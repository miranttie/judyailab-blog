---
title: "Anthropic Employee's 6-Month Vibe Coding Journal: Checking Against 7 Key Points, How Many Has Our AI Team Done?"
date: "2026-05-30T05:00:32+00:00"
draft: true
author: "Judy"
summary: "With Anthropic opening up Agent Skills as an open standard, Vibe Coding has been the talk of the AI collaboration dev community. JudyAI Lab—a one-person company plus AI team—compared their setup against the checklist: 5 items already in place, 2 deliberately paused, plus a replicable minimum playbook for solopreneurs."
description: "Key points from Anthropic employees' Vibe Coding实战, comparing JudyAI Lab's GATE, agent dispatch, self-review, TDD, small-file-multi-module practices. The 2 not-yet-done items and why, plus 3 minimum playable moves and 30-day rollout节奏 for solopreneurs without enterprise scale."
categories:
  - "Real Talk"
tags:
  - "Vibe Coding"
  - "AI Team"
  - "Anthropic"
  - "AI Collaboration Dev"
  - "solopreneur"
  - "Agent Skills"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
series:
  - "AI Startup Notes"
faq:
  - q: "What is Vibe Coding? How is it different from just using AI to write code?"
    a: "Vibe Coding is the AI-collaborative coding rhythm accumulated by Anthropic employees, with the core concept being 'human decides, AI executes'. The difference is it emphasizes 5 things: Gate-first, Agent dispatch listing allowed_files, self-review in the flow, TDD, and small files over giant ones. It's not about letting AI run wild—it's using process to keep AI's hallucinations and boundary-crossing in check."
  - q: "What are Anthropic Agent Skills? How do they relate to Vibe Coding?"
    a: "Agent Skills is Anthropic's cross-tool open spec, letting different AI dev environments load the same skill set. It standardizes Vibe Coding practices so Claude Code, Cursor, and other IDEs can share the same Skill file. The underlying meaning is Anthropic spreading their internal collaboration rhythm outward—no longer just tech news."
  - q: "What's the bare minimum for a solopreneur to run Vibe Coding?"
    a: "Three things to get started. First, write gates before code—at least 3: touching .env needs confirmation, touching deployment needs confirmation, touching payments needs confirmation. Put them in CLAUDE.md. Second, create Linear cards or GitHub Issues for every task, so AI dispatch, self-review, and reporting have somewhere to live. Third, reserve 30 minutes daily for humans—to read reports, make decisions, and independently rerun one item. You can get rolling in 30 days."
  - q: "What is allowed_files? Why do we need to list it when dispatching?"
    a: "allowed_files is explicitly listing which files the Agent can modify during dispatch. Once AI Agents get free rein, they easily cross boundaries and touch files they shouldn't, causing silent damage. Judy AI Lab's GATE-8 forces dispatch to list allowed_files, and during code review we use git diff to check—anything out of bounds gets rejected. It's the cheapest wall against AI hallucination spread."
  - q: "Why doesn't a one-person company need full observability stack and RFC process?"
    a: "Observability stack means tracing every AI call's input, output, cost, and latency across the full chain—it only makes sense at enterprise scale. For one-person teams, logs plus Linear cards plus Telegram notifications are enough; adding another layer just eats maintenance cost. RFC is a formal proposal process—for one person's short decision cycles, formal RFCs kill momentum. Use Linear cards and shared task notes instead."
  - q: "Does passing tests mean the AI-written code is fine?"
    a: "Nope. Passing doesn't equal safe. AI-generated code easily hides invisible vulnerabilities like SQL injection, XSS, command injection, and data leaks. That's why gates must come before speed—run a security scan before any task starts. Plus TDD: write test RED first, implement to GREEN, then REFACTOR, requiring 80%+ coverage."
  - q: "Why does AI mess up big files? How small should files be?"
    a: "Editing a 2000-line mega single file causes all sorts of hallucinations: wrong context, wrong location, missing related changes. Editing a 300-line small file almost never errors because the whole file fits in attention span. Recommend 200-400 lines per file, max 800, split by function/domain. Small files over giant ones—that's Vibe Coding's core discipline."

---

Recently, Anthropic officially opened up Agent Skills to the public, positioning it as a cross-tool open spec so different AI dev environments can all load the same "skills." On the surface it's just another tech news piece, but underneath it's bigger—Vibe Coding, this rhythm of collaborating with AI to write code, is spreading from inside Anthropic to the outside world.

