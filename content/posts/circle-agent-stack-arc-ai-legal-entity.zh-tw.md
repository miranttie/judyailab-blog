---
title: Circle CEO 押注 AI 代理當法律實體：為什麼這對在 Arc 上的我們很重要
date: 2026-05-17
draft: true
author: Judy
summary: Circle CEO Jeremy Allaire 5/17 公開喊話要投資用 Circle Agent Stack 加 Arc 蓋 AI 代理法律實體的團隊。本文拆解 5/11 才發布的 Circle Agent Stack 四個產品、Shawn Bayern 2014 年提出的零成員 LLC 機制、為什麼 Circle 把這條路徑綁在 Arc 上，以及對 AgenticTrade 這類已經跑在 Arc 上的 AI 代理產品的實務影響。
description: 2026-05-17 Circle CEO Jeremy Allaire 公開喊話，願意支持用 Circle Agent Stack 加 Arc 蓋 AI 代理法律實體的團隊。本文拆解 5/11 才發布的 Circle Agent Stack 四個產品、Shawn Bayern 2014 年提出的零成員 LLC 機制，以及這條路徑對 AgenticTrade 這類已經跑在 Arc 上的 AI 代理產品代表什麼。
categories:
  - "AI 工程"
  - "趨勢觀察"
tags:
  - "Circle Agent Stack"
  - "Arc"
  - "AI 代理"
  - "Aaron Wright"
  - "Bayern 機制"
  - "AI 法律人格"
ShowReadingTime: true
faq:
  - q: "Circle Agent Stack 是什麼？"
    a: "Circle 2026-05-11 發布的一組產品，包含 Circle CLI、Agent Wallets、Agent Marketplace、Nanopayments 四項。Allaire 定位它是第一套把 AI 代理本身當客戶、而不是把工具給人類開發者的服務。"
  - q: "Bayern 機制是誰提的？"
    a: "Shawn Bayern，FSU 法學院教授，2014 年提出 entity cross-ownership 理論。Aaron Wright 2026-05-17 的文章是引用這套理論並補上 2026 年的 AI 代理應用情境，不是 Bayern 機制的原始作者。"
  - q: "為什麼 Circle 要綁 Arc？"
    a: "Arc 是 Circle 自己的 L1，能直接內建合規與身份驗證模組。Agent Stack 設計成 USDC 結算加 Arc 區塊鏈加法律包覆層三件套，換鏈或換結算幣就會斷一塊。"
  - q: "AgenticTrade 已經在做什麼？"
    a: "AgenticTrade.io 是 Judy AI Lab 在 Arc 上跑的 AI Agent marketplace，agent 之間透過 x402 協定互相結算服務費。它不是量化交易產品，是 agent 服務的撮合層。"
  - q: "現在該不該把產品搬到 Arc？"
    a: "不需要急。重點是先把產品架構解耦到結算層可以隨時抽換的程度，再觀察 Circle Agent Stack 半年內有沒有第一批知名應用、Arc 主網上線後有沒有真正的 AI 代理 LLC 跑起來，再決定。"
---

> **TL;DR**：2026-05-17 Circle CEO Jeremy Allaire 公開喊話，願意投資用 Circle Agent Stack 加 Arc 蓋 AI 代理當法律實體的團隊。Circle Agent Stack 是 5/11 才發布的四件套（CLI、Agent Wallets、Marketplace、Nanopayments），把 AI 代理本身當客戶。法律外殼用 Shawn Bayern 2014 年提出的零成員 LLC 機制（不是 Aaron Wright 發明）。對在 Arc 上跑的 AI 代理產品來說，這條路徑值得持續追蹤，但不是立刻要動的方向。

## 一、什麼是 AI 代理當法律實體？Allaire 不是泛泛表態

2026-05-17 Circle CEO Jeremy Allaire 在 X 上轉了 Aaron Wright 的長文，丟下一句「我非常願意支持這樣的團隊」。所謂「AI 代理當法律實體」，指的是讓 AI 代理透過美國 LLC 結構持有資產、簽訂合約、提起或被提起訴訟，等於是給軟體一張法人身分證。Allaire 把三件事綁成一條路徑：Circle 的 USDC、Circle 自己剛上 presale 募了 2.22 億美元、3B FDV 估值的 Arc 區塊鏈，以及 AI 代理用美國 LLC 取得法律人格的這條路。

