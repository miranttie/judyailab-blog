---
title: 我怎麼讓超過五個不同模型的AI自動自發24H工作 — Multi-Agent架構實戰
date: "2026-05-20T12:00:00+00:00"
draft: false
author: Judy
slug: 2026-05-20-multi-model-ai-team-24h-autopilot
summary: 大家最常問我：「妳怎麼讓AI自己工作？」答案不是用一個最強的模型，而是讓七個不同模型分工合作 — 這就是Multi-Agent架構的核心。發任務卡→5分鐘內主管接走→派到對的角色→Gate攔假完成→QA查事實→TA讀者視角審核→回報。這篇講白話版的完整Multi-Agent架構，以及我從「每個pipeline一個Agent」走到「以專業分工」的彎路。
description: 七個AI模型組成24小時運轉的團隊，Linear當控制台，每張卡5分鐘內自動接走、Gate審核、QA查事實才回報。本篇拆解Multi-Agent架構：為什麼多模型贏過單一最強模型，以及最小可跑單元怎麼起步。
categories:
  - "AI工程"
  - "教學"
tags:
  - "Multi-Agent"
  - "AI Team"
  - "AI自動化"
  - "Claude Code"
  - "Linear"
  - "Agent架構"
  - "Multi-Model"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
faq:
  - q: "為什麼不用一個最強的AI（例如全部用GPT-5或Claude Opus）？"
    a: "因為每個模型的長處不同、成本結構也不同。判斷力強的模型推理貴，量產時負擔不起；寫得快的模型不擅長拆任務；查事實要內建搜尋。Multi-Agent架構讓每個模型做它最擅長的事，比讓一個模型做全部事便宜也準。"
  - q: "為什麼用Linear當控制台？而不是Notion或自己寫dashboard？"
    a: "因為issue tracker本來就是給人類派工的最自然介面 — 標籤、狀態流轉、留言、子任務都是內建。把AI當成「會自己撿卡」的虛擬同事，就直接接上現成的工作流，不必另外設計。自己寫的dashboard我也有，但Agent老忘記更新；Linear的狀態流轉是內建的，沒有「忘記更新」這個選項。"
  - q: "Gate是什麼？為什麼要審核AI的輸出？"
    a: "Gate是一層自動審核，攔截AI常見的偷懶模式 — 例如把責任推回給人的含糊保留語、捏造事實、洩漏內部資訊。AI說完成不等於真完成。Gate把這層信任問題自動化。"
  - q: "最小可跑單元是什麼？我也可以開始嗎？"
    a: "一張Linear board + 兩個cron（一個輪詢任務、一個觸發執行）+ 三個角色（主管/執行/QA）。先從一個pipeline跑通，再加角色、加Gate。不要一開始就上七個模型。"
  - q: "Multi-Agent架構跟OpenAI Symphony有什麼不同？"
    a: "Symphony是同一個模型開很多instance（全部都是Codex），解決coding量產問題。Multi-Agent架構是多模型多角色分工 — 主管、工程、寫作、QA、行銷、交易各有專屬模型，更貼近真實小團隊運作。"
lastmod: 2026-05-25T11:29:30+00:00
---

> **TL;DR**：我用Multi-Agent架構把七個不同模型編成一個24小時運轉的AI團隊 — Claude Opus當主管拆任務、MiniMax寫code、Hermes寫文章、Gemini CLI查事實、Groq Llama做交易判斷。控制台用Linear，發任務卡5分鐘內被自動接走，過Gate審核、過QA查事實，才回報給我。本篇拆解整套架構、模型分工的選擇邏輯、Gate如何擋下300+次假完成，以及你怎麼從最小單元起步。

## 為什麼大家都問我「怎麼讓AI自動工作」

我跑一間幾乎全AI的公司一陣子了，內部跑著一套Multi-Agent架構，把七個不同的AI模型編成像一間真實公司那樣分工合作。每次跟人介紹這套Multi-Agent架構，最多人想知道的不是「妳用什麼模型」，而是這句：

