---
title: "NVIDIA Cosmos 3 Open Sources First Full-Modality Physical AI Reasoning and Action Model"
date: "2026-06-01T06:05:08+00:00"
draft: true
author: Judy
summary: "AI News Flash: NVIDIA releases Cosmos 3, an open full-modality World Foundation Model designed for Physical AI, featuring integrated image generation, physical reasoning, and action output in a single architecture, replacing the previous separate deployment of Cosmos Predict, Transfer, Reason, Policy..."
description: "JudyAI Lab AI News Flash — Sourced from Hugging Face Blog — Covering the latest breakthrough in open full-modality world foundation models for Physical AI applications, including robotics, autonomous driving, warehouse safety, and intelligent spaces."
categories:
  - "AI News"
tags:
  - "AI News"
  - "Community"
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
news_source: "Hugging Face Blog"
news_source_url: "https://huggingface.co/blog/nvidia/cosmos-3-for-physical-ai"
news_pipeline_version: "v1-rss-only"
---

## 📰 Key Highlights

> NVIDIA releases Cosmos 3, an open full-modality World Foundation Model designed for "Physical AI", featuring integrated image generation, physical reasoning, and action output in a single architecture, replacing the previous separate deployment of Cosmos Predict, Transfer, Reason, Policy, and other independent models.

Cosmos 3 uses a Mixture-of-Transformers (MoT) backbone, operating through two parallel processing streams: autoregressive (AR) sequence for reasoning and understanding, and diffusion (DM) sequence for iterative denoising generation. While using independent parameters, both interact through shared attention mechanisms, capable of handling multiple modalities including text, images, video, audio, and motion simultaneously.

The model launches in two versions: Cosmos 3 Nano with 8B reasoner + 8B generator, targeting workstation-class hardware (like RTX PRO 6000); Cosmos 3 Super expands to 32B + 32B, targeting NVIDIA Hopper and Blackwell high-end GPUs, suitable for large-scale synthetic data generation and research. Application scenarios cover robotics manipulation, autonomous driving, warehouse safety, and intelligent spaces. The model is now available on Hugging Face, integrated into Diffusers' `Cosmos3OmniPipeline`, with six synthetic training datasets open-sourced covering robotics, physical simulation, driving, warehouse, spatial reasoning, and human motion.

---

## 💬 JudyAI Lab Viewpoint

> ⏳ Commentary To be added (by Hermes during finalize_commentary stage — must be fact-driven, no information fabrication)

---

## 📅 Source Information

- **Release Time**: 2026-06-01T04:44
- **Source**: [https://huggingface.co/blog/nvidia/cosmos-3-for-physical-ai](https://huggingface.co/blog/nvidia/cosmos-3-for-physical-ai)
---

## 🔗 延伸閱讀

- [個性化AI模型的崛起：如何為您的企業量身定制智能](https://judyailab.com/zh-tw/posts/rise-of-customized-ai-models/)
- [從交易想法到上線跑單：AI 輔助策略開發的真實流程](https://judyailab.com/zh-tw/posts/trading-concept-to-production-code-with-ai/)
