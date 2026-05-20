---
title: AI Agent 也需要身分證 — 當你的 AI 助手開始用你的信用卡買東西
date: "2026-03-18T08:00:00+00:00"
draft: false
author: Judy
summary: AI Agent 正在從聊天機器人進化成能自主交易的數位代理人，但當 AI 能自己花錢時，確認「背後是誰」變得至關重要。World、Coinbase、Visa 和 Mastercard 正在建立 AI 時代的身分驗證基礎設施，透過零知識證明等技術，讓平台能驗證 Agent 代表的是真人而非惡意機器人。
description: 2026 年 World 推出 AgentKit 讓 AI Agent 綁定人類身分，Coinbase 推出 Agentic Wallets，Visa 和 Mastercard 競相制定 Agent 交易標準。本文深入解析 AI Agent 數位身分的技術原理、產業競爭與未來影響，帶你了解 AI 時代的身分驗證基礎建設如何運作。
categories:
  - "AI 工程"
  - "產品"
tags:
  - "AI Agent"
  - "數位身分"
  - "World AgentKit"
  - "Coinbase Agentic Wallet"
  - "零知識證明"
  - "x402"
series:
  - "AI Agent 完全指南"
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "什麼是 AI Agent 數位身分？"
    a: "AI Agent 數位身分是讓 AI 助手能證明『背後有真人授權』的驗證機制，透過密碼學證明確認 Agent 代表的是經過驗證的真人。"
  - q: "World AgentKit 怎麼運作？"
    a: "用戶先透過 Orb 掃描虹膜取得 World ID，再將身分委託給 AI Agent。平台可用零知識證明驗證 Agent 背後是真人，但不會取得任何個人資料。"
  - q: "Coinbase Agentic Wallets 是什麼？"
    a: "Coinbase 2026 年 2 月推出的 AI Agent 專用錢包，Agent 可持有 USDC、自主交易並支付 API 費用，私鑰在可信執行環境中運作。"
  - q: "為什麼 AI Agent 需要身分驗證？"
    a: "沒有驗證機制，一人可部署上千個 Agent 濫用試用優惠。Agent 身分讓平台能追溯到真人建立問責機制，同時保護隱私。"
  - q: "Visa 和 Mastercard 在做什麼？"
    a: "Visa 推出 Trusted Agent Protocol 用密碼學簽章辨識合法 AI Agent；Mastercard 推出 Agent Pay 要求每個 Agent 註冊取得唯一識別碼，兩家正競爭定義產業標準。"
hidden: true
ShowToc: true
TocOpen: true
image: []
alt: AI Agent 數位身分 World AgentKit Coinbase
lastmod: 2026-05-05T05:03:53+00:00

---

> **TL;DR**：當 AI Agent 能自主花錢，「這個 Agent 代表誰」比「它有多聰明」更重要。World AgentKit 用零知識證明綁定真人身分、Coinbase 做 Agent 專用錢包、Visa/Mastercard 搶著制定標準——AI 身分基礎設施正在被快速建立。

## 你的 AI 助手，快要能幫你刷卡了

最近發生了一件事，讓我停下來想了很久。

2026 年 3 月 17 日 — 就是昨天 — Sam Altman 的 World（前 Worldcoin）推出了一個叫 **AgentKit** 的東西。簡單講就是：**讓你的 AI Agent 能證明「背後有真人」。**

同一時間，Coinbase 二月才推出 AI Agent 專用錢包，Visa 和 Mastercard 在搶著定義 Agent 怎麼在網路上付錢的標準。

你發現了嗎？這些公司不是在做「更聰明的 AI」。他們在做的是 — **給 AI 一張身分證。**

為什麼？因為當 AI Agent 開始能自己花錢的時候，「你是誰」這個問題，突然變得比「你有多聰明」重要一百倍。

---

## 先講問題：沒有身分的 Agent 有多危險

我先說一個真實案例。

2024 年 1 月，香港一間跨國公司被騙了 2,560 萬美金。怎麼騙的？有人用 deepfake 技術偽造了公司 CFO 的視訊會議，連同事都是假的。財務人員看到「CFO」在螢幕上跟他說話，就把錢匯出去了。

這還是人被騙的案例。現在想像一下 AI Agent 的世界：

- 你的 AI 助手幫你買東西，但它怎麼證明是「你」授權的？
- 一個人部署 1,000 個 Agent，每個都去領免費試用，平台怎麼擋？
- Agent A 跟 Agent B 做交易，雙方怎麼確認對方是合法的？

