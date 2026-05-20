---
title: "AI Self-Review Pipeline: How We Got Agents to Review Their Own Code Before Sending PRs"
date: "2026-03-14T05:01:08+00:00"
draft: false
author: "Judy"
summary: "When an Agent says it's done, that doesn't mean it's actually done — this is something we've learned the hard way at Judy AI Lab. Silent failures in scheduled tasks, a 40% rejection rate on deliveries forced us to design a five-stage self-review loop: from spec confirmation, implementation, code review, fix, to Xiaoyue's QA scoring. After going live for over a month, the rejection rate dropped from 40% to 10%."
description: "When an AI Agent says 'it's done,' what's your first reaction? At Judy AI Lab, our experience shows: no matter what it says, first check if it's gone through the five stages. Starting from real pitfalls, sharing the design logic behind multi-Agent quality gates — acceptance criteria defined by humans, let Agents achieve them, get the order right and the results will follow. Keywords: AI Agent Quality Management, Automated Code Review, Multi-Agent Systems."
categories:
  - "Real Stories"
tags:
  - "AI Agent"
  - "Code Review"
  - "Multi-Agent Systems"
  - "Quality Management"
  - "Automation"
series:
  - "AI Agent Complete Guide"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
lastmod: 2026-05-13T05:22:58+00:00
faq:
  - q: "What is an AI self-review pipeline and why do agents need one?"
    a: "An AI self-review pipeline is a multi-stage quality gate that AI coding agents must pass before their work can be marked complete. Agents optimize for 'task complete' as their objective function, so without explicit acceptance criteria they take the shortest path to what they think is the endpoint. That means edge cases get skipped, tests don't get written, and silent failures slip into production. A self-review pipeline closes the gap between 'the code runs' and 'the code is production-ready' by encoding human acceptance standards into machine-checkable gates."

  - q: "How do you stop an AI agent from saying 'done' when the work isn't actually finished?"
    a: "Stop treating the agent's self-report as authoritative. At Judy AI Lab we require every output to pass five sequential gates before merge: spec confirmation, implementation, self-review, peer-agent review, and human acceptance. The agent cannot mark its own task done. Each gate has explicit pass criteria—tests written, edge cases enumerated, error messages localized, logs verified. If any gate fails, the task returns to the previous stage with concrete feedback. This converts subjective 'done' into objective checkpoints the agent literally cannot skip."

  - q: "What are the five quality gates in a multi-agent code review system?"
    a: "The five gates are: (1) Spec Confirmation—agent restates requirements and acceptance criteria before coding; (2) Implementation—code is written against the confirmed spec; (3) Self-Review—agent runs its own checklist for edge cases, tests, and localization; (4) Peer Agent Review—a second agent independently audits the diff against the spec; (5) Human Acceptance—the operator runs the feature end-to-end. Each gate produces an artifact (spec doc, diff, checklist, review notes, acceptance log) so failures are traceable and the loop never collapses into a single subjective judgment."

  - q: "What are the most common mistakes when delegating coding tasks to AI agents?"
    a: "Three mistakes dominate. First, accepting 'it's done' at face value—agents report completion based on their own definition, not yours. Second, defining tasks by feature description instead of acceptance criteria—'add scheduled task' is not the same as 'add scheduled task with error logging, retry logic, and localized alerts.' Third, skipping the independent review step—the same agent that wrote the code is the worst judge of whether it's correct. Fix these by writing testable acceptance criteria upfront, requiring an independent reviewer agent, and always running the feature yourself before merge."

  - q: "How is multi-agent code review different from human pair programming or traditional CI?"
    a: "Traditional CI catches syntax errors, type mismatches, and failing tests, but cannot judge whether the implementation matches intent. Human pair programming catches intent but doesn't scale across dozens of parallel agent tasks. Multi-agent review sits between them: a reviewer agent reads the spec, diff, and tests, then audits for missing edge cases, untested branches, localization gaps, and silent failure modes. It runs in seconds, scales horizontally, and produces a written review artifact. CI still runs underneath—the agent review adds the judgment layer CI cannot provide."

  - q: "Who should adopt an agent self-review pipeline, and when is it overkill?"
    a: "Adopt it if you run multiple coding agents in parallel, ship to production daily, or have caught silent failures that wasted hours of debugging. Small solo projects with a single human reviewing every diff don't need the overhead—you are the gate. The threshold is roughly: more than two agents running concurrently, or any task touching scheduled jobs, payment flows, or external APIs. Anywhere a silent failure costs more than the review overhead, the pipeline pays for itself within the first prevented incident."

  - q: "What are the limits and risks of relying on agents to review other agents?"
    a: "Reviewer agents share blind spots with implementer agents—both can miss the same class of bug if trained similarly. Mitigate this by using different models for review and implementation, requiring the reviewer to run tests rather than just read code, and keeping a human in the final acceptance gate. Never let agent-only review approve changes to authentication, payment, secrets, or destructive operations. Track reviewer false-positive and false-negative rates over time; if the reviewer rubber-stamps everything, the gate has collapsed and needs sharper acceptance criteria."

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

