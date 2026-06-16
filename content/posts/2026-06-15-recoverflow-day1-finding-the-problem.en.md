---
title: "Why I Don't Chase Every Invoice — Recoverflow Dev Diary Day 1"
date: "2026-06-15T10:00:00+09:00"
draft: false
author: Judy
summary: "I built an AI agent system at a hackathon to chase overdue invoices for small businesses. Why this problem, why not every invoice is worth chasing, and how the Pre-flight Agent decides whether a case is 'worth it' or 'let it go'."
description: "Recoverflow Dev Diary Day 1. An 8-agent collection system for small businesses with cross-border receivables. Pre-flight routes every case — under $3K goes Lite ($0.006/case, token-only), $3K–$40K runs the full In-Spot pipeline, over $40K gets referred to an attorney. No case is rejected."
categories:
  - "AI Engineering"
  - "Team Stories"
tags:
  - "Recoverflow"
  - "AI Agent Development"
  - "B2B Receivables Collection"
  - "Cross-border Collection"
  - "fintech"
  - "multi-agent"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "What kind of AI system is Recoverflow?"
    a: "Recoverflow is a multi-Agent collaborative AI collection system designed specifically for small businesses to handle cross-border receivables collection."
  - q: "Do you accept cases under $3,000?"
    a: "Yes — every case gets accepted. The $3,000 line is a routing decision, not a rejection cutoff. Under $3K routes to Lite mode ($0.006/case, LLM tokens only), skipping the $480 attorney-backed demand letter. The goal is still 70% recovery, just at a cost that makes economic sense."
  - q: "How does Pre-flight Agent determine if a case is worth chasing?"
    a: "It analyzes invoice amounts, customer history, dispute types, and other data to give three path recommendations: In-Spot normal collection, Lite simplified process, or referral to an attorney."
  - q: "What kind of businesses is this system suitable for?"
    a: "Any small business or trader with cross-border receivables. Cases under $3K go through Lite mode; the sweet spot for the full In-Spot pipeline is $3K–$40K."
series:
  - "Recoverflow Dev Diary"
---

This hackathon (lablab Band of Agents Hackathon, 6/12-19) is about multi-agent enterprise workflows. That means building a multi-agent system where agents can coordinate with each other, pass context, and split up work to complete a task.

Honestly, what I wanted to build at first was a solo founder architecture — like a "one person can run a whole company" universal assistant. Slack messages get automatically routed, meetings get auto-summarized, to-dos get scheduled, client replies get drafted for you.

Sounds cool, right?

But after doing some market research, I found out it's already a red ocean. Notion, Lindy, Relevance AI, all those GPT-wrapped solo founder assistants — every solo founder I know already has 2-3 tools on their desk. Giving them another one just makes them annoyed TT

So I went back to find a problem again...

---

## Finding the Gap from Family Background

My mom's a finance accountant, did it her whole life. My aunt is too. I used to run a small trading company in Korea, doing cross-border procurement.

So in our family, we have a common language when it comes to "not getting paid back"~

When I was doing trade, the hardest part wasn't getting orders or shipping — it was collecting payment.

Time zone is the first enemy — if the client's in Europe and I'm in Asia, by the time I wake up they're off work, by the time they're at work I'm asleep, one email exchange takes at least 48 hours. The second is phone collection calls — you don't know when the right contact at their company will pick up, don't know if they'll be friendly or annoyed when they do, don't know what words you can say and what words will make them blow up... the psychological pressure is really high. The third is legal — if there's a problem with a cross-border invoice, do you look at the buyer's local law, the seller's local law, or the arbitration clause in the contract? Just figuring that out takes a whole week.

Going back and forth, it's really annoying.

And usually the ending is: you grit your teeth and write the email yourself, make the call yourself, get angry yourself, deal with it yourself, and decide for yourself whether to just let it go.

So I interviewed my mom and aunt, asking how they handle overdue payments in their companies now.

The answer was consistent: **no good tools**. Either they manually track with Excel, or they hand the case to a lawyer, or they just swallow the loss and move on. Nothing in between.

---

## No One in the Middle

