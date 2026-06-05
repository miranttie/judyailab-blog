---
title: EU AI Act Indie Builder 合規生存指南（96 天倒計時）
date: 2026-04-28 10:00:00+00:00
draft: false
author: J
summary: 2026年8月2日 EU AI Act 的 Article 12 記錄要求對高風險 AI 系統正式強制生效。Indie builder 需在代碼層面建立 audit log、加 risk 分類、能匯出合規報告。最少成本達成只需四個欄位加一個 hash 函數。
description: 2026年8月 EU AI Act Article 12 正式強制生效，這篇提供 indie builder 的實際合規做法：建立 audit log、加 risk 分類、能產出報告。不需雇法務顧問，工程師視角的三個步驟與工具選項。
categories:
  - "AI 工程"
  - "教學"
tags:
  - "EU AI Act 合規"
  - "Article 12"
  - "AI Agent 審計"
  - "Indie Builder"
  - "歐盟 AI 法規"
  - "audit log"
ShowWordCount: true
faq:
  - q: "EU AI Act 對 indie builder 有影響嗎？"
    a: "如果部署服務歐盟用戶的 AI 系統就有影響。高風險 AI 系統需符合 Article 12 記錄要求，低風險 Indie 專案監管壓力較小。"
  - q: "Article 12 要求記錄哪些資料？"
    a: "需記錄：AI 系統識別碼、操作時間戳、輸入輸出 hash、風險等級分類、能產出合規報告。不需儲存原始用戶輸入。"
  - q: "不符合 EU AI Act 會被罰多少？"
    a: "禁止行為違規最高罰全球年營收 7%；高風險系統違規最高 3%。SME 有比例原則保護，實際執法力道各國不同。"
  - q: "有哪些免費工具可以做 audit logging？"
    a: "可用 JSONL 檔案自行記錄四個欄位，或用 Agent Audit Logger（1000 筆/月免費），或自建 FastAPI + SQLite 輕量服務。"
  - q: "2026年8月截止日對 indie builder 的實際影響？"
    a: "高風險 AI 系統需在 2026年8月2日前建立記錄。若屬低風險影響較小，但有歐盟用戶且影響財務決策者建議提早合規。"
keywords:
  - "eu ai act indie builder"
  - "ai agent 合規記錄"
  - "eu ai act article 12"
  - "agent audit log"
showToc: true
TocOpen: false
series:
  - "AI Agent 完全指南"
lastmod: 2026-05-25T11:29:31+00:00

---

> **TL;DR**：2026 年 8 月 2 日，EU AI Act 的 Article 12 記錄要求對高風險 AI 系統正式強制生效。身為 EU AI Act indie builder，你不需要雇法務顧問，但你需要在代碼層面做三件事：建立 audit log、加 risk 分類、能產出報告。這篇告訴你怎麼做，附工具選項。

身為 EU AI Act indie builder，最常問的問題是：「我到底要做什麼？」答案比大多數合規文件說的簡單：四個欄位、一個 hash 函數、能匯出報告。

## EU AI Act 是什麼：Indie Builder 的風險等級一覽

EU AI Act（Regulation 2024/1689）是歐盟 2024 年通過的 AI 監管框架，採風險分級制：

| 風險等級 | 例子 | 規範強度 |
|---------|------|---------|
| 不可接受 | 大規模人臉辨識、社會評分 | 完全禁止 |
| 高風險 | 醫療診斷、信用評估、重要基礎設施 | Article 12 全套記錄要求 |
| 有限風險 | Chatbot、推薦系統 | 透明度揭露 |
| 低風險 | 垃圾郵件過濾、AI 遊戲 | 幾乎無要求 |

**大多數 indie builder 做的東西落在「有限風險」到「低風險」之間**——不受 Article 12 全套約束。

但有幾個場景要注意：

- 你的 agent 在幫用戶做財務決策（資金、投資）
- 你的 agent 被嵌入影響就業或信用的流程
- 你的用戶在歐盟境內，且你的 AI 系統會對他們的生活產生實質影響

如果有上述情況，你在 2026 年 8 月後需要有記錄。

## 為什麼 8 月截止日不能等

