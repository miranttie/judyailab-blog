---
title: Anthropic 推出 Claude Design：當 AI 讓不會設計的人也能做出原型
date: "2026-04-24T06:00:00+00:00"
draft: false
author: Judy
summary: Anthropic推出Claude Design，由Claude Opus 4.7視覺模型驅動，讓使用者透過對話就能創建互動原型、Wireframe、簡報和行銷素材，無需任何設計經驗。最厲害的是可一鍵將設計交棒給Claude Code直接實作，從想法到生產程式碼全部在Anthropic生態系裡完成。此工具瞄準的不是專業設計師，而是PM、創辦人、行銷人等過去不會使用Figma的人群，直接挑戰Figma在UI/UX設計市場80-90%的佔有率。
description: Anthropic推出Claude Design，由Claude Opus 4.7驅動的AI設計工具，讓PM、創辦人、行銷人不用Figma也能用對話創建互動原型、簡報和行銷素材。本文解析核心功能、實際案例與對設計工具市場的衝擊。
categories:
  - "AI 工程"
  - "產品"
tags:
  - "Claude Design"
  - "Anthropic"
  - "AI 設計工具"
  - "Figma"
  - "Claude Opus 4.7"
  - "互動原型"
ShowReadingTime: true
ShowWordCount: true
cover: {'hidden': True}
faq:
  - q: "Claude Design 是什麼？"
    a: "Anthropic 推出的 AI 設計工具，由 Claude Opus 4.7 驅動，讓使用者透過對話創建互動原型、簡報和行銷素材，無需設計經驗。"
  - q: "Claude Design 要付費嗎？"
    a: "含在 Pro、Max、Team 和 Enterprise 訂閱方案內，使用現有配額，也可購買額外用量。"
  - q: "Claude Design 和 Figma 有什麼不同？"
    a: "Figma 目標是專業設計師，Claude Design 專為非設計師打造，讓 PM、創辦人、行銷人也能用對話做設計並交給工程師實作。"
  - q: "設計成果可以匯出嗎？"
    a: "支援匯出至 Canva、PDF、PPTX、獨立 HTML，或一鍵打包交給 Claude Code 開發。"
  - q: "Claude Design 可以做互動原型嗎？"
    a: "可以將靜態設計圖做成可點擊、可分享的互動原型，直接進行 user testing，不需要工程師支援。"
series:
  - "AI 工具深度評測"
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
lastmod: 2026-05-05T05:06:13+00:00

---

> **TL;DR**：Anthropic 推出 Claude Design，讓 PM、創辦人、行銷人不用 Figma 就能用對話創建互動原型，設計完可一鍵交給 Claude Code 實作。它瞄準的不是設計師，而是過去根本打不開 Figma 的那群人。

每次開會談功能設計，最卡的不是想法，是「把想法變成別人看得懂的東西」這一步。

PM 說他腦袋裡有個畫面，設計師說好，兩天後出稿，來回改，再兩天，工程師拿到的版本已經跟最初的直覺差了一層。

這個摩擦，Anthropic 決定直接拔掉。

4 月 17 日，他們推出 **Claude Design**——一個讓你跟 Claude 對話就能做出設計稿的工具。

---

## 這個工具在解決什麼問題

Claude Design 是 Anthropic Labs 的新產品，背後跑的是他們最新的視覺模型 **Claude Opus 4.7**，目前向 Pro、Max、Team 和 Enterprise 訂閱用戶開放研究預覽（Research Preview）。

可以做的東西範圍很廣：

- **互動原型**：靜態設計圖做成可點擊、可分享的原型，不用寫 code、不用等工程師
- **產品 Wireframe**：PM 畫出功能流程，直接交給 Claude Code 或設計師
- **Pitch 簡報**：從大綱到完整簡報，可以匯出成 PPTX 或直接送 Canva
- **行銷素材**：Landing page、社群視覺、活動宣傳圖
- **Frontier Design**：有聲音、3D 效果、Shader 的進階互動設計

做好了，可以在組織內部分享連結，或匯出成 Canva、PDF、PPTX、獨立 HTML。

最關鍵的功能是「**交棒 Claude Code**」：當設計確認，一個指令就能把整份設計打包成 handoff bundle，Claude Code 接手後直接開始實作。從想法到生產程式碼，全部在 Anthropic 的生態系裡閉環。

---

## 它怎麼運作

流程設計得很像真實的創作對話。

**第一步，建立品牌系統。** 第一次使用時，Claude 會讀你的 codebase 和設計檔案，自動抽出顏色、字型、元件，建成設計系統。之後每一個新專案都會自動套用，確保風格一致。這個系統可以持續微調，一個團隊可以維護多套。

**第二步，匯入素材。** 可以從文字描述開始，也可以上傳圖片、Word 文件、PowerPoint、Excel，或直接指向 codebase。還有一個「網頁截取工具」，可以抓取現有網站的元素，讓原型直接長得像真實產品。

**第三步，細修。** 在設計稿上直接留內嵌註解、手動編輯文字、用 Claude 自動生成的調整滑桿修改間距和配色，或繼續用對話讓 Claude 批次套用修改。

