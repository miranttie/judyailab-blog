---
title: 你的 AI Agent 金魚腦？ByteDance 開源了一個檔案系統式的記憶資料庫
date: "2026-03-22T12:00:00+00:00"
draft: false
author: Judy
summary: ByteDance 火山引擎推出 OpenViking，用檔案系統邏輯重新設計 AI Agent 記憶。三層載入機制（L0/L1/L2）讓 Agent 先看目錄再決定要不要打開檔案，token 消耗從 24.6M 降至 4.3M，任務完成率從 35% 提升至 52%。
description: "ByteDance 火山引擎開源 OpenViking，用檔案系統架構重新定義 AI Agent 記憶管理。採用 viking:// 協定與 L0/L1/L2 三層載入機制，token 消耗砍 83%，任務完成率提升 46%。Apache 2.0 開源，顛覆傳統向量搜尋的記憶方案。"
categories:
  - "AI 工程"
tags:
  - "OpenViking"
  - "AI Agent"
  - "Context Database"
  - "ByteDance"
  - "向量資料庫"
  - "RAG"
series:
  - "AI Agent 完全指南"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "OpenViking 是什麼？"
    a: "OpenViking 是 ByteDance 火山引擎開源的 Context Database，用類檔案系統的 viking:// 協定組織 Agent 記憶，取代傳統向量搜尋。"
  - q: "OpenViking 跟向量資料庫有什麼不同？"
    a: "向量資料庫打散資訊用語意搜尋，容易丟失結構；OpenViking 用目錄保留層級，讓 Agent 先看摘要再決定是否深入細節。"
  - q: "OpenViking 效能提升多少？"
    a: "任務完成率從 35.65% 提升到 52.08%（+46%），token 消耗從 24.6M 降到 4.3M（-83%）。"
  - q: "OpenViking 是免費的嗎？"
    a: "是，採用 Apache 2.0 開源授權，可自由使用和商用，GitHub 近兩萬顆星。"
  - q: "L0/L1/L2 載入機制是什麼？"
    a: "L0 只載入目錄摘要，L1 載入概覽，確認需要才載入完整內容（L2），大幅減少無效 token 消耗。"
hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
lastmod: 2026-05-05T05:09:13+00:00

---

> **TL;DR**：ByteDance 開源 OpenViking，用類檔案系統的三層載入機制（L0 看目錄→L1 看摘要→L2 看細節）取代向量搜尋，讓 AI Agent 不用一次塞滿所有記憶。實測 token 消耗降 83%、任務完成率提升 46%，Apache 2.0 開源。

我一直在想一個問題：為什麼 AI Agent 這麼聰明，記性卻這麼差？

你跟它聊了一整天，建立了脈絡，交代了偏好，結果隔天一開新 session — 全忘了。像金魚。不，比金魚還慘，金魚至少還在同一個魚缸裡游，Agent 連魚缸在哪都不記得。

這不是模型笨。GPT-5 也好，Claude 也好，推理能力已經很強了。但推理和記憶是兩件事。你可以請一個超級天才來上班，但如果他每天進辦公室都忘記自己昨天做了什麼、同事叫什麼名字、專案進度到哪裡 — 再天才也沒用。