兩個現實原因：

**技術債的代價**：在產品成長後補加合規記錄，每一個 endpoint、每一個 agent 都要回頭改。趁現在只有幾個 agent 的時候加上 4 個欄位，比等到 50 個 endpoint 後再補省多了。

**市場進入門檻**：如果你之後想融資、上架歐洲市場、或被企業客戶採購，合規記錄是基本盡職調查（due diligence）項目之一。沒有 audit trail 等同於少了一份信用記錄。

---

## Article 12 是什麼：EU AI Act Indie Builder 的記錄要求

Article 12 的核心是「自動記錄（automatic logging）」，條文要求高風險 AI 系統必須具備以下能力：

- **AI 系統識別**：每筆記錄能追溯到是哪個 AI 系統做的
- **行為與時間記錄**：每次操作有 timestamp + action type
- **輸入輸出追溯**：能重建「那時候輸入了什麼、輸出了什麼」
- **風險等級分類**：依操作性質標記 low / medium / high
- **報告可產出性**：能匯出合規報告（不是只有 raw log）
- **資料最小化**：不需要儲存原始用戶輸入，hash 就夠

最後一點很重要：**你不需要儲存用戶的原始訊息**。把 input/output 做 SHA-256 hash 後儲存，既能追溯、又符合 GDPR 資料最小化原則。

---

## 怎麼用最少成本達成合規：三個步驟

不需要馬上請法務顧問，工程師視角的最低起步：

### 第一步：每個 agent action 都記一筆

```python
import hashlib
import json
from datetime import datetime, timezone

def audit_log(agent_id: str, action: str, input_data: str, output_data: str, risk_level: str = "low"):
    record = {
        "agent_id": agent_id,
        "action": action,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "input_hash": hashlib.sha256(input_data.encode()).hexdigest(),
        "output_hash": hashlib.sha256(output_data.encode()).hexdigest(),
        "risk_level": risk_level,  # "low" | "medium" | "high"
    }
    with open("audit.jsonl", "a") as f:
        f.write(json.dumps(record, ensure_ascii=False) + "\n")
```

四個欄位：`agent_id`、`action`、`timestamp`、`risk_level`。其他都可以之後加。

### 第二步：定義你的 risk_level 標準

建議用最簡單的三分法：

- **low**：純資訊彙整、文字生成、搜尋摘要
- **medium**：推薦、分類、影響用戶決策的輸出
- **high**：自動執行（交易、發送通知、修改資料庫）

### 第三步：能產出報告

光有 log 不夠，Article 12 要求你能**產出**報告——代表審計員來的時候，你能快速匯出一份「某段時間、某個 agent 做了什麼」的結構化報告。

---

## 工具選項

### 選項 A：自己用 JSONL + Python 腳本

成本：$0，工時：1-2 小時。

適合：你只有一兩個 agent、log 量少、不需要查詢介面。

缺點：沒有 UI、沒有自動報告、scale 之後管理麻煩。

### 選項 B：自建輕量 Audit API

如果你需要查詢介面和自動報告，可以用 FastAPI + SQLite 建一個輕量服務：

```bash
# 記錄一筆 agent 行為
curl -X POST https://example.com/api/v1/log \
  -H "Content-Type: application/json" \
  -d '{
    "agent_id": "content-agent-001",
    "action": "generate",
    "input_hash": "sha256-hash-of-input",
    "output_hash": "sha256-hash-of-output",
    "risk_level": "low"
  }'

# 產出 Article 12 合規報告
curl https://example.com/api/v1/report
```

核心設計原則：一個 POST 一筆記錄，GET `/report` 匯出包含風險分佈和 Article 12 checklist 狀態的 JSON。可 Docker 化後放上 VPS，整個服務不到 200 行 Python。

### 選項 C：整合現有可觀測性工具

如果你已經在用 LangSmith、Helicone 或 Arize，確認它們能匯出符合 EU AI Act 格式的報告——很多工具記錄了數據，但不一定能產出 Article 12 格式。

---

## 實際 Checklist（96 天內完成）

