---
title: "Your Strategy Has 87% Win Rate? Z-Score Says: That's an Illusion"
date: 2026-03-06
draft: false
author: "J (Tech Lead)"
categories: ["Quantitative Trading"]
tags: ["Backtesting", "Statistics", "Paper Trading", "Z-Score", "Overfitting"]
description: "Our paper trading system ran 33 trades with an 87% win rate on paper. Then we added Z-score statistical testing — and every single strategy failed. Here's why that's actually good news."
ShowToc: true
TocOpen: true
lastmod: 2026-03-08T17:35:29+00:00
faq:
  - q: "What is a Z-score in trading and why does it matter?"
    a: "Z-score measures how statistically different your win rate is from random coin-flipping. The formula compares your actual win rate against a 50% baseline, scaled by sample size. A Z-score above 1.65 means 95% confidence your edge is real (p < 0.05). Below that threshold, your results are statistically indistinguishable from luck. This matters because traders routinely deploy real capital based on a handful of winning trades, mistaking small-sample noise for genuine skill. Z-score forces an honest answer: are you actually better than chance, or just early in a lucky streak?"
  - q: "How many trades do I need before a backtest is statistically valid?"
    a: "For a 60% win rate to clear Z > 1.65 significance, you need roughly 70+ trades. For a 55% edge, expect 270+ trades. An 8-trade or 30-trade sample is almost never enough to prove anything, regardless of how good the numbers look. Our 33-trade dataset produced Z = -0.87 across all strategies, meaning none of them passed. The brutal rule: if your sample is under 50 trades, treat the win rate as a placeholder, not evidence. Run paper trading longer before risking real money."
  - q: "What is Bayesian-adjusted win rate and when should I use it?"
    a: "Bayesian-adjusted win rate applies a Beta(1,1) prior using the formula (wins + 1) / (total + 2). It pulls small-sample results toward 50% to prevent overconfidence. Three wins out of three becomes 80% adjusted, not 100%. Seven wins out of eight becomes 80%, not 87.5%. Large samples like 70 of 100 barely shift (69.6%). Use it on any strategy with fewer than 50 trades, on any new system after a hot streak, and whenever you feel the urge to scale up based on early results. It is the cheapest defense against deploying noise as strategy."
  - q: "Can a strategy still be profitable with a sub-50% win rate?"
    a: "Yes, and ours is. Despite a 42.9% adjusted win rate, overall P&L is +0.57% because average win exceeds average loss. This is asymmetric risk-reward: cutting losers fast and letting winners run flips a losing win rate into a profitable account. Trend-following systems often win 30-40% of the time but capture 3-5x larger gains on winners. The win rate alone is meaningless — what matters is expectancy = (win rate × avg win) - (loss rate × avg loss). Focus on the product, not either factor in isolation."
  - q: "What is the most common mistake when interpreting backtest results?"
    a: "Treating raw win rate as proof of edge without checking sample size or statistical significance. A trader sees 87% across 8 trades and deploys real capital, then blows up when reality reverts to the true distribution. Other frequent mistakes: ignoring transaction costs and slippage, curve-fitting parameters to historical data, cherry-picking favorable date ranges, and confusing recent hot streaks with permanent edge. Always run Z-score testing, apply Bayesian adjustment, separate strategies by signal source, and compute drawdown alongside returns. If a strategy cannot survive these four filters, it is not ready for real money."
  - q: "How does Z-score testing compare to Sharpe ratio for strategy validation?"
    a: "They answer different questions. Z-score tests whether your win rate is statistically distinguishable from random — a yes/no significance check. Sharpe ratio measures risk-adjusted return: excess return divided by volatility. A strategy can have a strong Sharpe and still fail Z-score if the sample is tiny, and vice versa. Use both: Z-score to confirm the edge is real, Sharpe to compare strategies on risk-adjusted performance. For institutional standards, target Z > 1.65 and Sharpe > 1.0. Either metric alone is insufficient; together they catch both small-sample illusions and high-volatility traps."
  - q: "Who should run Z-score validation on their trading strategy?"
    a: "Anyone deploying capital based on backtest or paper trading results — retail algo traders, quant developers, prop desk candidates, and crypto signal subscribers. It is especially critical for traders with fewer than 100 historical trades, anyone running multiple strategies simultaneously, and teams reviewing a new signal source before allocation. Discretionary traders benefit too: logging 50 trades and computing Z-score reveals whether your intuition has a measurable edge. Skip it only if you have thousands of trades across multiple market regimes. For everyone else, ten minutes of statistical testing prevents months of blown accounts."

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

## The Numbers Lie

Our paper trading system ran for a month, and the numbers looked beautiful on a spreadsheet:

> 87.5% win rate, 7 wins, 1 loss, 2 breaks even

When most people see those numbers, their reaction is: "Awesome! Time to trade real money!"

Our reaction was: **"Hold on. Let the math speak first."**

## What is Z-Score?

At its core, Z-score is asking one simple question: **How much better are you than just flipping a coin?**

$$Z = \frac{\hat{p} - 0.5}{\sqrt{0.5 \times 0.5 / n}}$$

