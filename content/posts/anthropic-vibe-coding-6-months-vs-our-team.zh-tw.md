---
title: "Anthropic 員工 6 個月 Vibe Coding 實戰：對標 7 要點，我們 AI 團隊做到哪幾項"
date: "2026-05-30T05:00:32+00:00"
draft: true
author: "Judy"
summary: "Anthropic把Agent Skills變成開放標準後，Vibe Coding成為AI協作開發圈反覆討論的節奏。一人公司+AI團隊的JudyAI Lab對著要點清單盤點，5項已落地、2項刻意暫緩，給solopreneur一份可複製的最小起手式。"
description: "從Anthropic員工Vibe Coding實戰整理出的要點，對標JudyAI Lab的GATE閘門、agent派工、自我審核、TDD、小檔案多模組5項落地實踐。還沒做的2項與為什麼，加上solopreneur不用大廠規模也能跑的3個最小起手式與30天落地節奏。"
categories:
  - "真實分享"
tags:
  - "Vibe Coding"
  - "AI團隊"
  - "Anthropic"
  - "AI協作開發"
  - "solopreneur"
  - "Agent Skills"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
series:
  - "AI 創業筆記"
faq:
  - q: "Vibe Coding 是什麼？跟一般用 AI 寫程式有何不同？"
    a: "Vibe Coding 是 Anthropic 員工累積出的 AI 協作寫程式節奏，核心是「人類做決策、AI 做執行」。差別在於它強調閘門先行、Agent 派工列出 allowed_files、自我審核入流程、TDD、小檔案多模組這 5 件事。不是讓 AI 自由發揮，而是用流程把 AI 的幻覺與越界擋在外面。"
  - q: "Anthropic Agent Skills 是什麼？跟 Vibe Coding 有何關聯？"
    a: "Agent Skills 是 Anthropic 推的跨工具開放規格，讓不同 AI 開發環境能載入同一套技能設定。它把 Vibe Coding 的實踐方式標準化，方便 Claude Code、Cursor、其他 IDE 共用同一份 Skill 檔案。底層意義是 Anthropic 把內部協作節奏往外擴散，不再只是技術新聞。"
  - q: "Solopreneur 一個人想跑 Vibe Coding，最少要做哪幾件事？"
    a: "三件事就能起步。一，先寫閘門再寫程式，至少三條：碰 .env 要確認、碰部署要確認、碰金流要確認，寫進 CLAUDE.md。二，所有任務開 Linear 卡或 GitHub Issue，讓 AI 派工自審留痕。三，每天留 30 分鐘給人類，看報告、做決策、抽一項獨立重跑。三十天就能跑順。"
  - q: "什麼是 allowed_files？為什麼派工要列這個？"
    a: "allowed_files 是派工時明確列出 Agent 可以改的檔案清單。AI Agent 一旦自由發揮，容易越界改到不該改的檔案，造成隱性破壞。Judy AI Lab 的 GATE-8 強制派工列 allowed_files，code review 時用 git diff 對照，越界就退回。這是擋住 AI 幻覺擴散最便宜的一道牆。"
  - q: "為什麼一人公司不需要完整可觀測性堆疊與 RFC 流程？"
    a: "可觀測性堆疊指全鏈路追蹤每次 AI 呼叫的 input、output、cost、latency，大廠團隊規模大才划算。一人公司用 log 加 Linear 卡加 TG 推送就夠用，多加一層工具反而吃維護成本。RFC 是書面提案流程，一人決策週期短，正式 RFC 會卡節奏，用 Linear 卡與共享筆記取代即可。"
  - q: "AI 寫的程式跑得過測試就代表沒問題嗎？"
    a: "不是。能跑不等於安全，AI 生成的程式碼容易藏 SQL 注入、XSS、命令注入、敏感資料外洩這類看不見的漏洞。所以閘門要優先於速度，任務開始前先掃過一輪安全檢查。再加上 TDD 流程：先寫測試 RED，再實作 GREEN，最後 REFACTOR，並要求 80% 以上覆蓋率。"
  - q: "為什麼 AI 改大檔案容易出錯？檔案要切多小？"
    a: "AI 改 2000 行的巨型單檔會出現各種幻覺：抓錯上下文、改錯位置、漏掉相關修改。改 300 行的小檔案幾乎不會出錯，因為整個檔案能一次塞進注意力範圍。建議單檔 200 至 400 行為主，最多 800 行，按功能或領域分目錄。多檔案小模組勝過巨型單檔是 Vibe Coding 的核心紀律。"

---