**「妳到底怎麼讓AI自己工作？」**

很多人試過讓AI接管任務，最後都卡在同一個地方 — 還是得一直盯著它，盯到後來覺得自己做還比較快。問題不在AI不夠強，問題在**架構**。單一AI不管多強，都做不好「自己撿任務、自己分工、自己審核、自己交付」這件事。要做到真正AI自動化，需要的不是更強的模型，是**Multi-Agent架構**。

我的日常不是這樣的。我早上想到一個任務，打開Linear打一張卡，標籤打「J」，按Enter。**5分鐘內**，這張卡會被我的主管Agent接走，他會判斷這是寫文章、寫程式、做研究還是行銷推廣，分派到對應的角色，那個角色開始執行，做完進Gate審核，過了之後進QA查事實，全部通過才回報給我看。

我做的只有兩件事：發卡、看結果。

這篇我把整套Multi-Agent架構講清楚，包含我從「每個pipeline一個專屬Agent」走到「七個不同模型按專業分工」的彎路。

---

## 常見錯誤：我走過的Multi-Agent架構彎路

一開始我也犯了一個直覺錯誤。

我想著：「不同的事情用不同的Agent啊。」所以我開了一堆：寫Blog的Agent、發X的Agent、做交易訊號的Agent、查市場情報的Agent、跑SEO的Agent、做圖的Agent…

結果三個月後我發現幾件事：

- **記憶體不共用**。寫Blog的Agent不知道發X的Agent上週發過什麼。
- **彼此不知道對方在做什麼**。一個Agent寫了一篇Blog，另一個Agent拿去發X時又重寫一次。
- **debug是惡夢**。出問題要看五份日誌。

我砍掉重練。改成**以「專業」當分類軸** — 不再以「事」分。

意思是：哪個pipeline用到「寫作」這個專業就交給寫作Agent，哪個pipeline用到「QA查事實」就交給QA Agent。一個Agent一個專業，所有pipeline共用。

這樣下來：

- 寫作Agent一個人吃下所有寫的事（Blog、X、Email、商品文案）。
- QA Agent一個人吃下所有審核（寫作品質、code review、事實查證）。
- 工程Agent一個人吃下所有code實作。
- 主管Agent一個人負責拆任務、分派、退回。

**多不代表好。少而對才是。**

這個架構穩定下來之後，才有後面的故事。

---

## Multi-Agent架構是什麼樣子

```
       發任務
         │
         ▼
   ┌──────────┐  每 5 分鐘輪詢 ┌──────────┐
   │  Linear  │ ──────────────▶│ 中央調度器 │
   └──────────┘                └─────┬────┘
                                     │
                                     ▼
                         ┌──────────────────────┐
                         │  主管 Agent（Opus）   │ ── 拆任務、分派、退回
                         └──────────┬───────────┘
                                    │
            ┌────────────┬──────────┼──────────┬────────────┐
            ▼            ▼          ▼          ▼            ▼
       ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐
       │ 工程   │  │ 寫作   │  │  QA    │  │ 行銷   │  │ 交易   │
       │MiniMax │  │ Hermes │  │ Gemini │  │MiniMax │  │ Groq   │
       └───┬────┘  └───┬────┘  └───┬────┘  └───┬────┘  └───┬────┘
           │           │           │           │           │
           └───────────┴────┬──────┴───────────┴───────────┘
                            │
                            ▼
                    ┌──────────────┐
                    │  Gate 審核    │ ── 攔含糊、攔捏造、攔洩漏
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
                    │  QA 查事實    │ ── 內建搜尋驗證
                    └──────┬───────┘
                           │
                           ▼
                        回報 Judy
```

每個方框都是一個獨立的腳本或服務，用檔案式信箱通訊。整套東西跑在一台Oracle雲端VM上，**用cron排程，沒有message queue、沒有webhook、沒有額外的中介服務**。簡單到我自己debug都能直接看檔案。

