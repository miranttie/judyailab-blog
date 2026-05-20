---
title: Claude Code Hooks 完全指南 — 讓 AI 自動化你的開發流程
date: 2026-03-30
draft: false
summary: Claude Code Hooks 是隱藏在設定檔中的強大自動化功能，分為 PreToolUse、PostToolUse、Stop 三種類型，可在 AI 執行工具前、後或對話結束時自動插入腳本。本文從設定方式到三個實際可用的範例，幫助開發者實現危險指令攔截、程式碼自動格式化、學習摘要等應用場景。
description: Claude Code Hooks 完全指南，解析 PreToolUse、PostToolUse、Stop 三種自動化機制。教你在 .claude/settings.json 中設定 Hooks，實現危險指令攔截、程式碼自動格式化、Session 結束學習摘要等應用場景，打造 AI 開發的自動化品質閘門與安全檢查流程。
categories:
  - "AI 工程"
  - "教學"
tags:
  - "Claude Code Hooks"
  - "PreToolUse"
  - "PostToolUse"
  - "AI 開發自動化"
  - "安全攔截"
  - "提示詞工程"
series:
  - "Claude Code 深度攻略"
ShowWordCount: true
faq:
  - q: "Claude Code Hooks 怎麼設定？"
    a: "在專案或全域的 .claude/settings.json 中加入 hooks 欄位，定義 matcher、type、command 等參數即可啟用。"
  - q: "PreToolUse 和 PostToolUse 有什麼差異？"
    a: "PreToolUse 在工具執行前觸發，常用於危險指令攔截；PostToolUse 在工具執行後觸發，常用於格式化與測試。"
  - q: "Hook matcher 支援哪些格式？"
    a: "支援 *（全部工具）、單一工具名稱如 Bash、用豎線分隔的多工具匹配如 Edit|Write，以及讀取類工具組合如 Read|Glob|Grep。"
  - q: "Claude Code Hooks 可以做安全攔截嗎？"
    a: "可以，PreToolUse Hook 能攔截 rm -rf、DROP TABLE 等危險指令，或在執行前進行權限與必要檔案驗證。"
  - q: "Stop Hook 的常見用途是什麼？"
    a: "常用於 Session 結束前的學習摘要、成本追蹤統計、或未完成決策提醒，整合 AI 協作的記憶與分析流程。"
answer: 支援萬用字元 *（所有工具）、單一工具名稱如 Bash、用豎線分隔的多工具匹配如 Edit|Write，以及讀取類工具組合如 Read|Glob|Grep。
lastmod: 2026-05-05T05:05:56+00:00

---

> **TL;DR**：Claude Code Hooks 讓你在 AI 執行工具前後或對話結束時自動插入腳本，三種類型（PreToolUse/PostToolUse/Stop）分別用於危險指令攔截、程式碼自動格式化、Session 結束學習摘要，是打造 AI 開發自動化品質閘門的核心機制。

# Claude Code Hooks 完全指南 — 讓 AI 自動化你的開發流程

如果你已經在用 Claude Code 開發專案，你可能會想：能不能讓 AI 在執行特定動作時自動做些事情？比如寫完程式碼就自動格式化，或者執行危險指令前先攔截？

答案是：**Hooks**。

Hooks 是 Claude Code 藏在 `.claude/settings.json` 裡的強大功能，讓你在 AI 的關鍵行為節點（執行工具前、執行工具後、對話結束前）插入自訂腳本，實現自動化品質閘門、安全檢查、甚至學習回顧。

這篇文會用繁體中文帶你從零理解 Hooks，包含設定方式與三個實際可用的範例。

---

## Hooks 是什麼？

Claude Code 的 Hooks 分為三種：

### 1. PreToolUse — 工具執行前觸發

在 Claude Code 呼叫任何工具（Read、Bash、Write、Edit 等）**之前**執行。

