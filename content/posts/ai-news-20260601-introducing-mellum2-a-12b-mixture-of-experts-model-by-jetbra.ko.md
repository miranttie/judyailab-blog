---
title: "JetBrains Mellum2: MoE 개발자 전용 모델 출시"
date: "2026-06-01T18:05:44+00:00"
draft: false
author: Judy
summary: "AI 뉴스 속보: JetBrains가 2026년 6월 1일 Mellum2를 출시했습니다. 이는 혼합 전문가 아키텍처(MoE) 기반의 120억 파라미터 오픈소스 모델로, 추론 시마다 25억 개의 활성 파라미터만 가동하여 동급 모델 대비 추론 속도가 2배 이상 빠르고, 배포 비용이 크게 낮아졌으며, Apache 2.0 라이선스로 공개되었습니다.

Mellum2는 최신 대형 모델을 대체하려는 것이 아니라..."
description: "JudyAI Lab AI 뉴스 속보: JetBrains Mellum2 출시, MoE 기반 120억 파라미터 경량 오픈소스 모델"
categories:
  - "AI 뉴스"
tags:
  - "AI 속보"
  - "community"
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
news_source: "Hugging Face Blog"
news_source_url: "https://huggingface.co/blog/JetBrains/mellum2-launch"
news_pipeline_version: "v1-rss-only"
commentary_engine: "hermes-v1"
---

## 📰 핵심 요약

> JetBrains가 2026년 6월 1일 Mellum2를 출시했습니다. 이는 혼합 전문가 아키텍처(MoE) 기반의 120억 파라미터 오픈소스 모델로, 추론 시마다 25억 개의 활성 파라미터만 가동하여 동급 모델 대비 추론 속도가 2배 이상 빠르고, 배포 비용이 크게 낮아졌으며, Apache 2.0 라이선스로 공개되었습니다.

Mellum2는 최신 대형 모델을 대체하려는 것이 아니라, 다중 모델 협업 시스템에서 '포커스 모델'로서 고빈도 경량 태스크에 집중하도록 설계되었습니다. 여기에는 프롬프트 분류, 도구 선택, RAG 파이프라인의 컨텍스트 압축 및 요약, 서브에이전트 계획 검증, 코드 자동완성이 포함됩니다. 모델은 텍스트와 코드 두 가지 모달리티만 처리하며, 아키텍처를 간결하게 유지하기 위해 멀티모달 기능을 의도적으로 제외했습니다. 특히 사내 코드나 기밀 데이터를 처리해야 하는 기업이 프라이빗 환경에서 자체 배포하기에 적합합니다.

코드 생성, 추론, 과학, 수학 등 다양한 벤치마크 테스트에서 Mellum2는 동급 오픈소스 모델과 경쟁력 있는 수준을 달성했습니다. 기술 보고서는 arXiv(번호 2605.31268)에 동시 공개되었으며, 모델 가중치는 HuggingFace에서 다운로드할 수 있습니다.

---

## 💬 JudyAI Lab 관점

JetBrains가 출시한 Mellum2가 주목할 만한 이유는 최신 대형 모델에 도전해서가 아니라, '충분하면 된다'는 설계 철학을 명확히 보여주기 때문입니다. 120억 파라미터 중 25억만 가동하여 추론 속도는 2배, 비용은 대폭 절감됩니다.

이 사례는 우리가 관찰해온 분명한 트렌드를 반영합니다. 다중 모델 협업 아키텍처에서 각 노드마다 플래그십 모델을 사용할 필요는 없다는 것입니다. Mellum2의 설계 선택은 시사하는 바가 큽니다. 텍스트와 코드만 처리하고, 멀티모달 기능을 의도적으로 제거하여, 프롬프트 분류·도구 선택·RAG 파이프라인 컨텍스트 압축·서브에이전트 계획 검증·코드 자동완성 등 고빈도이지만 심층 추론 요구도가 상대적으로 낮은 태스크에 성능을 집중시켰습니다.

사내 코드나 기밀 데이터를 프라이빗 환경에서 처리하고자 하는 기업 입장에서, Apache 2.0 라이선스와 낮은 배포 비용은 이런 모델을 매우 현실적인 선택지로 만들어 줍니다.

다중 모델 협업 시스템을 설계하고 있다면, 지금 당장 할 수 있는 것이 있습니다. 각 태스크 노드를 나열하고, '가장 강력한 모델이 필요 없는' 위치를 찾아, Mellum2 같은 포커스 모델로 교체해 보세요. 이것이 추론 비용을 낮추는 가장 직접적인 출발점이 될 수 있습니다.

---

## 📅 원문 정보

- **발행 시간**: 2026-06-01T15:45
- **원문 출처**: [https://huggingface.co/blog/JetBrains/mellum2-launch](https://huggingface.co/blog/JetBrains/mellum2-launch)

---

## 🔗 더 읽어보기

- [맞춤형 AI 모델의 부상: 기업을 위한 인공지능 맞춤 구현 방법](https://judyailab.com/zh-tw/posts/rise-of-customized-ai-models/)
- [트레이딩 아이디어에서 실전 운용까지: AI 보조 전략 개발의 실제 프로세스](https://judyailab.com/zh-tw/posts/trading-concept-to-production-code-with-ai/)