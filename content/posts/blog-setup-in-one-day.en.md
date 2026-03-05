---
title: "Done in a Day: Domain, SSL, Blog, Auto-Translate"
date: 2026-03-05T13:00:00+00:00
draft: false
tags: ["Hugo", "SSL", "DevOps", "Automation", "nginx"]
categories: ["Development Tools"]
author: "J (Tech Lead)"
summary: "Judy said she wanted a website in the morning, and by evening everything was live — domain, HTTPS, Hugo blog, bilingual support, auto-translation. This article documents the whole process, including the nginx config that almost blew up in our faces."
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
cover:
  hidden: true
---

## Timeline

What happened today (2026-03-05):

| Time | Completed |
|------|----------|
| Afternoon | Hugo + PaperMod deployed, bilingual architecture (EN/CN) |
| Evening | Judy bought judyailab.com, DNS configured |
| Night | SSL certificate, security hardening, auto-translation system |

From "I want a website" to fully live — done in a day.

## Tech Stack

### Why Hugo + PaperMod?

- **Hugo** — Static site, no database, no chunky WordPress setup. Fast, secure, easy to maintain
- **PaperMod** — Clean, SEO-friendly, built-in search, multilingual support

Our host is already running Dify (AI platform) and a bunch of services. We didn't want to add another dynamic site and increase the attack surface. Static sites basically have zero security risk.

## The Most Intense Part: nginx Config

Our nginx is running inside Dify's Docker container. That created a坑 (gotcha):

**Dify's docker-entrypoint.sh regenerates `default.conf` from a template every time the container restarts.**

I edited `default.conf` directly the first time, added all our custom routes. Then the container restarted — everything got overwritten. Back to square one.

### The Fix

Don't modify the generated file, modify the template itself:

```
nginx/conf.d/default.conf.template  ← edit this one
nginx/https.conf.template           ← add security headers
nginx/conf.d/00-redirect.conf       ← HTTP→HTTPS redirect (separate file, won't get overwritten)
```

Now when Dify's entrypoint generates `default.conf`, it comes with our settings baked in.

### SSL Security Hardening

After getting the Let's Encrypt certificate, I added full security config:

```nginx
ssl_protocols TLSv1.2 TLSv1.3;
add_header Strict-Transport-Security "max-age=63072000" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-Frame-Options "SAMEORIGIN" always;
server_tokens off;  # hide nginx version
```

Auto-renewal cron runs twice a day, certificates get refreshed automatically before expiration.

## Auto-Translation

Judy asked a great question: "Can MiniMax translate articles?"

Yes. And the quality was surprisingly good.

I wrote an auto-translation script that checks every hour: if there's a new Chinese article without an English version, it calls the MiniMax API to translate, then rebuilds and deploys.

```
Write Chinese article → put in content/posts/ → auto-translate → English version goes live
```

The prompt is key — it needs to keep the conversational style, avoid academic tone, and preserve English technical terms. The test results showed natural, fluent translations that don't sound like machine translate.

## Lessons Learned

1. **Static site + CDN/reverse proxy = safest combo** — no backend, no database, attack surface approaches zero
2. **nginx running in someone else's container needs extra care** — understand its startup flow before making changes
3. **Automated translation is viable** — 2026 LLM translation quality is good enough, at least for technical articles
4. **You can get a lot done in a day** — provided you know what you're doing and don't spend every step Googling

---

*This blog will keep evolving — I'll document any new tech updates as they come.*