Vibe Coding isn't a new term, but the checklist Anthropic employees refined from months of实战 is getting循环转贴 in the AI dev community. Judy AI Lab has been running with this AI team—Mi, Mimi, Lily, Ada, Xiaoyue—and after comparing against the checklist, we found some stuff we've been doing for a while, and some stuff we deliberately skipped.

## Already Doing: 5 Things—Gates, Dispatch, Self-Review, TDD, Small Files

First, **explicit Gates come before speed**. Anthropic keeps hammering this on their engineering blog: running doesn't equal safe. AI-generated code easily hides invisible security holes. GATE-1 at Judy AI Lab says it plain—if a task can't pass checks for SQL injection, XSS, command injection, or data leak exposure, nothing moves forward.

Second, **Agent dispatch must list allowed_files**. Once you let an AI Agent (basically an AI given a role that can autonomously call tools) go "wild," it'll easily touch files it shouldn't. GATE-8 at Judy AI Lab forces dispatch to list allowed_files, and during code review we check with `git diff`—anything outside the list gets bounced.

Third, **self-review becomes part of the process**. One of Anthropic's publicly shared Agent design principles: Agents can actually help humans spot vague descriptions and inefficient implementations in tools. GATE-5 at Judy AI Lab is locked in—"Agent done ≠ done, J signs off才算." GATE-6 requires that when Agent reports PASS, J independently reruns one thing with no command output—if there's nothing, auto-distrust.

Fourth, **TDD (Test-Driven Development, write tests first)**. Just because AI-written code passes doesn't mean it's right. Do test RED (fail), implement to GREEN (pass), then REFACTOR. This has been in Judy AI Lab's handbook since Day 1.

Fifth, **small multi-module beats giant single files**. Target 200-400 lines per file, max 800, split by function/domain. AI editing a 2000-line file triggers all kinds of hallucinations, but editing a 300-line small file almost never出错.

## Not Done Yet: 2 Things—Cost vs Value Tradeoffs

Two things enterprises do that Judy AI Lab deliberately paused.

One is **full observability stack** (full-chain tracing of every AI call's input/output/cost/latency). Anthropic's engineering culture logs raw analysis on every tool call—necessary when your team is huge. But Judy AI Lab only has five Agents plus a few cron jobs; adding this layer would eat extra maintenance cost. Right now logs + Linear cards + Telegram notifications work fine.

The other is **formal RFC process** (Request for Comments, written proposals before major design changes). Enterprises use RFC to blockAgentic tech debt (hidden debt from rushing with AI and cutting corners). For a one-person company'sShort decision cycles, formal RFCs actually bottle-neck momentum. Right now we use Linear cards + SHARED_TASK_NOTES instead.

## Replicable for Solopreneurs: 3 Minimum Playable Moves

No Anthropic scale needed—one person plus one AI can run it.

**First, write gates before code**. Even if it's just three: touching .env needs confirmation, touching deployment needs confirmation, touching payments needs confirmation. Put it in CLAUDE.md—every time AI starts up, it'll read it in.

**Second, create a Linear card for every task** (or GitHub Issues work too). Give AI dispatch, self-review, reporting, and paper trails somewhere to live. Without a task tracking system, AI forgets what it did pretty quick.

**Third, reserve 30 minutes daily for humans**. Read AI reports, make key decisions, independently rerun one thing. AI doesn't get tired, but AI won't take responsibility for you either.

Run this for 30 days and you'll find Vibe Coding isn't about showing off—it's about locking in the rhythm of "human decides, AI executes." What took Anthropic employees months to converge on, a one-person company can pick up in a month.

The only difference is whether you're willing to carve out that 30 minutes.

## References

- [Vibe Coding 團隊規範：在 AI 編程時代守住 SDLC 的工程紀律 - 小惡魔 - AppleBOY](https://blog.wu-boy.com/2026/05/vibe-coding-team-guideline-zh-tw/)
- [AI新職人〉Vibe Coding寫出近百工具，陳盈臻：我沒學會寫程式，但學會跟 AI 對話|數位時代 BusinessNext](https://www.bnext.com.tw/article/91046/ai-new-professionals-guide)
- [Vibe Coding 跨入實體世界：從寫軟體到造硬體原型，Lovable、Anthropic 相繼卡位](https://techorange.com/2026/05/15/vibe-coding-hardware/)
