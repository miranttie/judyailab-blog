---
title: Claude Code 是什麼？2026 AI 編程助理完整新手指南
date: 2026-04-28 03:20:32+00:00
draft: false
summary: Claude Code 是 Anthropic 推出的終端機 AI 編程助理，能直接讀懂整個程式碼庫、編輯檔案、執行 shell 指令。本教學從安裝到實戰，帶你一步一步搞懂這款 AI 工具怎麼使用。只要學會下指令，就能用自然語言指揮 Claude Code 完成重構、修 bug、建測試等開發工作，大幅提升效率。
description: Claude Code 是 Anthropic 推出的 AI 編程助理，能在終端機直接讀寫程式碼、執行指令、完成跨檔案重構等開發工作。安裝只需一行指令，就能用自然語言指揮 AI 幫你寫 code、修 bug、建測試。適合想提升開發效率的工程師，以及想學習 AI 輔助編程的新手。
categories:
  - "教學"
  - "AI 工程"
tags:
  - "Claude Code 教學"
  - "AI 編程助理"
  - "Anthropic"
  - "終端機 AI"
  - "Claude Code 安裝"
  - "AI 開發工具"
ShowWordCount: true
faq:
  - q: "Claude Code 是什麼？"
    a: "Claude Code 是 Anthropic 推出的 AI 編程助理，直接在終端機運行，能讀懂整個程式碼庫、編輯檔案、執行指令，並自動完成開發工作流。"
  - q: "Claude Code 需要付費嗎？"
    a: "需要付費。你需要 Claude Max、Team 或 Enterprise 訂閱方案，或者使用 Anthropic API 金鑰搭配按量計費。"
  - q: "Claude Code 支援哪些作業系統？"
    a: "支援 macOS、Linux，以及透過 WSL 在 Windows 上運行。也提供 Web 版本和桌面應用程式。"
  - q: "Claude Code 跟 GitHub Copilot 有什麼不同？"
    a: "最大差異是 Claude Code 在終端機運行，能直接操作檔案系統和執行 shell 指令，處理跨檔案重構、專案建置等完整開發流程，而不只是行內自動補全。"
  - q: "不會寫程式的人能用 Claude Code 嗎？"
    a: "主要面向開發者。如果你完全沒有程式基礎，建議先從 Claude.ai 的對話介面開始，有基本終端機操作能力後再使用 Claude Code。"
keywords:
  - "claude code 是什麼"
  - "claude code 教學"
  - "claude code 介紹"
  - "ai 編程助理"
showToc: true
TocOpen: false
series:
  - "Claude Code 深度攻略"
lastmod: 2026-05-13T04:29:42+00:00

---

> **TL;DR**：Claude Code 是 Anthropic 打造的終端機 AI 編程助理，能直接讀懂你的整個程式碼庫、編輯檔案、跑指令。安裝只要一行 `npm install`，登入後就能在專案目錄裡用自然語言叫它改 code、修 bug、做重構。

## Claude Code 是什麼？

Claude Code 是什麼？簡單說，它是 Anthropic 推出的命令列（CLI）AI 編程助理。跟一般在瀏覽器裡貼程式碼問 AI 不同，Claude Code 直接跑在你的終端機裡，能存取整個專案的檔案結構、讀寫程式碼、執行 shell 指令，把「問 AI → 複製貼上 → 手動改」的流程壓縮成一句話完成。

它的官方定位是：

> Use Claude, Anthropic's AI assistant, right from your terminal. Claude can understand your codebase, edit files, run terminal commands, and handle entire workflows for you.

核心能力包括：

- **程式碼庫理解**：自動讀取專案結構與檔案內容，不需要你手動複製貼上
- **檔案讀寫**：直接建立、修改、刪除檔案，改完你確認就好
- **指令執行**：在終端機跑 build、test、git 等指令
- **MCP 擴充**：透過 Model Context Protocol 連接外部工具（資料庫、API、第三方服務）
- **多模型切換**：支援 Opus、Sonnet、Haiku 等不同模型，用 `--model` 參數切換

## 為什麼用？

**情境一：接手陌生專案**
你剛加入新團隊，面對幾萬行不熟悉的程式碼。在專案根目錄啟動 Claude Code，直接問「這個專案的架構是什麼？入口在哪？」，它會掃描整個目錄結構和關鍵檔案，給你結構化的回答。

