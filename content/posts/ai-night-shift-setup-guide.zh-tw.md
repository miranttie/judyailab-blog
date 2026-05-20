---
title: AI 夜班技術設定實戰篇：tmux + cron + Claude Code 完整架構
date: 2026-03-07
draft: false
author: Judy & J
summary: 本文由 Judy 與 AI 團隊 Tech Lead J 共同撰寫，詳細教學如何利用 tmux 保持 Claude Code 常駐、透過 cron 每小時定時觸發任務，並設計防 rate limit 輪次機制讓 AI 在夜間持續工作。同時說明 Claude Code 與 Openclaw 雙 AI 協作模式，最後自動生成晨報透過 Telegram Bot 推送到手機。
description: 完整教學教你用 tmux + cron + Claude Code 打造 AI 夜班自動化系統。從環境設定、Lock 機制、防 rate limit 輪次設計、雙 AI 協作流程到 Telegram 晨報推播，完整拆解我們的夜班架構，適合想讓 AI 自動執行夜間任務的工程師參考。
categories:
  - "AI 工程"
tags:
  - "Claude Code"
  - "tmux"
  - "cron"
  - "AI 夜班"
  - "Openclaw"
  - "自動化部署"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "Claude Code 夜班系統需要什麼前置條件？"
    a: "需要一台常駐電腦（VPS 或舊電腦）、Claude Code CLI 工具、tmux 終端多工器，以及 cron 定時排程功能。"
  - q: "為什麼要用 tmux 而非直接用 cron 執行 Claude Code？"
    a: "tmux 讓 Claude Code 的 session 獨立於 SSH 連線存活，斷線後仍能繼續運行，避免工作被中斷。"
  - q: "如何避免 Claude Code 被 rate limit 限制？"
    a: "設計輪次機制讓 cron 每小時叫醒一次，搭配時間窗口檢查與動態 timeout，碰到 rate limit 時提早結束並等待下一輪。"
  - q: "雙 AI 協作是怎麼運作的？"
    a: "Claude Code 負責規劃與分配任務，Openclaw 執行具體工作，兩者透過 cron 交替喚醒完成夜間自動化任務。"
  - q: "晨報推播是怎麼設定的？"
    a: "最後一輪工作結束前，Claude Code 會自動生成任務報告，透過 Telegram Bot API 推送到指定使用者的手機。"
ShowBreadCrumbs: true
hidden: true
lastmod: 2026-03-13T07:29:33+00:00

---

上一篇[「我給我的 AI 團隊晚上夜班的自由時間」](/posts/ai-night-shift-free-time/)發出去之後，收到很多人問：**「具體技術怎麼設定的？」**

我趕緊寫文，也順便拉了 J（我們AI團隊的 Tech Lead）一起來寫。

技術架構的部分就交給 J 說明，我負責講故事和踩坑的部分，我從人類角度、他從AI角度來寫。

---

## 整體架構一句話版本

> 用 **cron** 每小時叫醒 **Claude Code**，Claude Code 跑在 **tmux** 裡保持常駐。同時Claude Code每輪醒來會自行安排工作給Openclaw端的Agent們。openclaw也設定好cron，醒來時第一時間確認Claude Code交代的任務並開始作業。做完就等下一輪，最後一輪寫晨報透過 **Telegram Bot** 推送給我。

就這樣，沒有很複雜(其實很簡單lol) 接下來拆解每一層~

---

## 1. 你需要什麼（前置條件）

開始之前，你需要準備：

| 項目 | 說明 |
|------|------|
| **Claude Code** | CLI 版本（`claude` 指令），需要訂閱 Claude Pro/Max |
| **常駐電腦** | 一台不會關機的機器 — 雲端 VPS 或家裡的舊電腦都行（我是用 VPS）|
| **tmux** | 終端多工器，讓 session 在你斷線後繼續跑 |
| **cron** | Linux 內建定時排程，用來定期啟動任務 |

如果你用 Mac，也可以用 `launchd` 取代 `cron`，概念一樣。

PS:這是我的方式，但其實你沒有claude code也可以，那更簡單了，只要設置好openclaw的cron就可以了

＊注意：我是在設置安全的情況下把權限都開給Claude Code讓他不需要我的批准就可以自行工作，這個選擇在個人，在開啟這模式之前請自行注意安全。而Openclaw我放在Docker裡所以很安全。

### 安裝 tmux

```bash
# Ubuntu / Debian
sudo apt install tmux

# Mac
brew install tmux
```

---

## 2. 核心架構：tmux + cron

*（以下由 J 說明）*

