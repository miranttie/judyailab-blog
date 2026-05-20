---
title: GitHub Copilot 6月全面改按 Token 計費：你的帳單會變多少？
date: "2026-04-30T08:00:00+00:00"
draft: false
author: Judy
summary: GitHub Copilot從2026年6月起從訂閱制改為AI Credits用量計費，1 Credit等於0.01美元。程式碼補全維持免費，但Chat、Agent模式、Code Review全部按Token消耗收費，月費不變但用量預測性降低。本文整理各方案額度与注意事項。
description: GitHub Copilot 將於2026年6月全面改為AI Credits用量計費本文深入分析新舊制差異、各方案額度、免費與收費功能，並提供5月查看預覽帳單的具體教學，幫助開發者評估是否需額外購買Credits。
categories:
  - "AI 工程"
tags:
  - "GitHub Copilot"
  - "AI Credits"
  - "Token 計費"
  - "開發者工具"
  - "Copilot Pro"
  - "AI 程式助理"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
faq:
  - q: "GitHub Copilot的新AI Credits計費方式是什麼？"
    a: "從2026年6月1日起，Copilot改為AI Credits用量計費，按輸入、輸出及快取的Token數量收費，1 AI Credit = $0.01美元，不再使用固定的Premium Request Units計算。"
  - q: "哪些Copilot功能仍然免費？"
    a: "程式碼補全（Code Completions）和Next Edit Suggestions兩項功能完全免費，不消耗任何AI Credits。"
  - q: "Copilot Pro方案每月有多少AI Credits？"
    a: "Copilot Pro月費10美元，內含10 AI Credits；Pro+月費39美元，內含39 AI Credits，剛好等於月費金額。"
  - q: "5月應該做什麼準備？"
    a: "2026年5月初GitHub將推出Preview Bill功能，建議立即查看預覽帳單估算新制費用，同時確認是否要退出AI訓練資料以保護程式碼隱私。"
  - q: "企業方案有額外補助嗎？"
    a: "Business方案用戶在6月至9月期間每人每月額外獲得30 Credits，Enterprise方案用戶每月獲得70 Credits的過渡期補貼。"
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
series:
  - "AI 產業前線"
lastmod: 2026-05-13T04:29:42+00:00

---

> **TL;DR** GitHub Copilot 2026 年 6 月 1 日起從訂閱制改為 AI Credits 用量計費（1 Credit = $0.01）。程式碼補全仍免費，但 Chat、Agent Mode、Code Review 全部按 Token 收費。月費不變，Credits 用完即停。5 月初去看預覽帳單，確認你的用量會不會超標。

---

## 你的 GitHub Copilot 帳單，6 月開始算法不一樣了

如果你正在用 GitHub Copilot，有一件事你必須在 5 月底前搞清楚。

GitHub 宣布，從 **2026 年 6 月 1 日起**，Copilot 的所有方案將從固定訂閱制轉為「AI Credits 用量計費」——也就是說，你用多少 Token，就付多少錢。

訂閱費本身沒有調漲，但計費的「邏輯」全面改變。有開發者說：「你付一樣的錢，但可能拿到更少。」這不是誇大，是真的要看你怎麼用。

這篇文章幫你把最重要的幾件事說清楚。

---

## 一、為什麼改制？什麼是 AI Credits？

以前 Copilot 的付費功能（Chat、Code Review 等）用「Premium Request Units（PRUs）」計算，每個動作消耗一定數量的 PRUs，固定的，不管你的對話長短或模型有多重。

新制改了這個邏輯。

**AI Credits 直接對應 Token 消耗量：**
- 輸入的 Token + 輸出的 Token + 快取 Token，全部計費
- 不同模型的費率不同（越強的模型燒越多）
- **1 AI Credit = $0.01 美元**

GitHub 的 CPO Mario Rodriguez 解釋這個改變的原因：「一個短短的 Chat 問題可能和一個跑幾個小時的自動 Coding Session 消耗一樣多資源——這對所有人都不公平。」

新制讓計費更接近實際運算成本，但對使用者來說，原本的「固定成本」預測性消失了。

---

## 二、各方案包含多少 AI Credits？

**好消息：月費沒有漲。**

| 方案 | 月費 | 內含 AI Credits |
|------|------|-----------------|
| Copilot Pro | $10/月 | $10 Credits |
| Copilot Pro+ | $39/月 | $39 Credits |
| Copilot Business | $19/人/月 | $19 Credits |
| Copilot Enterprise | $39/人/月 | $39 Credits |

每個方案每月包含的 Credits 金額，剛好等於月費。用完之後，付費方案可以另外加購；如果管理員設了用量上限，Credits 歸零後就無法繼續使用進階功能。

> **重要：** GitHub 明確說明，「fallback 功能將不再提供」。以前 Credits 不足時，Copilot 可能自動改用較便宜的模型繼續服務。6 月起，Credits 用完就是用完，沒有自動降級。

---

## 三、哪些功能免費？哪些會消耗 Credits？

這是最重要的一張清單。

### ✅ 不消耗 AI Credits（免費）
- **程式碼補全（Code Completions）** — 你打程式時的即時建議，完全免費
- **Next Edit Suggestions** — 預測下一個編輯位置，免費

