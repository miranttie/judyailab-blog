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
lastmod: 2026-05-25T11:26:34+00:00
faq:
  - q: "Why not use existing backtesting frameworks like Backtrader or Zipline?"
    a: "We needed complete control over signal generation and position calculation logic. Off-the-shelf frameworks abstract away critical details — slippage modeling, partial fills, exact entry timing, and custom risk rules. Writing our own backtester took more time upfront but eliminated black-box behavior. Every result is traceable to specific code we wrote. For production capital deployment, you cannot afford uncertainty about what the framework is doing under the hood. Use Backtrader for quick prototyping; build your own when results will drive real money decisions."
  - q: "How do I avoid overfitting when backtesting a trading strategy?"
    a: "Use Walk-Forward Optimization with at least eight segments — train on earlier data, test on later data, and require consistent performance across six or more segments. Reserve completely untouched Out-of-Sample data and only reveal it after the strategy is finalized. Add Z-score statistical significance tests; a p-value above 0.05 means your results are indistinguishable from coin-flipping. An 80% win rate on In-Sample data means nothing if it collapses on OOS. Treat In-Sample backtest results as a starting hypothesis, never as proof."
  - q: "What's the difference between In-Sample and Out-of-Sample testing?"
    a: "In-Sample is the historical data you used to develop and tune your strategy. Out-of-Sample is reserved data the strategy has never seen during parameter tuning. In-Sample results are almost always inflated because you implicitly fit parameters to that period. OOS exposes whether the strategy captures real market behavior or just noise. Many strategies showing 500% In-Sample returns produce flat or negative OOS results. Never reveal OOS data until your strategy is fully finalized — peeking even once contaminates the test and invalidates the validation."
  - q: "Why does my high win rate strategy fail in live trading?"
    a: "Three reasons. First, overfitting — your parameters were tuned to historical noise that does not repeat. Second, insufficient sample size — winning 7 of 10 trades is statistically meaningless, run a Z-test and the p-value will exceed 0.05. Third, ignoring market regime — a trend-following strategy crushes trending markets and bleeds in choppy ones. Fix this by requiring 100+ trades minimum, validating across multiple market regimes with Walk-Forward, and running Z-score statistical significance tests. A 55% win rate across 500 trades beats 80% across 20 every time."
  - q: "Which strategy works best across all market conditions?"
    a: "None. Stop searching for one. We run four distinct strategies because each fits a specific regime. Pipeline trend-following hits 75% OOS pass rate in trending markets. BB Squeeze captures post-consolidation breakouts at 56%. MACD Divergence catches trend exhaustion at 33%. Mean Reversion handles oscillating ranges at 25%. Pipeline is our primary; the others activate when conditions match. Anyone selling you a single strategy that works everywhere is selling overfit garbage. Build a portfolio of specialized strategies and route capital based on detected market regime."
  - q: "How long does it take to build a real quantitative trading system?"
    a: "Two weeks of focused work gets you from blank file to running Paper Trading — if you skip ready-made frameworks and write everything yourself. That covers backtester core, four strategies, eight-segment Walk-Forward Optimization, Z-score statistical tests, and Paper Trading integration. Add several more weeks before deploying real capital: you need extensive Paper Trading to verify execution matches backtest assumptions, slippage calibration, and incident response procedures. Anyone promising a production-ready system in a weekend is skipping the validation work that actually keeps you from losing money."
  - q: "Should I trust a strategy with 7 wins out of 10 trades?"
    a: "No. Run a Z-test on it. With only 10 trades, a 70% win rate produces a p-value above 0.05, meaning the result is statistically indistinguishable from flipping a coin seven times and getting heads. Small-sample win rates are illusions created by randomness. Require at least 100 trades before drawing conclusions, and 300+ before deploying capital. Track win rate, average win/loss ratio, maximum drawdown, and Sharpe ratio together — never win rate alone. A 45% win rate with 3:1 reward-to-risk crushes a 70% win rate with 1:2."

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

## References

- [Backtesting Systematic Trading Strategies in Python: Considerations and Open Source Frameworks | QuantStart](https://www.quantstart.com/articles/backtesting-systematic-trading-strategies-in-python-considerations-and-open-source-frameworks/)
- [Online Quantitative Trading Strategies](https://www.stern.nyu.edu/sites/default/files/2025-05/Glucksman_Lahanis.pdf)
- [A Practical Guide to High-Performance Quant Backtesting with PySwordfish | by DolphinDB | Medium](https://medium.com/@DolphinDB_Inc/a-practical-guide-to-high-performance-quant-backtesting-with-pyswordfish-4d73e30bad1b)

---

## Further Reading

- [Your Strategy Has 87% Win Rate? Z-Score Says: That's an Illusion](/posts/z-score-reality-check/)
- [100% Win Rate in Backtesting? Don't Celebrate Yet — Our Most Painful Lesson](/posts/oos-validation-lesson/)
- [From Backtest Paradise to Live Trading Hell — 5 Hard Lessons from Our Quant System's First Month](/posts/backtest-to-live-trading-gap/)
