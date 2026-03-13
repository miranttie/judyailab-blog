#!/usr/bin/env python3
"""
批量翻譯 Blog 文章到韓文
使用 MiniMax M2.5 API（Anthropic 相容格式），從 .en.md 翻譯為 .ko.md
"""
import os
import re
import sys
import time
import requests
from pathlib import Path

POSTS_DIR = Path(__file__).parent.parent / "content" / "posts"
API_URL = "https://api.minimax.io/anthropic/v1/messages"
MODEL = "MiniMax-M2.5"

# Load API key from .env
api_key = os.environ.get("MINIMAX_API_KEY", "")
if not api_key:
    for env_file in ["/home/ubuntu/.openclaw/.env"]:
        if os.path.exists(env_file):
            for line in open(env_file):
                if line.startswith("MINIMAX_API_KEY="):
                    api_key = line.split("=", 1)[1].strip()
                    break
        if api_key:
            break

SYSTEM_PROMPT = """You are a professional Korean translator specializing in crypto trading and AI technology content.

Rules:
1. Translate from English to natural Korean (한국어)
2. Keep all YAML frontmatter keys in English, only translate values
3. Keep all code blocks, URLs, and HTML tags unchanged
4. Use appropriate Korean crypto/tech terminology:
   - backtesting → 백테스팅
   - Walk-Forward Optimization → 워크포워드 최적화
   - Out-of-Sample → 아웃오브샘플 (OOS)
   - position sizing → 포지션 사이징
   - drawdown → 드로다운
   - Sharpe ratio → 샤프 비율
   - regime → 레짐
   - agent → 에이전트
   - quantitative trading → 퀀트 트레이딩
   - paper trading → 페이퍼 트레이딩
5. Maintain the same tone — technical but approachable, not overly formal
6. For the frontmatter 'tags' and 'categories', translate them to Korean equivalents
7. Keep author names as-is (Judy, J)
8. Do NOT add or remove content — faithful translation only
9. The 'summary' field in frontmatter should also be translated
10. Keep markdown formatting (headers, lists, bold, etc.) intact"""


def translate_post(en_path: Path) -> str | None:
    """Translate a single post from English to Korean."""
    if not en_path.exists():
        print(f"  ⏭️ 檔案不存在，跳過")
        return None

    content = en_path.read_text(encoding="utf-8")

    # Check if Korean version already exists
    ko_path = en_path.with_suffix("").with_suffix(".ko.md")
    if ko_path.exists():
        print(f"  ⏭️ 已存在：{ko_path.name}")
        return None

    prompt = f"""Translate this blog post from English to Korean. Return ONLY the translated markdown (including frontmatter). Do not add any explanation.

{content}"""

    try:
        resp = requests.post(
            API_URL,
            headers={
                "x-api-key": api_key,
                "Content-Type": "application/json",
                "anthropic-version": "2023-06-01",
            },
            json={
                "model": MODEL,
                "max_tokens": 8192,
                "system": SYSTEM_PROMPT,
                "messages": [{"role": "user", "content": prompt}],
            },
            timeout=120,
        )

        if resp.status_code != 200:
            print(f"  ❌ API 錯誤 {resp.status_code}: {resp.text[:200]}")
            return None

        data = resp.json()
        # Handle different MiniMax response formats
        content = data.get("content", [])
        if isinstance(content, list) and len(content) > 0:
            item = content[0]
            if isinstance(item, dict):
                translated = item.get("text", "")
            else:
                translated = str(item)
        elif isinstance(content, str):
            translated = content
        else:
            print(f"  ❌ 意外的回應格式: {str(data)[:200]}")
            return None
        if not translated:
            print(f"  ❌ 翻譯結果為空")
            return None
        usage = data.get("usage", {})
        in_tok = usage.get("input_tokens", "?")
        out_tok = usage.get("output_tokens", "?")

        # Remove any markdown code block wrapper the model might add
        if translated.startswith("```"):
            lines = translated.split("\n")
            # Remove first and last ``` lines
            if lines[0].startswith("```"):
                lines = lines[1:]
            if lines and lines[-1].strip() == "```":
                lines = lines[:-1]
            translated = "\n".join(lines)

        # Ensure it starts with ---
        if not translated.strip().startswith("---"):
            print(f"  ⚠️ 翻譯格式異常：{en_path.name}")
            return None

        ko_path.write_text(translated, encoding="utf-8")
        print(f"  ✅ {ko_path.name} ({in_tok}+{out_tok} tokens)")
        return str(ko_path)
    except Exception as e:
        print(f"  ❌ {en_path.name}: {e}")
        return None


def main():
    en_files = sorted(POSTS_DIR.glob("*.en.md"))
    print(f"找到 {len(en_files)} 篇英文文章待翻譯\n")

    success = 0
    skipped = 0
    failed = 0

    for i, en_path in enumerate(en_files, 1):
        slug = en_path.stem.replace(".en", "")
        print(f"[{i}/{len(en_files)}] {slug}")

        result = translate_post(en_path)
        if result is None:
            ko_path = en_path.with_suffix("").with_suffix(".ko.md")
            if ko_path.exists():
                skipped += 1
            else:
                failed += 1
        else:
            success += 1

        # Rate limit: small delay between calls
        if i < len(en_files):
            time.sleep(1)

    print(f"\n=== 翻譯完成 ===")
    print(f"✅ 成功: {success}")
    print(f"⏭️ 跳過: {skipped}")
    print(f"❌ 失敗: {failed}")


if __name__ == "__main__":
    main()
