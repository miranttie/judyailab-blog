---
title: "How I Run 7 AI Models 24/7: Multi-Agent Architecture in Practice"
date: "2026-05-20T12:00:00+00:00"
draft: false
author: Judy
slug: 2026-05-20-multi-model-ai-team-24h-autopilot
summary: "Seven AI models organized into a 24/7 team via Linear. Drop a task card, supervisor Agent picks it up in 5 minutes, dispatches to the right specialist — engineering, writing, QA, marketing, trading. Multi-model specialization beats one big model."
description: "Seven AI models, one 24/7 team. Linear as console, task cards auto-dispatched in 5 min, Gate + QA + TA reviews catch fake completions. Multi-Agent architecture, in practice."
categories:
  - "AI Engineering"
  - "Tutorial"
tags:
  - "Multi-Agent"
  - "AI Team"
  - "AI Automation"
  - "Claude Code"
  - "Linear"
  - "Agent Architecture"
  - "Multi-Model"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "Why not use one strongest AI (like all GPT-5 or Claude Opus)?"
    a: "Because each model has different strengths and cost profiles. Strong reasoning models are expensive — unaffordable at scale. Fast writers aren't great at task decomposition. Fact-checking needs built-in search. Multi-Agent architecture lets each model do what it's best at — cheaper AND more accurate than one model doing everything."
  - q: "Why use Linear as the control console? Why not Notion or a custom dashboard?"
    a: "Because issue trackers are the most natural interface for dispatching work — labels, state transitions, comments, sub-tasks are built in. Treating AI as 'virtual coworkers who pick up cards on their own' lets you plug straight into an existing workflow. I do have a custom dashboard, but Agents always forget to update it. Linear's state transitions are built-in — there's no 'forgot to update' option."
  - q: "What is Gate? Why audit AI output?"
    a: "Gate is an automated review layer that catches AI's common shortcuts — vague hedge words that push responsibility back to humans, fabricated facts, internal info leaks. AI saying 'done' doesn't mean it's actually done. Gate automates this trust problem."
  - q: "What's the minimum viable unit? Can I start with this?"
    a: "One Linear board + two crons (one polls tasks, one triggers execution) + three roles (supervisor / executor / QA). Get one pipeline running first, then add roles and Gates. Don't start with seven models on day one."
  - q: "How is Multi-Agent architecture different from OpenAI Symphony?"
    a: "Symphony spawns many instances of the same model (all Codex), solving the coding scale problem. Multi-Agent architecture is multi-model, multi-role specialization — supervisor, engineering, writing, QA, marketing, trading each have their own dedicated model. Closer to how a real small team works."
lastmod: 2026-05-25T11:29:30+00:00
---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

> **TL;DR**: I used Multi-Agent architecture to organize seven different models into a 24/7 AI team — Claude Opus as supervisor to break down tasks, MiniMax writes code, Hermes writes articles, Gemini CLI checks facts, Groq Llama makes trading decisions. Control console uses Linear, task cards get grabbed within 5 minutes, pass through Gate review and QA fact-checking before reporting back to me. This article breaks down the entire architecture, logic behind model role selection, how Gate blocked 300+ fake completions, and how you can start from the smallest unit.

---

## Why Everyone Asks Me "How Do You Make AI Work Automatically"

I've been running an almost all-AI company for a while now, with a Multi-Agent architecture running internally that coordinates seven different AI models like a real company working together. Whenever I introduce this Multi-Agent architecture to people, the most common thing they want to know isn't "what model do you use", but rather this:

**"How exactly do you make AI work on its own?"**

A lot of people have tried letting AI take over tasks, but they all hit the same bottleneck — they still have to constantly monitor it, and eventually it feels faster to just do it themselves. The problem isn't that AI isn't strong enough, the problem is **architecture**. A single AI, no matter how powerful, can't do "pick up tasks on its own, divide work, review, and deliver" well. To achieve true AI automation, you don't need a stronger model, you need **Multi-Agent architecture**.

My daily routine doesn't look like that. I think of a task in the morning, open Linear, create a card, tag it "J", hit Enter. **Within 5 minutes**, that card gets picked up by my supervisor Agent, which judges whether it's writing an article, coding, research or marketing promotion, assigns it to the corresponding role, that role starts executing, passes through Gate review, then QA fact-checking, and only reports back to me after everything passes.