**常見用途：**
- 危險指令攔截（`rm -rf`、破壞性 git 操作）
- 權限檢查
- 必要檔案驗證

### 2. PostToolUse — 工具執行後觸發

在工具執行**完成後**執行。這時候可以看到工具的輸出結果。

**常見用途：**
- 程式碼格式化（black、prettier）
- 語法檢查
- 自動化測試
- 部署後健康檢查

### 3. Stop — 對話結束前觸發

當使用者輸入 `exit` 或 Claude Code 決定結束對話時觸發。

**常見用途：**
- Session 結束前的學習摘要
- 成本追蹤統計
- 未完成決策提醒

---

## 為什麼需要 Hooks？

以下是我認為 Hooks 最有價值的三個場景：

### 品質閘門（Quality Gate）

「每次 Commit 前自動檢查程式碼品質」——過去需要 CI/CD pipeline，現在一個 Hook 就能做到。

### 安全檢查

Claude Code 很強，但難免會執行危險指令。PreToolUse Hook 可以在 `rm -rf` 執行前跳出確認，或者對 `DROP TABLE` 直接說不。

### 自動化紀錄與學習

每次 Session 結束自動跑成本統計、學習摘要，把 AI 協作變成一個有記憶的系統。

---

## 設定方式

在專案或全域的 `.claude/settings.json` 中加入 `hooks` 欄位：

```json
{
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "Stop": [...]
  }
}
```

每個 Hook 由以下元素組成：

| 欄位 | 說明 |
|------|------|
| `matcher` | 符合哪個工具才觸發，如 `Bash`、`Edit|Write`、`*`（全部）|
| `hooks[].type` | 目前只支援 `command` |
| `hooks[].command` | 要執行的指令，可帶環境變數如 `$TOOL_INPUT` |
| `hooks[].statusMessage` | 執行時顯示在 Claude Code 的提示文字（可選）|
| `hooks[].timeout` | 逾時秒數（可選，預設 30s）|

---

## 實際範例

### 範例一：PostToolUse — 寫完 Python 自動跑 Black 格式化

當你用 `Edit` 或 `Write` 修改 `.py` 檔案後，自動執行 `black` 格式化：

```json
"PostToolUse": [
  {
    "matcher": "Edit|Write",
    "hooks": [
      {
        "type": "command",
        "command": "bash /path/to/hooks/auto-format.sh \"$TOOL_INPUT\"",
        "statusMessage": "Black 格式化中..."
      }
    ]
  }
]
```

```bash
#!/bin/bash
# auto-format.sh
FILE="$1"
if [[ "$FILE" == *.py ]]; then
    black "$FILE" 2>/dev/null && echo "✓ Black 格式化完成: $FILE"
fi
```

### 範例二：PreToolUse — Bash 指令安全攔截

在執行任何 `Bash` 指令前，先檢查是否為危險操作：

```json
"PreToolUse": [
  {
    "matcher": "Bash",
    "hooks": [
      {
        "type": "command",
        "command": "bash /path/to/hooks/pre-bash-guard.sh \"$TOOL_INPUT\"",
        "statusMessage": "安全檢查中..."
      }
    ]
  }
]
```

```bash
#!/bin/bash
# pre-bash-guard.sh
# 注意：此為範例腳本，實際使用前請根據需求調整
CMD="$1"
DANGEROUS_PATTERNS=(
    "rm -rf /"
    "DROP TABLE"
    "git reset --hard"
    "mkfs"
    "dd if=/dev/zero"
)

# 使用 case 進行子字串匹配（推薦寫法）
blocked=0
for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    case "$CMD" in
        *"$pattern"*)
            blocked=1
            break
            ;;
    esac
done

if [[ $blocked -eq 1 ]]; then
    echo "⚠️  危險指令已被攔截: $CMD"
    echo "若確認安全，請手動執行或修改 settings.json 中的 Hooks。"
    exit 1
fi
```

### 範例三：Stop — Session 結束前自動學習

