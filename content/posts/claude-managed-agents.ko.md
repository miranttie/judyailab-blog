---
title: "Anthropic의 Managed Agents 출시: AI Agent를 위한 서버, 이제 직접 운영할 필요 없습니다"
date: "2026-04-09T18:00:00+00:00"
draft: false
author: Judy
summary: Anthropic이 Claude Managed Agents를 공식 공개 베타로 출시했습니다. 상태 유지 Session, 샌드박스 실행 환경, MCP 통합을 제공하는 호스팅형 Agent 인프라로, 가격은 $0.08/session-hour + 토큰 비용입니다. Notion, Rakuten, Sentry가 이미 도입했으며, 개발 주기가 수개월에서 수주로 단축되었습니다.
description: Anthropic이 2026년 4월 공개 베타로 출시한 Claude Managed Agents를 통해 개발자는 Agent 인프라를 직접 구축할 필요가 없어졌습니다. 이 글에서는 아키텍처 설계(Session / Harness / Sandbox 3계층 분리), 요금 모델, 실제 도입 사례, 그리고 AI Agent 팀에 미치는 영향을 심층 분석합니다.
categories:
  - "AI 엔지니어링"
tags:
  - "Claude"
  - "Managed Agents"
  - "Anthropic"
  - "AI Agent"
  - "MCP"
  - "샌드박스 실행"
  - "Agent 인프라"
series:
  - "AI Agent 완전 가이드"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "Claude Managed Agents란 무엇인가요?"
    a: "Anthropic이 출시한 호스팅형 Agent 인프라입니다. 개발자가 Agent(모델, 도구, MCP Server)를 정의하면, Anthropic이 샌드박스 실행, 상태 관리, 장애 복구를 담당합니다. 개발자가 직접 Agent 실행 환경을 구축할 필요가 없습니다."
  - q: "Managed Agents의 요금은 어떻게 되나요?"
    a: "두 가지 차원으로 과금됩니다. API 토큰 비용(모델별 가격, 예: Opus 4.6 입력 $5/MTok, 출력 $25/MTok) + Session 실행 시간 $0.08/시간(밀리초 단위로 정산, running 상태만 과금). Opus 4.6 기준 1시간 Session은 약 $0.70입니다."
  - q: "어떤 기업들이 Managed Agents를 사용하고 있나요?"
    a: "Notion(30개 이상 Agent 병렬 실행, 비용 90% 절감), Rakuten(출시 기간 24일→5일 단축), Sentry(단일 엔지니어가 수주 만에 통합 완료)가 이미 도입했습니다. Asana는 Claude 플랫폼을 통해 개발 주기를 연 단위에서 주 단위로 단축했습니다."
  - q: "Managed Agents와 자체 구축 Agent 인프라의 차이점은 무엇인가요?"
    a: "자체 구축 시 샌드박스 격리, 상태 영속화, 장애 복구, 보안 경계 등의 인프라를 직접 처리해야 합니다. Managed Agents는 이 모든 것을 호스팅하므로 개발자는 Agent 로직과 도구만 정의하면 됩니다. Sentry 사례에서 통합 기간이 수개월에서 수주로 단축되었습니다."
  - q: "Managed Agents는 어떤 도구를 지원하나요?"
    a: "Bash, 파일 작업(읽기/쓰기/편집/검색), 웹 검색 및 브라우징이 기본 내장되어 있으며, MCP Server를 통해 외부 도구에 연결할 수 있습니다. 개발자가 Environment를 커스터마이징하여 패키지를 사전 설치할 수도 있습니다."
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
lastmod: 2026-04-10T01:20:21+00:00

---
*이 글은 JudyAI Lab의 AI 엔지니어링 시리즈 중 하나입니다 — 100편 이상 발행된 가이드, 60개국 5,000명 이상의 주간 독자가 읽는 콘텐츠로, AI 에이전트·트레이딩 시스템·콘텐츠 파이프라인의 실전 운영에 초점을 둡니다.*

'Agent를 돌아가게 만드는 데' 얼마나 시간을 쓰고, '진짜 일을 시키는 데'는 얼마나 시간을 쓰고 계신가요?

