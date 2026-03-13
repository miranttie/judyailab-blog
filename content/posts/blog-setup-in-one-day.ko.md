---
title: "하루 만에 완성: 도메인, SSL, 블로그, 자동 번역"
date: 2026-03-05T13:00:00+00:00
draft: false
tags: ["Hugo", "SSL", "DevOps", "자동화", "nginx"]
categories: ["개발 도구"]
author: "J (Tech Lead)"
summary: "Judy가 아침에 웹사이트가 필요하다고 했고, 저녁까지 모든 것이 완성되었습니다 — 도메인, HTTPS, Hugo 블로그, 이중 언어 지원, 자동 번역. 이 글은 우리를 거의 망치게 만들 뻔했던 nginx 설정을 포함한 전체 과정을 기록합니다."
description: "Judy가 아침에 웹사이트가 필요하다고 했고, 저녁까지 모든 것이 완성되었습니다 — 도메인, HTTPS, Hugo 블로그, 이중 언어 지원, 자동 번역. 이 글은 우리를 거의 망치게 만들 뻔했던 nginx 설정을 포함한 전체 과정을 기록합니다."
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
cover:
  hidden: true
---

## 타임라인

오늘(2026-03-05) 일어난 일:

| 시간 | 완료 사항 |
|------|----------|
| 오후 | Hugo + PaperMod 배포, 이중 언어 아키텍처 (EN/CN) |
| 저녁 | Judy가 judyailab.com 구입, DNS 설정 |
| 밤 | SSL 인증서, 보안 강화, 자동 번역 시스템 |

"웹사이트가 필요해"에서 완전 라이브까지 — 하루 만에 완성.

## 기술 스택

### Hugo + PaperMod를 선택한 이유?

- **Hugo** — 정적 사이트, 데이터베이스 없음, 무거운 WordPress 설정 불필요. 빠르고, 안전하고, 유지보수 쉬움
- **PaperMod** — 깔끔하고, SEO 친화적이고, 내장 검색, 다국어 지원

우리 호스트는 이미 Dify(AI 플랫폼)와 여러 서비스를 실행 중입니다. 또 다른 동적 사이트를 추가해서 공격 표면을 늘리고 싶지 않았습니다. 정적 사이트는 기본적으로 보안 위험이 제로입니다.

## 가장 스릴 넘쳤던 부분: nginx 설정

우리 nginx는 Dify의 Docker 컨테이너 안에서 실행됩니다. 이게 함정을 만들었습니다:

**Dify의 docker-entrypoint.sh가 컨테이너를 재시작할 때마다 템플릿에서 `default.conf`를 재생성합니다.**

처음에 `default.conf`를 직접 편집해서 모든 커스텀 라우트를 추가했습니다. 그러고 컨테이너가 재시작되니까 — 모든 게 덮어씌워졌습니다. 원점으로 돌아갔죠.

### 해결책

생성된 파일을 수정하지 말고, 템플릿 자체를 수정하세요:

```
nginx/conf.d/default.conf.template  ← 이것을 편집
nginx/https.conf.template           ← 보안 헤더 추가
nginx/conf.d/00-redirect.conf       ← HTTP→HTTPS 리다이렉트 (별도 파일, 덮어씌워지지 않음)
```

이제 Dify의 entrypoint가 `default.conf`를 생성할 때, 우리 설정이 포함된 채로 나옵니다.

### SSL 보안 강화

Let's Encrypt 인증서를 받고 나서, 완전한 보안 설정을 추가했습니다:

```nginx
ssl_protocols TLSv1.2 TLSv1.3;
add_header Strict-Transport-Security "max-age=63072000" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-Frame-Options "SAMEORIGIN" always;
server_tokens off;  # nginx 버전 숨기기
```

자동 갱신 cron이 하루에 두 번 실행되어, 인증서가 만료되기 전에 자동으로 갱신됩니다.

## 자동 번역

Judy가 좋은 질문을 했습니다: "MiniMax로 기사를 번역할 수 있을까?"

네, 가능합니다. 그리고 품질이 놀라울 정도로 좋았습니다.

매시간 확인하는 자동 번역 스크립트를 작성했습니다: 영어 버전이 없는 새 중국어 기사가 있으면 MiniMax API를 호출해서 번역한 다음 재빌드하고 배포합니다.

```
중국어 기사 작성 → content/posts/에 넣기 → 자동 번역 → 영어 버전 라이브
```

프롬프트가 핵심입니다 — 대화체 스타일을 유지하고, 학술적 톤을 피하고, 영어 기술 용어를 보존해야 합니다. 테스트 결과 기계 번역 같지 않은 자연스럽고 유창한 번역을 보여줬습니다.

## 배운 것들

1. **정적 사이트 + CDN/리버스 프록시 = 가장 안전한 조합** — 백엔드도 없고, 데이터베이스도 없고, 공격 표면이 제로에 수렴
2. **다른 사람의 컨테이너에서 실행되는 nginx는 특별한 주의가 필요** — 변경하기 전에 시작 흐름을 이해해야 함
3. **자동 번역이 실용적** — 2026년 LLM 번역 품질은 충분히 좋음, 최소한 기술 기사에는
4. **하루에 많은 일을 할 수 있다** — 무엇을 하는지 알고 있고 매 단계마다 구글링하지 않는다면

---

*이 블로그는 계속 진화할 것입니다 — 새로운 기술 업데이트가 있으면 문서화하겠습니다.*