---
title: "JetBrains 發布 Mellum2：120億參數混合專家架構開發者專用模型"
date: "2026-06-01T18:05:44+00:00"
draft: false
author: Judy
summary: "AI 新聞快訊：JetBrains 於 2026 年 6 月 1 日發布 Mellum2，這是一款基於混合專家架構（MoE）的 120 億參數開源模型，但每次推論僅啟動其中 25 億個活躍參數，使推論速度比同規模模型快逾兩倍，部署成本顯著降低，採用 Apache 2.0 授權公開釋出。

Mellum2 定位並非取..."
description: "JudyAI Lab AI 新聞快訊 — 來源 Hugging Face Blog"
categories:
  - "AI 新聞"
tags:
  - "AI 快訊"
  - "community"
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
news_source: "Hugging Face Blog"
news_source_url: "https://huggingface.co/blog/JetBrains/mellum2-launch"
news_pipeline_version: "v1-rss-only"
commentary_engine: "hermes-v1"
---

## 📰 重點摘要

> JetBrains 於 2026 年 6 月 1 日發布 Mellum2，這是一款基於混合專家架構（MoE）的 120 億參數開源模型，但每次推論僅啟動其中 25 億個活躍參數，使推論速度比同規模模型快逾兩倍，部署成本顯著降低，採用 Apache 2.0 授權公開釋出。

Mellum2 定位並非取代前沿大模型，而是作為多模型協作系統中的「焦點模型」，專注高頻輕量任務，涵蓋提示分類、工具選擇、RAG 管線的上下文壓縮與摘要、子代理規劃驗證及程式碼補全。模型僅處理文字與程式碼兩種模態，刻意排除多模態功能以保持架構精簡，特別適合企業在私有環境中自行部署，處理內部程式碼與機密資料。

在程式碼生成、推理、科學及數學等多項基準測試上，Mellum2 均達到同規模開源模型的競爭水準，技術報告已同步發布於 arXiv（編號 2605.31268），模型權重亦開放於 HuggingFace 供下載。

---

## 💬 JudyAI Lab 觀點

JetBrains發布的Mellum2值得關注，不是因為它要挑戰前沿大模型，而是它明確示範了「夠用就好」的設計哲學——120億引數只啟動25億，推論速度快兩倍，成本大幅下降。

這個案例反映出我們觀察到的一個清晰趨勢：多模型協作架構中，每個節點不需要都動用旗艦模型。Mellum2的設計選擇很有參考價值——只處理文字與程式碼，刻意拿掉多模態功能，把效能集中在提示分類、工具選擇、RAG管線的上下文壓縮、子代理規劃驗證、程式碼補全這幾個高頻但對深度推理要求相對低的任務。對於想在私有環境處理內部程式碼或機密資料的企業而言，Apache 2.0授權加上輕量部署成本，讓這類模型成為相當務實的選項。

如果你正在設計多模型協作系統，現在可以做的是：列出每個任務節點，找出哪些位置「不需要最強模型」，嘗試換成Mellum2這類焦點模型，這可能是降低推論成本最直接的起點。

---

## 📅 原文資訊

- **發布時間**：2026-06-01T15:45
- **來源原文**：[https://huggingface.co/blog/JetBrains/mellum2-launch](https://huggingface.co/blog/JetBrains/mellum2-launch)

---

## 🔗 延伸閱讀

- [個性化AI模型的崛起：如何為您的企業量身定制智能](https://judyailab.com/zh-tw/posts/rise-of-customized-ai-models/)
- [從交易想法到上線跑單：AI 輔助策略開發的真實流程](https://judyailab.com/zh-tw/posts/trading-concept-to-production-code-with-ai/)