---

## 怎麼跑起來：從發卡到收稿的步驟拆解

舉個具體例子，我今天早上想寫一篇關於某個AI工具的介紹文。

**Step 1（00:00）** — 我打開Linear，建一張卡：「寫一篇XX工具介紹，800字，目標讀者是想用AI自動化的個人開發者」。標籤打「J」，按Enter。我關掉Linear，去做別的事。

**Step 2（+5分鐘）** — 中央調度器輪詢到這張新卡。它看到標籤「J」，把卡的內容寫進主管Agent的信箱。

**Step 3（+6分鐘）** — 主管Agent醒來，讀信箱，判斷這是「寫作」類任務，把它派到寫作Agent的信箱，附上指示：「800字、教學風格、目標讀者個人開發者、附FAQ」。

**Step 4（+10分鐘）** — 寫作Agent起草。Hermes模型寫完丟到草稿區。

**Step 5（+15分鐘）** — Gate審核掃過草稿，檢查有沒有把責任推回給人的含糊保留語、有沒有捏造的KPI數字、有沒有洩漏內部路徑。這一篇Gate攔到一句「資料來源是內部資料庫」— 自動退回寫作Agent改成「依公開資料估算」。

**Step 6（+20分鐘）** — 改完再過Gate，通過。進QA階段。

**Step 7（+30分鐘）** — QA Agent用Gemini內建搜尋，把文章中提到的事實逐一驗證。發現一個版本號寫錯，自動標記。退回小修。

**Step 8（+45分鐘）** — 修完，全部通過。文章自動sync進Notion，狀態「待Judy審核」。

**Step 9** — 我吃完早餐，打開Notion看到一篇可以發的稿。我看完按「可發」。系統自動翻譯英文版、韓文版，部署到部落格。

整個過程我花的時間：發卡30秒+看稿5分鐘。其他時間我在做別的事。

---

## 我的協作模式：Opus給框架，MiniMax寫實作

這是整套架構的核心know-how，我講一個具體例子 — **寫code**。

如果寫一段交易系統的新策略，最直覺的做法是叫Claude Opus從頭寫到尾。可以。但成本高、慢。

我的做法是：

1. **Opus負責拆框架** — 我給Opus需求，它輸出：檔案結構、函式簽章、各函式的職責、邊界條件、需要的測試。**不寫實作細節**，只寫骨架。
2. **MiniMax負責填實作** — Opus拆好的骨架交給MiniMax，它一個函式一個函式填。
3. **Sonnet負責code review** — MiniMax寫完，Sonnet過一輪review，挑邏輯漏洞和邊界case。
4. **Opus負責收尾** — Sonnet標出來的問題，回到Opus判斷要不要改、怎麼改。

為什麼這樣分？

- Opus推理強，最適合**做判斷的活**（拆解、收尾）。但跑量貴，每天跑滿很傷錢包。
- MiniMax是訂閱制，**寫得快又便宜**，context也夠長，最適合**照規格實作**。
- Sonnet介於兩者之間，做review剛好 — 比Opus便宜，但邏輯仍硬。

這個模式套用到寫作也一樣：Opus給結構大綱、Hermes寫初稿、Sonnet做事實層review、Opus收尾改最後一輪。

**讓每個模型做它最擅長的事**，這是我整套Multi-Agent架構唯一一個原則。

---

## 七個模型，七個專業

我目前養著七個不同模型，每個都有專屬崗位：

### 1. Claude Opus 4.x — 軍師 / COO
判斷力最強。負責拆任務、分派、退回、寫程式框架、最後一輪code review、爭議仲裁。

**用它的時機**：需要做選擇的時候。例如「這個bug修法A跟B哪個對」、「這張卡該派給誰」、「這篇Blog寫到一半發現方向錯了該怎麼救」。

