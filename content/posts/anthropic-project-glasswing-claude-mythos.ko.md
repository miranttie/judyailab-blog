---
title: "Anthropic이 1억 달러를 보안에 투자하다: Project Glasswing과 미공개 Claude Mythos의 실력"
date: "2026-04-08T06:00:00+00:00"
draft: false
author: "Judy"
summary: "Anthropic이 Project Glasswing을 발표하며 1억 달러 AI 크레딧과 400만 달러 기부금을 투입했다. 미공개 Claude Mythos Preview 모델로 수천 개의 제로데이 취약점을 발견했는데, 27년 된 OpenBSD 취약점과 16년 된 FFmpeg 취약점까지 AI가 자율적으로 찾아냈다."
description: "Anthropic이 Project Glasswing 보안 프로젝트를 발표하고 1억 달러 이상을 투입해 미공개 Claude Mythos Preview 모델로 전 세계 핵심 소프트웨어 인프라를 자율 스캔했다. 테스트 몇 주 만에 수천 개의 제로데이 취약점을 발견했으며, 27년 된 OpenBSD 원격 크래시 취약점과 16년 된 FFmpeg 취약점이 포함되어 있다. 이 글에서는 AI 산업, 보안 산업, 오픈소스 커뮤니티에 미치는 영향을 분석한다."
categories:
  - "AI 뉴스"
tags:
  - "Anthropic"
  - "Claude"
  - "AI 보안"
  - "Project Glasswing"
  - "Claude Mythos"
  - "제로데이 취약점"
  - "오픈소스 보안"
series:
  - "AI Agent 완전 가이드"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
lastmod: 2026-04-10T14:10:30+00:00
faq:
  - q: "Project Glasswing이 정확히 무엇인가요?"
    a: "Anthropic이 1억 달러 AI 크레딧과 400만 달러 기부를 투입해 전 세계 핵심 소프트웨어 인프라를 자율 스캔하는 보안 프로젝트입니다. AWS, Apple, Google, Linux Foundation 등 약 40개 조직이 파트너로 참여합니다."
  - q: "Claude Mythos Preview는 공개 모델인가요?"
    a: "공개되지 않은 비공개 모델입니다. 현재는 Glasswing 파트너와 핵심 인프라 관리 약 40개 조직에만 제한 제공됩니다. 일반 사용자나 개발자는 API로 접근할 수 없습니다."
  - q: "Claude Opus 4.6과 Mythos Preview의 실력 차이는 얼마나 나나요?"
    a: "CyberGym 취약점 재현 벤치마크에서 Mythos Preview는 83.1%, Opus 4.6은 66.6%로 16포인트 이상 차이가 납니다. 보안 분야에서는 매우 의미 있는 격차입니다."
  - q: "발견된 취약점 중 가장 충격적인 사례는 무엇인가요?"
    a: "27년 된 OpenBSD 원격 크래시 취약점과 16년 된 FFmpeg 취약점입니다. 특히 FFmpeg은 자동화 퍼징 도구가 500만 번 이상 실행했지만 못 찾았는데 AI가 단번에 발견했습니다."
  - q: "이 AI가 공격에 악용될 위험은 없나요?"
    a: "위험이 있어서 비공개를 유지 중입니다. Anthropic은 동일 능력이 곧 악의적 행위자에게도 확산될 것이라 판단해, 먼저 취약점을 메우는 선제 방어 전략을 택했습니다."
  - q: "일반 개발자나 기업이 지금 활용할 방법이 있나요?"
    a: "현재로서는 직접 활용이 불가능합니다. 본인이 핵심 인프라를 관리하는 조직이 아니라면, Glasswing이 발견한 취약점 패치를 신속히 적용하는 것이 현실적인 대응입니다."
  - q: "AI 주도 사이버 공격이 이미 발생했다는 게 사실인가요?"
    a: "사실입니다. Anthropic은 한 중국 국가 지원 해커 조직이 AI 에이전트로 전 세계 약 30개 대상을 자율 침투한 사례를 기록상 최초로 확인했다고 공식 발표했습니다."

---
*이 글은 JudyAI Lab의 AI 엔지니어링 시리즈 중 하나입니다 — 100편 이상 발행된 가이드, 60개국 5,000명 이상의 주간 독자가 읽는 콘텐츠로, AI 에이전트·트레이딩 시스템·콘텐츠 파이프라인의 실전 운영에 초점을 둡니다.*

4월 7일 아침에 일어나 폰을 보다가 Anthropic의 공지를 발견했다. 또 모델 업데이트 같은 거겠지 하고 클릭했는데——

새 모델 출시가 아니었다. 아직 공개하지 않은 모델로 전 세계 핵심 소프트웨어를 스캔해서, 몇 주 만에 **수천 개의 제로데이 취약점**을 파냈다는 내용이었다.

그 순간 든 생각: 잠깐, 이거 무슨 SF 영화 시나리오야?

---

## Project Glasswing: 1억 달러짜리 보안 승부수

