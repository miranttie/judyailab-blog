---
title: "以任務為種子的合成問答資料生成技術用於 Nemotron 預訓練"
date: "2026-06-04T12:05:38+00:00"
draft: false
author: Judy
summary: "AI 新聞快訊：NVIDIA 針對 Nemotron 系列模型開發出「任務種子合成資料生成」（Task-Seeded SDG）五階段流程：從 lm-eval-harness 選取約 70 個公開任務（約 700 子任務），分為知識密集型（39 任務、約 300 萬筆）與推理密集型（34 任務、約 150 萬筆）兩類..."
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
news_source_url: "https://huggingface.co/blog/nvidia/task-seeded-sdg"
news_pipeline_version: "v1-rss-only"
commentary_engine: "hermes-v1"
---

## 📰 重點摘要

> NVIDIA 針對 Nemotron 系列模型開發出「任務種子合成資料生成」（Task-Seeded SDG）五階段流程：從 lm-eval-harness 選取約 70 個公開任務（約 700 子任務），分為知識密集型（39 任務、約 300 萬筆）與推理密集型（34 任務、約 150 萬筆）兩類種子，以大型語言模型生成內容不同但能力相近的問答對，再附加推理鏈與領域知識後統一過濾打包。消融實驗中，加入上下文的版本大幅勝出：GPQA-Diamond CoT 從 34.85 提升至 45.96（+11.11），AGIEval-en CoT +6.16，MMLU-Pro 5-shot +2.44。將此合成資料混入 Nemotron-3 Nano 的後期訓練（100B token 量級），最終 GPQA 從 30.8 躍升至 41.9（+11.1），MMLU-Pro +1.8，程式碼能力 +1.9，常識理解 +1.6，多項維度同步成長，驗證廣泛任務覆蓋可有效防止過擬合至單一評測風格。關鍵設計原則包括：答案應儲存語意文字而非選項代號，且混合資料集時須謹慎平衡各任務比例，確保知識、推理與程式能力全面穩定提升。

---

## 💬 JudyAI Lab 觀點

NVIDIA為Nemotron系列模型開發的「任務種子合成資料生成」五階段流程，首度具體示範瞭如何用結構化方法規模化生產訓練資料，讓小模型在多項評測同步成長，而非只在單一任務上刷分。

這個流程最值得我們觀察的，是它刻意區分「知識密集型」與「推理密集型」兩類種子任務，並在混入後期訓練時謹慎平衡各任務比例。消融實驗清楚顯示，加入上下文的版本讓GPQA-Diamond CoT從34.85提升至45.96，差距超過11個百分點。這告訴我們：合成資料的品質不只靠生成量，更靠結構設計——廣泛覆蓋約70個公開任務、700個子任務，正是防止模型過度擬合到特定評測風格的關鍵。程式碼能力、常識理解、推理能力多個維度同步提升，說明任務覆蓋的廣度本身就是一種防過擬合的設計。另一個值得記住的細節是：答案應儲存語意文字而非選項代號，讓模型真正學到語意理解，而非選項位置的記憶。

如果你正在為自己的模型或應用補充合成訓練資料，可以先問一句：我的任務種子夠多元嗎，還是隻押注在單一能力維度上？

---

## 📅 原文資訊

- **發布時間**：2026-06-04T11:24
- **來源原文**：[https://huggingface.co/blog/nvidia/task-seeded-sdg](https://huggingface.co/blog/nvidia/task-seeded-sdg)

---

## 🔗 延伸閱讀

- [個性化AI模型的崛起：如何為您的企業量身定制智能](https://judyailab.com/zh-tw/posts/rise-of-customized-ai-models/)
- [從交易想法到上線跑單：AI 輔助策略開發的真實流程](https://judyailab.com/zh-tw/posts/trading-concept-to-production-code-with-ai/)

