---
title: "NVIDIA Cosmos 3 開源首款全模態物理AI推理與行動模型"
date: "2026-06-01T06:05:08+00:00"
draft: false
author: Judy
summary: "AI 新聞快訊：NVIDIA 發布 Cosmos 3，一款針對「Physical AI」設計的開放式全模態世界基礎模型（World Foundation Model），最大特點是將影像生成、物理推理與動作輸出整合進單一架構，取代過去需分別部署的 Cosmos Predict、Transfer、Reason、Poli..."
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
news_source_url: "https://huggingface.co/blog/nvidia/cosmos-3-for-physical-ai"
news_pipeline_version: "v1-rss-only"
commentary_engine: "hermes-v1"
---

## 📰 重點摘要

> NVIDIA 發布 Cosmos 3，一款針對「Physical AI」設計的開放式全模態世界基礎模型（World Foundation Model），最大特點是將影像生成、物理推理與動作輸出整合進單一架構，取代過去需分別部署的 Cosmos Predict、Transfer、Reason、Policy 等多個獨立模型。

Cosmos 3 採用混合轉換器（Mixture-of-Transformers，MoT）骨幹，透過兩條並行處理流運作：自回歸（AR）序列負責推理與理解，擴散（DM）序列負責迭代去噪生成，兩者雖使用獨立參數，但透過共享注意力機制互相交互，可同時處理文字、影像、視訊、音訊與動作等多種模態。

模型推出兩個版本：Cosmos 3 Nano 配備 8B 推理器加 8B 生成器，定位工作站級硬體（如 RTX PRO 6000）；Cosmos 3 Super 擴充至 32B 加 32B，面向 NVIDIA Hopper 與 Blackwell 高階 GPU，適合大規模合成資料生成與研究。應用場景涵蓋機器人操控、自動駕駛、倉儲安全與智慧空間。模型已上架 Hugging Face，整合至 Diffusers 框架的 `Cosmos3OmniPipeline`，並同步開源六套涵蓋機器人、物理模擬、駕駛、倉儲、空間推理及人體動作的合成訓練資料集。

---

## 💬 JudyAI Lab 觀點

NVIDIA將過去需分別部署的多個AI模型整合進單一架構，這個設計哲學的根本轉變，值得所有在打造AI系統的人認真關注。

Cosmos 3最值得拆解的不是引數規模，而是它的雙流架構設計——自回歸序列負責推理理解，擴散序列負責迭代生成，兩者透過共享注意力機制互動，讓文字、影像、視訊、音訊與動作在同一模型內流通。這代表業界正在從「多個專用模型拼接」走向「原生多模態單架構」，系統複雜度降低，潛在的推論效率也跟著改變。另一個值得注意的是，NVIDIA同步開源了六套合成訓練資料集，涵蓋機器人、駕駛、倉儲等場景——對沒有大量真實標註資料的開發者來說，這是訓練AI的新資源入口。

如果你正在設計任何「感知→推理→輸出」流程的AI應用，建議去HuggingFace翻一下Cosmos3OmniPipeline的架構檔案，看看這套整合邏輯能否給你的系統帶來新的設計靈感。

---

## 📅 原文資訊

- **發布時間**：2026-06-01T04:44
- **來源原文**：[https://huggingface.co/blog/nvidia/cosmos-3-for-physical-ai](https://huggingface.co/blog/nvidia/cosmos-3-for-physical-ai)
---

## 🔗 延伸閱讀

- [個性化AI模型的崛起：如何為您的企業量身定制智能](https://judyailab.com/zh-tw/posts/rise-of-customized-ai-models/)
- [從交易想法到上線跑單：AI 輔助策略開發的真實流程](https://judyailab.com/zh-tw/posts/trading-concept-to-production-code-with-ai/)
