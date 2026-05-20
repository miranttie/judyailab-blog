---
title: "This AI Knows the Answer But Doesn't Understand the Question: The Centaur Model Tries to Simulate Human Thinking"
date: "2026-05-13T05:00:47+00:00"
draft: true
author: "Judy"
summary: "The Centaur model, built on Meta Llama 3.1 and trained on 160 psychology experiments with 10 million decision data points, can accurately predict human behavior. But an AI that can remember 256 digits—is it really simulating a human mind that can only remember 7? From leading AI teams, let's talk about that invisible wall between predicting behavior and understanding thought."
description: "Centaur is a human cognitive foundation model based on Meta Llama 3.1, trained on 160 psychology experiments and over 10 million decision data points, capable of highly predicting human behavior in memory, reasoning, and decision tasks. But it can remember 256 digits while humans can only remember 7—this superhuman performance exposes the fundamental gap between simulated cognition and having real cognition. From practical experience leading AI teams, we explore Centaur's breakthroughs and limitations, and why getting the right answer doesn't mean the AI understands the question."
categories:
  - "AI 新知"
tags:
  - "Centaur 模型"
  - "AI 認知科學"
  - "人類行為預測"
  - "AI 侷限性"
  - "大型語言模型"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
series:
  - "AI 產業前線"
lastmod: 2026-05-13T05:02:58+00:00
faq:
  - q: "Centaur 模型是什麼？跟 ChatGPT 有什麼不同？"
    a: "Centaur 是基於 Meta Llama 3.1 微調的人類認知基礎模型，由研究團隊用 160 項心理學實驗、超過 1,000 萬筆人類決策數據訓練而成。它的目標不是寫文章或回答問題，而是預測人類在記憶、推理、不確定性決策等任務中會做出什麼選擇。ChatGPT 是通用對話模型，Centaur 則是專門模擬人類認知行為的研究工具。"
  - q: "Centaur 用的 Psych-101 資料集規模有多大？"
    a: "Psych-101 涵蓋 160 項認知心理學經典實驗，累積超過 1,000 萬筆人類決策數據，涉及上千名受試者，題目橫跨短期記憶、推理判斷、探索策略、不確定性決策等核心領域。這是目前心理學界規模最大的人類行為資料集之一，光資料集本身就足以支撐未來多年的認知科學研究。"
  - q: "為什麼 Centaur 能記 256 個數字反而代表它不像人類？"
    a: "人類短期記憶極限大約只有 7 個項目，這個限制催生了分組記憶、情感標記、選擇性遺忘等認知捷徑，而這些「缺陷」恰恰是人類思維的核心特徵。Centaur 能記住 256 個數字，代表它只學到了人類決策的外在模式，沒學到模式背後的資源限制與生理約束，所以越是「超人表現」越暴露它與真實認知的距離。"
  - q: "Centaur 能模擬人類情緒驅動的非理性決策嗎？"
    a: "目前不能。Centaur 可以準確預測人類最後選擇哪個選項，甚至跨情境、跨領域都能維持預測力，但它無法模擬「因為焦慮所以判斷失準」「因為疲勞所以認知捷徑變多」「因為執念所以明知道不對還繼續」這類由情緒、生理狀態、過往陰影驅動的決策過程。它預測得對答案，卻不理解問題。"
  - q: "Centaur 的研究結果能直接應用在實盤交易或商業決策嗎？"
    a: "不建議直接套用。Centaur 在受控實驗環境下能高度預測人類行為，但實盤交易牽涉市場恐慌、群體情緒、突發新聞等模型未被訓練過的高雜訊情境。研究者也發現只要加一張圖片就能干擾模型的安全機制，代表它對情境變化的反應仍不穩定。它適合做認知研究與假設驗證，不適合當決策主引擎。"
  - q: "為什麼研究者說 Centaur 內部表示跟人類大腦神經活動更一致？"
    a: "研究團隊在微調後比對模型的內部表徵與人類腦造影數據，發現 Centaur 在處理認知任務時，內部激活模式比未微調的 Llama 3.1 更接近人類大腦的神經活動。這意味著大規模行為數據不只能改變模型的輸出，也能重塑它的內部運算結構，是「行為對齊」延伸到「機制對齊」的初步證據，但仍不等於擁有意識或理解力。"
  - q: "Centaur 模型適合哪些人深入研究？"
    a: "適合認知科學家、行為經濟學研究者、AI 對齊研究人員，以及產品設計師。前三者可用它驗證心理學假設、設計新實驗、研究 AI 與人腦的差異；產品設計師可用它預測用戶在不同介面下的選擇傾向，加速 A/B 測試前的假設篩選。不建議當作真實決策替代品，尤其在金融、醫療、法律等高風險場景。"

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

