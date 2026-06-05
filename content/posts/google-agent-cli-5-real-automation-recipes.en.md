---
title: "Google Agent CLI in Action: 5 Cloud Automation Recipes One-Person Companies Can Copy"
date: "2026-05-28T05:00:49+00:00"
draft: true
author: "Judy"
summary: "After cloud-scheduled Agents like Google Agent CLI and Claude Code launched, can one-person companies really offload busywork to AI?整理 5 個可複製的自動化食譜設計與選型邏輯。"
description: "Starting from the trend of cloud-scheduled Agents, this article organizes 5 automation scenarios using Google Agent CLI and Claude Code for Gmail, Calendar, Drive, Sheets, and cross-Agent handoffs. Includes selection logic, prompt design, and 3 common pitfalls around permissions/cost/retry—non-engineers can copy these recipes too."
categories:
  - "AI Automation"
tags:
  - "Google Agent CLI"
  - "Claude Code"
  - "Routines"
  - "AI Agent"
  - "Automation"
  - "One-Person Company"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
series:
  - "Complete AI Agent Guide"
faq:
  - q: "What's the difference between Google Agent CLI and Claude Code? Which should a one-person company choose?"
    a: "Gemini CLI is Google's open-source terminal AI agent, excelling at integrating with Google ecosystem services like Gmail, Calendar, and Drive. Claude Code positions itself as a cross-file understanding and terminal editing tool, stronger in local development scenarios. One-person companies don't need to pick one over the other—I recommend letting Gemini CLI handle Google internal busywork, and passing to Claude Code for cross-tool tasks that require programmatic judgment. This division of labor is more practical than forcing a single choice."
  - q: "How is cloud-scheduled Agent different from GitHub Actions? What tasks should go to cloud Agent?"
    a: "GitHub Actions suits deterministic workflows with fixed steps like Build, Test, and Deploy. Cloud-scheduled Agents suit open-ended tasks that need to assess content before deciding the next step—like classifying emails or determining which project a file belongs to. The decision rule is simple: if you can write the rules, use Actions; if the rules can't be fully documented and you need semantic judgment, use Agent instead—or token costs will spiral out of control."
  - q: "Will Gmail auto-classification accidentally delete important emails or send wrong replies? How to design it safely?"
    a: "The key is explicitly forbidding destructive actions in your prompt. I suggest writing directly in the instructions 'no deleting emails, no replying, no marking as read'—only allow labeling. Uncertain emails should go to a 'to review' label rather than forcing the Agent to classify. Same for Calendar scheduling—only generate suggested drafts for your morning confirmation, don't let the Agent send replies directly. Keep the human as the final checkpoint."
  - q: "What are common pitfalls when using Agent for Drive archiving and Sheets aggregation?"
    a: "Three most common: granting overly broad permissions causing the Agent to touch folders it shouldn't, not providing comparison benchmarks leading to empty insights in Sheets, and not setting token limits on open-ended tasks causing cost explosions. For Drive, only grant permission to specific folders. For Sheets, always feed 'today vs 7-day average vs same day last week' comparison data, and set daily token budget and retry limits at the scheduling layer."
  - q: "How do multiple Agents hand off work? Do I need a message queue?"
    a: "Not needed. The most crude but stable method is using the file system as a mailbox: Agent A completes its task and writes results as markdown to a cloud folder; Agent B scans that folder hourly and takes over when it sees new files. The benefit is—if either side breaks, the other can still see what was handed over. The entire line won't break with no trace, and you don't need to maintain extra event bus infrastructure."
  - q: "Are these automation recipes suitable for non-engineers? Do I need coding skills to copy them?"
    a: "Suitable. The core of these 5 recipes is prompt design and scheduling logic, not coding. Both Gemini CLI and Claude Code operate with natural language—just install and follow the official docs to set up schedule triggers. Non-engineers should focus most on clarifying the process: when the Agent should act, and when to loop back to human judgment. That's more important than technical details."
  - q: "Running these busywork tasks with cloud Agents—what's the monthly cost approx? How to keep it under control?"
    a: "It's hard to precisely estimate token usage for open-ended tasks—the actual cost depends on email volume, file count, and prompt complexity. There are three control methods: set max token limit per execution at the scheduling layer, have prompts explicitly ask for 'summaries only, no per-email breakdown,' and move deterministic steps (like fixed field filling) to Apps Script—only keeping truly judgment-requiring parts for the Agent."

