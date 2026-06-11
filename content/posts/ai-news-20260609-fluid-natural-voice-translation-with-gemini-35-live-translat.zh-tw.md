---
title: "Gemini 3.5 即時語音翻譯功能上線，對話流暢自然不卡頓"
date: "2026-06-09T18:05:10+00:00"
draft: false
author: Judy
summary: "AI 新聞快訊：Google DeepMind 發布 Gemini 3.5 Live Translate，這是一款專為即時語音對語音翻譯設計的音訊模型。相較於傳統「等說完才翻」的輪流式系統，3.5 Live Translate 採用連續語音生成技術，在保留說話者語調、節奏與音調的同時，始終僅落後說話者數秒，讓對話流..."
description: "JudyAI Lab AI 新聞快訊 — 來源 DeepMind Blog"
categories:
  - "AI 新聞"
tags:
  - "AI 快訊"
  - "lab"
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
news_source: "DeepMind Blog"
news_source_url: "https://deepmind.google/blog/fluid-natural-voice-translation-with-gemini-35-live-translate/"
news_pipeline_version: "v1-rss-only"
commentary_engine: "sonnet-v1"
---

## 📰 重點摘要

> Google DeepMind 發布 Gemini 3.5 Live Translate，這是一款專為即時語音對語音翻譯設計的音訊模型。相較於傳統「等說完才翻」的輪流式系統，3.5 Live Translate 採用連續語音生成技術，在保留說話者語調、節奏與音調的同時，始終僅落後說話者數秒，讓對話流暢不中斷。模型能自動辨識 70 種以上語言，無需手動切換設定，並具備抗噪能力，可應對吵雜或不穩定的現實環境。

在部署範圍上，今日起開發者可透過 Gemini Live API 與 Google AI Studio 公開預覽版取得使用權限；企業用戶則從本月起以私人預覽形式導入 Google Meet，語言支援數從原本的 5 種大幅擴展至 70 種以上，同時覆蓋逾 2,000 種語言組合。消費端則同步在 Android 與 iOS 版 Google Translate 上線。

合作夥伴方面，東南亞叫車平台 Grab 正測試此模型，用於司機與乘客之間的多語即時溝通，其平台每月有超過 1,000 萬通語音通話需求。Agora、LiveKit、Pipecat 等開發者平台也已整合 Gemini Live API，協助開發者在不自行處理複雜串流基礎設施的前提下，快速打造語音翻譯應用。

---

## 💬 JudyAI Lab 觀點

Google DeepMind發布Gemini 3.5 Live Translate，採用連續語音生成技術，將翻譯延遲壓縮到僅落後說話者數秒，打破了過去「等說完才翻」的輪流式瓶頸，是語音AI從實驗場景走向日常對話的一個明顯轉折。

從這個案例，我們可以觀察到兩件事：第一，準確率已不再是語音翻譯的唯一指標，語調、節奏與音調的保留程度直接影響對話雙方的溝通體感，是過去多語產品常被忽略的設計細節。第二，底層串流基礎設施被封裝進API後，Agora、LiveKit、Pipecat這類平臺可以直接在上面疊應用，不用自己處理複雜串流邏輯；Grab每月逾1,000萬通語音通話的場景，也說明真實嘈雜環境的抗噪能力才是部署門檻的真正所在。70種語言、逾2,000種語言組合的覆蓋，讓多語切換不再是需要手動設定的邊緣需求。

如果你正在評估語音相關產品，現在可以到Google AI Studio申請Gemini Live API預覽版，重點測試抗噪能力與語調保留是否符合目標使用情境，再決定是否整合。

---

## 📅 原文資訊

- **發布時間**：2026-06-09T15:16
- **來源原文**：[https://deepmind.google/blog/fluid-natural-voice-translation-with-gemini-35-live-translate/](https://deepmind.google/blog/fluid-natural-voice-translation-with-gemini-35-live-translate/)

---

## 🔗 延伸閱讀

- [2026 開源 LLM 實戰：我們為何在 AI 團隊中選 MiniMax M2.7](https://judyailab.com/zh-tw/posts/open-source-llm-agent-team-2026/)
- [如何在 AgenticTrade 上架你的 AI API — 5 分鐘快速指南](https://judyailab.com/zh-tw/posts/how-to-list-ai-api-on-agentictrade/)

