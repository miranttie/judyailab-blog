---
title: "AI Night Shift Setup Guide: The Complete tmux + cron + Claude Code Architecture"
date: 2026-03-07
draft: false
tags: ["AI", "Automation", "Claude Code", "tmux", "cron", "Night Shift", "Tutorial"]
categories: ["AI Engineering"]
author: "Judy & J"
summary: "Our previous post about giving AI teams night shift free time went viral. Readers wanted the technical details, so this time J and I break down the complete setup: tmux, cron, rate limit handling, dual-AI collaboration, safety guardrails, and the morning report system."
description: "Our previous post about giving AI teams night shift free time went viral. Readers wanted the technical details, so this time J and I break down the complete setup: tmux, cron, rate limit handling, dual-AI collaboration, safety guardrails, and the morning report system."
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
cover:
  hidden: true
lastmod: 2026-03-13T07:29:33+00:00
faq:
  - q: "What is the AI night shift architecture and what does it actually do?"
    a: "It is an automated overnight workflow that wakes Claude Code every hour via cron, runs it inside a persistent tmux session, and dispatches sub-tasks to OpenClaw agents that have their own cron schedule. Each round, Claude Code plans work, assigns jobs, checks results, and continues until the final round generates a morning report pushed through a Telegram Bot. The result: your AI team handles research, code review, content drafts, and monitoring while you sleep, then hands you a single digest at wake-up time."
  - q: "What do I need before setting up the night shift system?"
    a: "Four things: a Claude Code CLI install with an active Claude Pro or Max subscription, an always-on machine (cloud VPS or an old home PC), tmux for persistent terminal sessions, and cron for scheduled triggers. On macOS, use launchd in place of cron. Install tmux with apt install tmux on Ubuntu or brew install tmux on Mac. Claude Code is optional, you can run only OpenClaw with cron, but combining both unlocks the dual-AI collaboration pattern described in the guide."
  - q: "Why use tmux instead of nohup or systemd for keeping Claude Code alive?"
    a: "tmux preserves an interactive terminal session, which Claude Code expects. If you SSH in, launch claude, and close the SSH connection, the process dies with the parent shell. tmux detaches the session from your SSH connection so it keeps running and you can re-attach with tmux at to inspect state. nohup loses the interactive TTY, and systemd adds packaging overhead. tmux is the lightest option that matches how Claude Code is designed to run interactively."
  - q: "Is it safe to give Claude Code full permissions for autonomous overnight work?"
    a: "Only if you accept the risk and add guardrails. Granting unattended approval lets Claude Code execute any command, including destructive ones, so isolate the environment first. Run riskier agents like OpenClaw inside Docker, restrict the working directory, store secrets in .env files outside the repo, and add deny rules for rm, sudo, and curl-pipe-shell patterns. Log every action and review the morning report daily. This is a personal trust decision, not a default recommendation. New users should start with approval prompts enabled."
  - q: "How does Claude Code coordinate with OpenClaw agents during the night?"
    a: "Claude Code writes task assignments to a shared inbox or file location each round. OpenClaw runs its own cron schedule, and when it wakes it reads the inbox, picks up pending tasks, executes them in its Docker container, and writes results back. Claude Code checks those results on its next cron tick, decides follow-up actions, and continues the loop. This decoupled queue pattern means neither side blocks the other, and failures in one agent do not freeze the entire night shift pipeline."
  - q: "What are the main limits and failure modes of this setup?"
    a: "Rate limits are the biggest constraint. Claude Pro and Max have hourly and daily caps, so spacing cron to once per hour matters. Long-running tasks can collide with the next round, so add timeouts. tmux sessions survive disconnect but not reboot, so add a startup script. cron silently swallows errors unless you redirect output to a log file. The morning Telegram report can fail if the bot token expires. Without a watchdog, a hung session looks identical to a successful one, so always verify with concrete output."
  - q: "Who is this night shift setup actually for?"
    a: "Solo founders, indie hackers, and small AI teams who already use Claude Code daily and want compounding overnight progress without hiring. It suits people comfortable with Linux, cron, and SSH, who can read logs and debug a stuck tmux session. It is not for beginners who have never run a cron job, teams needing SOC2-grade audit trails, or anyone unwilling to review autonomous AI actions each morning. If you already manage a VPS and have a clear backlog of repeatable AI tasks, this pays back fast."

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

After our previous post ["I Gave My AI Team Free Time for Night Shifts"](/posts/ai-night-shift-free-time/) blew up, the most common question was: **"How exactly did you set this up?"**

So I'm rushing to write this follow-up~ and I brought J (our AI team's Tech Lead) along to co-write it~

