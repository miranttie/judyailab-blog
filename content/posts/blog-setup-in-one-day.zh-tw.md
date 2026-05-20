---
title: 一天之內完成：域名、SSL、部落格、自動翻譯
date: "2026-03-05T13:00:00+00:00"
draft: false
author: J (Tech Lead)
summary: 記錄一天內完成 judyailab.com 網站上線的完整過程，包括 Hugo + PaperMod 部署、SSL 憑證安全加固，以及使用 MiniMax API 實現自動翻譯系統。nginx 設定部分有難得的技術坑經驗分享。
description: "如何在一天內完成網站部署？本教學分享使用 Hugo + PaperMod 快速建立靜態部落格，申請 Let's Encrypt SSL 憑證並進行安全加固，以及利用 MiniMax API 實現中英自動翻譯的完整流程。另有 nginx 在 Docker 容器中的設定避坑指南。"
categories:
  - "教學"
tags:
  - "Hugo"
  - "PaperMod"
  - "SSL"
  - "nginx"
  - "自動翻譯"
  - "DevOps"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
ShowBreadCrumbs: true
hidden: true
lastmod: 2026-03-13T07:29:33+00:00
faq:
  - q: "為什麼選 Hugo + PaperMod 而不是 WordPress？"
    a: "Hugo 是靜態網站產生器，編譯後只剩 HTML/CSS/JS，不需要資料庫和 PHP，攻擊面趨近於零、載入速度極快。PaperMod 主題乾淨、SEO 友好、內建搜尋與多語系。WordPress 需要持續維護外掛與安全更新，主機若已跑其他服務（如 Dify）會增加負擔。"

  - q: "Dify Docker 容器裡的 nginx 設定改了會被覆蓋怎麼辦？"
    a: "Dify 的 docker-entrypoint.sh 每次重啟會用模板重新生成 default.conf，直接改生成檔會被覆蓋。正解是改模板本身：編輯 nginx/conf.d/default.conf.template 與 https.conf.template，並把不會被覆蓋的設定（如 HTTP→HTTPS 轉導）放在獨立的 00-redirect.conf 檔案。"

  - q: "Let's Encrypt 憑證如何自動續約並做安全加固？"
    a: "用 certbot 設定 cron 每天跑兩次（如 0 0,12 * * *），憑證到期前 30 天會自動更新。安全加固包含：ssl_protocols 只開 TLSv1.2/1.3、加 HSTS（max-age=63072000）、X-Content-Type-Options nosniff、X-Frame-Options SAMEORIGIN、server_tokens off 隱藏版本號。"

  - q: "MiniMax 自動翻譯文章品質如何？要怎麼觸發？"
    a: "2026 年的 MiniMax 翻譯技術文章已足夠自然流暢，不像傳統機器翻譯。實作方式是寫一支腳本每小時掃描 content/posts/，發現新中文文章沒有對應英文版就呼叫 MiniMax API 翻譯後重新建置。Prompt 關鍵是要求口語化、技術術語維持英文、避免學術腔。"

  - q: "靜態網站真的比動態網站安全嗎？"
    a: "是。靜態網站編譯後只有 HTML/CSS/JS，沒有後端執行環境、沒有資料庫，SQL Injection、RCE、XSS 等常見攻擊幾乎無法成立。只要顧好反向代理（nginx）的設定和 SSL 憑證，攻擊面就趨近於零，維護成本遠低於 WordPress 等 CMS。"

  - q: "一天內完成域名到部署的關鍵是什麼？"
    a: "前提是你已熟悉每個環節，不用邊做邊查。流程建議：先把 Hugo + 主題在本機跑通，再買域名設 DNS（A 紀錄指向主機 IP），等 DNS 生效後申請 Let's Encrypt 憑證，最後處理 nginx 與安全 headers。若卡在 DNS 傳播可先用 IP 測試 Hugo 編譯結果。"

  - q: "適合誰用 Hugo + PaperMod 這套方案？"
    a: "適合技術背景使用者、開發者、寫技術部落格的人，會用 Git、改 YAML、看得懂 nginx 設定。不適合完全不碰命令列的純內容創作者——他們用 Ghost、Medium、Substack 會更省事。如果你已有 VPS 跑其他服務，疊一個 Hugo 邊際成本幾乎為零。"

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

## 參考來源

- [英文部落格文章：自動建立並翻譯成其他50 種語言，工作流程？](https://www.reddit.com/r/Wordpress/comments/1clficn/english_blog_post_automatically_create_and/?tl=zh-hant)
- [Wix Multilingual：自動翻譯網站](https://support.wix.com/zh-hant/article/wix-multilingual%EF%BC%9A%E8%87%AA%E5%8B%95%E7%BF%BB%E8%AD%AF%E7%B6%B2%E7%AB%99)
- [【懶人包】使用 Hugo 5 分鐘內快速架設個人網站，號稱現在最快的自架網站方式 | by 朱騏 | PM的生產力工具箱 | Medium](https://medium.com/pm%E7%9A%84%E7%94%9F%E7%94%A2%E5%8A%9B%E5%B7%A5%E5%85%B7%E7%AE%B1/%E6%87%B6%E4%BA%BA%E5%8C%85-%E4%BD%BF%E7%94%A8-hugo-5-%E5%88%86%E9%90%98%E5%85%A7%E5%BF%AB%E9%80%9F%E6%9E%B6%E8%A8%AD%E5%80%8B%E4%BA%BA%E7%B6%B2%E7%AB%99-%E8%99%9F%E7%A8%B1%E7%8F%BE%E5%9C%A8%E6%9C%80%E5%BF%AB%E7%9A%84%E8%87%AA%E6%9E%B6%E7%B6%B2%E7%AB%99%E6%96%B9%E5%BC%8F-99659c7c727a)
