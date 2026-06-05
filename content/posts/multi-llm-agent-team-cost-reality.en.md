---
title: "Running 4 LLMs Simultaneously: A Real Multi-Agent Team's Selection and Cost Breakdown"
date: "2026-03-13T05:01:49+00:00"
draft: false
author: Judy Chen
summary: "A real AI team running 4 LLMs at the same time. With a monthly budget of just $255, they route tasks to Claude for complex architecture, MiniMax for translation, and Gemini for QA testing. The 60x price difference proves: task fit matters more than model rankings."
description: "The real cost and lessons from running Claude, MiniMax, and Gemini simultaneously. Use Claude for architecture decisions, MiniMax for translation, Gemini for QA research—the 60x price difference tells you that task fit matters more than model rankings. A multi-agent AI team's LLM selection story."
categories:
  - "Team Stories"
  - "AI Engineering"
tags:
  - "Multi-Agent"
  - "LLM Selection"
  - "AI Agent"
  - "Claude"
  - "MiniMax"
  - "Gemini"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "How much budget does a multi-agent AI team need per month?"
    a: "The author's team has a monthly AI budget of around $255, mainly for Claude subscriptions and other model subscriptions."
  - q: "What tasks are different LLMs best suited for?"
    a: "Claude is great for architecture decisions and code development; MiniMax is ideal for copy translation and data organization; Gemini excels at QA testing and large-scale data synthesis."
  - q: "What's the biggest challenge in multi-LLM collaboration?"
    a: "Format inconsistencies, latency differences, and different billing methods are the three main challenges—additional tools are needed to track usage and manage workflows."
  - q: "How do you decide which LLM to use?"
    a: "Don't look at benchmark scores—look at task requirements and cost-benefit. Use premium models for complex tasks, and cost-effective models for general tasks."
  - q: "Is MiniMax really 60x cheaper than Claude?"
    a: "According to the author's tests, MiniMax M2.5's API pricing is about 60x cheaper than Claude Opus, making it an effective way to significantly reduce costs."
hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
lastmod: 2026-05-25T11:26:34+00:00

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

Last month, J wrote a line in the patrol report: "Mimi translated 41 articles this week, and Claude's token bill didn't move."

I stared at that line for a moment.

Then I remembered—we moved translation tasks to MiniMax last month. 41 articles. Done almost silently.

That's when it hit me: running multiple LLMs simultaneously isn't some tech achievement. It's a practical answer that was forced out by costs, step by step.

---

## Not Tech Selection—It's All About the Numbers

For a while, I thought using the strongest model was the most time-saving approach.

Wrong. It's the most expensive one.

Our monthly AI budget is around $255—Claude subscription is the big chunk, for the parts J uses. J handles architecture decisions, code development, coordinating the entire agent team. These tasks have high error costs, and Claude Opus's reasoning ability delivers real ROI here.

But Mimi needs to整理 dozens of market articles, translate content, and generate drafts every week. Ada runs code reviews and product pages. If all of this went through Opus, the budget wouldn't hold up.

I looked it up: MiniMax M2.5's API pricing is about 60x cheaper than Claude Opus. 60x. Moving suitable tasks to MiniMax saves a significant amount each month, and the output quality for those tasks doesn't drop noticeably.

Gemini is what Xiaoyue uses—a paid Gemini CLI subscription, not the free version. I always have to clarify this because people assume it's the free OAuth one. It's a legitimately paid subscription. QA and research tasks have high volume, and the subscription is more cost-effective than running API calls.

These combinations weren't designed from the start. After a few months of testing, the bill forced me to figure it out one by one.

---

## Copy Translation, Code Development, QA Testing—Who Does What Isn't Guesswork

Let me get specific.

**J uses Claude** for architecture design, code development, and logically complex tasks. One mistake here means starting over, and the cost of fixing it is higher than the effort saved. Day-to-day development uses Sonnet, complex stuff gets Opus.

**Mimi and Ada use MiniMax** for copy translation, product page drafts, market intel整理, social posts. Speed matters, volume is high, and deep reasoning isn't needed. M2.5 delivers stable output on these tasks—formatting's occasionally a bit off, but within acceptable range.

**Xiaoyue uses Gemini** for QA test reports, competitive research, and large-scale data organization. Gemini's context window is huge—throwing a pile of data at it to synthesize conclusions is its strength, and the subscription version has consistent latency.

**Lily (on the content side)** uses Claude Sonnet for original articles, and MiniMax for translation and research. These two needs are very different. Running them separately with different models was confirmed through actual usage—not pre-designed, but discovered through trial and error.

---

## The Operational Reality of Multi-LLM Collaboration—Things Nobody Tells You About

Format inconsistency is the first pitfall.

Claude has its output habits, MiniMax has its own, Gemini has its own. When agents need to read each other's outputs, the three formats cause problems at the interface points. We didn't anticipate this at first. J had to add a parsing layer later to stabilize things.

Latency difference is the second pitfall. Claude Sonnet responds fast; Opus sometimes takes a while. MiniMax is usually quick, but occasionally slow during peak hours. Gemini subscription version barely lags. These differences cause surprises in automated workflows—an agent waiting too long means task chaining fails downstream. Automated scheduling needs to factor in latency buffers. We had to learn that the hard way.

Billing methods are completely different is the third pitfall. Claude and MiniMax are both subscription-based, but their usage quotas and calculation methods differ. Gemini is also subscription-based, charged monthly. All three have different usage limits, reset cycles, and overage handling. Integrating them for unified usage tracking isn't as intuitive as it sounds. We ended up building our own usage tracking tool to see the overall consumption picture.

These aren't major issues, but each one takes time to handle. Some of the cost savings from multi-LLM goes back into dealing with these.

---

## Leaderboards Tell You Who's Strongest, But Not Who's Best for Your Task

There was a period when I thought about standardizing on one model.

Then I did the math and dropped the idea.

Going all Claude Opus, the budget can't hold. Going all MiniMax, J's architecture decision quality drops, and error rates on complex tasks increase—fixing mistakes costs more than the savings. Going all Gemini, Traditional Chinese original content quality—I tried it, and there's a gap.

No single model can simultaneously achieve "good enough" plus "cheap enough" on all tasks. Benchmarks tell you which model performs best on which test set, but benchmarks don't tell you which model fits your language, your task volume, and how much budget you have left this month.

I don't know if our current setup is the optimal solution. But it's the answer that actually works after testing for a few months—the bills still look acceptable.

---

## References

- [Multi-agent LLMs in 2026 (+frameworks) | SuperAnnotate](https://www.superannotate.com/blog/multi-agent-llms)
- [AgentsNet: Coordination and Collaborative Reasoning in Multi-Agent LLMs](https://arxiv.org/html/2507.08616v1)
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)

---

## Further Reading

- [Building an AI Multi-Agent Team from Scratch: Our Real Experience](/posts/building-ai-agent-team/)
- [Three Frameworks to Turn AI from a Tool into Combat Power — An Agent's Inside Perspective](/posts/ai-agent-ceiling-trainer-perspective/)
- [AI Agent Always Deflects Responsibility? YES Discipline Engine Makes It Solve Problems on Its Own](/posts/yes-discipline-engine-ai-agent-quality/)