### 2. Claude Sonnet 4.6 — 寫作fact-check / code review / 交易分析師備用
Opus的便宜版。邏輯硬度幾乎一樣，價格只要一半。

**用它的時機**：需要嚴謹推理但跑量大的場景。Blog教學文事實查證、code review、交易分析師（Groq主力的備援）。

### 3. MiniMax M2.7 — 工程實作 / 行銷執行
訂閱制、context長、寫得快。

**用它的時機**：照已經拆好的框架寫實作（不需自己做判斷）、行銷文案執行、翻譯。

### 4. Hermes（透過OpenRouter）— 寫作角色
寫作品質夠用、成本低。長文風格穩。

**用它的時機**：Blog起草、社群貼文起草、商品文案起草。所有需要產出長度但不需要查事實的寫作。

### 5. Gemini CLI訂閱版 — QA查事實
**內建web search是它無可取代的優勢**。有些模型查事實要外接搜尋API，Gemini CLI自己會搜。

> 備註：選Gemini CLI還有個現實原因——年初一口氣訂了一整年，不用白不用。

**用它的時機**：Blog上線前查事實、新聞稿驗證、市場研究做source比對。

### 6. Gemini API（Flash）— 新聞pipeline
**免費額度**就足夠跑每天的新聞整理，夠快、API穩定。

**用它的時機**：每天的新聞獲取與整理pipeline，跑量大、不需要太強推理。免費這件事讓我不用擔心成本爆炸。

### 7. Groq Llama-4-Scout 17B — 交易訊號 / 艙位管理
**速度極快**，推理延遲是其他模型的1/10。

**用它的時機**：交易策略需要即時反應的場景 — 信號審查（決定要不要進場）、艙位管理（建議HOLD / 收緊停損 / 獲利了結 / 立刻平倉）。慢一秒就賠錢的事情。

---

## 為什麼用Linear當控制台

我試過用Notion、試過用Slack、試過自己寫dashboard，最後留下Linear。原因很單純：

**issue tracker本來就是給人類派工最自然的介面。**

標籤是路由、狀態是流程、留言是溝通、子任務是拆解。這些功能不用我設計，本來就是內建的。我要做的只是把「會自己撿卡的AI Agent」接上來，讓它們把Linear當成工作來源。

更重要的是：**留言往返也走Linear**。Agent做完留言、我有問題回留言、Agent看到留言再回答。整個對話流自動沉澱在卡上，未來要回顧只看那張卡就好。

Notion太彈性、Slack太線性。自己寫的dashboard我也有 — 但Agent每次都忘記更新，要我盯著它寫，那這個dashboard就失去意義了。Linear剛好 — 狀態流轉是內建的，Agent要做事就一定會經過Linear，沒有「忘記更新」這個選項。

---

## 檔案就是通訊協議

很多人問我Agent之間怎麼通訊。**用檔案。**

每個Agent有一個信箱資料夾，主管Agent派工就是寫一個訊息檔案進對應的信箱。執行Agent輪詢自己的信箱，看到新訊息就處理，處理完寫一個結果檔案到「已完成」資料夾。

為什麼不用message queue、不用Redis、不用webhook？

- **簡單** — cron就能跑。沒有伺服器要維護。
- **可審計** — 每個訊息都是檔案，要追debug直接看檔案內容。
- **可重跑** — 結果不對？把檔案搬回信箱重新處理一次就好。
- **零依賴** — 我不需要學任何新工具，作業系統內建的東西就夠了。

聽起來原始，但跑得穩。**最簡單的工具往往最耐用。**

---

## Gate + QA + TA 三層審核：為什麼我相信AI但不全信

AI最大的問題不是寫不出東西，是**寫出來的東西看起來像那回事，但其實不是**。

具體幾種狀況我都遇過：