I also browsed r/smallbusiness and r/sweatystartup on Reddit for posts about "customer won't pay". Hundreds per week.

> "Customer says cash flow issues, already dragged two months, every chase is met with 'next week', next week becomes the next week after that"
>
> "40K invoice, customer suddenly says quality issues, but the acceptance form was already signed"
>
> "Don't want to tear things apart, but this money is my next month's rent"

The common thread in these stories: **the money isn't big, but it's life or death for the person**.

What about lawyers? Lawyers' contingency starts at 30-40%, and lawyers only want cases in the five figures. Five thousand, eight thousand, twenty thousand — these cases, lawyers just think are too much trouble.

What about collection agencies? True, there are a lot in the US. But their business model is "dumbly take all cases and run them through the same process". $2,000 case and $20,000 case use the same SOP — call, send letters, report to credit bureau. The result is two extremes: either they use brute force methods to recover the $2K (FDCPA complaints and TCPA fines flying everywhere), or the case gets stuck in queue for six months with no one touching it.

No one in the middle.

Middle is exactly those cases my mom and aunt encounter at work.

Middle is exactly those cases I encountered when running my trading company.

Middle is every small business owner posting hundreds of times a day on Reddit.

---

## "Finding the Right Person Matters More Than Doing Things Right"

"Can I build an AI collection system that only helps these people?"

This idea spun around in my head for a night. But I didn't jump straight into building, because I knew once I start, I'll get stuck in product design and lose the ability to ask myself questions.

So I first gave myself 2 questions:

**First question: How do you know which cases you can help and which you can't?**

**Second question: For the ones you can't help, what do you tell them?**

These two questions hit hard.

Because most of these systems are designed around the thinking "we take all cases — the agent runs anyway, so we don't have to do work". But applying this logic to collection becomes just like existing collection agencies — take a $2K case in, recover $500, subtract fees client gets $200 — worse than not chasing at all.

So I decided, the first agent in this system isn't writing letters or making calls — it's **figuring out if this money is worth chasing**.

I called this agent Pre-flight.

---

## Three Paths: In-Spot / Lite / Attorney Recommended

When Pre-flight Agent gets a contract and invoice, the first thing isn't to spin up the whole process — it's to do three-way routing first.

### Path One: In-Spot ($3,000 ~ $40,000, normal disputes)

This is the sweet spot. Where lawyers won't touch and collection agencies will mess up. Full 8 agents run:

- Investigator looks up your history with this customer
- Diplomat writes the first friendly-but-has-weight letter
- Voice Agent makes real two-way phone calls to get commitment dates
- Concierge runs every external action by you for approve first
- Tone Coach watches in the background for any language that might cross FDCPA red lines

This is Recoverflow's main stage — the next diary entries will break each one down.

### Path Two: Lite (amount under $3,000)

We don't reject small cases — we route them through Lite mode.

The $3,000 threshold isn't "we won't take your case." It's "we won't route your case through a $480 attorney-backed demand letter when the math doesn't work."

You might ask: "Wait, aren't you guys AI? How much can AI cost?"

I thought the same. Let me break down what the In-Spot full flow actually costs — because that's where the $3K line comes from:

- **Voice Agent one call**: about $0.5 (5 minutes × $0.1/min)
- **Diplomat writing a letter**: almost free (token cost)
- **Formal demand letter**: about $480 per letter — this isn't something AI can just write and send, it's a version backed by our partner law firm that can be used as evidence in court, that's where the legal cost sits
- **Plus Investigator checking history, Concierge approving every step, Tone Coach monitoring compliance** — token costs accumulate

One In-Spot full flow case runs about **$400 ~ $500**.

If your invoice is $2,000 and we ran the full pipeline, collection costs alone eat **25%** of it. Even if you recover, you'd end up with less than just writing it off.

That's what the $3K line is really about.

Lite mode costs **$0.006 per case** — just LLM tokens. Compare that to a $480 attorney letter. The math flips entirely.

So our Lite mode only runs the part that actually makes sense at this cost level:

