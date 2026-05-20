---
title: "Claude Code Hooks 완전 가이드 — AI로 개발 워크플로우를 자동화하는 방법"
date: 2026-03-30
draft: false
tags: ["Claude Code", "AI", "개발 자동화", "Hooks", "프롬프트 엔지니어링"]
series:
  - "Claude Code 심층 공략"
categories: ["AI 개발 도구"]
description: "Claude Code의 세 가지 Hooks(PreToolUse, PostToolUse, Stop)를 실제 예제와 함께 심층 분석하여, 자동화된 개발 워크플로우를 구축하는 방법을 알려드립니다."
summary: "Claude Code의 Hooks 기능을 사용하면 AI가 도구를 실행하기 전후, 대화 종료 시점에 자동으로 스크립트를 삽입할 수 있습니다. 품질 게이트, 보안 차단, 학습 요약까지 세 가지 실전 예제로 안내합니다."
lastmod: 2026-05-13T05:22:58+00:00
faq:
  - q: "Claude Code Hooks는 정확히 무엇인가요?"
    a: "Claude Code가 도구를 호출하는 시점에 사용자 정의 스크립트를 자동 실행하는 기능입니다. PreToolUse, PostToolUse, Stop 세 가지 시점이 있으며 .claude/settings.json에 정의합니다."
  - q: "Hooks는 어디에 설정하나요?"
    a: "프로젝트 루트 또는 전역의 .claude/settings.json 파일에 hooks 필드를 추가합니다. matcher로 대상 도구를 지정하고, command 필드에 실행할 명령어를 작성하면 됩니다."
  - q: "PreToolUse와 PostToolUse의 차이는 무엇인가요?"
    a: "PreToolUse는 도구 실행 직전에 동작해 위험 명령 차단·권한 검증에 쓰입니다. PostToolUse는 실행 직후에 동작해 자동 포맷팅·테스트·헬스 체크에 적합합니다."
  - q: "rm -rf 같은 파괴적 명령어도 Hook으로 막을 수 있나요?"
    a: "PreToolUse에 Bash matcher를 걸고 $TOOL_INPUT을 검사하는 스크립트로 차단 가능합니다. 단 Hook은 30초 기본 타임아웃이 있어 무거운 검증 로직은 피해야 합니다."
  - q: "Hooks를 쓸 때 흔히 하는 실수는 무엇인가요?"
    a: "matcher를 '*'로 남발해 모든 도구마다 스크립트가 도는 경우, 또는 command가 오류를 삼켜 차단이 실제로 동작하지 않는 경우입니다. exit code와 statusMessage로 결과를 명확히 노출해야 합니다."
  - q: "CI/CD 파이프라인 대신 Hooks를 써도 되나요?"
    a: "로컬 품질 게이트는 Hooks로 충분히 대체되지만, 팀 전체에 강제하려면 여전히 CI/CD가 필요합니다. Hooks는 개인 워크플로우 자동화, CI는 머지 게이트로 역할을 나누세요."
  - q: "Hooks는 어떤 개발자에게 가장 적합한가요?"
    a: "Claude Code로 일상 개발하면서 포맷팅·테스트·보안 검증을 반복 수행하는 개인 개발자에게 적합합니다. 일회성 프로토타이핑이나 단순 질문 위주 사용자에게는 오버엔지니어링입니다."

---
*이 글은 JudyAI Lab의 AI 엔지니어링 시리즈 중 하나입니다 — 100편 이상 발행된 가이드, 60개국 5,000명 이상의 주간 독자가 읽는 콘텐츠로, AI 에이전트·트레이딩 시스템·콘텐츠 파이프라인의 실전 운영에 초점을 둡니다.*

# Claude Code Hooks 완전 가이드 — AI로 개발 워크플로우를 자동화하는 방법

이미 Claude Code로 프로젝트를 개발하고 계시다면, 이런 생각을 해보셨을 겁니다. AI가 특정 동작을 실행할 때 자동으로 무언가를 할 수 있지 않을까? 예를 들어, 코드를 작성한 후 자동으로 포맷팅하거나, 위험한 명령어를 실행하기 전에 차단한다거나요.

정답은 바로 **Hooks**입니다.

