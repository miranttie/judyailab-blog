---
title: "Hermes 桌面版 30 分鐘上手：不碰終端機，用 ChatGPT 帳號直接跑你的第一個 AI 助理"
date: "2026-06-09T05:00:56+00:00"
draft: true
author: "Judy"
summary: "Hermes Agent Desktop v0.5.2實測，從零安裝到第一個任務30分鐘搞定。不用打指令、不用編YAML，圖形介面直接接ChatGPT帳號跑AI助理。附踩雷區跟主流桌面AI助理對照。"
description: "Hermes桌面版 v0.5.2實測心得：MIT開源、圖形化設定、支援OpenRouter/OpenAI/Anthropic/Ollama等。給不想碰終端機的solopreneur一個能跑MCP、能排程、能接外部工具的桌面AI助理選項。"
categories:
  - "AI 工具"
tags:
  - "Hermes Agent"
  - "AI 桌面助理"
  - "MCP"
  - "Solopreneur"
  - "ChatGPT"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
series:
  - "AI Agent 完全指南"
---

## 為什麼桌面版的出現比想像中重要

Hermes Agent在2026年5月30日發了v0.5.2桌面版，MIT授權，開源社群fathah維護 ([來源](https://github.com/fathah/hermes-agent))。乍看就是「把CLI包成GUI」這種事，但對solopreneur這群人，意義不一樣。

過去要在自己機器上跑一個能呼叫工具、能讀本地檔案、能排程的AI agent，前置作業就是一道牆——裝Python、設環境變數、編YAML、跑terminal。一個沒寫過程式的小老闆要他做這些事，他寧願多付ChatGPT Plus訂閱費。問題是ChatGPT網頁版讀不了你硬碟裡的Excel、看不到你昨天下載的合約PDF、沒辦法在半夜自動幫你整理email。

桌面版補的就是這一塊。Judy AI Lab觀察到，這波「本地端AI agent桌面化」是2026上半年很安靜但很重要的一條線——市面上各家主流模型廠商也陸續推出自家的桌面端方案，定位不太一樣，後面會拆給你看（各家產品名稱與功能請以官網為準）。

## 動手之前：三件事先確認

裝之前最容易卡住的不是裝本身，是前置條件沒對齊。

**系統需求**：v0.5.2支援macOS（Apple Silicon跟Intel都行）跟Windows 10/11，Linux目前要自己build ([來源](https://github.com/fathah/hermes-agent))。記憶體建議16GB起跳——不是Hermes本身吃多少，是你之後接Ollama跑本地模型會吃。

**模型帳號**：你要先決定用哪家。安裝完成後桌面版會跳一個下拉選單問你模型提供商，支援OpenRouter、OpenAI、Google Gemini、Anthropic（Claude）、Nous Portal，以及本地端的Ollama跟LM Studio ([來源](https://github.com/fathah/hermes-agent))。如果你已經有ChatGPT帳號，要注意的是——這裡填的是OpenAI API Key（在platform.openai.com拿），不是ChatGPT那個訂閱帳號。這兩個是兩回事，搞混的人很多。

**防毒設定**：Windows Defender對沒簽章的開源exe會直接擋下來。安裝前先把下載資料夾加白名單，不然你會看到一個「無法執行」的紅框然後不知道怎麼辦。

## 安裝過程：三十分鐘其實留很多餘裕

從GitHub Releases下載對應系統的安裝檔（macOS是.dmg，Windows是.exe），雙擊開啟，路徑保持預設就好。

第一次啟動，桌面版會自動偵測是不是已經有Hermes CLI設定檔，有的話直接沿用，不用重填 ([來源](https://github.com/fathah/hermes-agent))。沒有的話，會跳出設定精靈：選模型提供商、貼API Key、設定工作目錄（這個目錄是agent讀寫檔案的範圍，建議在使用者資料夾下開一個新的「Hermes-workspace」）。

設定完按儲存，主介面開出來會看到三塊：左邊是對話視窗、中間是即時工具輸出（叫streaming tool output，你會看得到agent正在做什麼）、右邊是檔案瀏覽器跟並排預覽 ([來源](https://github.com/fathah/hermes-agent))。

到這邊，安裝完成。實測時間大概15-20分鐘，剩下的時間留給「丟第一個任務」。

## 第一個真實任務：請它整理本週email

別丟玩具題目（什麼「寫一首詩」這種demo），solopreneur要的是真實工作流的價值。

我們建議第一個任務這樣下：「請讀取我Hermes-workspace底下的emails.csv，把這週收到的email按客戶、潛在合作、訂閱通知三類分好，輸出一個markdown摘要到summary.md」。

這個任務會同時驗證三件事：本地檔案讀取權限有沒有開、模型分類能力夠不夠、檔案寫入有沒有問題。Hermes會在中間欄即時顯示它讀了什麼、寫了什麼，你看得到整個過程不是黑箱。

第一次跑通了之後，下一步可以接MCP工具（Model Context Protocol，可以理解成AI跟外部工具溝通的標準插頭），把外部服務接進來，就不用每次手動匯出CSV了。

## 踩雷區：三個會卡住95%人的點

**登入失敗**：最常見不是API Key錯，是key前面有空格。複製貼上時要注意。第二常見是OpenAI那邊還沒儲值，免費額度用完了。第三常見是把ChatGPT訂閱帳號密碼填進API Key欄位——再說一次，這兩個不是同一個東西。

**模型切換沒生效**：在設定改完模型之後要按右上角重新載入（不是關掉重開應用程式），不然對話視窗還是吃舊的模型。

**本地檔案權限**：macOS會跳系統權限詢問，要在「系統設定→隱私權→檔案與資料夾」把Hermes加進去。Windows則是要確認工作目錄不是放在`Program Files`或`C:\Windows`底下，不然會權限不足。

## Hermes 桌面版的定位：選它的理由

| 項目 | Hermes Desktop | 一般閉源桌面助理 |
|------|---------------|----------------|
| 授權 | 開源MIT | 多為閉源 |
| 模型選擇 | 多家可切（OpenRouter/OpenAI/Anthropic/Gemini/Ollama 等） | 通常綁定單一廠商 |
| MCP支援 | 有 | 視產品而定 |
| 本地檔案 | 自訂工作目錄 | 通常受限 |
| 排程任務 | 有，自然語言設定 | 多數沒有 |
| 自架後端 | 可以當遠端遙控器 | 多數不行 |
| 適合誰 | 想換模型、想排程、想接自架後端 | 只用單一模型、追求簡單 |

([來源](https://github.com/fathah/hermes-agent))

如果你完全綁定單一模型廠商，直接用那家自己的桌面端最省事（各家產品名稱、功能與訂閱條件請以官網為準）。但如果你想保留「之後換模型不換工具」「想讓agent半夜自己跑」「想接自己VPS的後端」這些彈性，Hermes桌面版才補得到位。

## 接下來可以接哪些MCP工具

裝好之後第二週的功課，就是把MCP工具加進來。solopreneur最常見的使用場景，大致圍繞在筆記資料庫、郵件處理、行事曆排程、團隊通訊、以及本地檔案系統這幾類。各家MCP server的可用性跟支援度持續變動，建議直接看官方MCP生態目錄找對應自己工具鏈的server，截至撰文時請以官網清單為準。

Hermes桌面版相較於CLI的差別，是把原本要手動編輯YAML的設定改成圖形介面操作 ([來源](https://github.com/fathah/hermes-agent))，對不熟terminal的小老闆這層人，門檻會降下來。實際每一個MCP工具怎麼接，仍然要看該工具自己的安裝文件，不是Hermes全包。

安全部分提一下，要接外部服務的人，建議直接到專案的GitHub Releases頁面確認最新版本跟release notes ([來源](https://github.com/fathah/hermes-agent/releases))，把版本升到最新比較放心，避免吃到已知的安全漏洞。

## 

裝完之後別急著炫技，先讓它做一個會重複發生的小任務——整理email、把每週YouTube留言分類、把帳單PDF讀進來轉成表格。會重複的、煩人的、不需要靈感的，先交給它。

剩下的時間，你才有餘裕想自己真正想做什麼。