- 寫完code跟我說已經沒事了 — 結果根本沒測試。
- 寫完文章引用一個數據，數據是它編的。
- 寫文案不小心把內部路徑或API變數名洩漏出去。
- 同一個bug改三次都改不對，每次都說「這次對了」。

所以我加了兩層自動審核。

### Gate層 — 偵測偷懶模式

Gate是一系列正規表達式+規則，自動掃Agent的輸出：

- **含糊保留語偵測** — 抓到把責任推回給人的措辭（要求人類自己檢查、含糊形容沒問題、英文模糊保留詞），自動FAIL。要PASS必須附證據（命令輸出、檔案內容、API回應）。
- **同卡退回計數** — 同一張卡同一個Agent退回超過3次就自動換人，不讓它無限迴圈。
- **超時告警** — Agent接走任務但超過6小時沒回報，自動推送通知。
- **內部資訊洩漏** — 路徑、主機名、API變數名、私人帳號、財務數字，掃到就block。

光是Gate這層，累計擋下的FAIL已經**超過380次**，自動退回換人**超過90次**。意思是這些假完成沒一個進到我眼前。

### QA層 — 真實事實查證

Gate過了不等於文章正確。QA層用Gemini內建搜尋，把文章裡每個事實主張（版本號、日期、引用、統計數字）拉去網路驗證。對不上就退回小修。

### TA層 — 目標讀者視角審核

QA過了還不等於這篇東西「值得讀」。TA（Target Audience）審核這層是讓另一個Agent扮演目標讀者 — 例如這篇文章的目標讀者是個人開發者，TA Agent就用個人開發者的視角去讀：看完有沒有可以動手做的東西？有沒有讓人想點下一篇？專業詞彙會不會太重？情緒共鳴在不在？TA不通過一樣退回。

三層加起來才能讓我**敢直接看結果**，不用每篇都自己fact-check。

> 補充一下：這裡介紹的是基本款的三層審核，**不同pipeline還會有各自的客製設定** — 例如交易pipeline會多一道風控Gate（單筆超過2%風險直接BLOCK）、產品上架pipeline會多一道版權與品牌一致性Gate、Blog pipeline會多一道引流節奏Gate。基本骨架一樣，細節依場景長出來。

---

## 我們能做什麼

這套Multi-Agent架構穩定下來之後，能做的事情很多：

- 自動寫部落格（中文、英文、韓文三語）並SEO / AEO優化
- 每天自動掃市場新聞、整理重點、推送
- 跑加密貨幣量化交易，從**自動策略研究**、信號審查到艙位管理全自動 — 系統會自己跑回測、發現新策略、丟進Testnet驗證、達標才升上真金
- 自動處理email，重要的翻成中文推給我
- 跑社群行銷，X貼文、Threads、Reddit自動分發
- 做市場調查，從關鍵字研究到競品分析到Notion報告

最有代表性的能力是商品開發 — **我規定我自己每天早上起床時要看到一件新商品**。所以系統得在我睡覺的這幾小時內，把市場調查→機會評估→產品設計→文案→上架→行銷文這一整條自動跑完，最晚在我睜眼那一刻把成品交給我。每天一件，沒有例外。

我能做到這些不是因為我用了最強的模型，是因為**讓每個專業有對的人在崗位上**。

---

## 你也可以從最小單元開始

不要一開始就追求七個模型。我把它拆成一個你**週末 90 分鐘可以跑通**的最小版。

### Step 1：一張 Linear board（10 分鐘）

開一個 Linear 免費 workspace → 新增一個專案 → 後台 Settings → API → 產生 `LINEAR_API_KEY`，存到 `.env`。

最小設定：
- **三個 label**：`role:executor`、`role:qa`、`status:rejected`
- **三個 status**：`Todo` → `In Progress` → `Done`（Linear 預設就有）

### Step 2：兩個 cron（20 分鐘）

#### Cron A — 派工（每 5 分鐘輪詢 Linear）

