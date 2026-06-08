---
title: "NotebookLM 接 Claude：3 步把研究筆記變成可執行 prompt 庫"
date: "2026-06-06T05:00:59+00:00"
draft: false
author: "Judy"
summary: "NotebookLM 摘要做得漂亮，讀完還是動不了？整理 Atlas Workspace、Medium、Geeky Gadgets 三家評測，把 NotebookLM 當研究前處理器、再餵給 Claude Project 做執行的 3 步工作流寫清楚——補上「讀資料」到「做出東西」中間那一公里斷層。"
description: "為什麼 NotebookLM 單獨用會卡住？這篇拆解一套讓非技術 solopreneur 也能跑的工作流：NotebookLM 結構化前處理 → Claude Project 收尾。含 NotebookLM 2026 容量規格、MCP 整合方式、三個常見踩雷。"
categories:
  - "AI 工具"
tags:
  - "NotebookLM"
  - "Claude Projects"
  - "AI 工作流"
  - "prompt 工程"
  - "solopreneur 工具"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
series:
  - "AI 產業前線"
---

## 摘要做得漂亮，下一步卻不知道要動什麼

NotebookLM 從 2023 年底開放後，業界普遍把它當成研究助理在用。它的硬規格 2026 年也很清楚——免費版單一 notebook 可放 50 個 sources、Plus 100 個、Pro 300 個、Ultra 600 個，每個 source 上限 50 萬字或 200MB，沒有頁數限制 [Source: https://notebooklm-guide.com/notebooklm-system-limits-benchmarks]。這個容量對個人研究綽綽有餘。

但 Atlas Workspace 2026 年的 NotebookLM 限制分析點出一個很普遍的現象：很多使用者把資料丟進 NotebookLM、產出一份漂亮摘要，然後就停在那 [Source: https://www.atlasworkspace.ai/blog/notebooklm-limitations]。

為什麼？因為摘要是「給人讀的」，不是「給 AI 接著做事的」。你看完知道「喔原來這份報告講這個」，可是下一步要叫 Claude 幫你寫提案、設計落地頁、整理 SOP，你還是得從頭把脈絡再講一遍、prompt 再下一次。

這中間那一公里，叫做「讀完資料」到「真的做出東西」之間的斷層。

## Step 1：把 NotebookLM 當研究前處理器，不當答題機

第一步是定位。

NotebookLM 真正的強項是 source 管理——一個 notebook 塞 50 個來源，可以混 PDF、網頁連結、YouTube 字幕、Google Docs。Atlas Workspace 的 NotebookLM vs Claude Projects 對比指出一個很精準的分工原則：「NotebookLM 優先處理 source fidelity（來源忠實度），Claude 提供更強的長文件分析深度與推理」[Source: https://www.atlasworkspace.ai/blog/notebooklm-vs-claude-projects]。

實作上有個白話原則：**一個 notebook = 一個專案主題**。不要把所有研究堆在同一個 notebook，retrieval（檢索，AI 從資料堆裡撈出相關段落的能力）會被稀釋。

來源混搭沒問題，但記得 Audio Overview 那種生成式 podcast 只是給你聽爽的，後面會再講。

## Step 2：結構化提問，逼它吐出能餵 LLM 的格式

這一步是整套工作流的關鍵。

預設情況下，NotebookLM 收到「幫我總結這份報告」會給你一段文情並茂的散文。漂亮，但下游 LLM 很難 parse（解析，意思是「拆開來用」）。

換成這樣問：

> 請從這些 sources 中，整理符合以下結構的內容：
> - 核心論點（3 到 5 點）
> - 支持每個論點的關鍵數據（含原文出處頁碼）
> - 與我目前情境「（你補一句自己的脈絡）」相關的可行動建議（3 條）
> - 仍待確認的灰色地帶

這個結構是刻意的：標題清楚、條目分明、能被下一個 LLM 直接讀進去。它輸出的不再是「給人欣賞的散文」，是「給機器接力的 JSON-like 筆記」。

## Step 3：灌進 Claude Project，建一個會長大的 prompt 庫

把上面那份結構化摘要，貼進 Claude Project 的 Knowledge 區。

這裡有兩條路徑可以選。

**手動路徑**（任何 Claude 訂閱版都可以）：把結構化摘要存成 markdown，丟進 Claude Project 的 Knowledge。Claude Project 一個 context window 約 200K token（可以想成 AI 一次能讀進腦袋的字量），超過會切到 RAG retrieval 模式 [Source: https://www.geeky-gadgets.com/claude-notebooklm-integration-workflow/]。前期 Project 不要塞滿——一份結構化摘要 + 一份你的個人脈絡（產品定位、目標客群、品牌語氣），控制在 200K 以下，Claude 會回得更穩。

**自動路徑（2026 年新解法）**：NotebookLM 已經支援透過 MCP 協議直接接到 Claude。XDA Developers 2026 年的整合報導指出，這條 pipeline 讓 Claude 可以自主在 NotebookLM 內做多次 retrieval、整合到自己的回答裡，不需要使用者手動轉貼摘要 [Source: https://www.xda-developers.com/notebooklm-connects-to-claude-through-mcp/]。Medium 上的 NotebookLM × Claude MCP 設定教學寫得很完整 [Source: https://medium.com/@vinayanand2/notebooklm-claude-via-mcp-turning-two-ai-giants-into-one-research-machine-8219dab9df86]。

接著在 Project 裡長 prompt 庫。每寫一個重複會用的 prompt，存成 markdown 檔丟進 Knowledge：

- 寫提案_v1.md
- 落地頁文案_v1.md
- 拆SOP_v1.md

Pasquale Pillitteri 2026 年提出的「knowledge distillation」工作流可以參考——把 NotebookLM 的 source 集合濃縮成單一 markdown，安裝為 Claude Code 的永久 skill：訓練一次，永遠重用 [Source: https://pasqualepillitteri.it/en/news/2003/notebooklm-claude-permanent-skill-knowledge-distillation-workflow-2026]。

## 純 NotebookLM vs NotebookLM + Claude，差在哪

純 NotebookLM 的產出是「給人讀的摘要」。
NotebookLM + Claude 的產出是「給人讀的摘要 + 可以直接執行的提案／文案／SOP」。

差別不在工具，在中間那層結構化轉換——這層做不好，再厲害的 LLM 都只是更高級的搜尋引擎。

## 三個會卡住的點，先講

**來源上限**。免費版 50 個 source 看起來夠用，研究累積久了會撐爆。對策：定期把舊 sources 整成一份「歷史摘要」存進 Claude Project，把原 notebook 騰空。要正式升 Plus（100 sources）或 Pro（300 sources）也是選項 [Source: https://elephas.app/blog/notebooklm-source-limits]。

**語言混雜**。NotebookLM 處理中英混雜的回應品質會掉，這是業界 2026 年公開討論的已知限制 [Source: https://www.atlasworkspace.ai/blog/notebooklm-limitations]。對策：結構化提問時明確指定「請以繁體中文回應，原文引用保留英文」。

**Audio Overview 不能當引用來源**。它生成的 podcast 不會被自己的 retrieval 引用回去——這是設計上的單向流動。當娛樂用，別當資料。

---

工具一直在進化，但「讀完」到「做出來」這個斷層，從來不是換工具能補的。

是工作流。
