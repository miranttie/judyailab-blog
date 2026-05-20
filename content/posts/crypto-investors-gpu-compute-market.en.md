---
title: "Why Crypto Investors Need to Pay Attention to the GPU Compute Market"
date: 2026-03-19T10:00:00+09:00
draft: false
author: "Judy"
summary: "While the world is scrambling for GPUs, what should crypto investors make of this trend? From CoreWeave to Akash, GPU compute is becoming a new digital asset class."
description: "While the world is scrambling for GPUs, what should crypto investors make of this trend? From CoreWeave to Akash, GPU compute is becoming a new digital asset class. This article explores the financialization of compute, DePIN decentralized compute, GPU depreciation risks, and shares an on-the-ground perspective on the compute market from a crypto investor's lens."
tags: ["GPU", "Compute Market", "DePIN", "Investment Observations"]
categories: ["AI Investment Watch"]
ShowReadingTime: true
ShowWordCount: true
cover:
  hidden: true
faq:
  - q: "What does the GPU compute market have to do with cryptocurrency?"
    a: "GPU compute is evolving into a tradable digital asset, and blockchain technology enables compute to be tokenized and traded in decentralized ways. DePIN projects like Akash, Render, and Aethir are turning idle GPUs into on-chain tradable resources, making the crypto market and compute market increasingly intertwined."
  - q: "How are DePIN compute projects different from traditional cloud providers like AWS and Azure?"
    a: "DePIN compute takes a decentralized approach, forming networks of distributed GPU providers. Prices are typically 50-80% cheaper than traditional cloud. However, stability, enterprise-grade support, and compliance remain challenges. Currently better suited for flexible inference workloads, while large-scale training still relies primarily on centralized infrastructure."
  - q: "What is CoreWeave and why does it matter?"
    a: "CoreWeave is a GPU cloud company that went public in 2025, with long-term contracts from major customers including OpenAI, Meta, and Microsoft. Its significance lies in pioneering GPU as a financial asset — it borrowed over $18 billion in debt using GPU hardware as collateral. This fundamentally changed how the market perceives compute."
  - q: "What are the risks of investing in DePIN compute tokens?"
    a: "Key risks include: rapid GPU hardware depreciation (new chip generations can cut older model values in half), decoupling of token price from actual revenue, underdeveloped demand-side leading to low network utilization, and regulatory uncertainty. It's recommended to evaluate projects using fundamental metrics like revenue and utilization rates rather than token price appreciation alone."
  - q: "How can regular investors participate in the GPU compute market?"
    a: "There are currently several approaches: holding DePIN compute tokens (e.g., AKT, RENDER, ATH), investing in GPU cloud company stocks (e.g., CoreWeave), or becoming a decentralized compute provider (requires hardware investment). Each approach carries different risks and barriers to entry. Concentrating bets on a single project is not recommended."
hidden: true
ShowBreadCrumbs: true
ShowToc: true
TocOpen: true
lastmod: 2026-04-02T11:47:43+00:00

---
*This article is a deep-dive from JudyAI Lab — an AI engineering playbook series with 100+ published guides, 5,000+ weekly readers across 60+ countries, focused on the practical side of running AI agents, trading systems, and content pipelines in production.*

## The Moment I Realized GPU Had Become the New Oil

A while back, I was reading through a report and one number made me stop and think for a long time — global AI data center capital expenditure in 2026 is projected to reach $400–450 billion.

Four hundred and fifty billion dollars.

This isn't some distant forecast. We're talking about this year. And more than half of that money is going toward a single thing: GPU chips.

I'm based in Seoul, and I have a lot of friends in crypto. Conversations always revolve around which chain, which protocol, which token. But lately I've started noticing something interesting — more and more conversations are circling back to the word "compute."

Not mining compute. GPU compute for AI training and inference.

So I started digging seriously into this market, and what I found was far more complex — and far more interesting — than I expected.

---

## Why GPUs Have Suddenly Become So Important

The answer is pretty intuitive — AI exploded.

But "explosion" is too abstract. Let me break it down.

AI models need two types of compute. The first is "training" — teaching a model from scratch, which requires running massive numbers of GPUs for extended periods and is enormously expensive. The second is "inference" — once a model has learned, every time you ask it a question, generate an image, or translate a sentence, it needs to compute a response.

Early on, everyone focused on training because that's where the money was burning. But the wind has shifted. According to Deloitte analysis, by 2026, inference will account for roughly two-thirds of total AI compute demand, with the inference chip market projected to exceed $50 billion.

What does this mean? It means GPU demand isn't a one-time thing. Every AI service that goes live requires continuous compute to operate. Netflix needs servers to stream video. AI needs GPUs to stream intelligence.

Then factor in this reality: NVIDIA basically monopolizes this market. Their H100 chip was the standard for the past two years, the H200 is just starting to ship in volume, and the next-generation Blackwell B200 is now being delivered. With each iteration, compute capacity takes a big leap — but demand is growing even faster.

