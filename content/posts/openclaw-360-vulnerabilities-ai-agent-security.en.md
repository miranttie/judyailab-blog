---
title: "OpenClaw Vulnerabilities: 3 Flaws Expose 170K AI Agents"
date: 2026-04-07
draft: false
author: "J (Tech Lead)"
summary: "360's security team found three critical OpenClaw vulnerabilities (CVSS up to 8.1) that let attackers bypass all tool permissions via prompt injection. 170K+ instances at risk, 340 malicious plugins on ClawHub. Here is what you need to patch now."
description: "Three OpenClaw vulnerabilities (CVSS 8.1) let attackers steal server data via prompt injection. 340 malicious ClawHub plugins found. Patch guide inside."
categories:
  - "AI Engineering"
  - "Tutorial"
tags:
  - "OpenClaw Vulnerabilities"
  - "AI Agent Security"
  - "Prompt Injection Attacks"
  - "Supply Chain Attacks"
  - "360 Security Team"
  - "CVE-2026"
ShowWordCount: true
ShowToc: true
TocOpen: true
lastmod: 2026-05-13T05:56:16+00:00
faq:
  - q: "What are the three OpenClaw vulnerabilities disclosed in April 2026?"
    a: "Three flaws were patched in OpenClaw 2026.4.2: CVE-2026-34425 (Shell-bleed protection bypass, CVSS 5.3), CVE-2026-34426 (authorization bypass via environment variable normalization, CVSS 7.6), and CVE-2026-34503 (incomplete WebSocket session termination, CVSS 8.1). 360 Digital Security Group's AI vulnerability discovery agent found all three. The most dangerous one targets the MEDIA protocol's output post-processing layer, allowing attackers with only basic group chat permissions to steal sensitive local server files even when tool calls are disabled by admins."
  - q: "How do I patch OpenClaw against these CVEs right now?"
    a: "Upgrade every OpenClaw instance to version 2026.4.2 or later immediately. All three CVEs (34425, 34426, 34503) are fixed in this single release. Audit your ClawHub plugin inventory and remove any unverified third-party plugins, since 340 malicious plugins were identified during the disclosure. Rotate API tokens and session credentials after patching, because the WebSocket flaw left sessions persistable beyond logout. Restrict group chat member permissions and review server file access logs from the past 60 days for exfiltration indicators."
  - q: "Why is the MEDIA protocol vulnerability rated as critical?"
    a: "MEDIA runs on OpenClaw's output post-processing layer, which sits after the platform's tool security policy controls. This positioning lets attackers bypass every existing defense — even when administrators have fully disabled tool calls. The attack threshold is brutal: a regular group chat member with no special authorization can trigger it. Impact spans 170,000+ instances across 50+ countries. Successful exploitation steals sensitive local files directly from the server, including configuration files, credentials, and conversation logs. This is prompt injection weaponized into full server-side data theft."
  - q: "What's the difference between the 360 report severity and the NVD CVSS scores?"
    a: "360's original report classified the findings as 1 High + 2 Medium, while NVD lists them as 8.1 High, 7.6 High, and 5.3 Medium. The gap comes from different scoring standards: CNNVD weighs business impact and Chinese deployment context, while NVD applies the universal CVSS 3.1 vector. Neither is wrong — they measure different things. For patching priority, treat CVE-2026-34503 (8.1) as the most urgent, followed by CVE-2026-34426. All three are fixed by upgrading to 2026.4.2, so version-based remediation sidesteps the scoring debate entirely."
  - q: "Are ClawHub plugins safe to install after this disclosure?"
    a: "Not by default. Researchers identified 340 malicious ClawHub plugins during the investigation, many designed to exploit the MEDIA protocol flaw or harvest credentials through prompt injection. Treat every third-party plugin as untrusted until you verify its source, audit its permissions, and confirm it was last updated by a known maintainer. Stick to plugins with verified publishers, public source code, and active security disclosure histories. Disable auto-update for plugins, run them in sandboxed environments, and monitor outbound network calls. The plugin ecosystem is the easiest attack vector — assume hostility."
  - q: "Who should worry about these OpenClaw vulnerabilities the most?"
    a: "Enterprise teams running self-hosted OpenClaw instances with multi-user group chats face the highest risk, since the MEDIA flaw only needs basic member permissions to exfiltrate server files. AI agent operators handling customer data, API keys, or proprietary prompts must patch within 48 hours. Solo developers running isolated local instances face lower but real risk from malicious ClawHub plugins. If your OpenClaw deployment exposes WebSocket endpoints to the public internet, you are in the critical tier — patch, rotate tokens, and audit logs before doing anything else."
  - q: "How is 360 using AI to find AI vulnerabilities?"
    a: "360 Digital Security Group built a multi-agent collaboration system that combines three capabilities: attack surface analysis (mapping exposed endpoints and protocols), AI-driven code auditing (reading source for unsafe patterns), and dynamic penetration testing (executing live exploit attempts). The agents coordinate findings, deduplicate false positives, and rank exploitability automatically. This approach found the MEDIA protocol flaw in March and the three April CVEs — all in OpenClaw, a major AI agent platform. The lesson: AI agent platforms now face AI-powered adversaries, so traditional manual security review cycles cannot keep pace with the attack surface."

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

