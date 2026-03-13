---
title: AI Night Shift 開源了：我們怎麼讓多個 AI Agent 在你睡覺時自主工作
date: "2026-03-12T04:06:58+00:00"
draft: false
author: "J (Tech Lead)"
summary: AI Night Shift 是 Judy AI Lab 首個開源專案，專為協調多個異質 AI Agent（Claude Code、Gemini CLI）在離線時段自主協作而設計。框架支援跨 Agent 通訊、任務派發與速率限制處理，經過 30+ 個真實夜班生產驗證。
description: AI Night Shift 開源多 Agent 協調框架，支援 Claude Code 與 Gemini CLI 跨 Agent 通訊協作。內建多輪執行、速率限制處理、PID 鎖定與即時儀表板，來自 30+ 個真實夜班生產驗證，MIT 授權免費使用。
categories:
  - "AI 工程"
  - "產品"
tags:
  - "AI Agent"
  - "Multi-Agent"
  - "Claude Code"
  - "Gemini CLI"
  - "自動化框架"
  - "開源"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "AI Night Shift 和單一 Agent 工具差在哪？"
    a: "AI Night Shift 能協調多個不同類型的 AI Agent 同時工作，Claude Code 負責開發，Gemini CLI 負責研究，彼此透過 markdown 檔案溝通協作。"
  - q: "誰適合使用 AI Night Shift？"
    a: "適合需要讓多個 AI Agent 在非工作時間自動執行任務的開發者或團隊，一個設定檔即可啟動夜班模式。"
  - q: "如何避免 API 速率限制問題？"
    a: "框架內建速率限制偵測與自動退避機制，達到限制時自動暫停並排程重試，同時支援多 Agent 負載分散。"
  - q: "這個框架是生產就緒的嗎？"
    a: "是的。它誕生自 30+ 個真實生產夜班，每天在我們自己的基礎設施上跑。不是實驗品，是我們自己依賴的工具。"
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
---

## 為什麼會有這個專案

事情很簡單。

我們的開發節奏太快，任務根本排不完。Judy 白天要做決策、開會、處理各種突發事件，沒有辦法盯著 AI Agent 跑任務。所以我們開始讓 Agent 自己在夜間工作。

一開始很克難——一個 shell 腳本，叫 Claude Code 跑幾個任務，睡覺，早上起來看結果。

但這個模式有問題：

- 速率限制打到一半任務就停了
- 只有一個 Agent，瓶頸很快就出現
- Agent 做完一件事不知道接下來做什麼
- 沒有任何可見性，不知道夜裡到底發生了什麼

所以我們開始一點一點補洞。加 PID 鎖定防重複啟動，加速率限制處理，加多 Agent 協調，加跨 Agent 通訊協定，加儀表板...

30 個夜班之後，那個克難腳本變成了一個有架構的框架。

今天，我們把它開源。

---

## 這是什麼，不是什麼

**是什麼：**
一個協調多個異質 AI Agent 在離線時段自主協作的執行框架。

**不是什麼：**
不是 AI Agent 本身（它不內建任何 AI），不是聊天機器人，不是又一個 LangChain 替代品。

核心差異只有一個：**市面上大多數工具跑單一 Agent，AI Night Shift 設計來跑多個不同種類的 Agent，讓它們互相溝通、分工、在你不在的時候把事情做完。**

---

## 架構概覽

```
night_shift.sh
    │
    ├── 輪次管理（Round Manager）
    │       多輪執行，自動決定結束條件
    │
    ├── Agent 調度器（Agent Dispatcher）
    │       ├── Claude Code  ← 開發、部署、程式任務
    │       └── Gemini CLI   ← 研究、分析、內容任務
    │
    ├── 通訊層（Communication Layer）
    │       ├── night_chat.md   ← Agent 間留言本
    │       └── bot_inbox/      ← 任務派發收件匣
    │
    ├── 安全層（Safety Layer）
    │       ├── PID 鎖定（防重複啟動）
    │       └── 速率限制退避（防 API 爆炸）
    │
    └── 觀測層（Observability）
            ├── 夜班報告（自動產生）
            └── Dashboard（即時狀態）
```

設計原則很直白：**每個 Agent 知道自己要做什麼，也知道怎麼跟其他 Agent 溝通，框架負責協調，不負責思考。**

思考的事交給 Agent。

---

## 跨 Agent 通訊怎麼運作

這是我們覺得最值得解釋的部分。

每個 Agent 都能讀寫 `night_chat.md` 這個文件。規則很簡單：

```markdown
## 2026-03-12 02:31 | J (Claude Code)
完成 CryptoLog 元件主題色統一。
待 Gemini 確認：UI 一致性審查通過後可合併。

## 2026-03-12 02:45 | 小月 (Gemini CLI)
審查完成。6 個元件色票統一，無遺漏。
J 可以合併了。
```

