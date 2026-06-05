---
title: "Google Agent CLI 實戰：5 個一人公司可照抄的雲端自動化食譜設計"
date: "2026-05-28T05:00:49+00:00"
draft: true
author: "Judy"
summary: "Google Agent CLI、Claude Code 這類雲端排程 Agent 陸續推出後，一人公司能不能真的把雜事丟給 AI？整理 5 個可複製的自動化食譜設計與選型邏輯。"
description: "從雲端排程 Agent 的趨勢切入，整理 Google Agent CLI 與 Claude Code 在 Gmail、Calendar、Drive、Sheets 與跨 Agent 交接的 5 個自動化情境，附選型邏輯、prompt 設計與權限/成本/重試 3 個常見踩坑，非工程師也能照抄。"
categories:
  - "AI 自動化"
tags:
  - "Google Agent CLI"
  - "Claude Code"
  - "Routines"
  - "AI Agent"
  - "自動化"
  - "一人公司"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
series:
  - "AI Agent 完全指南"
faq:
  - q: "Google Agent CLI 跟 Claude Code 有什麼差別？一人公司應該選哪個？"
    a: "Gemini CLI 是 Google 開源的終端機 AI agent，擅長串接 Gmail、Calendar、Drive 等 Google 生態服務；Claude Code 則定位在跨檔案理解與終端機編輯，本機開發場景較強。一人公司不需要二選一，建議讓 Gemini CLI 負責 Google 內部雜事，跨工具或需要程式判斷時交棒給 Claude Code，分工比硬選一個更實用。"
  - q: "雲端排程 Agent 跟 GitHub Actions 差在哪？什麼任務該丟雲端 Agent？"
    a: "GitHub Actions 適合 Build、Test、Deploy 這類步驟固定的 deterministic workflow；雲端排程 Agent 適合需要看內容判斷下一步的開放式任務，例如分類郵件、決定檔案歸到哪個專案。判斷標準很簡單：規則寫得完就用 Actions，寫不完、要靠語意判斷的才丟 Agent，否則 token 成本會失控。"
  - q: "Gmail 自動分類會不會把重要信誤刪或亂回？怎麼設計才安全？"
    a: "關鍵在 prompt 明確禁止破壞性動作。建議直接在指令寫「禁止刪信、禁止回信、禁止標為已讀」，只允許貼標籤；不確定的信件統一丟到「待判斷」標籤，不要強迫 Agent 分類。Calendar 排程同理，只產出建議草稿給你早上確認，不要讓 Agent 直接寄回覆，保留人工最後一道關卡。"
  - q: "用 Agent 跑 Drive 歸檔跟 Sheets 彙整，常見踩坑有哪些？"
    a: "三個最常見：權限給太寬導致 Agent 動到不該動的資料夾、prompt 沒給對比基準導致 Sheets 觀察寫得很空、開放式任務沒設 token 上限導致費用爆掉。建議 Drive 只給特定資料夾權限，Sheets 一定要餵「今天 vs 7 日均 vs 上週同日」對比數據，並在排程層設每日 token 預算與重試上限。"
  - q: "多個 Agent 要怎麼交接？需要架 message queue 嗎？"
    a: "不用。最土也最穩的方法是用檔案系統當信箱：A Agent 做完把結果寫成 markdown 丟到雲端資料夾，B Agent 每小時掃那個資料夾，看到新檔就接手。優點是任一邊壞掉，另一邊還看得到上一棒交了什麼，不會整條線斷掉沒紀錄，也不用維護額外的 event bus 基礎設施。"
  - q: "這套自動化食譜適合非工程師嗎？需要會寫程式才能照抄？"
    a: "適合。5 個食譜的核心是 prompt 設計與排程邏輯，不是寫程式。Gemini CLI 跟 Claude Code 都用自然語言操作，安裝後跟著官方文件設定排程觸發即可。非工程師最該專注的是把流程寫清楚：什麼情況要 Agent 動手、什麼情況丟回人工判斷，這比技術細節重要得多。"
  - q: "用雲端 Agent 跑這些雜事，每月成本大概多少？怎麼控制不失控？"
    a: "開放式任務的 token 用量很難精準估算，實際費用取決於信件量、檔案數與 prompt 複雜度。控制方法有三：在排程層設每次執行的最大 token 上限、prompt 明確要求「只回摘要不要逐封展開」、把 deterministic 步驟（如固定欄位填寫）改用 Apps Script 處理，只把真的需要判斷的部分留給 Agent。"