- $\hat{p}$ is your win rate
- $n$ is the number of trades
- If Z > 1.65, you have 95% confidence you're better than a coin flip (p < 0.05)

It sounds straightforward, but **most traders never run this test**. They see a 70% win rate and jump straight to real money, then blow up their account and ask "but the backtest was good!"

## The Real Data: 33 Trades and Uncomfortable Truths

We ran Z-score testing on all 33 closed trades. Here's what we found:

| Strategy | Trades | Raw Win Rate | Adjusted Win Rate | Z-Score | Significant? |
|----------|--------|--------------|-------------------|---------|--------------|
| CEX Volume + Funding | 11 | 45.5% | 46.2% | -0.30 | ✗ |
| TradingView Signals | 8 | 62.5% | 60.0% | +0.71 | ✗ |
| Pipeline | 7 | 28.6% | 33.3% | -1.13 | ✗ |
| Other | 7 | 28.6% | 33.3% | -1.13 | ✗ |
| **Overall** | **33** | **42.4%** | **42.9%** | **-0.87** | **✗** |

**Every single strategy had a p-value > 0.05. None of them passed the statistical test.**

What about that 87.5% win rate? That came from just 8 manually managed trades in paper trading mode — a sample way too small. After Bayesian adjustment, it's really only 60%, and p = 0.24. What statistics says: **You're statistically indistinguishable from a coin flip.**

## Bayesian-Adjusted Win Rate: The Cure for Small Samples

We implemented a Bayesian adjustment using a Beta(1,1) prior that automatically pulls small-sample win rates toward 50%:

$$\text{Adjusted Win Rate} = \frac{wins + 1}{total + 2} \times 100\%$$

The effect:
- 3 wins out of 3 → Raw 100% → **Adjusted 80%**
- 7 wins, 1 loss → Raw 87.5% → **Adjusted 80%**
- 70 out of 100 → Raw 70% → **Adjusted 69.6%** (large samples barely move)

This protects you from the illusion of "3 perfect trades."

## So Is the Account Actually Up?

Yes. Overall P&L is **+0.57%**.

This means even though win rate is below 50%, our risk management is working: **average loss per losing trade < average profit per winning trade**.

That's actually a good sign — the system profits from "making more on winners than losers," not from "being right more often." But 33 trades isn't enough data to draw firm conclusions.

## How Many Trades Do You Need?

| True Win Rate | Minimum Trades for p < 0.05 |
|---------------|----------------------------|
| 55% | ~384 trades |
| 60% | ~96 trades |
| 65% | ~44 trades |
| 70% | ~24 trades |

If your strategy truly has a 65% win rate, roughly 44 trades will prove it statistically. We're at 33 trades with 42% win rate — still some distance to go before we have "statistically significant edge."

## Overfitting Index (OFI)

Beyond Z-score, we added an overfitting index:

$$OFI = \frac{IS\_PF}{OOS\_PF}$$

In-sample Profit Factor divided by out-of-sample Profit Factor.

- OFI < 1.5 → Low overfitting risk ✓
- OFI 1.5–2.0 → Medium risk ⚠️
- OFI > 2.0 → High overfitting risk ✗
- OFI > 3.0 → Severe overfitting ✗✗

When your backtest dramatically outperforms live trading, OFI flags it directly.

## New Decision Logic

We used to rely on hard-coded thresholds (IS-OOS gap > 15% = overfitting). Now we use:

```
< 5 trades          → "Insufficient data"
p ≥ 0.05            → "Not statistically significant"
OFI > 2.0           → "Overfitted"
Adjusted WR ≥ 62%   → "Robust ✓"
Adjusted WR ≥ 58%   → "Acceptable"
Otherwise           → "Under review"
```

Notice line two — **p ≥ 0.05 means we mark it as not significant**. Previously, many strategies that looked "robust" were actually just underfunded with too little sample size to call.

## So Are Our Strategies Bad?

No. Our strategies are **unproven, not bad**. That's a completely different thing.

Thirty-three trades is too small. Here's our plan:

1. **Keep accumulating data** without tweaking parameters, until we hit 50+ trades
2. **Re-run Z-score at 50 trades** — if any strategy hits p < 0.05, increase position size
3. **Eliminate failures** — shut down any strategy still at p > 0.10 after 50 trades

That's the difference between quantitative trading and "trading by feel": **You're not guessing. You're waiting for the math to answer.**

## Takeaway

> Most retail traders lose money not because their strategies are bad, but because they never verify whether their strategies actually work.

Z-score testing isn't hard to implement, but it saves you from the classic path: "Small sample, high win rate → trade real money → blowup."

If you're also doing quantitative trading, before you trade real money, ask yourself this:

**"Is my win rate statistically significantly different from a coin flip?"**

If the answer is "I'm not sure" — then it's "no."

## References

- [Z score : r/Trading - Reddit](https://www.reddit.com/r/Trading/comments/186hide/z_score/)
- [87% chance of winning 1 out of 3 - Wizard of Vegas](https://wizardofvegas.com/forum/gambling/betting-systems/35661-87-chance-of-winning-1-out-of-3/)
- [The 90% Win Rate Trading Strategy (and the BIG Problem Behind It)](https://www.youtube.com/shorts/sVT87Dk-vL8)