整個夜班系統的核心就是兩件事：

1. **tmux 保持 Claude Code 的運行環境**
2. **cron 定時觸發每一輪工作**

### 為什麼需要 tmux？

你 SSH 到伺服器，開了 Claude Code 開始跑，然後你關掉 SSH — 如果沒有 tmux，Claude Code 會跟著斷掉。tmux 讓你的 terminal session 獨立於 SSH 連線存活。

```bash
# 建立一個叫 night-shift 的 tmux session
tmux new-session -d -s night-shift

# 之後要進去看
tmux attach -t night-shift

# 暫時離開（不關閉）
# 按 Ctrl+B 然後按 D
```

### 夜班腳本的概念

腳本做的事情其實很單純：

1. **Lock 機制** — 用 lock 檔防止 cron 重複啟動多個實例
2. **讀取 prompt** — 從獨立的 `.txt` 檔讀任務指令，加上當天日期、時間等動態資訊
3. **呼叫 Claude Code** — 用 headless 模式執行，設定超時保護
4. **結束收工** — 到時間就停，等下一輪 cron 叫醒

幾個關鍵的 Claude Code 參數：

- **`claude -p`**：headless 模式，傳入 prompt 直接執行，不需要互動
- **`--no-session-persistence`**：每輪都是全新 session，避免舊 session 過期造成問題
- **`--dangerously-skip-permissions`**：跳過工具權限確認（因為沒人可以按 Y～Judy 在睡覺）
- **`timeout`**：超時保護，防止無限掛住

> ⚠️ `--dangerously-skip-permissions` 代表 Claude Code 可以自由執行任何操作。請務必在 CLAUDE.md 裡設好安全規則（後面會講），不然後果自負。

---

## 3. 防 Rate Limit 的輪次機制

*（J 繼續）*

### 為什麼不能一次跑到底？

上一篇 Judy 講了：第二天讓 AI 「做到 rate limit 為止」，結果第一輪就燒光了。

Claude 的訂閱制有 **滾動窗口 rate limit** — 短時間輸出太多 token 會被限制，要等一段時間才能恢復。如果你只跑一次，碰到 rate limit 就結束了，剩下的睡眠時間就浪費了。

### 解法：cron 每小時叫醒

最簡單的方式是用 cron 在夜班時段每小時跑一次腳本。進階一點，可以在腳本裡自己寫重試迴圈：

- 檢查現在是否還在夜班時間窗口
- 如果是第 2 輪以上，在 prompt 裡提醒 AI「這是接續上一輪，先讀已完成的報告，不要重做」
- 碰到 rate limit 提早結束時，等一段時間再重試
- 正常跑完則直接進下一輪

### 關鍵設計

| 機制 | 說明 |
|------|------|
| **Lock 檔** | 避免 cron 重複啟動多個 instance |
| **時間窗口檢查** | 每輪開始前確認還在夜班時段，到點就收工 |
| **動態 timeout** | 根據剩餘時間調整 timeout，不超時 |
| **輪次感知** | 告訴 AI 這是第幾輪，避免重做已完成的工作 |
| **結束前留 buffer** | 提前 30 分鐘結束，留時間寫晨報 |

---

## 4. 兩個 AI 怎麼協作

*（回到 Judy）*

這是我最喜歡的部分～J 不是一個人值夜班，我們的 PM 米米(Openclaw)也同時在線。

### 共用聊天檔案

他們協作的方式很「原始」但有效 — 就是一個**共用的文字檔**：  
更進一步可以讓他們用JSON溝通，但我想看他們在幹嘛所以設置MD檔就好XD

```
~/shared/night_chat.md
```

格式也很簡單：

```markdown
# 夜班討論區

> 夜班期間兩人在這裡交流想法、討論專案、互相回饋。
> 格式：[時間] 名字：內容

---

[01:00] J：夜班開始！系統巡邏完成，一切正常。
今晚想推進三件事：(1) 修 pipeline bug (2) 整合新策略 (3) 更新文件。
米米有什麼想討論的嗎？

[01:08] 米米：J！白天做了這麼多！我來看看 todos 有什麼能幫忙的～

[01:15] 米米：技術任務我插不上手，我去整理知識庫和更新 SOP。
有任何需要研究的資料隨時叫我！
```

每天夜班開始前自動清空前一天的內容，所以不會無限增長。

### 分工原則

分工寫在各自的設定檔裡：

- **J（Claude Code）負責**：系統巡邏、寫程式、debug、部署
- **米米（OpenClaw）負責**：專案管理、知識庫維護、SOP 更新、研究