---

## Cloud Agent Goes Live: One-Person Companies Finally Have Somewhere to Dump Busywork

Over the past year, AI CLI tools have exploded onto the scene. Anthropic's Claude Code moved from IDE to terminal, with installation guides on GitHub positioning it as "an Anthropic-official, agentic coding tool running in the terminal"—capable of understanding entire codebases, completing edits with natural language, and running commands [Source: https://github.com/anthropics/claude-code]. Google's concurrent release, Gemini CLI, went the same direction, with the official repo describing it as an open-source AI agent that "brings Gemini directly into your workflow" from the terminal [Source: https://github.com/google-gemini/gemini-cli].

The shared direction of this wave of tools: they're not just answering questions—they **can actually be scheduled, triggered, and run through an entire flow on their own**. For one-person companies, the significance of this differs from engineers. Engineers see CI/CD; individual creators see—*finally dumping that whole bag of "things I do every day but don't want to spend brain power on"*.

These 5 recipes below organize the common design directions I've seen lately. They're not saying copy-paste and it'll definitely work—they're giving you a对照 group of "oh, that's how you can divide responsibilities".

## Selection Logic: What Goes to Cloud Agent, What Stays on Local CLI

First, why divide responsibilities instead of going all-in with one tool.

Cloud-scheduled Agents suit **open-ended tasks**—those that need judgment, that need to see current conditions to decide the next step. Deterministic workflows with fixed steps and determined results (Build, Test, Deploy) are better left to traditional CI tools like GitHub Actions—cleaner that way. Claude Code's official docs position it as "a development assistant running in the terminal, with cross-file reasoning," defaulting to local interactive mode [Source: https://docs.anthropic.com/en/docs/claude-code/overview]—converting it to cloud scheduled runs requires separately designing schedules and trigger mechanisms.

Translating to one-person company scenarios:

- **Tasks requiring content-based judgment** (classify Gmail, decide which email to reply to, which Drive file goes to which project) → suited for cloud Agent scheduling
- **Daily fixed-format report generation** (Sheets aggregation, fixed field filling) → can also assign, but prompts need to be very explicit
- **Tasks requiring cross-tool handoff** (one Agent finishes, another takes over) → running on cloud less likely to get stuck on local machine

Cost aspect must be clarified first: open-ended tasks easily cause token costs to spiral—this is the core constraint when designing recipes, which I'll expand on in the pitfall section.

## Recipes 1+2: Gmail Auto-Classification + Calendar Smart Scheduling

Gmail classification is worth tackling first because the inbox is the source of noise.

Design logic is simple: trigger at a fixed time each morning, Agent scans overnight unread emails, applies labels based on your rules—inquiry about quotes, collaboration invites, subscription newsletters, spam. The key isn't writing rules in fine detail—the key is **telling the Agent "when uncertain, label as needing human review"**—don't force it to classify.

Prompt template looks roughly like this:

```
You're my inbox assistant. Scan unread emails from the past 24 hours,
apply labels based on these rules:
- Contains quote/payment keywords → [Client]
- Contains collaborate/invite/media → [Collaboration]
- Contains unsubscribe → [Newsletter]
- Unsure → [To Review]

No deleting emails, no replying, no marking as read.
After completion, give me a summary: how many per category, any that look urgent.
```

Connecting to Calendar is step two: grab emails labeled [Collaboration], extract proposed time slots from their content, cross-reference with your Calendar's free slots—produce a "suggested reply times" document. **Don't let the Agent reply on its own**—just put the suggestions in a draft or Notion page, scan it over your morning coffee and decide yourself.

The design goal linking these two together is turning the flow of "open inbox → look → classify → decide whether to schedule a meeting"—which used to be scattered several times throughout the day—into one集中處理 session in the morning. How much time actually saves varies by person, but the point is consolidating fragmented attention switches into a single time block.

## Recipes 3+4: Drive Auto-Archive + Sheets Daily Aggregation

The pain point with Drive archiving isn't having too many files—it's **not having time to organize when you download, and two weeks later you can't find anything**.

Design logic: run once nightly, scan Drive root and "Downloads" folders, use filename + content to determine which project folder to archive to. Again, **if uncertain, don't touch—put in a "to organize" folder** for you to review.

Sheets aggregation is a different need: daily aggregate data from several sources (GSC, revenue, social numbers) into one sheet. This is actually more stable with GitHub Actions + Apps Script, but if you want "insights written alongside"—then using Agent is worthwhile—it'll see the story behind the numbers, not just fill columns.

The prompt key is giving it **comparison benchmarks**: "today vs 7-day average, vs same day last week"—don't just dump today's numbers in, or it won't highlight anything meaningful.

## Recipe 5: Cross-Agent Handoff—Turning "My AI" Into a Team

This is the most worthwhile design concept to share.

The multi-Agent collaboration concept is letting different Agents run on different models, responsible for different domains—tech, marketing, content, product, QA. Applying the same logic back to personal workflow: **instead of one Agent doing everything, let Google Gemini CLI do what it's good at in the Google ecosystem, and hand cross-tool parts to Claude Code**.

The handoff method is actually crude but useful: **use the file system as a mailbox**.

When Agent A finishes, it writes the results as a markdown file to a cloud folder; Agent B sets up to scan that folder hourly, and when it sees new files, takes over the next step. No complex message queue, no event bus—just file in, file out.

The architecture benefit: if either side breaks, the other can still see "what the previous hand-off gave me"—the entire chain won't break with no record.

Another habit worth pairing: placing a spec file in each project root. Taking Claude Code as example, official docs position `CLAUDE.md` as a project-level memory file, automatically loaded into context—for project preferences, conventions, past decisions [Source: https://docs.anthropic.com/en/docs/claude-code/memory]. Gemini CLI has corresponding `GEMINI.md` mechanism serving as hierarchical instructional context [Source: https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/configuration.md]. This is especially important for cross-Agent handoffs—it's essentially your team's shared SOP file.

## Pitfalls: Permissions, Costs, Retry Failures

These three things are the most frequently reported blockers after launching cloud Agents:

**Permissions**: First time Agent runs on Gmail/Drive requires OAuth authorization—non-engineers get stuck here. My recommendation: record your own screen during initial setup; next time you need to reset or switch accounts, you won't have to figure it out again. **Only grant minimum necessary scope**—if read-only works, don't give write access.

**Token Costs**: Open-ended tasks spiral easily. If the same Agent's prompt doesn't clearly define boundaries, it repeatedly reads files, repeatedly thinks. I recommend adding at the end of prompts: "max N steps执行, stop and report to me if exceeded."

**Retry on Failure**: Scheduled Agents don't automatically retry when they die—you need to set up your own health check. For example, another simple cron that daily checks "if today's report was supposed to be produced, was it produced?" If not, push a notification to Telegram or Slack. Don't discover a silent scheduler death a week later.

## Minimum Starting Point for Non-Engineers to Copy

If you only want to test one, start with Gmail classification—no need all five at once.

Setup flow: subscribe plan → throw that Gmail prompt above into your chosen CLI → set a daily 8 AM trigger → run three days and see if labels are accurate → if not, go back and adjust prompt.

The key to tuning prompt isn't making rules more detailed—it's **clarifying "what to do when uncertain."** AI isn't afraid of not knowing how to do something—it's afraid of not knowing when to stop and ask you.

Tools change yearly, but consolidate scattered judgment costs into centralized handling—that action alone is worth doing.

Above are the cloud Agent recipe design directions observed recently, adjusted to fit your own workflow before going live.