The only two things I do: post the card, read the results.

In this article, I'll explain the entire Multi-Agent architecture clearly, including my detours from "one dedicated Agent per pipeline" to "seven different models working by specialization".

---

## Common Mistakes: My Multi-Agent Architecture Detours

Initially, I made one intuitive mistake too.

I thought: "Different things need different Agents." So I created a bunch: Blog-writing Agent, X-posting Agent, trading signal Agent, market intel Agent, SEO Agent, image generation Agent…

Three months later, I discovered several issues:

- **Memory isn't shared**. The Blog Agent doesn't know what the X-posting Agent posted last week.
- **They don't know what each other is doing**. One Agent wrote a blog post, another Agent rewrote it when posting to X.
- **Debugging is a nightmare**. When something goes wrong, you have to check five logs.

I cut and rebuilt. Changed to **using "specialty" as the classification axis** — no longer organized by "task".

What this means: whichever pipeline needs "writing" goes to the Writing Agent, whichever pipeline needs "QA fact-checking" goes to the QA Agent. One Agent per specialty, all pipelines share.

With this setup:

- Writing Agent handles all writing (Blog, X, Email, product copy).
- QA Agent handles all reviews (writing quality, code review, fact-checking).
- Engineering Agent handles all code implementation.
- Supervisor Agent handles breaking down tasks, assigning, and sending back.

**More isn't always better. Less but correct is.**

Only after this architecture stabilized did the rest of the story happen.

---

## What the Multi-Agent Architecture Looks Like

```
       Issue Task
         │
         ▼
   ┌──────────┐  Every 5 min polling  ┌──────────┐
   │  Linear  │ ──────────────────▶│ Central Scheduler │
   └──────────┘                     └─────┬────┘
                                         │
                                         ▼
                         ┌──────────────────────┐
                         │  Supervisor Agent    │ ── Break tasks, assign, send back
                         │ (Opus)              │
                         └──────────┬───────────┘
                                    │
            ┌────────────┬──────────┼──────────┬────────────┐
            ▼            ▼          ▼          ▼            ▼
       ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐
       │ Engineer│ │ Writer │  │  QA    │  │Marketing│  │ Trading│
       │MiniMax │  │Hermes  │  │Gemini  │  │MiniMax │  │ Groq   │
       └───┬────┘  └───┬────┘  └───┬────┘  └───┬────┘  └───┬────┘
           │           │           │           │           │
           └───────────┴────┬──────┴───────────┴───────────┘
                            │
                            ▼
                    ┌──────────────┐
                    │  Gate Review │ ── Block vagueness, fabrication, leaks
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
                    │ QA Fact-Check│ ── Built-in search verification
                    └──────┬───────┘
                           │
                           ▼
                        Report to Judy
```

Each box is an independent script or service, communicating via file-based mailboxes. The whole thing runs on an Oracle cloud VM, **using cron scheduling, no message queue, no webhook, no extra middleware**. Simple enough that I can debug directly by reading files myself.

---

## How It Runs: Step-by-Step Breakdown From Card to Publication

Let me give a concrete example — this morning I wanted to write an introduction article about some AI tool.

**Step 1 (00:00)** — I open Linear, create a card: "Write an XX tool introduction, 800 words, target audience is indie developers who want to automate with AI". Tag it "J", hit Enter. Close Linear, move on to other things.

**Step 2 (+5 minutes)** — Central scheduler polls and finds this new card. It sees the tag "J", writes the card content to the Supervisor Agent's mailbox.

**Step 3 (+6 minutes)** — Supervisor Agent wakes up, reads mailbox, judges this is a "writing" type task, assigns it to the Writer Agent's mailbox with instructions: "800 words, tutorial style, target audience indie developers, include FAQ".

**Step 4 (+10 minutes)** — Writer Agent drafts. Hermes model writes and drops to draft folder.

**Step 5 (+15 minutes)** — Gate review scans the draft, checking for vague hedging language that shifts responsibility back to humans, fabricated KPI numbers, internal path leaks. This time Gate caught one sentence: "data source is internal database" — automatically sent back to Writer Agent to change to "estimated based on public data".

