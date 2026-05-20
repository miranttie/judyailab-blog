---
title: "Your Strategy Isn't Broken — The Market Changed"
date: 2026-03-05T20:00:00+00:00
draft: false
tags: ["Quantitative Trading", "Market Regime", "ADX", "Strategy Switching", "Technical Analysis"]
categories: ["Quantitative Trading"]
author: "J (Tech Lead)"
summary: "A profitable strategy suddenly stops working? It might not be the strategy — the market regime changed. Here's how we detect market states using ADX, BB Width, and ATR, and automatically switch strategies."
description: "A profitable strategy suddenly stops working? It might not be the strategy — the market regime changed. Here's how we detect market states using ADX, BB Width, and ATR, and automatically switch strategies."
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
cover:
  hidden: true
lastmod: 2026-03-13T07:29:33+00:00
faq:
  - q: "Why did my profitable trading strategy suddenly stop generating signals?"
    a: "The market regime likely changed. A strategy backtested at 70%+ win rate can produce zero signals for a week when the market shifts from trending to ranging. Trend-following strategies require directional movement; in sideways consolidation, that premise disappears and forcing trades creates losses. The strategy isn't broken — it's correctly refusing to trade in conditions it wasn't designed for. Check ADX: if it dropped below 20, you're in a ranging market and trend strategies should pause. The solution is regime detection plus automatic strategy switching, not abandoning a strategy that worked."
  - q: "How do I detect whether the market is trending or ranging?"
    a: "Use ADX (Average Directional Index) as the backbone indicator. ADX below 20 signals a ranging market with no clear trend. ADX between 20-25 is a transition zone where trends form or die. ADX above 25 confirms a trending market. Combine ADX with Bollinger Band Width for volatility context and 50-period EMA slope for direction. ADX tells you whether a trend exists; EMA slope tells you which way it points. This four-indicator stack (ADX, BB Width, ATR, EMA slope) classifies markets into TRENDING, RANGING, HIGH_VOL, or BREAKOUT states reliably."
  - q: "Which strategies should I run in a ranging market versus a trending market?"
    a: "In TRENDING markets (ADX > 25), run Pipeline trend-following, BB Squeeze breakout, and MACD Divergence reversal strategies. In RANGING markets (ADX < 20), switch to Mean Reversion and BB Squeeze setups — these profit from price bouncing between support and resistance. In HIGH_VOL states (ADX 20-25, BB Width > 15%), cut position sizes since direction is uncertain. In BREAKOUT conditions (narrowing BB + rising ADX), prioritize BB Squeeze. Never run mean reversion during strong trends or trend-following during chop — that's how regime mismatches blow up accounts."
  - q: "What is BB Width and how does it predict breakouts?"
    a: "Bollinger Band Width measures the distance between the upper and lower bands as a percentage. Narrow BB Width (under 5%) means the market is coiling and volatility is compressed — a breakout often follows. Normal range is 5-15%. Wide BB Width (over 15%) signals high volatility, big moves, or panic. The early-breakout signal is narrowing BB combined with rising ADX: compression plus building directional pressure. Pair this with ATR for stop-loss sizing — low ATR allows tighter stops, high ATR demands wider ones to avoid noise-driven exits."
  - q: "What are the biggest mistakes traders make with market regime detection?"
    a: "First, using a single indicator. ADX alone tells you trend strength but not direction — pair it with EMA slope. Second, treating regime thresholds as exact lines instead of zones. ADX 20-25 is a transition, not a clean switch. Third, over-switching strategies on noisy signals; require confirmation across multiple bars before flipping. Fourth, ignoring ATR for position sizing — running fixed-size positions in HIGH_VOL regimes destroys equity. Fifth, abandoning strategies during their natural dormant periods. A trend strategy producing no signals in a ranging market is working correctly, not broken."
  - q: "Who should use a regime-switching system instead of a single fixed strategy?"
    a: "Systematic traders running automated bots across multiple market conditions benefit most. If you trade one strategy manually and accept drawdown periods, regime switching adds complexity you may not need. But if you run 24/7 algorithmic execution, regime detection prevents catastrophic losses when conditions flip — a trend bot in a ranging market bleeds capital through false breakouts. Quant traders managing multiple strategies, portfolio managers allocating between mean-reversion and momentum books, and crypto bot operators facing rapid regime shifts all need this. Discretionary swing traders can apply the concept manually using ADX and BB Width as filters."
  - q: "How is regime-based strategy switching different from just using more indicators?"
    a: "Adding more indicators to one strategy creates noise and overfitting — confirmations stack until nothing triggers. Regime switching is structurally different: it routes execution to entirely different strategy logic based on market state. A trend-following strategy keeps its clean entry rules; a mean-reversion strategy keeps its own logic. The router decides which one is allowed to trade right now. This separates concerns: each strategy stays simple and optimized for its regime, while a higher-level classifier (ADX + BB Width + EMA slope) handles the meta-decision of when each is appropriate."

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

## Why Good Strategies Suddenly Stop Working

Our Pipeline trend-following strategy backtested at 70%+ win rate. Paper Trading went well at first. Then, an entire week passed with zero signals.

No bugs. No data issues. The market shifted from **Trending** to **Ranging**.

Trend strategies need price to move in one direction. When markets consolidate sideways, that premise disappears. Forcing trades means losses.

**This is the core concept of Market Regime: markets don't move the same way forever, and your strategy shouldn't trade the same way forever.**

## How We Detect Market State

We combine four indicators to classify market state:

### 1. ADX (Average Directional Index) — Trend Strength

ADX is the backbone. It doesn't tell you direction — just how strong the trend is:

- **ADX < 20**: Ranging market, no clear trend
- **ADX 20-25**: Transition zone, trend forming or dying
- **ADX > 25**: Trending market, clear directional move

We set ADX 20 as the threshold. Below 20, trend strategies pause.

### 2. BB Width (Bollinger Band Width) — Volatility

Bollinger Band width reflects market volatility:

- **Narrow (< 5%)**: Market is coiling, breakout may be coming
- **Normal (5-15%)**: Average volatility
- **Wide (> 15%)**: High volatility, big move or panic

Narrowing BB + rising ADX = early breakout signal.

### 3. ATR (Average True Range) — Absolute Volatility

ATR measures absolute price movement. Primarily used for stop-loss sizing and position sizing. Low ATR = tighter stops. High ATR = wider stops.

### 4. EMA Slope — Direction Confirmation

50-period EMA slope confirms trend direction: rising = bullish, falling = bearish. This pairs with ADX: ADX says "there's a trend," EMA says "which way."

## Four Market States

Combining these indicators, we define four states:

| State | ADX | BB Width | Characteristics | Best Strategy |
|-------|-----|----------|----------------|---------------|
| **TRENDING** | > 25 | Widening | Clear trend | Pipeline trend-following |
| **RANGING** | < 20 | Normal | Sideways | Mean Reversion + BB Squeeze |
| **HIGH_VOL** | 20-25 | > 15% | Volatile, uncertain | Reduce position size |
| **BREAKOUT** | Rising | Narrow→Wide | Breakout | BB Squeeze |

## Automatic Strategy Switching

With Regime detection, we built a strategy router:

```
Market State → Router → Activate corresponding strategies
```

**During TRENDING:**
- Pipeline (trend-following) ✅
- BB Squeeze (breakout) ✅
- MACD Divergence (reversal) ✅
- Mean Reversion ❌ paused

**During RANGING:**
- Pipeline ❌ paused
- BB Squeeze ✅
- MACD Divergence ✅
- Mean Reversion ✅

The benefit: strategies never run in the wrong environment. Pipeline won't force trades during consolidation. Mean Reversion won't fight trends.

## Transition Prediction: Know Before It Happens

Beyond real-time detection, we added ADX trend analysis. By tracking ADX rate of change over 48 hours, we can predict regime transitions:

- **ADX rising from 15 → 18 → 19**: Ranging is ending, trend strategies preparing to activate
- **ADX dropping from 28**: Trend is weakening, prepare to switch to ranging strategies

Our recent observation: SOL's ADX rose from 14 to 20.5 over 48 hours, successfully predicting the RANGING → TRENDING transition. The system started preparing when ADX approached 20, and activated Pipeline immediately after the crossover.

## Real Data

We scan six major coins (BTC, ETH, BNB, XRP, SOL, DOGE) for Regime state.

**Full-market ranging period (late Feb — early Mar):**
- All 6 coins ADX < 20
- Pipeline signals: 0 (correct behavior — don't trade in the wrong environment)
- Mean Reversion + BB Squeeze filled the gap

**SOL/DOGE entering trend (March 5):**
- SOL ADX 20.5, DOGE ADX 20.4
- Pipeline LONG signal proximity at 85%
- Other coins also rising (BNB estimated to break through in ~52h)

## Coverage Improvement

Before vs. after adding Regime detection and strategy switching:

| Metric | Before | After |
|--------|--------|-------|
| Strategies available in ranging | Only Pipeline (no signals) | MR + BB + MACD |
| Symbol × Direction coverage | 2/12 | 10/12 |
| Signal frequency during ranging | ~0/day | 2-4/day |

## Tips for Building Regime Detection

**1. Start with ADX alone**

You don't need all four indicators. ADX alone distinguishes trending from ranging. Just implementing "pause trend strategies when ADX < 20" is a massive improvement.

**2. Backtest by Regime**

Many people look at overall win rate. But a strategy might be 90% WR in trends and 30% in ranging, averaging to 60% that "looks okay." Segment by Regime to find the real issues.

**3. Add a cooldown to switching**

Don't flip-flop when ADX hovers around 20. We require ADX to stay above/below the threshold for 2 candles as confirmation, preventing false signals from causing rapid strategy toggling.

**4. Don't fully trust automation**

Regime detection is a tool, not gospel. Black swan events (major news, policy changes) can instantly shift market state, but ADX needs time to react. Keep human oversight.

## What's Next

- Develop finer Regime sub-categories (weak trend, strong trend, narrowing range, widening range)
- Use machine learning to predict Regime transitions
- Dynamically adjust position sizes per Regime (larger in trends, smaller in ranging)
- Backfill historical Regime data to validate strategy performance across different environments

---

*This is the third article in our "Quant Trading in Practice" series. Previous articles: [The 100% Win Rate Lesson](/en/posts/oos-validation-lesson/), [Position Sizing: The Hidden Engine](/en/posts/position-sizing-hidden-engine/).*

## References

- [r/Trading on Reddit: Your strategy didn’t stop working — the market changed](https://www.reddit.com/r/Trading/comments/1skiins/your_strategy_didnt_stop_working_the_market/)
- [The Market Isn't Broken - It's Rotating, And I'm Positioning For What's Next | Seeking Alpha](https://seekingalpha.com/article/4853697-market-isnt-broken-its-rotating-positioning-for-whats-next)
- [The Job Market Isn’t Broken. Your Strategy Is | by Frugal Thinker | Apr, 2026 | Medium](https://medium.com/@frugalthinker/the-job-market-isnt-broken-your-strategy-is-5800c11ffe00)
