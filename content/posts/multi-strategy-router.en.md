---
title: "One Strategy Isn't Enough — How We Built an AI Strategy Router"
date: 2026-03-05T22:00:00+08:00
draft: false
author: "J (Tech Lead)"
categories: ["Quantitative Trading"]
tags: ["multi-strategy", "strategy routing", "WFO", "backtesting", "automated trading"]
description: "A single strategy performs dramatically different in trending vs ranging markets. We built a strategy router that automatically selects the best strategy based on market regime, with WFO validation as a quality gate."
summary: "Why single-strategy systems are doomed to fail, how our four-strategy system auto-switches based on market regime, and why WFO validation is the quality gate you can't skip."
lastmod: 2026-05-25T11:26:34+00:00
faq:
  - q: "What is an AI strategy router in algorithmic trading?"
    a: "A strategy router is a meta-system that automatically selects the best trading strategy based on the current market regime, rather than relying on a single universal strategy. It detects market state using indicators like ADX, Bollinger Bands, ATR, and EMA, then routes execution to the strategy proven to perform best in that regime. Our router picks between four strategies — Pipeline, BB Squeeze, MACD Divergence, and Mean Reversion — and validates each combo against Walk-Forward Optimization (WFO) out-of-sample data before allowing full position sizing."
  - q: "Why use low win-rate strategies like MACD Divergence (33%) or Mean Reversion (25%)?"
    a: "Aggregate win rates are misleading. These strategies look weak overall but excel in specific market regimes. Mean Reversion at 25% aggregate jumps significantly when filtered to ranging markets, and BB Squeeze rises from 56% to 80%+ during high-volatility breakouts. Since markets range 60-70% of the time, a trend-only system bleeds money most days. Keeping regime-specialized strategies and routing them correctly turns their statistical weakness into a strength — you only deploy them when conditions favor their edge."
  - q: "How does the router detect market regime?"
    a: "The router combines four indicators: ADX measures trend strength (>25 = trending, <20 = ranging), Bollinger Band width detects volatility (>15% = high vol), ATR confirms volatility magnitude, and EMA slope confirms trend direction. A BB squeeze followed by expansion signals a breakout. These signals map to routing rules: trending markets get Pipeline, ranging markets get Mean Reversion plus MACD Divergence, high-volatility states get BB Squeeze, and confirmed breakouts return to Pipeline. The classification updates each bar so the active strategy follows regime shifts."
  - q: "What is WFO validation and why does it gate position sizing?"
    a: "Walk-Forward Optimization (WFO) tests a strategy on rolling out-of-sample windows to confirm performance is not curve-fit to historical data. In our router, only strategy-regime combinations with validated OOS results qualify for L2 (normal) position sizing. Unvalidated combos drop to L1 — reduced size — acting as a safety net against routing into untested territory. This prevents the classic backtest trap where in-sample numbers look great but live performance collapses. WFO is the quality gate between research and real capital."
  - q: "How is a strategy router different from a trading bot that runs multiple strategies in parallel?"
    a: "Parallel-strategy bots run every strategy simultaneously and let signals fight for capital, which causes overexposure during regime shifts and conflicting trades. A router runs one strategy at a time — whichever matches the current regime. This avoids capital fragmentation, eliminates contradictory positions (one long, one short on the same asset), and produces cleaner P&L attribution. You always know which strategy is active and why, making debugging and parameter tuning far easier than untangling overlapping multi-strategy noise."
  - q: "Who should build a strategy router instead of optimizing a single strategy?"
    a: "A router suits traders who already have two or more validated strategies with distinct edges (e.g., one trend, one mean-reversion) and consistent backtest data. If you're still searching for your first profitable strategy, build that first — routing won't fix a broken edge. Routers fit quants managing multi-week drawdowns from regime mismatches, systematic traders running on liquid assets like BTC/ETH with reliable ADX/BB signals, and teams with infrastructure to run WFO validation. Discretionary traders or single-strategy beginners gain less."
  - q: "What are the common mistakes when building a strategy router?"
    a: "Four mistakes dominate. First, skipping WFO validation and trusting in-sample backtests — this hides curve-fitting. Second, switching strategies too aggressively on noisy regime signals; add hysteresis or require multi-bar confirmation. Third, equal-weighting strategies regardless of OOS confidence — always tier position sizing (L1 vs L2). Fourth, ignoring transaction costs from frequent strategy switches, which can erase the edge gained by routing. Build the regime detector and validation gate before adding strategies, not after."

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

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

## References

- [Smart Routing: The Hidden Secret Behind 10x More Powerful AI Systems | by Manoj Desai | Medium](https://medium.com/@the_manoj_desai/smart-routing-the-hidden-secret-behind-10x-more-powerful-ai-systems-bd4258d6813a)
- [An effective AI strategy: How to build one | Google Cloud Blog](https://cloud.google.com/transform/how-to-build-an-effective-ai-strategy)
- [r/artificial on Reddit: I built a router that automatically sends your AI tasks to the most appropriate model to handle](https://www.reddit.com/r/artificial/comments/1t0soki/i_built_a_router_that_automatically_sends_your_ai/)

---

## Further Reading

- [Your Strategy Has 87% Win Rate? Z-Score Says: That's an Illusion](/posts/z-score-reality-check/)
- [Quantitative Trading System Build: From First Backtest Code to Paper Trading](/posts/quant-trading-journey/)
- [100% Win Rate in Backtesting? Don't Celebrate Yet — Our Most Painful Lesson](/posts/oos-validation-lesson/)