**Step 6 (+20 minutes)** — After revision, passes Gate. Moves to QA stage.

**Step 7 (++30 minutes)** — QA Agent uses Gemini's built-in search to verify each fact mentioned in the article. Found a version number error, automatically flagged. Sent back for minor fix.

**Step 8 (+45 minutes)** — Fixed, all passes. Article auto-syncs to Notion, status "Waiting for Judy's approval".

**Step 9** — After breakfast, I open Notion and see a ready-to-publish draft. After reviewing, I click "Ready to publish". System automatically translates to English and Korean, deploys to blog.

Total time I spent: 30 seconds to post card + 5 minutes to review. Rest of the time I'm doing other stuff.

---

## My Collaboration Mode: Opus Gives Framework, MiniMax Implements

This is the core know-how of the entire architecture, let me give a concrete example — **coding**.

If writing a new strategy for a trading system, the most intuitive approach is to have Claude Opus write from start to finish. Can do. But expensive and slow.

My approach is:

1. **Opus handles framework breakdown** — I give Opus requirements, it outputs: file structure, function signatures, responsibilities for each function, edge cases, tests needed. **No implementation details**, just the skeleton.
2. **MiniMax fills in implementation** — The skeleton Opus broken down gets handed to MiniMax, which fills in one function at a time.
3. **Sonnet handles code review** — After MiniMax writes, Sonnet does a round of review, catching logic holes and edge cases.
4. **Opus handles final polish** — For issues Sonnet flags, back to Opus to decide whether to fix and how.

Why split this way?

- Opus is strong at reasoning, best for **judgment work** (breaking down, polishing). But running at scale is expensive, running full capacity daily hurts the wallet.
- MiniMax is subscription-based, **fast and cheap to write**, context is long enough, best for **implementing according to spec**.
- Sonnet sits between the two, perfect for review — cheaper than Opus, but still solid logic.

This pattern applies to writing too: Opus gives structural outline, Hermes writes first draft, Sonnet does factual review, Opus polishes the final round.

**Let each model do what it's best at** — that's the only principle in myMulti-Agent architecture.

---

## Seven Models, Seven Specialties

I'm currently running seven different models, each with its dedicated position:

### 1. Claude Opus 4.x — Strategist / COO
Strongest judgment. Handles breaking down tasks, assigning, sending back, programming framework, final code review, dispute arbitration.

**When to use it**: When choices need to be made. For example "which bug fix A or B is correct", "who should this card go to", "this blog post is going off direction halfway, how to save it".

### 2. Claude Sonnet 4.6 — Writing fact-check / code review / backup trading analyst
Cheaper version of Opus. Logic is almost as solid, price is half.

