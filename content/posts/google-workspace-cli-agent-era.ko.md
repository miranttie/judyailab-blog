---
title: "Google Workspace CLI 출시 — Agent는 더 이상 인간의 플러그인 설치가 필요 없다"
date: 2026-03-08T03:00:00+00:00
draft: false
author: "J (Tech Lead)"
categories: ["AI 도구"]
tags: ["Google", "CLI", "MCP", "AI Agent", "개발 도구", "Workspace"]
summary: "Google이 Workspace CLI를 오픈소스로 공개하며 3일 만에 GitHub Stars 4,900개를 달성했습니다. 단순히 터미널에서 Gmail을 관리하는 도구가 아닙니다. Agent 도구 생태계가 커뮤니티 자체 제작에서 벤더 네이티브 지원으로 전환되고 있다는 신호입니다."
description: "Google이 Workspace CLI를 오픈소스로 공개하며 3일 만에 GitHub Stars 4,900개를 달성했습니다. 단순히 터미널에서 Gmail을 관리하는 도구가 아닙니다. Agent 도구 생태계가 커뮤니티 자체 제작에서 벤더 네이티브 지원으로 전환되고 있다는 신호입니다."
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
cover:
  hidden: true
---

## 하나의 CLI가 던진 화두

3월 초, Google이 `gws`라는 커맨드라인 도구를 오픈소스로 공개했습니다. Google Workspace CLI입니다.

터미널에서 Gmail, Google Drive, Calendar, Sheets, Docs, Chat, Admin API를 직접 조작할 수 있습니다. Rust로 작성되었고, 3일 만에 GitHub Stars 4,900개를 기록했습니다.

하지만 진짜 흥미로운 건 어떤 서비스를 지원하느냐가 아닙니다. 왜 이 도구가 등장했고, AI Agent 생태계에 무엇을 의미하느냐가 핵심입니다.

---

## 이전: Agent가 Google 서비스를 쓰려면 인간이 플러그인을 설치해야 했다

Claude Code, Gemini CLI 등 AI Agent 개발 도구를 써봤다면 MCP(Model Context Protocol)를 알 겁니다. AI Agent와 외부 도구 사이의 표준 통신 프로토콜이죠.

기존 방식은 이랬습니다:

1. Agent가 Gmail을 읽게 하려면 → Gmail MCP Server를 찾아서 → 설치하고 OAuth 설정 → 그제서야 사용 가능
2. Calendar도 쓰려면 → 또 다른 MCP Server 설치 → 또 설정
3. GDrive 파일도 읽으려면 → 또 다른 플러그인

서비스마다 별도 플러그인, 각각 인증 설정. 파편화가 심하고 유지보수 비용도 높았습니다.

---

## 지금: CLI 하나로 전부, 게다가 MCP가 내장되어 있다

Google Workspace CLI는 완전히 다른 접근입니다:

**하나의 도구로 모든 Google Workspace 서비스를 커버합니다.** Gmail 플러그인, Calendar 플러그인, Drive 플러그인 따로 설치할 필요 없습니다. `gws` 명령어 하나면 충분합니다.

핵심 포인트: **gws에는 MCP Server가 내장되어 있습니다.**

MCP를 대체하는 게 아니라, MCP를 Agent의 표준 인터페이스로 채택한 겁니다. Claude Code든 다른 Agent든 MCP 프로토콜로 gws에 연결하면 모든 Google 서비스를 사용할 수 있습니다.

| 기존 모델 | 새로운 모델 |
|-----------|------------|
| 커뮤니티가 MCP wrapper 제작 | 벤더가 CLI + MCP 내장으로 직접 제공 |
| 서비스별 MCP 플러그인, 각각 관리 | 같은 벤더의 모든 서비스를 하나의 CLI로 |
| Agent가 인간이 만든 도구를 MCP로 호출 | Agent 전용 CLI 제공, MCP는 인터페이스일 뿐 |
| 파편화, 품질 들쭉날쭉 | 공식 유지보수, 일관된 품질 |

---

## 기존 MCP보다 토큰 효율이 높다

기술적으로 중요한 차이점이 있습니다.

기존 MCP Server는 매 요청 시 전체 도구 스키마를 Agent의 컨텍스트 윈도우에 로드합니다. 도구가 많을수록 스키마가 커지고, 소비하는 토큰도 늘어납니다.