```python
# dispatcher.py 偽碼
new_cards = linear.list_issues(status="Todo", missing_label=["role:*"])
for card in new_cards:
    role = classify(card.title)        # 用關鍵字或叫 LLM 判
    linear.add_label(card.id, f"role:{role}")
    linear.set_status(card.id, "In Progress")
```

crontab：
```
*/5 * * * * cd /opt/agent && python dispatcher.py >> logs/dispatch.log 2>&1
```

#### Cron B — 執行（每 5 分鐘觸發對應 agent）

```python
# executor.py 偽碼
cards = linear.list_issues(status="In Progress", label="role:executor")
for card in cards:
    prompt = f"Task: {card.title}\nSpec: {card.description}"
    result = run_cli("claude-code", prompt)   # 或 codex / aider / gemini cli
    linear.add_comment(card.id, result)
    linear.add_label(card.id, "needs-qa")
```

```
*/5 * * * * cd /opt/agent && python executor.py >> logs/exec.log 2>&1
```

### Step 3：三個角色 prompt（30 分鐘，可直接抄）

每個角色 = **一個 system prompt + 一個被觸發的條件**。

**主管（Opus 或 Sonnet）** — 負責拆需求成可執行卡：

```
你是 PM。讀使用者需求，輸出一張 Linear 卡的 JSON：
{"title": "...", "description": "具體做什麼", "acceptance": "驗收準則"}
驗收準則必須可驗證，禁寫「做得好」「做得對」這種廢話。
```

**執行（任何便宜模型，MiniMax / Codex / Haiku 都行）** — 負責真的把卡做完：

```
你是 executor。讀 task，做完輸出結果。
鐵則：禁止輸出「可能」「應該」「請手動」「probably」「please check」這類含糊語。
不確定就直接寫「不知道，理由：...」。
```

**QA（Gemini CLI 或任何有 web search 的工具）** — 負責查事實 + 攔含糊：

```
你是 QA。讀 executor 的輸出，三層檢查：
1. 事實正確嗎？（用 web search 驗證至少 1 個數據點）
2. 有含糊語嗎？（grep "可能|應該|請手動|probably|please check"）
3. 達成驗收準則嗎？
任一項不過 → 輸出 FAIL + 具體原因；全過 → 輸出 PASS。
```

### Step 4：跑通第一張卡（20 分鐘）

打開 Linear，手動建一張卡：

- **標題**：寫一段 100 字介紹 Claude Code
- **描述**：給對技術不熟的讀者看，要正確、不能含糊、必須提到「它是什麼」「能做什麼」

預期 10 分鐘內看到：

1. Cron A 接到 → 加 `role:executor` → 移到 In Progress
2. Cron B 接到 → 呼叫 executor → 留言貼結果 → 加 `needs-qa`
3. QA cron（或合併進 Cron B 後段）→ 讀留言 → web search 驗事實 + grep 含糊語 → 留言 PASS/FAIL

**PASS** → 移到 Done。**FAIL** → 退回 Todo + 加 `status:rejected` label + 留言寫原因。

### Step 5：能跑就擴張

第一張卡跑通之後，再分批加：

- **第二個執行模型** — 不同 label 派不同 CLI（`lang:code` → Codex，`lang:writing` → MiniMax）
- **退回機制** — 同卡 3 次 FAIL → 自動 Blocked + TG 推給你
- **更多角色** — 行銷、交易、資料各一張 system prompt + 一條 label 規則
- **通知層** — 完成卡用 Telegram bot 推給你，不用一直開 Linear

**不要一次到位。先跑通一張卡，剩下都是擴張。**

---

## 結語：1.0是multi-instance，2.0是multi-model multi-role

最近OpenAI開源了一個叫Symphony的東西，做的事情類似：用Linear當控制台，每張卡一個Codex agent，agent自己撿卡自己做。OpenAI內部跑出PR數成長500%的成績。

我看完只有一個感想：**這只做了一半。**

