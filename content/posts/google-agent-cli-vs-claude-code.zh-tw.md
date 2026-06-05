---
title: Google Agent CLI vs Claude Code：兩大AI助手對決
date: "2026-05-25T18:06:11+00:00"
draft: false
author: Judy
summary: Google Agents CLI與Claude Code常被拿來比較，但其實它們不是同類工具——前者是讓Agent符合企業上線標準的SOP手冊，後者是動手寫程式的執行者。本文深入解析兩者在定價結構、核心功能與適用情境上的差異，幫開發者避開選擇盲點。
description: Claude Code月費20至200美元、Google Agents CLI開源免費，兩者定位卻截然不同。Claude Code是AI編碼執行者，Google Agents CLI是企業級Agent部署工具層。深入解析差異、價格與適用情境，幫你選對工具。
categories:
  - "AI 工程"
  - "產品"
tags:
  - "Claude Code"
  - "Google Agents CLI"
  - "AI Agent"
  - "AI編碼工具"
  - "開發者工具"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
faq:
  - q: "Google Agents CLI和Claude Code是哪一種工具？"
    a: "兩者定位不同——Claude Code是AI編碼助手，Google Agents CLI是Agent工程化標準工具，無法直接比較。"
  - q: "Claude Code多少錢？"
    a: "Pro方案每月20美元，Max方案每月100-200美元，視用量而定。"
  - q: "Google Agents CLI免費嗎？"
    a: "CLI本身開源免費，但部署到GCP雲端服務會產生費用，依據Cloud Run或GKE使用量計費。"
  - q: "該選哪個工具？"
    a: "若需AI幫你寫程式、改程式，選Claude Code；若要將Agent部署到企業正式環境，選Google Agents CLI。"
  - q: "可以同時使用兩個工具嗎？"
    a: "可以搭配使用——先用Claude Code寫Agent，再用Google Agents CLI做評估與部署上線。"
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
series:
  - "Claude Code 深度攻略"
---

> **TL;DR**：很多人以為Google Agents CLI是來跟Claude Code對打的，但細看官方定位會發現——它根本不是另一個AI編碼助手，而是要讓所有編碼助手都「變專業」的工具層。Claude Code是手術刀型的執行者（Pro月費20美元、Max要100-200美元），Google Agents CLI開源免費，但目的是賦能其他工具開發Agent。選哪個取決於你要AI做什麼。

## 一個被誤讀的對決

「Google Agent CLI vs Claude Code」這個題目本身就有問題。

業界普遍把這兩個東西放在一起比較，好像它們是同型別的競爭者。但實際上去看 Google 在 2026 年釋出的 Agents CLI 官方 repo 第一句就寫得很清楚——「不是另一個 AI 編碼助手，而是讓所有編碼助手變成 AI Agent 專家的工具」[原文 [GitHub google/agents-cli README](https://github.com/google/agents-cli)]。

換成生活的比喻：Claude Code 是廚師，Google Agents CLI 不是另一個廚師，是廚師背後的「中央廚房 SOP + 出餐前檢查 + 上菜流程」。

具體一點：Claude Code 你叫它「重寫這個 5000 行的 legacy code」它馬上動手。Google Agents CLI 不寫程式，它做兩件事——**評估**（看你已經寫好的 Agent 跑起來品質如何）跟**部署**（把驗證過的 Agent 推到 Google Cloud 正式環境跑）[參考 [Google Developers Blog 介紹 ADK](https://developers.googleblog.com/en/agent-development-kit-easy-to-build-multi-agent-applications/) 跟 [Google Cloud Blog Agent Executor 文章](https://cloud.google.com/blog/products/ai-machine-learning/agent-executor-googles-distributed-agent-runtime)]。

簡單講：Claude Code 是把程式碼寫好的那個人，Google Agents CLI 是教 Claude Code（或其他編碼助手）「怎麼把 Agent 做得符合企業正式上線標準」的那本 SOP 手冊。

## 價格結構不對等，混在一起比會誤導

這兩個工具的收費邏輯也不一樣。

Claude Code走訂閱制——Pro方案每月20美元但用量有限，重度使用者得訂Max方案，每月100-200美元[參考 [Anthropic Claude Code 官方定價](https://www.anthropic.com/pricing#claude-code)]。如果你每天用AI寫程式寫到很重，200美元不是小錢，但跟一個資深工程師的時薪比還是便宜很多。

Google Agents CLI是開源的，本身不收錢。但要記得——它要部署到Cloud Run、GKE上面那段才是真正花錢的地方，這部分走GCP計費。所以「Google免費vs Claude收費」這種比較其實沒看到全貌。

同樣常被拿來放在一起比的還有 Gemini CLI、Codex CLI，定位又不一樣，定價結構這個賽道每隔半年就換一次，去年比的結論今年常常已經不適用。

## Claude Code的強項：手術刀型執行者

如果你的需求是「我要AI幫我寫程式、改程式、修bug」，這就是Claude Code的主場。

它被描述為「2026年最強的終端AI寫程式工具」——多檔案重構、架構推理、複雜除錯，精準度顯著超出市場同類產品（業界普遍觀察）。再加上本地優先執行、深度程式碼理解能力、原生終端機體驗，特別適合維護大型或舊有程式碼庫、高隱私要求的專案、偏好CLI工作流程的開發者（社群整理）。

換句話說，Claude Code不是萬能。它就是一把手術刀。你叫它幫你做品牌策略，它做不來。但你叫它把一個5000行的legacy code改乾淨，它是目前市場上的第一選擇之一。

## Google Agents CLI的強項：把Agent從「能跑」變「能上線」

Google Agents CLI的價值不在寫程式，在工程化。

官方檔案裡有個示範流程——開發者只說一句「我要一個壓縮文字的 Agent」，編碼助手（注意，是 Claude Code / Codex / Gemini CLI，不是 Google CLI 本身）就會啟動工作流程，反問你要部署到哪、有沒有安全限制，然後自動建立專案結構、裝相依套件、把測試跟評估方法都附上 [參考 [Google Developers Blog ADK 介紹](https://developers.googleblog.com/en/agent-development-kit-easy-to-build-multi-agent-applications/)]。

重點在「包含測試與評估集」這幾個字。很多人用AI寫Agent寫到一個demo跑得起來就好，但demo跟正式上線之間，差的是評估、監控、部署、回滾、機密管理——這些Google Agents CLI把它包成了一套標準。

## 那到底要選哪個？

說實話這題沒有一個答案。

要寫程式、debug、改架構，Claude Code（搭配Pro或Max）。要把已經寫好的Agent推上Cloud Run變成可監控、可評估的正式服務，Google Agents CLI可以接在後面。如果只是要探索、低用量試玩，Gemini CLI的免費額度比Claude Code大很多——所以業界開始有人在用「Gemini CLI探索、Claude Code執行」這種雙工具策略（業界普遍觀察）。

這三個東西不是互斥的。把它們當成同一條產線的不同站，比較不會選錯。

---

被誤讀的對決，答案常常是「兩個都用，但用在不同的地方」。