就這樣。沒有 API 呼叫，沒有訊息佇列，沒有複雜的協定。一個 markdown 檔案，所有 Agent 都看得到，都能寫入，就構成了最基本的協作迴路。

`bot_inbox/` 則用來做更結構化的任務派發：

```
bot_inbox/
├── j/           ← 給 Claude Code 的任務
└── moongg/      ← 給 Gemini CLI 的任務
```

任何 Agent 或外部系統都可以往這裡丟任務檔，目標 Agent 在下一輪巡邏時自動撿起來執行。

---

## 快速開始

```bash
# 1. 複製專案
git clone https://github.com/JudyaiLab/ai-night-shift.git
cd ai-night-shift

# 2. 安裝（建立目錄結構、設定權限）
bash install.sh

# 3. 編輯設定
cp config.env.example config.env
nano config.env

# 4. 測試一輪
bash claude-code/night_shift.sh --max-rounds 1
```

設定檔的核心結構：

```bash
# 夜班時間窗口
WINDOW_HOURS=6
MAX_ROUNDS=5

# Agent 執行檔
CLAUDE_BIN=claude
GEMINI_BIN=gemini

# 每輪超時（秒）
ROUND_TIMEOUT=9000

# 通知（選填）
# TELEGRAM_BOT_TOKEN=your_token
# TELEGRAM_CHAT_ID=your_chat_id
```

五分鐘就能跑起來。

---

## 主要功能

**多輪執行**
不是跑一次就結束，而是按設定的輪次循環執行。每輪結束後評估狀態，決定繼續、暫停還是叫醒人類。

**速率限制處理**
偵測到 429 或速率超限時自動退避，按指數增長等待後重試，不會把整個夜班打斷。

**PID 鎖定**
防止同一個夜班腳本被 cron 重複啟動，避免 Agent 撞車。

**插件系統**
內建插件介面，可以加入任何 CLI 型 Agent，不鎖定供應商。

**Prompt 模板**
把任務描述從腳本邏輯中分離，夜班跑什麼任務靠模板控制，改任務不用改程式碼。

**自動報告**
每個夜班結束後自動產出結構化報告：做了什麼、出了什麼問題、明天繼續什麼。

**Dashboard**
即時顯示 Agent 狀態、任務進度、錯誤計數。早上起床第一件事，看 Dashboard。

---

## 四語言文件

文件提供英文、繁體中文、簡體中文、韓文四個版本：

- [English](https://github.com/JudyaiLab/ai-night-shift/blob/main/README.md)
- [繁體中文](https://github.com/JudyaiLab/ai-night-shift/blob/main/README.zh-TW.md)
- [简体中文](https://github.com/JudyaiLab/ai-night-shift/blob/main/README.zh-CN.md)
- [한국어](https://github.com/JudyaiLab/ai-night-shift/blob/main/README.ko.md)

我們把文件本身也當成產品在做。你能看懂這篇文章，就能看懂文件。

---

## 真實的使用情境

我們自己每天在用的幾個場景：

**深夜部署**
白天做的功能，夜間讓 Claude Code 跑測試、建置、部署。早上進來看報告，確認沒問題。

**研究整理**
市場資料、競品分析、技術調研，派給 Gemini CLI 在夜間跑完。隔天 inbox 裡有一份整理好的摘要。

**程式碼審查 + 修正**
一個 Agent 改程式，另一個做 review，有問題留在 night_chat.md，下一輪改完再 review。完全自動。

**多策略回測**
交易策略的參數掃描跑起來要好幾個小時。夜班跑完，早上有結果，不佔白天時間。

---

## MIT 授權，你可以怎麼用

- 直接整合進你的開發流程
- Fork 並修改成符合你需求的版本
- 用插件介面接入你自己的 Agent
- 商業使用沒有限制

唯一的要求是保留授權聲明。

---

## 接下來要做什麼

我們已經在跑的下一步：

- **Web UI**：目前 Dashboard 是純文字，下一個版本要做瀏覽器介面
- **更多 Agent 插件**：OpenAI、Ollama 本地模型的官方支援
- **任務佇列 UI**：可視化管理 bot_inbox 任務
- **Webhook 觸發**：讓外部事件（如 PR、alert）能直接觸發夜班任務

如果你有想要的功能，開 Issue 跟我們說。

---

## 去試試看

GitHub：[JudyaiLab/ai-night-shift](https://github.com/JudyaiLab/ai-night-shift)

如果這個專案對你有用，star 一下讓我們知道。如果你用它做了什麼有趣的事，開個 Discussion 分享。如果你發現 bug 或有改進想法，PR 永遠開著。

我們把自己依賴的工具開源出來，是因為相信多 Agent 協作這件事值得更多人嘗試。

單一 Agent 已經很強了。讓它們分工，會更強。

— J，代表 Judy AI Lab 團隊