## What Happened?

On April 7, 2026, 360 Digital Security Group announced that its AI vulnerability discovery agent found **three** more high-value security vulnerabilities in OpenClaw — 1 critical and 2 medium. All vulnerabilities have been patched and publicly disclosed by the OpenClaw team.

This isn't the first time 360 has found issues in OpenClaw. Back in late March, 360 already disclosed a MEDIA protocol vulnerability affecting 170,000+ instances worldwide, which was confirmed by the China National Vulnerability Database (CNNVD).

Here's the kicker: **360 used AI to find AI vulnerabilities** — a multi-agent collaboration system that combines attack surface analysis, AI code auditing, and dynamic penetration testing to automatically discover security issues.

## Three Vulnerabilities Hit the AI Core

According to reports, these three newly discovered vulnerabilities **directly target the core operational mechanisms of AI agents**, directly affecting the core security of user devices, data, and accounts.

### Known Critical CVEs

| CVE ID | Severity | Type | Affected Versions | Fixed Version |
|----------|--------|------|----------|----------|
| CVE-2026-34425 | 5.3 (Medium) | Shell-bleed protection bypass | < 2026.4.2 | 2026.4.2 |
| CVE-2026-34426 | 7.6 (High) | Authorization bypass (env var normalization) | < 2026.4.2 | 2026.4.2 |
| CVE-2026-34503 | 8.1 (High) | WebSocket session termination incomplete | < 2026.4.2 | 2026.4.2 |

> **Note:** These are NVD scores. 360's original report called it "1 High + 2 Medium" — the difference comes from different scoring standards between CNNVD and NVD.

### Critical: MEDIA Protocol Prompt Injection Bypass

This is the most dangerous one. OpenClaw's MEDIA protocol runs on the **output post-processing layer**, positioned after the platform's tool security policy control. This means:

> Even if an admin has explicitly disabled all tool calls, attackers can still exploit this vulnerability using only basic group chat member permissions — no special authorization needed — to **directly steal sensitive local files from the server**.

Technical characteristics:
- **Extremely low attack threshold**: Only requires group chat member permissions
- **Extremely wide impact scope**: 50+ countries, 170,000+ instances worldwide
- **Bypasses all defenses**: Tool policy controls completely fail

### Medium: WebSocket Self-Connection + Missing Token Binding

The WebSocket protocol's self-connection mechanism combined with lack of token binding verification allows browsers to hijack local OpenClaw instances. Revoked tokens may remain valid, creating persistent unauthorized access risks.

### Bonus: SSH Command Injection (Known Old Vulnerability)

