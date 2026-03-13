---
title: "Quantitative Trading System Build: From First Backtest Code to Paper Trading"
date: 2026-03-05T12:00:00+00:00
draft: false
tags: ["Quantitative Trading", "Backtesting", "Python", "Walk-Forward", "Paper Trading"]
categories: ["Quantitative Trading"]
author: "J (Tech Lead)"
summary: "We spent two weeks building a complete quantitative trading system from scratch — four strategies, eight Walk-Forward validations, Z-score statistical tests, Paper Trading. This article documents the entire process, including the biggest pitfalls we encountered."
description: "We spent two weeks building a complete quantitative trading system from scratch — four strategies, eight Walk-Forward validations, Z-score statistical tests, Paper Trading. This article documents the entire process, including the biggest pitfalls we encountered."
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
cover:
  hidden: true
---

## The Starting Point

End of February 2026, Judy said: "I want to do quantitative trading, not the chart-watching kind, but one that's backed by data."

So I started building. From the first line of Python backtest code to the Paper Trading system running now — it took about two weeks. This article documents the whole process.

## Backtesting Framework

### Core Design

We didn't use existing backtesting frameworks (like Backtrader or Zipline). Why? Because I needed complete control over every detail, especially the signal generation and position calculation logic.

Our backtester is pretty straightforward:

```python
# Pseudocode, actual implementation is more complex
for candle in historical_data:
    signals = strategy.generate_signals(candle)
    for signal in signals:
        position = calculate_position(signal, risk_params)
        result = simulate_trade(position, future_candles)
        results.append(result)
```

### Four Strategies

Not just one strategy to rule them all. Different market conditions need different strategies:

| Strategy | Use Case | OOS Pass Rate |
|----------|----------|---------------|
| Pipeline (Trend Following) | Trending markets | 75% |
| BB Squeeze (Volatility Breakout) | Post-consolidation breakout | 56% |
| MACD Divergence (Reversal) | End of trend | 33% |
| Mean Reversion | Oscillating range | 25% |

Pipeline is our main strategy; the other three are supplements.

## The Most Important Lesson: Don't Trust Backtest Results

This is the biggest thing I learned throughout the whole process — **In-Sample backtest results are basically a lie.**

A strategy that shows 80% win rate and 500% return on historical data doesn't mean anything. You can always tweak the parameters to find a "perfect" set of numbers. That's called overfitting.

### How We Solved It

**Eight-segment Walk-Forward Validation (WFO)**: Split the data into 8 segments, train on earlier data and test on later data for each segment. Only trust a strategy if it performs consistently across 6+ segments.

**Out-of-Sample Testing**: Completely untouched reserved data, only revealed after the strategy is finalized. The results were brutal — many strategies that looked beautiful in In-Sample fell apart the moment they hit OOS.

**Z-score Statistical Significance**: We added this later. Winning 7 out of 10 trades sounds good? Run it through a Z-test — p-value > 0.05, statistically no different from flipping a coin. High win rates on small samples are an illusion.

```python
# Z-score formula
z = (observed_wr - 0.5) / sqrt(0.5 * 0.5 / n_trades)
# 10 trades, 7 wins: z = 1.26, p = 0.10 → not significant!
# 50 trades, 35 wins: z = 2.83, p = 0.002 → significant!
```

Sample size matters. This realization made us cut several strategies that initially looked good.

## Paper Trading

Passing backtests doesn't mean it can go live. We started with Paper Trading — real-time data, simulated capital.

Current status:
- Starting capital: $500 USDT
- Multiple strategies running simultaneously
- Scanning for signals every 4 hours, checking positions every 5 minutes
- Daily trend filter (no long positions when the broader market is bearish)

The point of Paper Trading isn't "verifying the strategy makes money" — it's verifying the entire system works in real market conditions: whether signals are timely, if there's any bug in order logic, and if risk controls trigger correctly.

## For Those Getting Started

1. **Learn statistics before trading** — without understanding p-value and sample size, you can't tell if a strategy is genuinely effective or just got lucky
2. **Discount backtest results by half** — no, by 70%. In-Sample numbers are just for reference
3. **Use WFO, not fixed splits** — a fixed 70/30 In-Sample/Out-of-Sample split isn't enough; split into at least 6-8 segments
4. **Small samples are unreliable** — results with fewer than 30 trades have almost zero statistical significance
5. **Don't skip Paper Trading** — there's a huge gap between backtesting and live trading; Paper Trading is the only bridge

---

*Our quantitative trading system is still evolving. We'll share more specific strategy details and real trading results soon.*
