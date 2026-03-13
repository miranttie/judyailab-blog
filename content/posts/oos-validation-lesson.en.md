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
---

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