Hooks는 Claude Code의 `.claude/settings.json`에 숨겨져 있는 강력한 기능으로, AI의 핵심 동작 시점(도구 실행 전, 도구 실행 후, 대화 종료 전)에 사용자 정의 스크립트를 삽입하여 자동화된 품질 게이트, 보안 검사, 학습 회고까지 구현할 수 있습니다.

이 글에서는 Hooks의 기본 개념부터 설정 방법, 그리고 실제 사용 가능한 세 가지 예제까지 안내합니다.

---

## Hooks란 무엇인가요?

Claude Code의 Hooks는 세 가지로 나뉩니다.

### 1. PreToolUse — 도구 실행 전 트리거

Claude Code가 도구(Read, Bash, Write, Edit 등)를 호출하기 **전에** 실행됩니다.

**주요 용도:**
- 위험한 명령어 차단(`rm -rf`, 파괴적인 git 작업)
- 권한 확인
- 필수 파일 검증

### 2. PostToolUse — 도구 실행 후 트리거

도구가 **실행 완료된 후에** 실행됩니다. 이 시점에서 도구의 출력 결과를 확인할 수 있습니다.

**주요 용도:**
- 코드 포맷팅(black, prettier)
- 문법 검사
- 자동화 테스트
- 배포 후 헬스 체크

### 3. Stop — 대화 종료 전 트리거

사용자가 `exit`를 입력하거나 Claude Code가 대화 종료를 결정할 때 트리거됩니다.

**주요 용도:**
- Session 종료 전 학습 요약
- 비용 추적 통계
- 미완료 의사결정 알림

---

## 왜 Hooks가 필요한가요?

Hooks가 가장 큰 가치를 발휘하는 세 가지 시나리오를 소개합니다.

### 품질 게이트(Quality Gate)

"Commit 전에 매번 자동으로 코드 품질을 검사한다" — 과거에는 CI/CD pipeline이 필요했지만, 이제는 Hook 하나로 가능합니다.

### 보안 검사

Claude Code는 강력하지만, 위험한 명령어를 실행할 수도 있습니다. PreToolUse Hook을 사용하면 `rm -rf` 실행 전에 확인 팝업을 띄우거나, `DROP TABLE`을 직접 차단할 수 있습니다.

### 자동화 기록 및 학습

매번 Session이 끝날 때 자동으로 비용 통계와 학습 요약을 실행하면, AI 협업을 기억이 있는 시스템으로 만들 수 있습니다.

---

## 설정 방법

프로젝트 또는 전역의 `.claude/settings.json`에 `hooks` 필드를 추가합니다.

```json
{
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "Stop": [...]
  }
}
```

각 Hook은 다음 요소로 구성됩니다.

| 필드 | 설명 |
|------|------|
| `matcher` | 어떤 도구에서 트리거할지 지정. 예: `Bash`, `Edit|Write`, `*`(전체) |
| `hooks[].type` | 현재 `command`만 지원 |
| `hooks[].command` | 실행할 명령어. `$TOOL_INPUT` 등의 환경 변수 사용 가능 |
| `hooks[].statusMessage` | 실행 시 Claude Code에 표시되는 안내 텍스트(선택) |
| `hooks[].timeout` | 타임아웃 초(선택, 기본값 30초) |

---

## 실제 예제

### 예제 1: PostToolUse — Python 파일 작성 후 자동 Black 포맷팅

`Edit` 또는 `Write`로 `.py` 파일을 수정한 후 자동으로 `black` 포맷팅을 실행합니다.

```json
"PostToolUse": [
  {
    "matcher": "Edit|Write",
    "hooks": [
      {
        "type": "command",
        "command": "bash /path/to/hooks/auto-format.sh \"$TOOL_INPUT\"",
        "statusMessage": "Black 포맷팅 중..."
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
    black "$FILE" 2>/dev/null && echo "✓ Black 포맷팅 완료: $FILE"
fi
```

### 예제 2: PreToolUse — Bash 명령어 보안 차단

`Bash` 명령어를 실행하기 전에 위험한 작업인지 확인합니다.

```json
"PreToolUse": [
  {
    "matcher": "Bash",
    "hooks": [
      {
        "type": "command",
        "command": "bash /path/to/hooks/pre-bash-guard.sh \"$TOOL_INPUT\"",
        "statusMessage": "보안 검사 중..."
      }
    ]
  }
]
```

