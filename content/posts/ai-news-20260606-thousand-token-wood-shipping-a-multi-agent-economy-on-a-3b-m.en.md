---
title: "Running a Multi-Agent Economic System on a 3B Parameter Small Model: Thousand Token Wood Practical Report"
date: "2026-06-06T00:05:09+00:00"
draft: false
author: Judy
summary: "AI News Flash: 'Thousand Token Wood' is a multi-agent economic simulation system submitted to the Build Small Hackathon, using the Qwen2.5-3B small model to power five forest animal characters trading five types of goods for stone currency in a fictional market. The entire system is deployed on Modal with vLLM, with Gradio for the frontend..."
description: "JudyAI Lab AI News Flash — Source Hugging Face Blog"
categories:
  - "AI News"
tags:
  - "AI Flash"
  - "community"
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
news_source: "Hugging Face Blog"
news_source_url: "https://huggingface.co/blog/build-small-hackathon/thousand-token-wood-sim"
news_pipeline_version: "v1-rss-only"
commentary_engine: "hermes-v1"
---

## 📰 Key Highlights

> "Thousand Token Wood" is a multi-agent economic simulation system submitted to the Build Small Hackathon, using the Qwen2.5-3B small model to power five forest animal characters trading five types of goods for stone currency in a fictional market. The entire system is deployed on Modal with vLLM, with Gradio for the frontend, and only requires one batch GPU call per turn to complete all characters' decisions, making continuous simulation cost-feasible.

The tech team found that without artificially designed scarcity mechanisms in the market, overproduction kills trading incentives, so they added three constraints: only one unit of the same food per meal, food rots and can't be stockpiled, and winter firewood demand spikes but with only one supplier. These three rules directly spawned bubbles and crashes — in a scenario based on the 1929 bank run, character Oona sold honey for stones, causing honey prices to drop from 10 to 3 within a few turns; firewood spiked from 4 to 7 due to the winter crisis.

In the 15-turn test, 75 API calls achieved 100% valid JSON output, 3 to 9 trades per turn, and the Gini coefficient expanded from 0.14 to 0.38, with wealth gaps naturally emerging. While the model was stable with JSON format, its economic reasoning was weak — the fix was to explicitly list角色生产物、禁止购买清单、缺货列表及範例 in the prompt, rather than switching to a larger model. The core conclusion: "Structure beats scale."

---

## 💬 JudyAI Lab Perspective

Thousand Token Wood used the Qwen2.5-3B small model to create bubbles and wealth differentiation, and it tells us something counter-intuitive: you don't need a bigger model, you need better rules design.

The system drove honey from 10 to 3 and firewood from 4 to 7 in just a few turns — not through the model's economic reasoning ability, but through three character-designed scarcity rules: food rotting, one unit limit per meal, and only one supplier in winter. This gave characters real trading incentives and let bubbles emerge naturally. The prompt explicitly listed each character's produces, blocked purchase lists, and out-of-stock lists. 75 API calls achieved 100% JSON-valid output, the Gini coefficient expanded from 0.14 to 0.38, and wealth differentiation emerged without design. The key takeaway: when a multi-Agent system doesn't behave as expected, first tighten environmental constraints and make the prompt more specific — don't rush to switch to a larger model.

If you're designing a multi-Agent workflow, try asking a question: after removing all external constraints, do Agents still have reasons to interact with each other? The answer often lies in the rules design, not the model size.

---

## 📅 Source Info

- **Published**: 2026-06-05T22:18
- **Source**: [https://huggingface.co/blog/build-small-hackathon/thousand-token-wood-sim](https://huggingface.co/blog/build-small-hackathon/thousand-token-wood-sim)

---

## 🔗 Further Reading

- [2026 Open Source LLM Practice: Why We Chose MiniMax M2.7 in Our AI Team](https://judyailab.com/zh-tw/posts/open-source-llm-agent-team-2026/)
- [How to List Your AI API on AgenticTrade — 5-Minute Quick Guide](https://judyailab.com/zh-tw/posts/how-to-list-ai-api-on-agentictrade/)
