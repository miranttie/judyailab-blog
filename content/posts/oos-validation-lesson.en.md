---
title: "100% Win Rate in Backtesting? Don't Celebrate Yet — Our Most Painful Lesson"
date: 2026-03-05T18:00:00+00:00
draft: false
tags: ["quantitative trading", "backtesting", "overfitting", "out-of-sample", "walk-forward"]
categories: ["Quantitative Trading"]
author: "J (Tech Lead)"
summary: "We developed a mean reversion strategy. Backtesting showed 3 out of 8 combinations hitting 100% win rate. Then we ran Out-of-Sample validation, and 100% crashed to 25%. Here's what happened."
description: "We developed a mean reversion strategy. Backtesting showed 3 out of 8 combinations hitting 100% win rate. Then we ran Out-of-Sample validation, and 100% crashed to 25%. Here's what happened."
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
cover:
  hidden: true
lastmod: 2026-05-25T11:26:34+00:00
faq:
  - q: "Why does a 100% win rate in backtesting often fail in live trading?"
    a: "A 100% backtest win rate usually signals overfitting or insufficient sample size, not strategy strength. In our case, SOL LONG and XRP LONG each had only 3 trades — flipping heads three times in a row happens 12.5% of the time by pure chance. When we ran Out-of-Sample validation, XRP LONG dropped from 100% to 0%, and ETH SHORT crashed from 100% to 25%. Always check trade count, run OOS validation, and require at least 30 trades before trusting any win rate metric."
  - q: "What is Out-of-Sample (OOS) validation and how do I run it?"
    a: "OOS validation tests a strategy on data it has never seen. Split historical data into two parts: train parameters on the In-Sample portion (e.g., first 120 days), then test on the Out-of-Sample portion (last 60 days) without changing anything. If win rate collapses on OOS data, the strategy is overfitted. Our mean reversion strategy looked perfect on IS data but lost on OOS — proving the parameters were memorizing noise, not capturing real edge. Never deploy a strategy that hasn't passed OOS."
  - q: "How many trades are needed before backtest results become statistically meaningful?"
    a: "Aim for at least 30 trades per combination, and ideally 100+. Fewer than 10 trades produces results dominated by randomness — a 100% win rate on 3 trades carries roughly the same information as a coin flip. Profit factor and Sharpe ratio also become unreliable with small samples. If your strategy generates few signals over 180 days, either extend the backtest window, broaden the symbol universe, or accept that you cannot validate it without more market exposure."
  - q: "When should I use mean reversion instead of trend-following strategies?"
    a: "Use mean reversion when ADX is below 20 across major pairs, indicating a ranging market with no clear trend. Trend-following strategies like Pipeline or BB Squeeze produce almost no signals in these conditions. Mean reversion exploits price oscillation within a band: enter on RSI extremes (below 35 or above 65), exit at the Bollinger middle band, and use 1.5× ATR stops. However, mean reversion fails catastrophically during trending breakouts, so always combine it with a regime filter that disables it when ADX rises above 25."
  - q: "What are the most common mistakes when backtesting a new trading strategy?"
    a: "Four mistakes recur: (1) ignoring trade count and celebrating high win rates on tiny samples; (2) skipping Out-of-Sample validation and treating training results as live performance; (3) over-tuning parameters until every coin looks profitable, which guarantees overfitting; (4) failing to test across multiple market regimes — a strategy that works only in ranging conditions will blow up when trends return. Always validate with OOS, require minimum trade counts, and stress-test against different volatility and trend environments before risking capital."
  - q: "Who is this lesson most useful for?"
    a: "This applies to anyone building systematic crypto or stock trading strategies, especially solo developers and small quant teams without access to institutional validation pipelines. If you backtest in Python, TradingView, or Freqtrade and have ever shipped a strategy that looked great in backtest but bled money live, this is your wake-up call. Beginners should adopt OOS validation from day one; experienced traders should audit existing strategies for sample-size and overfitting issues before scaling positions."
  - q: "How is OOS validation different from walk-forward analysis?"
    a: "OOS is a single train/test split — train on 120 days, test on 60 days, once. Walk-forward analysis repeats this process rolling forward through time: train on window 1, test on window 2, then shift both windows and repeat. Walk-forward is more robust because it validates parameter stability across multiple market regimes, not just one. Start with OOS as a minimum gate, then graduate to walk-forward once your strategy passes. If walk-forward shows degrading performance over time, the edge is decaying."

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

## Context

Our trading system already had three strategies running in Paper Trading: Pipeline (trend following), BB Squeeze (Bollinger Band breakout), and MACD Divergence (divergence reversal).

These three share a common weakness: **when the market enters a ranging phase, signals drop to nearly zero**.

Our ADX indicator showed all six major coins below 20 — no clear trend. Trend-following strategies simply had nothing to do.

So I built a fourth strategy: **Mean Reversion**.

## The Logic

The concept is straightforward:

1. RSI below 35 (oversold) → wait for RSI to bounce → go long
2. RSI above 65 (overbought) → wait for RSI to drop → go short
3. Stop loss: 1.5× ATR
4. Take profit: BB middle band (mean reversion target)

In a ranging market, price bounces within a band. Mean reversion should theoretically be the perfect strategy.

## Backtest Results — Too Perfect

180 days of historical data, 6 coins × 2 directions = 12 combinations:

| Combination | Win Rate | Profit Factor | Trades |
|-------------|----------|---------------|--------|
| SOL LONG | 100% | ∞ | 3 |
| XRP LONG | 100% | ∞ | 3 |
| XRP SHORT | 85.7% | 7.93 | 7 |
| DOGE LONG | 83.3% | 5.19 | 6 |
| DOGE SHORT | 80% | 3.5 | 5 |
| ETH SHORT | 75% | 2.3 | 4 |
| BNB SHORT | 75% | 2.0 | 4 |
| BTC SHORT | 71.4% | 1.8 | 7 |

Eight combinations above 70% win rate. Three at 100%.

If we had gone live right then, we would have thought this strategy was invincible.

## The Red Flag: Sample Size

One number kept bothering me: **the number of trades**.

SOL LONG and XRP LONG, both at 100% win rate, each had only 3 trades.

A 100% win rate on 3 trades has almost zero statistical significance. The probability of flipping heads three times in a row is 12.5%. Not exactly rare.

## Out-of-Sample Validation

I ran OOS validation on every combination:

1. Split 180 days into **first 120 days (In-Sample)** and **last 60 days (Out-of-Sample)**
2. Train parameters on the first 120 days
3. Test on the last 60 days — data the model has never seen

Results:

| Combination | IS Win Rate | OOS Win Rate | Drop |
|-------------|-------------|-------------|------|
| SOL LONG | 100% | **75%** | -25% |
| XRP LONG | 100% | **0%** | -100% |
| ETH SHORT | 100% | **25%** | -75% |
| DOGE LONG | 83% | **50%** | -33% |
| BTC SHORT | 80% | **40%** | -40% |
| BTC LONG | 67% | **33%** | -34% |
| BNB LONG | 67% | **50%** | -17% |

**XRP LONG: IS 100% → OOS 0%**. Perfect on training data, every single trade lost on new data.

**ETH SHORT: IS 100% → OOS 25%**. Four wins in backtesting, only one win on unseen data.

## Only 2 Combinations Survived

Out of 12 combinations, only 2 maintained stable OOS performance:

- **SOL LONG**: IS 78% → OOS 75% (only 3% gap)
- **DOGE SHORT**: IS 80% → OOS 76% (only 4% gap)

We kept only these 2 for Paper Trading. The other 10 were cut.

## Why the Overfitting?

The root cause is **small sample size**:

- Mean reversion requires extreme RSI values to trigger
- Over 180 days, each combination generated only 3-7 trades
- 100% win rate on 3 trades ≠ the strategy works
- 85% win rate on 7 trades is also insufficient to draw conclusions

**Statistics 101**: to have reasonable confidence in a binary outcome (win/loss), you need at least 20-30 samples. Most of our combinations had single digits.

## Z-score Validation

We quantify whether strategy performance significantly exceeds random using Z-scores:

```
Z = (observed_WR - random_WR) / √(random_WR × (1 - random_WR) / N)
```

- Z > 1.96 → 95% confidence it's better than random
- Z > 2.58 → 99% confidence

Our main strategy Pipeline (414 trades, 72% win rate):

```
Z = (0.72 - 0.5) / √(0.5 × 0.5 / 414) = 8.94
```

Z = 8.94, far above 2.58. This strategy **genuinely** outperforms random.

Meanwhile MR's SOL LONG (3 trades, 100%):

```
Z = (1.0 - 0.5) / √(0.5 × 0.5 / 3) = 1.73
```

Z = 1.73, doesn't even reach 95% confidence. Statistics says: **this could just be luck**.

## Our Current Process

After this experience, every new strategy must pass three validations before going live:

1. **Minimum trade count**: at least 20 trades in backtesting
2. **OOS validation**: IS and OOS win rate gap under 10%
3. **Z-score test**: Z > 1.96

Fail any one = no deployment. No exceptions.

Current strategy standings:

| Strategy | Trades | Win Rate | Z-score | Status |
|----------|--------|----------|---------|--------|
| Pipeline | 414 | 72% | 8.94 | ✅ Primary |
| BB Squeeze | 82 | 56% | 1.09 | ⚠️ Supporting |
| MACD Div | 45 | 33% | -2.28 | ⚠️ Select pairs only |
| Mean Reversion | 53 | 25% | -3.64 | ❌ Only 2 pairs |

Pipeline is the only strategy with robust validation. The others need more data to build confidence.

## Takeaway

If your backtest shows 100% win rate, **assume it's fake** until OOS validation proves otherwise.

Small-sample backtest results are the most dangerous trap in trading system development. They create an illusion: this strategy is flawless. But flawless strategies don't exist — flawless backtests are usually just overfitting.

> Backtesting is a tool for eliminating bad strategies, not for proving good ones.
> A strategy that passes OOS validation might not make money, but one that fails definitely will disappoint you in live trading.

## References

- [100% Win Rate Backtesting Session (IFVG's)](https://www.youtube.com/watch?v=9Wh1io7mhmY)
- [80% win ratio in backtesting. But losing money in live ...](https://www.instagram.com/reel/DWmM4HMjWNX/?hl=en)
- [70% win rate in backtest but bad in live trading](https://www.reddit.com/r/Trading/comments/1gsigse/70_win_rate_in_backtest_but_bad_in_live_trading/)

---

## Further Reading

- [Your Strategy Has 87% Win Rate? Z-Score Says: That's an Illusion](/posts/z-score-reality-check/)
- [Quantitative Trading System Build: From First Backtest Code to Paper Trading](/posts/quant-trading-journey/)
- [The Single Strategy Trap: Why You Need a Multi-Strategy Trading System](/posts/multi-strategy-trading/)
