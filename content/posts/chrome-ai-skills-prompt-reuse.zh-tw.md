---
title: Chrome AI Skills — 提示詞從「用完即丟」變成「隨時重用」
date: "2026-04-24T16:00:00+00:00"
draft: false
author: Judy
summary: Google Chrome 推出 AI Skills 功能，讓用戶可以儲存並重複使用 AI 提示詞。本文從 AI 開發者與生產力工具的角度，對比 Claude Code Skills、OKX Agent Skills，分析「AI Skills 標配化」對開發者日常工作流的實際影響。
description: Google Chrome AI Skills 功能讓你把常用 AI 提示詞存成「技能」，下次一鍵重用。這不只是個人化設定——結合 Claude Code Skills、OKX Agent Skills 等平台趨勢，AI Skills 正成為各大平台的標配介面。開發者該如何把握這個轉變？
categories:
  - "AI 工具"
  - "開發者工具"
tags:
  - "Chrome AI"
  - "AI Skills"
  - "提示詞管理"
  - "Claude Code"
  - "生產力工具"
  - "Google Chrome"
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "Chrome AI Skills 是什麼？"
    a: "Chrome AI Skills 是 Google Chrome 瀏覽器新增的功能，讓用戶可以儲存常用 AI 提示詞並命名為「技能」，之後在任何網頁的 AI 輸入框中一鍵叫出重用，不需要每次重新輸入。"
  - q: "Chrome AI Skills 和 Claude Code Skills 有什麼不同？"
    a: "Chrome AI Skills 是瀏覽器層級的提示詞管理，跨網站通用，針對一般用戶設計。Claude Code Skills 是開發者工具，允許定義可執行的工作流程和自動化任務，更接近編程技能而非提示詞模板。"
  - q: "AI Skills 功能現在可以用嗎？"
    a: "Chrome AI Skills 功能目前在 Chrome Canary 版本測試中，正式版推出時間視 Google 的 Stable 更新節奏而定。Claude Code Skills 和 OKX Agent Skills 均已正式上線可用。"
  - q: "開發者應該怎麼利用 AI Skills 類功能？"
    a: "建議從最常重複輸入的提示詞開始儲存，例如 Code Review 風格指令、文件格式模板、API 測試描述等。每個平台的 Skills 機制不同，優先掌握你最常用工具的實作方式。"
  - q: "AI Skills 會取代提示詞工程嗎？"
    a: "不會。AI Skills 解決的是「重用」問題，提示詞工程解決的是「品質」問題。Skills 讓你快速叫出已經設計好的高品質提示詞，兩者是互補關係。"
hidden: true
ShowToc: true
TocOpen: true
image: []
alt: Chrome AI Skills 提示詞重用功能介紹與開發者應用指南
series:
  - "AI 工具深度評測"
lastmod: 2026-05-13T04:29:42+00:00

---

> **TL;DR**：Chrome AI Skills 讓你把常用提示詞存成一鍵可叫出的「技能」，背後反映的趨勢是 AI Skills 正成為各大平台標配——Claude Code Skills、OKX Agent Skills 已上線，提示詞從用完即丟走向可積累的工作流資產。

## 一個讓你不再重複貼提示詞的功能

你有沒有這種經驗：每次用 AI 工具做 Code Review，都要把同一段「請用繁體中文、列出 CRITICAL/HIGH/MEDIUM 三級問題……」的指令重新貼一遍？

Google Chrome 新推出的 **AI Skills** 功能就是為了解決這件事。

簡單說：你可以把常用提示詞存成一個「技能」，給它取個名字，之後在任何有 AI 輸入框的網頁上，直接叫出這個技能——不用重打，不用剪貼。

這看起來是個小功能，但背後反映的趨勢值得認真看。

---

## Chrome AI Skills 怎麼運作？

根據 Google 的說明，Chrome AI Skills 的核心邏輯很直觀：

1. **建立技能**：在 Chrome 設定中新增提示詞，為它取個名稱（如「代碼審查」、「翻譯成英文」）
2. **呼叫技能**：在任何 AI 聊天介面（Gemini、ChatGPT、Claude 網頁版等）的輸入框，透過快捷方式叫出已儲存的技能清單
3. **一鍵插入**：選擇後，提示詞自動填入輸入框，按送出即可

這個架構的關鍵點在於「**跨網站通用**」——不管你在哪個 AI 平台，只要用的是 Chrome，技能庫就跟著你。

---

## 和其他平台的 Skills 功能對比

「Skills」這個詞在 AI 圈不算新鮮，但各家的定義差很多。

### Claude Code Skills：開發者的工作流腳本

Claude Code（Anthropic 的 CLI 工具）也有 Skills 機制，但性質完全不同。

Claude Code Skills 本質上是**可執行的工作流程定義**：

```markdown
# /commit skill

執行 git 提交流程：
1. 檢查 staged files
2. 根據 diff 自動生成 commit message
3. 確認後執行 commit
```

你可以用 `/commit`、`/review-pr`、`/deploy` 這樣的指令叫出技能，它會執行一整套動作，不只是插入文字。差別在於：**Chrome AI Skills 是提示詞模板，Claude Code Skills 是可執行程序**。

### OKX Agent Skills：交易 AI 的能力單元

