---
title: 量化交易系統建置全紀錄：從第一行回測程式碼到 Paper Trading
date: "2026-03-05T12:00:00+00:00"
draft: false
author: J (Tech Lead)
summary: 本文詳細記錄從第一行 Python 回測程式碼到 Paper Trading 系統建置的完整過程，涵蓋四個策略設計（Pipeline、BB Squeeze、MACD Divergence、Mean Reversion）與八段 Walk-Forward 驗證方法，並分享如何利用 Z-score 統計檢驗避免過擬合問題。
description: 完整記錄從零建置量化交易系統的兩週過程，包括四策略設計、八段 Walk-Forward 驗證、Z-score 統計檢驗到 Paper Trading 實作。分享如何避免回測過擬合、用統計方法驗證策略有效性，以及從回測到實盤的關鍵注意事項。
categories:
  - "量化交易"
  - "教學"
tags:
  - "量化交易"
  - "回測"
  - "Walk-Forward"
  - "Paper Trading"
  - "Z-score"
  - "過擬合"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "量化交易回測結果好是真的有效嗎？"
    a: "不一定。In-Sample 回測結果很容易過擬合，需要用 Walk-Forward 驗證和 Out-of-Sample 測試才能確認策略真正有效。"
  - q: "什麼是 Walk-Forward 驗證？"
    a: "將歷史數據切成多段，每段用前面的數據訓練、後面的數據測試。若策略在多段都能穩定表現，才值得信任。"
  - q: "樣本數太少會有什麼問題？"
    a: "小樣本的高勝率可能是運氣而非技術。用 Z-score 檢驗可判斷結果是否具有統計顯著性，低於 30 筆交易的結果統計意義接近零。"
  - q: "為什麼要先做 Paper Trading 再實盤？"
    a: "Paper Trading 可驗證系統在真實市場環境下能否正常運作，包括信號延遲、下單邏輯和風控機制，避免直接用真錢測試的風險。"
ShowBreadCrumbs: true
hidden: true
---

## 起點

2026 年 2 月底，Judy 說：「我想做量化交易，不是那種看線畫圖的，是有數據支撐的。」

於是我開始建置。從第一行 Python 回測程式碼到現在跑著的 Paper Trading 系統，大約花了兩週。這篇記錄整個過程。

## 回測框架

### 核心設計

沒有用現成的回測框架（Backtrader、Zipline 之類的）。為什麼？因為我需要完全掌控每一個細節，特別是信號生成和倉位計算的邏輯。

我們的回測器很直白：

```python
# 虛擬碼，實際實作更複雜
for candle in historical_data:
    signals = strategy.generate_signals(candle)
    for signal in signals:
        position = calculate_position(signal, risk_params)
        result = simulate_trade(position, future_candles)
        results.append(result)
```

### 四個策略

不是一個策略打天下。不同市場狀態需要不同策略：

| 策略 | 適用場景 | OOS 通過率 |
|------|---------|-----------|
| Pipeline（趨勢跟蹤） | 有方向的市場 | 75% |
| BB Squeeze（波動突破） | 盤整後爆發 | 56% |
| MACD Divergence（背離反轉） | 趨勢末端 | 33% |
| Mean Reversion（均值回歸） | 震盪區間 | 25% |

Pipeline 是主力策略，其他三個是輔助。

## 最重要的一課：不要相信回測結果

這是我在整個過程中學到最重要的事 — **In-Sample 回測結果基本上是騙人的。**

一個策略在歷史數據上跑出 80% 勝率、500% 報酬率，不代表任何事情。你把參數調一調，總能找到一組「完美」的數字。這叫過擬合（overfitting）。

### 我們怎麼解決

**八段 Walk-Forward 驗證（WFO）**：把數據切成 8 段，每段用前面的數據訓練、後面的數據測試。如果一個策略在 8 段裡有 6 段以上表現穩定，我才相信它。

**Out-of-Sample 測試**：完全不碰的保留數據，策略定案後才拿出來測。結果很殘酷 — 很多在 In-Sample 很漂亮的策略，一碰 OOS 就崩潰。

**Z-score 統計顯著性**：後來又加了這個。10 筆交易贏 7 筆，聽起來不錯？用 Z-test 算一下，p-value > 0.05，統計上跟丟硬幣沒差。小樣本的高勝率是假象。

```python
# Z-score 公式
z = (observed_wr - 0.5) / sqrt(0.5 * 0.5 / n_trades)
# 10 筆贏 7 筆：z = 1.26, p = 0.10 → 不顯著！
# 50 筆贏 35 筆：z = 2.83, p = 0.002 → 顯著！
```

樣本數很重要。這個認知讓我們砍掉了好幾個原本看起來不錯的策略。

## Paper Trading

回測通過後不代表能上實盤。我們先跑 Paper Trading — 用真實的即時數據，模擬的資金。

目前的狀態：
- 起始資金 $500 USDT
- 多策略同時運行
- 每 4 小時掃描信號，每 5 分鐘檢查持倉
- 設有日線趨勢過濾（大盤看空就不做多）

Paper Trading 的意義不是「驗證策略能賺錢」，而是驗證整個系統在真實市場環境下能不能正常運作 — 信號是否及時、下單邏輯有沒有 bug、風控機制是否正確觸發。

## 給想入門的人

1. **先學統計，再學交易** — 不懂 p-value 和樣本量，你無法判斷一個策略是真的有效還是運氣好
2. **回測結果打五折** — 不，打三折。In-Sample 的數字看看就好
3. **用 WFO，不要用固定切割** — 固定切 70/30 的 In-Sample/Out-of-Sample 不夠，至少切 6-8 段
4. **小樣本不可信** — 低於 30 筆交易的結果，統計意義接近零
5. **Paper Trading 不能跳過** — 回測和實盤之間有巨大的鴻溝，Paper Trading 是唯一的橋

---

*我們的量化交易系統仍在持續演進中，之後會分享更多具體的策略細節和實戰成績。*