---

## 雲端 Agent 上線，一人公司的雜事終於有地方丟了

過去一年 AI CLI 工具爆量上線。Anthropic 的 Claude Code 從 IDE 端跨到終端機，官方 GitHub 上的安裝指南把它定位成「Anthropic 官方推出、跑在終端機裡的 agentic coding 工具」，可以理解整個 codebase、用自然語言完成編輯、跑 commands [Source: https://github.com/anthropics/claude-code]。Google 同期推出的 Gemini CLI 走同樣方向，官方倉庫描述為「直接從終端機把 Gemini 拉進你的 workflow」的開源 AI agent [Source: https://github.com/google-gemini/gemini-cli]。

這一波工具的共同方向是：不只是回答問題，而是**真的可以被排程、被觸發、自己跑完一段流程**。對一人公司來說，這件事的意義跟工程師不太一樣。工程師看到的是 CI/CD，個人創作者看到的是——終於可以把那種「每天要做但不值得花腦袋」的雜事整包丟出去。

下面這 5 個食譜，是整理近期常見的設計方向。不是叫你照抄就一定能用，是給你一個「原來可以這樣分工」的對照組。

## 選型邏輯：什麼丟雲端 Agent、什麼留在本機 CLI

先講為什麼要分工，不是一個工具走到底。

雲端排程 Agent 適合的是**開放式任務**——需要判斷、需要看當下狀況決定下一步的那種；確定步驟、確定結果（Build、Test、Deploy）的 deterministic workflow，反而還是留給 GitHub Actions 那種傳統 CI 工具比較乾淨。Claude Code 官方文件把它定位成「在終端機裡跑、跨檔案 reasoning」的開發助手，預設是本機互動模式 [Source: https://docs.anthropic.com/en/docs/claude-code/overview]，要轉成雲端定時跑就要另外設計排程跟觸發機制。

換到一人公司的場景就是：

- **要看內容判斷怎麼做的**（分 Gmail、決定哪封信要回、Drive 檔案要歸到哪個專案）→ 適合丟雲端 Agent 排程
- **每天固定要產出某個格式報表的**（Sheets 彙整、固定欄位填寫）→ 也可以丟，但 prompt 要寫得很死
- **需要跨工具交接的**（這個 Agent 做完換另一個接手）→ 雲端跑比較不卡電腦

成本面要先講清楚：開放式任務容易讓 token 費用失控，這是設計食譜時的核心限制條件，後面踩坑章節會再展開。

## 食譜 1+2：Gmail 自動分類 + Calendar 智能排程

Gmail 分類是最值得第一個下手的，因為信箱是雜訊源頭。

設計邏輯很單純：每天早上一個固定時間觸發，Agent 去掃過夜未讀，按你給的規則打標籤——客戶詢價、合作邀約、訂閱電子報、垃圾。重點不在規則寫多細，重點在 **prompt 要告訴 Agent「不確定就先標待人工」**，不要強迫它分類。

Prompt 模板大概長這樣：

```
你是我的信箱助手。掃過去 24 小時未讀信件，
依以下規則貼標籤：
- 含報價/付款字眼 → [客戶]
- 含合作/邀約/媒體 → [合作]
- 含 unsubscribe → [電子報]
- 不確定 → [待判斷]

禁止刪信、禁止回信、禁止標為已讀。
完成後給我一份摘要：每類幾封、有沒有看起來很急的。
```

接到 Calendar 就是第二步：把標 [合作] 的信，從內文抓出對方提的時段，比對你的 Calendar 空檔，產一份「可回信時段建議」。**不要讓 Agent 自己回信**，把建議丟到一個草稿或 Notion 頁面，早上喝咖啡時掃過去決定就好。

這兩個串起來的設計目的，是把「打開信箱→看→分類→決定要不要排會議」這個流程從每天分散好幾次，變成早上集中處理一次。實際省下多少時間因人而異，重點是把碎片化的注意力切換收歸到單一時段。

## 食譜 3+4：Drive 自動歸檔 + Sheets 每日彙整

Drive 歸檔的痛點不是檔案多，是**下載完當下沒空整理，過兩週就找不到**。

設計邏輯：每晚跑一次，掃 Drive 根目錄跟「下載」資料夾，依檔名+內容判斷歸到哪個專案資料夾。同樣的，**不確定的不要動，丟到「待整理」資料夾**讓你自己看。

Sheets 彙整是另一種需求：每天固定把幾個來源的數據（GSC、營收、社群數字）彙整到一張表。這個其實用 GitHub Actions + Apps Script 更穩，但如果你想要「順便寫一段觀察」，那就值得用 Agent——它會看到數字後面的故事，不是只填欄位。

Prompt 重點是給它**對比基準**：「今天 vs 7 日均、vs 上週同日」，不要只丟今天數字進去，它會講不出重點。

## 食譜 5：跨 Agent 交接，把「我家 AI」變成一個團隊

這是最值得分享的一個設計思路。

多 Agent 協作的概念，是讓不同 Agent 各自跑在不同模型上、負責不同領域——技術、行銷、內容、產品、QA。同樣的邏輯放回個人 workflow，就是：**不用一個 Agent 包山包海，可以讓 Google Gemini CLI 做擅長的 Google 生態事，跨工具的部分交棒給 Claude Code**。

交接方式其實很土但很有用：**用檔案系統當信箱**。

A Agent 做完，把結果寫成一份 markdown 丟到雲端某個資料夾；B Agent 設定每小時掃那個資料夾，看到新檔就接手下一步。沒有複雜的 message queue，沒有 event bus，就是檔案進、檔案出。

這個架構好處是——任一邊壞掉，另一邊還是看得到「上一棒交了什麼給我」，不會整條線斷掉沒紀錄。

另一個值得搭配的習慣，是在每個專案根目錄放一份規範檔。以 Claude Code 為例，官方文件把 `CLAUDE.md` 定位成專案層級的記憶檔，會被自動讀進 context，用來放專案偏好、慣例、過往決議 [Source: https://docs.anthropic.com/en/docs/claude-code/memory]。Gemini CLI 也有對應的 `GEMINI.md` 機制做為 hierarchical instructional context [Source: https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/configuration.md]。這對跨 Agent 交接尤其重要，等於是你團隊共用的 SOP 檔。

## 踩坑紀錄：權限、成本、失敗重試

這三件事，是雲端 Agent 上線後最常被回報的卡關點：

**權限**：Agent 第一次跑 Gmail/Drive 要 OAuth 授權，這步驟非工程師會卡住。建議第一次設定時錄一段自己的螢幕，下次要重設或換帳號才不用重摸索。授權範圍**只給最小必要**——能用 read-only 就不要給寫入。

**Token 成本**：開放式任務容易失控。同一個 Agent 如果 prompt 沒寫清楚邊界，會反覆讀檔、反覆思考。建議 prompt 最後一定加一句「最多執行 N 步，超過就停下來給我報告」。

**失敗重試**：排程 Agent 跑掛了不會自動重來，**要自己設一個健康檢查**——例如另一個簡單 cron 每天看「今天該產的報表有沒有產出」，沒有就推一則通知到 Telegram 或 Slack。不要等到一週後才發現某個排程靜悄悄死掉了。

## 非工程師照抄的最小起手式

如果只想先試一個，從 Gmail 分類開始就好。不要五個一次上。

設定流程大概是：訂閱方案開好→把上面那個 Gmail prompt 丟進你選的 CLI →設一個每天早上 8 點的觸發→跑三天看標得準不準→不準就回去調 prompt。

調 prompt 的關鍵不是把規則寫得更細，是**把「不確定怎麼辦」寫清楚**。AI 最怕的不是不會做，是不知道什麼時候該停手問你。

工具年年換，把判斷成本從每天分散變成集中處理，這個動作本身就值得做。

以上是近期觀察到的雲端 Agent 食譜設計方向，搭配自己的 workflow 調整再上線。