Symphony的設定是「同一個模型開很多instance」— 全部都是Codex。可以解決coding的量產問題，但解決不了「不同任務需要不同專業」的問題。寫程式、寫文章、查事實、做交易、跑行銷，是五件**本質不同**的事，不應該由同一個模型來做。

我這套Multi-Agent架構更貼近真實公司運作：**多角色、多模型、各司其職**。一個主管、一個工程、一個寫作、一個QA、一個行銷、一個交易、一個資料 — 像真實的小團隊。

**multi-instance同質agent是1.0。multi-role multi-model Multi-Agent架構是2.0。**

如果你也在試圖讓AI真的自己工作，這篇希望幫你跳過我走過的彎路。從一張Linear卡、三個角色開始，慢慢長大。

順帶一提，這套Multi-Agent架構的**雛形**其實兩個多月前我已經開源過 — 一個叫 [**ai-night-shift**](https://github.com/JudyaiLab/ai-night-shift) 的repo，主要解決「晚上睡覺時讓Agent繼續工作」的問題。

**當時就跑通的底層想法**：

- **檔案就是通訊協議** — `bot_inbox/` + `night_chat.md` 雙通道，不依賴 message queue
- **Adapter 抽象層** — 一份腳本支援 Claude Code、Codex CLI、Aider、自訂CLI
- **Autonomy Rules 防互動卡死** — 所有 prompt template 都有反互動指令區塊
- **原子化 PID lock** — 用 `mkdir` 而非檔案，防 TOCTOU race condition
- **Plugin 系統** — pre/task/post 三 phase，可插可拔

**這篇講的、是後來才長出來的**：

- **Linear 當中控** — 從本機 `bot_inbox/` 升級成雲端 board，跨機器跨 agent
- **多模型分工** — 從「夜班一個模型」變成「七個模型各司其職」
- **Gate-9 攔含糊語** — 跑了幾百次假完成之後才痛定思痛加上的事後檢查層
- **退回機制 + QA 二審** — Agent 說 PASS 不算數，要 J 重跑+小月 QA 過

**有興趣的人可以從那個repo起步**，它是這篇文章描述架構的最小可運行祖先，MIT授權直接拿去改。看那邊先理解「檔案通訊 + 自主執行」的骨架，再回頭看這篇怎麼把它長成全天候多模型團隊。

---

## 延伸閱讀

- [我們同時跑 4 種 LLM：真實多智能體團隊的選型與成本實錄](/posts/multi-llm-agent-team-cost-reality/)
- [我在一台雲端主機上建了一間微型 AI 公司（含防幻覺、品質閘門、模型調教實錄）](/posts/building-tiny-ai-company-on-laptop/)
- [AI Night Shift 開源了：我們怎麼讓多個 AI Agent 在你睡覺時自主工作](/posts/ai-night-shift-open-source-launch/)


- [JudyaiLab/ai-night-shift](https://github.com/JudyaiLab/ai-night-shift) — 我幾個月前開源的多Agent夜班自動化框架，本篇架構的最小可運行祖先
- [OpenAI Symphony開源規格說明](https://openai.com/index/open-source-codex-orchestration-symphony/) — OpenAI官方公告，了解他們的單模型multi-instance設計
- [github.com/openai/symphony](https://github.com/openai/symphony) — Symphony參考實作（Elixir寫）
- [Linear官方文件](https://linear.app/docs) — Linear API文件，自己接Multi-Agent架構的起點

---

*這套Multi-Agent架構還在持續迭代。如果你也在做類似的事，或者對某個段落有疑問，歡迎留言交流。*

想第一時間收到後續的架構迭代、踩雷紀錄、商品開發筆記？訂閱 Judy AI Lab 週報，每週把這週 Multi-Agent 團隊跑出來的東西、我自己整理的思考，一起寄給你 — 還會附上我們團隊每天在用的 AI 團隊架構完全指南 PDF。

{{< lead-magnet >}}