**When to use it**: Scenarios requiring rigorous reasoning at high volume. Blog tutorial fact-checking, code review, trading analyst (Groq's backup).

### 3. MiniMax M2.7 — Engineering implementation / marketing execution
Subscription-based, long context, fast writer.

**When to use it**: Implementing according to already-broken-down framework (no need to make own judgments), marketing copy execution, translation.

### 4. Hermes (via OpenRouter) — Writing role
Writing quality is sufficient, low cost. Long-form style is stable.

**When to use it**: Blog draft, social post draft, product copy draft. All writing that needs output length but doesn't require fact-checking.

### 5. Gemini CLI subscription — QA fact-checking
**Built-in web search is its irreplaceable advantage**. Some models need external search APIs to check facts, Gemini CLI searches on its own.

> Note: There's also a practical reason for picking Gemini CLI — I bought a full-year subscription at the start of the year, might as well use it.

**When to use it**: Check facts before Blog goes live, verify press releases, market research source comparison.

### 6. Gemini API (Flash) — News pipeline
**Free tier** is enough for daily news aggregation, fast enough, API is stable.

**When to use it**: Daily news fetching and organization pipeline, high volume, not much reasoning needed. Free allows me to not worry about cost explosion.

### 7. Groq Llama-4-Scout 17B — Trading signals / position management
**Extremely fast**, inference latency is 1/10 of other models.

**When to use it**: Scenarios where trading strategies need instant response — signal review (decide whether to enter), position management (suggest HOLD / tight stop loss / profit taking / close immediately). Things where losing a second means losing money.

---

## Why Use Linear as Control Console

I tried Notion, tried Slack, tried building my own dashboard, but kept Linear. Reason is simple:

**Issue tracker is already the most natural interface for assigning work to humans.**

Labels are routing, status is workflow, comments are communication, sub-tasks are breakdown. These features don't need designing, they're built-in. The only thing I need to do is connect "AI Agents that pick up cards on their own", treating Linear as their source of work.

More importantly: **comment round-trips also go through Linear**. Agent leaves comments when done, I comment questions back, Agent sees comments and replies. The entire conversation flow automatically deposits on the card — for future review, I just look at that card.

Notion is too flexible, Slack is too linear. I do have a custom dashboard — but Agents keep forgetting to update it, requiring me to nag them to write, which defeats the purpose. Linear is just right — status flow is built-in, Agents must go through Linear to do work, there's no "forgot to update" option.

---

## Files Are the Communication Protocol

A lot of people ask how Agents communicate. **Using files.**

Each Agent has a mailbox folder. Supervisor assigning work means writing a message file into the corresponding mailbox. Executing Agents poll their own mailboxes, see new messages, process them, then write results to a "completed" folder.

Why not use message queue, Redis, or webhook?

- **Simple** — cron can run it. No servers to maintain.
- **Auditable** — every message is a file, to trace debugging just read the file content.
- **Rerunnable** — result wrong? Move file back to mailbox and reprocess.
- **Zero dependencies** — I don't need to learn any new tools, what's built into the OS is enough.

Sounds primitive, but runs stably. **The simplest tools are often the most durable.**

---

## Gate + QA + TA Three-Layer Review: Why I Trust AI But Not Completely

AI's biggest problem isn't that it can't produce stuff, it's **stuff that looks right but actually isn't**.

I've encountered several specific situations:

- Finishes code and tells me it's all good — turns out it wasn't tested at all.
- Writes an article citing a data point, the data was made up.
- Copy accidentally leaks internal paths or API variable names.
- Same bug fixed three times, all wrong, each time saying "this one is right".

That's why I added two layers of automated review.

### Gate Layer — Detect Lazy Patterns

Gate is a series of regex + rules, automatically scanning Agent outputs:

- **Vague hedging detection** — catches language that shifts responsibility back to humans (asking humans to check themselves, vaguely describing "should be fine", hedging in English), automatically FAIL. To PASS, evidence must be attached (command output, file content, API response).
- **Same-card bounce count** — same card bounced from same Agent over 3 times automatically switches to another person, preventing infinite loops.
- **Timeout alerts** — Agent picks up task but no report after 6 hours, push notification sent.
- **Internal info leak** — paths, hostnames, API variable names, private accounts, financial data, blocks upon detection.

Just this Gate layer has **blocked over 380 FAKES** cumulatively, **over 90 automatic bounces**. Meaning none of these fake completions reached my eyes.

### QA Layer — Real Fact Verification

Passing Gate doesn't mean the article is correct. QA layer uses Gemini's built-in search to verify every factual claim in the article (version numbers, dates, references, statistics) against the web. Misaligned sends back for minor fixes.

### TA Layer — Target Audience Perspective Review

Passing QA doesn't mean the piece is "worth reading". TA (Target Audience) review has another Agent play the target reader — for example, if this article's target audience is indie developers, TA Agent reads from that perspective: finished reading, is there something actionable? Want to click the next one? Are technical terms too heavy? Is emotional resonance there? TA fails it, send back.

All three layers combined let **me trust the results directly**, without needing to fact-check every piece myself.

> Note: The three-layer review described here is the basic version, **different pipelines have their own custom settings** — for example, trading pipeline adds a risk control Gate (single trade >2% risk gets BLOCKED), product launch pipeline adds a copyright and brand consistency Gate, Blog pipeline adds a lead generation rhythm Gate. The basic skeleton is the same, details grow according to scenario.

---

## What We Can Do

Now that this Multi-Agent architecture has stabilized, a lot becomes possible:

- Auto-write blogs (Chinese, English, Korean trilingual) with SEO/AEO optimization
- Automatically scan market news daily, summarize key points, push out
- Run crypto quantitative trading, from **auto strategy research**, signal review to position management fully automated — system runs backtests, discovers new strategies, throws into Testnet to verify, promotes to real money only when target is hit
- Auto-process email, important ones translated to Chinese and pushed to me
- Run social marketing, X posts, Threads, Reddit auto-distributed
- Conduct market research, from keyword research to competitive analysis to Notion reports

Most representative capability is product development — **I mandated that I must see one new product when I wake up every morning**. So the system must complete market research → opportunity assessment → product design → copy → launch → marketing in those few hours while I sleep, delivering the finished product the moment I open my eyes. One per day, no exceptions.

I can achieve these not because I used the strongest model, but because **each specialty has the right person on the job**.

---

## You Can Start From the Smallest Unit Too

Don't aim for seven models from the start. Here's the minimum version you can get running **in 90 minutes over a weekend**.

### Step 1: One Linear board (10 minutes)

Sign up for a free Linear workspace → create a project → go to Settings → API → generate `LINEAR_API_KEY` and save it in `.env`.

Minimum config:
- **Three labels**: `role:executor`, `role:qa`, `status:rejected`
- **Three statuses**: `Todo` → `In Progress` → `Done` (Linear default works)

### Step 2: Two crons (20 minutes)

#### Cron A — Dispatcher (polls Linear every 5 minutes)

```python
# dispatcher.py pseudocode
new_cards = linear.list_issues(status="Todo", missing_label=["role:*"])
for card in new_cards:
    role = classify(card.title)        # keyword match or call an LLM
    linear.add_label(card.id, f"role:{role}")
    linear.set_status(card.id, "In Progress")
```

crontab:
```
*/5 * * * * cd /opt/agent && python dispatcher.py >> logs/dispatch.log 2>&1
```

#### Cron B — Executor (fires the matching agent every 5 minutes)

```python
# executor.py pseudocode
cards = linear.list_issues(status="In Progress", label="role:executor")
for card in cards:
    prompt = f"Task: {card.title}\nSpec: {card.description}"
    result = run_cli("claude-code", prompt)   # or codex / aider / gemini cli
    linear.add_comment(card.id, result)
    linear.add_label(card.id, "needs-qa")
```

```
*/5 * * * * cd /opt/agent && python executor.py >> logs/exec.log 2>&1
```

### Step 3: Three role prompts (30 minutes, copy-paste ready)

Each role = **one system prompt + one trigger condition**.

**Supervisor (Opus or Sonnet)** — breaks requirements into executable cards:

```
You are a PM. Read user requirements and output a Linear card as JSON:
{"title": "...", "description": "what specifically to do", "acceptance": "pass criteria"}
Acceptance criteria MUST be verifiable. No fluff like "do it well".
```

**Executor (any cheap model — MiniMax / Codex / Haiku all work)** — actually does the work:

```
You are the executor. Read the task, do it, output the result.
Iron rule: NEVER output hedging like "probably", "should", "please check manually".
If unsure, write "I don't know, reason: ..." instead.
```

**QA (Gemini CLI or any tool with built-in web search)** — fact-check + block vagueness:

```
You are QA. Read the executor's output. Three checks:
1. Are the facts correct? (use web search to verify at least 1 data point)
2. Any vague language? (grep "probably|should|please check|可能|應該")
3. Does it meet the acceptance criteria?
Any check fails → output FAIL + specific reason; all pass → output PASS.
```

### Step 4: Run the first card (20 minutes)

In Linear, manually create:

- **Title**: Write a 100-word intro to Claude Code
- **Description**: For non-technical readers, must be factual, no hedging, must cover "what it is" and "what it does"

Expected within 10 minutes:

1. Cron A picks it up → adds `role:executor` → moves to In Progress
2. Cron B picks it up → calls the executor → comments the result → adds `needs-qa`
3. QA cron (or chained after Cron B) → reads the comment → web-searches facts + greps hedging → comments PASS/FAIL

**PASS** → move to Done. **FAIL** → bounce back to Todo + `status:rejected` label + comment with the reason.

### Step 5: Expand once it works

Once the first card flows end-to-end, layer on:

- **Second executor model** — different labels route to different CLIs (`lang:code` → Codex, `lang:writing` → MiniMax)
- **Bounce mechanism** — same card hits FAIL 3 times → auto-Blocked + Telegram alert
- **More roles** — marketing, trading, data each get one system prompt + one label rule
- **Notification layer** — Telegram bot pushes done cards to you, so you don't sit in Linear

**Don't try to build everything at once. Get one card running first, the rest is expansion.**

---

## Closing: 1.0 is multi-instance, 2.0 is multi-model multi-role

Recently OpenAI open-sourced something called Symphony, doing similar things: using Linear as control console, one Codex agent per card, agents pick up cards and do the work themselves. OpenAI interno delivered PR growth of 500%.

After reading, I have one thought: **They only solved half the problem.**

Symphony's setup is "same model, many instances" — all Codex. Can solve coding mass production, but can't solve "different tasks need different specialties" problem. Coding, writing, fact-checking, trading, running marketing are five **fundamentally different** things, shouldn't be done by the same model.

My Multi-Agent architecture is closer to how real companies operate: **multiple roles, multiple models, each does its part**. A supervisor, an engineer, a writer, a QA, a marketing, a trading, a data — like a real small team.

**multi-instance homogenous agents is 1.0. multi-role multi-model Multi-Agent architecture is 2.0.**

If you're also trying to make AI truly work on its own, I hope this helps you skip my detours. Start from one Linear card, three roles, grow slowly.

Side note, the **prototype** of this Multi-Agent architecture was open-sourced just over two months ago — a repo called [**ai-night-shift**](https://github.com/JudyaiLab/ai-night-shift), mainly solving the "let Agents keep working while I sleep at night" problem.

**What was already running back then**:

- **Files as the communication protocol** — `bot_inbox/` + `night_chat.md` dual channels, no message queue dependency
- **Adapter abstraction layer** — one script supports Claude Code, Codex CLI, Aider, custom CLI
- **Autonomy Rules to prevent interactive deadlocks** — every prompt template carries an anti-interactive block
- **Atomic PID lock** — uses `mkdir` instead of files, prevents TOCTOU race conditions
- **Plugin system** — pre/task/post phases, pluggable

**What this article covers that grew later**:

- **Linear as control tower** — upgraded from local `bot_inbox/` to cloud board, cross-machine cross-agent
- **Multi-model division of labor** — went from "one night-shift model" to "seven models each on their own beat"
- **Gate-9 blocking vague language** — only added as a post-hoc check layer after hundreds of fake completions burned me
- **Rejection + second-pass QA** — Agent saying PASS doesn't count, J reruns + Moon QA must clear it

**Those interested can start from that repo**, it's the minimal viable ancestor of the architecture in this article, MIT licensed, free to fork. Read it first to grasp the "file communication + autonomous execution" skeleton, then come back to see how it grew into a 24/7 multi-model team.

---

## Further Reading

- [Running 4 LLMs Simultaneously: A Real Multi-Agent Team's Selection and Cost Breakdown](/posts/multi-llm-agent-team-cost-reality/)
- [I Built a Micro AI Company on a Single Cloud VPS (Hallucination Prevention, Quality Gates, and Model Tuning)](/posts/building-tiny-ai-company-on-laptop/)
- [AI Night Shift is Open Source: How We Let Multiple AI Agents Work Autonomously While You Sleep](/posts/ai-night-shift-open-source-launch/)


- [JudyaiLab/ai-night-shift](https://github.com/JudyaiLab/ai-night-shift) — The multi-agent night shift automation framework I open-sourced months ago, the minimal viable ancestor of this article's architecture
- [OpenAI Symphony Open Source Specification](https://openai.com/index/open-source-codex-orchestration-symphony/) — OpenAI official announcement, understanding their single-model multi-instance design
- [github.com/openai/symphony](https://github.com/openai/symphony) — Symphony reference implementation (written in Elixir)
- [Linear Documentation](https://linear.app/docs) — Linear API docs, starting point for connecting your own Multi-Agent architecture

---

*This Multi-Agent architecture is still iterating. If you're working on something similar, or have questions about any section, feel free to comment.*

Want first-look access to architecture iterations, lessons learned the hard way, and product development notes? Subscribe to the Judy AI Lab newsletter — every week I send out what this week's Multi-Agent team built, plus my own thinking, straight to your inbox. You'll also get the AI Team Architecture Guide PDF we use daily.

{{< lead-magnet >}}
