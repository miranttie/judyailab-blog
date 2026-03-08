---
title: "CoinSifter: Open Source Your First Crypto Screening Tool"
date: "2026-03-08T20:06:45+00:00"
draft: false
author: "J (Tech Lead)"
summary: Judy AI Lab releases their internal crypto screening engine CoinSifter as open source. Supports 6 technical indicators, multi-timeframe scanning, Web UI and Telegram push notifications. This article explains the reasons for open sourcing, core features, architecture design, and a 5-minute quick start guide.
description: CoinSifter is a free open-source crypto screening tool with RSI, EMA, MACD, Bollinger Bands, KDJ, and Volume indicators. Supports custom strategies, multi-timeframe scanning, Web UI and Telegram alerts for quant traders.
categories:
  - "Quantitative Trading"
  - "Product"
tags:
  - "CoinSifter"
  - "Crypto Screening"
  - "Technical Indicators"
  - "Open Source Tool"
  - "Python"
  - "RSI"
ShowWordCount: true
faq:
  - q: "Does CoinSifter require a paid API?"
    a: "No. You only need a free Binance API Key (with read-only permissions) to scan all trading pairs."
  - q: "Can CoinSifter automate trades?"
    a: "No. CoinSifter only handles screening and notifications — it won't place orders for you. Trading decisions should be made by humans."
  - q: "Which technical indicators are supported?"
    a: "Currently supports RSI, EMA, MACD, Bollinger Bands, KDJ Stochastic, and Volume — six indicators in total. You can freely combine them to create screening conditions."
  - q: "How to set up Telegram notifications?"
    a: "Just add your Bot Token and Chat ID in config.yaml, and CoinSifter will automatically push matching coins to your Telegram when conditions are met."
  - q: "Can it scan multiple timeframes at once?"
    a: "Yes. CoinSifter supports scanning 4H, 1H, 15m, and 1D timeframes simultaneously, with results displayed in tabs on the Web UI."
a: Yes. CoinSifter supports scanning 4H, 1H, 15m, and 1D timeframes simultaneously, with results displayed in tabs on the Web UI.
ShowToc: true
---

## From Internal Tool to Open Source

Every quantitative trader's workflow starts with the same point: filtering through thousands of coins to find ones that match your criteria.

Our team is no different. While building our automated trading system, we needed a tool to answer the most fundamental question: **Which coins currently meet my technical conditions?**

There are plenty of screening tools out there, but most have these issues:

- Free versions have limited features, core functionality requires payment
- No support for custom indicator combinations
- Can't be deployed locally — data security is questionable
- Can't integrate with your own automation workflows

So we built our own. After using it for a few months, we decided to open source it.

## What CoinSifter Can Do

### Six Technical Indicators

| Indicator | Description | Example Setting |
|-----------|-------------|-----------------|
| RSI | Relative Strength Index | `48 < RSI < 52` for range breakout |
| EMA | Exponential Moving Average | `EMA20 > EMA50` to confirm trend |
| MACD | Moving Average Convergence Divergence | Histogram turning positive, momentum reversal |
| Bollinger Bands | Bollinger Bands | Price touching lower band, looking for bounce |
| KDJ | Stochastic Oscillator | K-line crossing above D-line from oversold zone |
| Volume | Volume | Breaking 2x the recent average volume |

All indicators can have upper and lower bounds set, freely combined into screening strategies.

### Strategy System

Screening conditions are saved as YAML files — a strategy is just a set of rules:

```yaml
# strategies/trend_long.yaml
name: "Trend Long"
timeframe: "4h"
filters:
  RSI:
    min: 50
    max: 70
  EMA:
    short_period: 20
    long_period: 50
    condition: "short_above_long"
  Volume:
    min_ratio: 1.5
```

You can save multiple strategies — long and short setups — and switch between them anytime.

### Web UI

Browser-based interface with three main pages:

1. **Screener** — Select a strategy, hit scan, results displayed as indicator cards
2. **Scheduled Scan** — Set up automatic scans every N hours, results pushed to Telegram
3. **Settings** — API Key, Telegram Bot, scan parameters

Dark theme, perfect for long monitoring sessions.

### Telegram Notifications

When coins match your conditions, they're automatically pushed to your specified Telegram group or direct message. No need to keep your computer running to check results.

## Architecture

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  Strategy  │────▶│   Filter     │────▶│   Result    │
│    YAML    │     │   Engine     │     │  Output     │
│ (Rules)    │     │ (Indicators) │     │ (Web/TG)    │
└─────────────┘     └──────┬───────┘     └─────────────┘
                           │
                    ┌──────┴───────┐
                    │  Binance API │
                    │  (K-line)    │
                    └──────────────┘
```

Core components:

- **filter_engine.py** — Filter engine, takes strategy rules and market data, outputs matching coins
- **indicators.py** — Technical indicator calculations, pure Python + pandas
- **notifier.py** — Notification module, supports Telegram
- **web.py** — Flask web server, provides UI
- **coinsifter.py** — CLI entry point, supports one-time and loop modes

## 5-Minute Quick Start

### Prerequisites

- Python 3.8+
- Binance API Key (free to apply, just need read-only permissions)

### Installation

```bash
git clone https://github.com/judyailab/coinsifter.git
cd coinsifter
pip install -r requirements.txt
cp config.example.yaml config.yaml
```

### Configure API Key

Edit `config.yaml` and add your Binance API Key:

```yaml
binance:
  api_key: "YOUR_API_KEY"
  api_secret: "YOUR_API_SECRET"
```

> Only read permission (Enable Reading) is needed — trading permissions are not required.

### Launch Web UI

```bash
python web.py
```

Open your browser to `http://localhost:5050`, select a strategy, and hit scan.

### Command Line Mode

```bash
# Scan with default strategy
python coinsifter.py

# Specify a strategy
python coinsifter.py --strategy strategies/trend_long.yaml

# Loop mode (scan every 4 hours)
python coinsifter.py --loop --interval 14400
```

## Why Open Source

Three reasons:

**1. Screening is the starting point of trading — it shouldn't have a barrier**

The screening tool itself doesn't provide a trading edge. The real edge comes from how you interpret the results, design your trading strategy, and manage risk. By making the entry tool free and open, more people can focus on what really matters.

**2. Open source makes the tool better**

Our team is small — we can't possibly cover all coins, all indicators, all use cases. With open source, the community can contribute new indicators, fix bugs, and suggest improvements.

**3. Building trust**

We'll launch advanced analysis and trading tools in the future. Proving our technical capability and sincerity with a free open source tool first is more convincing than marketing talk.

## What's Next

CoinSifter is just the first step. Here's what we're planning:

- **More technical indicators**: ATR, ADX, OBV, etc.
- **Multi-exchange support**: OKX, Bybit
- **Backtesting integration**: Feed screening results directly into a backtesting framework to validate strategy effectiveness
- **Community strategy library**: Let users share and rate screening strategies

If you find this tool useful, feel free to drop a Star on GitHub.

---

*CoinSifter is an open source project by [JudyAI Lab](https://judyailab.com). MIT licensed, free to use and modify.*
