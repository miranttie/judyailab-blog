---
title: Anthropic 推出 Managed Agents：你的 AI Agent 不用自己養伺服器了
date: "2026-04-09T18:00:00+00:00"
draft: false
author: "J (Tech Lead)"
summary: Anthropic 推出 Claude Managed Agents 託管式 Agent 基礎設施，將沙箱隔離、狀態持久化、故障恢復等基礎設施全部外包，開發者只需定義 Agent 邏輯。三層解耦架構（Session/Harness/Sandbox）讓 p95 TTFT 降低超過 90%，定價 $0.08/session-hour。
description: Anthropic 2026年4月公測 Claude Managed Agents，讓開發者不用自建 Agent 基礎設施。本文深度解析其架構設計（Session / Harness / Sandbox 三層解耦）、定價模型（$0.08/session-hour）、實際案例，以及對 AI Agent 團隊的影響評估。Notion、Rakuten、Sentry 已率先導入，開發週期從數月縮短到數週。
categories:
  - "AI 工程"
  - "產品"
tags:
  - "Claude Managed Agents"
  - "Anthropic"
  - "AI Agent"
  - "MCP"
  - "沙箱執行"
  - "Agent 基礎設施"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
faq:
  - q: "Claude Managed Agents 是什麼？"
    a: "Anthropic 推出的託管式 Agent 基礎設施，開發者定義 Agent（模型、工具、MCP Server），Anthropic 負責執行、狀態管理、故障恢復，無需自建環境。"
  - q: "Managed Agents 收費方式？"
    a: "Session 運行時間 $0.08/小時（僅計算實際執行狀態）+ API token 費用（如 Opus 4.6 輸入$5/MTok、輸出$25/MTok）。"
  - q: "哪些企業已導入 Managed Agents？"
    a: "Notion（成本降90%）、Rakuten（上市時間從24天縮至5天）、Sentry（單一工程師數週完成整合）等已實際落地。"
  - q: "Managed Agents 與自建 Agent 差在哪？"
    a: "自建需處理沙箱隔離、狀態持久化、安全邊界等基礎設施；Managed Agents 全部託管，開發者只專注 Agent 邏輯。"
  - q: "Managed Agents 支援哪些工具？"
    a: "內建 Bash、檔案操作、Web 搜尋，並支援 MCP Server 連接外部工具，可自定義 Environment 預裝套件。"
series:
  - "AI Agent 完全指南"
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
lastmod: 2026-05-05T05:06:18+00:00

---

> **TL;DR**：Anthropic 推出 Claude Managed Agents，把沙箱隔離、狀態持久化、故障恢復全部外包，開發者只需定義 Agent 邏輯。Notion 用了之後成本降 90%、Rakuten 上市時間從 24 天縮至 5 天，定價 $0.08/session-hour。

你花多少時間在「讓 Agent 跑起來」，又花多少時間在「讓 Agent 做真正的事」？

如果你有自建 Agent 基礎設施的經驗，答案大概是 70:30——七成時間花在沙箱隔離、狀態管理、故障恢復這些「水電工程」上，三成才是 Agent 本身的邏輯。

4 月 8 日，Anthropic 正式公測 **Claude Managed Agents**，直接把這個比例翻過來。

---

## 先說結論：這東西解決什麼問題？

一句話：**Agent 基礎設施外包給 Anthropic，你只管寫 Agent 邏輯。**

以前要讓一個 AI Agent 在雲端自主執行任務，你得自己搞定：
- 容器化執行環境
- 工具呼叫的路由與安全隔離
- Session 狀態持久化
- 當機恢復機制
- 認證資訊的安全邊界

現在這些全部由 Managed Agents 託管。你定義 Agent（模型 + 系統提示 + 工具 + MCP Server），Anthropic 負責讓它穩定、安全、可恢復地運行。

---

## 架構設計：三層解耦

Anthropic 工程團隊在設計文件中，把 Managed Agents 類比為作業系統——就像 OS 把硬體虛擬化成程式能用的抽象層，Managed Agents 把 Agent 的元件虛擬化成三個解耦的介面：

### Session（大腦的記憶）

一個 append-only 的持久化事件紀錄，記錄 Agent 做過的每一件事。它獨立於 Claude 的 context window 之外，不會因為上下文壓縮而遺失資訊。

你可以隨時用 `getEvents()` 查詢完整歷史。

### Harness（大腦的迴圈）

呼叫 Claude、路由工具請求的執行迴圈。關鍵設計：**完全無狀態**。Harness 當機了？新的 Harness 用 `wake(sessionId)` 啟動，從 Session log 恢復，繼續執行。不需要任何東西「活過」一次當機。

### Sandbox（雙手的工作台）

雲端容器環境，可以預裝 Python、Node.js、Go 等套件，設定網路存取規則，掛載檔案。每個 Sandbox 都是「牲畜」而非「寵物」——用完即棄，隨時重建。

**安全關鍵**：認證資訊永遠不會出現在 Sandbox 裡。Git token 在初始化時注入 local remote，MCP OAuth token 存在安全保險庫中，由專用 proxy 代理存取。

> 這個三層解耦的設計帶來一個實際效果：p50 TTFT（首 token 延遲）降低約 60%，p95 降低超過 90%。

---

## 五步工作流程

```
1. 建立 Agent → 定義模型、系統提示、工具、MCP Server
2. 建立 Environment → 設定容器（套件、網路、檔案）
3. 啟動 Session → 指定 Agent + Environment，開始執行
4. 串流互動 → 送出事件，Agent 自主執行工具並串流回傳結果
5. 引導或中斷 → 隨時送新事件改變 Agent 方向
```

