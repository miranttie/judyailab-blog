---
title: "Tuning Open-Source Hermes to 80% of Claude Sonnet — 5 Methods and One Limitation"
date: 2026-05-25T10:00:00+00:00
lastmod: 2026-05-25T10:00:00+00:00
draft: false
author: Judy
summary: "The author compares Claude Sonnet with prompt-engineered Hermes 3 405B outputs through practical tests, proving that open-source models can reach 80% of commercial model quality in specific writing scenarios. Provides concrete System Prompt design principles for common issues like AI fluff, formulaic questions, and canned conclusions."
description: "This article demonstrates how to use System Prompt and Few-Shot techniques to elevate open-source Hermes 3 405B's writing quality to Claude Sonnet level at only 1/6 to 1/12 of the cost. Through three comparison tests on the same AI news story, it shows the difference between \"bare metal\" and \"tuned\" outputs, and summarizes 5 optimization methods for daily writing."
categories:
  - "AI Engineering"
  - "Tutorial"
tags:
  - "Prompt Engineering"
  - "Claude Sonnet"
  - "Hermes 3 405B"
  - "LLM Cost Optimization"
  - "System Prompt Design"
  - "AI Writing Techniques"
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
slug: prompt-engineering-cheap-llm-to-sonnet-level
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
faq:
  - q: "How much can I save by switching from Claude Sonnet to Hermes 3 405B for writing tasks?"
    a: "Hermes 3 405B costs $1/M input and $1/M output tokens, while Claude Sonnet 4.6 runs $3/M input and $15/M output. For typical writing tasks where output dominates (around 700 output tokens vs 800 input tokens for a 500-word piece), total cost drops to roughly one-sixth to one-twelfth of Sonnet. The exact ratio depends on your prompt length and output-to-input ratio. Output-heavy workloads like blog drafts, newsletter summaries, and news critiques see the largest savings since Hermes output pricing is fifteen times cheaper."
  - q: "Why does default Hermes Chinese writing feel like machine-translated AI slop?"
    a: "Hermes is an English-trained open-source model without Anthropic-style RLHF tuning for Chinese stylistic nuance. Grammar is correct, but point density, tone restraint, and opening approaches default to clichés like 'this is undoubtedly great news' or 'let's chat about this together'. Sonnet's polished Chinese comes from heavy human feedback layering that Hermes lacks. The fix is not retraining — it's prompt engineering. A targeted system prompt plus few-shot examples can suppress the cliché patterns and push output quality to roughly 80% of Sonnet level."
  - q: "What are the 5 prompt tuning methods to push Hermes to 80% of Sonnet quality?"
    a: "The five methods are: (1) explicit style constraints in the system prompt banning clichés like 'undoubtedly' and 'let's chat'; (2) few-shot examples showing 2-3 high-quality openings to anchor tone; (3) point-density rules forcing one concrete fact per paragraph; (4) opening pattern restrictions to prevent generic hooks; (5) tone calibration instructions specifying restraint over enthusiasm. Combined, these compress the style gap without retraining. They work best on structured writing tasks like news critiques and technical posts, less so on creative narrative."
  - q: "Which writing tasks should stay on Claude Sonnet instead of moving to Hermes?"
    a: "Keep Sonnet for tasks requiring deep cultural nuance, long-form narrative coherence beyond 1500 words, brand-voice-critical copy, and any Traditional Chinese content where subtle tone shifts matter for credibility. Hermes handles AI news critiques, product copy drafts, X threads, and newsletter summaries well after tuning. The one consistent limitation is opening creativity — Hermes still defaults to formulaic hooks even with few-shot examples. For flagship blog posts and high-stakes client work, the cost savings do not justify the quality drop."
  - q: "What is the one limitation that prompt tuning cannot fix on Hermes?"
    a: "Opening creativity is the persistent gap. Even with system prompts banning clichés and few-shot examples showing strong hooks, Hermes tends to revert to formulaic openings on novel topics. Sonnet generates fresh angles by default; Hermes needs you to supply the angle in the prompt. For pipelines, this means writing the first sentence yourself or maintaining a hook library the model picks from. If you need true zero-shot opening originality at scale, prompt tuning will not close that gap and Sonnet remains worth its premium."
  - q: "Who should use Hermes 3 405B with prompt tuning instead of just paying for Sonnet?"
    a: "This setup suits teams running high-volume writing pipelines — daily blog drafts, multiple newsletter sends, automated news critiques, or AI agent fleets producing hundreds of pieces weekly. If you generate over 500K output tokens monthly, switching saves real money. Solo creators producing one or two posts a week should stay on Sonnet since the absolute savings are small and engineering time on prompt tuning is not worth it. The break-even point is roughly $200 monthly in Sonnet output spend."

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