OKX 的 Agent Skills 又是另一個維度。在加密交易的 Agent 框架下，Skills 代表 AI Agent 可以調用的**功能模組**：

- `market_analysis_skill`：分析當前市場狀況
- `risk_assessment_skill`：評估持倉風險
- `execute_trade_skill`：執行交易指令

這裡的「Skill」更接近軟體工程的模組概念——封裝好的功能單元，Agent 可以按需組合調用。

### 三種 Skills 的定位對比

| 功能 | Chrome AI Skills | Claude Code Skills | OKX Agent Skills |
|---|---|---|---|
| 目標用戶 | 一般用戶 | 開發者 | 交易 AI 開發者 |
| 執行層級 | 提示詞文字 | 工作流程 | AI Agent 能力模組 |
| 跨平台 | ✅ 跨網站 | ❌ CLI 限定 | ❌ OKX 生態限定 |
| 自動化程度 | 低（手動觸發） | 中（半自動流程） | 高（Agent 自主調用） |

---

## 為什麼這個趨勢值得關注？

三個不同的平台、三種不同的 Skills 實作，但背後是同一個問題：**AI 的使用成本太高了**。

不是錢的成本，是**認知成本**。

每次想用 AI，你都要：回想最佳提示詞格式→重新輸入→調整→再輸入。這個摩擦讓很多人「知道 AI 有用，但懶得每次都認真寫提示詞」。

Skills 系列功能的本質，都是在降低這個摩擦：

- **Chrome AI Skills**：降低一般用戶的重用門檻
- **Claude Code Skills**：讓開發者把最佳實踐編碼化、可重複執行
- **Agent Skills**：讓 AI 系統把能力模組化、可組合

從個人工具到 Agent 架構，都在往同一個方向走：**把「用 AI 的技能」本身變成可以儲存、分享、重用的資產**。

---

## 開發者現在能做什麼？

不需要等 Chrome AI Skills 正式上線，類似的工作流優化現在就可以做：

### 1. 建立你的提示詞庫

用任何文字工具（Notion、Obsidian、甚至備忘錄）整理常用提示詞，分類存好。Chrome AI Skills 上線後無縫遷移。

常見值得存的類型：
- Code Review 風格指令（語言/格式/輸出結構）
- 文件翻譯模板（繁/簡/英的語氣要求）
- Debug 問題描述框架（錯誤訊息 + 期望行為 + 已嘗試方案）
- API 文件生成格式

### 2. 用 Claude Code Skills 把流程自動化

如果你已經在用 Claude Code，`.claude/` 目錄下的 skill 定義是比提示詞模板更強的工具。把重複的工作流——commit、PR 審查、部署確認——寫成 skill，直接 `/指令` 叫出執行。

### 3. 觀察 AI Skills 標準化的走向

Chrome 的動作意味著「提示詞管理」正在從個人習慣變成平台功能。下一步可能是：跨裝置同步、Skills 分享市集、API 存取。

對開發者來說，現在是建立個人 Skills 資產的好時機——無論最終在哪個平台使用。

---

## 小結

Chrome AI Skills 本身是個務實的小功能，解決「每次重打提示詞」這個真實痛點。但放在更大的背景下看，它是 AI 工具標配化的一個信號：**AI 的介面層正在成熟**。

從提示詞模板（Chrome）→ 工作流程（Claude Code）→ Agent 能力模組（OKX），Skills 的概念正沿著抽象層次往上走。

開發者現在要做的，是在這個趨勢確立之前，把自己最有價值的 AI 使用模式沉澱下來——無論最後叫做 Skills、Templates、還是別的什麼名字。想看提示詞自動化在完整開發流程中的應用，[Claude Code Hooks 完全指南](/posts/claude-code-hooks-guide/)有更深入的實作範例；[AI 自我審查流水線：Agent如何在送PR前先審自己的程式碼](/posts/ai-self-review-pipeline-quality-gates/)展示了提示詞模組化如何融入 CI 流程；[AI Agent 開發環境建置指南](/posts/ai-agent-dev-environment/)則提供整體工具鏈的選型參考。

---

*本文基於公開資訊整理，Chrome AI Skills 功能規格以 Google 官方發布為準。*

<!-- product-cta -->
{{< product-cta product="commander" >}}

在 Judy AI Lab，我們也把這套「沉澱可重用提示詞」的思路落實到日常開發與內容流程裡，讓每一次與 AI 的對話都能累積成團隊資產。

## 參考來源

- [Chrome Skills 教學：Google瀏覽器一鍵AI工作流程完整攻略（2026） - 雲林房地產阿宥｜AI房仲顧問](https://xn--cesq7h2ygv1v901b.com/chrome-skills-tutorial-2026/)
- [Chrome內建Gemini Skills！輸入「/」叫出提示詞，跨分頁比價、掃文件一鍵搞定|數位時代 BusinessNext](https://www.bnext.com.tw/article/90647/google-chrome-gemini-skills-save-ai-prompts)
- [Chrome 也有 Skills 功能了！輕鬆一鍵重複使用你的 AI 工作流程 - 電腦王阿達](https://www.koc.com.tw/archives/639059)

## 關鍵數據

- 3 個層級 Code Review 分類（CRITICAL/HIGH/MEDIUM）
- 5000 users (Threads + Newsletter 訂閱合計)
- $0 廣告投放（純有機流量）