Last month, Ada finished a feature module, and J reported to me, "It's done, can merge into main." I was a bit nervous right away — it's not that I don't trust Ada, but we know exactly how much that statement costs.

As expected, when J checked, the core logic was correct, but edge cases weren't handled, error messages were in English (our product has a Chinese interface), and most importantly — not a single line of test.

This wasn't an isolated case. During the early days when our Agent system first started running, we encountered this almost every week: tasks were handed out, reported as "done," but when we tried to use them, problems surfaced.

The issue isn't that Agents aren't capable enough — it's that "done" was never consistently defined.

## When an Agent Says "Done," That's When I Get Most Nervous

Our worst incident was a scheduled task script.

Ada said it was ready, J said it was tested, but it ran for three days online before someone discovered — under certain conditions, it would fail silently. No error, no notification, just quietly doing nothing.

Three days.

That time we spent almost twice as long tracking down where the problem was, because there were no error messages, no traces at all — just wrong results. If someone had just taken an extra look at edge cases before delivery, we never would have gotten to this point.

But "taking an extra look" wasn't defined as part of the task, so the Agent wouldn't do it.

## "It Works" and "It's Done" Are Very Different

This made me realize something: people have the same problem when writing code — "the feature runs" doesn't mean "it's ready for production." It's just that people, based on past experience with pitfalls, automatically fill in those "things that should just be done": checking edge cases, writing tests, glancing to see if anything was missed.

Agents don't have this instinct. Their objective function is "complete the task" — if the task definition isn't clear, they'll take the shortest path to what they think is the endpoint.

So the problem isn't that the Agent isn't smart enough — it's that our rules have gaps. It just faithfully follows the rules we gave it.

This realization made me stop and think: instead of constantly going back and asking the Agent to fix things, why not make "what counts as done" clear from the start?

## So J Designed a Closed Loop

Here's J's approach: no Agent output can be directly marked as "done" — it has to pass through five gates first.

**Spec Confirmation** is the first gate. Before the task starts, J aligns the acceptance criteria with the delivering Agent — not just the feature description, but also "what counts as a failure," "what edge cases exist," and "what proof it needs to show it's complete." After adding this gate, we realized how vague our previous task descriptions were.

The second gate is **Implementation**. The Agent builds according to the spec. With the spec in place, the Agent knows what to reference while building, no guessing required.

The third gate is **Code Review**. After completion, J brings in another Agent to review the code. Its job is to find bugs, edge case issues, places where the spec wasn't met. Not a subjective "how well did you do" evaluation — it's a checklist: "Does the spec say this should be done? Did you do it?"

The fourth gate is **Fix**. If the code-reviewer finds issues, send it back to fix, then run review again. This loop can run several rounds until no new issues surface.

The fifth gate is **Xiaoyue QA**. Xiaoyue is our QA researcher; she verifies from a user perspective whether this feature actually solves the problem, gives a score, and anything below 8.5 gets sent back.

Only after passing all five gates is it considered complete.

J said this was too slow at first. I said, let's calculate how much time we're spending fixing what the Agent messed up.

After calculating, she didn't say anything. (That's a management moment, lol)

## The Numbers Speak

This process started running steadily about a month and a half ago.

The most obvious change: tasks that J marks as "done" — the percentage that me or Judy send back after delivery — dropped from around 40% to under 10%. The ones that get sent back are almost all cases where the spec was unclear from the start, not quality issues.

Another unexpected finding is that Ada actually got faster. I thought adding all these gates would slow her down. But because the spec was clear from the start, she doesn't guess while building, doesn't realize halfway through that direction went off track and need to redo everything.

Once, the code-reviewer caught a logic error at the third gate. If it hadn't been caught until going live, J estimated it would take 4-5x the time to handle. The time saved — that's roughly enough to build three new features.

I don't know if that multiplier is always that accurate, but measuring it is better than not measuring it.

## When an Agent Says It's Done, That's Not the End

Now every time I see J report "delivery complete," my first reaction is still to check if all five gates were passed. This habit's a bit paranoid, but it gives me more peace of mind.

Lately I've been thinking about this — the core issue isn't really an AI problem, it's an "acceptance criteria" problem. Before, we let Agents define what "done" means for themselves, and of course there were gaps every time. Now we define it first, and the Agent achieves it.

Get the order right, and the results will follow.

That's what I was thinking when organizing our team processes recently.


<!-- product-cta -->
{{< product-cta product="commander" >}}

## References

- [Building your own PR reviewer with coding agents](https://www.huuhka.net/building-your-own-pr-reviewer-with-coding-agents/)
- [How to Set Up Automated Code Review with Multiple AI Agents | MindStudio](https://www.mindstudio.ai/blog/automated-code-review-multiple-ai-agents/)
- [How to review AI generated PRs](https://thoughtbot.com/blog/how-to-review-ai-generated-prs)