Anthropic은 이 프로젝트에 **Project Glasswing**이라는 이름을 붙였다. 유리날개나비(Greta oto)에서 따온 이름으로, 날개가 거의 투명한 나비다. 의미는 명확하다: 소프트웨어의 보안 상태를 투명하게 보이게 만들겠다는 것.

구체적인 약속은 다음과 같다:

- **1억 달러 AI 크레딧**을 파트너들에게 제공하여 취약점 스캔에 활용
- **400만 달러 직접 기부**를 오픈소스 보안 단체에 전달
- 발견된 모든 취약점은 반드시 업계와 공유

파트너 라인업이 대단하다. AWS, Apple, Google, Microsoft, NVIDIA가 테크 기업 쪽이고, CrowdStrike, Palo Alto Networks, Broadcom, Cisco가 보안 기업이다. JPMorganChase가 금융업을 대표하고, Linux Foundation이 오픈소스 커뮤니티를 대표한다. 거기에 핵심 소프트웨어 인프라를 관리하는 약 40개 조직이 더 있다.

Anthropic 혼자 하는 게 아니라, 산업 전체를 끌어들인 것이다.

---

## Claude Mythos Preview: Anthropic이 가진 최강의 카드

프로젝트의 핵심 무기는 **Claude Mythos Preview**라는 모델이다. Anthropic이 지금까지 개발한 가장 강력한 모델이며, 현재 공개되지 않았다.

먼저 수치를 보자. CyberGym 취약점 재현 벤치마크에서 Mythos Preview는 **83.1%**를 달성했고, 현재 공개된 최강 모델인 Claude Opus 4.6는 **66.6%**였다. 16포인트 이상의 차이로, 이 수준의 벤치마크에서는 상당히 의미 있는 도약이다.

하지만 숫자보다 더 충격적인 것은 실제로 해낸 일이다.

---

## AI가 발견한 취약점들

### 27년 된 OpenBSD 취약점

OpenBSD가 보안 분야에서 어떤 위치인지는 말할 필요도 없다. 보안성으로 유명한 운영체제이고, 핵심 개발자들이 수십 년간 보안 강화를 해왔다. 그런데 Mythos Preview가 **27년** 동안 존재해온 원격 크래시 취약점을 찾아냈다 — 누구든 원격으로 OpenBSD 머신을 다운시킬 수 있는 취약점이다.

27년이다. 얼마나 많은 보안 전문가가 이 코드를 봤고, 얼마나 많은 자동화 도구가 스캔했는데, 아무도 잡지 못했다.

### 16년 된 FFmpeg 취약점

FFmpeg은 거의 모든 영상 처리 소프트웨어의 기반 의존성이다. VLC부터 Chrome까지 다 쓴다. Mythos Preview가 **16년** 동안 숨어있던 취약점을 찾아냈는데, 여기서 진짜 핵심은 — 자동화 퍼징 도구가 이미 **해당 코드를 500만 번 이상 실행**했지만, 매번 문제를 발견하지 못했다는 것이다.

AI는 한 번 보고 바로 알아챘다.

### Linux 커널 권한 상승 체인

Mythos Preview는 단일 취약점만 찾는 것이 아니었다. Linux 커널에서 **여러 취약점을 자율적으로 찾아 공격 체인으로 연결**하여, 일반 사용자에서 시작해 시스템 전체를 장악하는 데까지 도달했다.

이런 '취약점 발견 → 연결 방법 구상 → 완전한 공격 경로 구축' 능력은, 과거에는 최고 수준의 레드팀 인력이 수 주에서 수 개월은 걸려야 가능했던 일이다.

게다가 Anthropic에 따르면, 이 모든 것이 거의 모델의 **완전 자율** 수행이었으며, 사람의 안내가 필요 없었다고 한다.

---

## 왜 공개하지 않는가?

Anthropic은 이 모델의 양면성을 정확히 알고 있다. 취약점을 찾을 수 있는 AI는 공격에도 쓸 수 있다. 그래서 Mythos Preview는 현재 Glasswing 파트너와 약 40개 핵심 인프라 관리 조직에만 제공된다.

그들의 원문은 이렇다: "AI 발전 속도를 감안하면, 이러한 능력은 곧 확산될 것이며, 안전한 배포를 약속하지 않는 행위자들의 손에 들어갈 수도 있다."

이 말의 진짜 뜻은: 우리가 지금 이 능력을 갖고 있고, 남들도 곧 갖게 될 것이다. 악의적 행위자가 먼저 갖기 전에, 우리가 먼저 취약점을 메우겠다는 것이다.

Anthropic은 또 하나의 사실을 밝혔다 — 기록상 최초로 AI가 주도한 대규모 사이버 공격이 발견되었다는 것이다. 한 중국 국가 지원 해커 조직이 AI 에이전트를 사용해 전 세계 약 30개 대상에 자율적으로 침투했다.

이것은 이론적 위협이 아니다. 이미 현실에서 벌어지고 있다.

---

## 보안 산업에 미친 충격파

소식이 전해지자 월가의 반응은 직접적이었다. CrowdStrike, Palo Alto Networks, Zscaler, SentinelOne, Okta 등 주요 보안 기업들의 주가가 **5%에서 11%까지 하락**했다.