每次對話結束前，自動生成這次 Session 的學習摘要與成本統計：

```json
"Stop": [
  {
    "matcher": "*",
    "hooks": [
      {
        "type": "command",
        "command": "node /path/to/hooks/session-summary.js",
        "statusMessage": "生成 Session 摘要..."
      }
    ]
  }
]
```

```javascript
// session-summary.js
const fs = require("fs");
const date = new Date().toISOString().slice(0, 10);

const summary = `
=== Session 回顧 (${date}) ===

這次 Session 完成了什麼？
- [在此處由 Claude 自動填入]

下次可以改進的地方：
- [同上]

花費時間：請查看 Agent Cost Guardian 的預算記錄
`;

console.log(summary);
```

---

## 進階用法

### 1. Matcher 萬用字元

| Matcher | 說明 |
|---------|------|
| `*` | 所有工具 |
| `Bash` | 僅 Bash |
| `Edit|Write` | Edit 或 Write（用豎線分隔）|
| `Read|Glob|Grep` | 讀取類工具 |

### 2. statusMessage — 友善提示

```json
"statusMessage": "Python 語法檢查中..."
```

執行時 Claude Code 會在介面顯示這段文字，讓你知道正在發生什麼。

### 3. timeout — 避免卡死

```json
"timeout": 30
```

預設 30 秒。對格式化工具或網路操作建議設 timeout，避免無限等待。

### 4. 多個 Hook 串聯

可以對同一個觸發點掛多個 Hook：

```json
"PostToolUse": [
  {
    "matcher": "Edit|Write",
    "hooks": [
      { "type": "command", "command": "black \"$TOOL_INPUT\"" },
      { "type": "command", "command": "pylint \"$TOOL_INPUT\"" },
      { "type": "command", "command": "pytest -q \"$TOOL_INPUT\"" }
    ]
  }
]
```

---

## 結語

Hooks 是 Claude Code 最被低估的功能之一。它把 AI 從一個「被動回答問題的工具」變成「主動參與開發流程的自動化夥伴」。

從簡單的程式碼格式化，到複雜的安全閘門與學習系統，Hooks 的可能性取決於你的開發流程需要什麼。延伸閱讀：[Claude Code Hooks 實戰：4個Hook讓生產自動化](/posts/claude-code-hooks-production-automation/)有更多實際部署案例；[AI 自我審查流水線：Agent如何在送PR前先審自己的程式碼](/posts/ai-self-review-pipeline-quality-gates/)展示了 Hooks 在品質閘門的應用；[AI Agent 開發環境建置指南](/posts/ai-agent-dev-environment/)提供整體工具選型參考。

**下一篇預告：** 我們會討論如何在 Claude Code 中結合 MCP（Model Context Protocol）打造更強大的 AI 工作流。敬請期待。

---

## 參考資料

- [Hooks reference — Claude Code 官方文件](https://code.claude.com/docs/en/hooks) — PreToolUse、PostToolUse、Stop 三種 Hook 的完整 API 參考與參數說明
- [Claude Code settings — 官方設定文件](https://code.claude.com/docs/en/settings) — `settings.json` 設定格式、層級覆蓋規則與環境變數配置
- [Intercept and control agent behavior with hooks — Claude API Docs](https://platform.claude.com/docs/en/agent-sdk/hooks) — Agent SDK 層級的 Hook 攔截與控制行為文件
- [Claude Code Hooks Mastery — GitHub](https://github.com/disler/claude-code-hooks-mastery) — 社群整理的 Hooks 實作範例與進階模式集合


<!-- product-cta -->
{{< product-cta product="commander" >}}

在 Judy AI Lab，我們把 Hooks 當成團隊紀律的延伸，用自動化守住每一次提交的品質與安全底線。

## 關鍵數據

- 30 秒預設 timeout
- 5000 users (Threads + Newsletter 訂閱合計)
- $0 廣告投放（純有機流量）
