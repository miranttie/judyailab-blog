---
title: Tether 做 AI 了 — QVAC Fabric 讓你用手機訓練大型語言模型
date: "2026-03-17T14:00:00+00:00"
draft: false
author: Judy
summary: Tether 推出 QVAC Fabric LLM 框架，實現史上首次在手機上完成大型語言模型微調。該框架整合 LoRA、BitNet 與 Vulkan 運算，不需雲端伺服器即可本地訓練 AI 模型，為開發者與企業提供隱私優先、成本極低的 AI 解決方案。
description: 全球最大穩定幣 USDT 母公司 Tether 推出革命性 QVAC Fabric 框架，實現史上首次在手機上微調大型語言模型。結合 LoRA 高效微調、BitNet 1-bit 參數量化與 Vulkan 跨平台運算，讓 AI 從雲端走向個人裝置，打造真正的去中心化 AI 時代。
categories:
  - "AI 工程"
  - "產品"
tags:
  - "Tether"
  - "QVAC Fabric"
  - "Edge AI"
  - "LoRA"
  - "BitNet"
  - "手機 AI"
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "QVAC Fabric 是什麼？"
    a: "QVAC Fabric 是 Tether 推出的開源框架，可讓手機直接微調大型語言模型，實現真正的本地端 AI 訓練。"
  - q: "手機真的能訓練 LLM 嗎？"
    a: "可以。QVAC Fabric 透過 Dynamic Tiling 技術解決手機記憶體限制，在 Qualcomm Adreno 830 顯示晶片上約 13 小時完成微調。"
  - q: "QVAC Fabric 使用什麼技術？"
    a: "整合 LoRA 高效微調、BitNet 1-bit 參數量化，以及跨平台的 Vulkan GPU 運算介面。"
  - q: "BitNet 有什麼優勢？"
    a: "BitNet 將模型參數從 16-bit/32-bit 壓縮至僅 3 個值（-1、0、+1），大幅降低記憶體需求，讓手機也能跑大模型。"
  - q: "QVAC Fabric 對開發者有何幫助？"
    a: "開發者可在個人裝置上免費微調模型，保護資料隱私，大幅降低 AI 開發成本與門檻。"
hidden: true
ShowToc: true
TocOpen: true
image: []
alt: Tether QVAC Fabric 手機端 AI 訓練框架
series:
  - "AI 工具深度評測"
lastmod: 2026-05-13T04:29:42+00:00

---

> **TL;DR**：Tether（USDT 母公司）推出 QVAC Fabric，實現史上首次在手機上完成 LLM 微調。透過 LoRA + BitNet 1-bit 量化 + Vulkan 跨平台運算，Qualcomm Adreno 830 約 13 小時就能完成微調，讓隱私優先的本地 AI 訓練成為可能。

## 做穩定幣的 Tether，怎麼突然搞起 AI 了？

如果你跟我一樣有在關注 AI 跟加密貨幣的交叉領域，最近這則新聞應該有讓你停下來想了一下。

Tether — 對，就是那個 USDT 的 Tether — 推出了一個叫 **QVAC Fabric LLM** 的東西。簡單一句話講就是：**你現在可以在手機上微調大型語言模型了。**

不是跑推論而已，是真的訓練。在手機上。

我第一反應也是「蛤？」但看完技術細節之後，覺得這件事比表面看起來的有意思很多。

---

## QVAC Fabric 到底是什麼？

先講它解決了什麼問題。

現在要微調一個 LLM，你通常需要：一張 A100 或 H100 GPU、一個雲端帳號（AWS/Azure/GCP）、然後把你的資料上傳到別人的伺服器上。

對大公司來說這不是問題，但對個人開發者或中小企業？成本高、隱私風險大、而且你完全依賴雲端服務商。

QVAC Fabric 的做法是把整個微調流程搬到本地裝置上。它做了幾件關鍵的事：

### 1. 把 LoRA 塞進 llama.cpp