**情境二：跨檔案重構**
要把某個函式改名，牽涉到 20 個檔案的引用。手動找 → 改 → 測試很痛苦。用 Claude Code 一句「把 getUserData 重新命名為 fetchUserProfile，所有引用一起改」，它會定位所有檔案、逐一修改、跑測試確認。

**情境三：自動化重複工作**
寫 commit message、產生測試案例、建立新的 API endpoint — 這些有固定模式但耗時間的工作，Claude Code 都能用自然語言指揮完成。搭配 `--print` 模式還能串進 CI/CD pipeline 做自動化。

## 怎麼用？（步驟教學）

### Step 1: 安裝 Claude Code

前置條件：需要 Node.js 18 以上版本。確認方式：

```bash
node --version
```

安裝 Claude Code：

```bash
npm install -g @anthropic-ai/claude-code
```

安裝完成後驗證：

```bash
claude --version
```

你會看到類似 `2.1.x (Claude Code)` 的版本號。

### Step 2: 登入認證

Claude Code 需要有效的訂閱或 API 金鑰。執行：

```bash
claude auth login
```

系統會引導你透過瀏覽器登入 Anthropic 帳號。登入後確認狀態：

```bash
claude auth status
```

成功會顯示你的帳號資訊和訂閱類型。

### Step 3: 在專案中啟動

切換到你的專案目錄，直接輸入：

```bash
cd your-project
claude
```

這會啟動互動式對話。你可以直接用自然語言跟它溝通：

```
> 這個專案的目錄結構是什麼？主要入口檔在哪？
```

```
> 幫我在 src/utils/ 建立一個日期格式化函式，支援 ISO 8601 和 Unix timestamp
```

```
> 跑一次測試，如果有失敗就修好它
```

如果只想執行單一指令不進入互動模式，用 `--print` 參數：

```bash
claude -p "列出這個專案所有的 TODO 註解"
```

想繼續上一次的對話，用 `--continue`：

```bash
claude --continue
```

或用 `--resume` 選擇歷史對話繼續：

```bash
claude --resume
```

## 常見錯誤與排查

### 錯誤 1: 安裝後找不到 claude 指令

**原因**: npm 全域安裝路徑不在系統 PATH 中。

**解法**: 執行 `npm config get prefix` 查看全域安裝路徑，確認該路徑的 `bin` 子目錄在你的 `PATH` 環境變數中。以 Linux 為例：

```bash
export PATH="$(npm config get prefix)/bin:$PATH"
```

將這行加入 `~/.bashrc` 或 `~/.zshrc` 以持久化。

### 錯誤 2: 認證失敗或 API 回傳 401

**原因**: 登入 token 過期，或使用的方案不包含 Claude Code 存取權限。

**解法**: 先確認認證狀態：

```bash
claude auth status
```

如果顯示未登入或 token 有問題，重新執行 `claude auth login`。確認你的帳號有 Max、Team 或 Enterprise 訂閱，或已設定有效的 API 金鑰。

### 錯誤 3: 啟動後回應很慢或 timeout

**原因**: 網路連線不穩，或專案太大導致初始化耗時。

**解法**: 用 `claude doctor` 執行健康檢查，它會診斷常見的連線和設定問題：

```bash
claude doctor
```

如果是大型專案，可以透過 `.claudeignore` 檔案排除不需要掃描的目錄（如 `node_modules`、`dist`）。

## 延伸閱讀

- [Claude Code Hooks 完全指南 — 讓 AI 自動化你的開發流程](https://judyailab.com/posts/claude-code-hooks-guide/)
- [從零開始建立 AI 多 Agent 團隊：我們的真實經歷與踩坑筆記](https://judyailab.com/posts/building-ai-agent-team/)
- [Claude Code 官方文件](https://docs.anthropic.com/en/docs/claude-code/overview)

## 結語

如果你是每天在終端機裡工作的開發者，Claude Code 值得花 10 分鐘裝起來試試。它最大的價值不是取代你寫程式，而是把那些「查文件、跨檔案搜尋、重複性修改」的時間壓縮掉，讓你專注在真正需要思考的設計和邏輯上。

下一步建議：裝好之後，在你最熟悉的專案裡啟動 Claude Code，先從「解釋這段程式碼」開始，感受它對你程式碼庫的理解力。等你確認它讀得懂你的專案，再開始讓它動手改東西。

## 關鍵數據

- 20 個檔案（跨檔案重構範例引用數）
- 10 分鐘（建議安裝試用時間）
- 5000 users (Threads + Newsletter 訂閱合計)