## Section 1 — Why Tune Cheaper Models to 80%?

I'm currently leading 6 AI agents, and a big chunk of our daily tasks involves writing: blog posts, news critiques, product copy, X threads, newsletter summaries.

At first, everything ran through Claude Sonnet. The results were great, but the bills piled up fast. Sonnet 4.6 goes for $3/M input tokens and $15/M output tokens on OpenRouter. In writing tasks, output dominates — for a 500-word article, input might be 800 tokens (prompt + system instructions), while output easily hits 700 tokens. Do the math, and output costs are often five to ten times input.

Then I compared Hermes 3 405B: $1/M for input, $1/M for output.

Input is one-third of Sonnet's, output is one-fifteenth. For real-world writing tasks, total cost comes out to about one-sixth to one-twelfth of Sonnet, depending on your prompt length.

Sounds tempting, but here's the catch: Hermes is an English-trained open-source model, and its Chinese writing is noticeably behind Sonnet. Not grammar-wise (grammar is fine), it's about point density, tone restraint, and opening approaches. Default Hermes Chinese reads like machine-translated AI blogs, full of clichés like "這無疑是一個好消息" ("this is undoubtedly great news") or "讓我們一起聊聊" ("let's chat about this").

Can't just swap it into the pipeline. Sonnet's style didn't fall from the sky — it's heavily tuned with human feedback from Anthropic. Hermes doesn't have that layer.

But "can't swap directly" doesn't mean "can't use." That's exactly what prompt engineering solves: can we push a cheaper model's output quality to usable levels through careful system prompts?

The core answer: **some topics work, some don't — it depends on the task type.** I used one piece of AI news as my comparison material, ran the same prompt three times, and now you'll see exactly where the gaps are.

## Section 2 — Running the Same News Prompt Three Times

To keep things fair, we picked an AI news piece that's neutral and unrelated to the models themselves:

> **"Gemini 3.1 Flash-Lite drops to $0.25 per million input tokens, GPT-5.4 Nano down to $0.20 — lightweight model price war heats up"**

The shared prompt:

> Write a blog post opening, 300-350 words, Traditional Chinese, comment on this news. Start from a specific scenario, have a point, skip PR press release style.

All three outputs share the same user prompt. The difference is in the system prompt: Group A set an ultra-minimal `HERMES_SYSTEM="You are a writer."` to bypass all default loading mechanisms (this is our "bare metal"); Group B is Sonnet without any custom system prompt; Group C follows `call_hermes.sh`'s default flow, auto-loading style guidelines + few-shot + constraint list.

In other words, A and C are "same model, different tuning" comparisons, while B is the "target level" reference.

---

### A. Bare Metal Hermes (No Style Guide, No Few-Shot)

> 最近幾週，我注意到一些有趣的變化在AI模型的世界裡。我的一個開發者朋友興奮地告訴我，有幾家模型商正在瘋狂地降低他們的輕量模型價格。Gemini 3.1 Flash-Lite 現在每百萬輸入 Token 只需要 $0.25，而 GPT-5.4 Nano 更是下探到了 $0.20。這場價格戰顯然已經白熱化，各家廠商都在努力推出更便宜的版本來吸引開發者市場。
> 
> 這樣的變化讓我不禁思考，AI 的民主化是不是正在加速進行？過去，高質量的AI模型通常只限於大公司或研究機構使用，但現在看來，即使是獨立開發者或小公司也能負擔得起這些先進的技術。這對於創新來說無疑是一個好消息。
> 
> 但另一方面，我也忍不住擔心這場價格戰會不會對AI產業帶來一些負面影響。過度的競爭可能導致某些公司為了生存而犧牲品質或倫理標準。
> 
> 希望這能為技術創新帶來更多可能性，也希望這場競爭能夠在一個健康的框架下進行。如果你也對這些變化有所關注，不妨分享你的觀察和想法，我們一起來聊聊吧！

