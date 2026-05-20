---
title: "Anthropic's $100M Security Push: Glasswing & Mythos"
date: "2026-04-08T06:00:00+00:00"
draft: false
author: Judy
summary: "Anthropic launches Project Glasswing, investing $100M in AI credits and $400K in donations. Using the unreleased Claude Mythos Preview model, they discovered thousands of zero-day vulnerabilities in critical software worldwide, including a 27-year-old OpenBSD bug and a 16-year-old FFmpeg vulnerability."
description: "Anthropic announces over $100M for Project Glasswing security initiative, using the unreleased Claude Mythos Preview model to discover thousands of zero-day vulnerabilities within weeks, including a 27-year-old OpenBSD remote crash bug and a 16-year-old FFmpeg flaw. This article analyzes how the AI security era is impacting the industry."
categories:
  - "Announcements"
  - "AI Engineering"
tags:
  - "Anthropic"
  - "Claude Mythos"
  - "Project Glasswing"
  - "AI Security"
  - "Zero-Day Vulnerability"
  - "OpenBSD Vulnerability"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
series:
  - "Complete AI Agent Guide"
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
lastmod: 2026-05-13T05:51:50+00:00
faq:
  - q: "What is Project Glasswing and how much is Anthropic investing?"
    a: "Project Glasswing is Anthropic's AI-powered software security initiative, committing over $500 million total: $100 million in AI credits for partners to run vulnerability scans, plus $400 million in direct donations to open source security organizations. Named after the transparent-winged glasswing butterfly, the goal is to make software vulnerabilities visible across critical infrastructure. Partners include AWS, Apple, Google, Microsoft, NVIDIA, CrowdStrike, Palo Alto Networks, JPMorganChase, the Linux Foundation, and roughly 40 other organizations. Every vulnerability discovered must be disclosed to the industry, not hoarded."
  - q: "What is Claude Mythos Preview and how does it compare to Claude Opus 4.6?"
    a: "Claude Mythos Preview is Anthropic's most powerful unreleased model, built specifically for security research. On the CyberGym vulnerability reproduction benchmark, Mythos Preview scored 83.1%, while the strongest public model, Claude Opus 4.6, scored 66.6%—a 16.5-point gap. It is not available to the public and runs only inside Project Glasswing partner programs. The model autonomously locates, reproduces, and explains zero-day vulnerabilities in real-world C, C++, and protocol code, including bugs that survived decades of human and automated review."
  - q: "What real-world vulnerabilities did Claude Mythos Preview discover?"
    a: "Within weeks, Mythos Preview surfaced thousands of zero-day vulnerabilities in critical software. The two headline finds: a 27-year-old remote crash bug in OpenBSD, an operating system whose entire reputation rests on security hardening, and a 16-year-old memory-corruption flaw in FFmpeg, the video-processing library embedded in nearly every streaming, broadcasting, and media pipeline on the planet. Both bugs survived decades of human audits, static analyzers, and fuzzers. All findings have been responsibly disclosed to maintainers and patched before public announcement."
  - q: "Can developers or security teams access Claude Mythos Preview today?"
    a: "No. Claude Mythos Preview is not publicly released and is not available through the Anthropic API, Claude.ai, AWS Bedrock, or Google Vertex AI. Access is limited to Project Glasswing partners running coordinated vulnerability research on critical infrastructure. For now, public users should rely on Claude Opus 4.6 or Claude Sonnet 4.6 for code review and security analysis. Organizations that maintain widely-used open source projects or critical infrastructure can apply for Glasswing partnership and the $100M AI credit pool through Anthropic's partner program."
  - q: "What are the limits and risks of using AI to find zero-day vulnerabilities?"
    a: "Three real risks. First, dual-use: the same capability that patches OpenBSD can weaponize unpatched targets if model weights leak. Anthropic mitigates this by keeping Mythos Preview unreleased and routing findings through coordinated disclosure. Second, false positives at scale—thousands of flagged issues require human triage, and maintainers of small open source projects can be overwhelmed. Third, regression risk: rapid patches to 27-year-old code can break downstream dependents. Glasswing addresses this by funding maintainers directly and requiring industry-wide disclosure rather than private exploitation."
  - q: "How does Project Glasswing compare to bug bounty programs and traditional fuzzing?"
    a: "Traditional bug bounties wait for human researchers to report findings and pay per-bug, typically $500 to $50,000. Fuzzers like AFL and OSS-Fuzz run continuously but mostly catch shallow memory bugs. Glasswing operates at a different scale: one model, scanning the entire critical-software stack in weeks, finding logic bugs and protocol flaws that fuzzers miss. It complements rather than replaces bounties—bounties reward external researchers, while Glasswing pre-empts attackers by sweeping codebases before vulnerabilities are weaponized. Combined with the $400M open source funding, it shifts security economics from reactive to proactive."
  - q: "Who should pay attention to Project Glasswing right now?"
    a: "Three groups. Open source maintainers of widely-deployed C, C++, kernel, or protocol code should expect inbound coordinated disclosures and prepare triage capacity. Enterprise security teams running OpenBSD, FFmpeg, or any dependency in the Glasswing scan list should monitor CVE feeds closely over the next quarter and patch aggressively. AI and security investors should note that vulnerability discovery is now an AI-leverage market—the bottleneck shifts from finding bugs to fixing them, which favors maintainer-funding and patch-automation startups over traditional pen-testing firms."

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