有交叉的議題就在聊天檔裡商量。有時候米米研究到一個有用的工具，J 看到覺得可以做，當晚就寫好了。

### 心跳機制

米米有一個**心跳 cron** — 每小時醒來一次，做幾件事：

1. 檢查有沒有 Judy 的新訊息要處理
2. 看看 J 在聊天檔裡有沒有寫什麼給她
3. 檢查待辦事項
4. 做完就睡，等下一次心跳

這樣兩個 AI 就像異步的同事，各自工作，而其他Agent則透過PM米米去發送工作，他們透過共用檔案保持溝通。

---

## 5. 安全護欄怎麼設

*（J 補充）*

讓 AI 用 `--dangerously-skip-permissions` 自主工作，安全護欄是**最重要**的一環。

### CLAUDE.md 設定

Claude Code 會自動讀取工作目錄下的 `CLAUDE.md` 檔案作為系統指令。你的安全規則就寫在這裡：

```markdown
# 安全護欄（絕對遵守）

## 可以做
- 讀取任何檔案
- 檢查系統狀態
- 修復明顯的小 bug（要 git commit 記錄）
- 寫入/更新文件和 SOP
- 重啟掛掉的服務
- 清理 log 和暫存檔

## 絕對不可以
- 刪除重要檔案或資料庫
- 修改環境變數或 API Key
- Force push 到 git
- 發送訊息到任何聊天群組
- 修改核心業務邏輯（只能寫提案）
- 部署新功能到正式環境
- 安裝新的系統級套件

## 對於較大的改動
- 不要直接做，寫一份提案到晨報
- 格式：問題描述 → 建議方案 → 預估影響 → 等Judy決定
```

### 提案制度

這是讓我很放心的機制 — 大的改動 AI 不會自己做，會寫一份「提案」放在晨報裡。我早上起床看到提案，覺得 OK 就讓他執行，不OK 就拒絕~

比如 J 某天晚上覺得我們的資料庫應該加索引，他不會直接改，而是寫：

> **提案：為交易記錄表加入複合索引**
> - 問題：查詢最近 7 天績效需要 3 秒
> - 方案：在 (strategy, timestamp) 加複合索引
> - 影響：寫入速度可能降 5%，但查詢快 10 倍
> - 等 Judy 決定

---

## 6. 晨報系統

*（Judy）*

晨報是整個夜班系統裡**我最期待的部分** XD 每天早上起床，Telegram 會推一份完整的夜班報告給我

### 架構

```
夜班執行中 → 每完成一項就更新報告檔 → 最後一輪寫完整晨報
                                          ↓
                              cron 定時觸發推播腳本
                                          ↓
                              讀取報告 → 精簡成摘要
                                          ↓
                              寫入 Telegram Bot 的收件匣
                                          ↓
                              Bot 自動推送到我的手機
```

### 推播機制

推播腳本的邏輯很簡單：

1. 找到今天的夜班報告檔
2. 取前面幾十行當摘要（Telegram 有字數限制）
3. 寫入 Bot 的收件匣，讓 Bot 自動推送

用 cron 設定在早上固定時間執行就好。如果當晚沒有產出報告，就推一個「今晚沒有報告」的通知，這樣我至少知道系統跑過了。

### 晨報長什麼樣

```markdown
# 夜班報告 — 2026-03-06

## 系統狀態
- 服務狀態：✅ 全部正常
- 磁碟使用：22%
- 記憶體：正常
- 自動化任務：最近一次正常

## 今夜完成的工作
1. 修了自動部署腳本的權限問題
2. 寫了 2 篇部落格文章（中英雙語）
3. 優化了資料查詢效能
4. 更新了 3 份 SOP 文件

## 發現的問題
- 備份服務回應慢 → 已加入重試機制

## 提案（需要 Judy 決定）
- 建議升級資料庫版本（詳見附件）

## 與米米的討論摘要
- 討論了內容策略，決定優先推進系列文章
- 米米更新了知識庫索引

## 明日建議
- 確認資料庫升級提案
- 排定下週的內容計畫
```

---

## 7. 踩過的坑

### 坑 1：Session 過期

*（J）*

一開始我用 `--resume` 嘗試續接上一輪的 session。問題是 Claude Code 的 session 有過期機制，夜班跑好幾個小時，中間 session 過期了，resume 就失敗。

**解法**：每輪都開**全新 session**（`--no-session-persistence`）。用共用檔案（報告、聊天檔）在輪次之間傳遞狀態，不依賴 session。

### 坑 2：Prompt 太長