**Review — Four Problems Stand Out:**

**AI Fluff Opening**: "最近幾週，我注意到一些有趣的變化" ("Over the past few weeks, I've noticed some interesting changes") — this carries zero information density, any AI could generate it.

**Formulaic Question Left Hanging**: "AI 的民主化是不是正在加速進行？" ("Is AI democratization accelerating?") asks a question without actually answering it, leaving the reader hanging.

**Generic Fluff Conclusion**: "這對於創新來說無疑是一個好消息" ("This is undoubtedly great news for innovation") and "希望這能為技術創新帶來更多可能性" ("Hope this brings more possibilities for tech innovation") — these two sentences could fit into any AI news critique, no specificity whatsoever.

**Formulated Canned Ending**: "不妨分享你的觀察和想法，我們一起來聊聊吧" ("Feel free to share your observations and thoughts, let's chat") — PR press release format.

One detail: "質量" (zhìliàng) is Mainland terminology; Taiwan uses "品質" (pǐnzhì).

This is LLM's "average写法" — no specific scenario, no counter-intuitive perspective, no personal angle. The model is doing the safest thing possible to fulfill the instruction.

---

### B. Claude Sonnet (Target Level)

> 上個月我幫一個小專案串了一個摘要 API，跑了大概兩週，月底一看帳單：$1.80。
>
> 我愣了一下——不是因為貴，是因為太便宜了。這個 API 一天大概被呼叫幾百次，幫我省掉的時間少說值幾千塊，但我付的錢還不夠買一杯手搖。
>
> 然後這週看到消息：Gemini 3.1 Flash-Lite 每百萬 token 降到 $0.25，GPT-5.4 Nano 更殺，直接推到 $0.20。輕量模型的價格戰已經不是在打折，是在重新定義「AI 算不算有成本」這件事。
>
> 我的第一個反應不是「太棒了好便宜」，而是：這個趨勢對誰有利，對誰是噩夢？
>
> 對開發者來說，當然是好事。以前一個小工具要估算 API 費用會讓人猶豫，現在根本不值得花時間算。但反過來想，當成本接近零，競爭優勢就從「能不能用 AI」移到「用得好不好」。便宜讓進入門檻消失，但也讓差異化更難做。
>
> 更值得想的是：這輪降價背後，Google 和 OpenAI 搶的不是你手邊這幾塊錢的 API 費，他們要的是你把整個工作流鎖進他們的生態系。今天 $0.20 很香，明天你的系統全部依賴這個模型，漲回 $0.80 的時候你怎麼辦？
>
> 便宜是入口，不是終點。

**Review — Why It's the Target Level:**

**Specific Opening**: Last month + summarization API + $1.80 bill + "not enough for a bubble tea" contrast. This opening establishes three layers in the first three lines: time, scenario, counter-intuitive feeling.

**Counter-intuitive Insight**: "不是貴，是太便宜了" ("not expensive, it's too便宜") flips the reader's expectation. "重新定義 AI 算不算有成本" ("redefining whether AI has a cost") is an angle bare metal Hermes completely lacks.

**Multi-layered Perspective**: Good for developers / differentiation gets harder / long-term ecosystem lock-in risk. Three perspectives, all squeezed into 300 words.

**Ending Is Observation, Not Invitation**: "便宜是入口，不是終點" ("Cheap is the doorway, not the destination") — one line, has its own stance.

These 300 words contain three non-obvious perspectives. This is the real gap between Sonnet and bare metal Hermes — not Chinese grammar, it's **point density**.

---

### C. Tuned Hermes (v1, ~70% Level)

> 3月底那天，我在首爾的辦公室整理一個客製化的AI語音助手，準備上線前突然想檢查一下成本。一個接一個翻過去，眼睛停在一個數字上：這個月，光是API調用就花了我120萬韓元。我愣了一下，心想「怎麼可能？」
>
> 就在這時，新聞滾動條上跳出一條消息：Gemini 3.1 Flash-Lite 每百萬輸入 Token 推到 $0.25，GPT-5.4 Nano 更是下探到 $0.20。原來是輕量模型價格戰白熱化，各家模型商紛紛推出更便宜版本搶佔開發者市場。
>
> 這場價格戰看似開發者的福音，實則是一場雙刃劍。對於我們這些獨立開發者和小團隊來說，成本下降當然是好消息，但背後隱藏的卻是更激烈的競爭和更高的入門門檻。
>
> 在這場戰役中，真正的贏家恐怕是那些能夠在降低成本的同時，保持高品質服務的模型商。隨著價格不斷下探，模型間的競爭將不再是價格，而是效能和可靠性。對於我們開發者來說，能否在這場浪潮中找到自己的立足之地，将是一個巨大的挑戰。

