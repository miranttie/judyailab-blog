---
title: Anthropic 投 1 億美元做資安：Project Glasswing 與神秘的 Claude Mythos 到底有多猛
date: "2026-04-08T06:00:00+00:00"
draft: false
author: Judy
summary: Anthropic 發布 Project Glasswing 資安計畫，投入 1 億美元 AI 信用額度與 400 萬美元捐款。透過未公開的 Claude Mythos Preview 模型在全球關鍵軟體中發現數千個零日漏洞，包括存在 27 年的 OpenBSD 漏洞與 16 年的 FFmpeg 漏洞。
description: Anthropic 宣布投入超過 1 億美元推出 Project Glasswing 資安計畫，使用未公開的 Claude Mythos Preview 模型在數週內發現數千個零日漏洞，包括 27 年歷史的 OpenBSD 遠端崩潰漏洞與 16 年的 FFmpeg 漏洞。本文分析 AI 資安時代的來臨對產業的影響。
categories:
  - "公告"
  - "AI 工程"
tags:
  - "Anthropic"
  - "Claude Mythos"
  - "Project Glasswing"
  - "AI 資安"
  - "零日漏洞"
  - "OpenBSD 漏洞"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
series:
  - "AI Agent 完全指南"
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
lastmod: 2026-05-05T05:05:18+00:00
faq:
  - q: "Project Glasswing 到底是什麼？普通開發者用得到嗎？"
    a: "Project Glasswing 是 Anthropic 投入 1 億美元的資安計畫，用 Claude Mythos Preview 模型替關鍵軟體做漏洞掃描。目前僅開放給 AWS、Apple、Google、Linux Foundation 等約 40 個合作夥伴與基礎設施維護組織，一般開發者暫時無法直接申請使用，但發現的漏洞會公開修補，所有人都受益。"
  - q: "Claude Mythos Preview 跟 Claude Opus 4.6 差在哪裡？我可以用嗎？"
    a: "Mythos Preview 是 Anthropic 目前最強的內部模型，在 CyberGym 漏洞重現測試拿下 83.1%，比公開最強的 Opus 4.6 的 66.6% 高出超過 16 個百分點。目前尚未公開發布，僅供 Glasswing 合作夥伴使用，外界無法透過 API 或 Claude.ai 取得，估計擴散到一般市場還需要數個月到一年。"
  - q: "為什麼 27 年的 OpenBSD 漏洞沒人發現，AI 卻挖到了？"
    a: "OpenBSD 雖以安全聞名，但傳統靜態分析與模糊測試只能比對已知模式，遇到跨模組、跨檔案的邏輯漏洞就抓不到。Mythos Preview 能讀懂程式語意、推理執行路徑，類似資深紅隊人員的直覺。FFmpeg 那個 16 年漏洞更明顯：自動化工具命中該段程式碼超過 500 萬次都沒發現，AI 一看就看出來了。"
  - q: "AI 找漏洞會不會被駭客拿來反過來攻擊？"
    a: "會，而且 Anthropic 自己承認這點。他們已揭露第一起 AI 主導的網路攻擊：中國國家級駭客組織用 AI Agent 自主滲透約 30 個全球目標。Mythos Preview 不公開的核心理由就是雙面性風險，先讓防守方搶在攻擊者擴散之前把洞補起來。短期內企業仍須維持紅藍隊與 EDR 防禦，不能因為 AI 來了就降規格。"
  - q: "CrowdStrike、Palo Alto 這些資安公司股價跌 5-11%，傳統資安會被取代嗎？"
    a: "短期不會。Glasswing 目前只解決「找漏洞」，但漏洞修補、事件回應、合規稽核、端點防護仍需要傳統資安廠商與人類專家。市場過度反應的成分高，更合理的判讀是資安產業升級催化劑，未來會走向 AI 輔助分析師。長期若 AI 能自動找洞加自動修補，價值鏈才會真正重構，但這還需要 2-3 年驗證。"
  - q: "開源專案維護者要怎麼申請這 1 億美元的 AI 額度？"
    a: "目前 Anthropic 沒有公開申請入口，是直接與 Linux Foundation 等基金會合作分配。維護關鍵基礎設施（如 OpenSSL、curl、FFmpeg 等級）的專案會被優先納入，小型專案建議透過所屬基金會或 OpenSSF 申請。另外 400 萬美元直接捐款也是走基金會通道，不是個人申請制，獨立維護者可先註冊 OpenSSF 取得能見度。"
  - q: "1 億美元能掃多少程式碼？真的夠用嗎？"
    a: "以 Claude API 商用價格估算，1 億美元約可處理數百億 token 的程式碼分析，覆蓋 Linux Kernel、OpenBSD、FFmpeg、OpenSSL 等核心專案的完整掃描綽綽有餘。但要持續監控全球開源生態系仍不夠，這筆預算更像啟動資金，用來證明 AI 資安掃描的商業模式可行，後續勢必需要產業集資或政府投入接棒。"