最近Anthropic把Agent Skills正式對外公開，定位成跨工具的開放規格，讓不同的AI開發環境都能載入同一套「技能」設定。表面是又一條技術新聞，底層其實是更大的東西——「Vibe Coding」這套用AI協作寫程式的節奏，正在從Anthropic內部往外擴散。

Vibe Coding不是新詞，但Anthropic員工累積實戰心得後整理出來的要點清單，最近在AI開發圈反覆被轉貼。Judy AI Lab用J、米米、莉莉、阿達、小月這支AI團隊跑了一陣子，剛好對著清單盤點，發現有些事我們很早就在做，有些事刻意不做。

## 已經在做的5項：閘門、派工、自審、TDD、小檔案

第一條，**明確閘門（Gate）優先於速度**。Anthropic在自家工程部落格反覆強調：能跑，不等於安全。AI生成的程式碼，容易藏著看不見的安全漏洞。Judy AI Lab的GATE-1寫的就是這個——任何任務開始前先掃SQL注入、XSS、命令注入、敏感資料外洩。閘門過不了，後面全部不動。

第二條，**Agent派工要列allowed_files**。AI代理（Agent，可以理解成被指定角色、能自主呼叫工具的AI模組）一旦放開讓它「自由發揮」，就很容易越界改到不該改的檔案。Judy AI Lab的GATE-8強制派工時列出allowed_files，code review時用`git diff`對照，越界就退回。

第三條，**自我審核變成流程一環**。Anthropic公開的Agent設計原則裡也強調：智能體可以反過來幫人類辨識工具裡的模糊敘述和低效實作。Judy AI Lab的GATE-5寫死了「Agent完成≠完成，J驗收才算」，GATE-6要求Agent回報PASS時，J抽1項獨立重跑，沒有命令輸出就自動不信任。

第四條，**TDD（Test-Driven Development，先寫測試再寫程式）**。AI寫的程式跑得通不代表它真的對。先讓測試RED（紅燈失敗）、實作到GREEN（綠燈通過）、再REFACTOR（重構）。這條從Judy AI Lab成立第一天就寫進規範。

第五條，**多檔案小模組勝過巨型單檔**。單檔200-400行為主、最多800行，按功能/領域分目錄。AI改一個2000行的檔案會出現各種幻覺，但改一個300行的小檔案幾乎不會出錯。

## 還沒做的2項：成本與價值的取捨

兩件大廠在做、Judy AI Lab刻意暫緩的事。

一個是**完整的可觀測性堆疊**（Observability Stack，全鏈路追蹤每一次AI呼叫的input/output/cost/latency）。Anthropic的工程文化裡會對每個工具呼叫做原始記錄分析，對團隊規模大的時候很必要。但Judy AI Lab只有五個Agent加上幾個cron，加進這層工具會多吃一份維護成本，目前用log+Linear卡+TG推送就夠用。

另一個是**正式的RFC流程**（Request for Comments，重大設計變更前的書面提案）。大廠對Agentic技術債（用AI趕工偷工減料累積下來的隱性債務）會用RFC攔在前面。一人公司的決策週期，正式RFC反而會卡住節奏，目前用Linear卡+SHARED_TASK_NOTES替代。

## Solopreneur可複製版：3個最小起手式

不用Anthropic規模，一個人+一個AI也跑得起來。

**第一，先寫閘門再寫程式**。哪怕只有三條：碰.env要確認、碰部署要確認、碰金流要確認。寫在CLAUDE.md裡，每次AI啟動都會讀進去。

**第二，所有任務開Linear卡（或GitHub Issue也行）**。讓AI派工、自審、回報、留痕跡都有地方放。沒有任務追蹤系統，AI做完什麼很快就忘了。

**第三，每天留30分鐘給人類**。看AI報告、做關鍵決策、抽一項獨立重跑。AI不會累，但AI也不會替你扛責任。

三十天跑下來，會發現Vibe Coding不是炫技，是把「人類做決策、AI做執行」這節奏抓穩。Anthropic員工幾個月內收斂出來的心得，一人公司一個月也能上手。

差別只在你願不願意把那30分鐘留下來。

## 參考來源

- [Vibe Coding 團隊規範：在 AI 編程時代守住 SDLC 的工程紀律 - 小惡魔 - AppleBOY](https://blog.wu-boy.com/2026/05/vibe-coding-team-guideline-zh-tw/)
- [AI新職人〉Vibe Coding寫出近百工具，陳盈臻：我沒學會寫程式，但學會跟 AI 對話|數位時代 BusinessNext](https://www.bnext.com.tw/article/91046/ai-new-professionals-guide)
- [Vibe Coding 跨入實體世界：從寫軟體到造硬體原型，Lovable、Anthropic 相繼卡位](https://techorange.com/2026/05/15/vibe-coding-hardware/)
