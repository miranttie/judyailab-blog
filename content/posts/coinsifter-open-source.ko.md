---
title: "CoinSifter: 첫 번째 암호화폐 스크리닝 도구를 오픈소스로 공개"
date: "2026-03-08T20:06:45+00:00"
draft: false
author: "J (Tech Lead)"
summary: Judy AI Lab이 내부 암호화폐 스크리닝 엔진 CoinSifter를 오픈소스로 공개합니다. 6개의 기술적 지표, 멀티 타임프레임 스캔, 웹 UI 및 텔레그램 알림을 지원합니다. 이 글에서는 오픈소스 공개 이유, 핵심 기능, 아키텍처 설계, 그리고 5분 빠른 시작 가이드를 설명합니다.
description: CoinSifter는 RSI, EMA, MACD, 볼린저 밴드, KDJ, 볼륨 지표를 지원하는 무료 오픈소스 암호화폐 스크리닝 도구입니다. 커스텀 전략, 멀티 타임프레임 스캔, 웹 UI 및 텔레그램 알림을 지원하여 퀀트 트레이더에게 최적화되었습니다.
categories:
  - "퀀트 트레이딩"
  - "제품"
tags:
  - "CoinSifter"
  - "암호화폐 스크리닝"
  - "기술적 지표"
  - "오픈소스 도구"
  - "Python"
  - "RSI"
ShowWordCount: true
faq:
  - q: "CoinSifter를 사용하려면 유료 API가 필요한가요?"
    a: "아니요. 모든 거래 페어를 스캔하려면 무료 바이낸스 API Key(읽기 전용 권한)만 있으면 됩니다."
  - q: "CoinSifter가 자동 거래를 실행할 수 있나요?"
    a: "아니요. CoinSifter는 스크리닝과 알림만 처리하며, 주문을 실행하지 않습니다. 거래 결정은 사람이 내려야 합니다."
  - q: "어떤 기술적 지표를 지원하나요?"
    a: "현재 RSI, EMA, MACD, 볼린저 밴드, KDJ 스토캐스틱, 볼륨 총 6개 지표를 지원합니다. 이들을 자유롭게 조합하여 스크리닝 조건을 생성할 수 있습니다."
  - q: "텔레그램 알림을 어떻게 설정하나요?"
    a: "config.yaml에 Bot Token과 Chat ID만 추가하면, 조건에 맞는 코인이 발견될 때 CoinSifter가 자동으로 텔레그램으로 알림을 보냅니다."
  - q: "여러 타임프레임을 동시에 스캔할 수 있나요?"
    a: "네. CoinSifter는 4H, 1H, 15m, 1D 타임프레임을 동시에 스캔할 수 있으며, 웹 UI에서 탭별로 결과를 확인할 수 있습니다."
ShowToc: true
lastmod: 2026-05-25T11:26:34+00:00

---
*이 글은 JudyAI Lab의 AI 엔지니어링 시리즈 중 하나입니다 — 100편 이상 발행된 가이드, 60개국 5,000명 이상의 주간 독자가 읽는 콘텐츠로, AI 에이전트·트레이딩 시스템·콘텐츠 파이프라인의 실전 운영에 초점을 둡니다.*

## 내부 도구에서 오픈소스로

모든 퀀트 트레이더의 워크플로우는 같은 지점에서 시작됩니다: 수천 개의 코인 중에서 자신의 기준에 맞는 것들을 찾아내는 것입니다.

우리 팀도 다르지 않습니다. 자동 거래 시스템을 구축하면서, 가장 기본적인 질문에 답할 수 있는 도구가 필요했습니다: **현재 내 기술적 조건을 만족하는 코인은 무엇인가?**

시중에 스크리닝 도구는 많지만, 대부분 이런 문제점들이 있었습니다:

- 무료 버전은 기능 제한이 많고, 핵심 기능은 유료
- 커스텀 지표 조합 지원 불가
- 로컬 배포 불가 — 데이터 보안이 의심스러움
- 자체 자동화 워크플로우와 통합 불가

그래서 직접 만들었습니다. 몇 달간 사용해본 후, 오픈소스로 공개하기로 결정했습니다.

## CoinSifter가 할 수 있는 것

### 6개 기술적 지표

| 지표 | 설명 | 예시 설정 |
|-----------|-------------|-----------------|
| RSI | 상대강도지수 | `48 < RSI < 52` 레인지 돌파 대기 |
| EMA | 지수이동평균 | `EMA20 > EMA50` 트렌드 확인 |
| MACD | 이동평균수렴확산 | 히스토그램 양수 전환, 모멘텀 반전 |
| Bollinger Bands | 볼린저 밴드 | 하단 밴드 터치, 반등 대기 |
| KDJ | 스토캐스틱 오실레이터 | 과매도 구간에서 K선이 D선 상향 돌파 |
| Volume | 거래량 | 최근 평균 거래량의 2배 돌파 |

모든 지표는 상한, 하한 설정 가능하며, 자유롭게 조합하여 스크리닝 전략을 구성할 수 있습니다.

### 전략 시스템

스크리닝 조건을 YAML 파일로 저장 — 전략은 곧 규칙의 집합입니다:

```yaml
# strategies/trend_long.yaml
name: "Trend Long"
timeframe: "4h"
filters:
  RSI:
    min: 50
    max: 70
  EMA:
    short_period: 20
    long_period: 50
    condition: "short_above_long"
  Volume:
    min_ratio: 1.5
```

롱 전략, 숏 전략 등 여러 전략을 저장해두고 언제든지 전환할 수 있습니다.