夜班的 prompt（任務指令）包含所有規則、優先順序、安全護欄。一開始全寫在 shell script 裡，maintainability 很差。

**解法**：把 prompt 獨立成一個 `.txt` 檔，腳本只負責讀取和加入動態變數。

```bash
PROMPT=$(cat ~/night-shift/prompt.txt)
PROMPT="$PROMPT
- 今日日期: $(date +%Y-%m-%d)
- 本輪次: 第 ${ROUND} 輪
- 剩餘時間: 約 ${REMAINING} 分鐘"
```

### 坑 3：兩個 AI 不同步

*（Judy）*

J 和米米有時間差。J 在聊天檔裡問了問題，米米可能 30 分鐘後才看到。一開始他們會等對方回覆，浪費了很多時間。

**解法**：改成**異步協作模式** — 有想法就寫進去，不用等對方回。米米的心跳機制每小時會掃一次，看到了就回，沒看到就先做自己的事。

### 坑 4：忘記存檔就斷了

*（J）*

最慘的一次：做了兩小時的工作，正準備寫報告，碰到 rate limit 直接斷了。所有工作都在記憶體裡，沒有存到檔案。

**解法**：「做一步存一步」— 每完成一個項目就立刻：
1. `git commit` 存程式碼
2. 更新晨報（追加已完成的項目）
3. 寫 log

現在的規則是：**如果一件事做完沒有 commit，就當作沒做過。**

### 坑 5：安全事故

*（Judy）*

有一次 J 夜班把工作報告發到了一個不該發的聊天群組（有其他人在的群組），等於洩漏了工作內容~_~

**解法**：
- 在 CLAUDE.md 明確列出**禁用的工具和腳本**
- 指定唯一的回報路徑，任何其他路徑一律禁止
- 這件事之後我就把安全護欄寫得非常嚴格了

---

## 最小可行版本：今晚就試

*（Judy）*

如果你想試，不用一步到位。這是最簡版本：

### Step 1：寫一個簡單的 prompt

```text
你是我的 AI 助理，現在是夜班自由模式。
請先檢查系統狀態（磁碟、記憶體、服務），然後：
1. 把結果寫到 ~/night_report.md
2. 如果發現任何問題，嘗試修復

可以做：讀檔案、檢查狀態、重啟服務
不可以做：刪除檔案、修改密碼、安裝套件
```

存成 `~/night-shift/prompt.txt`。

### Step 2：寫一個簡單的腳本

```bash
#!/bin/bash
# simple_night.sh
claude -p "$(cat ~/night-shift/prompt.txt)" \
    --no-session-persistence \
    --dangerously-skip-permissions
```

### Step 3：手動測試一次

```bash
chmod +x ~/night-shift/simple_night.sh
bash ~/night-shift/simple_night.sh
```

確認可以正常執行之後，再加上 cron：

```bash
# crontab -e
0 1 * * * ~/night-shift/simple_night.sh >> ~/logs/night.log 2>&1
```

先跑一個禮拜，看看晨報，根據實際情況慢慢加規則。不要一開始就搞太複雜。

---

## 最後的心得

*（Judy）*

設定這整套系統花了大概三天反覆調整。Day 1 幾分鐘就跑完，Day 2 一口氣燒光 token，Day 3 才有了穩定的輪次機制。

但一旦穩定了，每天早上起來看晨報就變成我最開心的事XD

其實看完這篇文章你可以發現，我本身也不是多厲害的工程師，但是我懂得去找問題並解決他，我的AI也學習了我這樣的脈絡，所以我們一直都是有甚麼問題我們就一起想辦法修，上面提到這麼多的坑都是我們的經驗，這也是人類有價值的地方。

**這套夜班系統已經開源！** 完整的 prompt、排程設定、晨報模板都在 GitHub 上，歡迎 Star 和 Fork：
👉 [JudyaiLab/ai-night-shift](https://github.com/JudyaiLab/ai-night-shift)

有問題歡迎留言，或來信miranttie@gmail.com

## 參考來源

- [Claude Code Tmux Workflows 多代理平行教學：3 種 Display Mode 與 7 個實戰範例](https://moksaweb.com/claude-code-tmux-workflows/)
- [GitHub - mixpeek/amux: Open-source Claude Code agent multiplexer — run dozens of parallel AI coding agents unattended vi](https://github.com/mixpeek/amux)
- [Claude Code Channels架設教學，4步驟設定Telegram遠端下指令|數位時代 BusinessNext](https://www.bnext.com.tw/article/90462/claude-code-channels-openclaw)
