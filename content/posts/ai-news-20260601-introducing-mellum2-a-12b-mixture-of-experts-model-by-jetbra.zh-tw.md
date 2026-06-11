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
faq:
  - q: "Mellum2 跟 GPT-4、Claude 這種前沿大模型差在哪？該選哪個？"
    a: "Mellum2 不是要取代前沿大模型，定位是多模型協作系統中的「焦點模型」，專做高頻輕量任務如提示分類、工具選擇、RAG 上下文壓縮、程式碼補全。需要深度推理、跨領域知識或多模態，仍要用 GPT-4 或 Claude；但在每秒呼叫數百次的中介節點，用 Mellum2 可以大幅降本而不犧牲體驗。"
  - q: "Mellum2 有 120 億參數，為什麼推論速度反而比同級模型快兩倍？"
    a: "關鍵在混合專家架構（MoE）。模型總參數雖有 120 億，但每次推論只啟動其中 25 億個活躍參數，路由機制會根據輸入選擇對應的專家子網路。實際運算量等同 25 億參數模型，記憶體佔用卻保留 120 億的知識容量，因此推論速度快、部署成本顯著降低。"
  - q: "Mellum2 採用 Apache 2.0 授權，企業可以拿來商用嗎？有什麼限制？"
    a: "可以商用、可以閉源修改、可以重新散布，這是最寬鬆的開源授權之一。需保留原始授權聲明與版權標示即可，無權利金。模型權重已開放於 HuggingFace 下載，搭配技術報告（arXiv 2605.31268）即可在私有環境部署，處理內部程式碼與機密資料不需外送 API。"
  - q: "Mellum2 不支援多模態，這是缺點嗎？什麼情境會用不到？"
    a: "刻意排除多模態是設計取捨，不是缺陷。若你的任務涉及圖片理解、PDF 解析、語音轉錄，Mellum2 完全不適用。但在純文字與程式碼場景（API agent、code review、RAG 摘要、log 分析），拿掉多模態反而讓架構更精簡、推論更快。先確認任務模態再選型，別盲目追求全能模型。"
  - q: "我已經在用 GPT-4 跑 Agent，怎麼判斷哪些節點該換成 Mellum2？"
    a: "列出 Agent 流程中每個 LLM 呼叫節點，標註三個指標：呼叫頻率、輸入長度、是否需要跨領域推理。高頻、短輸入、單一任務（如「判斷使用者意圖屬於哪一類」、「壓縮這段檢索結果」）是首選替換目標。需要規劃複雜步驟或寫長文的節點仍保留旗艦模型，這種混合策略通常能砍掉六成以上推論成本。"
  - q: "Mellum2 在程式碼補全上跟 Codex、CodeLlama 比起來如何？"
    a: "Mellum2 在程式碼生成、推理、數學等基準測試上達到同規模開源模型的競爭水準，並非全面領先。優勢在 MoE 架構帶來的推論速度與部署成本，適合 IDE 內嵌補全、CI 流程的程式碼審查這類延遲敏感場景。若追求單純的程式碼生成準確度上限，仍要評估 Codex 或專用 fine-tune 模型。"
  - q: "Mellum2 適合自己部署在公司內部伺服器嗎？硬體門檻多高？"
    a: "適合，這正是 JetBrains 的設計目標之一。25 億活躍參數的實際運算需求遠低於 120 億稠密模型，單張 24GB 顯存的消費級 GPU（如 RTX 4090）即可推論，企業級 A100/H100 可支援多並發。配合 Apache 2.0 授權，內部程式碼、合約、客戶資料完全不外送，是合規敏感產業的務實選擇。"

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

## 參考來源

- [JetBrains 开源 Mellum2 模型：12B 参数，升级为 AI 智能体编程助手|jetbrains|it之家|AI_新浪科技_新浪网](https://finance.sina.com.cn/tech/digi/2026-06-02/doc-inhzyxft1717959.shtml)
- [JetBrains开源Mellum2模型：12B参数，升级AI智能体编程|调用|代码|工作流|人工智能模型|jetbrains_网易订阅](https://www.163.com/dy/article/KUE2EI770511B8LM.html)
- [JetBrains 开源 Mellum2 模型：12B 参数，升级为 AI 智能体编程助手 - IT之家](https://www.ithome.com/0/958/658.htm)