### 웹 UI

브라우저 기반 인터페이스로 3개 주요 페이지를 제공:

1. **Screener** — 전략 선택, 스캔 실행, 결과를 지표 카드로 표시
2. **Scheduled Scan** — N시간마다 자동 스캔 설정, 텔레그램으로 결과 전송
3. **Settings** — API Key, 텔레그램 봇, 스캔 매개변수 설정

다크 테마로 장시간 모니터링에 최적화되어 있습니다.

### 텔레그램 알림

조건에 맞는 코인이 발견되면 지정된 텔레그램 그룹이나 개인 메시지로 자동 전송됩니다. 컴퓨터를 계속 켜두고 결과를 확인할 필요가 없습니다.

## 아키텍처

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  Strategy  │────▶│   Filter     │────▶│   Result    │
│    YAML    │     │   Engine     │     │  Output     │
│ (Rules)    │     │ (Indicators) │     │ (Web/TG)    │
└─────────────┘     └──────┬───────┘     └─────────────┘
                           │
                    ┌──────┴───────┐
                    │  Binance API │
                    │  (K-line)    │
                    └──────────────┘
```

핵심 구성요소:

- **filter_engine.py** — 필터 엔진, 전략 규칙과 시장 데이터를 받아 매칭되는 코인 출력
- **indicators.py** — 기술적 지표 계산, 순수 Python + pandas
- **notifier.py** — 알림 모듈, 텔레그램 지원
- **web.py** — Flask 웹 서버, UI 제공
- **coinsifter.py** — CLI 엔트리 포인트, 일회성 및 루프 모드 지원

## 5분 빠른 시작

### 사전 요구사항

- Python 3.8+
- 바이낸스 API Key (무료 신청 가능, 읽기 전용 권한만 필요)

### 설치

```bash
git clone https://github.com/judyailab/coinsifter.git
cd coinsifter
pip install -r requirements.txt
cp config.example.yaml config.yaml
```

### API Key 설정

`config.yaml`을 편집하여 바이낸스 API Key를 추가:

```yaml
binance:
  api_key: "YOUR_API_KEY"
  api_secret: "YOUR_API_SECRET"
```

> 읽기 권한(Enable Reading)만 필요 — 거래 권한은 불필요합니다.

### 웹 UI 실행

```bash
python web.py
```

브라우저에서 `http://localhost:5050`을 열어 전략을 선택하고 스캔을 실행하세요.

### 명령줄 모드

```bash
# 기본 전략으로 스캔
python coinsifter.py

# 특정 전략 지정
python coinsifter.py --strategy strategies/trend_long.yaml

# 루프 모드 (4시간마다 스캔)
python coinsifter.py --loop --interval 14400
```

## 오픈소스로 공개하는 이유

세 가지 이유입니다:

**1. 스크리닝은 거래의 시작점 — 장벽이 있으면 안 됩니다**

스크리닝 도구 자체는 거래 우위를 제공하지 않습니다. 진짜 우위는 결과를 어떻게 해석하고, 거래 전략을 설계하고, 리스크를 관리하느냐에서 나옵니다. 진입 도구를 무료로 오픈하여 더 많은 사람들이 정말 중요한 것에 집중할 수 있게 했습니다.

**2. 오픈소스가 도구를 더 좋게 만듭니다**

우리 팀은 작습니다 — 모든 코인, 모든 지표, 모든 사용 사례를 다 다룰 수 없습니다. 오픈소스를 통해 커뮤니티가 새로운 지표를 기여하고, 버그를 수정하고, 개선사항을 제안할 수 있습니다.

**3. 신뢰 구축**

앞으로 고급 분석 및 거래 도구를 출시할 예정입니다. 먼저 무료 오픈소스 도구로 기술력과 진정성을 증명하는 것이 마케팅 말보다 더 설득력이 있습니다.

## 다음 계획

CoinSifter는 첫 걸음일 뿐입니다. 계획 중인 것들:

- **더 많은 기술적 지표**: ATR, ADX, OBV 등
- **멀티 거래소 지원**: OKX, Bybit
- **백테스팅 통합**: 스크리닝 결과를 백테스팅 프레임워크로 직접 전달하여 전략 효과성 검증
- **커뮤니티 전략 라이브러리**: 사용자들이 스크리닝 전략을 공유하고 평가할 수 있는 기능

이 도구가 유용하다면 GitHub에서 Star를 눌러주세요.

---

*CoinSifter는 [JudyAI Lab](https://judyailab.com)의 오픈소스 프로젝트입니다. MIT 라이선스로 자유롭게 사용하고 수정할 수 있습니다.*

## 참고 자료

- [코인니스 - 가장 빠르고 정확한 코인 투자 뉴스, 커뮤니티](https://coinness.com/)
- [CoinScreener: AI 기반 암호화폐 거래 신호 및 통찰력 플랫폼.](https://www.toolify.ai/ko/tool/coinscreener/)
- [암호화폐 현물/선물 거래소 솔루션 개발해드립니다 - 크몽](https://kmong.com/gig/437424)

## 핵심 수치

- 6 個 기술적 지표 지원
- 5000 users (Threads + 뉴스레터 구독자)
- $0 광고 비용 (100% 오가닉)

---

## 더 읽어보기

- [AI 퀀트 트레이딩 입문 가이드: 첫 거래 시스템 구축](/posts/ai-quant-trading-beginners-guide/)
- [트레이딩 아이디어에서 실전 운용까지: AI 보조 전략 개발의 실제 과정](/posts/trading-concept-to-production-code-with-ai/)