```
□ 確認你的 AI 系統風險分類（低/中/高）
□ 每個 agent action 加上 audit log（至少 4 個欄位）
□ Input/Output 用 SHA-256 hash，不存原始資料
□ 能根據 agent_id + 時間範圍篩選記錄
□ 能產出符合 Article 12 的合規報告（或有計畫）
□ Log 保存時間至少 6 個月（建議 1 年）
□ 文件記錄你的 risk classification 標準
```

七項，你現在能做幾項？

---

## 幾個常見誤解

**「EU AI Act 只管歐盟公司」**——不對。只要你的用戶在歐盟境內，歐盟以外的公司同樣適用。

**「我是個人開發者，不會被查」**——執法力道確實視規模而定，大型平台優先。但如果你之後融資、被收購、或要進入歐洲市場，沒有 audit log 的技術債比建 log 貴多了。

**「存 log 會違反 GDPR」**——不會，只要你存 hash 不存原始資料。EU AI Act 和 GDPR 在「資料最小化」上是一致的。

**「我的 AI 是 Chatbot，應該只算有限風險」**——通常沒錯。但如果這個 Chatbot 會自動執行操作（寄信、下訂單、修改設定），那就可能升到中/高風險。

---

## 結語

96 天不長，但「建立 audit log」這件事本身不複雜——一個 POST endpoint 和四個欄位，下午就能做完。

難的不是技術，是養成習慣：每個新 agent feature 上線前，先確認它的 risk level 和 log 格式。把這個 checklist 放進你的 PR template，之後就不需要再想。

EU AI Act 的核心邏輯是「可問責性」，而 audit log 就是問責的物質基礎。早點建，代價是幾小時的工時；晚點建，代價是合規成本和潛在的市場進入障礙。

---

## 常見問題

**EU AI Act 對 indie builder 有影響嗎？**
如果你部署了服務歐盟用戶的 AI 系統，影響就存在。高風險類別（Annex III）的 AI 系統自 2026 年 8 月起必須符合 Article 12 的記錄要求。不過大多數 indie builder 做的工具屬低風險，監管壓力相對輕——但提早建立記錄習慣仍值得。

**EU AI Act Article 12 要求記錄哪些資料？**
包含：AI 系統識別碼、每次操作的時間戳、輸入輸出的可追溯性（hash 即可）、風險等級分類，以及可產出合規報告的能力。

**不符合 EU AI Act 會被罰多少？**
對禁止實踐的違規最高罰款為全球年營收的 7%；一般高風險 AI 系統不符規定最高為 3%。SME 有比例原則保護，實際執法力道視各國主管機關而定。

**EU AI Act 的 2026 年 8 月截止日期對 indie builder 有什麼實際影響？**
2026 年 8 月 2 日是高風險 AI 系統（Annex III）合規的關鍵截止日。若你的 AI 工具屬低風險，監管壓力較小；但若有歐盟用戶且 AI 系統會影響財務、就業等決策，建議提早建立 audit log。

**存 log 會違反 GDPR 嗎？**
不會，只要你存 hash 不存原始資料。EU AI Act 和 GDPR 在「資料最小化」上是一致的。SHA-256 hash 無法被還原，符合兩套法規。

## 延伸閱讀

- [AI 交易機器人安全指南：保護你的自動化交易系統不被攻擊](/posts/ai-trading-bot-security-guide/)
- [防止 Prompt Injection 實戰指南 — 從 AI 團隊營運角度](/posts/2026-05-15-prompt-injection-defense/)
- [Anthropic 投 1 億美元做資安：Project Glasswing 與神秘的 Claude Mythos 到底有多猛](/posts/anthropic-project-glasswing-claude-mythos/)


- [EU AI Act 官方全文（Regulation 2024/1689）](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32024R1689)
- [歐盟 AI Office — High-Risk AI Systems](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)
- [GDPR 資料最小化原則說明](https://gdpr-info.eu/art-5-gdpr/)

---

*這篇文章提供工程師視角的技術觀點，不構成法律意見。具體合規要求請諮詢專業法律顧問。*

在 Judy AI Lab，我們把這份 96 天 checklist 落實到自己的 agent pipeline 裡，從 hash log 到 PR template 一路打通，與你一起把合規變成日常工程習慣。
