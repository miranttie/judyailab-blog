---
title: "Holo 3.1 本地高速電腦操控 AI 代理正式發布"
date: "2026-06-03T00:05:13+00:00"
draft: true
author: Judy
summary: "AI 新聞快訊：H Company 於 2026 年 6 月 2 日正式發布 Holo 3.1 電腦操作 AI 代理模型系列，共提供四種規格：0.8B 超輕量本地版、4B 低成本版、9B 效能平衡版，以及旗艦級 35B-A3B。

在行動端自動化基準 AndroidWorld 上，35B-A3B 模型得分從前代的 ..."
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
news_source_url: "https://huggingface.co/blog/Hcompany/holo31"
news_pipeline_version: "v1-rss-only"
---

## 📰 重點摘要

> H Company 於 2026 年 6 月 2 日正式發布 Holo 3.1 電腦操作 AI 代理模型系列，共提供四種規格：0.8B 超輕量本地版、4B 低成本版、9B 效能平衡版，以及旗艦級 35B-A3B。

在行動端自動化基準 AndroidWorld 上，35B-A3B 模型得分從前代的 67% 提升至 79.3%，4B 與 9B 則從 58% 躍升至 72%，進步幅度相當顯著。與官方產品框架 Holotab 整合後，整體表現較 Holo 3 提升逾 25%，並新增函數呼叫協定（function-calling）原生支援，令不同部署環境間的效能落差大幅縮小。

量化推論方面，官方同步釋出 FP8、Q4 GGUF 與 NVFP4 三種格式的壓縮權重。在 NVIDIA DGX Spark 硬體上，NVFP4 較 BF16 全精度吞吐量提升 1.74 倍，綜合優化後每步推論時間從 6.8 秒壓縮至 3.3 秒，達到約兩倍加速效果，且在 OSWorld 測試上精度損失僅約 2 分，幾乎無感。

部署選項同時支援雲端 API 與本地執行兩條路線，本地模式可於 Windows 及 Mac 上運作，資料不離開用戶自有網路，兼顧效能與隱私保護。全系列模型已於 Hugging Face 開放下載，並可透過 H Company 官方 API 進行雲端呼叫。

---

## 💬 JudyAI Lab 觀點

> ⏳ Commentary 待補（由 Hermes 在 finalize_commentary 階段加入，必須事實導向、不延伸捏資訊）

---

## 📅 原文資訊

- **發布時間**：2026-06-02T14:13
- **來源原文**：[https://huggingface.co/blog/Hcompany/holo31](https://huggingface.co/blog/Hcompany/holo31)

---

## 🔗 延伸閱讀

- [個性化AI模型的崛起：如何為您的企業量身定制智能](https://judyailab.com/zh-tw/posts/rise-of-customized-ai-models/)
- [從交易想法到上線跑單：AI 輔助策略開發的真實流程](https://judyailab.com/zh-tw/posts/trading-concept-to-production-code-with-ai/)