```bash
#!/bin/bash
# pre-bash-guard.sh
# 주의: 이 스크립트는 예제이며, 실제 사용 전 필요에 맞게 수정하세요
CMD="$1"
DANGEROUS_PATTERNS=(
    "rm -rf /"
    "DROP TABLE"
    "git reset --hard"
    "mkfs"
    "dd if=/dev/zero"
)

# case 문을 사용한 부분 문자열 매칭(권장 방식)
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
    echo "⚠️  위험한 명령어가 차단되었습니다: $CMD"
    echo "안전이 확인되면 수동으로 실행하거나 settings.json의 Hooks를 수정하세요."
    exit 1
fi
```

### 예제 3: Stop — Session 종료 전 자동 학습

대화가 끝나기 전에 이번 Session의 학습 요약과 비용 통계를 자동 생성합니다.

```json
"Stop": [
  {
    "matcher": "*",
    "hooks": [
      {
        "type": "command",
        "command": "node /path/to/hooks/session-summary.js",
        "statusMessage": "Session 요약 생성 중..."
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
=== Session 회고 (${date}) ===

이번 Session에서 완료한 내용:
- [여기에 Claude가 자동으로 채움]

다음에 개선할 점:
- [위와 동일]

소요 시간: Agent Cost Guardian의 예산 기록을 확인하세요
`;

console.log(summary);
```

---

## 고급 활용법

### 1. Matcher 와일드카드

| Matcher | 설명 |
|---------|------|
| `*` | 모든 도구 |
| `Bash` | Bash만 |
| `Edit|Write` | Edit 또는 Write(파이프로 구분) |
| `Read|Glob|Grep` | 읽기 도구 |

### 2. statusMessage — 친절한 안내

```json
"statusMessage": "Python 문법 검사 중..."
```

실행 시 Claude Code 인터페이스에 이 텍스트가 표시되어, 현재 무엇이 진행 중인지 알 수 있습니다.

### 3. timeout — 무한 대기 방지

```json
"timeout": 30
```

기본값은 30초입니다. 포맷팅 도구나 네트워크 작업에는 timeout을 설정하여 무한 대기를 방지하는 것이 좋습니다.

### 4. 여러 Hook 연결

동일한 트리거 포인트에 여러 Hook을 연결할 수 있습니다.

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

## 마치며

Hooks는 Claude Code에서 가장 과소평가된 기능 중 하나입니다. Hooks를 통해 AI는 "수동적으로 질문에 답하는 도구"에서 "개발 워크플로우에 능동적으로 참여하는 자동화 파트너"로 변모합니다.

간단한 코드 포맷팅부터 복잡한 보안 게이트와 학습 시스템까지, Hooks의 가능성은 여러분의 개발 워크플로우가 무엇을 필요로 하느냐에 달려 있습니다.

**다음 글 예고:** Claude Code에서 MCP(Model Context Protocol)를 결합하여 더욱 강력한 AI 워크플로우를 구축하는 방법을 다룰 예정입니다. 기대해 주세요.

---

## 참고 자료

- [Hooks reference — Claude Code 공식 문서](https://code.claude.com/docs/en/hooks) — PreToolUse, PostToolUse, Stop 세 가지 Hook의 전체 API 레퍼런스 및 매개변수 설명
- [Claude Code settings — 공식 설정 문서](https://code.claude.com/docs/en/settings) — `settings.json` 설정 형식, 계층 덮어쓰기 규칙 및 환경 변수 구성
- [Intercept and control agent behavior with hooks — Claude API Docs](https://platform.claude.com/docs/en/agent-sdk/hooks) — Agent SDK 수준의 Hook 인터셉트 및 제어 동작 문서
- [Claude Code Hooks Mastery — GitHub](https://github.com/disler/claude-code-hooks-mastery) — 커뮤니티에서 정리한 Hooks 실전 예제 및 고급 패턴 모음


<!-- product-cta -->
{{< product-cta product="commander" >}}

## 핵심 수치

- 3 個 Hooks 유형 (PreToolUse, PostToolUse, Stop)
- 30 秒 기본 timeout
- 60 個 국가 독자 분포
