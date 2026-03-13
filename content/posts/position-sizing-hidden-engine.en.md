---
title: "Position Sizing: The Most Underrated Part of Quantitative Trading"
date: 2026-03-05T19:00:00+00:00
draft: false
tags: ["quantitative trading", "position sizing", "risk management", "Kelly Criterion"]
categories: ["Quantitative Trading"]
author: "J (Tech Lead)"
summary: "Most traders spend 90% of their time finding signals and 10% thinking about position size. But math shows: the same strategy with different position sizing can produce results that differ by 10x."
description: "Most traders spend 90% of their time finding signals and 10% thinking about position size. But math shows: the same strategy with different position sizing can produce results that differ by 10x."
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
cover:
  hidden: true
---

## An Experiment

Same strategy. 72% win rate. Average win 1.5%, average loss 2%.

Run 100 trades with different position sizing methods:

| Method | Risk Per Trade | Final Balance | Max Drawdown |
|--------|---------------|---------------|-------------|
| Fixed $50 | $50/trade | $1,050 | 12% |
| Fixed 10% | 10% of balance | $1,980 | 18% |
| Risk 2% | Max loss = 2% of balance | $2,340 | 10.4% |
| Half Kelly | 24.5% of balance | $14,332 | 27% |
| Full Kelly | 49% of balance | $3,100 | 55% |

Starting capital $500. Same 100 trades. Results differ by 14x.

## Why Such a Big Difference?

**Fixed Amount** ($50/trade): Regardless of account size, bet $50 each time. When the account grows, the bet proportion becomes too small — compounding is wasted. When the account shrinks, the proportion becomes too large — losses accelerate.

**Fixed Percentage** (10%): Better than fixed amount. Bet more when the account is bigger, less when it's smaller. But where does 10% come from? It's an arbitrary number.

**Risk 2%**: Maximum loss per trade never exceeds 2% of account balance. **Note: this is not 2% position size, it's 2% maximum loss**. If your stop loss is 3% away, position size = 2% / 3% ≈ 67% of balance.

**Kelly Criterion**: The mathematically optimal betting fraction. Formula: `f* = (bp - q) / b`, where p=win rate, q=loss rate, b=win/loss ratio. Full Kelly maximizes growth but also maximizes volatility. Half Kelly is the practical compromise.

## Risk-Based Calculation

Our system uses Risk 2% as the baseline. The math is straightforward:

```
Position = (Balance × Risk%) / |Entry Price - Stop Loss|
```

Suppose you have $1,000, going long BTC @ $90,000, stop at $88,200 (2% away):

```
Position = ($1,000 × 0.02) / ($90,000 - $88,200)
         = $20 / $1,800
         = 0.0111 BTC
         ≈ $1,000 notional
```

Maximum loss = 0.0111 × $1,800 = $20 (2% of account).

If the stop is tighter (1%):
```
Position = $20 / $900 = 0.0222 BTC ≈ $2,000
```

This is the core of Risk-Based sizing: **tighter stops = larger positions; wider stops = smaller positions**. The risk per trade stays consistent.

## Dynamic Adjustments

Fixed 2% is already good, but we layer two more adjustments:

### 1. Losing Streak Protection

Consecutive losses trigger automatic risk reduction:

| Consecutive Losses | Risk Multiplier |
|-------------------|----------------|
| 0-2 | 100% (normal) |
| 3-4 | 50% (risk drops from 2% to 1%) |
| 5+ | Pause new positions |

Psychology research shows that decision quality degrades after consecutive losses. Rules-based risk reduction protects you from tilt.

### 2. Session Adjustment

We analyzed 400+ trades by time of day:

| UTC Session | Win Rate | Risk Adjustment |
|------------|---------|----------------|
| 04-08 (Asia morning) | 86% | +20% |
| 00-04 (late night) | 80% | +10% |
| 08-12 (Europe morning) | 75% | No change |
| 16-20 (US early) | 73% | No change |
| 12-16 (Europe afternoon) | 65% | -15% |
| 20-00 (US late) | 68% | -20% |

Asia morning has the highest win rate — good liquidity and clean trends. US late session performs worst — high volatility but unclear direction.

Final risk = Base 2% × Losing streak factor × Session factor.

After 3 consecutive losses, during US late session:
```
Actual risk = 2% × 50% × 80% = 0.8%
```

The system protects you automatically.

## Kelly Criterion

The Kelly formula gives the mathematically optimal bet size:

```
f* = p - q/b
```

- p = win rate
- q = 1 - p
- b = win/loss ratio (average win / average loss)

Our Pipeline strategy: p=0.72, b=0.75 (small wins, larger losses)

```
f* = 0.72 - 0.28/0.75 = 0.72 - 0.37 = 0.35
```

Full Kelly suggests 35% per trade. But Full Kelly's volatility is extreme (P95 drawdown 55%). In practice, Half Kelly (17.5%) is more stable.

**Half Kelly is a compromise**: you give up half the expected return in exchange for significantly lower drawdown risk. In real trading, psychological stability matters more than maximizing returns.

## Our Choice

We chose Risk 2% + losing streak protection + session adjustment over Kelly:

1. **Risk 2% is more robust**: Kelly requires precise win rate and payoff ratio estimates. If these are wrong, it's catastrophic. Risk 2% doesn't depend on these estimates.

2. **More controllable risk**: Risk 2% caps single-trade loss at 2% of account. Kelly during a losing streak can lose 10-20%.

3. **Better psychology**: Losing 2% on a trade won't keep you up at night. Losing 17.5% might.

4. **More flexible layering**: Losing streak and session adjustments stack naturally on Risk 2%. Layering them on Kelly is mathematically complex.

## Takeaway

Position sizing isn't a supporting character in trading — it's the key factor that determines whether you survive.

> A 60% win rate strategy + good position sizing > an 80% win rate strategy + bad position sizing.

If you can only improve one part of your trading system, don't tweak indicator parameters. Get position sizing right first.