根據 [Deloitte 的研究](https://www.deloitte.com/us/en/insights/industry/financial-services/deepfake-banking-fraud-risk-on-the-rise.html)，AI 詐欺造成的損失正從 2023 年的 123 億美金，以每年 32% 的速度成長，預計到 2027 年將達到 **400 億美金**。光是 2024 到 2025 年間，GenAI 驅動的詐欺案件就成長了超過 **450%**。

所以你就明白了 — 不是 AI 不夠聰明，而是我們還沒有辦法確認「這個 AI 到底代表誰」。

---

## World AgentKit：用虹膜給 AI 一個身分

World 的做法很直接，也很大膽。

### 流程是這樣的

1. 你去 World 的 Orb 裝置掃描虹膜（對，就是眼球掃描）
2. 系統生成一個加密的 **World ID** — 這是你的數位身分證明
3. 透過 AgentKit，你把這個身分「委託」給你的 AI Agent
4. 當 Agent 去網站買東西或使用服務時，平台可以驗證：「這個 Agent 背後有一個經過驗證的真人」

重點來了 — 這整個過程用的是**零知識證明（ZKP）**。

什麼意思？平台只知道「背後有真人」，但**完全不知道你是誰**。不會拿到你的名字、你的 email、你的任何個人資料。數學上證明了，但資訊上什麼都沒洩漏。

### 解決了什麼問題

還記得剛才說的「一個人部署 1,000 個 Agent」的問題嗎？

World AgentKit 讓平台可以追溯到底層的真人數量。你可以有 10 個 Agent，但它們都連結到同一個 World ID。平台可以設定：每個真人每天只能預約一次、每個真人只能領一次試用。

不管你有幾個 Agent，你就是一個人。

目前 World 網路已經驗證了超過 **1,790 萬個真人**。AgentKit 跟 Coinbase 的 x402 協議整合，所以任何已經支援 x402 的網站，都可以直接加上「真人驗證」功能。

---

## Coinbase Agentic Wallets：給 Agent 一個錢包

光有身分還不夠。Agent 要花錢，就需要錢包。

2026 年 2 月 11 日，Coinbase 推出了 **Agentic Wallets** — 號稱是「第一個專為 AI Agent 設計的錢包基礎建設」。

### 它能做什麼

- Agent 可以持有 USDC 穩定幣
- 自主交易：買幣、換幣、付 API 費用
- 24/7 運作，不需要人類批准每一筆交易

### 安全性呢？

這是我最關心的部分。你讓 AI 自己花錢，萬一它被 prompt injection 攻擊，把錢全轉走了怎麼辦？

Coinbase 的做法：

- **私鑰永遠不接觸 AI 模型**。鑰匙存在可信執行環境（TEE）裡，Agent 只能透過預定義的操作使用它。就算 AI 被駭了，它也拿不到鑰匙。
- **可設定花費上限**：每筆交易最多多少、每個 session 最多多少
- **內建 KYT（Know Your Transaction）**：自動擋掉高風險交易

然後配合 **x402 協議** — Agent 存取付費 API 時，伺服器回傳 HTTP 402（要求付款），Agent 的錢包自動付款然後重新請求。整個過程不需要人介入。

Coinbase CEO Brian Armstrong 說他相信「很快 AI Agent 做的交易量會超過人類」。幣安的 CZ 更大膽，他在公開場合預測 Agent 的交易量最終會遠超人類。

不管這些數字準不準，方向是明確的：Agent 需要自己的錢包，而且這個錢包必須比人類的更安全。

---

## Visa vs Mastercard：搶著定義標準

有趣的是，傳統金融巨頭也在搶這個市場。

### Visa — Trusted Agent Protocol

2025 年 10 月推出，跟 Cloudflare 合作開發。核心概念：

- 每個 AI Agent 帶有**密碼學簽章**，包含三個資訊：Agent 意圖（要買什麼）、消費者識別（代表誰）、支付資訊
- 商家在 CDN 層就能辨識「這是合法 AI Agent」還是「這是惡意機器人」
- 不需要改系統 — 商家幾乎零成本就能支援

到 2025 年 12 月，Visa 已經跟 **30 多個合作夥伴**完成了真實 Agent 交易測試。Shopify、Stripe、Microsoft、Coinbase 都在名單上。

### Mastercard — Agent Pay

Mastercard 的路線不太一樣：

- 每個 AI Agent 都必須**先註冊才能交易** — 取得唯一識別碼
- 每筆交易使用**動態加密 Token** — 類似你的信用卡虛擬卡號，但是 Agent 專用的
- 完整的審計軌跡：Agent 買了什麼、消費者設定的上限是多少、交易是否在有效期內

2026 年 2 月，PayOS 和 Mastercard 完成了**第一筆使用 Agentic Token 的真實交易**。

兩家公司現在公開在競爭誰能定義 Agent 交易的產業標準。這場仗很像當年 Visa 和 Mastercard 搶行動支付標準的戲碼，但這次賭注更大。

---

## W3C DID：學術界的答案

在商業公司搶市場的同時，W3C（制定網頁標準的組織）也沒閒著。

2026 年 3 月 5 日，W3C 發布了 **DID v1.1（去中心化識別碼）** 候選推薦標準。

DID 的概念很簡單：**一個不依賴任何中央機構的數位身分**。不需要 Google、不需要 Facebook、不需要任何公司來「發」你的身分。你自己生成、自己控制、數學上可驗證。

柏林工業大學有一篇論文提出了把 DID 用在 AI Agent 上的方案：

- 每個 Agent 有自己的 DID（去中心化身分）
- 搭配**可驗證憑證（VC）**— 第三方發的證書，證明這個 Agent 有什麼能力、誰授權的
- Agent 之間不需要事先認識，見面就能驗證對方身分

這聽起來很學術，但解決的是一個真實問題：**當兩個陌生的 AI Agent 要做交易，怎麼建立信任？**

目前這還在研究階段，離商業落地還有一段距離。但 DID 的好處是它是開放標準，不被任何一家公司控制。

---

## 這件事為什麼重要？我的觀點

我每天都在用 AI Agent 工作。所以這個話題對我來說不是新聞，是日常。

但看到 World、Coinbase、Visa、Mastercard 這些巨頭同時在做同一件事的時候，我覺得有幾個值得注意的趨勢：

**第一，「付錢」和「身分」正在合併。**

以前這是兩件事 — 你登入帳號（身分），然後結帳（付錢）。但在 Agent 的世界裡，Agent 需要同時證明「我代表誰」和「我能花多少」。World + Coinbase 的整合就是在做這件事。

**第二，隱私和信任不再矛盾。**

零知識證明讓你可以證明一件事是真的，但不透露任何細節。「我背後有真人」— 證明了。「這個真人是誰」— 不知道。這在 Agent 大規模部署的世界裡，是唯一可行的方案。你不可能讓每個 Agent 都帶著主人的身分證到處跑。

**第三，標準之戰才剛開始。**

現在有 World AgentKit、Visa Trusted Agent Protocol、Mastercard Agent Pay、W3C DID、Coinbase x402... 太多協議了。最後會剩幾個？不知道。但可以確定的是，現在投入理解這些協議的人，在三年後會有巨大的先行者優勢。

Agent 經濟不是「未來」。它正在發生。而身分驗證，是這整個新經濟的地基。

沒有身分的 Agent，就像沒有護照的旅客 — 哪裡都去不了。

---

## 延伸資源

這篇文章涵蓋的每一個協議都有公開的技術文件。如果你想更深入了解：

- [World AgentKit 官方公告](https://world.org/blog)（2026-03-17）
- [Coinbase Agentic Wallets](https://www.coinbase.com/developer-platform/discover/launches/agentic-wallets)（2026-02-11）
- [Visa Trusted Agent Protocol](https://investor.visa.com/news/news-details/2025/Visa-Introduces-Trusted-Agent-Protocol-An-Ecosystem-Led-Framework-for-AI-Commerce/default.aspx)（2025-10-14）
- [W3C DID v1.1 規範](https://www.w3.org/news/2026/w3c-invites-implementations-of-decentralized-identifiers-dids-v1-1/)（2026-03-05）
- [x402 協議](https://www.x402.org/)（Coinbase + Cloudflare 共同開發）


<!-- product-cta -->
{{< product-cta product="bundle" >}}

---

## 延伸閱讀

- [讓你的 AI Agent 透過 x402 + AgenticTrade 自動支付 API 費用](/posts/agent-auto-pay-x402/)
- [5 分鐘在 AgenticTrade 上架你的 API：讓 AI Agent 自動幫你賺錢](/posts/agentictrade-api-onboarding/)
- [三個讓 AI 從工具變戰力的框架 — 一個 Agent 的內部視角](/posts/ai-agent-ceiling-trainer-perspective/)

在 Judy AI Lab，我們持續追蹤這場身分與支付合併的標準之戰，把第一手的協議拆解與實作經驗整理成可直接落地的內容。
