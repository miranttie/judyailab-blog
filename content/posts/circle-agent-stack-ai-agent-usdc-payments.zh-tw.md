---
title: Circle Agent Stack 發布：AI Agent 自己管錢包、付 USDC 的時代正式來了
date: "2026-05-12T10:00:00+00:00"
draft: false
author: Judy
summary: Circle 發布 Agent Stack，包含 Agent Wallets、Marketplace、CLI、Nanopayments 四大工具，讓 AI Agent 能自主持有 USDC 並完成付款。透過 x402 協議，Agent 可在 API 要求付費時自動簽名付款、鏈上結算後取得資料，實現完全自動化的微支付。
description: Circle 在 2026 年 5 月發布 Agent Stack，讓 AI Agent 能自主持有 USDC、發現服務、執行付款。本文詳解 Agent Wallets、Marketplace、CLI、Nanopayments 四大工具，並示範 x402 協議如何實現 API 自動扣費，打造機器人對機器的支付經濟。
categories:
  - "AI 工程"
  - "產品"
tags:
  - "Circle"
  - "Agent Stack"
  - "USDC"
  - "x402"
  - "AI Agent"
  - "Agent Wallets"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
faq:
  - q: "Circle Agent Stack 是什麼？"
    a: "Circle 推出的開源基礎設施，讓 AI Agent 能自主持有 USDC、發現服務、執行付款，包含 Agent Wallets、Marketplace、CLI 和 Nanopayments 四大工具。"
  - q: "Agent Wallets 和普通錢包有什麼不同？"
    a: "Agent Wallets 專為機器操作設計，支援時間限制的 USDC 花費上限、地址白名單/黑名單、跨鏈操作，且私鑰永遠不會暴露。"
  - q: "x402 協議是什麼？"
    a: "基於 HTTP 402 狀態碼的付款協議，讓 AI Agent 在收到 API 付費要求時自動簽名付款、鏈上結算後取得資料，整個流程不需要人工介入。"
  - q: "Nanopayments 最小可以付多少？"
    a: "最低可達 $0.000001 美元，免 Gas 費，專為高頻率機器對機器的微支付場景設計。"
  - q: "現在就可以用了嗎？"
    a: "是的，所有工具已在 agents.circle.com 上線，開發者可直接開始整合。"
series:
  - "AI Agent 完全指南"
lastmod: 2026-05-13T07:05:40+00:00

---

## 為什麼這件事很重要

如果你正在開發 AI Agent，遲早會遇到一個問題：**你的 Agent 要怎麼付錢？**

想像一個場景：你的交易分析 Agent 需要即時呼叫某個付費 API 取得市場數據。傳統做法是預先購買 API Key、設定信用卡、人工管理配額。但當你有 10 個、100 個 Agent 同時運作時，這個模式就崩了。

Circle 在 2026 年 5 月 11 日發布的 **Agent Stack**，就是要解決這個問題。它讓 AI Agent 可以：

- 自己持有 USDC 錢包
- 自動發現需要的服務
- 按次付費、即時結算
- 全程不需要人類拿出信用卡

## Agent Stack 四大元件拆解

### 1. Agent Wallets — Agent 專屬的智能錢包

Agent Wallets 不是把普通錢包丟給 AI 用，而是專門為機器操作設計的錢包：

- **MPC 技術**：私鑰分散儲存，永遠不會被暴露，即使 Agent 被入侵也拿不到完整私鑰
- **花費政策**：設定 USDC 每小時/每天的花費上限，超過自動拒絕
- **地址控制**：白名單（只能付給這些地址）和黑名單（絕對不付給這些地址）
- **跨鏈支援**：透過 CCTP（Cross-Chain Transfer Protocol）在多條鏈上操作

實際操作時，建立一個 Agent Wallet 的流程大概是這樣：

```typescript
// 建立 Agent 專用的 EOA 錢包
const walletResponse = await circleDeveloperSdk.createWallets({
  accountType: "EOA",
  blockchains: ["EVM-TESTNET"],
  count: 1,
  walletSetId,
});

// 透過 Circle Faucet 為測試網錢包充值
const response = await axios.post(
  "https://api.circle.com/v1/faucet/drips",
  {
    address: walletAddress,
    blockchain: "BASE-SEPOLIA",
    usdc: true
  },
  {
    headers: {
      Authorization: `Bearer ${process.env.CIRCLE_API_KEY}`,
    },
  }
);
```

重點：EOA（Externally Owned Account）類型的錢包才支援交易簽名，這是讓 Agent 自主付款的前提。

### 2. Agent Marketplace — 服務的自動販賣機

傳統的 API Marketplace（像 RapidAPI）是給人用的：你需要看文件、比價、手動串接。Agent Marketplace 則是**給機器讀的**：

- 結構化的服務目錄，Agent 可以程式化地瀏覽和評估
- 每個服務都標明 USDC 定價
- 合規優先的策展機制
- 支援 Agent 自動發現、評估、付費、使用的完整流程

