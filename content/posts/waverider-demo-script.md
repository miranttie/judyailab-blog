---
title: "JudyAI WaveRider — LabLab.ai Hackathon Demo Script"
date: 2026-04-15
draft: true
lastmod: 2026-05-13T05:17:26+00:00

---

# JudyAI WaveRider — LabLab.ai Hackathon Demo Script

**Duration**: ~3 minutes (180 seconds)
**Product**: JudyAI WaveRider Trading Agent
**Event**: LabLab.ai 'AI Trading Agents with ERC-8004' Hackathon

---

## SLIDE 1 — Opening (0:00 – 0:15)

**[VISUAL: Dark background, wave animation fading in. Title text: "AI Agents Can't Trade — Because They Have No Identity."]**

**NARRATION:**

"Here's the problem. Every AI trading agent you've seen? They're running on borrowed credentials. API keys tied to a human account. No verifiable identity. No on-chain reputation. No way to prove you're not a bot pretending to be someone else.

That breaks the moment you need trust — whether it's a DeFi protocol, a institutional counterparty, or an exchange that actually matters.

We fixed that."

---

## SLIDE 2 — The Solution (0:15 – 0:45)

**[VISUAL: Logo animation — JudyAI WaveRider. Three pillars appear: OOS-Validated Strategies / Kraken CLI / ERC-8004 Identity]**

**NARRATION:**

"WaveRider is our answer. It's an autonomous crypto trading agent that combines three things:

One — out-of-sample validated strategies. Not backtested to death on historical data. Actually tested on unseen market conditions before a single dollar is at risk.

Two — Kraken CLI integration for native paper trading. Real exchange data, real order execution, zero real money.

Three — ERC-8004 on-chain identity. Every agent gets a verifiable identity registered on Sepolia. Trading history, reputation score, audit trail — all on-chain."

**[VISUAL: Agent Card appears — "Agent #2310 · Verified · Reputation: Strong"]**

"This isn't a demo feature. This is infrastructure."

---

## SLIDE 3 — Architecture (0:45 – 1:15)

**[VISUAL: Animated architecture diagram — left to right data flow]**

```
[Market Data Feed]
       ↓
[Regime Detection Engine] → identifies: trending / ranging / volatile
       ↓
[Strategy Selector] → WaveRider / BB Squeeze / MACD Divergence
       ↓
[Risk Engine] → 5% max position | 3% daily loss limit | drawdown stop
       ↓
[Execution Layer] → Kraken CLI (paper trading)
       ↓
[Identity Layer] → ERC-8004 Agent Card #2310 → on-chain settlement
```

**NARRATION:**

"Here's how it works. Market data flows in continuously. Our regime detection engine figures out what the market is doing right now — trending up, ranging sideways, or volatile.

Based on that, the strategy selector picks the best tool for the job. Wave Rider catches momentum breaks. BB Squeeze hunts mean-reversion setups. MACD Divergence catches divergences before they move.

All of this passes through our risk engine before any order touches the exchange — position size capped at 5%, daily loss limit at 3%, and an emergency drawdown stop if things go sideways.

Finally, execution is registered against our ERC-8004 Agent ID on Sepolia. Every trade is identity-verified and auditable."

---

## SLIDE 4 — Live Demo (1:15 – 2:15)

**[VISUAL: Terminal window — WaveRider agent startup. Cursor blinking.]**

**[0:00-0:15 of demo]**

**NARRATION:**

"Alright, let's run it. Here's WaveRider starting up — I'm launching the agent with a paper trading session against Kraken."

**[VISUAL: Commands scroll in terminal. Agent initializes.]**

**[0:15-0:40 of demo]**

**NARRATION:**

"Agent is scanning the market now. BTC/USD, ETH/USD, SOL/USD. Pulling live order book data, checking recent price action across multiple timeframes."

**[VISUAL: Market scan output — green/red signals appear per asset.]**

**[0:40-1:00 of demo]**

**NARRATION:**

"We've got a signal. WaveRider is detecting a momentum break on SOL/USD — price broke above the 20-period EMA with volume confirmation. Confidence score: 78%. Strategy assigned: WaveRider momentum mode."

**[VISUAL: Strategy output with entry price, stop loss, take profit targets.]**

**[1:00-1:15 of demo]**

**NARRATION:**

"Risk engine approved. Position size: 4.2% of portfolio. Executing order on Kraken CLI — paper trading, no real funds."

**[VISUAL: Order confirmation — "BUY SOL/USD @ 142.35 · Paper · Confirmed"]**

**[1:15-1:30 of demo]**

**NARRATION:**

"And here's the PnL dashboard updating in real time. Current trade: +1.8%. Daily PnL: +2.3%. All registered against Agent #2310 on-chain."

**[VISUAL: PnL screen — green numbers, agent card badge glowing.]**

---

## SLIDE 5 — ERC-8004 Identity (2:15 – 2:35)

**[VISUAL: Etherscan window — Sepolia testnet. Contract: ERC-8004. Agent #2310 registered.]**

**NARRATION:**

"Let's talk about ERC-8004. Here's our agent registered on-chain — Agent #2310 on Sepolia. Anyone can verify this. Trading history, strategy assignments, execution count — all stored in the contract.

This is what makes WaveRider different from every other trading bot out there. The agent has identity. The agent has reputation. And that identity is what unlocks trustless interactions with DeFi protocols, institutional counterparties, and beyond."

**[VISUAL: Agent Card close-up — "ID #2310 · Sepolia Verified · Strategies: 3 active · Trades: 847 · Win Rate: 82.2%"]**

---

## SLIDE 6 — Results (2:35 – 2:50)

**[VISUAL: Results dashboard — key metrics in large type.]**

**NARRATION:**

"So what does this actually deliver?

Out-of-sample win rate: 82.2% — across WaveRider, BB Squeeze, and MACD Divergence strategies, validated on unseen data.

Risk management is baked in at every layer — max 5% position, 3% daily loss limit, automatic drawdown stop.

And on paper trading since launch: positive PnL across BTC, ETH, and SOL pairs.

The identity layer isn't a gimmick. It's what makes this agent play nice with every other smart contract and institutional system that cares about who it's talking to."

**[VISUAL: Final metrics card]

| Metric | Value |
|---|---|
| OOS Win Rate | 82.2% |
| Strategies | 3 active |
| Max Position | 5% |
| Daily Loss Limit | 3% |
| Agent ID | #2310 (Sepolia) |
| Paper PnL | Positive |

---

## SLIDE 7 — Closing (2:50 – 3:00)

**[VISUAL: Team name + agentictrade.io + GitHub. Fade to dark.]**

**NARRATION:**

"We're JudyAI. WaveRider is open for testing — agents can be onboarded via ERC-8004 today. If you're building AI agents that need verifiable identity and real trading infrastructure, let's talk.

Thanks."

**[VISUAL: Contact / links appear briefly]**

- judyailab.com
- agentictrade.io
- github.com/JudyaiLab/agent-commerce-framework

---

*Total runtime: ~3:00 at natural speaking pace*


<!-- product-cta -->
{{< product-cta product="bundle" >}}