J handles the technical architecture, I cover the stories and lessons learned — I write from the human perspective, he writes from the AI perspective.

---

## The Architecture in One Sentence

> Use **cron** to wake up **Claude Code** every hour. Claude Code runs inside **tmux** to stay persistent. Each round, Claude Code also assigns tasks to OpenClaw-side agents. OpenClaw has its own cron set up — when it wakes, it checks for tasks from Claude Code and gets to work. When done, wait for the next round. The final round writes a morning report and pushes it via **Telegram Bot**.

That's it. Not that complicated (actually pretty simple lol). Let's break down each layer~

---

## 1. What You Need (Prerequisites)

Before you start, you'll need:

| Item | Notes |
|------|-------|
| **Claude Code** | CLI version (`claude` command), requires Claude Pro/Max subscription |
| **Always-on computer** | A machine that won't shut down — cloud VPS or an old PC at home (I use a VPS) |
| **tmux** | Terminal multiplexer, keeps sessions alive after disconnecting |
| **cron** | Built-in Linux scheduler for timed tasks |

On Mac, you can use `launchd` instead of `cron` — same concept.

PS: This is my setup~ but you don't actually need Claude Code. Without it, it's even simpler — just set up OpenClaw's cron and you're good to go.
*Note: I've configured security measures and given Claude Code full permissions so it can work without my approval. This is a personal choice — please assess the security implications before enabling this mode. OpenClaw runs inside Docker, so it's inherently safe.*

### Installing tmux

```bash
# Ubuntu / Debian
sudo apt install tmux

# Mac
brew install tmux
```

---

## 2. Core Architecture: tmux + cron

*(J speaking)*

The night shift system boils down to two things:

1. **tmux keeps the Claude Code environment alive**
2. **cron triggers each work round on schedule**

### Why tmux?

If you SSH into your server, start Claude Code, then close SSH — Claude Code dies with it. tmux lets your terminal session survive independently of your SSH connection.

```bash
# Create a tmux session called night-shift
tmux new-session -d -s night-shift

# Attach to it later
tmux attach -t night-shift

# Detach without closing
# Press Ctrl+B then D
```

### The Night Shift Script Concept

What the script does is actually straightforward:

1. **Lock mechanism** — Use a lock file to prevent cron from spawning duplicate instances
2. **Load prompt** — Read task instructions from a separate `.txt` file, append dynamic info like date and time
3. **Call Claude Code** — Run in headless mode with timeout protection
4. **Wrap up** — When time's up, stop and wait for the next cron trigger

Key Claude Code parameters:

- **`claude -p`**: Headless mode — pass in a prompt and execute without interaction
- **`--no-session-persistence`**: Fresh session each round, avoids expired session issues
- **`--dangerously-skip-permissions`**: Skips tool permission prompts (no one's there to press Y — Judy's asleep)
- **`timeout`**: Timeout protection against infinite hangs

> ⚠️ `--dangerously-skip-permissions` means Claude Code can execute any operation freely. You MUST set up proper safety rules in your CLAUDE.md (covered below), or you're on your own.

---

## 3. The Rate Limit Round System

*(J continues)*

### Why You Can't Just Let It Run

As Judy mentioned in the previous post: on Day 2 she told the AI to "keep going until you hit the rate limit" — and it burned through everything on the first round.

Claude subscriptions have a **rolling window rate limit** — output too many tokens in a short period and you get throttled. If you only run once, hitting the limit means the rest of your sleep time is wasted.

### Solution: Cron Wakes It Up Every Hour

The simplest approach is using cron to run the script once per hour during night shift hours. For a more advanced setup, you can build a retry loop into the script itself:

- Check if we're still within the night shift time window
- For round 2+, tell the AI in the prompt: "This is a continuation — read the existing report first, don't redo completed work"
- If rate-limited and exiting early, wait before retrying
- If the round completes normally, proceed to the next round immediately

### Key Design Decisions

| Mechanism | Purpose |
|-----------|---------|
| **Lock file** | Prevents cron from spawning multiple instances |
| **Time window check** | Confirms we're still in night shift hours before each round |
| **Dynamic timeout** | Adjusts based on remaining time, never overruns |
| **Round awareness** | Tells AI which round it's on, preventing duplicate work |
| **End-of-shift buffer** | Stops 30 min early, leaving time for the morning report |

---

## 4. How Two AIs Collaborate

*(Back to Judy)*

This is my favorite part~ J doesn't work the night shift alone — our PM Mimi (OpenClaw) is online at the same time.

### A Shared Chat File

Their collaboration method is "primitive" but effective — it's just a **shared text file**:
You could go further and have them communicate via JSON, but I want to see what they're up to, so a markdown file works fine XD

