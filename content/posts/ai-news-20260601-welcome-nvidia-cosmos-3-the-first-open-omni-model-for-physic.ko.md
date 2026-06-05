---
title: "NVIDIA Cosmos 3 물리 AI 전모달 오픈소스 첫 공개"
date: "2026-06-01T06:05:08+00:00"
draft: true
author: Judy
summary: "AI 뉴스 속보: NVIDIA가 Cosmos 3를 출시했습니다. 「Physical AI」를 위해 설계된 오픈소스 전모달 세계 기반 모델(World Foundation Model)로, 영상 생성·물리 추론·행동 출력을 단일 아키텍처에 통합한 것이 최대 특징입니다. 기존에 개별 배포가 필요했던 Cosmos Predict, Transfer, Reason, Poli..."
description: "JudyAI Lab AI 뉴스 속보 — 출처: Hugging Face Blog"
categories:
  - "AI 뉴스"
tags:
  - "AI 속보"
  - "community"
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
news_source: "Hugging Face Blog"
news_source_url: "https://huggingface.co/blog/nvidia/cosmos-3-for-physical-ai"
news_pipeline_version: "v1-rss-only"
---

## 📰 핵심 요약

> NVIDIA가 Cosmos 3를 공개했습니다. 「Physical AI」를 위해 설계된 오픈소스 전모달 세계 기반 모델(World Foundation Model)로, 영상 생성·물리 추론·행동 출력을 단일 아키텍처로 통합한 것이 가장 큰 특징입니다. 기존에 Cosmos Predict, Transfer, Reason, Policy 등 여러 개별 모델을 따로 배포해야 했던 방식을 대체합니다.

Cosmos 3는 혼합 트랜스포머(Mixture-of-Transformers, MoT) 백본을 채택하여 두 개의 병렬 처리 흐름으로 동작합니다. 자기회귀(AR) 시퀀스는 추론과 이해를 담당하고, 확산(DM) 시퀀스는 반복적인 노이즈 제거 생성을 담당합니다. 두 흐름은 독립적인 파라미터를 사용하지만 공유 어텐션 메커니즘을 통해 상호 교류하며, 텍스트·이미지·영상·오디오·행동 등 다양한 모달리티를 동시에 처리할 수 있습니다.

모델은 두 가지 버전으로 출시됩니다. Cosmos 3 Nano는 8B 추론기와 8B 생성기를 탑재하여 워크스테이션급 하드웨어(RTX PRO 6000 등)를 대상으로 하며, Cosmos 3 Super는 32B+32B로 확장되어 NVIDIA Hopper 및 Blackwell 고급 GPU를 지원하고 대규모 합성 데이터 생성과 연구에 적합합니다. 활용 분야는 로봇 조작, 자율주행, 물류 창고 안전, 스마트 공간 등을 아우릅니다. 모델은 Hugging Face에 업로드되었으며 Diffusers 프레임워크의 `Cosmos3OmniPipeline`에 통합되었고, 로봇·물리 시뮬레이션·주행·물류 창고·공간 추론·인체 동작을 포함한 6종의 합성 학습 데이터셋도 동시에 오픈소스로 공개되었습니다.

---

## 💬 JudyAI Lab 관점

> ⏳ Commentary 추가 예정 (finalize_commentary 단계에서 Hermes가 추가하며, 반드시 사실 기반이어야 하고 정보를 임의로 확장하지 않음)

---

## 📅 원문 정보

- **발행 시각**: 2026-06-01T04:44
- **원문 링크**: [https://huggingface.co/blog/nvidia/cosmos-3-for-physical-ai](https://huggingface.co/blog/nvidia/cosmos-3-for-physical-ai)
---

## 🔗 延伸閱讀

- [個性化AI模型的崛起：如何為您的企業量身定制智能](https://judyailab.com/zh-tw/posts/rise-of-customized-ai-models/)
- [從交易想法到上線跑單：AI 輔助策略開發的真實流程](https://judyailab.com/zh-tw/posts/trading-concept-to-production-code-with-ai/)
