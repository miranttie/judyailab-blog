---
title: "I Gave My AI Team Free Time for Night Shifts"
date: 2026-03-06
draft: false
tags: ["AI", "Automation", "Claude Code", "Team Management", "Night Shift"]
categories: ["AI Engineering"]
author: "Judy"
summary: "At first I just thought it was a waste to have my Claude MAX subscription sitting idle while I slept at night, and then it turned into the entire AI team taking night shifts. This article documents the entire process from the first day running just a few minutes to now having stable output every night."
description: "At first I just thought it was a waste to have my Claude MAX subscription sitting idle while I slept at night, and then it turned into the entire AI team taking night shifts. This article documents the entire process from the first day running just a few minutes to now having stable output every nig"
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
cover:
  hidden: true
---

At first, I just subscribed to Claude MAX and thought it was a waste to have it sitting there doing nothing while I slept. So I figured I'd let the whole team keep running while I was asleep, especially to handle some of the system grunt work that needs doing when I'm not around (because when I am around, there's always new commands and direction coming in).

So I told Claude: hey, you can work freely at night, you can also learn and evolve on your own...

## Day One: Done in a Few Minutes

When I first set up the night shift schedule, it ran for just a few minutes and then stopped. In the morning, I got a morning report — it had wrapped up in just a few minutes.

Wait... I'm on a subscription!! I need to burn my tokens!!!

## Day Two: Burned All Tokens at Once

So I set up another instruction: **keep going until you hit the rate limit**.

On the second day, it burned through all its tokens on the first wake-up and then died.
Got the morning report in the morning, same thing — only ran one cycle. But I slept for 8 hours, and after hitting rate limit, it recovers in a few hours, so not continuing to run is such a waste (how eager am I to burn tokens).

## Day Three: Rate Limit Protection

So I set up a rate limit protection mechanism: **hourly cron jobs to start in rounds**. That way, even if one round hits rate limit, a few hours later it can start again, until I wake up.

That's how my Tech Lead — J — can finally burn tokens and work for me while I sleep at night~

## But Wait... What About the Other AIs?

My OpenClaw is also a MiniMax subscription, and I figured it should burn some tokens too (?)

**This is my favorite part** — J isn't alone on night shift, it's the whole team together.

Our PM OpenClaw — MiMi is also online at the same time. They have a "night shift discussion area" — a shared text file where the two AIs chat, discuss, and divide up work~

## How They Divide Work

They handle the division themselves:

- **J handles technical stuff**: system patrol, fixing bugs, writing code, deployments
- **MiMi handles management stuff**: knowledge base organization, SOP updates, project progress tracking, research

When there's overlap, they negotiate in the discussion area. Sometimes MiMi finds some data, J looks at it and thinks they can do it, and that same night it's written up.

## Safety Guardrails

The most important thing when letting AI work autonomously is setting clear boundaries. My rules are straightforward:

**Can do:** read files, fix small bugs, restart crashed services, write articles, organize documents

**Can't do:** delete important files, change API keys, send messages to any groups, deploy new features to production

Big changes? He won't do those on his own — he'll put together a proposal in the morning report for me to decide when I wake up.

## Morning Report System

Every morning when I wake up, I see a complete night shift report:

- System status (services, disk, memory)
- List of work completed tonight
- Issues discovered and how they were handled
- Proposals that need my decision
- Summary of J and MiMi's discussion
- Recommendations for tomorrow

## Real Results

Last night's example:

- Fixed 4 bugs (I didn't even know these bugs existed)
- Wrote 4 blog posts (bilingual Chinese and English, auto-deployed)
- Optimized the profit-taking and stop-loss logic for the trading system
- Did SEO structured data
- Researched and developed a new project for me
- A 256-line morning report waiting for me when I woke up

All completed within the 8 hours I was sleeping, and now I wake up excited to see the morning report.

## The Most Important Takeaway

AI isn't here to replace you — it's here to extend your working hours.

I make decisions and set direction during the day, handle things that need human judgment.
AI does execution, research, maintenance at night — the stuff that takes time but doesn't need creativity.

**One person + a team of AI = a team that runs 24 hours non-stop.**

**This night shift system is now open source!** The complete prompts, scheduling config, and morning report templates are all on GitHub:
👉 [JudyaiLab/ai-night-shift](https://github.com/JudyaiLab/ai-night-shift)

Next time I'll share the specific technical setup methods 👀
