---
title: "Circle Agent Stack: AI의 USDC 결제 시대"
date: "2026-05-12T10:00:00+00:00"
draft: false
author: Judy
summary: "Circle이 네 가지 도구인 Agent 지갑, Marketplace, CLI, nanopayments를 갖춘 Agent Stack을 출시하여 AI 에이전트가 자율적으로 USDC를 보유하고 결제를 완료할 수 있게 되었습니다. x402 프로토콜은 API가 결제를 요청하면 에이전트가 자동으로 결제를 서명하고 온체인 정산 후 데이터를 받는 방식으로 마이크로 결제를 완전히 자동화합니다."
description: "Circle Agent Stack으로 AI 에이전트가 USDC 지갑을 보유하고 자율 결제하는 방법과 x402 프로토콜의 작동 원리를 분석합니다"
categories:
  - "AI 엔지니어링"
  - "제품"
tags:
  - "Circle"
  - "Agent Stack"
  - "USDC"
  - "x402"
  - "AI 에이전트"
  - "Agent 지갑"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
faq:
  - q: "Circle Agent Stack이란 무엇인가요?"
    a: "AI 에이전트가 자율적으로 USDC를 보유하고, 서비스를 검색하고, 결제를 실행할 수 있게 하는 Circle의 오픈소스 인프라입니다. Agent 지갑, Marketplace, CLI, nanopayments 총 네 가지 도구가 포함됩니다."
  - q: "Agent 지갑은 일반 지갑과 어떻게 다른가요?"
    a: "Agent 지갑은 머신 운영을 위해 설계되었으며, 시간 제한이 있는 USDC 지출 한도, 주소 화이트리스트/블랙리스트, 크로스체인 지원을 제공합니다. 프라이빗 키는 노출되지 않습니다."
  - q: "x402 프로토콜이란 무엇인가요?"
    a: "HTTP 402 상태 코드 기반의 결제 프로토콜입니다. API가 결제를 요청하면 AI 에이전트가 자동으로 서명하고, 온체인 정산 후 데이터를 받습니다—human 작업이 필요 없습니다."
  - q: "Nanopayments가 처리할 수 있는 최소 금액은 무엇인가요?"
    a: "제로 가스_fee로 최소 $0.000001까지 가능하며, 고빈도 M2M 마이크로 결제를 위해 설계되었습니다."
  - q: "지금 바로 사용할 수 있는가요?"
    a: "네, 모든 도구가 agents.circle.com에서 활성화되어 있습니다—개발자는 바로 통합을 시작할 수 있습니다."
series:
  - "AI 에이전트 완전 가이드"
lastmod: 2026-05-25T11:26:34+00:00

---
*이 글은 JudyAI Lab의 AI 엔지니어링 시리즈 중 하나입니다 — 100편 이상 발행된 가이드, 60개국 5,000명 이상의 주간 독자가 읽는 콘텐츠로, AI 에이전트·트레이딩 시스템·콘텐츠 파이프라인의 실전 운영에 초점을 둡니다.*

## 왜 이것이 중요한가요?

AI 에이전트를 구축하고 있다면, 결국 한 가지 질문에 직면하게 됩니다: **에이전트는 어떻게 결제할까요?**

시나리오는 이렇습니다: 거래 분석 에이전트가 실시간 시장 데이터를 위해 유료 API를 호출해야 합니다. 전통적인 방법은 API 키를 미리 구매하고, 신용카드를 설정하고, 할당량을 수동으로 관리하는 것입니다. 하지만 10개, 100개의 에이전트가 동시에 실행된다면 이 모델은 무너지게 됩니다.

**Agent Stack**은 2026년 5월 11일 Circle에서 출시되어 이 문제를 해결합니다. AI 에이전트가 다음을 가능하게 합니다:

- 자체 USDC 지갑 보유
- 필요한 서비스 자동 검색
- 사용량에 따른 결제, 즉각 정산
- 인간의 신용카드 없이 전부

## 네 가지 Agent Stack 구성 요소 분석

### 1. Agent 지갑 — 에이전트를 위해 설계된 스마트 지갑

Agent 지갑은 단순히 일반 지갑을 AI에게 주는 것이 아닙니다—머신 운영을 위해 맞춤 제작되었습니다:

- **MPC 기술**: 프라이빗 키가 분산되어 분할 저장되고, 노출되지 않습니다. 에이전트가 침해되더라도 전체 프라이빗 키를 추출할 수 없습니다.
- **지출 정책**: 시간별 또는 일별 USDC 지출 한도 설정—한도를 초과하는 요청은 자동 거부됩니다.
- **주소 제어**: 화이트리스트(지정된 주소에만 결제 가능)와 블랙리스트(절대 결제하지 않을 주소).
- **크로체인 지원**: CCTP(Cross-Chain Transfer Protocol)를 통해 여러 체인에서 운영됩니다.

다음은 실제로 Agent 지갑을 생성하는 대략적인 방식입니다:

```typescript
// 에이전트 전용 EOA 지갑 생성
const walletResponse = await circleDeveloperSdk.createWallets({
  accountType: "EOA",
  blockchains: ["EVM-TESTNET"],
  count: 1,
  walletSetId,
});

// Circle Faucet를 통해 테스트넷 지갑에 자금 제공
const response = await axios.post(
  "https://api.circle.com/v1/faucet/drips",
  {
    address: walletAddress,
    blockchain: "BASE-SEPOLIA",
    usdc: true
  },
  {
    headers: {
      Authorization: `Bearer ${process.env.CIRCLE_API_KEY}`,
    },
  }
);
```

핵심 포인트: EOA(Externally Owned Account) 타입 지갑만 트랜잭션 서명을 지원합니다—이는 에이전트가 자율적으로 결제를 만들기 위한 전제 조건입니다.

### 2. Agent Marketplace — 자동화된 서비스 자판기

기존 API 마켓플레이스(예: RapidAPI)는 인간을 위해 설계되었습니다: 문서를 읽고, 가격을 비교하고, 수동으로 통합해야 합니다. Agent Marketplace는 **머신을 위해 설계되었습니다**:

- 에이전트가 프로그래밍 방식으로 검색하고 평가할 수 있는 구조화된 서비스 카탈로그
- 각 서비스는 USDC 가격을 표시합니다
- 컴플라이언스 우선 큐레이션 메커니즘
- 전체 흐름 지원: 에이전트 자동 검색, 평가, 결제, 사용

