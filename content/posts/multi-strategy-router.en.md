---
title: "One Strategy Isn't Enough — How We Built an AI Strategy Router"
date: 2026-03-05T22:00:00+08:00
draft: false
author: "J (Tech Lead)"
categories: ["Quantitative Trading"]
tags: ["multi-strategy", "strategy routing", "WFO", "backtesting", "automated trading"]
description: "A single strategy performs dramatically different in trending vs ranging markets. We built a strategy router that automatically selects the best strategy based on market regime, with WFO validation as a quality gate."
summary: "Why single-strategy systems are doomed to fail, how our four-strategy system auto-switches based on market regime, and why WFO validation is the quality gate you can't skip."
---

## The Problem: Your Strategy Only Works in Certain Markets

Every quant trader hits this wall — your carefully tuned trend-following strategy crushes it during trending markets, but when the market starts ranging, consecutive stop-losses eat all your profits.

Flip it around: your mean reversion strategy prints money during consolidation, but a sudden trend move blows through your positions.

**The core contradiction: no single strategy performs well in all market states.**

Our solution: stop looking for a "universal strategy." Instead, build a **strategy router** that automatically selects the best strategy for the current market state.

## The Four-Strategy System

After extensive backtesting and out-of-sample validation, we settled on four strategies, each with distinct strengths:

| Strategy | Best For | OOS Win Rate | Core Indicators |
|----------|----------|-------------|-----------------|
| Pipeline | Trends | 75% | Multi-timeframe EMA + RSI |
| BB Squeeze | Volatility Breakouts | 56% | Bollinger Band squeeze → expansion |
| MACD Divergence | Ranging Reversals | 33%* | MACD divergence + volume confirmation |
| Mean Reversion | Range Trading | 25%* | Z-score + Bollinger regression |

> *MACD Div and MR have lower OOS win rates in aggregate, but when filtered by the correct market regime, their real-world performance improves significantly. That's the whole point of strategy routing.

### Why Keep Low Win-Rate Strategies?

Intuition says to only use your highest win-rate strategy. But this ignores a fact: **markets are ranging 60-70% of the time**. If you only have trend strategies, you're either making money or losing it most days.

Low win-rate strategies become profitable in the "right market state." BB Squeeze in high-volatility environments jumps from 56% to 80%+. MACD Div in ranging markets sees significant accuracy improvement.

## The Strategy Router: Auto-Matching Market to Strategy

### Routing Logic

```
Market Regime Detection (ADX + BB + ATR + EMA)
        ↓
┌──────────────────────────────────────────┐
│ TRENDING (ADX > 25) → Pipeline           │
│ RANGING (ADX < 20)  → MR + MACD Div     │
│ HIGH_VOL (BB > 15%) → BB Squeeze         │
│ BREAKOUT (BB squeeze → expansion)        │
│                      → Pipeline           │
└──────────────────────────────────────────┘
        ↓
    WFO Validation: Does this combo have OOS data?
        ↓
┌──────────────────────┐
│ ✅ Validated → L2    │  ← Normal position
│ ❌ Unvalidated → L1  │  ← Downgraded 50%
└──────────────────────┘
```

### Live Routing Table (Today's Data)

Our system currently tracks 6 major coins × 2 directions = 12 combinations, each with its own optimal strategy mapping:

- **BTC SHORT** → BB Squeeze (91% WR, PF 8.5)
- **ETH SHORT** → MACD Divergence (86% WR, PF 5.0)
- **BNB LONG** → MACD Divergence (86% WR, PF 4.5)
- **XRP LONG** → MACD Divergence (80% WR, PF 3.0)
- **SOL LONG** → BB Squeeze (75% WR, PF 2.0)

7 out of 12 combinations are active. The other 5 are paused because we haven't found robust enough strategies for them — **which is itself a form of risk management**.

## WFO Validation: The Quality Gate

The most critical safety mechanism in the strategy router is **Walk-Forward Optimization (WFO) validation**.

### What Is WFO?

In simple terms:

1. Train on the first 70% of data (In-Sample)
2. Test on the last 30% (Out-of-Sample)
3. Roll the window forward and repeat, ensuring the strategy profits on unseen data

### A Real Lesson We Learned the Hard Way

ETH/USDT LONG with the Pipeline strategy looked great in-sample, but its WFO validation had **zero OOS trades** — the validation data was empty.

The system still opened a position with L2 confidence (normal position size). Result? That trade lost $11.05, the biggest loss among all automated trades.

**Lesson**: We immediately changed the rule — any strategy combination without WFO validation data is automatically downgraded to L1 (50% position size).

```python
# WFO-verified combinations
WFO_VERIFIED = {
    ("BTCUSDT", "SHORT"), ("ETHUSDT", "SHORT"),
    ("BNBUSDT", "LONG"),  ("BNBUSDT", "SHORT"),
    ("XRPUSDT", "LONG"),  ("XRPUSDT", "SHORT"),
    ("SOLUSDT", "LONG"),
}

def get_confidence_level(symbol, direction):
    if (symbol, direction) in WFO_VERIFIED:
        return "L2"  # Normal position
    return "L1"  # Downgraded to 50%
```

## Confidence Tiers × Position Sizing

The router doesn't just decide which strategy — it decides how much capital to deploy:

| Confidence | WFO Status | Position Size | Description |
|-----------|-----------|--------------|-------------|
| L3 | ✅ + multi-strategy agreement | 100% | Highest confidence, multiple strategies signal together |
| L2 | ✅ | 75% | Standard position, OOS validated |
| L1 | ❌ or partial | 50% | Downgraded, reducing loss impact |

Combined with 2% risk-per-trade and losing-streak reduction, even consecutive losses stay within manageable bounds.

## Correlation Risk Management

Multiple strategies introduce a new problem: **if BTC and ETH both signal long, you're carrying double directional risk** (since they're highly correlated).

Our rules:
- Maximum 3 same-direction positions simultaneously
- BTC/ETH high-correlation group: max 2 same-direction
- Check existing position direction distribution before opening new trades

## Live Performance

Separated performance since system launch:

| Mode | Trades | Win Rate | Cumulative PnL |
|------|--------|----------|----------------|
| Paper (manual signals) | 10 | 87.5% | +$17.41 |
| Testnet (automated) | 8 | 62.5% | +$30.26 |
| **Total** | **18** | **72.2%** | **+$47.67** |

Manual signals have higher win rates because Judy (the human trader) adds judgment to filter borderline signals. The automated 62.5% is expected to improve further with WFO validation gating now in place.

## Takeaways

1. **Don't chase one perfect strategy** — markets change, your system should adapt
2. **Build market regime detection first** — knowing "what kind of market is this" matters more than predicting the future
3. **WFO validation is non-negotiable** — in-sample 100% win rate means nothing; OOS is the truth
4. **No validation = automatic downgrade** — better to earn less than lose more
5. **Watch correlations** — diversification isn't buying more coins, it's ensuring they don't all move together

---

*This is the fourth article in our "Quantitative Trading in Practice" series. If you're building your own trading system, follow us on [X](https://x.com/AnalyzCryptoMi) for more discussions.*
