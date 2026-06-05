---
title: OWASP Top 10 for Agentic Applications 2026 — AI Agent 開發者必懂的 10 大安全風險
date: "2026-05-22T05:08:33+00:00"
draft: false
author: Judy
summary: OWASP 2026 發布專為 AI Agent 系統設計的全新安全框架，將提示注入與過度代理整合為 ASI01 目標劫持，並涵蓋工具濫用、記憶汙染、流氓 Agent 等十大攻擊面，幫助開發者在輸入、工具、記憶與 Agent 協作各層建立完整防護機制。
description: OWASP 2026 發布首份 Agentic Applications 安全框架，ASI01-ASI10 解析目標劫持、工具濫用、記憶汙染、流氓 Agent 等十大風險，提供開發者在 input、tool、memory、agent 各層建立防護機制的具體方向，是 AI Agent 開發者必讀的安全指南。
categories:
  - "AI 工程"
  - "產品"
tags:
  - "OWASP Top 10"
  - "AI Agent 安全"
  - "Agentic AI"
  - "目標劫持"
  - "記憶汙染"
  - "AI Agent 開發"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
faq:
  - q: "OWASP Top 10 for Agentic Applications 跟 LLM Top 10 有何不同？"
    a: "LLM Top 10 針對單次推理，ASI 系列專門處理多步執行、工具呼叫、長期記憶與多 Agent 協作的風險，是全新的威脅模型框架。"
  - q: "ASI01 目標劫持最常見的攻擊路徑是什麼？"
    a: "最常見是將惡意指令藏在外部資料中，Agent 讀入後與系統 prompt 競爭優先權，企業必須將外部資料視為不可信輸入處理。"
  - q: "如何防止記憶汙濁（ASI06）？"
    a: "要在寫入記憶時就做好來源標記與信任分級，而非等到讀取時才檢查，因為攻擊與受害時間差可能很長。"
  - q: "Multi-Agent 系統需要特別注意哪些風險？"
    a: "Agent 間信任濫用（ASI07）、連鎖失效（ASI08）與流氓 Agent（ASI10）是多 Agent 情境特有的橫向與系統性風險，需建立Agent 身份驗證與互動監控機制。"
  - q: "傳統資安措施足以保護 AI Agent 嗎？"
    a: "不足夠，Agent 有「權但不該做」的場景，需要加入 context-aware 的一致性檢查，傳統 RBAC 只檢查能不能，無法應對此類風險。"
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
series:
  - "AI Agent 完全指南"
---

OWASP GenAI Security Project 在 2026 發布了一份新清單——Top 10 for Agentic Applications [Source: https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/]。這不是傳統 Top 10 的小升級，是專門為 AI Agent 系統做的全新框架，由業界專家社群共同 peer review 出來的 [Source: https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/]。

裡面的 ASI01 到 ASI10，命名邏輯就跟原本的 LLM Top 10 不一樣了——ASI01（Agent Goal Hijack）直接把 prompt injection（原 LLM01）跟 excessive agency（原 LLM06）合在一起 [Source: https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/]，因為 Agent 的多步自主執行會把單次回應的攻擊放大到完全不同的層級。

## 為什麼 Agent 需要自己的一份清單

傳統 OWASP Top 10 是為 web app 設計的，後來 LLM Top 10 補上了單次推理場景的風險。但 Agent 不一樣——它會自己呼叫工具、會記得上次發生什麼、會跨任務累積狀態。

這幾個能力疊起來，攻擊面就完全不同。

舉個對比：對一個 chatbot 做 prompt injection，最壞就是它回一句不該回的話。但對一個 Agent 做 goal hijack，它可能會接著跑十步、轉錢、改設定、串接下游系統——而且每一步看起來都「在執行任務」，從 log 看不出哪裡開始走偏。

相較於 LLM Top 10，ASI07（Agent 間信任濫用）、ASI08（連鎖失效）、ASI10（流氓 Agent）這幾條更聚焦 multi-agent 情境的橫向與系統性風險 [Source: https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/]，因為單次推理的世界裡這些情境根本不存在。

## ASI01 到 ASI10 一句話速覽