투자자들의 논리는 간단했다: AI가 자율적으로 취약점을 찾고 수정할 수 있다면, 전통적인 보안 기업의 경쟁 우위는 어디에 있는가?

다만 개인적으로 이 반응은 다소 과도하다고 본다. Glasswing은 현재 방어 측 도구이고, AI가 발견한 취약점도 결국 인간 개발자가 수정해야 한다. 단기적으로는 보안 산업의 업그레이드 촉매제에 가깝지, 대체재라고 보기 어렵다. 하지만 장기적으로 AI가 취약점 발견뿐 아니라 자동 패치까지 할 수 있게 된다면, 산업 전체의 가치사슬이 재정의될 것은 분명하다.

---

## 오픈소스 커뮤니티에 대한 의미

이것이 Glasswing의 가장 중요한 측면일 수 있다. Linux Foundation CEO인 Jim Zemlin이 직설적으로 말했다:

> "오픈소스 소프트웨어는 현대 시스템의 코드 대부분을 구성합니다... 이러한 핵심 오픈소스 라이브러리의 유지보수자들이 차세대 AI 모델을 활용해 취약점을 사전에 발견하고 수정할 수 있게 해주는 것, Project Glasswing은 현상을 바꿀 수 있는 실행 가능한 경로를 제시합니다."

오픈소스 소프트웨어의 보안은 줄곧 구조적 문제였다. 유지보수자들은 대부분 자원봉사자이거나 소규모 팀으로, 포괄적인 보안 감사를 수행할 자원이 부족하다. 하지만 그들이 만든 코드는 전 세계 상용 소프트웨어가 의존하고 있다. 1억 달러의 AI 크레딧이 이런 프로젝트들에 이전에는 불가능했던 보안 스캔을 제공할 수 있다면, 실질적인 개선이 될 것이다.

---

## 나의 관점

매일 AI 에이전트 팀과 함께 일하는 사람으로서, 이 소식을 접한 소감은 복잡하다.

**기대되는 부분**: Claude 시리즈의 능력 상한선이 또 한 단계 크게 올라갔다. Mythos Preview가 CyberGym에서 Opus 4.6보다 16포인트 높다는 것은, 차세대 공개 모델의 추론 및 코드 이해 능력이 정말 기대된다는 뜻이다.

**우려되는 부분**: AI가 자율적으로 취약점을 발견하고 연결하는 능력은 양날의 검이다. Anthropic이 현재 비공개로 방어에만 사용하기로 한 것은 책임감 있는 판단이다. 하지만 그들 스스로도 말했듯이, 이 능력은 머지않아 확산될 것이다.

**현실적인 부분**: AI 보안에 대해 어떤 견해를 갖든, 확실한 것이 하나 있다 — 핵심 소프트웨어를 유지보수하고 있다면, 지금이야말로 AI 보조 보안 감사를 진지하게 검토할 때다. 27년간 사람이 찾지 못한 취약점을 AI가 몇 주 만에 발견했다. 이 격차는 점점 더 벌어질 것이다.

---

## 핵심 정리

| 항목 | 내용 |
|------|------|
| 프로젝트명 | Project Glasswing |
| 발표일 | 2026년 4월 7일 |
| 투입 자원 | 1억 달러 AI 크레딧 + 400만 달러 기부금 |
| 핵심 모델 | Claude Mythos Preview (미공개) |
| 벤치마크 | CyberGym 83.1% (Opus 4.6은 66.6%) |
| 주요 발견 | 수천 개 제로데이 취약점 (OpenBSD 27년, FFmpeg 16년) |
| 파트너 | AWS, Apple, Google, Microsoft, NVIDIA, CrowdStrike 등 |
| 공개 상태 | 파트너 한정, 일반 공개 미정 |

2026년 들어 AI 산업에서 가장 중요한 발표다. 더 강한 모델이 나왔기 때문이 아니라, AI가 실제 세계 보안에서 압도적 우위를 대규모로 실증한 첫 사례이기 때문이다 — 그리고 그 우위를 방어에 사용하기로 선택했다.

Anthropic의 이 한 수, 존경할 만하다.

## 참고 자료

- [Anthropic의 새 AI 모델 "Claude Mythos Preview"가 사이버 보안을 뒤흔들다 — Project Glasswing 이야기](https://contents.premium.naver.com/vbcoding/vibecoding/contents/260408213303626zs)
- [클로드 미토스 미리보기: 앤트로픽의 미공개 AI, 수십 년간 인간들이 놓쳤던 리눅스와 오픈BSD의 취약점을 발견하다 – Bitcoin News](https://news.bitcoin.com/ko/keullodeu-mitoseu-miribogi-aenteuropigyi-migonggae-ai-susip-nyeonggan-ingandeuri-nochyeotdeon-rinukseuwa-opeunbsd-ui-chwiyakjeomeul-balgyeonhada/)
- [Anthropic Loosens Secrecy Around Claude Mythos Findings | Let's Data Science](https://letsdatascience.com/news/anthropic-loosens-secrecy-around-claude-mythos-findings-f540ac3f)
