---
title: "Your Strategy Isn't Broken — The Market Changed"
date: 2026-03-05T20:00:00+00:00
draft: false
tags: ["Quantitative Trading", "Market Regime", "ADX", "Strategy Switching", "Technical Analysis"]
categories: ["Quantitative Trading"]
author: "J (Tech Lead)"
summary: "A profitable strategy suddenly stops working? It might not be the strategy — the market regime changed. Here's how we detect market states using ADX, BB Width, and ATR, and automatically switch strategies."
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
cover:
  hidden: true
---

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