- **ASI01 目標劫持（Agent Goal Hijack）**：攻擊者改寫 Agent 真正在追的目標
- **ASI02 工具濫用（Tool Misuse）**：合法許可權被導去做不該做的事
- **ASI03 許可權越界（Excessive Permissions）**：Agent 超出原本被授權的範圍
- **ASI04 Agentic 供應鏈（Agentic Supply Chain）**：第三方 Agent、工具、外掛、模型來源本身被汙染
- **ASI05 非預期程式碼執行（Unexpected Code Execution）**：Agent 解析輸入時觸發了不該執行的程式碼路徑
- **ASI06 記憶汙染（Memory Poisoning）**：往 long-term memory 塞毒
- **ASI07 Agent 間信任濫用（Inter-Agent Trust Exploitation）**：multi-agent 系統的橫向攻擊
- **ASI08 連鎖失效（Cascading Failures）**：一個 Agent 出錯，沿著 chain 把整個系統一起拖垮
- **ASI09 人機信任濫用（Human-Agent Trust Exploitation）**：Agent 利用人類對它的信任，誘導使用者做出錯誤決策
- **ASI10 流氓 Agent（Rogue Agents）**：被植入或失控的 Agent 在系統內活動

完整定義與英文原文對照可參考 OWASP 官方檔案 [Source: https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/]。

## 十條逐一講：每條長什麼樣、為什麼難擋

**ASI01 目標劫持**最常見的攻擊路徑，是把惡意指令藏在 Agent 必須讀的資料來源裡——爬到的網頁、收到的 email、user upload 的檔案。Agent 讀進去之後，那段指令會跟原本的系統 prompt 競爭優先權。多步執行放大了影響：單次推理錯一次是錯一句話，Agent 錯一次是錯接下來整條 chain。傳統 LLM 防護擋不住，因為這條從「資料」進來看起來是合法輸入。

**ASI02 工具濫用**的關鍵在「合法但不該」。Agent 有權呼叫資料庫查詢，沒問題；但攻擊者騙它去查不屬於這次任務的資料，許可權檢查透過了，動作完成了，從系統角度看不出異常。防護重點是工具呼叫前的 context 檢查，不只是 permission 檢查——同樣的 API call 在「客服任務」跟「資料外洩」情境下該不該允許，邏輯不一樣。

**ASI03 許可權越界**跟 ASI02 是表親但不同：ASI02 是用既有許可權做不該的事，ASI03 是 Agent 自己主動取得不該有的許可權。常見路徑包括：自我提權（騙系統發 admin token）、橫向移動（用 A 工具的回應推導 B 工具的 credential）、escalation chain。RBAC 守不住，因為攻擊者每一步看起來都合法，是累積後超出原本授權範圍。

**ASI04 Agentic 供應鏈**把 npm/pypi 供應鏈攻擊搬到 Agent 世界。第三方 Agent、外掛、MCP server、預訓練模型權重、prompt template 庫——任何進入你 stack 的元件都是攻擊面。最近一波 PyPI typosquatting 投毒套件、Hugging Face 上的 backdoored model、惡意 MCP server 騙開發者裝，都屬這條。SBOM 必須擴張到「Agent 元件」維度。

**ASI05 非預期程式碼執行**特別危險，因為 Agent 常常自己寫 code 自己跑：生成 SQL 然後執行、生成 Python 然後 eval、生成 shell 然後 subprocess。攻擊者透過誘導 prompt 讓 Agent 寫出含 shell injection / SQL injection / 路徑穿越的程式碼，再讓 Agent 自己跑。沙盒、白名單、模板渲染前的轉義缺一不可。

**ASI06 記憶汙染**是 long-term memory agent 的專屬風險。攻擊者塞一段假記憶進去，幾天後 Agent 自己讀回來，就會把假的東西當作「以前學過的事實」。這條尤其麻煩，因為汙染跟使用會隔很久，事後追因果鏈非常難。RAG 系統、向量資料庫、knowledge graph 都是潛在汙染點。

