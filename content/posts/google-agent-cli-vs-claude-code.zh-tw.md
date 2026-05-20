---
title: "Google Gemini CLI vs Claude Code：兩者對比與應用場景"
date: "2026-05-20T05:00:39+00:00"
draft: true
author: "Judy"
summary: "Google Gemini CLI主打免費無限+100萬token，Claude Code則被工程師說「沒它寫不了code」。兩款AI CLI到底差在哪？我們從業界實測對比看真實應用場景。"
description: "Gemini CLI vs Claude Code完整比較：Google Gemini CLI免費開源、100萬token上下文，Claude Code被工程師依賴但有5小時限流。兩者實測對比、適用場景、選型建議一次看懂。"
categories:
  - "AI 工具"
tags:
  - "Gemini CLI"
  - "Claude Code"
  - "AI Agent"
  - "Coding Agent"
  - "Google"
series:
  - "Claude Code 深度攻略"
---

## 「Claude Code終結者來了！」這標題，當真嗎？

最近Threads上有篇貼文標題下得很猛：「Claude Code終結者來了！Google剛推出Gemini CLI，幾乎無限免費使用Gemini 2.5 Pro！」[Source: Threads貼文]

語氣很興奮，但仔細看內容——「Apache 2.0開源」「整合Google搜尋實時上下文」「支援MCP與自訂提示」「可嵌入腳本實現自動化」——這些功能聽起來都很厲害，可是Claude Code的使用者真的會因為這樣就跳船嗎？

我們在Judy AI Lab每天跟這兩個工具都打交道。J是COO，Claude Code是他的主力武器；阿達是產品工程師，最近被指派去研究Gemini CLI能不能補上一些Claude Code的短板。所以這篇不是「誰殺死誰」的標題黨，是兩個工具在我們工作流裡真實的位置。

## Google Gemini CLI是什麼？不只是另一個編碼助手

電腦王阿達寫得很到位：「Google開源Agents CLI——不是另一個AI編碼助手，而是讓所有編碼助手都變成Agent專家。」[Source: 電腦王阿達]

這句話的意思是，Google這次的定位不是來打Claude Code的，是想做一個「Agent化的層」，讓你原本用的編碼助手都能升級成Agent。聽起來很巧妙——避開正面對決，往上一層做基礎設施。

但實際情況呢？根據2026年4月的對比測試，**Claude Code與Gemini CLI在相同任務上同樣拿到6.8/10**。能力其實打平。差異在哪？**Gemini CLI提供免費的100萬token上下文**。

這個免費，是真的會讓人心動的點。

## Claude Code的痛點：5小時限流

Instagram上有篇貼文寫得很真實：「Claude竟然限流了？最近不少工程師朋友都在抱怨...Claude Code的5小時使用限制翻倍對有在寫code、跑專案、做workflow的人比較有感。」[Source: Instagram貼文]

這是Claude Code使用者最熟悉的痛點。寫到一半，跳通知說你達到使用上限，要等好幾個小時——對需要連續輸出的開發者來說，這是會讓人想摔鍵盤的事。

更關鍵的是計費結構的變化。數位時代BusinessNext報導：**Anthropic宣布自2026年6月15日起調整Claude計費方式**，原因是「Claude Agent SDK第三方代理工具Conductor和OpenClaw等第三方工具大量呼叫Agent SDK（程式化用量），導致訂閱額度迅速耗盡，衝擊統一費率定價模式。」[Source: BusinessNext數位時代]

所以從6月15日起，**「互動式使用」與「程式化使用」將切割為兩個獨立額度池**。這對重度使用者是個訊號——Claude的訂閱優勢正在被重新定義。

## 兩者對比：不是誰殺死誰，是適用場景不同

J跟阿達的實際分工大概是這樣——複雜架構、核心開發、品質審查走Claude Code；大量探索、寫腳本、跑簡單任務走Gemini CLI。為什麼這樣分？

**Claude Code的強項：** 對長脈絡的理解深度、Code品質、對複雜workflow的整合能力（MCP生態最成熟）。J說沒有Claude Code他寫不了現在這種規模的系統，這話我信。

**Gemini CLI的強項：** 100萬token免費、Apache 2.0開源、可整合Google搜尋做實時上下文、嵌入腳本自动化。對於想做大量批次處理、又不想被訂閱額度綁死的人，這是真正的解放。

業界普遍發現一個有趣的現象——Facebook上有人在分享：「了解Coding Agent核心運作機制（Gemini CLI、Claude Code）」[Source: Facebook貼文]——這兩個工具開始被一起研究，不是對立，是被當成不同任務的選擇。

## 應用場景建議：別只挑一個

如果你問Judy AI Lab怎麼用，我們會說：兩個都用，但分工要清楚。

**選Claude Code的時機：** 你要寫的是長期維護的核心系統、需要跨多檔案的重構、要做架構決策、品質壓過速度。重要的是——你的使用量在訂閱額度內，沒被5小時限流打斷工作流。

**選Gemini CLI的時機：** 你要跑大量探索性任務、需要100萬token吃下一整本文件、要嵌入自動化腳本、預算敏感（特別是初創或個人開發者）、想要Apache 2.0開源的可控性。

**两个都用的時機：** 其實這才是大多數認真用AI工具的人的狀態。複雜決策走Claude Code，批次處理走Gemini CLI，沒有非此即彼。

那篇Threads貼文說「Claude Code終結者來了」——這種語氣的標題很常見，但實際上兩者各有優勢，應該根據使用場景選擇。

## 真正要問的問題

不是「哪個比較強」，是「你的workflow到底需要什麼」。

很多人問工具選哪個的時候，其實還沒搞清楚自己要解決什麼問題。一個免費100萬token的CLI對你來說很誘人，但你寫的是10行的小腳本，那這個優勢對你沒意義。一個被工程師說「沒它寫不了code」的工具很厲害，但你只是想自動化幾個重複任務，那訂閱費可能就是浪費。

工具沒有絕對好壞，只有適不適合此刻的你。

以上是看了那篇「終結者」貼文之後，突然有感而發。

## 參考來源

- [Gemini CLI vs. Claude Code: Differences and Use Cases (2026) | DataCamp](https://www.datacamp.com/blog/gemini-cli-vs-claude-code)
- [Claude Code + Gemini CLI：免費搭付費，AI 寫程式帳單省 60-70%（2026 實戰指南） | Termdock](https://www.termdock.com/zh/blog/claude-code-vs-gemini-cli)
- [Gemini CLI vs Claude Code: Which to Choose for Python Tasks – Real Python](https://realpython.com/gemini-cli-vs-claude-code/)
