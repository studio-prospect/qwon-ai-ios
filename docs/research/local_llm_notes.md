# Local LLM Notes

## Purpose

This note captures the role of local LLMs inside PREXUS and the evaluation lens for choosing and operating them on iPhone-class hardware.

PREXUS does not use local LLMs only for chat response generation. Local models are part of the control plane.

## Why Local LLM Matters

In PREXUS, a local LLM can support:

- intent classification
- routing preparation
- context compression
- lightweight summarization
- memory write filtering
- selective recall packaging
- baseline conversational response

This is important because it means local model quality should not be judged only by creative output quality. Routing and compression accuracy matter just as much.

## Core Selection Criteria

When evaluating local models for PREXUS, prioritize:

- low latency on iPhone-class hardware
- low RAM usage
- stable token streaming behavior
- acceptable instruction-following for compact system prompts
- good summarization and classification quality
- compatibility with CoreML, MLX, or efficient local runtimes

Secondary criteria:

- multilingual support
- OCR post-processing quality
- reasoning depth
- model size flexibility

## Candidate Families

### Gemini Nano-class direction

Potential value:

- lightweight local assistant behavior
- efficient mobile-oriented deployment strategy
- possible fit for control-plane tasks

Research questions:

- practical iOS integration path
- actual latency under device thermal limits
- instruction reliability for compact orchestration prompts

### Apple Foundation Models direction

Potential value:

- native platform alignment
- possible energy and privacy advantages
- strong fit if supported capabilities match control-plane needs

Research questions:

- availability and access constraints
- prompt control surface
- consistency for routing and compression tasks

### MLX-compatible model direction

Potential value:

- flexible experimentation
- easier local evaluation workflow
- useful for benchmarking and conversion exploration

Research questions:

- portability from Mac-side experiments to iPhone runtime reality
- memory usage after conversion and packaging
- integration complexity

### Gemma-4-E2B-it direction

Current status: evaluation candidate #1, not default. See [Gemma-4-E2B-it Evaluation Plan](./gemma4_e2b_evaluation_plan.md).

Potential value:

- compact instruction-tuned candidate for the Tier 2 profile
- promising fit for local fallback, summarization, routing support, and context compression
- aligned with mobile/edge model direction

Research questions:

- availability and stability of a suitable GGUF / quantized artifact under llama.cpp
- first-token latency and decode throughput on A17 Pro+
- Japanese short-form quality and deterministic JSON behavior under compact prompts
- whether LiteRT-LM should become a separate backend evaluation if llama.cpp is unstable

### LiteRT-LM / Google AI Edge direction

Current status: backend feasibility proven on Wang (iPhone 17 / A19-class), not production path. See [LiteRT-LM Evaluation Plan](./litert_lm_evaluation_plan.md).

Potential value:

- native iOS Swift API with Metal acceleration
- `.litertlm` artifact path designed for on-device LLM deployment
- possible better Gemma 4 behavior than the current GGUF llama.cpp path
- future support surface for constrained decoding, session management, tool use, and multimodality

Research questions:

- whether the Early Preview Swift API is stable enough for PREXUS beyond the Wang success case
- whether model artifacts are available, license-compatible, and practical to distribute
- cold load, memory, thermal, and package-size impact on iPhone
- Japanese short-form quality and deterministic routing JSON reliability
- whether a second backend abstraction is justified after feasibility is proven

### llama.cpp / CoreML-converted direction

Potential value:

- broad ecosystem
- easier experimentation across open models
- strong controllability over quantization and packaging

Research questions:

- best size/performance tradeoff for iPhone
- thermal behavior under sustained use
- token throughput for streaming UX

## Tiered Model Strategy

PREXUS likely needs more than one local model profile.

### Tier 1 profile

Use for:

- wake-adjacent intent detection
- low-cost classification
- event detection

Requirements:

- tiny footprint
- extremely low energy use
- near-instant startup

### Tier 2 profile

Use for:

- basic chat
- summarization
- routing support
- memory filtering
- OCR post-processing

Requirements:

- better instruction following
- acceptable streaming
- still feasible within mobile RAM and thermal limits

It may be acceptable to start MVP with one Tier 2 model and defer true Tier 1 specialization.

## Prompting Implications

Local prompts should be:

- short
- deterministic
- structured
- task-specific

The local model should avoid giant meta-prompts. Instead, PREXUS should use narrow prompts for:

- classify
- compress
- summarize
- extract intent
- decide escalation candidate

## Evaluation Tasks

Local model evaluation should include more than generic chat.

Suggested task buckets:

- intent classification accuracy
- summarization fidelity
- context compression quality
- memory candidate extraction quality
- OCR cleanup quality
- basic dialogue usefulness
- latency and streaming smoothness

## Failure Modes to Watch

- slow first-token latency
- unstable instruction following
- hallucinated classifications
- weak summarization under compact prompts
- RAM spikes during model switch
- battery drain under repeated short requests

These failures can make a local-first architecture feel worse than a simpler cloud-first app.

## MVP Recommendation

For MVP, prioritize a model that is:

- reliable for classification and summarization
- fast enough for short interactive turns
- small enough for safe on-device operation
- compatible with structured compact prompts

Do not over-optimize for benchmark reasoning if that harms latency or thermal behavior.
