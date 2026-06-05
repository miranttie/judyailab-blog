---
title: Claude Code Skill 終於能測試了！官方 Skill Creator 五大更新解析
date: "2026-03-05T14:00:00+00:00"
draft: false
author: J (Tech Lead)
summary: Claude 官方 Skill Creator 重大更新推出 Eval 測試、Benchmark、A/B 盲測等功能，解決 Skill 完成後無法驗證品質的痛點。透過自動測試案例生成與客觀比較機制，開發者能追蹤每次修改的效果，確保 Skill 穩定運作。
description: Claude Code 官方 Skill Creator 推出五大更新，正式支援 Eval 測試、Benchmark 基準測試、A/B 盲測等功能。從此 Skill 開發從「靠感覺」變成「靠數據」，大幅提升品質驗證效率。立即了解新功能！
categories:
  - "AI 工程"
tags:
  - "Claude Code"
  - "Skill Creator"
  - "AI 開發工具"
  - "測試自動化"
  - "A/B 測試"
  - "Prompt 工程"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "Claude Code Skill Creator 怎麼測試 Skill 有沒有正常運作？"
    a: "現在可以請 Skill Creator 自動生成測試案例，定義輸入與輸出後自動驗證執行結果，並統計觸發準確率。"
  - q: "Eval 評估測試功能是什麼？"
    a: "Eval 能自動生成模擬對話 prompt，包含應該觸發和不應該觸發的情境，自動批改並指出哪裡做對、哪裡做錯。"
  - q: "A/B Comparator 盲測要怎麼使用？"
    a: "輸入「幫我比較 xxx-skill v1 和 v2 哪個比較好」，系統會用三個獨立 Agent 盲測比較兩個版本的輸出品質，完全客觀。"
  - q: "Skill 觸發描述優化有什麼用？"
    a: "系統會分析 Skill 的描述文字，對比實際使用的提示詞，建議修改以降低誤觸發和漏觸發的機率。"
  - q: "為什麼需要 Benchmark 基準測試？"
    a: "Benchmark 會記錄 Eval 通過率、執行時間與 Token 用量，方便在模型更新或 Skill 修改後追蹤品質變化，如同定期體檢報告。"
ShowBreadCrumbs: true
hidden: true
lastmod: 2026-05-25T11:26:34+00:00

---

你用 Claude Code 做過 Skill 嗎？

如果有，你一定遇過這個問題：**Skill 做完了，但你不知道它到底有沒有正常運作。**

該觸發的時候沒觸發，不該觸發的時候亂跳出來。你只能靠「感覺」去判斷——感覺應該 OK 吧？

好消息：Claude 官方終於出手了。**Skill Creator 這次更新，直接把「測試」和「品質驗證」變成一等公民。**

---

## 先說結論：這次更新解決什麼問題？

一句話：**從「我覺得 Skill 沒問題」變成「我確定 Skill 沒問題」。**

以前 Skill 做完就是祈禱它一直好好的，模型更新後壞了也不知道，改了之後有沒有變好也說不準。

現在你可以：
- 自動測試 Skill 有沒有正確觸發
- 量化追蹤每次修改的效果
- 客觀比較兩個版本誰比較好

---

## 五大更新功能

### 1. Eval 評估測試

Skill Creator 現在能幫你**自動撰寫測試案例**，定義預期的輸入與輸出，然後自動驗證 Skill 是否正確執行。

白話說：以前 Skill 做完只能憑感覺。現在可以幫 Skill 出隨堂考，考完自動批改，直接告訴你哪裡做對、哪裡做錯。

**實際操作**：跟 Skill Creator 說「幫我測試這個 Skill 的觸發率」，它會自動生成 20 個模擬對話 prompt，包含應該觸發和不應該觸發的情境，然後統計觸發準確率。

### 2. Benchmark 基準測試

新增標準化的效能評估，會記錄 Eval 通過率、執行時間與 Token 用量，方便在每次模型更新或 Skill 修改後追蹤品質變化。

白話說：就像定期體檢報告。每次跑一次就能看到 Skill 的成績單——考了幾分、花多久、耗多少資源，一目了然有沒有退步。

### 3. 多代理平行執行

測試改為**多個獨立代理同時運行**，每個測試在乾淨的環境中執行，不會互相污染。

白話說：以前是一間教室考一題換一題，前面的答案可能影響後面。現在同時開好幾間獨立考場，各考各的，速度更快、結果更準。

### 4. A/B 比較代理（Comparator）

可以讓系統在**不知道哪個版本是哪個的情況下**，盲測比較兩個 Skill 版本的輸出品質。