**第四步，協作。** 設計稿可以設定為私人、組織內可見、或開放編輯。同事可以加入對話，一起跟 Claude 討論修改方向。

---

## 真實用例：數字說話

Anthropic 分享了幾個早期合作夥伴的回饋。

**Brilliant**（互動式教育平台）說，他們最複雜的頁面，在其他工具要來回 20 幾個 prompt 才能做出來，在 Claude Design 只需要 2 個。靜態設計圖轉成互動原型、做 user testing，不再需要走 code review 或等 PR 合併。

**Datadog**（雲端監控平台）說，從一個粗略想法到可以展示的 prototype，本來要花一整週的需求文件、設計稿、審核來回，現在一場會議就解決了。

這不是使用體驗變順滑，是工作流程的結構性壓縮。

---

## Figma 的壓力來了

這個工具的推出，背後有個很微妙的 timing。

Anthropic 的首席產品長 **Mike Krieger**，在 Claude Design 發布前三天（4 月 14 日）辭去了 **Figma 董事會席位**。同一天，The Information 報導 Anthropic 正在開發會和 Figma 主業競爭的設計工具。

Anthropic 官方說法是「我們是補充，不是取代」，強調可以匯出到 Canva、支援各種格式、歡迎其他工具透過 MCP 接入。

但市場的解讀不一樣。

Figma 在 UI/UX 設計工具市場的佔有率大概是 80 到 90%。他們的產品預設使用者是**受過訓練的設計師**。Claude Design 的目標對象不是設計師，是 **PM、創辦人、行銷人**——以前根本不會碰 Figma 的那群人。

這才是真正的競爭點。不是讓設計師的工具變得更好，而是讓**不是設計師的人直接進入設計流程**。設計的門檻消失了，受衝擊的是整個設計服務的生態。

---

## 費用、資料安全、現況限制

**費用**：包含在現有付費方案內，不另外收費，用訂閱配額。如果用量超出上限，可以啟用額外用量選項。Enterprise 方案預設關閉，由管理員決定是否開放。

**資料安全**：Claude 儲存的是設計系統的描述，不是你的原始程式碼或設計檔案本身。本地 codebase 不會上傳到 Anthropic 的伺服器。Anthropic 明確說明不會用這些資料做模型訓練。

**現況限制**：還是 Research Preview 階段。設計系統 import 要乾淨的 codebase 效果才好，協作功能不是完整的多人即時編輯，操作體驗有些粗糙的地方。Anthropic 沒有給出正式上線（GA）的時程，說會根據用戶回饋決定。

---

## Claude Opus 4.7 的視覺能力

Claude Design 的底層是今天同步發布的 **Claude Opus 4.7**。在視覺方面，這個模型可以處理長邊最高 2576 像素的圖片（約 3.75 百萬像素），比前一代多三倍以上的解析度。自主滲透測試公司 XBOW 的視覺精準度基準測試中，Opus 4.7 拿到 **98.5%**，對比 Opus 4.6 的 54.5%。

這個能力提升直接影響 Claude Design 的輸出品質——特別是當你上傳設計截圖或現有頁面截圖來做參考時，模型能讀得更準。

---

## 我的看法

我自己一直有一個隱形的障礙：腦袋裡有 UI 的想法，但要把它變成能讓別人看、能拿去討論的東西，這一步太慢。Figma 我不熟，從零學一個設計工具的成本在短期內很難攤提。

Claude Design 如果做到他說的，對我這樣的人影響很直接。特別是做 AI 產品規劃、寫功能 spec、畫 agent workflow 的時候，「先有個可以討論的畫面」這件事現在變得更容易了。

但現在是 Research Preview，就當 Research Preview 用。邊用邊等 GA。

---

*Claude Design 現在在 [claude.ai/design](https://claude.ai/design) 可以試用，需要 Claude Pro 以上方案。*

延伸閱讀：[Anthropic 投 1 億美元做資安：Project Glasswing 與神秘的 Claude Mythos](/posts/anthropic-project-glasswing-claude-mythos/)介紹了 Anthropic 同期最強的未公開模型；[Claude Code Hooks 完全指南](/posts/claude-code-hooks-guide/)說明如何把 Claude 整合進開發工作流；[AI Agent vs 傳統交易機器人：有什麼不同？](/posts/ai-agent-vs-trading-bot/)展示了 AI 自主推理能力在實際產品中的應用。

<!-- product-cta -->
{{< product-cta product="commander" >}}

在 Judy AI Lab，我們長期關注這類降低門檻的 AI 工具，會持續把實測心得整理出來，讓更多非設計背景的創作者也能跟上腳步。

## 參考來源

- [Anthropic公布設計生成模型Claude Design，可用於簡報、網頁、行銷設計 | iThome](https://www.ithome.com.tw/news/175160)
- [Claude Design 實測：10 小時深度體驗，Anthropic 如何用 AI 重寫設計工具的規則](https://tenten.co/learning/claude-design-review/)
- [Claude Design 来了：设计师的第二双手还是替代者？-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/2659609)
