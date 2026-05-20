# Gemma-4-E2B-it Evaluation Plan

## Purpose

This document records the current PREXUS decision on Gemma-4-E2B-it and gives Cursor an implementation-ready evaluation task.

PREXUS should treat Gemma-4-E2B-it as the first serious on-device language model candidate for the local inference lane, but not as the default production model yet.

## Current Decision

| Item | Decision |
|---|---|
| Model | `google/gemma-4-E2B-it` |
| Status | Evaluation candidate #1 |
| Default model? | No |
| First integration path | Existing llama.cpp / GGUF path from P1-1 |
| Fallback research path | LiteRT-LM / Google AI Edge path if llama.cpp is unstable |
| Target device class | A17 Pro+ first, then broader iPhone support only after evidence |
| Asset policy | Do not commit model binaries or large downloaded artifacts |

## Why This Candidate Fits PREXUS

Gemma-4-E2B-it is attractive because it aligns with the PREXUS direction:

- local-first mobile inference
- compact model footprint relative to larger open models
- instruction-tuned behavior for short deterministic prompts
- possible future fit for multimodal and agentic on-device workflows
- permissive enough licensing posture for evaluation, subject to final legal/product review

The model should be evaluated as a runtime control-plane model, not only as a chat model. PREXUS needs local models for routing support, context compression, summarization, memory filtering, and safe local fallback.

## Source Notes

The current evaluation is based on publicly available model/runtime information as of 2026-05-20:

- Google Gemma 4 announcement and edge/mobile positioning: https://developers.googleblog.com/bring-state-of-the-art-agentic-skills-to-the-edge-with-gemma-4/
- Google Developers Blog on LiteRT-LM on-device GenAI: https://developers.googleblog.com/blazing-fast-on-device-genai-with-litert-lm/
- Hugging Face model page for `google/gemma-4-E2B`: https://huggingface.co/google/gemma-4-E2B-it

These sources are external references. Implementation must still be validated inside PREXUS with the actual model artifact and runtime path used by the app.

## Non-Goals

Do not do the following in the first evaluation PR:

- Do not switch the PREXUS default local model to Gemma-4-E2B-it.
- Do not replace the P1-1 llama.cpp backend with LiteRT-LM.
- Do not commit model weights, converted model binaries, or generated large artifacts.
- Do not expand scope into OCR, camera, or full multimodal inference.
- Do not add a new backend abstraction unless the existing one blocks evaluation.

## Evaluation Questions

Cursor should answer these questions with evidence:

1. Can a quantized Gemma-4-E2B-it artifact be loaded through the current llama.cpp local inference path?
2. Does it stream stable output for short instruction-following prompts?
3. Is first-token latency acceptable for an interactive iPhone chat turn?
4. Is sustained decoding acceptable under mobile thermal and memory constraints?
5. Is Japanese short-form response quality good enough for local fallback?
6. Is it useful for PREXUS control-plane tasks such as summarization and routing support?
7. If llama.cpp is not viable, is the blocker model-format, runtime, performance, or app-integration related?

## Required Measurements

Record these metrics for the first successful device/simulator run where possible:

| Metric | Required detail |
|---|---|
| Model artifact | Exact filename, quantization, source URL, local path pattern excluding user-specific paths |
| Runtime path | llama.cpp, adapter class, and app build configuration used |
| Device | Simulator or physical device; iPhone model if physical |
| Cold load time | Time from load request to model-ready state |
| First-token latency | Time from prompt submit to first generated token |
| Decode throughput | Tokens/sec for a short prompt and a medium prompt |
| Peak memory | Approximate app/process peak memory during load and decode |
| Thermal notes | Any observed throttling, heat, or simulator/device limitations |
| Japanese quality | Short qualitative notes over fixed prompts |
| Failure mode | If blocked, exact failure class and log excerpt |

Simulator-only results are acceptable for initial plumbing, but final model viability requires physical A17 Pro+ evidence.

## Prompt Set

Use compact prompts. Avoid benchmarking with long creative prompts first.

### Japanese fallback chat

```text
あなたはPREXUSのローカル補助モデルです。短く自然な日本語で答えてください。
質問: 明日の予定を整理する時、最初に何を確認すべきですか？
```

### Routing support

```text
Classify the user intent as one of: chat, summarize, memory_write, tool_request, cloud_needed.
User: この長いメモを3点に要約して、あとで見返せるようにして
Return only JSON.
```

### Context compression

```text
Compress the following context into 3 bullet points. Preserve decisions and open questions. Do not add facts.
Context: User prefers local-first processing. Cloud escalation is allowed only when local confidence is low. The next task is model evaluation.
```

## Acceptance Criteria For Cursor PR

A first PR is acceptable if it provides one of the following:

### Success path

- Gemma-4-E2B-it or a clearly identified quantized derivative loads through the existing local inference path.
- At least one streaming generation succeeds.
- Basic metrics are documented.
- No model binary is committed.
- Existing tests still pass, or any unavailable test environment is explicitly documented.

### Blocked path

- The PR documents why Gemma-4-E2B-it cannot currently run through the existing path.
- The blocker is classified as artifact availability, model format, runtime support, memory, build integration, or another concrete category.
- The PR does not introduce speculative backend rewrites.
- A next-step recommendation is recorded.

## Cursor Task

Implement the first Gemma-4-E2B-it evaluation slice.

### Scope

1. Use the existing P1-1 local inference architecture as the primary path.
2. Add only lightweight evaluation hooks, diagnostics, or documentation needed to run and record the experiment.
3. Keep model artifacts out of git.
4. Preserve local-first and privacy-preserving defaults.
5. If llama.cpp cannot run the model, document the blocker and recommend whether LiteRT-LM should become a separate planned backend evaluation.

### Deliverables

- Update this document with results or a blocker report.
- Add minimal runtime diagnostics only if needed for measurement.
- Update any local model setup notes if the artifact path or expected filename pattern becomes known.
- Open a PR using `.github/pull_request_template.md`.
- Include concrete test plan results in the PR body.

### Suggested PR title

`P1-3: Evaluate Gemma-4-E2B-it local model candidate`

## Review Gate

Codex should not approve a backend switch in this task. Merge readiness should be based on whether the PR improves PREXUS' evidence about Gemma-4-E2B-it without destabilizing the current local inference path.