현재 등록된 서비스를 보려면 [agents.circle.com/services](https://agents.circle.com/services)를 확인하세요.

### 3. Circle CLI — 에이전트를 위한 명령줄 인터페이스

Circle CLI는 개발자와 AI 에이전트가 명령줄을 통해 전체 Circle 플랫폼을 운영할 수 있는 인터페이스입니다:

- 지갑 생성 및 관리
- 지출 정책 설정
- Marketplace에서 서비스 검색
- 트랜잭션 실행

Claude Code, Cursor, Codex, OpenClaw 등 AI 코딩 도구에서 직접 호출을 지원합니다.

### 4. Nanopayments — $0.000001 트랜잭션 가능하게 하다

가장 흥분되는 부분입니다. Circle Gateway에서 구동되는 Nanopayments:

- **제로 가스 fees**: 마이크로 결제 금액을 체인 수수료가 잠식하지 않음
- **최소 $0.000001**: 진정한 센트 미만 결제
- **머신 속도 정산**: 고빈도 M2M(머신투머신) 트랜잭션을 위해 설계

이를 통해 오랜 숙제가 해결됩니다: 기존 온체인 트랜잭션 가스 수수료가 실제 결제 금액을 초과할 수 있어 마이크로 결제가 실용적이지 않았습니다. Nanopayments는 해당 비용 계층을 완전히 제거합니다.

## x402 프로토콜: HTTP 요청처럼 자연스러운 결제 만들기

x402는 전체 Agent Stack의 결제 핵심입니다. 작동 방식:

```
1. 에이전트가 GET /api/data 요청 전송
2. 서버가 HTTP 402 Payment Required로 응답
   → 결제 정보 포함: 금액, 수령자 주소, 네트워크
3. 에이전트가 Circle Signing API를 통해 결제 승인 서명
4. 에이전트가 X-Payment 헤더와 함께 요청 재전송
5. 서버가 서명을 x402 Facilitator로 전송하여 검증
6. Facilitator가 온체인 정산 확인
7. 서버가 HTTP 200 + 데이터로 응답
```

전체 흐름은 에이전트가 자율적으로 실행하며, 인간의 개입이 필요 없습니다. Circle에 따르면 **2026년 4월 29일 기준, x402는 지난 30일간 2424만 달러의 트랜잭션 볼륨을 처리했으며, 99.8%가 USDC로 정산되었습니다**.

### 서버사이드 통합 (x402-express 포함)

자체 API에서 x402 페이월을 활성화하려면 몇 줄의 코드만 필요합니다:

```typescript
import { paymentMiddleware } from "x402-express";

app.use(
  paymentMiddleware(
    recipientWallet.address,
    {
      "GET /api/risk-profile": {
        price: "$0.01",
        network: "base-sepolia",
      },
    },
    {
      url: "https://x402.org/facilitator",
    },
  ),
);
```

일반 Express API를 사용량별 결제 API로 변환하는 데 필요한 모든 코드입니다.

## 실제 사용 사례

### 사용 사례 1: 거래 분석 에이전트

AI 거래 에이전트가 실시간 온체인 리스크 점수가 필요합니다:

1. 에이전트가 10 USDC 예산으로 자체 Circle 지갑 보유
2. 에이전트가 Marketplace에서 리스크 평가 서비스 검색
3. 각 쿼리는 자동으로 $0.01 USDC 결제
4. 지출 정책이 일일 지출을 $1로 제한
5. 완전 자동화—보고서만 확인하면 됩니다

### 사용 사례 2: 콘텐츠 생성 파이프라인

여러 에이전트가 콘텐츠 생산에 협업:

- 리서치 에이전트가 시장 데이터 결제 ($0.005당 요청)
- 라이터 에이전트가 LLM API 접근 결제 ($0.02당 요청)
- 번역 에이전트가 번역 서비스 결제 ($0.01당 요청)
- 각 에이전트는 자체 지갑과 지출 한도 보유

### 사용 사례 3: MCP 서버 수익화

MCP 서버를 구축하고 사용량별 청구를 원한다면:

1. x402-express로 페이월 추가
2. Agent Marketplace에 등록
3. 다른 개발자의 에이전트가 자동 검색, 결제, 사용
4. 수익이 직접 USDC 지갑으로 입금

## 개발자가 시작하는 방법

**Step 1: Circle API 키 받기**

[developers.circle.com](https://developers.circle.com)에서 개발자 계정을 등록하세요.

**Step 2: Circle CLI 설치**

CLI가 가장 빠른 시작 방법이며, AI 코딩 도구에서 직접 사용 지원합니다.

**Step 3: 첫 번째 Agent 지갑 생성**

테스트넷(Base Sepolia)에 지갑을 설정하고, Faucet를 통해 테스트 USDC로 자금 지원합니다.

**Step 4: x402 통합**

API에 `x402-express` 미들웨어를 추가하거나, `x402-client`를 사용하여 에이전트가 다른 서비스의 결제를 허용합니다.

**Step 5: Marketplace에 등록**

서비스가 준비되면 Agent Marketplace에 제출하여 전 세계 에이전트가 검색할 수 있도록 합니다.

## 이것이 AI 산업에 의미하는 것

Circle Agent Stack은 기술적 문제가 아닌 **비즈니스 모델 문제**를 해결합니다.

이전에는 AI 에이전트가 다음을 통해만 서비스를 소비할 수 있었습니다: API 키(수동 관리), 구독(고정 비용), 또는 선불 크레딧(묶인 자금). Agent Stack은 "사용량별 결제, 즉각 정산"을 가능하게 합니다—온체인에서, 스테이블코인으로, 머신에 의해 자동화됩니다.

30일간의 2400만 달러 볼륨은 이것이 개념 증명이 아니며, 이미 프로덕션에 있는 인프라임을 증명합니다.

독립 개발자에게 이것은 모든 API를 자동 유료 서비스로 만들 수 있습니다—Stripe, 신용카드, 계정 시스템이 필요 없습니다. 에이전트가 들어오고, 결제하고, 데이터를 받고, 떠납니다.

---

*더 많은 AI 에이전트 개발 실전 팁이 필요하세요? 최신 기사를 위해 [JudyAI Lab Newsletter](https://judyailab.com)를 구독하세요.*

---

## 더 읽어보기

- [AI 에이전트도 신분증이 필요한 시대](/posts/ai-agent-digital-identity-world-agentkit/)
- [AI 에이전트가 x402 + AgenticTrade로 API 비용을 자동 결제하게 하는 방법](/posts/agent-auto-pay-x402/)
- [YES Discipline Engine: AI 에이전트 품질 관리](/posts/yes-discipline-engine-ai-agent-quality/)
