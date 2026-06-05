---
title: "Salesforce Agentforce vs 我的單人 AI 團隊：小老闆該選哪一邊？"
date: "2026-06-03T05:00:49+00:00"
draft: true
author: "Judy"
summary: "Salesforce Agentforce 走企業級 AI Agent 平臺路線，定價繞著 Flex 點數、對話量、人頭授權跑。Judy AI Lab 用 Claude+MiniMax+Gemini 訂閱拼出五個 Agent，月費控制在幾百美元。給 solopreneur 的三條決策路徑。"
description: "從 Salesforce Agentforce 的定價邏輯切入，對照 Judy AI Lab 用 Claude、MiniMax、Gemini 訂閱組合跑出的五人 AI 團隊架構，給小老闆三條落地路徑——完全 DIY、訂閱半自動助理、企業級平臺——以及三個該升級到 Agentforce 的訊號條件。"
categories:
  - "AI Agent"
tags:
  - "Agentforce"
  - "AI Agent"
  - "Solopreneur"
  - "Claude"
  - "AI 團隊"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
series:
  - "AI Agent 完全指南"
---

## Agentforce在賣什麼？把企業級AI經紀人變成SaaS

Salesforce把Agentforce包成「企業級AI智慧代理平臺」，核心是Atlas Reasoning Engine——可以把複雜請求拆成小任務、逐步評估、自主執行，跨團隊和部門擴展 [Source: https://www.salesforce.com/agentforce/]。定價方式很 Salesforce風格：Flex點數、對話量計費、或依使用者人頭授權，三選一 [Source: https://www.salesforce.com/tw/agentforce/pricing/]。

旁邊還有一個更大的訊號。Gartner 2025/03 預測，到2029年，自主式AI將自主解決80% 的常見客戶服務問題，帶來30% 的營運成本降低 [Source: https://www.cxtoday.com/contact-center/agentic-ai-gartner-predicts-80-of-customer-problems-solved-without-human-help-by-2029/]。

故事講得很好聽，但Judy AI Lab觀察到一個盲點：Agentforce的目標客戶是IT部門和大企業，不是手上只有一個人的小老闆。

## Judy AI Lab的AI團隊長這樣

Judy AI Lab的團隊養了五個Agent。J跑技術軍師兼COO，用Claude Opus；米米跟阿達分別做行銷和產品工程，跑MiniMax M2.7；莉莉做內容總監，掛在OpenRouter的Hermes模型上；小月做QA，用Gemini訂閱版。

跟Agentforce比，這套組合最大的差別是——它不是平臺給的能力，是Judy自己拼出來的能力。每個Agent有自己的角色、工具、inbox。要加功能就改prompt、加skill，不需要等SaaS廠商roadmap。

聽起來搞剛，但對小老闆來說，這剛好是Agentforce給不了的東西：完全的客製邊界、零授權上限、想跑多久就跑多久。

## 算給你看：訂閱費的差距不是一兩倍

先把Claude那邊的官方價格擺出來。Pro方案USD $20/月、Max方案 $100/月、Team方案月繳每人 $30/月，5人團隊最低 $150起；若改成年繳，每人 $25/月，5人團隊最低 $125起 [Source: https://www.anthropic.com/pricing]。MiniMax和Gemini訂閱版的個人月費，也都落在三位數美元以內。

整套加總，Judy AI Lab跑五個Agent的訂閱費用，落在幾百美元區間，沒有對話量計費，也沒有per-seat trap。

Agentforce那邊，官方有公開定價：Flex點數每10萬點USD $500、對話式定價每次對話 $2、使用者授權則從每人每月 $125起跳 [Source: https://www.salesforce.com/tw/agentforce/pricing/]。看起來透明，但對小老闆來說，這三條路都不友善——對話量計費等於用得越多繳越多，per-seat每多一個人就多 $125，Flex點數則要先估量買整批。本質上是面向IT預算撥得出來的企業設計的。

## 小老闆的三條路，看你站在哪

第一條，完全DIY：用Claude Code或類似的Agent CLI自己接MCP（Model Context Protocol，可以理解成AI跟外部工具溝通的標準插頭），自己寫prompt、自己排cron。學習曲線最陡，但成本最低、彈性最大。

第二條，用Claude Pro或ChatGPT Plus當「半自動助理」：不寫程式，把AI當文案手、報表手、FAQ手。一個月 $20，先把AI帶進工作流，再決定要不要升級。

第三條，才是Agentforce路線：已經有Salesforce CRM、有IT部門可以接、客服ticket量大到需要自動分流。這時候Agentforce的價值才會cover它的訂閱成本。

路徑沒有對錯，只有適不適合。

## 三個訊號出現時，才考慮Agentforce

第一，對話量大到自架訂閱無法cover，邊際成本反而高於Agentforce每次對話 $2的計費。

第二，合規或稽核變成硬條件——某些行業需要SOC 2、ISO 27001這種背書，DIY拿不到。

第三，Agent數從5個變50個，需要分權、需要稽核操作日誌。這時候平臺每人每月 $125的價值會壓過彈性的損失。

在這三條紅線跨過之前，每月幾百美元跑整間公司，是目前solopreneur最划算的解。

問題從來不是「Agentforce還是DIY」。是你現在站在哪一個訊號上。