**Review — Progress and What's Still Missing:**

**Progress**: Has a specific scenario now (late March + Seoul office + AI voice assistant + 1.2M KRW bill). "最近幾週" is gone. Formulaic questions gone. "我們一起來聊聊" nowhere to be found.

**What's Still Missing**: "新聞滾動條上跳出一條消息" ("a news ticker flashed a message") feels artificially dramatic; Sonnet just says "然後這週看到消息" ("then this week I saw the news"), much more natural. The argument section still has AI speak: "真正的贏家恐怕是" ("the real winner probably is"), "巨大的挑戰" ("huge challenge"), "在這場浪潮中" ("in this wave"), "雙刃劍" ("double-edged sword"). Most critically: no counter-intuitive insight like Sonnet's — no "cheap is the entry, not the destination," no "ecosystem lock-in" angle, no reasoning layer about "differentiation moving from can-use to how-well."

Point density is about half of Sonnet's.

This is ~70%: structure is there, tone is matched, but reasoning depth hasn't reached that level yet.

---

## Section 3 — Our 5 Tuning Methods

Tuning isn't a one-and-done design. Here are the 5 methods we actually use, and each one is essential.

### 3.1 Style Guide File (202 Lines)

I organized "how Judy writes" into a document: `Judy寫作風格整理.md`, 9912 bytes, 202 lines. Content divided into sections: core identity (Taiwanese AI builder in Seoul, not a KOL or sponsored account), thinking framework (observation → topic → personal experience → open insight), tone guidance (restrained, not preachy, has stances without being radical), commonly-used transition word lists, prohibited word lists, sentence pattern features.