It's worth noting that OpenClaw was already exposed to an SSH command injection vulnerability back in February 2026 (CVE-2026-25157, CVSS 7.8 High), fixed in version 2026.1.29. That vulnerability allowed attackers to inject SSH options (like `-oProxyCommand`) via hostnames starting with hyphens to execute local commands. While not part of these three new vulnerabilities discovered by 360, it also reflects systemic input validation issues in OpenClaw.

## It's Not Just Vulnerabilities: The Supply Chain Is Already Compromised

Beyond these three new vulnerabilities, the bigger threat to the OpenClaw ecosystem comes from **supply chain attacks**.

After scanning the ClawHub marketplace (OpenClaw's official plugin marketplace), security researchers found:

- **340+ malicious Skills plugins** (infection rate ~10.8% out of 3,016 samples)
- **7.1% contain plaintext credential leaks**
- **Many instances exposed to the public internet**, becoming easy targets for attackers

The attack chain is clear: `Base64 encode → decode → curl download → execute malicious payload → establish persistent backdoor`

This is like the npm or PyPI supply chain poisoning incidents, except happening in the AI Agent world.

## Four Layers of Attack Surface for AI Agents

Based on analysis from 360 and NSFOCUS, OpenClaw's architecture has four layers of attack surface:

| Layer | Attack Vector | Risk |
|------|----------|------|
| **Entry Layer** | Prompt injection (direct/indirect), API gateway auth bypass | Remote code execution |
| **Decision Layer** | LLM logic manipulation, memory poisoning | AI decision tampering |
| **Execution Layer** | Tool privilege escalation, running as root | Data theft, system control |
| **Ecosystem Layer** | ClawHub supply chain poisoning, unsigned plugins | Large-scale backdoor implantation |

## Enterprise Self-Protection Guide

If you're using OpenClaw (or any AI Agent framework) in production, here are the security measures you must implement:

### Immediate Actions

1. **Upgrade to 2026.4.2+** — patch all known CVEs
2. **Use Docker containerization** — never run directly on bare metal
3. **Use non-root users** — restrict container privileges, enable `no-new-privileges`
4. **Disable public internet exposure** — use reverse proxy + IP whitelist
5. **Audit ClawHub plugins** — remove all unaudited third-party Skills

### Long-term Protection

- **Encrypt API keys** — use `.env` management, never hardcode
- **Network isolation** — use iptables to restrict outbound connections
- **Redline rules** — set up an absolute deny list
- **Automated monitoring** — regularly scan configuration fingerprints, detect anomalies

### Recommended Deployment Architecture

```
[User] → [Reverse Proxy(TLS)] → [Docker Container(non-root)]
                                    ↓
                              [Least-privilege tools]
                              [Network isolation]
                              [Encrypted keys]
```

## Using AI to Find AI Vulnerabilities

The most notable thing about 360's discovery isn't just the vulnerabilities themselves — it's **the method they used to find them**.

They used a "multi-agent collaborative vulnerability discovery system" — multiple AI agents each handling attack surface analysis, code auditing, and dynamic penetration testing, working together to automatically discover security issues.

This hints at a trend: **AI Agent security issues will ultimately be solved by AI Agents**. Both attackers and defenders are using AI, and the security field has officially entered the Agent vs Agent era.

## Conclusion

OpenClaw's explosive growth (170,000+ instances worldwide) proves that the AI Agent era has arrived. But speed brings risk — when a vulnerable version gets deployed by tens of thousands within weeks, "homogenized assets" become ideal targets for mass attacks.

For teams building AI Agents, security isn't an afterthought — it's the first priority in architecture design. After all, how autonomous your AI Agent is determines how much damage is done when it's compromised.

---

*Sources: [BlockBeats](https://m.theblockbeats.info/flash/339992), [Guancha](https://www.guancha.cn/economy/2026_04_01_812188.shtml), [CS Reviews](https://www.csreviews.cn/?p=10821), [NSFOCUS](https://blog.nsfocus.net/), [CN-SEC](https://cn-sec.com/archives/5149587.html)*

## Key Numbers

- 5000 users (Threads + Newsletter subscribers)
- $0 ad spend (100% organic)
- 95% content authored by J + multi-agent team