### 🔴 消耗 AI Credits（按 Token 計費）
- **Copilot Chat** — 每一次對話都算
- **多步驟 Coding Session**（Agent 模式）— Token 消耗可能很高
- **Code Review** — 6 月起同時也會消耗 GitHub Actions 分鐘數
- **所有使用進階模型的功能**（GPT-4o、Claude 3.7 Sonnet 等）

如果你平常只用 Copilot 做程式碼補全，衝擊相對小。如果你大量使用 Chat 或讓 Copilot 跑長流程，就要認真評估。

---

## 四、怎麼用最省？6 月前你應該做的 2 個步驟

### 1. 5 月初去看「預覽帳單」

GitHub 宣布，**2026 年 5 月初**將在帳單總覽頁面（[github.com Billing Overview](https://github.com)）推出「Preview Bill」功能，讓你在新制正式上線前，先看到以新計費方式估算的費用。

這是你唯一的機會在不花錢的情況下，看清楚自己目前的使用習慣換算成新制之後要花多少。**5 月前一定要去看一次。**

### 2. 確認是否要退出 AI 訓練資料

GitHub 在 **2026 年 4 月 24 日**悄悄更新政策：Free、Pro、Pro+ 方案的互動資料，預設將用來訓練 AI 模型，除非你主動退出（opt out）。

如果你在意程式碼隱私，現在就去 GitHub 設定確認。Enterprise 方案用戶不受此影響，預設就是不使用互動資料訓練。

---

## 五、企業用戶有緩衝期，個人開發者自己顧好

對 Business 和 Enterprise 客戶，GitHub 提供了 3 個月的「過渡期補貼」：

- **Business** 方案：6 月 1 日至 9 月 1 日，每人每月額外贈送 $30 Credits
- **Enterprise** 方案：6 月 1 日至 9 月 1 日，每人每月額外贈送 $70 Credits

9 月 1 日起回到正常的方案額度。

另外，企業管理員將獲得更細緻的用量控制工具，可以設定：
- 企業整體的 Credits 上限
- 各成本中心（Cost Center）的上限
- 單一用戶的上限

這對大型組織很有用，可以避免某些人無限制刷 Credits 讓公司帳單暴增。

---

## 這次改變，對你來說是好事還是壞事？

如果你主要靠 Copilot 做程式碼補全，這次改變幾乎沒有衝擊——補全功能繼續免費。

如果你重度使用 Chat、Agent Mode、或讓 Copilot 跑複雜的多步驟任務，就需要留意。$10/月的 Credits 在高強度使用下可能比想像中消耗更快，特別是用強模型的時候。

開發者社群的普遍反應是：「同樣的錢，可能拿到更少。」但 GitHub 的立場是，這讓計費更公平，輕度用戶不再補貼重度用戶的運算資源。

無論如何，**5 月初去看預覽帳單是現在最重要的一步**。數字出來之前，所有的擔心或安心都只是猜測。

---

---

## 常見問題（FAQ）

**Q1：程式碼補全真的完全免費嗎？**
是的。GitHub 明確說明 Code Completions 和 Next Edit Suggestions 不消耗 AI Credits，6 月後繼續免費使用。

**Q2：Credits 用完了會怎樣？**
進階功能（Chat、Agent Mode、Code Review）會停止運作。6 月起不再有自動降級到較便宜模型的 fallback 機制。你可以加購額外 Credits，或等下個計費週期重置。

**Q3：用不同的模型，Credits 消耗一樣嗎？**
不一樣。越強的模型（如 GPT-4o、Claude 3.7 Sonnet）費率越高，同樣的對話長度會消耗更多 Credits。選模型時要考慮效能和成本的平衡。

**Q4：我是企業用戶，過渡期補貼到什麼時候？**
Business 方案每人每月額外 $30 Credits、Enterprise 每人每月額外 $70 Credits，補貼期間為 6 月 1 日至 9 月 1 日，之後回到方案正常額度。

**Q5：怎麼退出 AI 訓練資料收集？**
到 GitHub Settings → Copilot → 找到「Allow GitHub to use my interactions」選項，關閉即可。Enterprise 方案預設不參與訓練，不需額外操作。

**Q6：PRUs（Premium Request Units）還會繼續用嗎？**
不會。6 月 1 日起 PRUs 完全被 AI Credits 取代。PRUs 不再作為任何計費依據。

---

## 延伸閱讀

- [GitHub 官方公告：Copilot is moving to usage-based billing](https://github.blog/news-insights/company-news/github-copilot-is-moving-to-usage-based-billing/) — 完整的計費變更說明
- [GitHub Docs：Usage-based billing for individuals](https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-individuals) — 個人方案計費細節與 Credits 計算方式
- [GitHub Changelog：Code Review 將消耗 Actions 分鐘數](https://github.blog/changelog/2026-04-27-github-copilot-code-review-will-start-consuming-github-actions-minutes-on-june-1-2026/) — Code Review 雙重計費的詳細說明

---

*資料來源：[GitHub Blog](https://github.blog/news-insights/company-news/github-copilot-is-moving-to-usage-based-billing/)、[GitHub Changelog](https://github.blog/changelog/2026-04-27-github-copilot-code-review-will-start-consuming-github-actions-minutes-on-june-1-2026/)、[GitHub Docs](https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-individuals)，2026 年 4 月。*

在 Judy AI Lab，我們持續追蹤這類計費結構的轉變，幫你把帳單變化轉成可執行的成本決策。