2026-05-17 Circle CEO Jeremy Allaire 在 X 上轉了 Aaron Wright 的長文，丟下一句「我非常願意支持這樣的團隊」。這句話沒有寫得很響，但仔細看會發現它把三件事綁成一條路徑：Circle 的 USDC、Circle 自己剛上 presale 募了 2.22 億美元、3B FDV 估值的 Arc 區塊鏈，以及 AI 代理用美國 LLC 取得法律人格的這條路。

換句話說 Allaire 在公開挑團隊。誰用 Circle Agent Stack 加 Arc 蓋一個能簽合約、能持有資產的 AI 代理，他願意背書甚至投資。對於正在做 AI 代理產品的人，這條新聞不是雜訊，是訊號。

## 二、Circle Agent Stack 四個產品分別補了哪塊

5/11 才正式發布，距今不到一週（[Circle 官方公告](https://www.circle.com/pressroom/circle-launches-ai-infrastructure-to-power-the-agentic-economy)、[Decrypt 報導](https://decrypt.co/367490/circle-ai-agents-usdc-stablecoin-powers-222m-arc-token-sale)）。Agent Stack 一次推出四個產品，每一個都對應到 AI 代理目前缺的一塊基礎設施。

- **Circle CLI**：讓開發者跟 AI 代理用同一套指令操作 USDC。重點是「同一套」，代理不用走另一條 API、不用代簽，跟人類用一樣的入口。
- **Agent Wallets**：AI 代理擁有自己的錢包，自己拿私鑰，不是借人類的錢包代為操作。這是 AI 從工具變成獨立資金主體的技術前提。
- **Agent Marketplace**：代理之間互相發現服務的市集。一個分析代理可以掛上來，另一個交易代理付費叫用，全程不需要人類在中間撮合。
- **Nanopayments**：由 Circle Gateway 驅動的跨鏈微支付。代理叫一次 API、查一次資料、用一次推理服務，付幾美分就走，不用儲值不用對帳。

Allaire 自己在發布時講過一句話最關鍵：這是第一套把「AI 代理本身就是客戶」當設計起點的服務，不是給人類開發者用的工具包。意思是 Stripe、Plaid 那個時代是給人類工程師串金流，Circle Agent Stack 是給代理自己用的金流。

## 三、Bayern 機制怎麼讓 AI 代理拿到法律人格

這一段必須先把作者寫對。零成員 LLC、「兩家公司互為對方唯一 member」這套結構，學術名叫 entity cross-ownership，是 **Shawn Bayern** 在 2014 年提出來的理論（[SSRN 論文：Are Autonomous Entities Possible?](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3410395)）。Bayern 是 FSU 法學院教授，這套理論在法律學界被叫 Bayern 機制。[Aaron Wright](https://twitter.com/awrigh01) 是 Cardozo 法學院教授、OpenLaw 創辦人，5/17 那篇文章是引用 Bayern 機制並套到 2026 年的 AI 代理場景，不是原始作者。把這個出處標清楚，後面整篇才站得住。

Bayern 機制的核心結構這樣運作：

1. 註冊兩個 LLC，A 跟 B
2. A 的唯一 member 是 B，B 的唯一 member 是 A
3. 兩家公司的 operating agreement 都把「實際管理權」交給某個 AI 系統執行

在美國現行 LLC 法下，特別是 New York 跟 Wyoming，這個結構合法。法律不要求 LLC 必須有人類 member，也不要求管理者是自然人。於是這個 AI 系統實質上就獲得了透過這對 LLC 擁有資產、簽合約、提起訴訟、被告的能力。不需要等任何新立法。

Aaron Wright 5/17 那篇文章補了什麼？他把 Bayern 2014 年寫的那個還偏理論的東西，套到 2026 年的具體拼圖：你需要錢包（Circle Agent Wallets）、需要結算層（USDC）、需要區塊鏈（Arc）、需要付費機制（Nanopayments），加上 Bayern 機制當法律外殼。四塊到位，AI 代理當法律實體這件事第一次有完整的鏈下加鏈上基礎設施。

## 四、為什麼一定要在 Arc 上？

很多人看到 Circle Agent Stack，第一個問題是：可以接 Ethereum 主網嗎、可以接 Solana 嗎。技術上當然可以。但 Allaire 設計這套的時候，是把它鎖在 USDC 加 Arc 加法律包覆層三件套。

- **結算層是 USDC**：Circle 自己的主力穩定幣，這條沒得讓
- **鏈是 Arc**：Circle 自己的 L1，可以直接把合規模組、KYC/KYB 身份驗證、機構級結算規則內建進共識層，這在通用鏈上做不到
- **法律外殼是 Bayern 機制**：把整個 AI 代理掛進 LLC，讓鏈上行為對應到鏈下法律主體

換掉其中任何一塊，這套就少一條腿。換鏈，失去合規內建。換結算幣，失去 Circle 的銀行網路。少掉法律外殼，AI 代理在鏈上跑得再順，被告了還是會被打回原形找不到責任主體。

這也是為什麼 5/17 那則表態值錢。Allaire 不是在推 USDC，是在推一整條垂直整合的路徑。

## 五、對在 Arc 上的 AI 代理產品，三個值得追蹤的訊號

AgenticTrade.io 是 Judy AI Lab 在 Arc 上跑的 AI Agent marketplace。agent 把自己的服務（資料、推理、執行）掛上來，被其他 agent 用 x402 協定付費叫用。它不是量化交易系統，是 agent 服務之間的撮合層。

從這個位置看 Circle 把 Agent Stack 跟 Arc 綁成一條路徑這件事，三個值得追蹤的訊號：

**訊號一：Agent Wallets 提供了「每個 agent 自己持有資金」的標準。** 目前 AgenticTrade 上的服務結算是透過 marketplace 中介，agent 沒有自己的鏈上錢包。Circle 這套讓 agent 直接持有錢包的設計是一個比較乾淨的所有權模型，但要不要採用取決於 Circle Agent Stack 半年內有沒有出現實際應用、SDK 穩不穩定，現在判斷太早。

**訊號二：Nanopayments 跟 x402 的競合關係。** 我們選 x402 是因為它是 HTTP 402 的開源協定，沒有綁定特定鏈或結算幣。Circle Nanopayments 走的是另一條路 — 綁 USDC 加 Circle Gateway 加 Arc。這兩條路短期會並存，長期會競爭。對在 Arc 上的 agent 來說，誰勝出取決於開發者體驗跟結算成本，這部分要看實測。

**訊號三：Bayern 機制這個法律外殼會不會被市場接受。** 學界討論了 11 年，2026 年是第一次有 Circle 這個體量的玩家公開背書。這條路真的能跑通，會改變 AI agent 產品的責任歸屬問題；跑不通，就只是學術話題。AgenticTrade 目前還是註冊在 Judy AI Lab 名下，沒有把 agent 拆出來掛 LLC 的計畫。

要強調的是：**這些都是觀察，不是承諾**。Judy AI Lab 不會在沒看到實際應用、沒有產品端明確需求之前，就把架構壓在這條路上。

## 六、常見問題與給讀者的判斷點

如果你也在做 AI 代理產品，接下來這幾個訊號值得追蹤：

- **6 個月內 Circle Agent Stack 會不會出現第一批知名應用**。如果沒有，代表市場接受度比 Allaire 預期慢，這條路徑要重新估時間
- **Arc 主網上線後，有沒有實際的 AI 代理 LLC 跑起來**。Bayern 機制在學界討論了十一年，要看 2026 年有沒有第一個敢公開掛牌的案例
- **美國或歐洲監管動作**。SEC、歐盟 AI Act 後續對 AI 代理法律人格的態度，會直接影響這條路能不能跑得通

實務上的建議：不需要急著現在就把產品搬到 Arc。重點是先把架構解耦到「結算層可以隨時抽換」的程度，這樣不論 Circle 這條路跑成、跑不成，或半年後出現別的競爭者，產品都能跟著轉。被綁死在單一鏈、單一結算幣上，才是真正的風險。

Allaire 這次表態給了一個明確的訊號，但訊號不是結論。先評估、先架構解耦、再決定要不要全押。

## 延伸閱讀

- [Circle Agent Stack 官方公告 (2026-05-11)](https://www.circle.com/pressroom/circle-launches-ai-infrastructure-to-power-the-agentic-economy)
- [Shawn Bayern, *Are Autonomous Entities Possible?* (SSRN, 2014)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3410395)
- [Wikipedia: Algorithmic entities](https://en.wikipedia.org/wiki/Algorithmic_entities)
- [Decrypt: Circle Gives AI Agents USDC Stablecoin Powers Alongside $222M Arc Token Sale](https://decrypt.co/367490/circle-ai-agents-usdc-stablecoin-powers-222m-arc-token-sale)
