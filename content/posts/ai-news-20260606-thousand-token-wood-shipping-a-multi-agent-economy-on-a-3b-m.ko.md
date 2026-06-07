---
title: "Thousand Token Wood 멀티 에이전트 경제 실전기"
date: "2026-06-06T00:05:09+00:00"
draft: false
author: Judy
summary: "AI 뉴스 속보: 천대목(Thousand Token Wood)은 Build Small Hackathon에 출품된 멀티 에이전트 경제 시뮬레이션 시스템으로, Qwen2.5-3B 소형 모델을 사용해 다섯 마리의 숲 동물 캐릭터가 가상 시장에서 다섯 가지 상품을 돌 화폐로 거래합니다. 전체 시스템은 vLLM으로 Modal에 배포되고, 프론트엔드는 Gradio를 사용하며,..."
description: "JudyAI Lab AI 뉴스 속보 — 소형 LLM으로 멀티 에이전트 경제 시뮬레이션 구현 사례. 출처: Hugging Face Blog"
categories:
  - "AI 뉴스"
tags:
  - "AI 속보"
  - "community"
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
news_source: "Hugging Face Blog"
news_source_url: "https://huggingface.co/blog/build-small-hackathon/thousand-token-wood-sim"
news_pipeline_version: "v1-rss-only"
commentary_engine: "hermes-v1"
---

## 📰 핵심 요약

> 천대목(Thousand Token Wood)은 Build Small Hackathon에 출품된 멀티 에이전트 경제 시뮬레이션 시스템으로, Qwen2.5-3B 소형 모델을 사용해 다섯 마리의 숲 동물 캐릭터가 가상 시장에서 다섯 가지 상품을 돌 화폐로 거래합니다. 전체 시스템은 vLLM으로 Modal에 배포되고, 프론트엔드는 Gradio를 사용하며, 매 라운드마다 단 한 번의 배치 GPU 호출로 모든 캐릭터의 의사결정이 완료되어 연속 시뮬레이션을 비용 효율적으로 운영할 수 있습니다.

기술팀은 시장에 인위적인 희소성 메커니즘이 없으면 과잉 생산으로 인해 거래 유인이 사라진다는 사실을 발견하고, 세 가지 제약을 도입했습니다: 한 끼에 같은 종류의 식료품은 한 단위만 섭취 가능, 식료품은 부패하여 비축 불가, 겨울에는 장작 수요가 급증하지만 공급자는 한 명뿐. 이 세 가지 규칙이 직접적으로 버블과 붕괴를 만들어냈습니다. 1929년 뱅크런을 원형으로 한 시나리오에서 캐릭터 Oona가 꿀을 팔아 돌 화폐를 얻으면서, 꿀 가격이 수 라운드 만에 10에서 3으로 폭락했습니다. 장작은 겨울 위기로 인해 4에서 7로 급등했습니다.

15라운드 테스트에서 75번의 API 호출이 100% 유효 JSON 출력을 달성했으며, 매 라운드 3~9건의 거래가 성사되었고, 지니 계수는 0.14에서 0.38로 확대되어 부의 격차가 자연스럽게 나타났습니다. 모델은 JSON 형식은 안정적이지만 경제적 추론 능력은 다소 약했습니다. 해결책은 더 큰 모델로 교체하는 것이 아니라, 프롬프트에 각 캐릭터의 생산 품목, 구매 금지 목록, 재고 부족 목록과 예시를 명확히 나열하는 것이었습니다. 저자의 핵심 결론은 "구조가 규모보다 중요하다"입니다.

---

## 💬 JudyAI Lab 관점

Thousand Token Wood는 Qwen2.5-3B 소형 모델로 버블과 부의 분화를 구현해냈습니다. 이는 반직관적인 사실 하나를 알려줍니다: 더 큰 모델이 아니라 더 좋은 규칙 설계가 필요하다는 것입니다.

꿀 가격이 수 라운드 만에 10에서 3으로, 장작이 4에서 7로 변동한 것은 모델의 경제적 추론 능력 덕분이 아니라, 세 가지 인위적인 희소성 규칙 덕분이었습니다. 식료품 부패, 한 끼 한 단위 제한, 겨울철 단독 공급자. 이 규칙들이 캐릭터에게 실질적인 거래 유인을 만들어냈고, 버블도 자연스럽게 나타났습니다. 프롬프트에 각 캐릭터의 생산 품목, 구매 금지 목록, 재고 부족 목록을 명시함으로써 75번의 API 호출에서 100% 유효 JSON 출력을 달성했고, 지니 계수는 0.14에서 0.38로 확대되어 부의 분화가 의도치 않아도 나타났습니다. 이 사례에서 우리가 주목하는 핵심은 이것입니다: 멀티 에이전트 시스템이 기대대로 작동하지 않을 때, 더 큰 모델로 서둘러 교체하기 전에 먼저 환경 제약을 강화하고 프롬프트를 구체적으로 작성해야 한다는 점입니다.

멀티 에이전트 파이프라인을 설계하고 있다면, 한 가지 질문을 스스로에게 던져보세요: 외부 제약을 모두 제거했을 때 에이전트들이 서로 상호작용할 이유가 있나요? 답은 대개 모델 크기가 아니라 규칙 설계 안에 있습니다.

---

## 📅 원문 정보

- **발행 시각**: 2026-06-05T22:18
- **원문 링크**: [https://huggingface.co/blog/build-small-hackathon/thousand-token-wood-sim](https://huggingface.co/blog/build-small-hackathon/thousand-token-wood-sim)

---

## 🔗 더 읽어보기

- [2026 오픈소스 LLM 실전: AI 팀에서 MiniMax M2.7을 선택한 이유](https://judyailab.com/zh-tw/posts/open-source-llm-agent-team-2026/)
- [AgenticTrade에서 AI API 등록하는 방법 — 5분 빠른 가이드](https://judyailab.com/zh-tw/posts/how-to-list-ai-api-on-agentictrade/)