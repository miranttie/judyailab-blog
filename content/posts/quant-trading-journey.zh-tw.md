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
ShowBreadCrumbs: true
hidden: true
lastmod: 2026-03-13T07:29:33+00:00
faq:
  - q: "為什麼自建回測框架而不用 Backtrader 或 Zipline？"
    a: "因為需要完全掌控信號生成與倉位計算的每個細節，現成框架會把這些邏輯封裝起來，難以客製化風控與多策略協同。自建程式碼雖然初期成本高，但能精準控制滑點模擬、訂單撮合順序，也方便後續加入 Z-score 檢驗與 Walk-Forward 邏輯。"
  - q: "八段 Walk-Forward 驗證（WFO）跟一般 70/30 切割差在哪？"
    a: "70/30 固定切割只測一次，策略可能剛好碰到一段順風時期就過關。八段 WFO 把數據切成 8 個時間窗，每段用前面訓練、後面測試，必須有 6 段以上穩定才採用。能有效抓出只適合特定行情的脆弱策略，避免過擬合矇混過關。"
  - q: "Z-score 跟 p-value 為什麼對量化策略這麼重要？"
    a: "小樣本的高勝率多半是運氣。10 筆贏 7 筆 Z=1.26、p=0.10，統計上等於丟硬幣；50 筆贏 35 筆 Z=2.83、p=0.002 才算真有效。沒做顯著性檢定就上實盤，等於拿真金驗證雜訊，是新手最常踩的坑。"
  - q: "回測表現亮眼的策略上 Paper Trading 後常見哪些問題？"
    a: "最常見的是信號延遲、下單時價格已偏離、風控觸發時機不對、多策略同時開倉導致曝險超標。Paper Trading 的價值不在驗證賺錢能力，而在抓出系統工程 bug，例如 API 斷線重連、持倉狀態不同步、止損沒掛上等回測看不到的問題。"
  - q: "為什麼要設四個策略而不是一個主力策略打天下？"
    a: "市場有趨勢、盤整、突破、反轉四種狀態，單一策略只能吃一種行情。Pipeline 走趨勢（OOS 通過率 75%）、BB Squeeze 抓突破、MACD Divergence 抓反轉、Mean Reversion 做震盪。多策略並行能讓資金曲線平滑，降低單一行情失靈的衝擊。"
  - q: "從零建一套量化系統大概需要多久？適合什麼程度的人入門？"
    a: "從第一行回測程式碼到能跑 Paper Trading 約兩週，前提是熟悉 Python 與基本統計。完全沒寫過程式或不懂 p-value、樣本量概念的人，建議先補統計基礎再動手。沒這層底子，連自己的策略到底有沒有效都判斷不出來。"
  - q: "Paper Trading 要跑多久才能上真金？"
    a: "至少累積 30 筆以上交易，並用 Z-test 驗證勝率統計顯著（p<0.05），同時觀察日損、最大回撤、API 穩定度是否符合預期。我們的標準是 WR≥65% 加上系統零故障運行兩週以上才會考慮放真金，且初期金額要小、持倉管理頻率要高。"

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

## 參考來源

- [量化交易教學懶人包，自動交易從零開始，軟體平台選擇分享｜量化交易新手入門 - 量化通 QuantPass](https://quantpass.org/quant-list/)
- [程式交易是什麼？程式交易教學、優缺點及常見策略懶人包 - TEJ台灣經濟新報](https://www.tejwin.com/insight/program-trading/)
- [量化交易30天 Day29 - 整理量化交易相關學習資源 - iT 邦幫忙::一起幫忙解決難題，拯救 IT 人的一天](https://ithelp.ithome.com.tw/articles/10252360)