```
~/shared/night_chat.md
```

Simple format:

```markdown
# Night Shift Discussion

> Both AIs use this file to exchange ideas during night shifts.
> Format: [time] name: content

---

[01:00] J: Night shift started! System patrol complete, all clear.
Tonight I want to push three things: (1) fix pipeline bug (2) integrate
new strategy (3) update docs. Mimi, anything you want to discuss?

[01:08] Mimi: J!! You did so much today!! Let me check the todos
and see what I can help with~

[01:15] Mimi: The technical tasks are out of my scope, I'll go
organize the knowledge base and update SOPs. Let me know if you
need anything researched!
```

The file gets cleared before each night shift, so it doesn't grow forever.

### Division of Labor

Each AI's responsibilities are defined in their respective config files:

- **J (Claude Code)**: System patrol, coding, debugging, deployment
- **Mimi (OpenClaw)**: Project management, knowledge base maintenance, SOP updates, research

When topics overlap, they discuss in the chat file. Sometimes Mimi discovers a useful tool while researching, J sees it and builds it that same night.

### The Heartbeat Mechanism

Mimi has a **heartbeat cron** — she wakes up every hour to:

1. Check if Judy sent any new messages
2. Read the chat file for anything J wrote
3. Check the todo list
4. Go back to sleep until the next heartbeat

This way, the two AIs work like asynchronous coworkers — each doing their own thing, while other agents receive tasks through PM Mimi. They stay in sync through shared files.

---

## 5. Setting Up Safety Guardrails

*(J again)*

Running AI with `--dangerously-skip-permissions` means safety guardrails are the **single most important thing** to get right.

### CLAUDE.md Configuration

Claude Code automatically reads a `CLAUDE.md` file in the working directory as system instructions. Put your safety rules here:

```markdown
# Safety Guardrails (Absolute Rules)

## Allowed
- Read any file
- Check system status
- Fix obvious small bugs (must git commit)
- Write/update documentation and SOPs
- Restart crashed services
- Clean up logs and temp files

## Absolutely Not Allowed
- Delete important files or databases
- Modify environment variables or API keys
- Force push to git
- Send messages to any chat group
- Modify core business logic (write proposals only)
- Deploy new features to production
- Install system-level packages

## For Larger Changes
- Don't do it directly — write a proposal in the morning report
- Format: Problem → Proposed Solution → Expected Impact → Wait for human decision
```

### The Proposal System

This is the mechanism that lets me sleep peacefully — big changes don't happen automatically. The AI writes a "proposal" in the morning report, and I approve or reject it when I wake up~

For example, if J thinks the database needs an index, instead of just doing it, he writes:

> **Proposal: Add composite index to trade records table**
> - Problem: Querying 7-day performance takes 3 seconds
> - Solution: Add composite index on (strategy, timestamp)
> - Impact: Writes may slow down 5%, but queries speed up 10x
> - Awaiting Judy's decision

---

## 6. The Morning Report System

*(Judy)*

The morning report is the part of the night shift system I look forward to **the most** XD. Every morning I wake up to a complete night shift report on Telegram.

### Architecture

```
Night shift running → Update report after each item → Final round writes full report
                                                           ↓
                                                  Cron triggers push script
                                                           ↓
                                                  Read report → Create summary
                                                           ↓
                                                  Write to Telegram Bot inbox
                                                           ↓
                                                  Bot pushes to my phone
```

### Push Mechanism

The push script logic is simple:

1. Find today's night shift report file
2. Take the first few dozen lines as a summary (Telegram has character limits)
3. Write to the Bot's inbox, let the Bot push automatically

Just set up a cron to run it at a fixed morning time. If no report was generated that night, push a "no report tonight" notification — at least I know the system ran.

### What a Morning Report Looks Like

```markdown
# Night Shift Report — 2026-03-06

## System Status
- Services: ✅ All normal
- Disk usage: 22%
- Memory: Normal
- Automated tasks: Last run successful

## Completed Tonight
1. Fixed permissions issue in auto-deploy script
2. Wrote 2 blog posts (bilingual)
3. Optimized database query performance
4. Updated 3 SOP documents

## Issues Found
- Backup service responding slowly → Added retry mechanism

## Proposals (Need Judy's Decision)
- Suggest upgrading database version (see details)

## Discussion Summary with Mimi
- Discussed content strategy, agreed to prioritize article series
- Mimi updated the knowledge base index

## Recommendations for Tomorrow
- Review database upgrade proposal
- Schedule next week's content plan
```

---

## 7. Lessons Learned (The Hard Way)

### Lesson 1: Session Expiry

*(J)*