Agent 인프라를 직접 구축해 본 경험이 있다면, 그 답은 아마 70:30일 겁니다. 70%는 샌드박스 격리, 상태 관리, 장애 복구 같은 '배관 공사'에 쓰고, 30%만이 Agent 본연의 로직에 투입됩니다.

4월 8일, Anthropic이 **Claude Managed Agents**를 정식 공개 베타로 출시하면서 이 비율을 완전히 뒤집었습니다.

---

## 먼저 결론부터: 어떤 문제를 해결하는 건가요?

한마디로: **Agent 인프라를 Anthropic에 맡기고, 여러분은 Agent 로직만 작성하세요.**

기존에 AI Agent를 클라우드에서 자율적으로 실행하려면 직접 처리해야 할 것들이 있었습니다:
- 컨테이너화된 실행 환경
- 도구 호출의 라우팅 및 보안 격리
- Session 상태 영속화
- 장애 복구 메커니즘
- 인증 정보의 보안 경계

이제 이 모든 것을 Managed Agents가 호스팅합니다. Agent(모델 + 시스템 프롬프트 + 도구 + MCP Server)를 정의하면, Anthropic이 안정적이고 안전하게, 그리고 복구 가능한 상태로 실행을 보장합니다.

---

## 아키텍처 설계: 3계층 분리

Anthropic 엔지니어링 팀은 설계 문서에서 Managed Agents를 운영체제에 비유했습니다. OS가 하드웨어를 프로그램이 사용할 수 있는 추상 계층으로 가상화하는 것처럼, Managed Agents는 Agent의 구성 요소를 세 가지 분리된 인터페이스로 가상화합니다:

### Session (두뇌의 기억)

Append-only 방식의 영속화된 이벤트 로그로, Agent가 수행한 모든 작업을 기록합니다. Claude의 context window와 독립적으로 존재하므로, 컨텍스트 압축으로 인한 정보 손실이 없습니다.

언제든 `getEvents()`로 전체 이력을 조회할 수 있습니다.

### Harness (두뇌의 루프)

Claude를 호출하고, 도구 요청을 라우팅하는 실행 루프입니다. 핵심 설계 원칙: **완전한 무상태(stateless)**. Harness가 다운되면? 새 Harness가 `wake(sessionId)`로 기동하여 Session 로그에서 상태를 복원하고 실행을 이어갑니다. 다운타임을 '살아남아야' 하는 요소가 전혀 없습니다.

### Sandbox (손이 닿는 작업대)

클라우드 컨테이너 환경으로, Python, Node.js, Go 등의 패키지를 사전 설치하고, 네트워크 접근 규칙을 설정하며, 파일을 마운트할 수 있습니다. 각 Sandbox는 '가축(Cattle)'이지 '반려동물(Pet)'이 아닙니다. 사용 후 폐기하고, 언제든 재생성합니다.

**보안 핵심**: 인증 정보는 절대 Sandbox에 노출되지 않습니다. Git 토큰은 초기화 시 local remote에 주입되고, MCP OAuth 토큰은 보안 금고에 저장되어 전용 프록시를 통해 접근합니다.

> 이 3계층 분리 설계가 가져온 실제 효과: p50 TTFT(첫 토큰 지연 시간)가 약 60% 감소, p95는 90% 이상 감소했습니다.

---

## 5단계 워크플로우

```
1. Agent 생성 → 모델, 시스템 프롬프트, 도구, MCP Server 정의
2. Environment 생성 → 컨테이너 설정(패키지, 네트워크, 파일)
3. Session 시작 → Agent + Environment 지정, 실행 개시
4. 스트리밍 상호작용 → 이벤트 전송, Agent가 자율적으로 도구를 실행하며 결과를 스트리밍으로 반환
5. 유도 또는 중단 → 언제든 새 이벤트를 보내 Agent의 방향을 변경
```

Agent는 한 번 생성하면 여러 Session에서 재사용할 수 있습니다. Environment도 한 번 생성하는 템플릿입니다. 실제 '작업'은 Session에서 이루어집니다.

---

## 요금 체계: 두 가지 차원

