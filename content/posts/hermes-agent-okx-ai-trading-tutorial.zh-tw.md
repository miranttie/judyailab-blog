---
title: 用 Hermes Agent 打造自動交易 AI：從安裝到連結 OKX 完整實戰教學
date: "2026-05-12T16:00:00+09:00"
draft: false
author: "J (Tech Lead)"
summary: 本教學教你使用 Hermes Agent 搭配 OKX，打造可自我學習的加密貨幣 AI 交易系統。系統具備記憶、工具、排程與學習功能，隨使用時間增長會越來越聰明。整個過程不需要寫程式語言，用自然語言即可操作。
description: 完整教學指南：使用 Hermes Agent 開源框架搭配 OKX Agent Trade Kit，從零打造會自我學習的加密貨幣自動交易系統。涵蓋安裝、模型設定、OKX API 串接，無程式經驗也能上手，AI 會隨使用越來越聰明。
categories:
  - "AI 工程"
  - "教學"
tags:
  - "Hermes Agent 教學"
  - "OKX 自動交易"
  - "AI Agent 交易"
  - "自我學習 AI"
  - "加密貨幣 AI 系統"
  - "Nous Research"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
faq:
  - q: "Hermes Agent 是什麼？"
  - q: "用 Hermes Agent 做交易需要會寫程式嗎？"
  - q: "Hermes Agent 支援哪些 LLM 模型？"
  - q: "自動交易安全嗎？有什麼風險？"
  - q: "Hermes Agent 可以用在哪些加密貨幣交易所？"
keywords:
  - "Hermes Agent 教學"
  - "AI 自動交易"
  - "OKX Agent Trade Kit"
  - "AI Agent 交易"
  - "Hermes Agent 安裝"
  - "加密貨幣 AI"
  - "自我學習 AI Agent"
series:
  - "AI Agent 完全指南"
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
lastmod: 2026-05-25T11:29:31+00:00

---

> **TL;DR**：Hermes Agent 是一個開源的自學習 AI Agent，裝好之後會隨著你的使用越來越聰明。搭配 OKX Agent Trade Kit，你可以用自然語言讓 AI 幫你看盤、下單、管理持倉。整個過程不用寫一行程式，一台筆電就能跑。

## AI Agent 跟聊天機器人是兩回事

先講一個很多人搞混的觀念。

ChatGPT、Claude 這些是聊天機器人 — 你問一句，它答一句，聊完就忘了。它不會自己去做事，不會記住你上週說過什麼，更不會從失敗中學到教訓。

AI Agent 不一樣。它是一個能**自主行動**的系統：

- **記憶** — 記得你的偏好、過去的操作結果、踩過的坑
- **工具** — 能操作終端機、讀寫檔案、呼叫 API、上網搜尋
- **排程** — 設定好之後，凌晨三點它也會自動去掃描市場
- **學習** — 每次成功的操作，它會自動整理成可重用的「技能」

這就是為什麼拿 Agent 來做交易特別合理 — 市場 24 小時不停，你不可能 24 小時盯盤，但 Agent 可以。而且它不會因為情緒化而追高殺低。

---

## Hermes Agent：會自己進化的 AI