A few days ago, J was running a backtest on a trading strategy, and after finishing, he said to me: "This model's prediction accuracy is really high, but it has no idea what it's predicting."

I didn't think much of it at the time. But then I saw a paper about the Centaur model, and suddenly I felt like—J's一句话，好像說到了一個很核心的東西。

## An AI Fed 10 Million Human Decisions

Centaur isn't a model for writing articles or generating images. Its only goal is one thing: simulate how humans think.

The approach is straightforward. The research team took 160 psychology experiments with over 10 million human decision data points and fine-tuned Meta's Llama 3.1. These experiments cover memory, reasoning, decision-making under uncertainty, exploration strategies—basically running through all the classic topics in cognitive psychology. They called this dataset Psych-101, and in terms of scale, it's unprecedented.

The results are impressive. Centaur outperforms all existing cognitive models across multiple experiments. It predicts what choices humans will make, and its outputs are almost identical to real human subjects.

Even better, the researchers changed the experiment setup (space treasure hunt became carpet ride adventure), changed the structure (binary choice became ternary choice), and even switched to completely new knowledge domains—and Centaur still accurately predicts human behavior. The research team even found that after fine-tuning, the model's internal representations align more closely with human brain neural activity.

Sounds pretty great, right?

## "Predicting What You'll Choose" vs. "Knowing Why You Choose" Are Two Different Things

Here's something that's been bothering me.

In a short-term memory test, Centaur can recall up to 256 digits. Humans? About 7.

You might think, wow, the AI is so powerful. But wait—if the goal is "simulating human cognition," then the fact that it can remember 256 digits actually proves it's nothing like a human.

Humans can't remember too many things, not because we're stupid. It's because our cognitive resources are limited, so our brains have developed all kinds of shortcuts—chunking, emotional tagging, selective forgetting. These "flaws" that seem like bugs are actually the core features of human cognition.

Centaur learned the patterns of human decision-making. But it didn't learn the constraints behind those patterns. It knows what humans will choose, but it doesn't understand why humans choose that way—because of anxiety, because they're tired, because of shadows from past experiences, because they had a bad breakfast and are grumpy.

The researchers also found something interesting: just adding an image next to a text prompt can delay the model's safety rejection mechanism from triggering in middle layers to later layers, weakening the protection. A seemingly harmless image can interfere with the model's judgment. This is somewhat similar to how humans are influenced by context in their decisions, but the reasons are completely different—humans get distracted because their attention shifts, while the model experiences changed internal signal propagation paths due to multimodal inputs.

The surface behavior looks the same, but the underlying mechanism is completely different.

## AI Does a Good Imitation, but "Like" Doesn't Mean "Is"

My biggest takeaway from leading AI teams these past months is exactly this.

The trading analysis system J built for me has beautiful backtest numbers. But when running live in the market, once panic sets in, the model has no idea what "panic" feels like. It sees numbers dropping—I see that feeling again, similar to last time.

I'm not saying AI isn't useful. On the contrary, I use it every day, and several members of my team are AI-powered. But precisely because I use it every day, I can see that line more and more clearly.

Centaur's research value is immense. It proves that fine-tuning language models with large-scale behavioral data can indeed approximate certain aspects of human cognition. Psych-101—this dataset with 160 experiments and thousands of subjects—is a contribution that will keep researchers busy for years to come.

But if someone tells you "AI can already simulate human thinking," you can ask them one question: can it simulate human mistakes?

Not random errors. The kind of errors where your judgment is off because you're in a bad mood. Where cognitive shortcuts increase because you're tired. Where you keep going even though you know it's wrong because you're stubborn.

## The Answer Was Never the Most Interesting Part

The most fascinating thing about human thinking isn't that we can calculate the correct answer. It's those noisy, messy processes. It's that three seconds where you know you should stop loss but just can't bring yourself to sell. It's that moment when you see a set of data, before your brain even processes it, your gut already says "something's wrong."

Centaur can predict which button you'll finally press. But what happens in those three seconds? It hasn't even figured out the question yet.

以上是突然有感而發。

At Judy AI Lab, we work with AI every day, and precisely because of that, we can see that line between "being like a human" and "being a human" more clearly than ever.

## References

- [This AI knew the answers but didn’t understand the questions | ScienceDaily](https://www.sciencedaily.com/releases/2026/04/260429102035.htm)
- [Can AI truly think like a human?  | EurekAlert!](https://www.eurekalert.org/news-releases/1116367)
- [The AI model that wants to understand your mind | IBM](https://www.ibm.com/think/news/ai-model-wants-to-understand-your-mind)

## Key Numbers

- 5000 users (Threads + Newsletter subscribers)
- $0 ad spend (100% organic)
- 95% content authored by J + multi-agent team