April 7th, I woke up and scrolled through my phone, saw Anthropic dropped an announcement. Thought it was another model update, clicked in—

Turns out it wasn't a new model launch. They took a model that hasn't been released yet and scanned critical software worldwide, finding **thousands of zero-day vulnerabilities** in just a few weeks.

My first thought: wait, is this some sci-fi movie plot?

---

## Project Glasswing: A $100 Million Security Gamble

Anthropic named this initiative **Project Glasswing**, named after the glasswing butterfly (Greta oto)—a butterfly with nearly transparent wings. The message is clear: make software security transparent and visible.

The concrete commitments:

- **$100 million in AI credits**, available to partners for vulnerability scanning
- **$400 million in direct donations** to open source security organizations
- All discovered vulnerabilities must be shared with the industry

The partner lineup is impressive. AWS, Apple, Google, Microsoft, NVIDIA on the tech giant side; CrowdStrike, Palo Alto Networks, Broadcom, Cisco on the security side; JPMorganChase representing finance; Linux Foundation representing the open source community. Plus roughly 40 other organizations responsible for maintaining critical software infrastructure.

This isn't Anthropic doing this alone—they brought the entire industry along.

---

## Claude Mythos Preview: Anthropic's Strongest Card

The core weapon of this entire initiative is a model called **Claude Mythos Preview**. It's the most powerful model Anthropic has developed to date, and it's not publicly released yet.

Let's look at the numbers: On the CyberGym vulnerability reproduction benchmark, Mythos Preview scored **83.1%**, while the current strongest public model, Claude Opus 4.6, scored **66.6%**. A gap of over 16 percentage points—that's a pretty significant jump for a benchmark at this level.

But the numbers aren't the most shocking part. The shocking part is what it actually accomplished.

---

## Those Vulnerabilities Dug Up by AI

### The 27-Year-Old OpenBSD Vulnerability

OpenBSD's reputation in the security world doesn't need explaining—it's an OS known for security, with core developers spending decades on security hardening. And yet Mythos Preview found a remote crash vulnerability that had been there for **27 years**—anyone could remotely crash an OpenBSD machine.

27 years. How many security experts have looked at this code, how many automated tools have scanned it, and nothing was caught.

### The 16-Year-Old FFmpeg Vulnerability

FFmpeg is the underlying dependency for almost all video processing software—VLC, Chrome, you name it. Mythos Preview found a vulnerability that had been hidden for **16 years**, and here's the kicker—automated fuzzing tools had **hit this code over 5 million times** and never found the issue.

One look by AI and it spotted it.

### Linux Kernel Privilege Escalation Chain

Mythos Preview doesn't just find single vulnerabilities. It autonomously found **multiple vulnerabilities in the Linux kernel and chained them together**—from a regular user all the way to full control of the entire machine.

This ability to "find vulnerabilities → figure out how to chain them → build a complete attack path"—before this, that required top-tier red team members taking weeks or even months to accomplish.

And according to Anthropic, almost all of this was done **completely autonomously** by the model, without human guidance.