Through `call_hermes.sh`, this document auto-loads into the system prompt before every call. (Unless you set the `HERMES_SYSTEM` environment variable to override it — that's the mechanism we used to create the bare metal control group in Group A above.)

The key isn't the document's format, it's "documenting" itself. Your intuitive sense of style — "I don't like wrapping keywords in quotes," "don't open with questions," "ending should have a take, not invite comments" — these intuitions are invisible to the model, you have to write them as explicit rules.

### 3.2 Few-Shot Auto-Fetching Latest 3 Real Blogs

Early versions had static text examples directly in the prompt, but I found Hermes's "few-shot learning" too honest — it would directly copy example sentence structures, even paraphrase entire paragraphs, reading like my old articles were regurgitated.

The fix was switching to **dynamic fetching**: before every call, grab the latest 3 posts from `content/posts/*.zh-tw.md` by modification time, truncate each to the first 1200 characters, and inject them as few-shot examples.

Three benefits: always see the latest writing style, which naturally evolves with the articles; new posts auto-refresh, no need to maintain the example library; truncating to 1200 characters instead of full text controls context length to prevent token explosion.

### 3.3 Constraint List (Explicit Prohibition)

Style guide says "write this way," constraint list says "don't write this way" — separate them, both needed.

My main prohibitions:

- Emoji (completely banned)
- Mainland terminology (质量 → 品質, 隐藏, 这场, 厂商)
- Code-mixing (no English unless it's a technical term)
- Formulaic questions ("X 是不是正在加速？" type leading questions)
- Dramatic formulas ("新聞滾動條跳出," "就在這時" type cinematic transitions)
- AI speak list: "無疑是," "真正的贏家," "巨大的挑戰," "在這場浪潮中," "雙刃劍"

This list goes into the user prompt, pasted every single time.

### 3.4 Structure Template Instead of Text Examples

Don't give "please write like this: [complete example paragraph]" — that's a text example, the model will copy.

Give "opening structure formula: [specific time] + [specific place] + [specific action] + [contrast feeling]" — this is a structure template, the model fills in original content per the grid.

The opening in Section 2's Group C (tuned Hermes) is the result of this template: late March (time) + Seoul office (place) + organizing AI voice assistant (action) + 1.2M KRW bill "怎麼可能?" (contrast). Every run is different, but fits the shape.

### 3.5 Negative Example Explicitly Shown

Listing "never write like this ✗" works better than positive lists.

The principle: models are more sensitive to "prohibition signals" than "encouragement signals." Telling the model "good openings are like this" might cause it to treat good examples as templates to copy; telling the model "writing like this is wrong" helps it avoid more precisely.

I directly pulled failure examples from earlier raw outputs, which worked better than self-crafted negative examples — because they're genuinely from that model, accurately matching its own failure patterns.

---

## Section 4 — One Key Limitation: The Methodology Isn't Universal

But honestly, these 5 methods aren't an "apply and get 80%" silver-bullet.

80% is an average, not a ceiling you hit on every task. The same tuning mechanism applied to different writing tasks produces very different results.

### 4.1 Tasks Where Hermes Can Reach 80%

**Content with clear structural templates.** News commentary, product feature descriptions, tutorial step breakdowns, X posts, newsletter summaries — these tasks share a trait: the shape of the opening, reasoning, and conclusion is fixed. The model just needs to fill in concrete content per the grid. Style guide plus structure template is enough to carry these tasks.

**Content anchored in external data.** Hand the model a press release, a chart, an API response and ask it to "write a commentary based on this data" — Hermes performs respectably when constrained by data. Its weakness is "originating viewpoints from nothing," but "extending from data" is something it can do.

**High-repetition, low-variation batch writing.** Standardized content produced at volume (news digests, posts, product copy) on Hermes isn't just cheaper — because the output shape converges, post-processing QA is easier too.

### 4.2 Tasks Where Hermes Still Can't Get There

**Long-form content requiring original-viewpoint density.** Tutorials, deep analysis, case retrospectives — Sonnet's capacity for "flipping reader expectations in one line" or "addressing three reader layers simultaneously" is accumulated through pre-training and RLHF. Prompt engineering can't claw that back. A close like Section 2's Group B "cheap is the entrance, not the destination" is still beyond tuned Hermes.

**Complex logical reasoning.** Tech-stack decisions, strategy backtest analysis, bug root-cause investigation — these demand rigorous inference across multiple premises. Hermes tends to skip a premise mid-chain; the conclusion looks plausible but the logic links break.

**Long-form coherence.** Past 2,000 words, Hermes drifts in topic, breaks call-backs to earlier sections, repeats rhythm. Long-form coherence is one of Sonnet's biggest gaps over other models.

### 4.3 A Hybrid Strategy, Not a Binary Choice

In practice the answer isn't "all Hermes" or "all Sonnet" — it's task-based routing:

- **Hermes**: X posts, news summaries, product feature descriptions, first-draft sketching
- **Sonnet**: Blog tutorials, deep analysis, case studies, strategy decision documents
- **Mixed**: Mid-length articles — let Hermes lay the structure, Sonnet rewrites and adds viewpoints

This is the same routing logic discussed in [Running 4 LLMs in One Multi-Agent Team: The Real Selection and Cost Story](/posts/multi-llm-agent-team-cost-reality/) — not "use whichever is best," but "for each task find the cheapest model that's good enough."

Pushing Hermes from "unusable" to "good enough" — that 80% — is what prompt engineering can do. The remaining 20% (viewpoint density and long-form logic) still belongs to Sonnet today. Whether you can accept that 20% gap depends on your content mix. For teams producing a dozen standardized pieces a day, saving 80% of the standardized-writing budget beats chasing 100% on everything.

---

## Further Reading

- [Running 4 LLMs in One Multi-Agent Team: The Real Selection and Cost Story](/posts/multi-llm-agent-team-cost-reality/) — Actual division of labor and bill breakdown across 4 models
- [2026 Open-Source LLM in Production: Why Our AI Team Picked MiniMax M2.7](/posts/open-source-llm-agent-team-2026/) — Considerations for choosing another open-source LLM
- [How I Got 5+ Different AI Models to Self-Operate 24/7](/posts/2026-05-20-multi-model-ai-team-24h-autopilot/) — The overall architecture of a multi-model agent team