**ASI07 Agent 間信任濫用**只在 multi-agent 系統發生。Agent A 信任 Agent B 的回應，B 信任 C，攻擊者進入 chain 中任何一個節點，整條鏈的下游都吃假資料而不知道。橫向攻擊在傳統微服務時代叫 lateral movement，在 Agent 世界更嚴重——因為 Agent 之間的信任通常隱含在 prompt 設計裡，沒有清楚的 boundary。

**ASI08 連鎖失效**跟 ASI07 一樣是 chain 問題但起因不同：ASI07 是惡意，ASI08 是錯誤擴散。一個 Agent 因為 hallucination 給錯資料，下游 Agent 把它當真，再往下傳 5 步，整個 workflow 已經完全脫離現實。circuit breaker、信心度標註、cross-validate 是必要的緩解措施。

**ASI09 人機信任濫用**反過來——Agent 利用人類對它的信任做壞事。常見手法包括偽造緊急感（「不點這個現在就會出大事」）、社工式說服、把惡意內容包成 Agent 的「建議」讓人不假思索接受。當人類把 Agent 當作中立工具時，攻擊面最大。UX 設計需要 friction layer，讓重要動作必須人類二次確認。

**ASI10 流氓 Agent**是 multi-agent 系統的新威脅。一個 Agent 被攻破或被植入，在團隊內冒充正常成員發任務、改設定、讀別人的記憶。傳統 zero trust 在 Agent 世界要重新設計——身分驗證的物件不是人，是行為模式。anomaly detection 要從「這個帳號的行為」升級到「這個 Agent 的決策軌跡」。

## 從原則到工程的落地方向

OWASP 給的是分類跟原則，工程上要自己接。以下是幾個對應到 ASI 條目的常見實作方向。

針對 **ASI04（Agentic 供應鏈）**，第三方 Agent、外掛、模型來源都要納入供應鏈管理——pin 版本、做來源簽章驗證、CI 階段掃 manifest，跟傳統 SBOM 的思路一致，只是把物件從 npm 套件換成 Agent 元件。

針對 **ASI05（非預期程式碼執行）**，輸入解析要假設惡意輸入會嘗試觸發 eval、模板注入、檔案系統存取。任何會被 Agent 動態執行的內容（生成的 code、生成的 SQL、生成的 shell），都要先進沙盒或經過白名單檢查，不能直接交給 runtime。

針對 **ASI06（記憶汙染）跟 ASI08（連鎖失效）**，知識庫寫入要標來源、限可信度權重；向量資料庫的每一筆寫入都留 trace——誰寫的、什麼任務寫的、用什麼指令寫的。出事時可以反推因果鏈，也能在某個 Agent 開始噴錯時，限制錯誤往下游 chain 擴散。

針對 **ASI02 / ASI03（工具濫用、許可權越界）**，每個 Agent 出生時就帶一份 boundary 設定，能用哪些工具、能呼叫哪些下游、能存取哪些資源，超出範圍的請求直接拒絕，不交給 Agent 自己判斷。

針對 **ASI04 衍生的資源面風險**，rate limit 是必備的——限制每個 Agent 每分鐘能呼叫多少次外部 API，避免任務迴圈失控把配額打爆，也順便擋掉攻擊者用無限呼叫拖垮服務的路徑。這層通常會搭配上面 ASI02/03 的 boundary 設定一起設計。

## 開發者現在可以做的三件事

把所有外部來源的內容當作「資料不是指令」處理。Web fetch、user upload、外部 API 回傳——任何要進到 Agent context 的東西，都先過一道 sanitize，再進主流程。這同時對應 ASI01 跟 ASI05。

工具呼叫前加一層 context 檢查，不只看許可權。同樣的 API call，在不同任務情境下該不該被允許，邏輯是不一樣的，光靠 RBAC 擋不住 ASI02 這類攻擊。

記憶系統一定要有 trace。寫入來源、寫入任務、寫入時間，缺一個都會在出事後讓你完全看不到根因，ASI06 跟 ASI08 都會在這個缺口上出事。

OWASP 這份清單最值得讀的部分，其實不是十條風險本身，是它在告訴你——Agent 系統的安全模型，跟你以前知道的，不一樣了。
