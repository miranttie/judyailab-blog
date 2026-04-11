---
title: "Building an AI Trading Agent That Proves Its Claims: Our ERC-8004 Hackathon Story"
date: 2026-04-10
draft: false
slug: hackathon-trading-agent-journey
description: "How we built WaveRider — an autonomous crypto trading agent that went from 58/100 to Leaderboard #5 in 11 days. Walk-Forward validation, 7-layer risk management, Merkle-verified audit trails, and radical transparency about what went wrong."
tags: ["AI", "trading", "ERC-8004", "hackathon", "WFO", "risk management", "blockchain"]
categories: ["AI", "Engineering"]
author: "JudyAI Lab"
keywords: ["AI trading agent", "ERC-8004", "Walk-Forward Optimization", "crypto trading bot", "on-chain identity", "risk management", "hackathon"]
---

On March 31st, I deployed an AI trading agent with one strategy, zero on-chain presence, and a score of 58 out of 100.

Eleven days later, that agent sits at **#5 on the leaderboard** out of 58 registered teams, with a validation score of 98, a reputation score of 94, and — here's the part I'm most proud of — a total drawdown of just **0.4% on a $100,000 portfolio** through some of the choppiest market conditions we've seen all year.

This is the story of how we built **WaveRider** for the LabLab.ai "AI Trading Agents with ERC-8004" hackathon. Not the polished version. The real one — bugs, failures, 3 AM debugging sessions, and all.

## The Problem We Set Out to Solve

Every AI trading agent at a hackathon shows you a backtest number. "90% win rate!" "3x returns!" The slides look great.

But ask a simple question — *"How does it perform on data it hasn't seen before?"* — and most of those numbers collapse.

That's because standard backtesting is a trap. You optimize parameters on the same data you test on. The model literally sees the answers. Of course it performs well. It's like studying the answer key and calling yourself prepared for the exam.

We wanted to build something different: **an agent whose claims you can actually verify.**

## Day 1–3: The Naive Start

WaveRider launched with a single strategy — EMA crossover + RSI momentum + volume confirmation. A classic trend-following approach.

The first few trades looked fine. Then the market went sideways.

Trend-following strategies in ranging markets are like bringing a surfboard to a lake. You sit there waiting for a wave that never comes, and every small ripple costs you money.

**First lesson: One strategy isn't enough.**

We added two more engines: **BB Squeeze** (Bollinger Band compression breakouts) and **MACD Divergence** (price-momentum divergence for reversals). Three complementary strategies covering trends, breakouts, and reversals.

But which strategy should run when? That led us to **regime detection** — using ADX, Bollinger Band width, and EMA convergence to classify market conditions into six states: Trending Up, Trending Down, Ranging, High Volatility, Breakout Forming, and Exhaustion.

Each state routes to different strategy combinations. We ended up with a **36-cell matrix** — 6 coins × 6 regimes — where each cell has its own optimized parameter set.

## Day 4–5: Walk-Forward Optimization Exposes the Truth

Here's where things got uncomfortable.

We ran Walk-Forward Optimization on all our strategies. Unlike standard backtesting, WFO trains on one time window and tests on the *next* unseen window, repeating this 8 times across 360 days of data. It's the closest thing to simulating real forward performance without actually trading.

**The results were humbling.**

BTC Long, which looked great in traditional backtests, came back with a **40% out-of-sample win rate.** We blacklisted it immediately.

DOGE Long? 30.3% OOS. Blacklisted.

But ETH? **93.3% long, 97.8% short** across 91 out-of-sample trades. SOL held up at 72–76%. LINK hit 100% long (small sample, but consistent).

The overall OOS portfolio: **82.2% win rate across 366 trades** that the model had never seen during optimization.

**Second lesson: If your strategy can't survive Walk-Forward, it can't survive live markets. Kill your darlings based on data, not ego.**

## Day 6–7: Dual-AI Ensemble (And When It All Went Down)

Raw strategy signals are noisy. A trend-following signal in a choppy market is technically valid but practically worthless. We needed something to filter signal quality.

Enter the **dual-AI ensemble**: MiniMax M2.7 (cloud-based, strong reasoning) and Qwen 2.5 (local via Ollama, fast inference). Every signal gets reviewed by both models independently. They assess market context, confluence factors, and risk-reward ratio. An agreement bonus boosts confidence when both concur.

This pushed our signal rejection rate to **87%** — only the highest-conviction setups get through.

Then, during scan #92 at 3 AM, all three AI backends (MiniMax, Claude, Ollama) timed out simultaneously. The agent was blind.

**Third lesson: AI is a tool, not a crutch.**

We reduced per-model timeouts from 45s to 25s, restructured the cascade to fail fast, and added a **rule-based fallback** that executes at 50% position size when AI is unavailable. The agent should degrade gracefully, never go dark.

## Day 8–9: SOL Teaches Us About Per-Pair Risk

SOL/USDT hit three consecutive stop-losses. Our global consecutive loss counter was at 3 — but the global counter looks at ALL pairs combined. By the time it triggered the position scaling reduction, SOL had already bled through three full-size trades.

**Fourth lesson: Global risk controls aren't granular enough.**

We invented **Layer 6: Per-pair throttle.** Two consecutive losses on the same pair triggers a 3-scan cooldown for that specific pair. The risk system went from 5 layers to 7:

1. Position sizing (max 5% per trade)
2. Daily loss limit (3% → auto-stop)
3. Max drawdown (10% → emergency close all)
4. Global consecutive loss pause
5. Consecutive loss scaling (50% size)
6. **Per-pair throttle** (new)
7. **Batch take-profit** (TP1→breakeven, TP2→tighten, TP3→close)

