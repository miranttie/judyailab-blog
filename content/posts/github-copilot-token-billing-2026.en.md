---
title: "GitHub Copilot Switches to Token-Based Billing in June: How Will Your Bill Change?"
date: "2026-04-30T08:00:00+00:00"
draft: false
author: Judy
summary: "GitHub Copilot is shifting from a subscription model to AI Credits usage-based billing starting June 2026. 1 Credit equals $0.01. Code completions remain free, but Chat, Agent Mode, and Code Review all charge by token consumption. Monthly fees stay the same, but usage predictability decreases. This article organizes plan quotas and important notes."
description: "GitHub Copilot will fully switch to AI Credits usage-based billing in June 2026. This article analyzes the differences between the old and new systems, plan quotas, free vs paid features, and provides a step-by-step guide to checking your preview bill in May, helping developers evaluate if they need to purchase additional Credits."
categories:
  - "AI Engineering"
tags:
  - "GitHub Copilot"
  - "AI Credits"
  - "Token Billing"
  - "Developer Tools"
  - "Copilot Pro"
  - "AI Coding Assistant"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
faq:
  - q: "What is GitHub Copilot's new AI Credits billing model?"
    a: "Starting June 1, 2026, Copilot switches to AI Credits usage-based billing, charging by input, output, and cached token counts. 1 AI Credit = $0.01 USD. The old Premium Request Units calculation is no longer used."
  - q: "Which Copilot features remain free?"
    a: "Code Completions and Next Edit Suggestions are completely free and don't consume any AI Credits."
  - q: "How many AI Credits does Copilot Pro include monthly?"
    a: "Copilot Pro costs $10/month and includes 10 AI Credits. Pro+ costs $39/month and includes 39 AI Credits — exactly matching the monthly fee."
  - q: "What should I do in May?"
    a: "GitHub will launch the Preview Bill feature in early May 2026. You should check your preview bill to estimate costs under the new model, and confirm whether you want to opt out of AI training data to protect your code privacy."
  - q: "Are there any extra allowances for business plans?"
    a: "Business plan users get an additional 30 Credits per person per month from June to September. Enterprise plan users get 70 Credits per month as a transition subsidy."
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
lastmod: 2026-05-03T07:02:22+00:00

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

> **TL;DR** Starting June 1, 2026, GitHub Copilot switches from subscription-based to AI Credits usage-based billing (1 Credit = $0.01). Code completions stay free, but Chat, Agent Mode, and Code Review all charge by tokens. Monthly fees remain the same, but once Credits are used up, that's it. Check the preview bill in early May to see if your usage will exceed your quota.

---

## Your GitHub Copilot Bill Works Different Starting June

If you're using GitHub Copilot, there's something you need to figure out before the end of May.

GitHub announced that starting **June 1, 2026**, all Copilot plans will switch from fixed subscription to "AI Credits usage-based billing" — meaning you pay for what you use, token by token.

The subscription fee itself isn't going up, but the entire billing "logic" has changed. Developers are saying: "You're paying the same money, but might get less." That's not an exaggeration — it really depends on how you use it.

This article breaks down the most important things you need to know.

---

## Why the Change? What Are AI Credits?

Previously, Copilot's paid features (Chat, Code Review, etc.) were calculated using "Premium Request Units (PRUs)" — each action consumed a fixed number of PRUs, regardless of how long your conversation was or how heavy the model was.

The new system changes that.

**AI Credits directly correspond to token usage:**
- Input tokens + output tokens + cached tokens all count toward billing
- Different models have different rates (the stronger the model, the more it burns)
- **1 AI Credit = $0.01 USD**

GitHub's CPO Mario Rodriguez explained the reason for this change: "A short Chat question might consume the same resources as a multi-hour automated coding session — that's unfair to everyone."

The new system makes billing closer to actual compute costs, but for users, the predictability of the old "fixed cost" is gone.

---

## How Many AI Credits Do Each Plan Include?

**Good news: monthly fees haven't gone up.**

| Plan | Monthly Fee | Included AI Credits |
|------|------------|---------------------|
| Copilot Pro | $10/month | $10 Credits |
| Copilot Pro+ | $39/month | $39 Credits |
| Copilot Business | $19/user/month | $19 Credits |
| Copilot Enterprise | $39/user/month | $39 Credits |

Each plan includes Credits equal to the monthly fee. Once you run out, paid plans can purchase additional Credits. If an admin sets a usage limit, once Credits hit zero, you won't be able to use advanced features anymore.

> **Important:** GitHub explicitly states that "fallback functionality will no longer be available." When Credits were low before, Copilot might automatically switch to a cheaper model to keep serving you. Starting in June, once Credits are gone, they're gone — no automatic downgrading.

---

## What's Free? What Consumes Credits?

This is the most important list.

### ✅ Doesn't Consume AI Credits (Free)
- **Code Completions** — the real-time suggestions as you type, completely free
- **Next Edit Suggestions** — predicts the next edit location, free

