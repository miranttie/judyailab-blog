---
title: "Your Strategy Has 87% Win Rate? Z-score Says: That's an Illusion"
date: 2026-03-06
draft: false
author: J (Tech Lead)
summary: "A paper trading strategy with 87.5% apparent win rate fails statistical validation—Z-score yields p=0.24, no significant difference from coin flipping. Using Bayesian adjustment and Overfitting Index (OFI) with 33 real trades to establish a strategy validation logic that avoids the small-sample high-win-rate trap."
description: "Quantitative traders often get misled by sky-high paper trading win rates. This article uses 33 real trades to expose the statistical illusion behind 87% win rate, applying Z-score testing, Bayesian adjustment, and Overfitting Index (OFI). Learn why 50 trades is the minimum threshold and how many samples different win rates need to prove real edge—verify your strategy with math before risking real money."
categories:
  - "Quantitative Trading"
tags:
  - "Z-score"
  - "Overfitting"
  - "Backtesting"
  - "Statistical Test"
  - "Paper Trading"
  - "Quantitative Trading"
ShowWordCount: true
ShowToc: true
TocOpen: true
lastmod: 2026-03-13T07:29:33+00:00
faq:
  - q: "What is Z-score and why must quantitative traders run this test?"
    a: "Z-score measures how far your win rate deviates from 'coin flip 50%', formula is (win_rate-0.5)/√(0.25/n). When Z>1.65, you have 95% confidence your strategy actually has an edge (p<0.05). Running live trades without this test is basically confusing luck for skill—this is the classic way retail traders blow up their accounts."
  - q: "Why is 87.5% win rate a statistical illusion?"
    a: "Because the sample size is only 8 trades. After Bayesian adjustment it drops to 60%, with p-value 0.24—way above 0.05. This means there's no statistical difference from coin flipping. High win rates with small samples are almost always just luck. You need at least 24+ trades (assuming true win rate of 70%) to初步驗證 edge."
  - q: "How do you calculate Bayesian-adjusted win rate? How does it differ from raw win rate?"
    a: "Formula is (wins+1)/(total+2), using Beta(1,1) prior to pull small samples toward 50%. A perfect 3/3 at 100% gets adjusted to 80%, but 70/100 only adjusts to 69.6%—barely affected. Its purpose is preventing you from falling for the '3 trades 100%' illusion while having minimal impact on large samples."
  - q: "How many trades does my strategy need to be statistically valid?"
    a: "It depends on your true win rate: 55% needs ~384 trades, 60% needs 96 trades, 65% needs 44 trades, 70% needs 24 trades. The closer your win rate is to 50%, the more samples you need to separate skill from luck. In practice, 50 trades is the absolute minimum—talking about edge before that is premature."
  - q: "What is the Overfitting Index (OFI)? How do you interpret it?"
    a: "OFI = IS_Profit_Factor / OOS_Profit_Factor, used to detect bloated backtest results. OFI<1.5 = low risk, 1.5-2.0 = medium, >2.0 = high, >3.0 = severe overfitting. When backtest performance is much better than live trading, OFI catches it immediately—more precise than hardcoding 'IS-OOS gap>15%' thresholds."
  - q: "Why can the strategy show positive returns even with sub-50% win rate? Does that mean the strategy is okay?"
    a: "It means risk management is working—you're making more per winning trade than losing per losing trade. That's a good sign but not conclusive, because 33 trades is too small and positive returns could come from one or two big winners. You need Z-score to verify edge exists first, then check if profit distribution is stable, before calling the strategy viable."
  - q: "Why does the new strategy decision logic reject p≥0.05 as not significant immediately?"
    a: "Hardcoded thresholds like 'WR>60% = robust' wrongly label 'lucky strategies with insufficient samples' as effective. The new logic checks sample size first (<5 trades = insufficient data), then p-value (p≥0.05 = rejected), then adjusted WR and OFI. This blocks small-sample scams where luck gets mistaken for alpha."

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

## The Numbers on Paper Are Lying

Our paper trading system ran for a month, and the numbers looked pretty sweet:

> Win rate 87.5%, 7 wins 1 loss 2 ties

When most people see that number, the reaction is "Hell yeah, let's go live!"

Our reaction was: **"Hold up—let's let the math speak first."**

This article documents our conclusions after running statistical tests on 33 real trades—and why that 87.5% was pure illusion.

