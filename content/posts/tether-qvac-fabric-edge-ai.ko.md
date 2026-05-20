---
title: "Tether QVAC Fabric: 폰에서 LLM 학습하기"
date: "2026-03-17T14:00:00+00:00"
draft: false
author: Judy
summary: "Tether가 QVAC Fabric LLM 프레임워크를 출시하여 모바일 폰에서 대형 언어 모델을 최초로 파인튜닝하는 데 성공했습니다. 이 프레임워크는 LoRA, BitNet, Vulkan 컴퓨팅을 통합하여 클라우드 서버 없이 로컬 AI 모델 학습을 가능하게 하며, 개발자와 기업을 위한 프라이버시 우선, 초저비용 AI 솔루션을 제공합니다."
description: "세계 최대 스테이블코인 USDT를 운영하는 회사가 혁신적인 QVAC Fabric 프레임워크를 출시하여 모바일 폰에서 대형 언어 모델을 최초로 파인튜닝하는 데 성공했습니다. 효율적인 파인튜닝인 LoRA, 1비트 파라미터 양자화인 BitNet, 크로스플랫폼 Vulkan 컴퓨팅을 결합하여 AI가 클라우드에서 개인 기기로 이동하고, 진정한 탈중앙화 AI 시대를 열립니다."
categories:
  - "AI 엔지니어링"
  - "제품"
tags:
  - "Tether"
  - "QVAC Fabric"
  - "엣지 AI"
  - "LoRA"
  - "BitNet"
  - "모바일 AI"
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "QVAC Fabric이란 무엇인가요?"
    a: "QVAC Fabric은 Tether가 출시한 오픈소스 프레임워크로, 폰에서 직접 대형 언어 모델을 파인튜닝할 수 있게 하여 진정한 온디바이스 AI 학습을 실현합니다."
  - q: "폰에서 실제로 LLM을 학습할 수 있나요?"
    a: "네. QVAC Fabric은 Dynamic Tiling 기술을 통해 모바일 메모리 한계를 해결하며, Qualcomm Adreno 830 GPU에서 약 13시간 만에 파인튜닝을 완료합니다."
  - q: "QVAC Fabric은 어떤 기술을 사용하나요?"
    a: "효율적인 파인튜닝인 LoRA, 1비트 파라미터 양자화인 BitNet, 크로스플랫폼 Vulkan GPU 컴퓨팅 인터페이스를 통합합니다."
  - q: "BitNet의 장점은 무엇인가요?"
    a: "BitNet은 모델 파라미터를 16비트/32비트에서 단 3개의 값(-1, 0, +1)으로 압축하여 메모리 요구량을 크게 줄이고, 폰에서 대형 모델을 실행할 수 있게 합니다."
  - q: "QVAC Fabric은 개발자에게 어떤 도움이 되나요?"
    a: "개발자는 개인 기기에서 무료로 모델을 파인튜닝하고, 데이터 프라이버시를 보호하며, AI 개발 비용과 장벽을 획기적으로 줄일 수 있습니다."
hidden: true
ShowToc: true
TocOpen: true
image: []
alt: "Tether QVAC Fabric Mobile AI Training Framework"
lastmod: 2026-05-13T05:50:03+00:00

---
*이 글은 JudyAI Lab의 AI 엔지니어링 시리즈 중 하나입니다 — 100편 이상 발행된 가이드, 60개국 5,000명 이상의 주간 독자가 읽는 콘텐츠로, AI 에이전트·트레이딩 시스템·콘텐츠 파이프라인의 실전 운영에 초점을 둡니다.*

## 그래서 Tether, 스테이블코인 회사가 갑자기 AI를?

저처럼 AI와 암호화폐의 교차점을 관심을 가지고 지켜본다면, 이 소식을 듣고 잠시 멈춰 생각했을 것입니다.

Tether — 네, USDT의 그 Tether — **QVAC Fabric LLM**이라는 것을 출시했습니다. 간단히 말하면: **이제 폰에서 대형 언어 모델을 파인튜닝할 수 있습니다.**

추론만 실행하는 것이 아닙니다. 실제로 학습하는 것입니다. 폰에서요.

저의 첫 번째 반응은 "뭐라고?"였지만, 기술적 세부사항을 살펴보니 처음 생각했던 것보다 훨씬 더 흥미롭다는 것을 깨달았습니다.

---

## 그래서 QVAC Fabric이란 정확히 무엇인가요?

먼저 이게 어떤 문제를 해결하는지 설명하겠습니다.

오늘날 LLM을 파인튜닝하려면 보통 다음이 필요합니다: A100 또는 H100 GPU, 클라우드 계정(AWS/Azure/GCP), 그리고 데이터를 타사의 서버에 업로드합니다.