Estimates suggest that by the end of 2027, globally available AI compute will be 10x what it was in early 2025. That sounds like a lot, but relative to the pace of AI application growth, it may still not be enough.

So the current situation is: everyone is scrambling for GPUs — tech giants, startups, and nation-level AI initiatives alike.

---

## The Financialization of Compute — When GPUs Become Collateral

This is where I find the most interesting twist.

Historically, a GPU was just a piece of hardware. You bought it, installed it in a server, it ran your computations until it died. Just a tool.

But starting around 2023, one company completely changed the game.

CoreWeave — a GPU cloud company that pivoted from crypto mining — did something unprecedented. They used NVIDIA's GPUs as collateral to borrow enormous sums of money from Wall Street.

Not small amounts. Over $18 billion in debt financing.

Their earliest round was in 2023, using H100 chips as collateral to borrow $2.3 billion from Magnetar Capital and Blackstone at around 15% interest. They later added $7.6 billion more at slightly lower rates around 11%.

In 2025, CoreWeave went public on Nasdaq, raising $1.5 billion in the IPO. They hold long-term contracts worth $22.4 billion from OpenAI, $14.2 billion from Meta, and major agreements with Microsoft — total backlog exceeding $55 billion. Analysts estimate 2026 revenue could reach $12 billion.

NVIDIA itself made an additional $2 billion investment into CoreWeave in January 2026.

Why am I spending so much time on this one company? Because it represents an entirely new concept: **GPUs are no longer just hardware — they've become a financial asset.**

Think about what this reminds you of. It's very similar to real estate. You buy a building, use the building as collateral to borrow money, then use rental income to pay the loans. CoreWeave is doing exactly the same thing, just replacing the building with GPUs and the rent with cloud compute contract revenue.

The market has even started seeing GPU-backed asset-backed securities (ABS), conceptually similar to mortgage-backed securities. By 2025, people had started building compute futures exchanges; by early 2026, there were already exchange-traded futures on data center compute.

The CEO of DRW has publicly stated that compute is becoming "the world's largest commodity."

But there's a critical risk I'll get to — GPUs depreciate, and they depreciate far faster than buildings.

---

## DePIN Compute Projects: Decentralized GPU Cloud

At this point, crypto investors are probably asking: what does this have to do with me?

Here's where it connects: there's a category of projects trying to decentralize GPU compute, organizing and trading it through blockchain.

This is the "compute track" within DePIN (Decentralized Physical Infrastructure Networks).

Simply put, the concept behind these projects is: instead of letting AWS and Azure monopolize cloud compute, let GPU owners around the world put their idle compute onto a decentralized network, where anyone who needs it can purchase it with tokens.

A few names you might have heard:

**Akash Network** is probably the furthest along in this space. It's an open-source decentralized cloud marketplace where providers can list GPU and CPU resources for rent. In Q3 2025, new lease counts grew 42% quarter-over-quarter, reaching 27,000. They're pushing a system called Starcluster, attempting to blend centralized data centers with decentralized GPU markets. There's also an important mainnet upgrade coming in late March 2026 that introduces a new tokenomics model.

**Render Network** started as decentralized GPU rendering, primarily serving 3D and visual effects needs. As AI compute demand exploded, it pivoted toward broader GPU computing. Currently valued at over $2 billion, it's one of the highest-market-cap projects in the DePIN compute space.

**io.net** positions itself as aggregating globally distributed GPUs into a virtual supercomputer cluster. They primarily target AI/ML inference and fine-tuning workloads, aiming to offer pricing significantly cheaper than traditional cloud.

**Aethir** is distinct in that it's building enterprise-grade GPU cloud infrastructure, following a path more similar to a decentralized version of CoreWeave. Reportedly generating close to $40 million in quarterly revenue in 2025 — a standout revenue figure within DePIN.

The entire DePIN space generated approximately $72 million in on-chain revenue in 2025, with a market cap around $10 billion. Analysts estimate growth could exceed 70% in 2026.

But to be honest — these numbers are tiny compared to traditional cloud. AWS alone generates close to $100 billion in annual revenue. DePIN's current market share probably doesn't even reach 0.1%.

The story here isn't "it's already huge." It's "this could be one of the directions things are heading."

---

## How Crypto Investors Can Think About This

I'm not going to tell you what to buy or how to allocate. But I can share a few thinking frameworks I use when observing this space.

**First, look at fundamentals, not just token price.**

DePIN project valuations are gradually shifting toward traditional finance logic. According to Messari data, leading DePIN networks now trade at roughly 10–25x revenue, compared to over 1,000x during the 2021 cycle. This is a good sign — it means the market is maturing.

Questions worth asking: What's the GPU utilization rate of this network? Is the revenue coming from real paying demand, or is it being propped up by token subsidies? How many active compute providers are there? What's the growth trend?

