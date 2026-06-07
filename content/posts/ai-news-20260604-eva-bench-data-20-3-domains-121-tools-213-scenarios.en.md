---
title: "EVA-Bench Data 2.0 Benchmark Released: Covering 3 Domains, 121 Tools, and 213 Test Scenarios"
date: "2026-06-04T18:06:20+00:00"
draft: false
author: Judy
summary: "AI News: ServiceNow AI Research Team releases EVA-Bench Data 2.0, an enterprise-grade benchmark designed for Voice Agent, now significantly expanded from a single domain to three enterprise scenarios: Aviation Customer Service Management (CSM), Enterprise IT Service Management (ITSM), and Healthcare HR Service Delivery (HRSD). The three domains together cover 213..."
description: "JudyAI Lab AI News — Source Hugging Face Blog"
categories:
  - "AI News"
tags:
  - "AI Update"
  - "community"
ShowReadingTime: true
ShowWordCount: true
ShowBreadCrumbs: true
news_source: "Hugging Face Blog"
news_source_url: "https://huggingface.co/blog/ServiceNow-AI/eva-bench-data"
news_pipeline_version: "v1-rss-only"
commentary_engine: "sonnet-v1"
recovered_at: "2026-06-07T13:09:08.278030+00:00"
---

## 📰 Key Takeaways

> ServiceNow AI Research Team releases EVA-Bench Data 2.0, an enterprise-grade benchmark designed for Voice Agent, now significantly expanded from a single domain to three enterprise scenarios: Aviation Customer Service Management (CSM), Enterprise IT Service Management (ITSM), and Healthcare HR Service Delivery (HRSD). Together, the three domains cover 213 evaluation scenarios and 121 tools—a roughly fourfold increase over the initial version. Breaking it down by domain: Aviation has 50 scenarios, ITSM has 80, and HRSD has 83.

This benchmark places a strong emphasis on voice scenario realism. Each data point was筛选 based on actual phone customer service workflows, and the tool schemas are modeled after production environment API specifications. The Healthcare HRSD domain goes further by integrating real US healthcare policies, including NPI physician identification numbers, FMLA leave regulations, and insurance coverage rules—ensuring the evaluation scenarios align closely with practitioners' actual work contexts. All 213 scenarios have been cross-validated for solvability across three frontier models—OpenAI GPT-5.4, Google Gemini 3.1 Pro, and Anthropic Claude Opus 4.6—to ensure the benchmark is challenging and the evaluation results are fair and reliable.

All three datasets have been open-sourced and can be loaded directly via HuggingFace Datasets. The team has also announced an upcoming multi-language expansion, which will extend the evaluation scope beyond the current pure-English enterprise deployment constraints. The dataset design principles and generation process details are fully documented in the original article, serving as a practical reference for developers looking to build their own evaluation datasets.

---

## 💬 JudyAI Lab Perspective

ServiceNow expanding the Voice Agent benchmark from a single domain to three enterprise scenarios—Aviation, ITSM, and Healthcare—and open-sourcing them all—in our view, signals that enterprise AI voice evaluation standardization has moved from conceptual discussion to practical, actionable tools.

The most noteworthy design principle here is "筛选 scenarios based on real phone customer service workflows" rather than inventing problems from scratch. This approach reflects a growing consensus: if enterprise voice AI evaluation is disconnected from actual business processes, the scores often fail to predict production environment performance. The cross-validation of all 213 scenarios across GPT-5.4, Gemini 3.1 Pro, and Claude Opus 4.6 ensures the benchmark is both challenging and fair—not just friendly to a specific model. The inclusion of NPI identification numbers, FMLA leave regulations, and insurance coverage rules in Healthcare HRSD scenarios also shows that evaluation data in high-compliance domains needs to meet a certain density threshold of business details to truly measure meaningful differences.

If you're building an enterprise AI evaluation dataset, the open-source data's scenario generation process files are a direct starting point for reference—reverse-engineering test scenarios from business workflows exposes production gaps more effectively than forward-engineering from model capability dimensions.

---

## 📅 Source Info

- **Release Date**: 2026-06-04T12:24
- **Original Source**: [https://huggingface.co/blog/ServiceNow-AI/eva-bench-data](https://huggingface.co/blog/ServiceNow-AI/eva-bench-data)

---

## 🔗 Further Reading

- [The Rise of Customized AI Models: Tailoring Intelligence for Your Business](https://judyailab.com/zh-tw/posts/rise-of-customized-ai-models/)
- [From Trading Idea to Live Deployment: The Real Workflow of AI-Assisted Strategy Development](https://judyailab.com/zh-tw/posts/trading-concept-to-production-code-with-ai/)