**Result: Total drawdown held to 0.4% across 11 days of adverse market conditions.** The 7-layer system prevented over $8,300 in potential losses compared to our worst-case OOS scenario.

## Day 10: The Reputation Crisis

The hackathon uses shared smart contracts for scoring. One of them — the ReputationRegistry — allows agents to post reputation updates on-chain.

Except it doesn't. Not for self-assessment.

Every `submitFeedback` call with our agent wallet reverted. The contract blocks self-rating by design (to prevent score inflation). We tried feedbackType 0, 1, 2 — all rejected.

Most teams would just accept a zero reputation score and move on. We went a different direction.

We built a **zero-base reputation formula from scratch.** Starting at 0 — not 50, not 65, not some padded base that masks poor performance. Every point is earned:

- Risk control: 30 points max (our drawdown under 0.5% = 30/30)
- Transparency: 20 points (artifacts per trade ratio)
- Validation quality: 15 points
- Activity: 15 points
- Win rate: 10 points
- PnL: 10 points (can be negative)

Our score: **79/100.** Not flashy. But every single point represents measurable, verifiable performance. Run `make reputation` to see the full breakdown.

**Fifth lesson: When the system blocks you, build a better system. Constraints breed innovation.**

## Day 10 (continued): Merkle Integrity

If we're asking judges to trust our validation artifacts, we should give them a way to verify nothing was tampered with after the fact.

We built a **SHA-256 Merkle tree** over all 205 validation records — trade intents, risk checks, and strategy checkpoints. The root hash is embedded in the agent card and posted on-chain.

Run `make verify` to recompute the Merkle root independently. If it matches, no records have been modified. If it doesn't, something changed.

This is trust-minimized verification applied to trading agents. Not "trust my numbers." Instead: "here's the math to check them yourself."

## Day 11: The Breakthrough

The hackathon organizers announced they'd fixed a Solidity bug in the ValidationRegistry. The `postEIP712Attestation` function was using `this.postAttestation(...)` — an external call that changes `msg.sender` from the operator wallet to the contract itself. Since the contract wasn't in its own whitelist, every checkpoint submission reverted.

Within minutes of the fix, we posted 6 validation checkpoints covering risk management, WFO results, Merkle integrity, reputation methodology, and AI ensemble design.

**Validation score jumped to 98. Reputation to 94. Leaderboard position: #5 out of 58.**

## The Numbers We're Proud Of (And the Ones We're Not)

Let's be transparent:

| Metric | OOS Backtest | Live Paper Trading |
|--------|-------------|-------------------|
| **Win Rate** | 82.2% (366 trades) | 40.0% (25 trades) |
| **Max Drawdown** | -8.7% | **-0.4%** |
| **Risk Rejection** | — | 87% of signals filtered |

The 40% live win rate is real, and we're not hiding it. The hackathon period was dominated by ranging and choppy markets — exactly the regime where trend-following strategies underperform. Our WFO backtest windows included ~60% trending regimes; live was the opposite.

But here's what matters: **the risk system did its job.** A 40% win rate with -0.4% drawdown means the agent lost small and protected capital. When markets turn favorable for our strategies, the validated edge is there. When they don't, the 7-layer risk system keeps the damage negligible.

A production agent that loses 0.4% in bad markets is more valuable than a demo agent that shows 80%+ on cherry-picked data.

## What We Built (The Technical Stack)

- **3 strategy engines** with 36-cell regime-adaptive routing
- **7-layer risk management** including per-pair throttle and batch take-profit
- **Dual-AI ensemble** (MiniMax M2.7 + Qwen 2.5) with 87% signal rejection
- **Walk-Forward Optimization** (8 windows, 366 OOS trades)
- **SHA-256 Merkle tree** over 205 validation artifacts
- **Zero-base reputation formula** (base=0, fully earned)
- **ERC-8004 on-chain identity** (Agent #17, dual-contract registration)
- **79 EIP-712 signed trade intents** submitted to RiskRouter
- **93 tests** (unit + integration + integrity)
- **Graceful shutdown** with SIGTERM/SIGINT handling
- All source files under 800 lines. Docker + systemd ready.

Everything is open source at [github.com/JudyaiLab/hackathon-trading-agent](https://github.com/JudyaiLab/hackathon-trading-agent).

Run `make test && make validate && make verify && make reputation` to verify every claim in this post.

## What I Learned

**1. Validation methodology matters more than backtest numbers.** Any model can show 90% on in-sample data. Walk-Forward is the honest test.

**2. Risk management is the product.** Not the strategy, not the AI, not the fancy indicators. When markets turn against you, the only thing that matters is how much you lose.

**3. Transparency is a competitive advantage.** Showing your failures alongside your successes builds more trust than a perfect track record ever could.

**4. Constraints breed innovation.** The contract blocking self-rating forced us to build zero-base reputation. The AI timeout forced us to build fallback systems. SOL bleeding forced us to build per-pair throttling. Every problem made the agent better.

**5. On-chain identity changes the game.** ERC-8004 isn't just a hackathon requirement — it's the future of agent accountability. When any agent can register a verifiable identity and build portable reputation, the entire ecosystem levels up.

---

*WaveRider is Agent #17 on Sepolia. Validation score: 98. Reputation: 94. Leaderboard: #5 of 58.*

*Built during 11 sleepless days by JudyAI Lab.*

*[GitHub](https://github.com/JudyaiLab/hackathon-trading-agent) · [JudyAI Lab](https://judyailab.com)*