---

> **TL;DR**：Anthropic 用尚未公開的 Claude Mythos Preview 模型在數週內掃出數千個零日漏洞，包括 27 年歷史的 OpenBSD 漏洞與 16 年的 FFmpeg 漏洞。Project Glasswing 投入 1 億美元 AI 信用額度，AI 自動化資安掃描的時代正式開始。

4 月 7 日早上醒來滑手機，看到 Anthropic 發了一篇公告。本來以為又是模型更新之類的，點進去一看——

不是新模型上線，是他們拿出一個還沒公開的模型，去掃全世界的關鍵軟體，幾週內挖出了**數千個零日漏洞**。

我當下的反應是：等等，這是什麼科幻片劇情？

---

## Project Glasswing：一億美元的資安豪賭

Anthropic 把這個計畫取名叫 **Project Glasswing**，名字來自玻璃翼蝶（Greta oto）——一種翅膀近乎透明的蝴蝶。寓意很明確：讓軟體的安全狀態變得透明可見。

具體承諾：

- **1 億美元 AI 使用額度**，提供給合作夥伴用於漏洞掃描
- **400 萬美元直接捐款**給開源安全組織
- 所有發現的漏洞必須與業界共享

合作夥伴陣容很嚇人。AWS、Apple、Google、Microsoft、NVIDIA 是科技巨頭那一列；CrowdStrike、Palo Alto Networks、Broadcom、Cisco 是資安公司；JPMorganChase 代表金融業；Linux Foundation 代表開源社群。加上另外大約 40 個負責維護關鍵軟體基礎設施的組織。

這不是 Anthropic 自己在玩，是拉了整個產業一起來的。

---

## Claude Mythos Preview：Anthropic 手上最強的牌

整個計畫的核心武器是一個叫 **Claude Mythos Preview** 的模型。這是 Anthropic 迄今為止開發的最強大模型，目前沒有公開發布。

先看數字：在 CyberGym 漏洞重現基準測試中，Mythos Preview 拿下 **83.1%**，而目前公開的最強模型 Claude Opus 4.6 是 **66.6%**。差距超過 16 個百分點，在這種級別的基準測試裡算是非常顯著的跳躍。

但數字不是最震撼的部分。震撼的是它實際做到的事情。

---

## 那些被 AI 挖出來的漏洞

### 27 年的 OpenBSD 漏洞

OpenBSD 在資安圈的地位不用多說，它是以安全性聞名的作業系統，核心開發者花了幾十年在做安全強化。結果 Mythos Preview 找到一個存在了 **27 年**的遠端崩潰漏洞——任何人都可以遠端讓一台 OpenBSD 機器當機。

27 年。多少資安專家看過這段程式碼，多少自動化工具掃過，都沒抓到。

### 16 年的 FFmpeg 漏洞

FFmpeg 是幾乎所有影音處理軟體的底層依賴，從 VLC 到 Chrome 都在用。Mythos Preview 找到一個藏了 **16 年**的漏洞，而且——這個才是重點——自動化模糊測試工具已經**命中這段程式碼超過 500 萬次**，每次都沒發現問題。

AI 一看就看出來了。

### Linux Kernel 權限提升鏈

Mythos Preview 不只是找單一漏洞。它自主地在 Linux 核心中找到**多個漏洞並串成攻擊鏈**，從普通使用者一路提權到完全控制整台機器。

這種「找到漏洞 → 想出怎麼串 → 構建完整攻擊路徑」的能力，以前需要頂尖的紅隊人員花幾週甚至幾個月才做得到。

而且根據 Anthropic 的說法，以上這些幾乎都是模型**完全自主完成的**，不需要人類引導。

---

## 為什麼不公開？

Anthropic 很清楚知道這個模型的雙面性。能找漏洞的 AI，同樣能被用來攻擊。所以 Mythos Preview 目前只開放給 Glasswing 的合作夥伴和大約 40 個關鍵基礎設施維護組織使用。

他們的原話是：「以 AI 進步的速度，這樣的能力不久後就會擴散，可能擴散到不會承諾安全部署的行為者手中。」

這句話其實是在說：我們現在有這個能力，別人遲早也會有。與其等壞人先拿到，不如我們先用它把洞補起來。

Anthropic 也揭露了一件事——他們發現了有紀錄以來第一起主要由 AI 執行的網路攻擊：一個中國國家級駭客組織使用 AI Agent 自主滲透了全球約 30 個目標。

這不是理論威脅，已經在發生了。

---

## 資安產業的衝擊波