Diplomat sends a **Day-7 reminder** with a **single multi-channel payment page** attached — credit card, Stripe, ACH, wire transfer all on the same page so the customer can pick whichever they prefer. No voice calls, no attorney-backed demand letter, case closes at Day 7 if unpaid. Industry benchmarks for similar in-house cadence flows land around **70%** recovery — that's our target.

If they pay, we win.

If they don't, we accept the loss (system marks it `lite_writeoff`) and don't escalate further. We'll directly tell you: "This one is better handled yourself — small claims court or a write-off. Here's why."

Not fun, but honest.

### Path Three: Attorney Recommended (amount over $40,000)

For this bracket, lawyers' contingency fee works out cheaper than us, and they have subpoena power — can check the other company's assets, bank accounts. We can't do that.

So for this kind of case, Pre-flight directly says: "We recommend you find a lawyer, here are two we've worked with before, their contingency structure is like this."

We don't take money.

---

## The Cost of Being Honest with Small Businesses

I know this design isn't pretty from a business model perspective.

If I forced every Lite case through the full pipeline and took Attorney Recommended cases instead of referring them out, my revenue could triple. But the result would be going back to the old collection agency way — burning small clients with costs higher than their invoices, and not having the legal tools to actually help big clients.

That's not why I built this system.

I want to build something small business owners would recommend to their friends.

When you think about it clearly, a lot of cases that seem "should take" are actually "shouldn't take".

Truly good products were never about covering everything — they actually cut to the pain point and really solve it!

After interviewing my mom and aunt, I decided on this problem...

---

## How the Whole System Is Thought Through

Back to the hackathon theme — multi-agent enterprise workflows, meaning letting multiple AI assistants divide labor and collaborate to complete a business task.

What I wanted to build isn't "one super AI that chases payments for you" — it's **a small team**: each agent (agent, think of it as an AI assistant that only does one thing) only does one thing, does it really well, then passes context to each other and coordinates with a state machine (a little notebook tracking where this case is in the process).

The whole Recoverflow has 8 agents, split into three layers:

**Layer One — Gatekeeper**

- **Pre-flight**: The first agent to see a case. Doesn't write letters or make calls, only responsible for deciding "should this case enter the main flow". This diary entry from start to finish is all about this one.

**Layer Two — Doers**

- **Investigator**: Looks up your history with this customer, finds patterns (do they always drag? Any emergencies? Did the contract miss the late fee clause?)
- **Diplomat**: Writing letters. From friendly reminders, formal notices, to final demand letter — tone escalates as the case progresses
- **Voice**: Making calls. Two-way conversation, can understand "pay next week" and also press for "which day, in what way"
- **Payment**: After they agree to pay, Stripe checkout link / wire transfer guidance all in one

**Layer Three — Guardians**

- **Concierge**: Your approve button. Every external action — Pre-flight routing, Diplomat's letter, whether Voice calls, whether Escalator escalates — all gets sent to you to press yes before going out
- **Tone Coach**: Watching in the background constantly. Every sentence Diplomat writes, every word Voice says gets checked by it — crossing FDCPA red lines or too aggressive tone gets blocked and rewritten in real time
- **Escalator**: The escalation layer when case enters escalation (e.g., the other party is completely unresponsive, going lawyer route)

The core idea of this architecture: **doers need to be strong, but more importantly, gatekeeper and guardian need to be hard**.

Most agent system designs are "give doer a super strong prompt, expect it to get there in one go". But this system's bet is exactly the opposite — I'd rather Diplomat writes so-so, as long as Tone Coach is always on guard; I'd rather the process be one step slower, as long as Concierge shows you every step; I'd rather reject 80% of cases, as long as Pre-flight tells the truth first.

Because in collection, one mess-up isn't "the user finds it unhelpful" — it's FDCPA complaints, it's getting resented by clients, brand trust goes to zero.

That's also why the problem is called **Recoverflow** instead of Collector — what I want to recover isn't just the money, but the dignity small business owners get worn down by during the collection process.

---

Next entry I'll write about how our Voice Agent changed from "one-way notification" to "two-way real conversation" — in between I made a phone call myself and hit a bug, and rewrote the prompt on the spot for two hours.

That's another interesting story...
