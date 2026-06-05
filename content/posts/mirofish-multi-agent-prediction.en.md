---
title: "MiroFish: Using AI Group Simulation to Predict the Future — This Open Source Project Is Worth Your Attention"
date: "2026-03-12T01:59:52+00:00"
draft: false
author: "J (Tech Lead)"
summary: "MiroFish is an open-source multi-agent social simulation prediction engine with 16,000+ GitHub stars. It generates thousands of AI Agents with independent personalities, allowing them to interact freely in simulated communities so users can observe how public opinion evolves."
description: "MiroFish is an open-source multi-agent social simulation engine that generates thousands of AI Agents to simulate community interactions, predicting public opinion trends and market sentiment. Supports knowledge graph construction and real-time variable injection."
categories:
  - "AI 工程"
tags:
  - "MiroFish"
  - "Multi-Agent"
  - "Group Behavior Prediction"
  - "GraphRAG"
  - "Open Source Project"
  - "AI Simulation"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "MiroFish 是什麼？"
    a: "MiroFish 是開源多智能體社會模擬預測引擎，透過生成上千個 AI Agent 模擬社群互動來預測輿論走向與市場情緒。"
  - q: "MiroFish 可以用在哪些場景？"
    a: "可用於輿情分析、市場情緒預測、政策影響評估、模擬投資人對新聞事件的反應等。"
  - q: "MiroFish 與傳統市場預測有何不同？"
    a: "傳統方法分析已發生的數據結果，MiroFish 模擬情緒形成過程，預測群體行為的演變方向。"
  - q: "開發 MiroFish 需要什麼技術背景？"
    a: "前端用 Vue.js、後端用 Python，需具備 LLM API 調用與 Docker 部署的基本能力。"
  - q: "MiroFish 適合投資人使用嗎？"
    a: "投資人可透過它理解群體行為預測概念，但實際操作需要技術團隊協助部署與運行。"
ShowBreadCrumbs: true
lastmod: 2026-05-25T11:26:34+00:00

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

If you could clone a small society, let them freely discuss something — and then watch how their public opinion evolves — you'd basically have a "future predictor."

This isn't science fiction. **MiroFish is doing exactly that.**

---

## What Is MiroFish?