## Why 87.5% Win Rate Is a Statistical Illusion

Z-score essentially asks one question: **How does your performance compare to flipping a coin?**

$$Z = \frac{\hat{p} - 0.5}{\sqrt{0.5 \times 0.5 / n}}$$

- $\hat{p}$ is your win rate
- $n$ is number of trades
- If Z > 1.65, you have 95% confidence you're better than random guessing (p < 0.05)

Sounds simple, but **most traders never run this test**. They see 70% win rate and go live immediately, then lose everything before asking "but the backtest was so good."

Plugging in that 87.5%: 8 trades, Bayesian-adjusted to just 60%, p-value 0.24. Statistics gives you a one-line answer—**there's no significant difference from coin flipping.**

For the full trade breakdown, we covered it in [Paper Trading Monthly Review: 33 Trades Debrief](/2026/paper-trading-monthly-review/). This article focuses on the statistical testing methodology.

## Zero Strategies Pass After 33 Trades

We ran Z-score tests on all 33 closed trades across strategies:

| Strategy | #Trades | Raw WR | Adjusted WR | Z-score | Significant? |
|----------|---------|--------|-------------|---------|--------------|
| CCEX Volume + Funding | 11 | 45.5% | 46.2% | -0.30 | ✗ |
| TradingView Signals | 8 | 62.5% | 60.0% | +0.71 | ✗ |
| Pipeline | 7 | 28.6% | 33.3% | -1.13 | ✗ |
| Others | 7 | 28.6% | 33.3% | -1.13 | ✗ |
| **Overall** | **33** | **42.4%** | **42.9%** | **-0.87** | **✗** |

**Every single strategy has p > 0.05—none passed statistical validation.**

That 87.5% win rate? It was just 8 manually managed trades in paper trading mode—sample too small, Bayesian-adjusted to 60%, with p = 0.24.

First conclusion: **With fewer than 30 trades, it's too early to talk about win rates.**

## Bayesian Adjustment: Subtracting Luck from Win Rate

We added a Bayesian adjustment mechanism using Beta(1,1) prior to pull small-sample win rates toward 50%:

$$\text{Adjusted WR} = \frac{wins + 1}{total + 2} \times 100\%$$

Effects:

- Case 1: 3 wins out of 3 → Raw 100% → **Adjusted 80%**
- Case 2: 7 wins 1 loss → Raw 87.5% → **Adjusted 80%**
- Case 3: 70/100 → Raw 70% → **Adjusted 69.6%** (large samples barely affected)

This makes sure you can't get fooled by "3 trades at 100%" illusions. The larger the sample, the lighter the adjustment—which is exactly what we want.

## Positive PnL Doesn't Mean the Strategy Works

Overall PnL is **+0.57%**.

Even with a sub-50% win rate, our risk management is doing its job right: **average loss per losing trade < average profit per winning trade**.

That's actually a good sign—the system makes money via "winners bigger than losers" rather than "predicting correctly." But with only 33 trades, it's too small to conclude. The positive returns could come from one or two big winners pulling the numbers up. We need Z-score to verify edge exists before calling the strategy "effective."

## How Many Trades Does Your Strategy Need?

| True WR | Minimum for p < 0.05 |
|--------|---------------------|
| 55% | ~384 trades |
| 60% | ~96 trades |
| 65% | ~44 trades |
| 70% | ~24 trades |

Two things: First, the closer your win rate is to 50%, the more trades you need to separate skill from luck—this grows exponentially. Second, a strategy with true 65% win rate needs roughly 44 trades to prove it. Third, we're at 33 trades with 42% WR—we've got a ways to go before having a "statistically significant edge."

Practical minimum: **50 trades**. Talking about edge below that number is premature.

## OFI Overfitting Index: Catching Backtest Bloat

On top of Z-score, we added the Overfitting Index:

$$OFI = \frac{IS_PF}{OOS_PF}$$

IS (In-Sample) Profit Factor divided by OOS (Out-of-Sample) Profit Factor.

- OFI < 1.5 → Low overfitting risk ✓
- OFI 1.5-2.0 → Medium risk ⚠️
- OFI > 2.0 → High overfitting risk ✗
- OFI > 3.0 → Severe overfitting ✗✗

When your backtested performance is way better than live trading, OFI catches it immediately. Compared to hardcoding "IS-OOS gap > 15%" thresholds, OFI better reflects the actual ratio between the two samples.