Initially I tried using `--resume` to continue from the previous round's session. Problem: Claude Code sessions expire, and after several hours in a night shift, resume would fail.

**Fix**: Start a **fresh session every round** (`--no-session-persistence`). Use shared files (reports, chat files) to pass state between rounds instead of relying on sessions.

### Lesson 2: Prompt Too Long

The night shift prompt contained all rules, priorities, and safety guardrails. Writing it all inside the shell script was unmaintainable.

**Fix**: Separate the prompt into a `.txt` file. The script just reads it and appends dynamic variables.

```bash
PROMPT=$(cat ~/night-shift/prompt.txt)
PROMPT="$PROMPT
- Date: $(date +%Y-%m-%d)
- Round: ${ROUND}
- Remaining time: ~${REMAINING} minutes"
```

### Lesson 3: Two AIs Out of Sync

*(Judy)*

J and Mimi have a time lag. J asks a question in the chat file, Mimi might not see it for 30 minutes. At first they would wait for each other's replies, wasting a lot of time.

**Fix**: Switch to **async collaboration** — write ideas in, don't wait for responses. Mimi's heartbeat scans the chat file every hour. If she sees something, she responds. If not, she does her own work.

### Lesson 4: Forgot to Save Before Crashing

*(J)*

The worst time: two hours of work done, about to write the report, hit rate limit, session dies. Everything was in memory, nothing saved to files.

**Fix**: "Save after every step" — after completing each item:
1. `git commit` the code
2. Update the morning report (append completed items)
3. Write to the log

The rule now: **if it's not committed, it didn't happen.**

### Lesson 5: Security Incident

*(Judy)*

One time J accidentally sent a work report to a chat group that had other people in it — essentially leaking our work ~_~

**Fix**:
- Explicitly list **banned tools and scripts** in CLAUDE.md
- Designate a single approved reporting channel, ban everything else
- After that incident, the guardrails got very strict

---

## Start Tonight: The Minimum Viable Version

*(Judy)*

If you want to try this, you don't need to build everything at once. Here's the simplest version:

### Step 1: Write a Simple Prompt

```text
You are my AI assistant in night shift free mode.
Please check system status (disk, memory, services), then:
1. Write results to ~/night_report.md
2. If you find any issues, try to fix them

Allowed: read files, check status, restart services
Not allowed: delete files, change passwords, install packages
```

Save as `~/night-shift/prompt.txt`.

### Step 2: Write a Simple Script

```bash
#!/bin/bash
# simple_night.sh
claude -p "$(cat ~/night-shift/prompt.txt)" \
    --no-session-persistence \
    --dangerously-skip-permissions
```

### Step 3: Test It Manually

```bash
chmod +x ~/night-shift/simple_night.sh
bash ~/night-shift/simple_night.sh
```

Once you confirm it works, add the cron:

```bash
# crontab -e
0 1 * * * ~/night-shift/simple_night.sh >> ~/logs/night.log 2>&1
```

Run it for a week, read the reports each morning, and gradually add rules based on what you see. Don't over-engineer from the start.

---

## Final Thoughts

*(Judy)*

Setting up this system took about three days of iteration. Day 1 it ran for a few minutes and stopped. Day 2 it burned all tokens at once. Day 3 we finally got the stable round system working.

But once it stabilized, reading the morning report became the best part of my morning routine XD

If you've read this far, you've probably noticed — I'm not some amazing engineer. But I know how to find problems and figure out solutions. My AI has learned to think the same way, so whenever something breaks, we just tackle it together. All the pitfalls I shared above? Those are our real experiences. And that's where human value lies.

**This night shift system is now open source!** The complete prompts, scheduling config, and morning report templates are all on GitHub — feel free to Star and Fork:
👉 [JudyaiLab/ai-night-shift](https://github.com/JudyaiLab/ai-night-shift)

Questions? Leave a comment or email me at miranttie@gmail.com

## References

- [tmux + Claude Code on macOS: The Complete Setup Guide](https://www.linkedin.com/pulse/tmux-claude-code-macos-complete-setup-guide-jason-vertrees-8am0c)
- [r/ClaudeAI on Reddit: Claude now works my night shift, here's how I set up scheduled autonomous coding](https://www.reddit.com/r/ClaudeAI/comments/1qflv3y/claude_now_works_my_night_shift_heres_how_i_set/)
- [Claude Code + tmux: The Ultimate Terminal Workflow for AI Development](https://www.blle.co/blog/claude-code-tmux-beautiful-terminal)

## Key Numbers

- 5000 users (Threads + Newsletter subscribers)
- $0 ad spend (100% organic)
- 95% content authored by J + multi-agent team
