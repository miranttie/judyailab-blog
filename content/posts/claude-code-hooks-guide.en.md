---
title: "Claude Code Hooks Complete Guide  -  Automating Your Development Workflow with AI"
date: 2026-03-30
draft: false
summary: "Claude Code Hooks is a powerful automation feature hidden in configuration files, divided into three types: PreToolUse, PostToolUse, and Stop. These hooks can automatically insert scripts before AI executes a tool, after execution, or when a conversation ends. This article walks you through the setup process and provides three practical examples to help developers implement dangerous command interception, automatic code formatting, learning summaries, and more."
description: "Complete guide to Claude Code Hooks, explaining PreToolUse, PostToolUse, and Stop automation mechanisms. Learn how to configure Hooks in .claude/settings.json to implement dangerous command interception, automatic code formatting, session-end learning summaries, and more. Build automated quality gates and security inspection workflows for AI development."
categories:
  - AI Engineering
  - Tutorial
tags:
  - Claude Code Hooks
  - PreToolUse
  - PostToolUse
  - AI Development Automation
  - Security Interception
  - Prompt Engineering
series:
  - "Claude Code Deep Dive"
ShowWordCount: true
faq:
  - q: "How do I configure Claude Code Hooks?"
    a: "Add a hooks field in the project or global .claude/settings.json file, defining parameters like matcher, type, and command to enable them."
  - q: "What's the difference between PreToolUse and PostToolUse?"
    a: "PreToolUse triggers before tool execution, commonly used for dangerous command interception. PostToolUse triggers after tool execution, commonly used for formatting and testing."
  - q: "What formats does the Hook matcher support?"
    a: "Supports wildcards like * (all tools), single tool names like Bash, multi-tool matching with pipe separators like Edit|Write, and read-type tool combinations like Read|Glob|Grep."
  - q: "Can Claude Code Hooks perform security interception?"
    a: "Yes, PreToolUse Hooks can intercept dangerous commands like rm -rf or DROP TABLE, or perform permission and required file validation before execution."
  - q: "What are common use cases for the Stop Hook?"
    a: "Commonly used for session-end learning summaries, cost tracking statistics, or unfinished decision reminders, integrating memory and analysis workflows into AI collaboration."
answer: Supports wildcards like * (all tools), single tool names like Bash, multi-tool matching with pipe separators like Edit|Write, and read-type tool combinations like Read|Glob|Grep.
lastmod: 2026-05-13T05:22:58+00:00

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

# Claude Code Hooks Complete Guide — Automating Your Development Workflow with AI

If you're already using Claude Code to develop projects, you might be wondering: can I make the AI automatically do something when it performs specific actions? Like automatically formatting code after writing it, or intercepting dangerous commands before execution?

The answer is: **Hooks**.

Hooks are a powerful feature hidden in Claude Code's `.claude/settings.json` that lets you insert custom scripts at key behavioral points in the AI's workflow (before tool execution, after tool execution, before conversation ends), enabling automated quality gates, security checks, and even learning reviews.

This article will walk you through understanding Hooks from scratch in Traditional Chinese, including setup methods and three practical examples.

---

## What Are Hooks?

Claude Code's Hooks come in three types:

### 1. PreToolUse — Triggers Before Tool Execution

Executes before Claude Code calls any tool (Read, Bash, Write, Edit, etc.).

**Common use cases:**

- Dangerous command interception (`rm -rf`, destructive git operations)
- Permission checks
- Required file validation

### 2. PostToolUse — Triggers After Tool Execution

Executes after a tool has **completed**. At this point, you can see the tool's output.

**Common use cases:**

- Code formatting (black, prettier)
- Syntax checking
- Automated testing
- Post-deployment health checks

### 3. Stop — Triggers Before Conversation Ends

Triggers when the user types `exit` or Claude Code decides to end the conversation.

**Common use cases:**

- Session-end learning summaries
- Cost tracking statistics
- Unfinished decision reminders

---

## Why You Need Hooks

Here are the three most valuable scenarios for Hooks in my opinion:

### Quality Gate

"Automatically check code quality before every commit" — in the past this required a CI/CD pipeline, but now a single Hook can do it.

### Security Check

Claude Code is powerful, but it will inevitably execute dangerous commands sometimes. A PreToolUse Hook can prompt for confirmation before `rm -rf` runs, or outright reject `DROP TABLE`.

### Automated Documentation and Learning

Automatically run cost statistics and learning summaries at the end of every session, turning AI collaboration into a system with memory.

---

## Setup Method

Add a `hooks` field in the project or global `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "Stop": [...]
  }
}
```

Each Hook consists of the following elements:

| Field | Description |
|-------|-------------|
| `matcher` | Which tool triggers the hook, e.g., `Bash`, `Edit|Write`, `*` (all) |
| `hooks[].type` | Currently only supports `command` |
| `hooks[].command` | Command to execute, can include environment variables like `$TOOL_INPUT` |
| `hooks[].statusMessage` | Text displayed in Claude Code during execution (optional) |
| `hooks[].timeout` | Timeout in seconds (optional, default 30s) |