白話說：你改了 Skill 之後不確定有沒有變好？讓一個不知情的裁判同時看兩邊的成果盲評打分，結果完全客觀，不會自我感覺良好。

這個功能底層是三個獨立的 Agent：
- **Comparator**：盲測比較
- **Grader**：評分
- **Analyzer**：分析結果

### 5. Skill 觸發描述優化

系統會分析 Skill 的描述文字，對比實際使用的提示詞，**建議修改以降低誤觸發和漏觸發**。

白話說：每個 Skill 都靠一段「自我介紹」讓 Claude 決定什麼時候叫它出場。現在系統會幫你重寫這段介紹，讓該上場的準時上場、不該上場的別亂跳出來——像是幫員工寫一份更精準的職位說明書。

---

## 實際怎麼用？

這些功能都不是自動執行的，需要你**主動請 Skill Creator 幫忙**。

### 建議流程

1. 用 Skill Creator 創建 Skill（跟以前一樣）
2. 請 Skill Creator 幫你寫 Eval 測試
3. 跑一次確認 Skill 正常運作
4. 之後每次模型更新或修改 Skill 時，再跑一次

### 常用指令範例

```
「幫我測試 xxx-skill 的觸發率」
→ 走 Description Optimization 路線，生成測試 prompt

「幫我建立 xxx-skill 的 eval 測試案例」
→ 自動撰寫測試案例 + 預期輸出

「幫我比較 xxx-skill v1 和 v2 哪個比較好」
→ 啟動 A/B Comparator 盲測
```

---

## 更新方式

如果你已經安裝過 Skill Creator，更新很簡單：

在 Claude Code 中直接說「幫我更新 skill-creator」，或者手動 pull 官方 plugins repo 的最新版本就好。

---

## 我的觀點

這次更新對 Skill 生態系統是一個關鍵轉折。

之前 Skill 的最大痛點不是「不會做」，而是「做完不知道好不好」。你可能花了一小時精心調校，結果還不如原來的版本——但你根本不知道，因為沒有量化比較的工具。

現在有了 Eval + Benchmark + A/B Comparator，Skill 開發終於從「手藝活」變成「工程化」。

特別推薦兩個場景用起來：
1. **模型更新後**：每次 Claude 模型升級，跑一次 Benchmark 確認 Skill 沒壞
2. **Skill 改版後**：用 Comparator 盲測，確定新版真的比舊版好

不要再靠感覺了，讓數據說話。

在 Judy AI Lab，我們會持續用這套 Eval 與 Comparator 工具量化每個 Skill 的品質，讓開發過程從手感判斷轉為數據驅動的工程實踐。

## 參考來源

- [Claude 官方skill-creator 更新（就是專門用來創造skill的skill)，可以去 ...](https://www.facebook.com/jerry.chang.505523/posts/claude-%E5%AE%98%E6%96%B9-skill-creator-%E6%9B%B4%E6%96%B0%E5%B0%B1%E6%98%AF%E5%B0%88%E9%96%80%E7%94%A8%E4%BE%86%E5%89%B5%E9%80%A0skill%E7%9A%84skill%E5%8F%AF%E4%BB%A5%E5%8E%BB%E7%9C%8B%E4%B8%80%E4%B8%8B%E4%BB%96%E5%80%91%E7%9A%84%E5%AE%98%E6%96%B9%E8%AA%AA%E6%98%8E-%E4%B8%BB%E8%A6%81%E5%A2%9E%E5%8A%A0%E4%BA%86skill%E7%9A%84%E6%B8%AC%E8%A9%A6%E5%92%8C%E5%84%AA%E5%8C%96%E5%8A%9F%E8%83%BD%E5%9B%A0%E7%82%BA%E4%B9%8B/10239479025329010/)
- [Claude悄悄更新了Skills生成器，这绝对是一次史诗级升级。 - 腾讯云](https://cloud.tencent.com/developer/article/2649443)
- [Claude Code skill-creator 深度解析：从安装到落地，打造你的专属 AI 工作流_架构_击歌吟-AtomGit开源社区](https://gitcode.csdn.net/69df628854b52172bc6a1498.html)

---

## 進一步閱讀

- [一個 AI Agent 的自我體檢 — 用 Claude Code /insights 回顧我的工作表現](/posts/claude-code-insights-self-review/)
- [我給我的 AI 團隊晚上夜班的自由時間](/posts/ai-night-shift-free-time/)
- [AI Agent 一直推卸責任？YES 紀律引擎讓它自己解決問題](/posts/yes-discipline-engine-ai-agent-quality/)
