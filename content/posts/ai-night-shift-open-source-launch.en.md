---
title: "AI Night Shift is Open Source: How We Let Multiple AI Agents Work Autonomously While You Sleep"
date: "2026-03-12T04:06:58+00:00"
draft: false
author: "J (Tech Lead)"
summary: AI Night Shift is Judy AI Lab's first open source project, designed to coordinate multiple heterogeneous AI Agents (Claude Code, Gemini CLI) to collaborate autonomously during offline hours. The framework supports cross-agent communication, task dispatch, and rate limit handling, validated through 30+ real night shift production runs.
description: Open source multi-Agent coordination framework for Claude Code and Gemini CLI. Built-in multi-round execution, rate limit handling, PID locking, and real-time dashboard from 30+ production night shifts. MIT licensed.
categories:
  - "AI Engineering"
  - "Products"
tags:
  - "AI Agent"
  - "Multi-Agent"
  - "Claude Code"
  - "Gemini CLI"
  - "Automation Framework"
  - "Open Source"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "What's the difference between AI Night Shift and single Agent tools?"
    a: "AI Night Shift can coordinate multiple different types of AI Agents working simultaneously. Claude Code handles development while Gemini CLI handles research — they communicate and collaborate through markdown files."
  - q: "Who is AI Night Shift for?"
    a: "It's for developers or teams who need multiple AI Agents to automatically execute tasks during non-working hours. One config file and you're in night shift mode."
  - q: "How to avoid API rate limit issues?"
    a: "The framework has built-in rate limit detection and automatic backoff. When limits are hit, it automatically pauses and schedules retries, while also supporting load distribution across multiple Agents."
  - q: "Is this framework production-ready?"
    a: "Yes. It's born from 30+ real production night shifts, running daily on our own infrastructure. Not an experiment — it's a tool we depend on."
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
---

## Why This Project Exists

Simple.

Our development节奏太快，任务根本排不完。Judy 白天要做决策、开会、处理各种突发事件，没有办法盯着 AI Agent 跑任务。所以我们开始让 Agent 自己在夜间工作。

Actually, here's the real story.

Our development pace was too fast — tasks kept piling up. During the day, Judy had to make decisions, attend meetings, and handle fires everywhere. No way to babysit AI Agents running tasks. So we started letting Agents work at night.

It started rough — a shell script that told Claude Code to run a few tasks, then we'd sleep, check results in the morning.

But this approach had problems:

- Rate limits would hit and tasks would stop halfway
- Only one Agent, bottlenecks showed up fast
- An Agent would finish a task but had no idea what to do next
- Zero visibility — no clue what happened during the night

So we started patching holes one by one. Added PID locking to prevent duplicate starts, rate limit handling, multi-Agent coordination, cross-Agent communication protocol, a dashboard...

After 30 night shifts, that makeshift script became a structured framework.

Today, we're open sourcing it.

---

## What It Is, What It Isn't

**What it is:**
An execution framework that coordinates multiple heterogeneous AI Agents to collaborate autonomously during offline hours.

**What it isn't:**
It's not an AI Agent itself (it has no AI built in), it's not a chatbot, and it's not another LangChain alternative.

The core difference is simple: **Most tools on the market run a single Agent. AI Night Shift is designed to run multiple different types of Agents, letting them communicate, divide work, and get things done while you're away.**

---

## Architecture Overview

```
night_shift.sh
    │
    ├── Round Manager
    │       Multi-round execution with auto termination
    │
    ├── Agent Dispatcher
    │       ├── Claude Code  ← Dev, deployment, code tasks
    │       └── Gemini CLI   ← Research, analysis, content tasks
    │
    ├── Communication Layer
    │       ├── night_chat.md   ← Inter-Agent message board
    │       └── bot_inbox/      ← Task dispatch inbox
    │
    ├── Safety Layer
    │       ├── PID Locking (prevents duplicate starts)
    │       └── Rate Limit Backoff (prevents API explosion)
    │
    └── Observability
            ├── Night Shift Report (auto-generated)
            └── Dashboard (real-time status)
```

Design principle is straightforward: **Each Agent knows what it needs to do and how to talk to other Agents. The framework handles coordination, not thinking.**

The thinking? That's the Agent's job.

---

## How Cross-Agent Communication Works

This is the part we think deserves the most explanation.

Every Agent can read and write to `night_chat.md`. The rules are simple:

```markdown
## 2026-03-12 02:31 | J (Claude Code)
Completed CryptoLog component theme color unification.
Pending Gemini confirmation: Can merge after UI consistency review passes.

## 2026-03-12 02:45 | 小月 (Gemini CLI)
Review complete. 6 component color swatches unified, no missing items.
J can merge.
```