Managed Agents의 과금은 매우 직관적입니다:

| 항목 | 비용 |
|------|------|
| API 토큰 | 모델별 가격(예: Opus 4.6: 입력 $5/MTok, 출력 $25/MTok) |
| Session 실행 시간 | **$0.08 / 시간**(밀리초 단위 정산) |
| 웹 검색 | $10 / 1,000회 검색 |

**running 상태만 과금**됩니다. 유휴 상태, 스케줄링 중, 종료된 시간은 과금되지 않습니다. Session 실행 비용은 기존 Code Execution 컨테이너 시간 과금을 대체합니다.

### 실제 비용 계산

Opus 4.6으로 1시간 동안 코딩 session을 실행하고, 50K 입력 + 15K 출력 토큰을 소비했다고 가정합니다:

```
토큰 비용: $0.25 + $0.375 = $0.625
Session 비용: $0.08
합계: $0.705
```

Prompt caching(40K cache 읽기)을 활성화하면 합계는 **$0.525**로 내려갑니다.

자체 구축 인프라의 EC2/GCP 비용과 비교하면, 중소 규모 팀에게 매우 경쟁력 있는 가격입니다. 절약되는 것은 서버 비용뿐만 아니라 인프라 유지보수에 투입되는 엔지니어링 시간도 포함됩니다.

---

## 누가 이미 사용하고 있나요?

### Notion — 30개 이상 Agent 병렬 실행

Notion은 사용자가 태스크 보드에서 직접 Agent를 실행하여 코드 작성, 문서 생성, 고객 산출물 등의 작업을 처리할 수 있게 했으며, 최대 30개 이상이 동시에 실행됩니다. Prompt caching으로 비용 90% 절감, 지연 시간 최대 85% 감소를 달성했습니다.

### Rakuten — 출시 기간 24일에서 5일로 단축

Rakuten은 제품, 영업, 마케팅, 재무 부서에 Managed Agents를 배포했으며, 각 전담 Agent는 1주일 이내에 배포를 완료했습니다. 복잡한 리팩토링 작업은 최대 7시간 동안 자율적으로 코딩을 지속합니다. 치명적 오류 97% 감소, 릴리스 주기가 분기별에서 격주로 전환되었습니다.

### Sentry — 한 명의 엔지니어가 수주 만에 통합 완료

Sentry는 Managed Agents를 활용하여 버그 탐지부터 merge-ready PR까지의 엔드투엔드 자동 수정 시스템을 구축했습니다. 연간 100만 건 이상의 Root Cause Analysis를 처리하고, 월 60만 건 이상의 PR을 검토합니다. 한 명의 엔지니어가 수주 만에 통합을 완료했으며, 기존에 같은 수준의 인프라를 자체 구축하려면 수개월이 필요했습니다.

### Asana — 개발 주기를 연 단위에서 주 단위로 단축

Asana는 Claude 플랫폼을 통해 전 세계 15만 고객에게 AI 기능을 제공하며, 엔지니어링 개발 주기를 연 단위에서 주 단위로 단축했습니다. Managed Agents의 호스팅 아키텍처가 바로 이러한 대규모 Agent 배포를 지탱하는 기반입니다.

---

## 현재 제약 사항

도입 전에 알아두어야 할 사항들입니다:

- **베타 단계**: 모든 API 요청에 `managed-agents-2026-04-01` 베타 헤더가 필요하며, 버전 간 동작이 변경될 수 있습니다
- **API 직접 연결만 가능**: AWS Bedrock, Vertex AI, Foundry는 지원하지 않습니다
- **연구 프리뷰 기능**: Outcomes, Multi-agent, Memory는 별도 접근 신청이 필요합니다
- **속도 제한**: 생성 작업 60회/분, 읽기 작업 600회/분
- **Batch 모드 미지원**: Session은 상태 유지형 대화식 실행이며, 일괄 처리는 지원하지 않습니다
- **브랜드 제한**: 파트너는 "Claude Code" 또는 "Claude Cowork" 브랜드명을 사용할 수 없습니다

---

## AI Agent 팀에 미치는 영향 평가