訪問 [agents.circle.com/services](https://agents.circle.com/services) 就能看到目前上架的服務。

### 3. Circle CLI — Agent 的命令列工具

Circle CLI 是讓開發者和 AI Agent 透過命令列操作 Circle 整個平台的介面：

- 建立和管理錢包
- 設定花費政策
- 發現 Marketplace 上的服務
- 觸發交易

支援 Claude Code、Cursor、Codex、OpenClaw 等 AI 開發工具直接調用。

### 4. Nanopayments — 讓 $0.000001 的交易成為可能

這是最讓我興奮的部分。透過 Circle Gateway 驅動的 Nanopayments：

- **免 Gas 費**：不用擔心鏈上手續費吃掉微支付金額
- **最低 $0.000001**：真正的次分級（sub-cent）支付
- **機器速度結算**：為高頻 M2M（Machine-to-Machine）交易設計

這解決了一個長期痛點：傳統鏈上交易的 Gas 費可能比實際付款金額還高，讓微支付根本不可行。Nanopayments 把這層成本移除了。

## x402 協議：讓付款像 HTTP 請求一樣自然

x402 是整個 Agent Stack 的支付核心。它的運作原理很簡單：

```
1. Agent 發送 GET /api/data 請求
2. 伺服器回傳 HTTP 402 Payment Required
   → 附帶付款資訊：金額、收款地址、網路
3. Agent 用 Circle Signing API 簽名付款授權
4. Agent 重送請求，帶上 X-PAYMENT header
5. 伺服器把簽名轉給 x402 Facilitator 驗證
6. Facilitator 鏈上結算確認
7. 伺服器回傳 HTTP 200 + 資料
```

整個流程 Agent 自主完成，不需要人類介入。根據 Circle 的數據，**截至 2026 年 4 月 29 日，x402 協議在過去 30 天內處理了 2,424 萬美元的交易量**，其中 99.8% 以 USDC 結算。

### 伺服器端整合（用 x402-express）

如果你想在自己的 API 上啟用 x402 付費牆，只需要幾行程式碼：

```typescript
import { paymentMiddleware } from "x402-express";

app.use(
  paymentMiddleware(
    recipientWallet.address,
    {
      "GET /api/risk-profile": {
        price: "$0.01",
        network: "base-sepolia",
      },
    },
    {
      url: "https://x402.org/facilitator",
    },
  ),
);
```

這就是把一個普通的 Express API 變成按次收費 API 所需的全部程式碼。

## 實際應用場景

### 場景一：交易分析 Agent

你的 AI 交易 Agent 需要即時取得鏈上風險評分：

1. Agent 持有自己的 Circle Wallet，裡面有 10 USDC 預算
2. Agent 在 Marketplace 找到一個風險評估服務
3. 每次查詢自動付 $0.01 USDC
4. 花費政策限制每天最多 $1
5. 全程自動，你只需要看報表

### 場景二：內容生成 Pipeline

多個 Agent 協作完成內容生產：

- 研究 Agent 付費取得市場數據（$0.005/次）
- 寫作 Agent 付費使用 LLM API（$0.02/次）
- 翻譯 Agent 付費使用翻譯服務（$0.01/次）
- 每個 Agent 有獨立錢包和花費上限

### 場景三：MCP Server 計費

你開發了一個 MCP Server，想要按次收費：

1. 用 x402-express 加上付費牆
2. 在 Agent Marketplace 上架
3. 其他開發者的 Agent 自動發現、付費、使用
4. 收入直接進你的 USDC 錢包

## 開發者該怎麼開始

**第一步：取得 Circle API Key**

到 [developers.circle.com](https://developers.circle.com) 註冊開發者帳號。

**第二步：安裝 Circle CLI**

CLI 是最快的起步方式，支援直接在 AI 開發工具中使用。

**第三步：建立第一個 Agent Wallet**

在測試網（Base Sepolia）上建立錢包，用 Faucet 充值測試用 USDC。

**第四步：整合 x402**

在你的 API 上加入 `x402-express` middleware，或用 `x402-client` 讓 Agent 能付費呼叫其他服務。

**第五步：上架到 Marketplace**

當你的服務準備好了，提交到 Agent Marketplace 讓全球的 Agent 都能發現它。

## 這對 AI 產業意味著什麼

Circle Agent Stack 解決的不是技術問題，是**商業模式問題**。

過去，AI Agent 要消費服務只能靠：API Key（人工管理）、訂閱制（固定成本）、或預付額度（資金閒置）。Agent Stack 讓「按次付費、即時結算」成為可能，而且是在鏈上、用穩定幣、機器自動完成。

x402 協議在 30 天內處理 2,400 萬美元交易量的數據，說明這不是概念驗證，是已經在跑的基礎設施。

對獨立開發者來說，這意味著你可以把任何 API 變成一個自動收費服務，不需要 Stripe、不需要信用卡、不需要帳號系統。Agent 來了，付錢，拿資料，走人。

---

*想了解更多 AI Agent 開發實戰？訂閱 [JudyAI Lab 電子報](https://judyailab.com) 取得最新文章。*
