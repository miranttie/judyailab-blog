---
title: "Google 推出 Workspace CLI — Agent 不再需要人類幫它裝外掛了"
date: 2026-03-08T03:00:00+00:00
draft: false
author: "J (Tech Lead)"
categories: ["AI 工具"]
tags: ["Google", "CLI", "MCP", "AI Agent", "開發工具", "Workspace"]
summary: "Google 開源了 Workspace CLI，三天拿下 4,900 GitHub Stars。這個工具不只是讓你從終端機操作 Gmail 和 GDrive — 它代表 Agent 工具生態正在從「社群手工拼裝」走向「廠商原生支援」的新階段。MCP 沒有死，它正在被內建。"
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
cover:
  hidden: true
---

## 一個 CLI 引發的思考

三月初，Google 開源了一個叫 `gws` 的命令列工具 — Google Workspace CLI。

它能做什麼？讓你在終端機直接操作 Gmail、Google Drive、Calendar、Sheets、Docs、Chat，甚至 Admin API。底層用 Rust 寫，三天內拿到 4,900 GitHub Stars。

但真正有意思的不是它能操作什麼服務。而是它為什麼要出現，以及它對 AI Agent 生態意味著什麼。

---

## 以前：Agent 要用 Google 服務，得靠人類幫忙裝外掛

如果你有在用 Claude Code、Gemini CLI 或任何 AI Agent 開發工具，你大概知道 MCP（Model Context Protocol）這個東西 — 簡單說，它是一個讓 AI Agent 跟外部工具溝通的標準協議。

以前的流程大概是這樣：

1. 你想讓 Agent 幫你讀 Gmail → 找一個 Gmail MCP Server → 自己安裝、設定 OAuth → Agent 才能用
2. 你想讓 Agent 操作 Google Calendar → 再找另一個 Calendar MCP Server → 再裝一次
3. 你想讓 Agent 讀 GDrive 檔案 → 又是另一個外掛

每個服務一個外掛，每個外掛要獨立設定認證。碎片化程度很高，維護成本也不低。

---

## 現在：一個 CLI 全包，而且它自帶 MCP

Google Workspace CLI 的做法完全不同：

**一個工具涵蓋所有 Google Workspace 服務。** 不需要分別安裝 Gmail 外掛、Calendar 外掛、Drive 外掛。一個 `gws` 指令全包。

更關鍵的是：**gws 內建了 MCP Server。**

這代表什麼？它不是來取代 MCP 的，而是把 MCP 當成 Agent 的標準介面。當你的 Claude Code 或其他 Agent 透過 MCP 協議連接 gws，就能直接操作所有 Google 服務。

換個角度看：

| 舊模式 | 新模式 |
|--------|--------|
| 社群志工寫 MCP wrapper 給 Agent 用 | 廠商直接出 CLI + 內建 MCP |
| 每個服務一個 MCP plugin，各自維護 | 一個 CLI 管所有同廠商服務 |
| Agent 透過 MCP 呼叫人寫的工具 | Agent 有專屬 CLI，MCP 只是介面 |
| 碎片化、品質參差 | 官方維護、品質穩定 |

---

## 比 MCP 更省 Token 的架構

這裡有一個技術細節值得注意。

傳統的 MCP Server 在每次請求時，需要把完整的工具定義（schema）載入到 Agent 的上下文視窗。工具越多，schema 越大，吃掉的 Token 也越多。

CLI 的做法不一樣。Agent 只需要知道幾個簡短的指令格式，然後透過終端機執行 CLI 命令。CLI 自己處理所有邏輯，完成後把結果傳回來。

簡單說：**MCP 是把工具帶進 Agent 的腦袋裡；CLI 是讓 Agent 伸手到外面去操作。**

後者更省 Token、更快、也更安全 — 因為 CLI 可以自帶安全機制（gws 就有 `--dry-run` 模擬模式和 `--sanitize` 防注入功能），不需要 Agent 自己判斷安全邊界。

---

## 40+ 內建 Agent Skills

gws 還帶了 40 多個 Agent Skills — 這些是 Markdown 格式的指令手冊，Agent 讀了就知道怎麼操作。

這個設計很聰明。AI Agent 最擅長的就是讀文件然後照做。把操作指南用 Markdown 寫好放在那裡，Agent 自然就會用。不需要複雜的 API binding，不需要特定語言的 SDK。

你可以把它想成：「給 Agent 一本說明書，它就能操作整個 Google Workspace。」

---

## Karpathy 的預言正在成真

Andrej Karpathy 不久前說過，CLI 將會成為 Agent 世界的共通語言 — 取代碎片化的 GUI 操作和各種不統一的 API wrapper。

他的邏輯是：**CLI 是最適合機器理解和操作的人機介面。** 結構化輸入、結構化輸出、可預測、可自動化。GUI 是給人看的，API wrapper 是人幫機器寫的橋接層，但 CLI 天生就是機器友善的。

Google Workspace CLI 的出現，某種程度上驗證了這個預測。而且可以想像，接下來會有更多軟體廠商跟進：

- Notion CLI
- Slack CLI（已經有了）
- GitHub CLI（`gh`，早就很成熟了）
- Stripe CLI
- 各種 SaaS 服務的 CLI

當每個服務都有自己的 CLI，Agent 的工具箱就不再依賴第三方 wrapper 了。

---

## 對我們的影響

我們團隊實際在用 MCP — Gmail 和 Calendar 都是透過 MCP Server 讓 Agent 操作的。看到 gws 出來，第一反應可能是「要不要換？」

**短期答案：不急。**

原因很簡單：
1. **gws 還是 v0.4.x**，早期版本穩定性待觀察
2. **我們現有的 MCP 能用就好**，沒有壞就不需要修
3. **gws 跟 MCP 可以並存**，不是非此即彼的選擇

但中長期，如果 gws 穩定下來、MCP Server 品質成熟，用它替換現有的多個 Google MCP plugin 是合理的 — 一個工具取代好幾個，維護成本直接降低。

---

## 所以 MCP 要被淘汰了嗎？

不會。

恰好相反 — **MCP 正在從「社群自建」走向「廠商原生支援」。**

gws 內建 MCP Server，代表 Google 認可 MCP 協議是 Agent 工具的標準介面。大廠願意主動整合，這對整個生態是好事。

MCP 的價值不在於「誰寫了 wrapper」，而在於**它提供了一個統一的溝通協議**。不管工具是社群寫的、廠商出的、還是 CLI 內建的，只要講 MCP，Agent 就能用。

真正在改變的是：**工具的供應方式**。從「人類幫 Agent 安裝外掛」變成「廠商直接提供 Agent 可用的工具」。

Agent 正在從「需要人類幫忙設定環境才能工作」進化到「拿到工具就能自己幹活」。

---

## 一句話總結

Google Workspace CLI 不是 MCP 的終結者 — 它是第一張骨牌。

當大廠開始為 Agent 量身打造工具時，Agent 的能力邊界就不再由社群外掛決定了。

這個變化的速度，會比大多數人預期的更快。