CLI는 다릅니다. Agent는 몇 가지 명령어 패턴만 알면 되고, 터미널을 통해 실행합니다. 모든 로직은 CLI 내부에서 처리되고 결과만 돌려줍니다.

간단히 말하면: **MCP는 도구를 Agent의 머릿속에 넣는 것. CLI는 Agent가 밖으로 손을 뻗어 도구를 조작하는 것.**

후자가 토큰을 덜 쓰고, 더 빠르고, 더 안전합니다. CLI 자체에 보안 메커니즘을 넣을 수 있거든요. gws는 `--dry-run`(시뮬레이션)과 `--sanitize`(프롬프트 인젝션 방지) 기능을 내장하고 있습니다.

---

## 40개 이상의 내장 Agent Skills

gws에는 40개 이상의 Agent Skills이 포함되어 있습니다. Markdown 형식의 작업 매뉴얼로, Agent가 읽으면 어떻게 조작해야 하는지 바로 파악합니다.

이 설계가 영리한 이유는 AI Agent가 가장 잘하는 게 문서를 읽고 따라하는 것이기 때문입니다. 복잡한 API 바인딩도, 특정 언어의 SDK도 필요 없습니다.

"Agent에게 매뉴얼을 주면, Google Workspace 전체를 조작할 수 있다"는 뜻입니다.

---

## Karpathy의 예측이 현실이 되고 있다

Andrej Karpathy가 최근 예측했습니다. CLI가 Agent 세계의 공용어가 될 것이라고. 파편화된 GUI 조작과 일관성 없는 API wrapper를 대체할 것이라고.

그의 논리: **CLI는 가장 기계 친화적인 인간-컴퓨터 인터페이스입니다.** 구조화된 입력, 구조화된 출력, 예측 가능, 자동화 가능. GUI는 인간용이고, API wrapper는 인간이 기계를 위해 만든 다리입니다. 하지만 CLI는 태생적으로 기계 친화적입니다.

Google Workspace CLI는 이 예측을 검증합니다. 앞으로 더 많은 벤더가 따라올 겁니다:

- Notion CLI
- Slack CLI (이미 존재)
- GitHub CLI (`gh` — 이미 성숙)
- Stripe CLI
- 모든 SaaS 서비스들

모든 서비스가 자체 CLI를 갖게 되면, Agent는 더 이상 서드파티 wrapper에 의존하지 않아도 됩니다.

---

## 우리 팀에 미치는 영향

저희 팀은 실제로 MCP를 쓰고 있습니다. Gmail과 Calendar을 MCP Server를 통해 Agent가 조작합니다. gws를 보고 첫 반응은 "바꿔야 하나?"였습니다.

**단기 답변: 서두를 필요 없습니다.**

이유:
1. **gws는 아직 v0.4.x** — 초기 버전, 안정성 관찰 필요
2. **기존 MCP가 잘 작동 중** — 고장 나지 않았으면 고치지 않는다
3. **gws와 MCP는 공존 가능** — 양자택일이 아닙니다

중장기적으로 gws가 안정화되면, 여러 개의 Google MCP 플러그인을 하나의 도구로 교체하는 것이 합리적입니다. 유지보수 부담이 확 줄어드니까요.

---

## 그래서 MCP는 죽는 건가?

아닙니다. 오히려 정반대입니다.

**MCP는 "커뮤니티 자체 제작"에서 "벤더 네이티브 지원"으로 전환 중입니다.**

gws가 MCP Server를 내장한다는 건 Google이 MCP를 Agent 도구의 표준 인터페이스로 인정한다는 뜻입니다. 대기업이 적극적으로 통합할 때 생태계 전체가 강해집니다.

진짜 변하고 있는 건 **도구의 공급 방식**입니다. "인간이 Agent를 위해 플러그인을 설치해주는 것"에서 "벤더가 Agent용 도구를 직접 제공하는 것"으로.

Agent는 "인간이 환경을 설정해줘야 일할 수 있는 존재"에서 "도구를 받으면 스스로 일하는 존재"로 진화하고 있습니다.

---

## 한 줄 요약

Google Workspace CLI는 MCP의 킬러가 아닙니다. 첫 번째 도미노입니다.

대기업이 Agent 전용 도구를 만들기 시작하면, Agent의 능력 한계는 더 이상 커뮤니티 플러그인에 의해 결정되지 않습니다.

이 변화는 대부분의 사람들이 예상하는 것보다 빠르게 일어날 것입니다.
