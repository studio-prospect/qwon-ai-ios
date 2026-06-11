# Gemma 4 E4B Mobile Evaluation Plan

**Status:** Evaluation planning — docs-only. Not implementation approval. Not a QWON default-model change.

**Last updated:** 2026-06-11 (Phase E4B-3 Wang smoke complete — feasibility pass) (Phase E4B-1 metadata + desktop feasibility recorded)

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

**Phase E4B-1 status (2026-06-11):** **Blocker documented** — artifact metadata + local hashes recorded; desktop load/generate **not successful** on eval host. See [Phase E4B-1 results](#phase-e4b-1-results-2026-06-11).

### Phase E4B-1 results (2026-06-11)

Research/eval-only. No QWON app integration. No default-model change.

#### Hugging Face revision and file inventory

| Field | Value |
| --- | --- |
| **Repository** | [`google/gemma-4-E4B-it-qat-mobile-transformers`](https://huggingface.co/google/gemma-4-E4B-it-qat-mobile-transformers) |
| **Revision (SHA)** | `6637cffd8d4cd55fb1461d280f7299c4998daf63` |
| **Last modified (HF API)** | 2026-06-05T20:32:13Z |
| **Listed license (HF)** | Apache-2.0 — QWON redistribution still requires Legal/Product confirmation |

| Path | Bytes | SHA-256 (local download) |
| --- | ---: | --- |
| `model.safetensors` | 3,525,094,516 (~3.28 GiB) | `391946da2e0bec22288e9fe50a4d31d2401c9570ba3baaf0ba43d644dadeb1d4` |
| `tokenizer.json` | 32,169,626 (~30.7 MiB) | `cc8d3a0ce36466ccc1278bf987df5f71db1719b9ca6b4118264f45cb627bfe0f` |
| `tokenizer_config.json` | 2,095 | `68e2ea668d2b18a3c9b2868cccc1911e3c3b432c8f786557b17f164b346d9667` |
| `config.json` | 6,305 | `c4847fd621d80f160945b62f4a2d9413fc82b81f17955b49ae32ea9feb00c5c6` |
| `chat_template.jinja` | 17,336 | `2f1b4d75d067bae3fe44e676721c7f077d243bc007156cb9c2f8b5836613d082` |
| `processor_config.json` | 1,689 | `32bdf45d2ad4cc29a0822ddd157a182de76644f0419a6228d151495256e9813c` |
| `preprocessor_config.json` | 511 | `ea2ae257e901064abdd98dceb19f2b0da06af600bed15e0f99f5c85c37ee9d78` |
| `generation_config.json` | 209 | `fb53f4c64e58896a63472e8eb304397db4a39453e1da0f5d57625ec5a8c1050e` |
| `README.md` | 28,470 | `5cfed04d82b65e9eaa671593f6e3a0925eebb56795a0e876234147f9e4288bcc` |
| `.gitattributes` | 1,570 | `34448b82c17d60fec9b65b1f093c115ddbaadc04beb1b0140b6bfed2e012a930` |

**Repo total (top-level artifacts):** ~**3.56 GB** (`model.safetensors` dominates).

**Artifact schema notes (from `config.json` + model card):**

- `model_type`: **`gemma4`** (multimodal — text / image / audio towers in config).
- Mobile QAT variant: model card labels format **mobile-optimized (wNa8o8)** — custom schema for mobile hardware efficiency (2-bit decode layers, optimized KV cache, static activations).
- `quantization_config.quant_method`: **`gemma`** with per-module `module_quant_configs` (10 patterns) and 7 `modules_to_not_convert` entries (vision/audio towers, embeddings, etc.).

#### Local ops paths (gitignored — not in git)

| Path | Purpose |
| --- | --- |
| `models/prexus-eval-gemma4-e4b-mobile-transformers/` | Full HF snapshot at revision `6637cff…` |
| `.eval-logs/gemma4-e4b-mobile-e4b1-manifest.json` | Local SHA-256 manifest (ops only) |
| `.eval-venv/gemma4-e4b/` | Isolated Python 3.12 venv for desktop probe |

Download command (ops): `huggingface_hub.snapshot_download` pinned to revision `6637cffd8d4cd55fb1461d280f7299c4998daf63`.

#### Desktop eval host

| Field | Value |
| --- | --- |
| **OS** | macOS 15.7.7 (Build 24G720) |
| **Arch** | **x86_64** |
| **RAM** | 32 GiB |
| **Python** | 3.12 (venv) |
| **transformers** | 5.11.0 |
| **torch (installed max on host)** | 2.2.2 — **PyPI has no torch ≥ 2.4 wheel for this x86_64 macOS host** |
| **MPS** | Available (`True`) but unused — Transformers disables PyTorch backend below 2.4 |

Upstream README requires: `pip install -U transformers torch accelerate` and `AutoModelForMultimodalLM.from_pretrained(...)` ([model README](https://huggingface.co/google/gemma-4-E4B-it-qat-mobile-transformers/blob/main/README.md)).

#### Runtime probe results

| Step | Result | Notes |
| --- | --- | --- |
| `AutoConfig.from_pretrained` | **Pass** | `model_type=gemma4` |
| `AutoTokenizer.from_pretrained` | **Pass** | Loads from local snapshot |
| `AutoProcessor.from_pretrained` | **Fail** | `ModuleNotFoundError: Could not import module 'Gemma4Processor'` — Transformers reports PyTorch unavailable (requires torch ≥ 2.4) |
| `AutoModelForMultimodalLM.from_pretrained` | **Fail** | `ImportError`: PyTorch library not found in Transformers backend (same torch ≥ 2.4 gate) |
| `model.generate` (text) | **Not run** | Blocked by model load failure |

Transformers log on this host: `[transformers] Disabling PyTorch because PyTorch >= 2.4 is required but found 2.2.2`.

#### Blocker classification

| Class | Status | Detail |
| --- | --- | --- |
| **dependency** | **Primary blocker** | `transformers` 5.11 + Gemma 4 classes require **torch ≥ 2.4**; eval host (x86_64 macOS) capped at **torch 2.2.2** on PyPI — desktop load/generate could not proceed |
| **artifact schema** | Observed, not blocking alone | Single **3.28 GiB** `model.safetensors`; **wNa8o8** mobile QAT / `quant_method: gemma` — requires current Transformers Gemma4 code path |
| **runtime support** | Resolved in E4B-2 | Exact mobile-transformers Safetensors has **no direct iOS path**; see [Phase E4B-2](#phase-e4b-2--runtime-path-decision-2026-06-11) |
| **memory** | Not measured | Load did not reach weight materialization |
| **model behavior** | Not measured | No generation run |

#### Phase E4B-1 exit verdict

**Concrete blocker documented** on x86_64 eval host. Desktop Transformers load/generate remains **inconclusive** until retried on **torch ≥ 2.4** — this does **not** block the E4B-2 iOS runtime decision because Transformers is a desktop research path only.

**Unchanged:** QWON default model remains Qwen GGUF; `prexus-local-mvp.gguf` unchanged; no M3 / Build `4` / TestFlight scope.

### Phase E4B-2 — Runtime path decision (2026-06-11)

Research/eval-only. Official/upstream evidence review — no app integration.

#### Decision question

Does the **exact** [`google/gemma-4-E4B-it-qat-mobile-transformers`](https://huggingface.co/google/gemma-4-E4B-it-qat-mobile-transformers) Safetensors artifact (~3.28 GiB, **wNa8o8** mobile QAT) have a realistic **iOS** runtime path for QWON?

#### Decision summary

| Question | Answer |
| --- | --- |
| **Exact mobile-transformers Safetensors on iOS?** | **No** — no official upstream iOS runtime loads this artifact directly |
| **Gemma 4 E4B on iOS at all?** | **Yes (alternate artifact)** — official path is **LiteRT-LM + `.litertlm`** from [`litert-community/gemma-4-E4B-it-litert-lm`](https://huggingface.co/litert-community/gemma-4-E4B-it-litert-lm) |
| **E4B-3 isolated iOS eval?** | **Proceed** — reuse PREXUS LiteRT eval lane pattern; **not** the mobile-transformers Safetensors file |

#### Artifact map (do not conflate)

Google publishes **separate** QAT packaging for the same E4B instruction-tuned model family:

| HF repo | Format | Primary upstream runtime | iOS path? |
| --- | --- | --- | --- |
| [`google/gemma-4-E4B-it-qat-mobile-transformers`](https://huggingface.co/google/gemma-4-E4B-it-qat-mobile-transformers) | Single `model.safetensors` (~3.28 GiB), **wNa8o8** | **Transformers** (`AutoModelForMultimodalLM`) — desktop / Python | **No** |
| [`litert-community/gemma-4-E4B-it-litert-lm`](https://huggingface.co/litert-community/gemma-4-E4B-it-litert-lm) | `gemma-4-E4B-it.litertlm` (~3.66 GiB) | **LiteRT-LM** Swift API (iOS / Android / desktop) | **Yes** (official) |
| [`google/gemma-4-E4B-it`](https://huggingface.co/google/gemma-4-E4B-it) | Base bfloat16 / other QAT variants | Conversion source for `litert-torch export_hf` | Indirect |

[QAT blog](https://blog.google/innovation-and-ai/technology/developers-tools/quantization-aware-training-gemma-4/) lists mobile weights on Hugging Face and routes **on-device deployment** to **LiteRT-LM**, while the **mobile-transformers** repo documents **Transformers** usage only.

#### Runtime path matrix

| Candidate path | Verdict | Primary evidence | Blocker / notes |
| --- | --- | --- | --- |
| **Transformers + exact mobile-transformers artifact** | **Rejected (iOS)** | [Model README](https://huggingface.co/google/gemma-4-E4B-it-qat-mobile-transformers/blob/main/README.md) — `pip install transformers torch`; `AutoModelForMultimodalLM` | Python/desktop only; not an iOS embedding path. E4B-1 desktop probe **inconclusive** (torch ≥ 2.4 host needed) — orthogonal to iOS decision |
| **LiteRT-LM + exact mobile-transformers Safetensors** | **Rejected** | [LiteRT-LM Gemma 4 models](https://ai.google.dev/edge/litert-lm/models/gemma-4) — prebuilt `.litertlm` from `litert-community/*`; [Deploy from Safetensors](https://ai.google.dev/edge/litert-lm/models/gemma-4) uses `litert-torch export_hf` from **base** `google/gemma-4-E2B-it` / `google/gemma-4-E4B-it`, not mobile-transformers wNa8o8 | No documented conversion from `qat-mobile-transformers` → `.litertlm` |
| **LiteRT-LM + `litert-community/gemma-4-E4B-it-litert-lm`** | **Selected for E4B-3** | [LiteRT-LM Gemma 4 — E4B 3.65 GB](https://ai.google.dev/edge/litert-lm/models/gemma-4); [HF litert-community card](https://huggingface.co/litert-community/gemma-4-E4B-it-litert-lm); [LiteRT-LM Swift API](https://ai.google.dev/edge/litert-lm/swift); [Google Developers Blog](https://developers.googleblog.com/blazing-fast-on-device-genai-with-litert-lm/) — iPhone 17 Pro GPU benchmarks for E4B | **Different artifact** than E4B-1 source; PREXUS E2B `.litertlm` feasibility already proven on Wang — see [LiteRT-LM evaluation plan](./litert_lm_evaluation_plan.md) |
| **Core ML (Apple / official tooling)** | **Rejected (exact artifact)** | No Apple/Google doc linking `qat-mobile-transformers` → Core ML. [Optimum ExecuTorch](https://docs.pytorch.org/executorch/stable/llm/export-llm-optimum.html) supports `--recipe coreml` for generic HF export, not this wNa8o8 schema | Community [CoreML-LLM](https://github.com/john-rocky/CoreML-LLM) converts **base** Gemma 4 E4B — separate research fork, not this Safetensors artifact |
| **MLX / MLX Swift** | **Rejected (exact artifact)** | [QAT blog](https://blog.google/innovation-and-ai/technology/developers-tools/quantization-aware-training-gemma-4/) mentions MLX for Q4_0 / general checkpoints, not `qat-mobile-transformers`. [ExecuTorch MLX issue #18928](https://github.com/pytorch/executorch/issues/18928) validated **`google/gemma-4-E2B-it` only** | No official wNa8o8 mobile-transformers iOS path; E4B MLX coverage unvalidated |
| **ExecuTorch** | **Rejected (exact artifact)** | [ExecuTorch PR #18695](https://github.com/pytorch/executorch/pull/18695) — native export for `google/gemma-4-E2B` / `google/gemma-4-E4B` base checkpoints; [Optimum ExecuTorch](https://docs.pytorch.org/executorch/stable/llm/export-llm-optimum.html) generic Gemma support | Export targets **base** HF repos, not `qat-mobile-transformers`; conversion of wNa8o8 schema **unproven**; PREXUS has no ExecuTorch integration |

#### LiteRT-LM E4B artifact inventory (official iOS path)

| Field | Value |
| --- | --- |
| **HF repo** | [`litert-community/gemma-4-E4B-it-litert-lm`](https://huggingface.co/litert-community/gemma-4-E4B-it-litert-lm) |
| **iOS artifact** | `gemma-4-E4B-it.litertlm` — **3,659,530,240 bytes** (~3.41 GiB) per HF files API (2026-06-11) |
| **Web variant** | `gemma-4-E4B-it-web.litertlm` (~2.97 GiB) — web-optimized; **not** the iOS eval target |
| **Official model size** | **3.65 GB** per [LiteRT-LM Gemma 4 docs](https://ai.google.dev/edge/litert-lm/models/gemma-4) |
| **iOS benchmarks (Google-published)** | iPhone 17 Pro GPU: prefill 1189 tk/s, decode 25 tk/s, TTFT 0.9 s, peak CPU memory 3380 MB |

#### Phase E4B-2 exit verdict

**Exact `google/gemma-4-E4B-it-qat-mobile-transformers` Safetensors: no realistic direct iOS runtime path.**

**Selected next step:** isolated iOS eval (Phase E4B-3) using **`litert-community/gemma-4-E4B-it-litert-lm` → `gemma-4-E4B-it.litertlm`**, extending the existing PREXUS LiteRT eval lane — **not** shipping or bundling the mobile-transformers Safetensors artifact.

**Unchanged:** QWON default model, M3 closure, Build `4` / TestFlight / public release gates.

### Phase E4B-3 — Isolated iOS eval only

**Prerequisite:** Phase E4B-2 **selected LiteRT-LM + `.litertlm`** (alternate official artifact — not mobile-transformers Safetensors).

Constraints:

- Use an isolated eval app/target or compile-gated path (extend `PREXUSLiteRTEval` / `PREXUS_LITERT_LM_EVAL=1` pattern — see [LiteRT-LM evaluation plan](./litert_lm_evaluation_plan.md)).
- Artifact: **`litert-community/gemma-4-E4B-it-litert-lm` → `gemma-4-E4B-it.litertlm`** — gitignored ops path (e.g. `models/prexus-eval-gemma4-e4b.litertlm`).
- **Do not** load `google/gemma-4-E4B-it-qat-mobile-transformers` Safetensors on device.
- Do not change QWON production default.
- Do not expose user-facing TestFlight UI.
- Do not upload TestFlight.
- Keep Wang as primary target; Matisse expected to be unsupported unless proven otherwise (E2B precedent).

#### E4B-3 implementation (2026-06-11)

Isolated eval lane extended — **no QWON production changes**.

| Item | Value |
| --- | --- |
| Fetch script | `./tools/scripts/fetch_litert_lm_e4b_eval_model.sh` → `models/prexus-eval-gemma4-e4b.litertlm` (gitignored) |
| Device workflow | `./tools/scripts/eval_litert_lm_e4b_on_device.sh "Wang"` |
| Eval app | `PREXUSLiteRTEval` — E4B filename via launch env `PREXUS_LITERT_EVAL_MODEL_FILENAME=prexus-eval-gemma4-e4b.litertlm` |
| Prompts | E4B [fixed prompt set](#fixed-prompt-set) — Japanese short, strict routing JSON, control-plane summary |
| Log output | `.eval-logs/litert-e4b-device-eval-Wang.log` (gitignored) |

**Artifact fetched (Mac, 2026-06-11):**

| Field | Value |
| --- | --- |
| Source | [`litert-community/gemma-4-E4B-it-litert-lm`](https://huggingface.co/litert-community/gemma-4-E4B-it-litert-lm) → `gemma-4-E4B-it.litertlm` |
| Local path | `models/prexus-eval-gemma4-e4b.litertlm` |
| Size | **3,659,530,240 bytes** (~3.41 GiB) |
| SHA-256 | `0b2a8980ce155fd97673d8e820b4d29d9c7d99b8fa6806f425d969b145bd52e0` |

#### E4B-3 Wang device results (2026-06-11)

Captured via `PREXUSLiteRTEval` → `Documents/prexus-litert-device-eval.log` → `./tools/scripts/eval_litert_lm_e4b_on_device.sh "Wang"` → `.eval-logs/litert-e4b-device-eval-Wang.log` (gitignored).

| Metric | E4B (Wang) | E2B Wang baseline ([LiteRT plan](./litert_lm_evaluation_plan.md)) |
| --- | --- | --- |
| Device | iPhone 17 (Wang), `iPhone18,3`, A19-class | same |
| LiteRT-LM | v0.12.0 (local shallow vendor) | same |
| Model on device | `prexus-eval-gemma4-e4b.litertlm` (**3.41 GiB**) | `prexus-eval-gemma4-e2b.litertlm` (**2.41 GiB**) |
| Backend | `.gpu` / Metal | same |
| Cold load | **11,363 ms** | **6952 ms** |
| JA first-token | **2061 ms** | **754 ms** |
| JA total / decode | **3556 ms**, **~0.3 t/s** | **1091 ms**, **~0.9 t/s** |
| Memory footprint proxy | **546 MB** (`phys_footprint` post-init; underestimates peak model RAM) | not recorded |
| Japanese smoke | **Coherent** — まず、**「何のための予定か」**… | Coherent |
| Routing JSON | **Extractable JSON (fenced); strict JSON contract not met** — response wrapped in ` ```json ` fences; keys `intent`, `confidence`, `needs_cloud` parseable after strip | Valid compact JSON (no fences) |
| Control-plane summary | **Pass** — 3 bullets, no added facts | not in E2B smoke |
| App stability | **Pass** (`eval-complete`) | Pass |
| Thermal notes | Not recorded (bounded ~18 s session) | not recorded |
| Google-published E4B ref | TTFT 0.9 s, decode 25 tk/s, peak 3380 MB (iPhone 17 Pro GPU) | — |

**Wang conclusion (E4B):** LiteRT-LM + Gemma 4 E4B `.litertlm` **passes isolated iOS runtime feasibility** on A19-class Wang — cold load, Japanese answer, and control-plane summary succeed. **Control-plane JSON reliability:** routing output is **extractable but fenced**; does **not** meet the strict JSON-only contract (contrast E2B Wang baseline). Trade-offs vs E2B: **~1.6× cold load** (11.4 s vs 7.0 s), **~1.4× artifact size** (3.41 vs 2.41 GiB), **slower first-token and decode** on this smoke path. **Do not adopt as default**; QWON production remains Qwen MVP.

**Phase E4B-3 exit verdict:** Wang load/generation **succeeds** (runtime feasibility pass). No iOS runtime blocker for official `.litertlm` path. Strict routing JSON contract **not** demonstrated on this smoke.

## Acceptance Criteria for the First PR

A first PR is mergeable if it is **docs-only** and provides:

- This evaluation plan or equivalent.
- Source links to the model page and official/primary references used.
- Clear non-goals: no default switch, no Build `4`, no TestFlight, no M3 reopen.
- A next-step task for Cursor that starts with runtime feasibility rather than app integration.
- `git diff --check` passes.

## Cursor Task After E4B-3

E4B-3 Wang smoke **complete** — see [device results](#e4b-3-wang-device-results-2026-06-11).

Optional follow-ups (not blocking):

1. Matisse blocked repro (expected — E2B precedent on A12).
2. Bounded thermal/memory session (5–10 min) for E4B vs E2B comparison.
3. E4B-1 desktop Transformers retry on torch ≥ 2.4 host (behavior baseline only).
4. Adoption review if product wants E4B as a second local backend candidate.

## Review Gate

Codex should reject any PR that:

- Switches QWON's default local model.
- Adds Gemma artifacts to git.
- Opens Build `4` / TestFlight / public-release scope.
- Treats the mobile Transformers artifact as a proven iOS runtime path without evidence.
- Removes the Qwen alpha fallback or M2 guided placement path.
