---
title: "三十億參數小模型上跑多智能體經濟系統 Thousand Token Wood 實戰報告"
date: "2026-06-06T00:05:09+00:00"
draft: false
author: Judy
summary: "AI 新聞快訊：「千代木」（Thousand Token Wood）是一個提交給 Build Small Hackathon 的多智能體經濟模擬系統，採用 Qwen2.5-3B 小型模型，驅動五隻森林動物角色在虛構市場內交易五種商品換取石子貨幣。整個系統以 vLLM 部署在 Modal 上，前端使用 Gradio，..."
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
news_source_url: "https://huggingface.co/blog/build-small-hackathon/thousand-token-wood-sim"
news_pipeline_version: "v1-rss-only"
commentary_engine: "hermes-v1"
---

## 📰 重點摘要

> 「千代木」（Thousand Token Wood）是一個提交給 Build Small Hackathon 的多智能體經濟模擬系統，採用 Qwen2.5-3B 小型模型，驅動五隻森林動物角色在虛構市場內交易五種商品換取石子貨幣。整個系統以 vLLM 部署在 Modal 上，前端使用 Gradio，每回合僅需一次批次 GPU 呼叫即可完成所有角色的決策，讓連續模擬在成本上可行。

技術團隊發現，若市場沒有人為設計的稀缺性機制，生產過剩會讓交易誘因消失，因此加入三道限制：每餐只能吃一單位同類食物、食物會腐爛不能囤積、冬季柴火需求暴增但只有一名供應者。這三條規則直接催生了泡沫與崩盤——以1929銀行擠兌為原型的場景中，角色Oona拋售蜂蜜換取石子，導致蜂蜜價格在數回合內從10跌至3；柴火則因冬季危機從4漲至7。

15回合測試中，75次 API 呼叫達到 100% 有效 JSON 輸出，每回合成交3至9筆，基尼係數從0.14擴大至0.38，財富差距自然浮現。模型雖然JSON格式穩定，但經濟推理較弱，解法是在提示詞中明確列出角色生產物、禁止購買清單、缺貨列表及範例，而非換用更大的模型——作者核心結論是「結構優於規模」。

---

## 💬 JudyAI Lab 觀點

千代木用Qwen2.5-3B小模型跑出了泡沫與財富分化，它告訴我們一件反直覺的事：不需要更大的模型，只需要更好的規則設計。

系統能讓蜂蜜在數回合內從10跌至3、柴火從4漲至7，靠的不是模型的經濟推理能力，而是三條人設的稀缺規則——食物腐爛、每餐限量一單位、冬季只有一名供應者。這讓角色產生了真實的交易誘因，也讓泡沫自然浮現。提示詞裡明確列出每個角色的生產物、禁止購買清單與缺貨清單，75次API呼叫達到100% JSON有效輸出，基尼係數從0.14擴大至0.38，財富分化無需設計就出現了。我們觀察這個案例的重點在於：當多Agent系統行為不如預期，先收緊環境約束、把提示詞寫具體，而不是急著換更大的模型。

如果你正在設計多Agent流程，試著問一個問題：拿掉所有外部限制後，Agent之間還有理由彼此互動嗎？答案往往藏在規則設計裡，不在模型大小。

---

## 📅 原文資訊

- **發布時間**：2026-06-05T22:18
- **來源原文**：[https://huggingface.co/blog/build-small-hackathon/thousand-token-wood-sim](https://huggingface.co/blog/build-small-hackathon/thousand-token-wood-sim)

---

## 🔗 延伸閱讀

- [2026 開源 LLM 實戰：我們為何在 AI 團隊中選 MiniMax M2.7](https://judyailab.com/zh-tw/posts/open-source-llm-agent-team-2026/)
- [如何在 AgenticTrade 上架你的 AI API — 5 分鐘快速指南](https://judyailab.com/zh-tw/posts/how-to-list-ai-api-on-agentictrade/)