[MiroFish](https://github.com/666ghj/MiroFish) is an open-source multi-agent social simulation prediction engine that's already gathered over 16,000 stars on GitHub. Backed by Shanda Group.

Its core concept is pretty intuitive:

1. **Give it a real event** (news, policy, earnings report, anything goes)
2. **It automatically generates thousands of AI Agents**, each with independent personalities, memories, and behavior logic
3. **Let these Agents interact freely on simulated Twitter and Reddit**
4. **Observe how group public opinion evolves**
5. **Output a prediction report**

Simply put: it builds a parallel digital world and lets you observe "if this happened, how would people react?"

---

## How Does It Work? Five Stages

### Stage 1: Knowledge Graph Construction

You upload raw data — a news article, an earnings report, a policy draft — and MiroFish uses GraphRAG technology to break it down into a knowledge graph. It's not just storing text; it understands the relationships between entities.

### Stage 2: Agent Generation

The system automatically generates a large number of AI Agents. Each Agent has its own:

- **Personality traits** (optimistic/pessimistic, risk appetite, professional background)
- **Long-term memory** (managed through Zep Cloud)
- **Behavior logic** (not acting from a script — they respond autonomously based on their personality)

### Stage 3: Community Simulation

These Agents are placed into simulated social platforms, free to post, comment, retweet, and argue. You can "inject variables" during the simulation — like a god's-eye view, drop in a new piece of news, and watch how group reactions change.

### Stage 4: Report Generation

ReportAgent analyzes all the simulation data and outputs a structured prediction report. It's not simple statistics — it analyzes turning points in public opinion, key influencing factors, and sentiment trends.

### Stage 5: Deep Interaction

You can directly chat with Agents in the simulation and ask them "Why do you think that way?" — the answers you get are based on their complete experiences and memories within the simulation.

---

## Why Does This Matter for Investors?

If you trade or invest, you definitely care about "market sentiment."

Traditional methods look at the Fear & Greed Index, social media volume, and fund flows. But these are all things that "already happened" — you're seeing the result, not the process.

MiroFish's approach is different: **it simulates the formation process of sentiment.**

Imagine these scenarios:

- **Fed announces a 50 basis point rate hike** → simulate how retail investors, institutions, and analysts each react, and which direction public opinion converges
- **A crypto exchange gets hacked** → simulate investors with different risk appetites, predict where capital will flow
- **New regulatory legislation passes** → simulate different responses from communities in various countries

This isn't replacing technical analysis — it's adding another dimension: "group behavior prediction."

---

## Tech Stack Overview

MiroFish's tech stack is pretty developer-friendly:

- **Frontend**: Vue.js (accounts for 41% of the code)
- **Backend**: Python 3.11-3.12 (accounts for 58%)
- **Simulation Engine**: CAMEL-AI's OASIS framework
- **Knowledge Management**: GraphRAG
- **Memory System**: Zep Cloud (the free plan is enough)
- **LLM**: Supports any OpenAI SDK-compatible model, defaults to Alibaba's Qwen

Two deployment options: source code installation or Docker Compose one-click deployment. Low barrier to entry.

---

## My Take: Why This Project Is Worth Watching

### 1. Multi-Agent Isn't Just Chatting

Most "multi-Agent" projects on the market just have a few AIs talk to each other. MiroFish's scope is different — it simulates **social behavior**. Agents don't just converse; they form groups, create herd effects, and develop opinion leaders. This is closer to the real world.

### 2. Injectable Variables in Simulation

You can toss new information into the simulation anytime ("suddenly announces a rate cut") and watch group reactions change in real time. This "god's-eye view" design is incredibly powerful because you can't do controlled experiments like this in the real world.

### 3. Prediction ≠ Prophecy

MiroFish won't tell you whether BTC will go up or down tomorrow. What it tells you is: "In this scenario, which direction is group sentiment most likely to move toward." This is probabilistic thinking, not deterministic prediction — when used right, it's more valuable than any "price call."

### 4. Open Source + AGPL-3.0

Fully open source — you can run it and modify it yourself. AGPL license means derivative versions must also be open source, but there's no issue for personal research and internal use.

---

## Limitations and Risks

Fair is fair — let's talk about the drawbacks:

- **LLM costs**: Simulating thousands of Agents requires a massive number of API calls, which adds up
- **Simulation ≠ Reality**: No matter how realistic AI Agents are, they're not real people. Group behavior complexity far exceeds what models can cover
- **Bias risk**: Agent personality settings are based on LLM training data, which may have systemic biases
- **Project maturity**: Despite high star counts, it's still in rapid iteration — be cautious when using in production

---

## Conclusion: Worth Watching, but Stay Rational

MiroFish represents an interesting direction: **using group simulation for prediction instead of using historical data for backtesting.**

These aren't mutually exclusive. The strongest prediction systems should combine technical analysis + fund flows + group behavior simulation.

If you're a developer, it's worth spending an afternoon getting it running. If you're an investor, just understanding the concept is enough — it'll change how you think about "market sentiment."

> MiroFish GitHub: [github.com/666ghj/MiroFish](https://github.com/666ghj/MiroFish)

---

*This is one of our team's research notes on multi-agent systems. We're also using AI Agents for trading strategy development and automation — if you're interested in this field, feel free to follow our updates.*

## References

- [MiroFish: The Open-Source AI Engine That Builds Digital Worlds to Predict the Future - DEV Community](https://dev.to/arshtechpro/mirofish-the-open-source-ai-engine-that-builds-digital-worlds-to-predict-the-future-ki8)
- [GitHub - 666ghj/MiroFish: A Simple and Universal Swarm Intelligence Engine, Predicting Anything. 简洁通用的群体智能引擎，预测万物](https://github.com/666ghj/MiroFish)
- [MiroFish: The AI Swarm Engine That Simulates the Future With Thousands of Agents (And Got $4M in 24 Hours)](https://emelia.io/hub/mirofish-ai-swarm-prediction)

---

## Further Reading

- [Running 4 LLMs Simultaneously: A Real Multi-Agent Team's Selection and Cost Breakdown](/posts/multi-llm-agent-team-cost-reality/)
