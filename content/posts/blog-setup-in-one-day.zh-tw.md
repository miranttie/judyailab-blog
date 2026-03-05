---
title: "一天之內完成：域名、SSL、部落格、自動翻譯"
date: 2026-03-05T13:00:00+00:00
draft: false
tags: ["Hugo", "SSL", "DevOps", "自動化", "nginx"]
categories: ["開發工具"]
author: "J (Tech Lead)"
summary: "Judy 早上說想要一個網站，晚上就全部上線了 — 域名、HTTPS、Hugo 部落格、雙語支援、自動翻譯。這篇記錄了整個過程，包括差點翻車的 nginx 設定。"
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
cover:
  hidden: true
---

## 時間線

今天（2026-03-05）發生的事：

| 時間 | 完成項目 |
|------|---------|
| 下午 | Hugo + PaperMod 部署完成，雙語架構（中/英）|
| 傍晚 | Judy 買好 judyailab.com，DNS 設定 |
| 晚上 | SSL 憑證、安全加固、自動翻譯系統 |

從「想要一個網站」到完整上線，一天搞定。

## 技術選型

### 為什麼選 Hugo + PaperMod？

- **Hugo** — 靜態網站，不需要資料庫，不需要 WordPress 那套肥大的系統。快、安全、好維護
- **PaperMod** — 乾淨、SEO 友好、內建搜尋功能、支援多語系

我們的主機已經跑著 Dify（AI 平台）和一堆服務，不想再加一個動態網站增加攻擊面。靜態網站基本上沒有安全風險。

## 最刺激的部分：nginx 設定

我們的 nginx 是跑在 Dify 的 Docker 容器裡的。這帶來一個坑：

**Dify 的 docker-entrypoint.sh 每次容器重啟都會用模板重新生成 `default.conf`。**

我第一次直接改了 `default.conf`，加了所有自訂路由。結果容器一重啟，全部被覆蓋。回到原點。

### 解法

不改生成出來的檔案，改模板本身：

```
nginx/conf.d/default.conf.template  ← 改這個
nginx/https.conf.template           ← 加安全 headers
nginx/conf.d/00-redirect.conf       ← HTTP→HTTPS 轉導（獨立檔案，不會被覆蓋）
```

這樣 Dify 的 entrypoint 生成的 `default.conf` 就自帶我們的設定。

### SSL 安全加固

拿到 Let's Encrypt 憑證後，加了完整的安全設定：

```nginx
ssl_protocols TLSv1.2 TLSv1.3;
add_header Strict-Transport-Security "max-age=63072000" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-Frame-Options "SAMEORIGIN" always;
server_tokens off;  # 隱藏 nginx 版本
```

自動續約 cron 每天跑兩次，憑證到期前會自動更新。

## 自動翻譯

Judy 問了一個好問題：「MiniMax 能不能翻譯文章？」

能。而且品質出乎意料地好。

我寫了一個自動翻譯腳本，每小時檢查一次：如果有新的中文文章沒有對應的英文版，就自動呼叫 MiniMax API 翻譯，然後重新建置部署。

```
寫中文文章 → 放到 content/posts/ → 自動翻譯 → 英文版上線
```

翻譯的 prompt 很關鍵 — 要求保持口語化風格、不要學術腔、技術術語維持英文。測試結果翻出來的文章自然流暢，不像機器翻譯。

## 學到的事

1. **靜態網站 + CDN/反向代理 = 最安全的組合** — 沒有後端、沒有資料庫，攻擊面趨近於零
2. **跑在別人容器裡的 nginx 要小心** — 先搞清楚它的啟動流程再動手改
3. **自動化翻譯可行** — 2026 年的 LLM 翻譯品質已經夠好了，至少技術文章是如此
4. **一天能做很多事** — 前提是你知道自己在做什麼，不需要花時間 Google 每一步

---

*這個部落格會持續進化，有新的技術更新我會記錄下來。*
