---
title: "EVA-Bench Data 2.0 評測基準發布：涵蓋3大領域、121項工具與213個測試場景"
date: "2026-06-04T18:06:20+00:00"
draft: false
author: Judy
summary: "AI 新聞快訊：ServiceNow AI 研究團隊發布 EVA-Bench Data 2.0，這是一套專為語音 Agent 設計的企業級評測基準，此次大幅擴充規模，從原本單一領域擴展為三大企業場景：航空客服管理（CSM）、企業 IT 服務管理（ITSM），以及醫療人力資源服務交付（HRSD）。三個領域合計涵蓋 2..."
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
news_source_url: "https://huggingface.co/blog/ServiceNow-AI/eva-bench-data"
news_pipeline_version: "v1-rss-only"
commentary_engine: "sonnet-v1"
recovered_at: "2026-06-07T13:09:08.278030+00:00"
---

## 📰 重點摘要

> ServiceNow AI 研究團隊發布 EVA-Bench Data 2.0，這是一套專為語音 Agent 設計的企業級評測基準，此次大幅擴充規模，從原本單一領域擴展為三大企業場景：航空客服管理（CSM）、企業 IT 服務管理（ITSM），以及醫療人力資源服務交付（HRSD）。三個領域合計涵蓋 213 個評測情境與 121 種工具，場景覆蓋量較初版提升約四倍。按領域拆分，航空場景有 50 個、ITSM 80 個、HRSD 83 個。

這套基準特別強調語音場景的現實性，每一筆資料均以實際電話客服流程為出發點篩選，工具 schema 參照生產環境 API 規格建模。醫療 HRSD 領域更深入對接美國真實醫療政策，納入 NPI 醫師識別號、FMLA 家庭假法規及保險覆蓋規則等細節，確保評測場景與從業者的實際工作情境一致。所有 213 個情境均經三款前沿模型——OpenAI GPT-5.4、Google Gemini 3.1 Pro 以及 Anthropic Claude Opus 4.6——交叉驗證可解性，以確保基準具挑戰性且評測結果公平可信。

三個資料集已全數開源，可透過 HuggingFace Datasets 直接載入。團隊也預告即將推出多語言擴充版本，使評測範疇超越現有的純英語企業部署限制。資料集設計原則與生成流程細節在原文中有完整說明，可供有意自建評測資料集的開發者作為實作參考。

---

## 💬 JudyAI Lab 觀點

ServiceNow將語音Agent評測基準從單領域擴充套件至航空、ITSM、醫療三大企業場景並全數開源——在我們看來，這代表企業AI語音評測的標準化已從概念討論走向可實際落地的工具層。

這套基準最值得我們關注的設計原則，是「從真實電話客服流程出發篩選情境」，而非憑空擬題。這個取向反映出一個正在成形的共識：企業語音AI的評測若脫離實際業務流程，測出的分數往往無法預測生產環境表現。213個情境同時透過GPT-5.4、Gemini 3.1 Pro與Claude Opus 4.6三款模型的交叉驗證可解性，這種多模型共識設計確保基準兼具挑戰性與公平性，而不是隻對特定模型友善。醫療HRSD場景納入NPI識別號、FMLA假規、保險覆蓋規則等細節，也說明高合規領域的評測資料本身需要達到業務細節的密度門檻，才能真正測出有意義的差異。

如果你正在設計企業AI評測資料集，這套開源資料的情境生成流程檔案是可直接參考的起點——從業務流程逆推測試情境，比從模型能力維度正推更能暴露生產落差。

---

## 📅 原文資訊

- **發布時間**：2026-06-04T12:24
- **來源原文**：[https://huggingface.co/blog/ServiceNow-AI/eva-bench-data](https://huggingface.co/blog/ServiceNow-AI/eva-bench-data)

---

## 🔗 延伸閱讀

- [個性化AI模型的崛起：如何為您的企業量身定制智能](https://judyailab.com/zh-tw/posts/rise-of-customized-ai-models/)
- [從交易想法到上線跑單：AI 輔助策略開發的真實流程](https://judyailab.com/zh-tw/posts/trading-concept-to-production-code-with-ai/)