대기업에게는 이것이 문제가 아닙니다. 하지만 개인 개발자나 중소기업에게는요? 높은 비용, 큰 프라이버시 위험, 그리고 클라우드 서비스 제공자에 완전히 의존해야 합니다.

QVAC Fabric의 접근 방식은 전체 파인튜닝 파이프라인을 로컬 기기로 이동시키는 것입니다. 다음과 같습니다:

### 1. llama.cpp에 LoRA 넣기

[LoRA](https://arxiv.org/abs/2106.09685)(Low-Rank Adaptation)는 현재 가장 인기 있는 효율적인 파인튜닝 방법입니다 — 원본 모델의 가중치는 건드리지 않고, 작은 학습 가능한 파라미터 세트만 추가합니다. QVAC Fabric은 llama.cpp 런타임 환경에 직접 전체 LoRA 파인튜닝을 통합한 첫 번째 프레임워크입니다.

이것은 PyTorch가 필요하지 않다는 것을 의미합니다, CUDA도 필요하지 않습니다 — llama.cpp만 있으면 파인튜닝을 실행할 수 있습니다.

### 2. CUDA 대신 Vulkan 사용

이것은 가장 inteligente한 설계 결정 중 하나입니다.

CUDA는 NVIDIA GPU에서만 실행됩니다. 그러나 [Vulkan](https://www.vulkan.org/)은 크로스플랫폼 GPU 컴퓨팅 인터페이스로, NVIDIA, AMD, Intel, Apple Silicon, Qualcomm Adreno를 지원합니다.

**하나의 코드베이스로 모든 하드웨어에서 실행할 수 있습니다.** 폰, 노트북, 데스크톱, 서버 — 동일한 파이프라인입니다.

### 3. Dynamic Tiling으로 모바일 메모리 병목 해결

일반적인 폰 GPU는 몇 GB만의 메모리만 가지고 있습니다 — 전체 행렬 연산을 수행하기에는 전혀 충분하지 않습니다. QVAC Fabric의 해결책은 **Dynamic Tiling** — 대형 행렬 연산을 작은 청크로 분해하고, 순차적으로 처리한 후, 결과를 조립합니다.

속도 희생은 있지만, 트레이드오프는: **폰에서 실제로 이것을 실행할 수 있습니다.**

---

## 실제로는 얼마나 빠르나요?

제가 가장 궁금했던 데이터입니다:

| 기기 | 파인튜닝 시간 |
|--------|-----------------|
| NVIDIA RTX 4090 (데스크톱 GPU) | 약 45분 |
| Qualcomm Adreno 830 (폰 GPU) | 약 13시간 |

13시간이 오래 걸리는 것처럼 들립니까? 하지만 이것은 **인류 최초로 폰 수준의 GPU에서 LLM 파인튜닝이 완료된 것입니다.** 그리고 밤새 잘 동안 그냥 두면 됩니다.

품질 측면에서, 그들의 벤치마크 결과는 업계 표준 테스트에서 PyTorch와 맞먹으며, 일부 지표는 오히려 약간 더 좋습니다.

---

## BitNet 1-bit: AI 모델을 믿을 수 없을 정도로 얇게 만들기

LoRA 파인튜닝 외에도, QVAC는 Microsoft의 [BitNet](https://arxiv.org/abs/2310.11453) 아키텍처 지원도 통합합니다.

기존 LLM은 각 파라미터를 16비트 또는 32비트 부동소수점 숫자로 저장합니다. BitNet은 파라미터를 단 세 개의 값으로 압축합니다: **-1, 0, +1**.

어떤 효과일까요? 원래 몇 GB 또는 수십 GB를 차지하던 모델의 메모리 사용량이 일반 폰이 처리할 수 있는 수준으로 크게 줄어듭니다.

QVAC의 BitNet LoRA 프레임워크는 전 세계 최초의 크로스플랫폼 구현을 주장합니다 — Llama3, Qwen3, Gemma3와 같은 주요 모델 아키텍처를 지원합니다.

---

## 왜 Tether인가요?

왜 스테이블코인 회사가 AI 프레임워크를 만들려고 할까요?

실제로, Tether는 지난 1년간 이를 위해 포지셔닝해왔습니다. 그들에는 다음을 포함하는 QVAC 에코시스템이 있습니다:

- **QVAC Workbench** — 로컬 AI 워크스테이션 앱
- **QVAC Health** — 건강 데이터 AI
- **Genesis II** — 1,480억 토큰 학습 데이터셋
- 그리고 지금 **QVAC Fabric** — 파인튜닝 프레임워크

Paolo Ardoino(Tether CEO)은 담백하게 말했습니다:

> "AI는 큰 클라우드 플랫폼에만 의해 제어되어서는 안 됩니다. QVAC Fabric은 개인과 기업이 자신의 조건으로 추론을 실행하고 강력한 모델을 파인튜닝할 수 있게 합니다."

실제로 이것은 암호화폐 공간과 같은 핵심 정신입니다: **탈중앙화, 주권적 자기임신, 중개자 없음.**

이번에는 금융이 아니라 AI일 뿐입니다.

---

## 왜 중요한가요? 나의 생각

우리 팀은 매일 다양한 AI 모델을 다루고 있습니다 — Claude, Gemini, MiniMax — 여러 모델 간의 조정만으로도 하나의 기술셋입니다. 그래서 이 소식을 봤을 때, 단순히 "멋지다"라는 생각 외에도, 이것이 전체 에코시스템을 어떻게 변화시킬지 생각했습니다.

**주목할 세 가지 방향:**

**첫째, 프라이버시.** 지금 문서를 ChatGPT로 분석 보내면 해당 데이터는 클라우드로갑니다. 파인튜닝된 모델을 직접 폰에서 실행할 수 있다면, 데이터가 기기를 떠나지 않습니다—이것은 의료, 법률, 금융 분야에서 대 Breakthrough입니다.

**둘째, 비용.** 클라우드에서 모델을 파인튜닝하면 수십에서 수백 달러까지 들 수 있습니다. 노트북으로 이것이 가능하다면, 개인 개발자와 소규모 팀의 장벽은 거의제로로 떨어집니다.

**셋째, 개인화.** 누구나 완전히 자신만의 AI를 학습할 수 있습니다 — 자신의 데이터, 자신의 글쓰기 스타일, 자신의 전문 지식을 사용해서요. 일반적인 GPT가 아니라 **자신의** GPT. 이것은 사실 우리 팀이 지금까지 해온 일입니다, 그냥 API + 프롬프트 엔지니어링 + 에이전트 아키텍처를 사용해서요. 앞으로 이것을 로컬에서 할 수 있다면, 많은 접근 방식이 완전히 달라질 것입니다.

---

## 지금 사용할 수 있나요?

네. QVAC Fabric은 Apache 2.0 오픈소스 라이선스로 출시되었으며, [GitHub](https://github.com/tetherto/qvac-fabric-llm.cpp)에서 직접 다운로드할 수 있습니다. 파인튜팅 부분은 [qvac-rnd-fabric-llm-finetune](https://github.com/tetherto/qvac-rnd-fabric-llm-finetune) 저장소에 있습니다. Hugging Face에는 미리 컴파일된 바이너리와 어댑터도 있습니다.

지원되는 모델은 Llama3, Qwen3, Gemma3를 포함하며, iOS, Android, Windows, macOS, Linux를 커버합니다.

하지만 솔직히, 지금 이 제품의 대상 청중은 여전히 개발자입니다. 시작하려면 llama.cpp와 모델 파인튜닝에 대한 기본적인 이해가 필요합니다. 하지만 오픈소스 커뮤니티의 속도를 볼 때, 누군가 이것을 원클릭 설치 앱으로打包할 soon할 것 같습니다.

---

## 결론

전체적인 "Tether가 AI 함"이라는 것은 странный 피벗처럼 들리지만, 생각해보면 실제로는 많은 sense가 있습니다 — 스테이블코인은 탈중앙화 금융을 원하고, QVAC는 탈중앙화 AI를 원합니다. 기본 철학은 정확히 동일합니다.

그리고 그들은 큰 약속만 하는 것이 아니라, 실제로 무언가를 만들고, 오픈소스로 공개하고, 벤치마크를 실행했습니다. "폰에서 LLM 파인튜닝"이라는 것 자체가 이미 기술적 이정표입니다.

AI의 미래는 클라우드에 있을 필요가 없습니다. 그것은 바로 당신의 주머니에 있을 수 있습니다.

---

*추가 읽기:*
- [Tether 공식 발표](https://tether.io/news/tether-data-introduces-qvac-fabric-llm-the-edge-first-llm-inference-runtime-and-generalized-llm-lora-fine-tuning-framework-for-modern-ai-models-on-heterogeneous-gpus-smartphones-laptops-and-server/)
- [QVAC 공식 웹사이트](https://qvac.tether.io/)
- [QVAC Fabric 기술 심층 분석](https://tether.io/blog/qvac-fabric-llm-marks-a-turning-point-in-ai-personalization-bringing-fine-tuning-from-data-centers-to-everyday-devices/)

<!-- product-cta -->
{{< product-cta product="course" >}}

## 핵심 수치

- 5000 users (Threads + 뉴스레터 구독자)
- $0 광고 비용 (100% 오가닉)
- 95% 콘텐츠는 J + 멀티 에이전트 팀 작성