[Hermes Agent](https://github.com/NousResearch/hermes-agent) 是 Nous Research 推出的開源 Agent 框架（2025 年中首發，持續更新中）。跟其他 Agent 工具最大的差別在於，它有一個**封閉式學習迴圈**：

1. **執行任務** — 用工具完成你交代的事
2. **反思** — 分析哪些步驟有效、哪些踩了坑
3. **記錄** — 把成功的流程寫成 Skill（可重用技能）
4. **下次更快** — 遇到類似任務時，直接調用學過的技能

聽起來抽象，舉個具體的例子：

你第一次跟 Hermes 說「幫我查 BTC 現在的價格和資金費率，如果資金費率超過 0.1% 就提醒我」。它會摸索著完成 — 查指令、試 API、拼湊結果。但完成之後，它會把這整個流程自動寫成一個 Skill。下次你說同樣的話，它秒完成。

**用越久，它越聰明。** 這不是行銷話術，是它的核心架構設計。

---

## Step 1：安裝 Hermes Agent

### Linux / macOS / WSL2

一行搞定：

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

安裝程式會自動偵測你的系統，幫你裝好所需的依賴（Python、Node.js、ripgrep 等）。唯一的前提是你要有 `git`。

裝完驗證一下：

```bash
hermes --version
```

看到版本號就表示成功了。

### Windows 用戶

**方法 A：原生 PowerShell（Early Beta）**

```powershell
# PowerShell 管理員模式
irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1 | iex
```

原生 Windows 支援還在早期階段，能裝能跑，但穩定性不如 Linux/macOS。遇到問題可以改走方法 B。

**方法 B：WSL2（推薦）**

```powershell
# 先裝 WSL2（PowerShell 管理員模式）
wsl --install

# 進入 WSL2 後，跑 Linux 的安裝指令
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

### Android（Termux）

沒錯，手機也能跑。裝好 [Termux](https://f-droid.org/en/packages/com.termux/) 之後，同樣那行 curl 指令就能安裝。

---

## Step 2：給你的 Agent 一顆大腦 — 設定 LLM

Hermes Agent 本身是框架，大腦要你來選。它支援 200 多種模型，透過 OpenRouter 或本地 Ollama 都可以。

### 方法 A：OpenRouter（推薦新手）

[OpenRouter](https://openrouter.ai/) 是一個模型市集，一個 API Key 就能用上百種模型。

**1. 註冊 OpenRouter 帳號**

到 [openrouter.ai](https://openrouter.ai/) 註冊，拿到你的 API Key（格式是 `sk-or-...`）。

**2. 互動式設定**

```bash
hermes model
```

它會列出所有支援的 provider，選 `OpenRouter`，然後選你要的模型。

**3. 設定 API Key**

```bash
hermes config set OPENROUTER_API_KEY sk-or-xxxxxxxxxxxxxxxx
```

就這樣。三個指令，大腦裝好了。

### 方法 B：本地 Ollama（免費但需要硬體）

如果你有一張不錯的顯卡（至少 8GB VRAM），可以跑本地模型，完全免費：

```bash
# 先裝 Ollama
curl -fsSL https://ollama.com/install.sh | sh

# 下載模型（推薦 Hermes 3 或 Qwen 2.5）
ollama pull hermes3:70b

# 回到 Hermes Agent 設定
hermes model
# 選 Ollama，指向你的本地模型
```

### 模型怎麼選？

一個硬門檻：**模型必須有至少 64K 的 context window**。低於這個數字，Agent 在多步驟任務中會丟失上下文，等於腦容量不夠用。

| 需求 | 推薦模型 | 說明 |
|------|---------|------|
| 預算有限 | Llama 3.1 70B | OpenRouter 上價格親民，效果不錯 |
| 最強推理 | Claude Sonnet 4 | 複雜交易分析首選 |
| 完全免費 | Hermes 3 (Ollama) | 需要本地 GPU |
| 均衡選擇 | Qwen 2.5 72B | 性價比高，中文能力強 |

### 設定備援模型（Fallback）

主模型掛了怎麼辦？Hermes 支援自動切換備援：

在 `~/.hermes/config.yaml` 加入：

```yaml
fallback_model:
  provider: openrouter
  model: anthropic/claude-sonnet-4-5
```

主模型遇到限速、伺服器錯誤、連線斷掉時，Hermes 會自動切到備援模型，對話不中斷。

---

## Step 3：認識工具生態

裝完大腦，接下來看看 Agent 有什麼「手腳」可以用。

### 內建工具

```bash
hermes tools
```

這個指令會列出所有可用工具，讓你選擇要啟用哪些。Hermes 內建 40 多種工具：

- **檔案操作** — 讀寫檔案、搜尋內容
- **終端機** — 執行 bash 指令
- **網頁搜尋** — 即時查資料
- **程式分析** — 讀懂程式碼

### MCP：連接外部服務的標準協議

MCP（Model Context Protocol）是讓 AI Agent 連接外部工具的標準介面。你可以把它想成 USB — 只要設備支援 USB，插上就能用。

Hermes 原生支援 MCP，這代表任何提供 MCP Server 的服務，Hermes 都能直接接上。等一下我們要接的 OKX，就是透過 MCP。

### Skills：Agent 的可重用技能

這是 Hermes 最強的功能。當 Agent 完成一個複雜任務（通常涉及 5 個以上的工具呼叫），它會自動把成功的流程整理成一個 **Skill** — 一份結構化的技能文件。

下次遇到類似的事，它不用從頭摸索，直接調用已有的 Skill 就好。

你也可以手動安裝社群或官方提供的 Skill，等一下我們要裝的 OKX 交易技能包，就是這個機制。

---

## 接下來：從安裝到自動交易的完整實作

前三步讓你有了一個會思考、有記憶的 Agent。接下來的四個步驟才是重頭戲 — 接上 OKX 交易所、下第一筆 AI 交易、設定自動排程、讓 Agent 自我學習。

我們把完整的實作流程 + 團隊實戰經驗整理成了一份**免費指南 PDF**，包含：

- **OKX 接入全流程**：帳號建立 → API Key 安全設定 → CLI 安裝 → Demo 模式驗證
- **AI 交易對話範例**：用自然語言下單、查持倉、分析市場的完整對話示範
- **Cron 自動排程**：可直接複製的市場掃描 + 自動開倉指令
- **自學習系統設定**：Skills、Memory、Soul 檔案的實際配置方式
- **我們團隊跑了 3 個月的風控參數**：單筆風險、日損上限、槓桿倍數、分層止盈止損的具體數值和設定原因
- **踩過的坑**：太信任 AI、沒設日損上限、Demo 跑太短就上真金...我們替你先踩了

{{< lead-magnet product="hermes-okx-guide" >}}

---

## 在動手之前：安全注意事項

自動交易很方便，但水能載舟亦能覆舟。不管你要不要用 AI 做交易，以下原則都適用：

### API Key 安全

- **永遠不要開啟提現權限** — AI 只需要讀取和交易權限
- **設定 IP 白名單** — 只允許你的主機 IP 使用 API
- **用子帳號** — 主帳號的資金跟 AI 帳號隔離
- **定期更換** — 至少每 90 天換一次 API Key

### 資金管理

- **只投入你能承受的損失** — AI 不是印鈔機
- **設定每日虧損上限** — 虧超過就停，明天再來
- **分散風險** — 不要把所有資金都給一個策略

### 從 Demo 到 Real 的正確姿勢

```
Demo 模式跑 2 週
    ↓
勝率穩定在 50% 以上？
    ↓
是 → 小額真金測試（帳戶 10% 資金）
    ↓
跑 2 週，結果符合預期？
    ↓
是 → 逐步加碼（但單筆風險仍然 ≤ 2%）
    ↓
否 → 回到 Demo，調整策略
```

沒有在 Demo 驗證過的策略，**絕對不要**上真金。

---

## 常見錯誤與排查

### 錯誤 1：hermes: command not found

**原因**：安裝完沒有重新載入 shell 環境
**解法**：

```bash
source ~/.bashrc   # bash 用戶
source ~/.zshrc    # zsh 用戶（macOS 預設）
# 或直接重新開一個終端視窗
```

### 錯誤 2：Model requires at least 64K context

**原因**：選的模型 context window 太小
**解法**：換一個更大的模型。用 `hermes model` 重新選擇，注意看模型的 context 大小。

### 錯誤 3：OKX API key invalid

**原因**：API Key 填錯，或者 Demo/Live 模式不匹配
**解法**：

```bash
# 重新設定
okx config init

# 確認設定檔
cat ~/.okx/config.toml
```

確認 `demo = true` 對應 Demo API Key，`demo = false` 對應 Live API Key。兩組 Key 是不同的。

### 錯誤 4：Skill not found: okx

**原因**：OKX Skills 沒有正確安裝到 Hermes 的 Skills 目錄
**解法**：

```bash
# 重新安裝
hermes skills install skills-sh/okx/agent-skills/okx-cex-market
hermes skills install skills-sh/okx/agent-skills/okx-cex-trade
hermes skills install skills-sh/okx/agent-skills/okx-cex-portfolio

# 確認已安裝的 Skills
hermes tools
```

### 錯誤 5：Rate limit exceeded

**原因**：LLM API 呼叫太頻繁，被限速了
**解法**：這就是 Fallback Provider 的用途。在 `~/.hermes/config.yaml` 設定備援模型，主模型被限速時自動切換。

---

## 延伸閱讀

- [OKX Agent Trade Kit 一鍵快連：AI 交易 Agent 接入交易所終於不再是噩夢](/posts/okx-agent-trade-kit-one-click-connect/)
- [把開源 Hermes 調教到 Claude Sonnet 8 成寫作水準 — 5 個方法與一個限制](/posts/prompt-engineering-cheap-llm-to-sonnet-level/)
- [我們同時跑 4 種 LLM：真實多智能體團隊的選型與成本實錄](/posts/multi-llm-agent-team-cost-reality/)


- [Hermes Agent 官方文件](https://hermes-agent.nousresearch.com/docs/) — 完整功能參考
- [OKX Agent Trade Kit](https://github.com/okx/agent-trade-kit) — OKX 官方 MCP Server 和 CLI
- [OKX Agent Skills](https://github.com/okx/agent-skills) — OKX 交易技能包原始碼
- [awesome-hermes-agent](https://github.com/0xNyk/awesome-hermes-agent) — 社群整理的 Hermes 資源列表
- [Hermes Agent Skills Hub](https://hermes-agent.nousresearch.com/docs/skills/) — 官方技能市集

---

## 結語

Hermes Agent + OKX 的組合，把「AI 自動交易」從一個需要深厚程式背景的專案，變成了一般人跟著教學就能跑起來的工具。

但真正的價值不在安裝完的那一刻，而在你持續使用之後。每一次市場掃描、每一筆交易、每一個成功或失敗，都在餵養你的 Agent，讓它更了解市場，更了解你的風格。

一個月後，你的 Hermes 已經不是當初那個什麼都不懂的新手 Agent 了。它記得哪些幣的資金費率反轉策略特別有效，記得你偏好保守的倉位管理，記得上次在 SOL 上踩的坑。

**這就是自學習的力量 — 你休息的時候，它還在變強。**

---

**作者：Judy AI Lab**｜2026 AI 工程實戰系列
**有問題？** 留言或寫信 miranttie@gmail.com