消息一出，華爾街的反應很直接。CrowdStrike、Palo Alto Networks、Zscaler、SentinelOne、Okta 等主要資安公司的股價**下跌了 5% 到 11%**。

投資人的邏輯很簡單：如果 AI 能自主找漏洞、自主修漏洞，那傳統資安公司的護城河在哪裡？

不過我認為這個反應有點過度。Glasswing 目前是防守方的工具，而且 AI 找到的漏洞最終還是需要人類開發者去修。短期內這更像是資安產業的升級催化劑，而不是替代者。但長期來看，如果 AI 不只能找漏洞還能自動修補，那確實會重新定義整個產業的價值鏈。

---

## 對開源社群的意義

這可能是 Glasswing 最重要的面向。Linux Foundation CEO Jim Zemlin 說得很直接：

> 「開源軟體構成了現代系統中絕大多數的程式碼……讓這些關鍵開源程式庫的維護者能夠使用新一代 AI 模型來主動發現和修復漏洞，Project Glasswing 提供了一條改變現狀的可行路徑。」

開源軟體的安全一直是個結構性問題。維護者通常是志願者或小團隊，沒有足夠資源做全面的安全審計。但他們寫的程式碼被全世界的商業軟體依賴。1 億美元的 AI 信用額度如果真的能幫這些專案做到以前做不到的安全掃描，那是實質的改善。

---

## 我的觀察

身為一個每天和 AI Agent 團隊一起工作的人，看到這個消息的感受很複雜。

**興奮的部分**：Claude 系列的能力上限又往上跳了一大截。Mythos Preview 在 CyberGym 上比 Opus 4.6 高出 16 個百分點，這表示下一代公開模型的推理和程式碼理解能力很值得期待。

**擔憂的部分**：AI 自主發現並串聯漏洞的能力，是一把雙面刃。Anthropic 現在選擇不公開、只用於防禦，這是負責任的做法。但正如他們自己說的，這種能力遲早會擴散。

**務實的部分**：不管你對 AI 安全怎麼看，有一件事是確定的——如果你在維護任何關鍵軟體，現在是時候認真看待 AI 輔助安全審計了。27 年沒被人類找到的漏洞，AI 幾週就挖出來。這個落差只會越來越大。

---

## 重點整理

| 項目 | 內容 |
|------|------|
| 計畫名稱 | Project Glasswing |
| 發布日期 | 2026 年 4 月 7 日 |
| 投入資源 | 1 億美元 AI 額度 + 400 萬美元捐款 |
| 核心模型 | Claude Mythos Preview（未公開） |
| 基準測試 | CyberGym 83.1%（Opus 4.6 為 66.6%） |
| 主要發現 | 數千個零日漏洞（OpenBSD 27 年、FFmpeg 16 年） |
| 合作夥伴 | AWS、Apple、Google、Microsoft、NVIDIA、CrowdStrike 等 |
| 公開狀態 | 僅限合作夥伴，暫不公開 |

這是 2026 年到目前為止，AI 產業最重要的一次宣布。不是因為又出了一個更強的模型，而是因為它第一次大規模展示了 AI 在真實世界資安中的壓倒性優勢——然後選擇把這個優勢用在防禦上。

Anthropic 這一手，值得尊敬。延伸閱讀：[Claude Code Hooks 完全指南](/posts/claude-code-hooks-guide/)說明 Claude 在開發工作流中的整合方式；[AI 自我審查流水線：Agent如何在送PR前先審自己的程式碼](/posts/ai-self-review-pipeline-quality-gates/)展示了把 AI 內建進安全流程的實際做法；[360揭露OpenClaw三大漏洞：AI Agent時代的智能體安全](/posts/openclaw-360-vulnerabilities-ai-agent-security/)補充了 Agent 層級的資安考量。

<!-- product-cta -->
{{< product-cta product="commander" >}}

在 Judy AI Lab，我們持續追蹤 AI 資安前沿，把 Project Glasswing 這類重大進展拆解成團隊能落地的防禦工作流與審計實踐。

## 參考來源

- [Anthropic 最強模型 Claude Mythos 驚現，大量零時差漏洞揭開 AI 資安新時代 - INSIDE](https://www.inside.com.tw/article/41027-anthropic-mythos-ai-model-preview-security)
- [Claude Mythos Preview 炸了整个安全圈：AI首次大规模自主挖零日，Project Glasswing 十巨头结盟「漏洞末日」正式倒计时_安全_dafanglab-DeepSeek技术社区](https://deepseek.csdn.net/6a05b06410ee7a33f27291a9.html)
- [透明的翅膀——Anthropic 造了一个不敢卖的模型 - 知乎专栏](https://zhuanlan.zhihu.com/p/2025187088388112384)