[LoRA](https://arxiv.org/abs/2106.09685)（Low-Rank Adaptation）是目前最流行的高效微調方法 — 不動原始模型的權重，只額外加一小組可訓練參數。QVAC Fabric 是第一個把完整 LoRA 微調直接整合進 llama.cpp 執行環境的框架。

這代表你不需要 PyTorch、不需要 CUDA，只靠 llama.cpp 就能跑微調。

### 2. 用 Vulkan 取代 CUDA

這是最聰明的設計決策之一。

CUDA 只能跑在 NVIDIA 的 GPU 上。但 [Vulkan](https://www.vulkan.org/) 是跨平台的 GPU 計算介面，NVIDIA、AMD、Intel、Apple Silicon、Qualcomm Adreno 全部都支援。

**一套程式碼，所有硬體都能跑。** 手機、筆電、桌機、伺服器，同一個 pipeline。

### 3. Dynamic Tiling 解決手機記憶體瓶頸

手機 GPU 的記憶體通常只有幾 GB，根本塞不下完整的矩陣運算。QVAC Fabric 的解法是 **Dynamic Tiling** — 把大型矩陣運算拆成小塊，依序處理再組裝結果。

犧牲一點速度，但換來的是：**手機真的能跑起來。**

---

## 實際跑起來多快？

這是我最關心的數據：

| 裝置 | 微調時間 |
|------|---------|
| NVIDIA RTX 4090（桌機 GPU） | 約 45 分鐘 |
| Qualcomm Adreno 830（手機 GPU） | 約 13 小時 |

13 小時聽起來很久？但這是 **人類史上第一次在手機等級的 GPU 上完成 LLM 微調**。而且是你睡一覺起來就好了。

品質方面，他們的 benchmark 結果跟 PyTorch 在業界標準測試上不相上下，某些指標甚至稍微好一點。

---

## BitNet 1-bit：讓 AI 模型瘦到不可思議

除了 LoRA 微調之外，QVAC 還整合了微軟的 [BitNet](https://arxiv.org/abs/2310.11453) 架構支援。

傳統 LLM 每個參數用 16-bit 或 32-bit 浮點數儲存。BitNet 把參數壓縮到只剩三個值：**-1、0、+1**。

效果是什麼？原本動輒幾 GB 甚至幾十 GB 的模型，記憶體用量可以大幅壓縮到一般手機都能負擔的程度。

QVAC 的 BitNet LoRA 框架號稱是全球第一個跨平台的實作 — 支援 Llama3、Qwen3、Gemma3 這些主流模型架構。

---

## 為什麼是 Tether？

你可能會問：一個做穩定幣的公司為什麼要做 AI 框架？

其實 Tether 過去一年已經在佈局了。他們有一個叫 QVAC 的生態系，包含：
- **QVAC Workbench** — 本地 AI 工作站 app
- **QVAC Health** — 健康數據 AI
- **Genesis II** — 1480 億 token 的訓練資料集
- 現在加上 **QVAC Fabric** — 微調框架

Paolo Ardoino（Tether CEO）講得很直白：

> 「AI 不應該只被大型雲端平台控制。QVAC Fabric 讓個人和企業能在自己的條件下執行推論和微調強大的模型。」

這跟加密貨幣圈的核心精神其實是同一件事：**去中心化、自主權、不靠第三方。**

只是這次不是金融，是 AI。

---

## 這件事為什麼重要？我的觀點

我們團隊每天都在跟各種 AI 模型打交道 — Claude、Gemini、MiniMax，光是在不同模型之間分工配合就是一門學問。所以看到這個消息的時候，我想的不只是「酷」，而是這會怎麼改變整個生態。

**三個我覺得值得注意的方向：**

**第一，隱私。** 現在你把文件丟給 ChatGPT 分析，那些資料就上雲了。如果你能在自己的手機上跑一個微調過的模型，資料完全不出裝置 — 這對醫療、法律、金融領域是巨大的突破。

**第二，成本。** 現在微調一次模型在雲端可能花幾十到幾百美金。如果你的筆電就能做這件事，個人開發者和小團隊的門檻直接降到接近零。

**第三，個人化。** 每個人都能訓練一個只屬於自己的 AI — 用你自己的資料、你的寫作風格、你的專業知識。不是通用的 GPT，是 **你的** GPT。這其實就是我們團隊一直在做的事，只是我們現在用的是 API + prompt engineering + agent 架構。如果未來能在本地做到，很多玩法會完全不一樣。

---

## 現在能用了嗎？

可以。QVAC Fabric 已經以 Apache 2.0 開源授權釋出，你可以直接去 [GitHub](https://github.com/tetherto/qvac-fabric-llm.cpp) 下載。微調部分在 [qvac-rnd-fabric-llm-finetune](https://github.com/tetherto/qvac-rnd-fabric-llm-finetune) 這個 repo。Hugging Face 上也有預編譯的二進制檔和 adapter。

支援的模型包括 Llama3、Qwen3、Gemma3，涵蓋 iOS、Android、Windows、macOS、Linux 全平台。

不過說實話，現在這個東西的目標族群還是開發者。你需要對 llama.cpp 和模型微調有基本概念才玩得起來。但以開源社群的速度，我猜很快就會有人包成一鍵安裝的 app。

---

## 結論

Tether 做 AI 這件事，聽起來很跳 tone，但仔細想想其實很合邏輯 — 穩定幣要的是去中心化金融，QVAC 要的是去中心化 AI。底層哲學一模一樣。

而且他們不是畫大餅，是真的把東西做出來了、開源了、benchmark 跑出來了。光是「手機上微調 LLM」這一點，就已經是技術里程碑了。

AI 的未來不一定在雲端。可能就在你口袋裡。

---

*延伸閱讀：*
- [Tether 官方公告](https://tether.io/news/tether-data-introduces-qvac-fabric-llm-the-edge-first-llm-inference-runtime-and-generalized-llm-lora-fine-tuning-framework-for-modern-ai-models-on-heterogeneous-gpus-smartphones-laptops-and-server/)
- [QVAC 官方網站](https://qvac.tether.io/)
- [QVAC Fabric 技術深度分析](https://tether.io/blog/qvac-fabric-llm-marks-a-turning-point-in-ai-personalization-bringing-fine-tuning-from-data-centers-to-everyday-devices/)

延伸閱讀：[AI 推論定價完全解析 — 從免費到每百萬 Token 21 美元](/posts/ai-inference-pricing-guide/)從成本角度比較雲端與邊緣 AI 的取捨；[2026開源LLM實戰：我們為何選MiniMax M2.7](/posts/open-source-llm-agent-team-2026/)分享了在受限預算下選模型的實戰經驗；[具身智能：AI Agent 從螢幕走進真實世界](/posts/embodied-ai-agents-to-robots/)是邊緣 AI 趨勢的延伸討論。


<!-- product-cta -->
{{< product-cta product="course" >}}

我們在 Judy AI Lab 持續追蹤邊緣 AI 與本地微調的進展，未來會把這類技術整合進我們的 agent 架構，分享更多實戰心得給大家。