### 🔴 Consumes AI Credits (Billed by Token)
- **Copilot Chat** — every conversation counts
- **Multi-step Coding Sessions** (Agent Mode) — token usage can be very high
- **Code Review** — starting in June, also consumes GitHub Actions minutes
- **All features using advanced models** (GPT-4o, Claude 3.7 Sonnet, etc.)

If you mostly use Copilot for code completions, the impact is relatively small. If you heavily use Chat or let Copilot run long workflows, you'll need to seriously evaluate.

---

## How to Save the Most: 2 Steps You Should Take Before June

### 1. Check the "Preview Bill" in Early May

GitHub announced that in **early May 2026**, they'll launch a "Preview Bill" feature on the billing overview page ([github.com Billing Overview](https://github.com)), letting you see estimated costs under the new billing model before it officially launches.

This is your only chance to see, without spending money, how your current usage habits translate to costs under the new system. **You must check it before May ends.**

### 2. Confirm Whether to Opt Out of AI Training Data

GitHub quietly updated their policy on **April 24, 2026**: interaction data from Free, Pro, and Pro+ plans will be used to train AI models by default, unless you actively opt out.

If you care about code privacy, go to your GitHub settings now to confirm. Enterprise plan users are not affected — their default is to not use interaction data for training.

---

## Enterprise Users Get a Buffer, Individual Developers Need to Watch Themselves

For Business and Enterprise customers, GitHub is offering a 3-month "transition subsidy":

- **Business** plan: June 1 to September 1, additional $30 Credits per person per month
- **Enterprise** plan: June 1 to September 1, additional $70 Credits per person per month

Starting September 1, it goes back to normal plan quotas.

Additionally, enterprise admins will get finer-grained usage control tools, allowing them to set:
- Overall Credits limits for the organization
- Limits for each cost center
- Per-user limits

This is super useful for large organizations to prevent anyone from racking up an exploding company bill by unlimited Credits usage.

---

## Is This Change Good or Bad for You?

If you mainly rely on Copilot for code completions, this change has almost no impact — completions stay free.

If you heavily use Chat, Agent Mode, or let Copilot run complex multi-step tasks, you'll need to pay attention. The $10/month Credits can deplete faster than you might think, especially when using stronger models.

The general consensus in the developer community is: "You're paying the same, but might get less." But GitHub's stance is that this makes billing fairer — light users no longer subsidize heavy users' compute resources.

Either way, **checking the preview bill in early May is the most important thing right now**. Before the numbers come out, all the worry or relief is just speculation.

---

---

## Frequently Asked Questions (FAQ)

**Q1: Is code completion really completely free?**
Yes. GitHub explicitly states that Code Completions and Next Edit Suggestions don't consume AI Credits and will remain free after June.

**Q2: What happens when Credits run out?**
Advanced features (Chat, Agent Mode, Code Review) will stop working. Starting in June, there's no automatic fallback to cheaper models. You can purchase additional Credits or wait for the next billing cycle reset.

**Q3: Do different models consume the same amount of Credits?**
No. The stronger the model (like GPT-4o, Claude 3.7 Sonnet), the higher the rate — the same conversation length will consume more Credits. You need to consider the trade-off between performance and cost when choosing models.

**Q4: I'm an enterprise user, how long is the transition subsidy?**
Business plan gets an additional $30 Credits per person per month, Enterprise gets $70 Credits per person per month. The subsidy period is June 1 to September 1, then it returns to normal plan quotas.

**Q5: How do I opt out of AI training data collection?**
Go to GitHub Settings → Copilot → find the "Allow GitHub to use my interactions" option and turn it off. Enterprise plans don't participate in training by default, so no extra action needed.

**Q6: Will PRUs (Premium Request Units) still be used?**
No. Starting June 1, PRUs are completely replaced by AI Credits. PRUs will no longer be used for any billing calculations.

---

## Further Reading

- [GitHub Official Announcement: Copilot is moving to usage-based billing](https://github.blog/news-insights/company-news/github-copilot-is-moving-to-usage-based-billing/) — complete billing change explanation
- [GitHub Docs: Usage-based billing for individuals](https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-individuals) — individual plan billing details and Credits calculation
- [GitHub Changelog: Code Review will consume Actions minutes](https://github.blog/changelog/2026-04-27-github-copilot-code-review-will-start-consuming-github-actions-minutes-on-june-1-2026/) — detailed explanation of Code Review dual billing

---

*Sources: [GitHub Blog](https://github.blog/news-insights/company-news/github-copilot-is-moving-to-usage-based-billing/), [GitHub Changelog](https://github.blog/changelog/2026-04-27-github-copilot-code-review-will-start-consuming-github-actions-minutes-on-june-1-2026/), [GitHub Docs](https://docs.github.com/en/copilot/concepts/billing/usage-based-billing-for-individuals), April 2026.*