---

## Why Not Release It?

Anthropic is well aware of this model's double-edged nature. An AI that can find vulnerabilities can also be used to attack them. So Mythos Preview is currently only available to Glasswing partners and roughly 40 critical infrastructure maintenance organizations.

Their exact words: "At the pace of AI progress, such capabilities will eventually spread—potentially to actors who won't commit to secure deployment" (spread to actors who won't commit to secure deployment)."

Basically what they're saying is: we have this capability now, others will eventually have it too. Rather than wait for the bad guys to get it first, let's use it to patch the holes first.

Anthropic also revealed something—they discovered the first recorded predominantly AI-executed cyberattack: a Chinese state-sponsored hacker group used AI agents to autonomously infiltrate around 30 targets globally.

This isn't a theoretical threat. It's already happening.

---

## Shockwaves in the Security Industry

Wall Street's reaction was pretty direct. Major security companies like CrowdStrike, Palo Alto Networks, Zscaler, SentinelOne, Okta saw their stock prices **drop 5% to 11%**.

The investor logic is simple: if AI can autonomously find and fix vulnerabilities, where's the moat for traditional security companies?

But I think this reaction is a bit overblown. Glasswing is currently a defensive tool, and the vulnerabilities AI finds still need human developers to fix. In the short term, this is more of an upgrade catalyst for the security industry than a replacement. But long term, if AI can not only find vulnerabilities but also automatically patch them, that will definitely redefine the value chain of the entire industry.

---

## Significance for the Open Source Community

This might be the most important aspect of Glasswing. Linux Foundation CEO Jim Zemlin put it directly:

> "Open source software makes up the vast majority of code in modern systems... giving maintainers of these critical open source libraries access to next-generation AI models to proactively discover and fix vulnerabilities, Project Glasswing provides a viable path to change the status quo."

Open source software security has always been a structural problem. Maintainers are usually volunteers or small teams without resources for comprehensive security audits. But the code they write is depended on by commercial software worldwide. If the $100 million in AI credits can really help these projects do security scanning they couldn't do before, that's a tangible improvement.

---

## My Observations

As someone who works with AI Agent teams every day, my reaction to this news is complicated.

**The exciting part**: Claude series capabilities just jumped another level. Mythos Preview scoring 16 percentage points higher than Opus 4.6 on CyberGym means the next generation of public models should have significantly better reasoning and code understanding.

**The concerning part**: AI's ability to autonomously discover and chain vulnerabilities is a double-edged sword. Anthropic's choice to not release it publicly and use it only for defense is responsible. But as they themselves said, this capability will eventually spread.

**The practical part**: No matter how you feel about AI security, one thing is certain—if you're maintaining any critical software, it's time to take AI-assisted security auditing seriously. A vulnerability that went undetected by humans for 27 years, AI dug it up in a few weeks. This gap will only keep growing.

---

## Key Takeaways

| Item | Content |
|------|------|
| Program Name | Project Glasswing |
| Launch Date | April 7, 2026 |
| Investment | $100M in AI credits + $400K in donations |
| Core Model | Claude Mythos Preview (unreleased) |
| Benchmark | CyberGym 83.1% (Opus 4.6 at 66.6%) |
| Key Findings | Thousands of zero-day vulnerabilities (OpenBSD 27 years, FFmpeg 16 years) |
| Partners | AWS, Apple, Google, Microsoft, NVIDIA, CrowdStrike, etc. |
| Public Status | Partners only, not publicly released |

This is the most important announcement in the AI industry so far in 2026. Not because another stronger model was released, but because it was the first time AI demonstrated overwhelming advantage in real-world security—and chose to use that advantage for defense.

Anthropic's move deserves respect.

## References

- [Project Glasswing: Securing critical software for the AI era](https://www.anthropic.com/glasswing)
- [Project Glasswing: Anthropic's $100M Cyber Defense Push](https://decodethefuture.org/en/project-glasswing-anthropic-cybersecurity/)
- [Anthropic Allows Glasswing Partners to Share Mythos-Based Findings - Security Boulevard](https://securityboulevard.com/2026/05/anthropic-allows-glasswing-partners-to-share-mythos-based-findings/)