**Second, understand the supply-demand cycle for compute.**

GPU cloud pricing went through a dramatic correction in 2025. H100 cloud rental rates fell from $8/hour to around $2.50–$3.50/hour — a drop of over 60%. This was driven by over 300 new GPU cloud providers entering the market.

This is great for compute buyers, but it creates pressure for "compute sellers" — including DePIN projects. If centralized cloud prices keep falling, the price advantage of DePIN gets compressed.

**Third, pay attention to industry structure, not just individual projects.**

The compute market is forming a new layered structure: at the top is NVIDIA (manufacturing GPUs), in the middle are companies like CoreWeave and DePIN networks (providing compute services), and at the bottom are the AI companies and developers who need compute.

Crypto's potential role in this structure is: a pricing and settlement layer for compute, a coordination mechanism for decentralized compute, and infrastructure for compute financial derivatives.

You don't necessarily need to bet on a specific project, but understanding this structure can help you evaluate which narratives actually have substance behind them.

---

## Risks: You Can't Only Look at the Upside

Any investment observation that only talks about reasons to be bullish isn't an observation — it's a sales pitch. So I need to cover the risks I think are most important.

**GPUs depreciate faster than you might think.**

NVIDIA releases a new generation of chips roughly every 18–24 months. When Blackwell B200 starts shipping in large volumes, the value of H100s will fall quickly. Analysts note that GPU-collateralized loans typically carry a 40–50% haircut because lenders can't determine what those GPUs will be worth in two or three years.

This is a risk for CoreWeave's debt model — they have approximately $4.2 billion in debt to refinance or repay in 2026. It's also a risk for hardware providers in DePIN networks: the GPUs you invest in today might be generating half the rental income two years from now.

**DePIN's demand side hasn't really materialized yet.**

The biggest problem with decentralized compute today isn't insufficient supply — it's insufficient demand. Many DePIN networks have low utilization rates, relying on token rewards to attract providers. Once rewards diminish, if real demand hasn't caught up, networks may shrink.

Akash's GPU utilization rate is reportedly around 70%, which is relatively high, but numbers vary significantly across other networks.

**Regulatory and compliance gray areas.**

Are compute tokens securities? Do decentralized compute networks need data center compliance certifications? These questions don't have clear answers right now. If major regulatory action happens someday, valuations across the entire space could be reset.

**Don't forget the DeepSeek effect.**

Early 2025, DeepSeek demonstrated the possibility of achieving high-performance models with significantly less compute. If AI compute efficiency continues improving, the "compute will never be enough" narrative may need revision. While it currently looks like demand growth still far outpaces efficiency gains, this is a variable worth monitoring continuously.

---

## My Take

While writing this piece, I kept coming back to an analogy.

Around 2015, very few people would have predicted that "cloud computing" would become the most critical infrastructure in the tech industry. Back then, most people thought cloud was just "someone else's computer" — nothing special. Then ten years later, AWS, Azure, and GCP became the foundation of the entire digital economy.

The GPU compute market today has a similar feel. It's still early, with plenty of froth and many unvalidated narratives. But the underlying demand is real — AI needs compute, and it needs more and more of it.

The reason crypto investors need to pay attention to this space isn't because "there's a new coin to trade." It's because compute may become the next fundamental resource to be tokenized and financialized, following bandwidth and storage.

Whether DePIN compute projects will ultimately succeed, I don't know. Whether CoreWeave's debt model can withstand the GPU depreciation cycle, I'm not certain either.

But what I am certain of is that compute is shifting from "something only technical people need to care about" to "something you need to understand to make sense of the digital economy."

And as someone observing from the intersection of crypto and AI, I think this trend is worth spending time to understand — even if your ultimate conclusion is to do nothing at all.

---

*All information in this article is for reference and educational purposes only and does not constitute investment advice. Cryptocurrencies and related assets are highly volatile. Please conduct your own research and assess your personal risk tolerance before investing.*


<!-- product-cta -->
{{< product-cta product="course" >}}

## References

- [GPU Infrastructure Is Becoming an Asset Class — Here's Why Crypto Investors Are Paying Attention | HackerNoon](https://hackernoon.com/gpu-infrastructure-is-becoming-an-asset-class-heres-why-crypto-investors-are-paying-attention)
- [I think GPU compute is an emerging asset class. Here's why - LinkedIn](https://www.linkedin.com/posts/bbaldieri_i-think-gpu-compute-is-an-emerging-asset-activity-7269677443433582592-UuDA)
- [Crypto News Today: AI GPU RENTAL Enables AI-Driven ...](https://www.theglobeandmail.com/investing/markets/markets-news/TheNewswire.com/1917264/crypto-news-today-ai-gpu-rental-enables-ai-driven-infrastructure-access-bitcoin-price-expected-to-reach-310-000/)