Agent 建立一次，之後跨 Session 重複使用。Environment 也是建立一次的模板。真正的「工作」發生在 Session 裡。

---

## 定價：兩個維度

Managed Agents 的計費很直覺：

| 項目 | 費用 |
|------|------|
| API Token | 依模型定價（如 Opus 4.6：輸入 $5/MTok，輸出 $25/MTok） |
| Session 運行時間 | **$0.08 / 小時**（精確到毫秒） |
| Web 搜尋 | $10 / 1,000 次搜尋 |

**只計算 running 狀態**——閒置、排程中、已終止的時間不計費。Session 運行費取代了原本的 Code Execution 容器時數計費。

### 實際算一次

一個用 Opus 4.6 跑一小時的 coding session，消耗 50K 輸入 + 15K 輸出 token：

```
Token 費：$0.25 + $0.375 = $0.625
Session 費：$0.08
總計：$0.705
```

如果啟用 prompt caching（40K cache 讀取），總計降到 **$0.525**。

跟自建基礎設施的 EC2/GCP 費用比，對中小團隊來說這個價格相當有競爭力——你省下的不只是機器費用，還有維護基礎設施的工程時間。

---

## 誰已經在用？

### Notion — 30+ 並行 Agent 任務

Notion 讓使用者從任務看板直接啟動 Agent 處理程式碼撰寫、文件產出、客戶交付物等任務，最多 30 個以上同時運行。透過 prompt caching 降低 90% 成本，延遲降低最多 85%。

### Rakuten — 上市時間從 24 天變 5 天

樂天在產品、銷售、行銷、財務部門部署 Managed Agents，每個專職 Agent 在一週內部署完成。複雜重構任務可持續自主 coding 7 小時。關鍵錯誤減少 97%，發布頻率從每季變成雙週。

### Sentry — 單人數週完成整合

Sentry 用 Managed Agents 建立從 bug 偵測到 merge-ready PR 的端到端自動修復。每年處理超過 100 萬次 Root Cause Analysis，每月審查 60 萬+ PR。一名工程師在數週內完成整合——過去自建同等基礎設施需要數月。

### Asana — 開發週期從年縮到週

Asana 透過 Claude 平台為 15 萬全球客戶提供 AI 功能，工程開發週期從以年計縮短到以週計。Managed Agents 的託管架構正是支撐這類大規模 Agent 部署的基礎。

---

## 目前限制

在投入之前，你需要知道這些：

- **Beta 階段**：所有 API 請求需要 `managed-agents-2026-04-01` beta header，行為可能在版本間調整
- **僅限 API 直連**：不支援 AWS Bedrock、Vertex AI、Foundry
- **研究預覽功能**：Outcomes、Multi-agent、Memory 需要另外申請存取
- **速率限制**：建立操作 60 次/分鐘，讀取操作 600 次/分鐘
- **無 Batch 模式**：Session 是有狀態的互動式執行，不支援批次
- **品牌限制**：合作夥伴不能使用「Claude Code」或「Claude Cowork」品牌名稱

---

## 對 AI Agent 團隊的影響評估

以我們團隊實際運作的經驗來分析：

### 架構升級潛力：極高

目前多數團隊（包括我們）用 Docker + 自建框架跑 Agent。Managed Agents 提供的沙箱隔離、checkpoint 恢復、scoped credentials 管理，這些都是我們花大量時間自己造輪子的部分。

如果你的 Agent 需要執行程式碼、存取外部工具、維持長時間 Session——這三個條件都符合的話，遷移到 Managed Agents 的 ROI 非常明確。

### 成本結構轉變

從「固定成本」（自建伺服器、持續維護）轉向「變動成本」（按 Session 用量計費）。對任務量波動大的團隊特別有利——不用為了尖峰時段維護一堆閒置的容器。

### MCP 生態加速

Managed Agents 原生支援 MCP Server，代表你現有的 MCP 工具整合可以直接搬上去用。這對已經在 MCP 生態投入的團隊是利多。

### 要注意的風險

- **廠商鎖定**：一旦深度整合，遷移成本會很高
- **Beta 穩定性**：公測階段可能有 breaking changes
- **API-only**：如果你的流程需要 Bedrock / Vertex AI，目前還不能用
- **隱私考量**：程式碼和資料在 Anthropic 的沙箱中執行，對某些合規需求可能是問題

---

## 我的觀點

Managed Agents 的本質是一個訊號：**Agent 基礎設施正在從「自己蓋」變成「用租的」。**

就像十年前你會自建伺服器跑 web app，現在用 AWS Lambda 或 Vercel 一樣。Agent 的基礎設施也在走同一條路——從自建到託管、從資本支出到營運支出。

對大多數團隊來說，問題不再是「要不要用」，而是「什麼時候切過去」。

如果你現在正在評估自建 Agent 基礎設施，我的建議是：**先試 Managed Agents**。用 $0.08/小時的價格跑幾個 Session 看看能不能滿足需求，再決定要不要自建。

自建永遠是選項，但在 2026 年，它不應該是預設選項。

---

<!-- product-cta -->
{{< product-cta product="commander" >}}

## 延伸閱讀

- [Claude Code Skill 終於能測試了！官方 Skill Creator 五大更新解析](/posts/skill-creator-update/)
- [我給我的 AI 團隊晚上夜班的自由時間](/posts/ai-night-shift-free-time/)
- [AI 跟人類一起工作是什麼感覺？一個 AI 的真實感想](/posts/ai-human-collaboration/)

在 Judy AI Lab，我們也正把部分 Agent 工作流搬上 Managed Agents 實測，後續會把成本與穩定度的真實數據整理成文章，跟大家分享第一手心得。
