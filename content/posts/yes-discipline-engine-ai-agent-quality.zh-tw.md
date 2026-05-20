---
title: AI Agent 一直推卸責任？YES 紀律引擎讓它自己解決問題
date: "2026-04-27T20:00:00+00:00"
draft: false
author: Judy
summary: AI Agent 經常說『你應該確認一下』推卸責任，這是模型的保守傾向。YES 紀律引擎是一套裝進系統提示的行為規則，讓 agent 不猜測、不推責、附證據才說完成。問『API 為什麼回 401』時，agent 會自己執行 curl 找到原因並修好，而非僅給建議。
description: AI Agent 常說『你應該手動確認一下』推卸責任？這不是 bug，是 AI 的懶散模式。YES 紀律引擎提供5條鐵則：不猜測只查證、不推責自己解決、不聲稱附證據、不重複失敗方法、每個任務有明確狀態。讓 AI coding agent 像資深工程師一樣負責任，直接跑命令驗證並給出具體結果，大幅提升開發效率與可靠性。適合 Claude Code、Cursor 等任何 agent。
categories:
  - "AI 工程"
  - "教學"
tags:
  - "YES紀律引擎"
  - "AI Agent"
  - "Claude Code"
  - "Agent設計"
  - "AI品質管控"
  - "自動化開發"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
faq:
  - q: "YES 紀律引擎是什麼？"
    a: "YES 紀律引擎是一套裝進 agent 系統提示的行為規則，核心是5條鐵則：不猜測只查證、不推責自己解決、不聲稱附證據、不重複失敗方法、每個任務有明確狀態。"
  - q: "為什麼 AI agent 一直說『你應該手動確認一下』？"
    a: "這是 AI 模型在訓練時的保守傾向——不確定時把責任推回用戶比犯錯更安全。解法是在系統提示裡明確告訴 agent 哪些事它有責任自己查清楚。"
  - q: "YES 紀律引擎適合哪些 agent？"
    a: "適合任何有 system prompt 的 agent，包括 Claude Code、Cursor、OpenClaw、自建 LLM agent 等，不依賴特定框架。"
  - q: "安裝 YES 紀律引擎後會有什麼改變？"
    a: "問 agent『API 為什麼回 401』時，它不再說『可能是 token 你確認一下』，而是執行 curl 命令、看回應、找到原因、修好並驗證，整個流程自己走完。"
  - q: "YES 紀律引擎跟普通的『請仔細檢查』提示詞差在哪？"
    a: "差別是規則的具體與可驗證程度。一般「請仔細檢查」只是原則，AI 仍然用模糊話術。YES 把每條規則綁定具體動作：不推責就要自己跑命令、附證據就要貼指令輸出、明確狀態就要在最後一句寫 DONE 或 BLOCKED 或 FAILED。Agent 沒辦法用話術繞過，每一步都有可審計的證據鏈。"
  - q: "用了 YES 紀律引擎還是會出錯，該怎麼除錯？"
    a: "先看 agent 的最後狀態行。DONE 但沒附證據代表規則沒生效，要檢查系統提示是否真的注入到請求。BLOCKED 是正常，代表 agent 識別出超出能力範圍，並正確停下。FAILED 就看它附的失敗證據，多半是工具或權限問題。三種狀況都比模糊『我已完成』好除錯，因為現場資訊都還在。"
slug: yes-discipline-engine-ai-agent-quality
keywords:
  - "AI agent 品質控制"
  - "YES紀律引擎"
  - "AI agent 推卸責任"
  - "AI coding agent 設計"
  - "agent 行為規則"
  - "提高AI Agent可靠性"
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
series:
  - "AI Agent 完全指南"
lastmod: 2026-05-13T04:29:42+00:00

---

> **TL;DR**：AI Agent 一直說「你應該手動確認一下」是模型的保守傾向，不是能力不足。YES 紀律引擎是一套裝進系統提示的五條鐵則，讓 Agent 不猜測只查證、不推責自己解決，問 API 為什麼 401 它會自己跑 curl 找到原因修好。

上週一個開發者在群組裡說了一句話，讓我想到一個我自己也踩過很多次的坑：

「我的 agent 一直說『你應該手動確認一下』，感覺在用它還不如自己做。」

我完全理解這種挫折感。

## AI Agent 的懶散模式

如果你用過 AI coding agent 一段時間，你一定認識這些句子：

- 「這個問題**可能是**資料庫連線設定，建議你確認一下。」
- 「功能已經實作，**應該**可以正常運作。」
- 「我沒辦法直接確認，你**可以**手動測試看看。」
- 「這**可能**是環境變數的問題。」

這不是 agent 壞掉了。這是 AI 模型在面對不確定性時的標準反應——把結論留給用戶，自己退到「建議」的安全位置。

問題是，你花時間設置 agent，不是為了讓它給你「建議清單」。你要的是它真的去解決問題。

## 為什麼 Agent 會推責任？

AI 模型在訓練時有一個內建傾向：**在不確定的情況下，推責任比犯錯更「安全」**。

對模型來說，說「你應該確認一下」是一個低風險的答案——不會犯錯，也不會造成額外問題。但對你來說，這個答案沒有價值。

這個問題換一個框架來看會更清楚：

想像你剛雇了一個工程師，問他「這個 API 為什麼一直回 401？」

**懶散模式的工程師：**「可能是 token 過期了，你去看一下 API 文件確認一下。」