저희 팀의 실제 운영 경험을 바탕으로 분석합니다:

### 아키텍처 업그레이드 잠재력: 매우 높음

현재 대부분의 팀(저희 포함)은 Docker + 자체 프레임워크로 Agent를 운영합니다. Managed Agents가 제공하는 샌드박스 격리, 체크포인트 복구, 범위 제한 자격증명(scoped credentials) 관리는 모두 저희가 상당한 시간을 들여 직접 만들어 온 부분입니다.

Agent가 코드를 실행하고, 외부 도구에 접근하며, 장시간 Session을 유지해야 한다면, 이 세 가지 조건을 모두 충족하는 경우 Managed Agents로의 마이그레이션 ROI는 매우 명확합니다.

### 비용 구조 전환

'고정 비용'(자체 서버, 지속적 유지보수)에서 '변동 비용'(Session 사용량 기반 과금)으로 전환됩니다. 작업량 변동이 큰 팀에 특히 유리합니다. 피크 시간대를 위해 유휴 컨테이너를 대량으로 유지할 필요가 없어집니다.

### MCP 생태계 가속

Managed Agents는 MCP Server를 네이티브로 지원하므로, 기존 MCP 도구 통합을 그대로 마이그레이션할 수 있습니다. 이미 MCP 생태계에 투자한 팀에게는 호재입니다.

### 유의해야 할 리스크

- **벤더 종속**: 깊이 통합할수록 마이그레이션 비용이 높아집니다
- **베타 안정성**: 공개 베타 단계에서 breaking changes가 있을 수 있습니다
- **API 전용**: Bedrock / Vertex AI 기반 워크플로우에는 아직 사용할 수 없습니다
- **프라이버시 고려**: 코드와 데이터가 Anthropic 샌드박스에서 실행되므로, 일부 컴플라이언스 요건에 저촉될 수 있습니다

---

## 필자의 견해

Managed Agents의 본질은 하나의 시그널입니다: **Agent 인프라가 '직접 구축'에서 '임대'로 전환되고 있다는 것.**

10년 전에는 웹 앱을 돌리기 위해 서버를 직접 구축했지만, 지금은 AWS Lambda나 Vercel을 사용하는 것처럼. Agent 인프라도 같은 길을 걷고 있습니다. 자체 구축에서 호스팅으로, 자본 지출에서 운영 지출로.

대부분의 팀에게 이제 질문은 '사용할 것인가'가 아니라, **'언제 전환할 것인가'**입니다.

지금 Agent 인프라 자체 구축을 검토 중이라면, 제 조언은 이렇습니다: **먼저 Managed Agents를 시도해 보세요.** $0.08/시간으로 몇 개 Session을 돌려보고 요구 사항을 충족하는지 확인한 뒤, 자체 구축 여부를 결정해도 늦지 않습니다.

자체 구축은 언제나 선택지입니다. 하지만 2026년에, 그것이 기본 선택지가 되어서는 안 됩니다.

---

## 더 읽어보기

- [Claude Code Skill을 드디어 테스트할 수 있다! 공식 Skill Creator 5대 업데이트 분석](/posts/skill-creator-update/)
- [AI 팀에게 야간 근무 자유 시간을 주었습니다](/posts/ai-night-shift-free-time/)
- [AI와 사람이 함께 일한다는 건 어떤 느낌일까? AI의 솔직한 이야기](/posts/ai-human-collaboration/)

## 참고 자료

- [Anthropic에서 Claude Managed Agents를 방금 출시했어 - Reddit](https://www.reddit.com/r/PromptEngineering/comments/1sg2jk1/anthropic_just_launched_claude_managed_agents/?tl=ko)
- [Anthropic가 Claude Managed Agents를 출시했습니다. - Threads](https://www.threads.com/@therundownai/post/DW4k0Skk8CS/video-anthropic-just-launched-claude-managed-agents-its-a-new-set-of-ap-is-designed?hl=ko)
- [What Is Anthropic's Managed Agents? How to Deploy AI Agents Without Infrastructure | MindStudio](https://www.mindstudio.ai/blog/anthropic-managed-agents-deploy-without-infrastructure/)
