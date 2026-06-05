---
title: CoinSifter：開源你的第一個加密貨幣篩選工具
date: "2026-03-08T20:06:45+00:00"
draft: false
author: "J (Tech Lead)"
summary: Judy AI Lab 將內部使用的加密貨幣篩選引擎 CoinSifter 完整開源，支援 6 種技術指標、多時間框架掃描，並提供 Web UI 和 Telegram 推播功能。本文說明開源原因、核心功能、架構設計，以及 5 分鐘快速上手教學。
description: CoinSifter 開源加密貨幣篩選工具，支援 RSI、EMA、MACD、布林帶、KD、成交量 6 大技術指標，可自訂策略條件、多時間框架掃描，提供 Web UI 視覺化介面與 Telegram 推播通知，適合量化交易者快速篩選符合技術條件的幣種。
categories:
  - "量化交易"
  - "產品"
tags:
  - "CoinSifter"
  - "加密貨幣篩選"
  - "技術指標"
  - "開源工具"
  - "Python"
  - "RSI"
ShowWordCount: true
faq:
  - q: "CoinSifter 需要付費的 API 嗎？"
    a: "不需要。只要免費的 Binance API Key（設為唯讀權限即可），就能掃描全部幣種。"
  - q: "CoinSifter 可以自動交易嗎？"
    a: "不行。CoinSifter 只負責篩選和通知，不會代你下單，交易決策應該由人類做出。"
  - q: "支援哪些技術指標？"
    a: "目前支援 RSI、EMA、MACD、布林帶、KD 隨機指標、成交量六種指標，可自由組合篩選條件。"
  - q: "如何設定 Telegram 推播？"
    a: "在 config.yaml 填入你的 Bot Token 和 Chat ID，篩選到符合條件的幣種時會自動推送到你的 Telegram。"
  - q: "可以同時掃描多個時間框架嗎？"
    a: "可以。CoinSifter 支援 4H、1H、15m、1D 四個時間框架同時掃描，結果會在 Web UI 中以分頁顯示。"
a: 可以。CoinSifter 支援 4H、1H、15m、1D 四個時間框架同時掃描，結果會在 Web UI 中以分頁顯示。
ShowToc: true
lastmod: 2026-05-25T11:26:34+00:00

---

## 從自用工具到開源

每個量化交易者的工作流程都有一個共同起點：從上千個幣種中，篩出符合自己條件的標的。

我們團隊也不例外。在建置自動交易系統的過程中，我們需要一個工具來回答最基本的問題：**現在哪些幣種符合我的技術條件？**

市面上有不少篩幣工具，但多數有以下問題：
- 免費版功能受限，核心功能要付費
- 不支援自定義指標組合
- 無法本地部署，數據安全是問號
- 無法跟自己的自動化流程整合

所以我們自己寫了一個。用了幾個月後，決定把它開源。

## CoinSifter 能做什麼

### 六種技術指標

| 指標 | 說明 | 設定範例 |
|------|------|---------|
| RSI | 相對強弱指數 | `48 < RSI < 52` 找盤整突破 |
| EMA | 指數移動平均 | `EMA20 > EMA50` 確認趨勢 |
| MACD | 移動平均收斂發散 | 柱狀圖由負轉正，動能反轉 |
| 布林帶 | Bollinger Bands | 價格觸及下軌，尋找反彈 |
| KD | 隨機指標 | K 線從超賣區向上穿越 D 線 |
| 成交量 | Volume | 突破近期平均量的 2 倍 |

所有指標都可以設定上下限，自由組合成篩選策略。

### 策略系統

篩選條件存成 YAML 檔案，一個策略就是一組規則：

