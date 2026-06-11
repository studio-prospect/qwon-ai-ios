# Gemma 4 E4B Mobile Evaluation Plan

**Status:** Evaluation planning — docs-only. Not implementation approval. Not a QWON default-model change.

**Last updated:** 2026-06-11

Related: [Gemma-4-E2B-it evaluation](./gemma4_e2b_evaluation_plan.md) · [LiteRT-LM evaluation](./litert_lm_evaluation_plan.md) · [Local LLM notes](./local_llm_notes.md) · [M3 model download UX plan](../product/qwon_model_download_gguf_ux_plan.md)

## Purpose

This document scopes a safe evaluation path for **Gemma 4 E4B Mobile**:

- Model repository: [`google/gemma-4-E4B-it-qat-mobile-transformers`](https://huggingface.co/google/gemma-4-E4B-it-qat-mobile-transformers)
- Initial role in QWON: **research/eval candidate only**
- Target question: whether the mobile-optimized Gemma 4 E4B artifact is practical for QWON's future local runtime lane on high-end iPhones.

The first step is **runtime feasibility**, not app integration. This model should not be treated as a drop-in replacement for the current Qwen GGUF file.

## Current Decision

| Item | Decision |
| --- | --- |
| Candidate | `google/gemma-4-E4B-it-qat-mobile-transformers` |
| Status | Evaluation candidate, planning only |
| QWON default model? | **No** |
| TestFlight / Build `4` approval? | **No** |
| Production M3 downloader reopen? | **No** |
| First evaluation lane | Isolated research / eval-only |
| First required answer | Which runtime can actually execute this artifact on iPhone? |
| Asset policy | Do not commit model weights, safetensors, converted artifacts, logs, screenshots, or generated binaries |

## Source Snapshot

External source snapshot as of **2026-06-11**:

| Topic | Source-backed observation |
| --- | --- |
| Hugging Face model page | [`google/gemma-4-E4B-it-qat-mobile-transformers`](https://huggingface.co/google/gemma-4-E4B-it-qat-mobile-transformers) |
| Listed framework / format | Hugging Face tags include **Transformers** and **Safetensors** |
| Listed license | Hugging Face shows **Apache-2.0**; QWON redistribution still requires Legal/Product confirmation before any product distribution |
| Repository size | Hugging Face files listing shows approx **3.56 GB** repo size and approx **3.53 GB** `model.safetensors` |
| Mobile format claim | Model card describes **mobile-optimized (wNa8o8)** as a custom schema for mobile hardware efficiency, available for Gemma 4 E2B and E4B |
| Model scale | Model card lists E4B as **4.5B effective** parameters and **8B with embeddings** |
| Modalities | Model card lists E4B support for **text, image, and audio** |
| Context | Model card lists E2B/E4B context length as **128K tokens** |

These notes are source traceability for planning. They are not evidence that QWON can execute the artifact on-device.

## Why This Is Not a Drop-in Qwen Replacement

The current QWON alpha line is based on:

- `prexus-local-mvp.gguf`
- Qwen2.5-0.5B-Instruct Q4_K_M
- llama.cpp / GGUF path
- M2 **Place GGUF via Mac** as the tester-visible model placement path

Gemma 4 E4B Mobile differs materially:

| Dimension | Current Qwen alpha | Gemma 4 E4B Mobile candidate |
| --- | --- | --- |
| Artifact style | GGUF | Transformers / Safetensors mobile-optimized artifact |
| Approx size | ~398 MB hosted object | ~3.5 GB repository / safetensors file |
| Runtime path | llama.cpp | Unknown for iOS; must be proven |
| Risk | Known alpha behavior | Memory/runtime/package-size unknown |
| Initial scope | Stable TestFlight `0.1.0 (3)` | Research only |

Therefore, the first evaluation must answer **runtime feasibility** before any UI, downloader, TestFlight, or model-routing work.

## Non-goals

Do **not** do any of the following in the first evaluation slice:

- Do not switch QWON's default local model.
- Do not replace `prexus-local-mvp.gguf`.
- Do not rename the Qwen alpha model file contract.
- Do not reopen M3 downloader or make Gemma downloadable in-app.
- Do not approve Build `4`, TestFlight upload, tag, or version bump.
- Do not add Gemma weights, safetensors, converted artifacts, or large generated files to git.
- Do not add user-facing UI until runtime feasibility is proven.
- Do not claim App Store / public-release readiness.
- Do not rely on simulator-only evidence for viability.

## Evaluation Questions

### Runtime feasibility

1. Can the artifact be loaded on macOS with the current upstream Transformers path?
2. Is there an iOS-compatible runtime path for this **mobile-optimized wNa8o8 / Safetensors** artifact?
3. Is LiteRT-LM / Google AI Edge a viable route for this exact artifact, or does it require a different packaged model?
4. Is Core ML / MLX / ExecuTorch conversion realistic for this artifact size and schema?
5. If conversion is required, what are the exact conversion inputs, output sizes, and runtime constraints?

### Device viability

1. Can Wang-class hardware load the artifact without memory pressure termination?
2. What are cold load time, first-token latency, decode throughput, and peak memory?
3. Does the model remain thermally acceptable for short local tasks?
4. Is the model useful for text-only control-plane tasks despite multimodal capability?
5. Is Matisse/A12 explicitly unsupported or merely untested?

### Quality / control-plane behavior

Use the same compact evaluation lens as prior Qwen / Gemma / LiteRT work:

1. Japanese short response quality.
2. Strict JSON for routing/control-plane prompts.
3. Summarization / task extraction.
4. Deterministic behavior with thinking disabled, if the selected runtime exposes that control.
5. Failure behavior and fallback clarity.

## Required Metrics

Record at minimum:

| Metric | Required detail |
| --- | --- |
| Artifact identity | Exact model repo, revision/commit if available, file names, byte sizes, hash when downloaded |
| Runtime | Transformers / LiteRT-LM / Core ML / MLX / other; exact version and build path |
| Device | Mac host, iPhone model, iOS version, memory class |
| Load | Cold load time and failure class if load fails |
| Generation | First-token latency, total latency, decode tokens/sec |
| Memory | Approx peak RSS / app memory / OS pressure notes |
| Thermal | Qualitative thermal notes for a short run; longer run only if initial load succeeds |
| Quality | Fixed prompt output notes for Japanese, strict JSON, summarization |
| Packaging | On-device artifact size and whether it can fit current QWON storage assumptions |
| Legal / license | Source license notes and unresolved redistribution questions |

## Fixed Prompt Set

Keep prompts short. Avoid multimodal prompts until text-only runtime viability is proven.

### Japanese short response

```text
あなたはQWONのローカル補助モデルです。短く自然な日本語で答えてください。
質問: 明日の予定を整理する時、最初に何を確認すべきですか？
```

### Strict routing JSON

```text
Classify the user intent as one of: chat, summarize, memory_write, tool_request, cloud_needed.
User: この長いメモを3点に要約して、あとで見返せるようにして
Return only valid JSON with keys: intent, confidence, needs_cloud.
```

### Control-plane summary

```text
Summarize into exactly three bullets. Preserve decisions and open questions. Do not add facts.
Context: QWON prefers local-first processing. Cloud escalation is allowed only when local confidence is low. The next task is model evaluation.
```

## Suggested Evaluation Phases

### Phase E4B-0 — Docs-only planning

Current document. No downloads or code changes required.

Acceptance:

- Evaluation scope is clear.
- Source links are recorded.
- Non-goals protect QWON alpha / TestFlight stability.

### Phase E4B-1 — Desktop metadata and baseline load check

Research/eval-only. No app integration.

Tasks:

1. Download metadata and, if approved locally, the model artifact outside git.
2. Record exact revision, file sizes, and hashes in a gitignored ops folder or docs summary without committing binaries.
3. Run a minimal macOS Transformers load/generate test if hardware permits.
4. Classify blockers: dependency, memory, artifact schema, runtime, or model behavior.

Exit:

- Either one text generation succeeds on desktop, or a concrete blocker is documented.

### Phase E4B-2 — Runtime path decision

Before iOS work, decide the feasible runtime candidate:

| Candidate path | Question |
| --- | --- |
| Transformers only | Useful for desktop baseline but not enough for QWON iOS integration |
| LiteRT-LM / Google AI Edge | Does this exact mobile artifact map to a LiteRT-supported package? |
| Core ML conversion | Is conversion available and practical for 3.5GB-class artifact? |
| MLX / MLX Swift | Is iPhone deployment realistic, or Mac-only research? |
| ExecuTorch / other | Only if supported by official/upstream docs and worth investigation |

Exit:

- One runtime path is selected for isolated iOS feasibility, or all paths are blocked with evidence.

### Phase E4B-3 — Isolated iOS eval only

Only after Phase E4B-2 identifies an iOS-capable runtime.

Constraints:

- Use an isolated eval app/target or compile-gated path.
- Do not change QWON production default.
- Do not expose user-facing TestFlight UI.
- Do not upload TestFlight.
- Keep Wang as primary target; Matisse expected to be unsupported unless proven otherwise.

Exit:

- Wang load/generation succeeds with metrics, or a concrete iOS blocker is recorded.

## Acceptance Criteria for the First PR

A first PR is mergeable if it is **docs-only** and provides:

- This evaluation plan or equivalent.
- Source links to the model page and official/primary references used.
- Clear non-goals: no default switch, no Build `4`, no TestFlight, no M3 reopen.
- A next-step task for Cursor that starts with runtime feasibility rather than app integration.
- `git diff --check` passes.

## Cursor Task After This Plan

Prepare a follow-up **research/eval-only** PR for **Phase E4B-1**.

Scope:

1. Do not change QWON app code unless a later Codex plan explicitly allows it.
2. Do not commit model artifacts.
3. Create or update a gitignored ops path for local evidence if needed.
4. Collect model metadata: file list, exact sizes, revision, local hash if downloaded.
5. Attempt desktop-only load/generate if dependencies and local hardware allow.
6. Update this document with results or blocker classification.

Suggested PR title:

`docs(research): Record Gemma 4 E4B Mobile metadata and runtime feasibility notes`

## Review Gate

Codex should reject any PR that:

- Switches QWON's default local model.
- Adds Gemma artifacts to git.
- Opens Build `4` / TestFlight / public-release scope.
- Treats the mobile Transformers artifact as a proven iOS runtime path without evidence.
- Removes the Qwen alpha fallback or M2 guided placement path.
