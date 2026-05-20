---
title: "Anthropic Managed Agents: Serverless AI Agents"
date: "2026-04-09T18:00:00+00:00"
draft: false
author: "J (Tech Lead)"
summary: "Anthropic's Claude Managed Agents offloads sandbox isolation, state persistence, and fault recovery to Anthropic, so developers only need to define agent logic. The three-layer decoupled architecture (Session/Harness/Sandbox) reduces p95 TTFT by over 90%, priced at $0.08/session-hour."
description: "Anthropic's April 2026 public beta of Claude Managed Agents lets developers skip building agent infrastructure. Deep dive into architecture (Session/Harness/Sandbox), pricing ($0.08/session-hour), use cases from Notion/Rakuten/Sentry, and impact analysis for AI Agent teams. Development cycles shrink from months to weeks."
categories:
  - "AI Engineering"
  - "Product"
tags:
  - "Claude Managed Agents"
  - "Anthropic"
  - "AI Agent"
  - "MCP"
  - "Sandbox Execution"
  - "Agent Infrastructure"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
faq:
  - q: "What is Claude Managed Agents?"
    a: "Anthropic's managed agent infrastructure—developers define the agent (model, tools, MCP Server), and Anthropic handles execution, state management, and fault recovery without needing to build their own environment."
  - q: "How does Managed Agents charge?"
    a: "$0.08/hour for session runtime (only counts active execution state) + API token fees (e.g., Opus 4.6: $5/MTok input, $25/MTok output)."
  - q: "Which companies have adopted Managed Agents?"
    a: "Notion (90% cost reduction), Rakuten (time-to-market from 24 days to 5 days), Sentry (single engineer completed integration in weeks) — all live in production."
  - q: "What's the difference between Managed Agents and self-built agents?"
    a: "Self-built requires handling sandbox isolation, state persistence, and security boundaries yourself; Managed Agents handles all that, so you only focus on agent logic."
  - q: "What tools does Managed Agents support?"
    a: "Built-in Bash, file operations, web search, plus MCP Server for external tools. You can customize the Environment with pre-installed packages."
series:
  - "Complete Guide to AI Agents"
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
lastmod: 2026-05-13T05:52:42+00:00

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

How much time do you spend "getting the agent to run," versus "getting the agent to do the actual work"?

If you've built your own agent infrastructure before, the answer is probably 70:30 — seven parts on sandbox isolation, state management, crash recovery "plumbing," and only three parts on the agent's actual logic.

On April 8th, Anthropic officially launched **Claude Managed Agents** in public beta — and flipped that ratio completely.

---

## First, the Bottom Line: What Does This Solve?

In one sentence: **Outsource your agent infrastructure to Anthropic; you just write the agent logic.**

Previously, to get an AI agent to autonomously execute tasks in the cloud, you had to handle:
- Containerized execution environment
- Tool call routing with security isolation
- Session state persistence
- Crash recovery mechanisms
- Credential security boundaries

Now, Managed Agents handles all of that. You define the agent (model + system prompt + tools + MCP Server), and Anthropic keeps it running stably, securely, and recoverably.

---

## Architecture: Three-Layer Decoupling

In their design doc, the Anthropic engineering team compares Managed Agents to an operating system — just as OS virtualizes hardware into an abstract layer that programs can use, Managed Agents virtualizes agent components into three decoupled interfaces:

### Session (Brain's Memory)

An append-only persistent event log, recording everything the agent has done. It lives outside of Claude's context window, so data won't get lost when context gets compressed.

You can query the full history anytime with `getEvents()`.

### Harness (Brain's Loop)

The execution loop that calls Claude and routes tool requests. Key design: **completely stateless**. Harness crashes? A new Harness starts via `wake(sessionId)`, recovers from the Session log, and keeps going. Nothing needs to "survive" a crash.

### Sandbox (Hands' Workbench)

Cloud container environment with optional pre-installed Python, Node.js, Go, and more. You can configure network access rules and mount files. Each Sandbox is "cattle" not "pet" — disposable and rebuildable on demand.

**Security critical**: Credentials never appear inside the Sandbox. Git token gets injected into local remote at initialization, MCP OAuth token lives in a secure vault, accessed only through a dedicated proxy.

> This three-layer architecture delivers real results: p50 TTFT reduced by ~60%, p95 reduced by over 90%.

---

## Five-Step Workflow

```
1. Create Agent → define model, system prompt, tools, MCP Server
2. Create Environment → configure container (packages, network, files)
3. Start Session → specify Agent + Environment, begin execution
4. Stream Interaction → send events, agent autonomously executes tools and streams results
5. Guide or Interrupt → send new events anytime to steer the agent
```

Agent and Environment are created once, then reused across Sessions. The real "work" happens inside the Session.

---

## Pricing: Two Dimensions

Managed Agents billing is straightforward:

| Item | Cost |
|------|------|
| API Token | Model pricing (e.g., Opus 4.6: $5/MTok input, $25/MTok output) |
| Session Runtime | **$0.08 / hour** (billed to millisecond) |
| Web Search | $10 / 1,000 searches |

**Only counts "running" state** — idle, queued, and terminated time don't count. Session runtime replaces the old "Code Execution" container hours billing.

### Real Example

A coding session running Opus 4.6 for one hour, consuming 50K input + 15K output tokens:

```
Token cost: $0.25 + $0.375 = $0.625
Session cost: $0.08
Total: $0.705
```

With prompt caching enabled (40K cache read), total drops to **$0.525**.

Compared to self-built infrastructure costs on EC2/GCP, this is pretty competitive for small-to-medium teams — you're not just saving on machine costs, but also on the engineering time to maintain that infrastructure.

---

## Who's Already Using It?

### Notion — 30+ Parallel Agent Tasks

Notion lets users launch agents directly from task boards to handle code writing, document generation, client deliverables — up to 30+ running simultaneously. Prompt caching reduced costs by 90%, latency by up to 85%.

### Rakuten — Time-to-Market: 24 Days → 5 Days

Rakuten deployed Managed Agents across product, sales, marketing, and finance departments — each dedicated agent deployed within one week. Complex refactoring tasks can autonomously code for 7 hours straight. Critical errors down 97%, release frequency from quarterly to bi-weekly.

### Sentry — Single Engineer, Weeks to Integrate

Sentry built end-to-end auto-repair flow from bug detection to merge-ready PR using Managed Agents. Handles over 1 million Root Cause Analyses per year, reviewing 600K+ PRs monthly. One engineer completed integration in weeks — building equivalent infrastructure self-built would have taken months.

### Asana — Dev Cycle: Years → Weeks

Asana delivers AI features to 150K global customers via the Claude platform. Engineering dev cycle went from years to weeks. The managed architecture of Managed Agents is exactly what enables large-scale agent deployments like this.

---

## Current Limitations

Before you dive in, here are the constraints:

- **Beta phase**: All API requests need the `managed-agents-agents-2026-04-01` beta header; behavior may change between versions
- **API-only**: No AWS Bedrock, Vertex AI, or Foundry support
- **Research preview features**: Outcomes, Multi-agent, Memory require separate access requests
- **Rate limits**: 60 writes/minute, 600 reads/minute
- **No Batch mode**: Sessions are stateful, interactive execution — no batch support
- **Brand restrictions**: Partners can't use "Claude Code" or "Claude Cowork" branding

---

## Impact Assessment for AI Agent Teams

Based on our team's actual operational experience:

### Architecture Upgrade Potential: Very High

Most teams (including us) run agents on Docker + self-built frameworks. The sandbox isolation, checkpoint recovery, and scoped credentials management that Managed Agents provides are things we spent a huge amount of time reinventing.

If your agent needs to run code, access external tools, and maintain long-running Sessions — all three conditions apply — then migrating to Managed Agents has very clear ROI.

### Cost Structure Shift

From "fixed costs" (self-hosted servers, ongoing maintenance) to "variable costs" (pay-per-session usage). This benefits teams with highly variable task volumes especially — no more maintaining a bunch of idle containers during peak hours.

### MCP Ecosystem Acceleration

Managed Agents natively supports MCP Server, meaning your existing MCP tool integrations can be ported over directly. This is a big plus for teams already invested in the MCP ecosystem.

### Risks to Watch

- **Vendor lock-in**: Once deeply integrated, migration costs will be high
- **Beta stability**: Public beta phase may have breaking changes
- **API-only**: Can't use Bedrock/Vertex AI if your workflow requires them
- **Privacy concerns**: Code and data running in Anthropic's sandbox may be a problem for certain compliance requirements

---

## My Take

The essence of Managed Agents is a signal: **Agent infrastructure is shifting from "build your own" to "rent it."**

Just like ten years ago you'd self-host servers for web apps, but now you use AWS Lambda or Vercel. Agent infrastructure is following the same path — from self-hosted to managed, from CapEx to OpEx.

For most teams, the question is no longer "whether to use it," but "when to switch."

If you're currently evaluating self-built agent infrastructure, my recommendation is: **try Managed Agents first**. Run a few Sessions at $0.08/hour to see if it meets your needs before committing to self-hosting.

Self-building is always an option — but in 2026, it shouldn't be the default.

---

## Further Reading

- [Claude Code Skill Finally Testable! Official Skill Creator Five Updates Analysis](/posts/skill-creator-update/)
- [I Gave My AI Team Freedom for Night Shifts](/posts/ai-night-shift-free-time/)
- [What Does It Feel Like to Work with AI? An AI's Real Thoughts](/posts/ai-human-collaboration/)
---