```yaml
# strategies/trend_long.yaml
name: "趨勢做多"
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

可以儲存多個策略，做多做空各一套，隨時切換。

### Web UI

瀏覽器介面，三個功能頁：

1. **篩選器** — 選擇策略，一鍵掃描，結果用指標卡片展示
2. **排程掃描** — 設定每 N 小時自動掃描，結果推播到 Telegram
3. **設定** — API Key、Telegram Bot、掃描參數

深色主題，適合長時間盯盤。

### Telegram 推播

篩出符合條件的幣種時，自動推送到指定的 Telegram 群組或私聊。不需要一直開著電腦看結果。

## 架構設計

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  策略 YAML  │────▶│  篩選引擎    │────▶│  結果輸出   │
│  (規則定義) │     │  (指標計算)  │     │  (Web/TG)   │
└─────────────┘     └──────┬───────┘     └─────────────┘
                           │
                    ┌──────┴───────┐
                    │ Binance API  │
                    │ (K線數據)    │
                    └──────────────┘
```

核心元件：
- **filter_engine.py** — 篩選引擎，接收策略規則和市場數據，輸出符合條件的幣種
- **indicators.py** — 技術指標計算，純 Python + pandas
- **notifier.py** — 通知模組，支援 Telegram
- **web.py** — Flask Web 伺服器，提供 UI
- **coinsifter.py** — CLI 入口，支援單次和循環模式

## 5 分鐘快速上手

### 前置需求

- Python 3.8+
- Binance API Key（免費申請，設唯讀權限即可）

### 安裝

```bash
git clone https://github.com/judyailab/coinsifter.git
cd coinsifter
pip install -r requirements.txt
cp config.example.yaml config.yaml
```

### 設定 API Key

編輯 `config.yaml`，填入你的 Binance API Key：

```yaml
binance:
  api_key: "你的API_KEY"
  api_secret: "你的API_SECRET"
```

> 只需要唯讀權限（Enable Reading），不需要開啟交易權限。

### 啟動 Web UI

```bash
python web.py
```

打開瀏覽器前往 `http://localhost:5050`，選擇策略，按下掃描。

### 命令列模式

```bash
# 使用預設策略掃描
python coinsifter.py

# 指定策略
python coinsifter.py --strategy strategies/trend_long.yaml

# 循環模式（每 4 小時掃描一次）
python coinsifter.py --loop --interval 14400
```

## 為什麼開源

三個理由：

**1. 篩幣是交易的起點，不應該有門檻**

篩選工具本身不提供交易優勢。真正的優勢來自你怎麼解讀篩選結果、怎麼設計交易策略、怎麼控制風險。把入口工具免費開放，讓更多人能專注在真正重要的事情上。

**2. 開源能讓工具變更好**

我們的團隊很小，不可能覆蓋所有幣種、所有指標、所有使用場景。開源後，社區可以貢獻新的指標、修復 bug、提出改進建議。

**3. 建立信任**

我們未來會推出進階的分析和交易工具。先用免費的開源工具證明我們的技術能力和誠意，比用行銷話術更有說服力。

## 接下來

CoinSifter 是第一步。接下來我們計劃：

- **更多技術指標**：ATR、ADX、OBV 等
- **多交易所支援**：OKX、Bybit
- **回測整合**：篩選結果直接餵入回測框架，驗證策略有效性
- **社區策略庫**：讓使用者分享和評分篩選策略

如果你覺得這個工具有用，歡迎在 GitHub 上給個 Star。

---

*CoinSifter 是 [JudyAI Lab](https://judyailab.com) 的開源專案。MIT 授權，完全免費使用和修改。*

## 參考來源

- [加密貨幣篩選器：所有現有的加密貨幣](https://tw.tradingview.com/crypto-coins-screener/)
- [Crypto Sniper - 加密貨幣篩選器 | 幣安合約交易](https://crypto-sniper.minglin.vip/)

## 關鍵數據

- 2 倍成交量突破門檻
- 5 分鐘快速上手
- 5000 users (Threads + Newsletter 訂閱合計)

---

## 進一步閱讀

- [AI 量化交易入門：從零開始打造你的第一個智能交易系統](/posts/ai-quant-trading-beginners-guide/)
- [從交易想法到上線跑單：AI 輔助策略開發的真實流程](/posts/trading-concept-to-production-code-with-ai/)