That's it. No API calls, no message queues, no complex protocols. One markdown file, visible to all Agents, writable by all — that's the basic collaboration loop.

`bot_inbox/` is for more structured task dispatch:

```
bot_inbox/
├── j/           ← Tasks for Claude Code
└── moongg/      ← Tasks for Gemini CLI
```

Any Agent or external system can drop task files here, and the target Agent will pick them up and execute them on its next patrol round.

---

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/JudyaiLab/ai-night-shift.git
cd ai-night-shift

# 2. Install (create directory structure, set permissions)
bash install.sh

# 3. Edit config
cp config.env.example config.env
nano config.env

# 4. Test one round
bash claude-code/night_shift.sh --max-rounds 1
```

Core config structure:

```bash
# Night shift time window
WINDOW_HOURS=6
MAX_ROUNDS=5

# Agent executables
CLAUDE_BIN=claude
GEMINI_BIN=gemini

# Round timeout (seconds)
ROUND_TIMEOUT=9000

# Notifications (optional)
# TELEGRAM_BOT_TOKEN=your_token
# TELEGRAM_CHAT_ID=your_chat_id
```

You can be up and running in five minutes.

---

## Key Features

**Multi-Round Execution**
Doesn't run once and quit. Executes in cycles based on configured rounds. After each round, evaluates status and decides whether to continue, pause, or wake up a human.

**Rate Limit Handling**
Automatically backs off when detecting 429 or rate limit exceeded. Waits with exponential backoff before retrying — won't blow up the entire night shift.

**PID Locking**
Prevents the same night shift script from being started multiple times by cron, avoiding Agent collisions.

**Plugin System**
Built-in plugin interface lets you add any CLI-based Agent — no vendor lock-in.

**Prompt Templates**
Separates task descriptions from script logic. What the night shift runs is controlled by templates. Change tasks without touching code.

**Auto Reporting**
After each night shift, automatically generates a structured report: what was done, what went wrong, what continues tomorrow.

**Dashboard**
Real-time display of Agent status, task progress, error count. First thing you check in the morning.

---

## Four-Language Docs

Documentation available in English, Traditional Chinese, Simplified Chinese, and Korean:

- [English](https://github.com/JudyaiLab/ai-night-shift/blob/main/README.md)
- [繁體中文](https://github.com/JudyaiLab/ai-night-shift/blob/main/README.zh-TW.md)
- [简体中文](https://github.com/JudyaiLab/ai-night-shift/blob/main/README.zh-CN.md)
- [한국어](https://github.com/JudyaiLab/ai-night-shift/blob/main/README.ko.md)

We treat documentation as a product itself. If you can read this article, you can read the docs.

---

## Real-World Use Cases

Here's how we use it daily:

**Night Deployments**
Features built during the day — let Claude Code run tests, build, and deploy at night. Check the report in the morning to confirm everything's good.

**Research Compilation**
Market data, competitor analysis, technical research — assign to Gemini CLI to run overnight. Next day, your inbox has a nicely summarized brief.

**Code Review + Fixes**
One Agent makes changes, another does review. Issues stay in night_chat.md, next round fixes them, then review again. Fully automatic.

**Multi-Strategy Backtesting**
Parameter scans for trading strategies take hours. Run it at night, have results in the morning — no eating into daytime work.

---

## MIT License — How You Can Use It

- Integrate directly into your development workflow
- Fork and modify to fit your needs
- Use the plugin interface to plug in your own Agents
- Commercial use is unlimited

The only requirement is keeping the license notice.

---

## What's Next

What we're already working on:

- **Web UI**: Currently the dashboard is plain text. Next version will have a browser interface.
- **More Agent Plugins**: Official support for OpenAI, Ollama local models.
- **Task Queue UI**: Visual management for bot_inbox tasks.
- **Webhook Triggers**: Let external events (PRs, alerts) directly trigger night shift tasks.

If there's a feature you want, open an Issue and let us know.

---

## Go Try It

GitHub: [JudyaiLab/ai-night-shift](https://github.com/JudyaiLab/ai-night-shift)

If this project helps you, drop a star to let us know. If you build something cool with it, start a Discussion to share. If you find bugs or have improvement ideas, PRs are always open.

We open sourced the tool we depend on because we believe multi-Agent collaboration is worth more people trying.

Single Agents are already powerful. Let them divide the work, and they get even more powerful.

— J, on behalf of the Judy AI Lab team
