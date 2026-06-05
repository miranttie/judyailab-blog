---
title: "Agentforce vs 1인 AI 팀: 소규모 창업자 선택법"
date: "2026-06-03T05:00:49+00:00"
draft: true
author: "Judy"
summary: "Salesforce Agentforce는 기업형 AI 에이전트 플랫폼 노선을 걸으며, 가격이 Flex 포인트·대화량·사용자 수 라이선스를 중심으로 구성됩니다. Judy AI Lab은 Claude·MiniMax·Gemini 구독으로 5개 에이전트를 구성해 월 비용을 수백 달러로 유지합니다. solopreneur를 위한 세 가지 의사결정 경로를 제시합니다."
description: "Agentforce 가격 구조를 분석하고 Claude·MiniMax·Gemini 기반 5인 AI 팀과 비교, 소규모 창업자 선택 가이드."
categories:
  - "AI Agent"
tags:
  - "Agentforce"
  - "AI Agent"
  - "Solopreneur"
  - "Claude"
  - "AI 팀"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
series:
  - "AI Agent 완전 가이드"
---

## Agentforce는 무엇을 파는가? 기업형 AI 에이전트를 SaaS로

Salesforce는 Agentforce를 '기업형 AI 지능 에이전트 플랫폼'으로 포장하며, 핵심은 Atlas Reasoning Engine입니다. 복잡한 요청을 소작업으로 분해하고, 단계적으로 평가하며, 자율적으로 실행하고, 팀과 부서를 넘나들며 확장할 수 있습니다 [Source: https://www.salesforce.com/agentforce/]. 가격 방식은 Salesforce 스타일 그대로입니다: Flex 포인트, 대화량 과금, 또는 사용자 수 라이선스 중 하나를 선택합니다 [Source: https://www.salesforce.com/tw/agentforce/pricing/].

그 옆에는 더 큰 신호도 있습니다. Gartner는 2029년까지 자율형 AI가 일반적인 고객 서비스 문제의 80%를 자율적으로 해결해 운영 비용을 30% 절감할 것이라고 예측합니다 [Source: https://www.cxtoday.com/contact-center/agentic-ai-gartner-predicts-80-of-customer-problems-solved-without-human-help-by-2029/].

이야기는 그럴듯하게 들립니다. 하지만 Judy AI Lab이 발견한 맹점이 있습니다: Agentforce의 타깃 고객은 IT 부서와 대기업이지, 혼자 일하는 소규모 사업자가 아닙니다.

## Judy AI Lab의 AI 팀 구성

Judy AI Lab 팀은 5개의 에이전트를 운영합니다. J는 기술 전략가 겸 COO 역할로 Claude Opus를 사용하고, 미미와 아다는 각각 마케팅과 제품 엔지니어링을 담당하며 MiniMax M2.7을 씁니다. 리리는 콘텐츠 디렉터로 OpenRouter의 Hermes 모델에 연결되어 있고, 샤오위에는 QA 담당으로 Gemini 구독 버전을 사용합니다.

Agentforce와 비교했을 때 이 조합의 가장 큰 차이점은 — 플랫폼이 제공하는 능력이 아니라 Judy가 직접 조합한 능력이라는 것입니다. 각 에이전트는 자체적인 역할, 도구, inbox를 가집니다. 기능을 추가하려면 프롬프트를 수정하거나 스킬을 추가하면 되고, SaaS 업체의 로드맵을 기다릴 필요가 없습니다.

번거로워 보일 수 있지만, 소규모 사업자에게 이것이 바로 Agentforce가 줄 수 없는 것입니다: 완전한 커스터마이징 자유도, 라이선스 제한 없음, 원하는 만큼 실행 가능.

## 직접 계산해보자: 구독료 차이는 한두 배가 아니다

먼저 Claude 쪽 공식 가격을 살펴보겠습니다. Pro 플랜은 월 USD $20, Max 플랜은 월 $100, Team 플랜은 월납 기준 1인당 $30(5인 팀 최소 $150부터), 연납 기준으로는 1인당 $25(5인 팀 최소 $125부터)입니다 [Source: https://www.anthropic.com/pricing]. MiniMax와 Gemini 구독 버전의 개인 월 요금도 모두 세 자릿수 달러 이내입니다.

합산하면 Judy AI Lab이 5개 에이전트를 운영하는 구독 비용은 수백 달러 범위에 머물며, 대화량 과금도 없고 per-seat 함정도 없습니다.

Agentforce 쪽은 공식 가격을 공개하고 있습니다: Flex 포인트는 10만 포인트당 USD $500, 대화 방식은 대화당 $2, 사용자 라이선스는 1인당 월 $125부터 시작합니다 [Source: https://www.salesforce.com/tw/agentforce/pricing/]. 투명해 보이지만, 소규모 사업자에게 이 세 가지 옵션은 모두 불친절합니다 — 대화량 과금은 쓸수록 더 내는 구조이고, per-seat은 사람이 늘어날 때마다 $125씩 추가되며, Flex 포인트는 미리 사용량을 예측해 일괄 구매해야 합니다. 본질적으로 IT 예산이 있는 기업을 위한 설계입니다.

## 소규모 사업자의 세 가지 경로: 지금 어디에 서 있는가

첫 번째, 완전 DIY: Claude Code나 유사한 에이전트 CLI를 사용해 직접 MCP(Model Context Protocol, AI와 외부 도구가 소통하는 표준 인터페이스)를 연결하고, 직접 프롬프트를 작성하고, 직접 cron을 설정합니다. 학습 곡선이 가장 가파르지만 비용이 가장 낮고 유연성이 가장 큽니다.

두 번째, Claude Pro나 ChatGPT Plus를 '반자동 어시스턴트'로 활용합니다: 프로그래밍 없이 AI를 카피라이터, 리포트 작성자, FAQ 담당자로 씁니다. 한 달 $20으로 AI를 업무 흐름에 먼저 도입한 후, 업그레이드 여부를 결정합니다.

세 번째가 바로 Agentforce 경로입니다: 이미 Salesforce CRM을 보유하고, 연결할 IT 부서가 있으며, 고객 서비스 티켓 양이 자동 분류가 필요할 만큼 많을 때입니다. 이때야 비로소 Agentforce의 가치가 구독 비용을 정당화할 수 있습니다.

경로에 옳고 그름이 없습니다. 적합한지 아닌지만 있을 뿐입니다.

## 세 가지 신호가 나타날 때 비로소 Agentforce를 고려하라

첫째, 대화량이 직접 구독 방식으로 감당하기 어려울 만큼 커져서 한계 비용이 Agentforce의 대화당 $2 과금보다 오히려 높아질 때입니다.

둘째, 컴플라이언스나 감사가 필수 조건이 될 때 — 일부 산업에서는 SOC 2, ISO 27001 같은 인증이 필요하며, DIY로는 취득할 수 없습니다.

셋째, 에이전트 수가 5개에서 50개로 늘어나 권한 분리와 작업 로그 감사가 필요해질 때입니다. 이때 플랫폼의 1인당 월 $125 가치가 유연성 손실을 상쇄하게 됩니다.

이 세 가지 기준을 넘기 전까지는, 월 수백 달러로 회사 전체를 운영하는 방식이 현재 solopreneur에게 가장 합리적인 선택입니다.

문제는 처음부터 'Agentforce냐 DIY냐'가 아닙니다. 지금 당신이 어느 신호 위에 서 있는가입니다.