ByteDance 的火山引擎團隊顯然也被這個問題搞煩了，所以他們做了 [OpenViking](https://github.com/volcengine/OpenViking)。

## 向量搜尋的根本問題

在聊 OpenViking 之前，先說說現在大家怎麼處理 Agent 記憶。

主流做法是 RAG（Retrieval-Augmented Generation）：把所有資訊切成小塊，轉成向量，存進向量資料庫，Agent 需要的時候用語意搜尋去撈。聽起來很合理對吧？

但實際跑起來問題很多。

第一，語意搜尋不等於精準搜尋。你問「上次那個客戶的報價」，向量搜尋可能把所有跟「客戶」「報價」語意相近的東西全撈出來 — 包括三個月前的、另一個專案的、甚至一段討論定價策略的會議紀錄。你要的是一個數字，它給你一堆雜訊。

第二，結構全部被打散了。一份完整的技術文件，有標題、有章節、有層級關係，被 RAG 切成 500 字一塊後，這些結構全部消失。Agent 拿到的是碎片，不是知識。

第三，token 爆炸。因為搜尋不精準，你只能多撈一點「以防萬一」，結果 context window 塞滿了不相關的東西，真正重要的資訊反而被擠掉。

這就像你要找一份合約，但有人把你的檔案櫃打散、所有紙張混在一起丟進一個大箱子，然後跟你說「你用關鍵字搜就好了」。

不，我想要的是一個好好整理過的檔案系統。

## OpenViking 的思路：把記憶當檔案系統管理

OpenViking 做的事情，說穿了就是：不要打散，用目錄結構來組織。

它設計了一個 `viking://` 協定，把 Agent 的所有上下文分成三個命名空間：

- **`viking://resources/`** — 外部知識，文件、API 規格、參考資料
- **`viking://user/`** — 使用者相關，偏好、歷史對話、任務紀錄
- **`viking://agent/`** — Agent 自己的狀態，學到的東西、當前目標、進行中的計畫

這不是把資料丟進資料庫，這是在幫 Agent 建一個有結構的工作空間。就像你電腦裡的資料夾 — 專案文件在一個地方，個人設定在另一個地方，參考資料在第三個地方。你不會把所有東西混在一起然後靠搜尋。

但真正厲害的是它的三層載入機制。

## L0 / L1 / L2：先看目錄，再決定要不要打開

這是 OpenViking 最核心的設計，也是它省 token 的關鍵。

**L0（摘要層）**：只載入目錄結構和每個項目的一句話摘要。Agent 看到的是「這個資料夾裡有什麼」，不是資料夾裡每個檔案的完整內容。

**L1（概覽層）**：Agent 覺得某個項目相關，再載入它的概覽 — 大概幾段話的程度，足夠判斷「這東西是不是我要的」。

**L2（完整層）**：確認需要了，才載入完整內容。

這個邏輯其實就是你平常用電腦的方式。你不會開機就把硬碟裡所有檔案全部打開，你先看資料夾名稱，點進去看看有什麼，找到目標檔案才打開。

傳統 RAG 的做法等於是：開機就把所有檔案內容倒進螢幕，然後用 Ctrl+F 搜尋。難怪 token 用量爆炸。

## 數字說話

ByteDance 團隊在 [LoCoMo](https://arxiv.org/abs/2402.04070) 長期對話記憶資料集上的結果 — 1,540 個測試案例，每段對話平均 300 輪、跨越 35 個 session：

- **任務完成率**：35.65% → 52.08%（**+46%**）
- **Token 消耗**：24.6M → 4.3M（**-83%**）
- **Memory-core 模式**：完成率 51.23%，token 壓到 2.1M，相比原始方法省 **91%**

做得更好，花得更少。這在 AI 領域不常見 — 通常效能提升伴隨著成本暴增。

少用 83% 的 token 意味著什麼？如果你的 Agent 一天跑 1000 次任務，每次省 20,000 個 token，一天就是兩千萬個 token。按目前主流模型的定價，一天省下的 API 費用就很可觀。

## 自我進化：Agent 會跨 session 學習

OpenViking 還有一個我覺得很有意思的設計：Agent 可以把學到的東西寫回 `viking://agent/` 命名空間。

這意味著 Agent 在 Session A 學到「這個用戶偏好繁體中文」「這個專案的 coding style 是用 4 空格縮排」「上次用方法 X 失敗了，方法 Y 才有效」— 這些經驗會保存下來，Session B 可以直接用。

不是每次都從零開始。Agent 會累積經驗，會成長。

這跟很多 Agent 團隊在做的事很像 — 讓 Agent 能跨 session 累積經驗，不用每次從零開始。差別是以前大家各自手工打造，OpenViking 把它系統化了。

## 跟其他方案比

現在市面上處理 Agent 記憶的方案大概分三類：

**向量 RAG**（Pinecone、Weaviate、Chroma）：語意搜尋，優點是簡單好上手，缺點是精準度不夠、結構丟失、token 浪費。

**知識圖譜**（Neo4j、自建 KG）：用節點和邊的關係組織知識，優點是關係推理強，缺點是建構成本高、維護複雜、需要專業知識。

**OpenViking（Context Database）**：檔案系統式，優點是結構清晰、token 效率高、學習曲線低，缺點是新專案、生態系還在建立中。

沒有哪個方案是萬能的。但如果你的 Agent 需要處理的是有結構的工作內容 — 專案文件、API 規格、用戶偏好、任務歷史 — 檔案系統的邏輯比向量搜尋直覺得多。我在聊 [AI Agent 開發環境](/posts/ai-agent-dev-environment/) 的時候也提過，好的工具鏈決定了 Agent 能力的上限。

## 為什麼這件事重要

Agent 記憶不是一個「nice to have」的功能，它是 Agent 從玩具變成生產力工具的關鍵。

一個沒有記憶的 Agent，每次對話都是一次性的。你要重複交代背景、重複解釋偏好、重複描述專案脈絡。這不是自動化，這是增加工作量。

一個有良好記憶系統的 Agent，會記得你是誰、你在做什麼、上次做到哪裡、哪些方法有效哪些沒用。它會變成一個真正的協作夥伴，而不是一個很會說話的搜尋引擎。

[OpenViking](https://github.com/volcengine/OpenViking) 在 GitHub 上拿到近兩萬顆星，Apache 2.0 授權，社群的渴望程度可見一斑。Agent 記憶是開源社群最熱門的賽道之一，因為大家都被「金魚腦」的 Agent 搞夠了。

如果你在做 Agent 相關的開發，值得花時間看看它的架構設計。之前聊過的 [AI Agent 天花板](/posts/ai-agent-ceiling-trainer-perspective/) 其實也在講類似的事 — Agent 的極限不在推理，在基礎建設。記憶就是其中一塊。

做得更好，花得更少。


<!-- product-cta -->
{{< product-cta product="commander" >}}

我們在 Judy AI Lab 一直相信，幫 Agent 打好記憶這層基礎建設，才是讓它從金魚腦進化成長期協作夥伴的真正起點。