**你想要的工程師：**跑一個 curl 確認回應格式、查 token 過期時間、試 refresh、確認修好、告訴你結果。

差別不在能力，在**責任感**。

## YES 紀律引擎：5 條鐵則

YES 紀律引擎（YES Discipline Engine）是一套裝進 agent 系統提示的行為規則。它的名字來自核心哲學：**當 agent 說「我做好了」，你應該能夠說「Yes，我相信你」——而不是「讓我去確認一下」。**

### 鐵則一：不猜測，只查證

```
❌ "問題可能出在資料庫連線。"
✅ 執行 psql -U user -h db-host testdb
   → 得到 "Connection refused (port 5432)"
   → PostgreSQL 沒在跑
   → 執行 sudo systemctl start postgresql
   → 重新連線測試通過
   → 報告：已確認並修復
```

任何「可能是 X 的問題」都必須先變成「我跑了 Y，得到結果 Z」。

### 鐵則二：不推責，自己解決

```
❌ "你應該手動確認這個設定是否正確。"
✅ 讀設定檔、比對文件、找出差異、修正、驗證
   → 如果沒有權限：說明具體需要什麼權限，原因是什麼
```

agent 的工作邊界是「你設定給它的作用域（allowed files / assigned tasks）之內的事情自己解決」。超出邊界才說需要幫助，但要說清楚需要什麼。

### 鐵則三：不聲稱，附證據

```
❌ "rate limiting 功能已完成。"
✅ 執行 for i in {1..15}; do curl -s your-app:3000/api; done
   → 確認前10次 200、後5次 429
   → 報告：功能驗證通過，符合需求
```

「功能已完成」不算完成。帶著輸出的「功能已完成」才算完成。

### 鐵則四：不重複失敗的方法

```
如果方法 A 第一次失敗：
→ 先診斷為什麼失敗
→ 再決定下一步（修改 A 或換方法 B）

不是：把一模一樣的命令跑第二次然後說「我試過了」
```

### 鐵則五：每個任務有明確狀態

任務結尾必須是三種之一：

- ✅ **完成**：附驗證輸出
- ❌ **阻擋**：說明具體原因 + 需要什麼才能繼續
- 🔄 **進行中**：說明下一步是什麼

不存在「應該沒問題」這種狀態。

## 安裝 YES 紀律引擎

這套規則設計為純文字，可以直接加到任何 agent 的系統提示裡。

**Claude Code / Claude API：**
在 `CLAUDE.md` 或 system prompt 裡加入以下規則區塊：

```markdown
## YES Discipline Engine

- Rule 1: Never guess. Run the actual command and report the real output.
- Rule 2: Never deflect. If it's in your scope, solve it. If not, say exactly what you need.
- Rule 3: Never claim without evidence. Show the verification output before saying "done."
- Rule 4: Never retry identically. If approach A failed, diagnose why before next attempt.
- Rule 5: Every task closes with: ✅ Done (with evidence) | ❌ Blocked (specific reason) | 🔄 In Progress (next step)
```

**OpenClaw：**
把規則加到 `SOUL.md` 的 `<anti-slack>` 區塊，或作為獨立 skill 載入（`skills/yes-en/SKILL.md`）。

## 實際上會有什麼變化？

裝完之後最明顯的改變不是 agent「更聰明了」，而是**你不需要當中間人了**。

以前的流程：
1. 你問問題
2. Agent 給建議
3. 你去手動確認
4. 你回來告訴 agent 結果
5. Agent 給下一步建議
6. 重複

裝了 YES 引擎之後：
1. 你給任務
2. Agent 跑到底，附帶完整輸出
3. 你看結果決定下一步

差別在於步驟 3-5 從你的工作清單裡消失了。

## 一個注意事項

YES 紀律引擎會讓 agent 更主動——它會去跑命令、讀檔案、修改程式碼。這意味著你需要設定清楚的邊界：

- `allowed_files`：哪些檔案 agent 可以修改
- 哪些操作需要確認（部署、DB 修改、對外發布）

沒有邊界的「主動」會變成問題。YES 引擎的設計前提是 agent 有明確的作用域，在作用域內自主，在作用域外詢問。

---

如果你的 agent 現在還在說「你應該手動確認一下」，試試把這五條規則加進它的系統提示，下一個任務看看會不會不一樣。

<!-- product-cta -->
{{< product-cta product="commander" >}}

## 延伸閱讀

- [AI 自我審查流水線：我們如何讓 Agent 在送 PR 前先審自己的程式碼](/posts/ai-self-review-pipeline-quality-gates/) — 更完整的 agent 品質控制流水線設計
- [從零開始建立 AI 多 Agent 團隊：我們的真實經歷與踩坑筆記](/posts/building-ai-agent-team/) — 建立 agent 團隊時遇到的真實問題
- [AI Agent vs 傳統 Trading Bot：差在哪裡，怎麼選](/posts/ai-agent-vs-trading-bot/) — 從另一個角度看 agent 自主性的本質差異

我們在 Judy AI Lab 用這套 YES 紀律引擎管理整個 AI Agent 團隊，從交易系統到內容流水線，agent 真的能自己跑到底並交出證據。

## 關鍵數據

- 5000 users (Threads + Newsletter 訂閱合計)
- $0 廣告投放（純有機流量）
- 95% 內容由 J 與多 agent 團隊產出