For more on backtesting traps, check out the second half of [From Trading Concepts to Production Code: How Much Can AI Actually Help?](/2026/trading-concept-to-production-code-with-ai/).

## The New Strategy Decision Logic

Previously we used hardcoded thresholds (IS-OOS gap > 15% = overfitting). Now it's:

```
< 5 trades      → "Insufficient Data"
p ≥ 0.05        → "Not Statistically Significant"
OFI > 2.0       → "Overfitting"
Adjusted WR ≥ 62% → "Robust ✓"
Adjusted WR ≥ 58% → "Acceptable"
Others           → "Pending Observation"
```

Note the second line—**p ≥ 0.05 gets rejected outright**. Previously, many seemingly "robust" strategies were just falsely labeled as effective due to insufficient sample sizes. The new logic puts sample size first, then p-value second—blocking small-sample scams before checking OFI and adjusted WR.

## So Our Strategy Sucks, Right?

Wrong. Our strategy **hasn't been proven effective yet**. Those are two completely different things.

33 trades is too few. Our plan:

1. **Step 1: Keep accumulating data**, don't change parameters, run to 50+ trades
2. **Step 2: Re-run Z-score after 50 trades**—if any strategy hits p < 0.05, increase position size
3. **Step 3: Kill the losers**—strategies still at p > 0.10 after 50 trades get shut down

This is the difference between quant trading and "feeling trading": **You're not guessing—you're waiting for math to give you the answer.**

## Closing: Ask This Before Going Live

> Most retail traders lose money not because their strategy sucks—they never verify whether the strategy actually works.

Z-score statistical testing isn't hard to implement, but it'll save you from the classic path: small-sample high win rate → go live → blow up.

If you're doing quantitative trading, ask yourself this question before going live:

**"Is my win rate statistically different from coin flipping?"**

If the answer is "I'm not sure"—then that's a "no."

At Judy AI Lab, we insist that every strategy passes both Z-score and OFI validation before trusting it with real money.

## FAQ

### What is Z-score and why must quantitative traders run this test?

Z-score measures how far your win rate deviates from "coin flip 50%", formula is (win_rate-0.5)/√(0.25/n). When Z>1.65, you have 95% confidence your strategy actually has an edge (p<0.05). Running live trades without this test is basically confusing luck for skill—this is the classic way retail traders blow up their accounts.

### Why is 87.5% win rate a statistical illusion?

Because the sample size is only 8 trades. After Bayesian adjustment it drops to 60%, with p-value 0.24—way above 0.05. This means there's no statistical difference from coin flipping. High win rates with small samples are almost always just luck. You need at least 24+ trades (assuming true win rate of 70%) to tentatively verify edge.

### How many trades does my strategy need to be statistically valid?

It depends on your true win rate: 55% needs ~384 trades, 60% needs 96 trades, 65% needs 44 trades, 70% needs 24 trades. The closer your win rate is to 50%, the more samples you need to separate skill from luck. In practice, 50 trades is the absolute minimum—talking about edge before that is premature.

### What is the Overfitting Index (OFI)? How do you interpret it?

OFI = IS_Profit_Factor / OOS_Profit_Factor, used to detect bloated backtest results. OFI<1.5 = low risk, 1.5-2.0 = medium, >2.0 = high, >3.0 = severe overfitting. When backtest performance is much better than live trading, OFI catches it immediately—more precise than hardcoding "IS-OOS gap>15%" thresholds.

### Why can the strategy show positive returns even with sub-50% win rate?

It means risk management is working—you're making more per winning trade than losing per losing trade. That's a good sign but not conclusive, because 33 trades is too small and positive returns could come from one or two big winners. You need Z-score to verify edge exists first, then check if profit distribution is stable, before calling the strategy viable.

## References

- [97% Win Rate Trading Strategy (Exposed) | Trading Rush](https://tradingrush.net/97-win-rate-trading-strategy-exposed/)
- [Understanding Trading Win/Loss Ratio: Definition, Formula, and Examples](https://www.investopedia.com/terms/w/win-loss-ratio.asp)
- [r/AutomateYourTrading on Reddit: Z-Score in Trading Algo Development: Measuring Repeatability and Ruling out Luck/Random](https://www.reddit.com/r/AutomateYourTrading/comments/1nn0im9/zscore_in_trading_algo_development_measuring/)