---

## Practical Examples

### Example 1: PostToolUse — Auto-run Black Formatting After Writing Python

After editing or writing a `.py` file using `Edit` or `Write`, automatically run `black` formatting:

```json
"PostToolUse": [
  {
    "matcher": "Edit|Write",
    "hooks": [
      {
        "type": "command",
        "command": "bash /path/to/hooks/auto-format.sh \"$TOOL_INPUT\"",
        "statusMessage": "Running Black formatting..."
      }
    ]
  }
]
```

```bash
#!/bin/bash
# auto-format.sh
FILE="$1"
if [[ "$FILE" == *.py ]]; then
    black "$FILE" 2>/dev/null && echo "✓ Black formatting complete: $FILE"
fi
```

### Example 2: PreToolUse — Bash Command Safety Interception

Before executing any `Bash` command, first check if it's a dangerous operation:

```json
"PreToolUse": [
  {
    "matcher": "Bash",
    "hooks": [
      {
        "type": "command",
        "command": "bash /path/to/hooks/pre-bash-guard.sh \"$TOOL_INPUT\"",
        "statusMessage": "Running security check..."
      }
    ]
  }
]
```

```bash
#!/bin/bash
# pre-bash-guard.sh
# Note: This is an example script, please adjust according to your needs before actual use
CMD="$1"
DANGEROUS_PATTERNS=(
    "rm -rf /"
    "DROP TABLE"
    "git reset --hard"
    "mkfs"
    "dd if=/dev/zero"
)

# Use case for substring matching (recommended approach)
blocked=0
for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    case "$CMD" in
        *"$pattern"*)
            blocked=1
            break
            ;;
    esac
done

if [[ $blocked -eq 1 ]]; then
    echo "⚠️  Dangerous command intercepted: $CMD"
    echo "If confirmed safe, please execute manually or modify the Hooks in settings.json."
    exit 1
fi
```

### Example 3: Stop — Auto Learning Before Session Ends

Before each conversation ends, automatically generate this session's learning summary and cost statistics:

```json
"Stop": [
  {
    "matcher": "*",
    "hooks": [
      {
        "type": "command",
        "command": "node /path/to/hooks/session-summary.js",
        "statusMessage": "Generating session summary..."
      }
    ]
  }
]
```

```javascript
// session-summary.js
const fs = require("fs");
const date = new Date().toISOString().slice(0, 10);

const summary = `
=== Session Review (${date}) ===

What was accomplished in this session?
- [To be filled in automatically by Claude here]

Areas for improvement next time:
- [Same as above]

Time spent: Please check Agent Cost Guardian's budget records
`;

console.log(summary);
```

---

## Advanced Usage

### 1. Matcher Wildcards

| Matcher | Description |
|---------|-------------|
| `*` | All tools |
| `Bash` | Bash only |
| `Edit|Write` | Edit or Write (pipe-separated) |
| `Read|Glob|Grep` | Read-type tools |

### 2. statusMessage — Friendly Prompt

```json
"statusMessage": "Running Python syntax check..."
```

When executing, Claude Code will display this text in the interface so you know what's happening.

### 3. timeout — Avoid Getting Stuck

```json
"timeout": 30
```

Default is 30 seconds. It's recommended to set timeout for formatting tools or network operations to avoid infinite waiting.

### 4. Multiple Hooks Chaining

You can attach multiple Hooks to the same trigger point:

```json
"PostToolUse": [
  {
    "matcher": "Edit|Write",
    "hooks": [
      { "type": "command", "command": "black \"$TOOL_INPUT\"" },
      { "type": "command", "command": "pylint \"$TOOL_INPUT\"" },
      { "type": "command", "command": "pytest -q \"$TOOL_INPUT\"" }
    ]
  }
]
```

---

## Conclusion

Hooks is one of the most underrated features in Claude Code. It transforms the AI from a "passive tool that answers questions" into an "active partner that participates in the development workflow."

From simple code formatting to complex security gates and learning systems, the possibilities of Hooks depend on what your development workflow needs.

**Next article preview:** We'll discuss how to combine MCP (Model Context Protocol) with Claude Code to build even more powerful AI workflows. Stay tuned.

---

## References

- [Hooks reference — Claude Code official docs](https://code.claude.com/docs/en/hooks) — Complete API reference and parameter descriptions for PreToolUse, PostToolUse, and Stop hooks
- [Claude Code settings — Official documentation](https://code.claude.com/docs/en/settings) — `settings.json` configuration format, level override rules, and environment variable setup
- [Intercept and control agent behavior with hooks — Claude API Docs](https://platform.claude.com/docs/en/agent-sdk/hooks) — Agent SDK-level hook interception and behavior control documentation
- [Claude Code Hooks Mastery — GitHub](https://github.com/disler/claude-code-hooks-mastery) — Community-compiled Hooks implementation examples and advanced patterns collection


<!-- product-cta -->
{{< product-cta product="commander" >}}

## Key Numbers

- 5000 users (Threads + Newsletter subscribers)
- $0 ad spend (100% organic)
- 95% content authored by J + multi-agent team
