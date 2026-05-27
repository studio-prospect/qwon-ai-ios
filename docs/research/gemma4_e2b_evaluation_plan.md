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

---

## Evaluation Results (2026-05-21)

**Verdict:** Gemma-4-E2B-it **loads and decodes** through the pinned PREXUS llama.cpp path (`vendor/llama.cpp` @ `585080d`), but **coherent instruction-following output was not demonstrated** in this Mac-side pass. **Default model unchanged.** A17 Pro+ device validation is still required before any adoption decision.

### Artifact and runtime

| Item | Value |
| --- | --- |
| Model | `google/gemma-4-E2B-it` |
| Quant / source | Q4_K_M, [bartowski/google_gemma-4-E2B-it-GGUF](https://huggingface.co/bartowski/google_gemma-4-E2B-it-GGUF) |
| Local path pattern | `models/prexus-eval-gemma4-e2b-it.gguf` (gitignored) |
| llama.cpp | `585080d` (same submodule pin as P1-1) |
| PREXUS path | `LlamaCppLocalModelClient` → `PREXUSLlamaBridge` + `llama_chat_apply_template` |
| Mac bench host | MacBook-class, AMD Radeon Pro 560X (4 GiB Metal working-set limit) |

### Throughput (`llama-bench`, Metal, `-r 2`)

| Model | Prompt processing (512 tok) | Token generation (64 tok) | File size |
| --- | ---: | ---: | ---: |
| Qwen2.5-0.5B Q4_K_M (default MVP) | 266.9 ± 11.6 t/s | 5.3 ± 1.5 t/s | 374 MiB |
| Gemma-4-E2B-it Q4_K_M (candidate) | 90.2 ± 2.1 t/s | 2.4 ± 1.0 t/s | 3.21 GiB |

Gemma is **~3.4× slower** on prompt processing and **~2.2× slower** on decode vs the current default on the same Mac host.

### Latency and memory (`llama-cli -st`, first Japanese prompt)

| Metric | Qwen 0.5B | Gemma-4-E2B Q4_K_M |
| --- | ---: | ---: |
| Wall time (cold load + 48 tok gen) | ~5 s | ~23 s |
| Prompt throughput (cli) | ~168 t/s | ~35–40 t/s |
| Decode throughput (cli) | ~8.4 t/s | ~3.4–3.7 t/s |
| Peak RSS (`time -l`) | ~550 MiB | ~4.6 GiB |
| Peak memory footprint | ~108 MiB | ~1.0 GiB |

On iPhone 8 GiB class hardware, a **3.2 GiB** weight file plus KV/context overhead is **feasible but tight**; sustained decode at ~2–4 t/s implies **elevated thermal and battery risk** for interactive chat.

### Quality notes (fixed prompt set)

**Japanese fallback chat** — Qwen returned a coherent one-sentence Japanese answer. Gemma returned **multilingual token soup** (degenerate text) across multiple attempts:

- raw `-p` prompt
- `-sys` + `--reasoning off`
- `--chat-template gemma`
- `--chat-template-kwargs '{"enable_thinking":false}'`

**Routing JSON** — Gemma `llama-cli` run **aborted** during chat parsing (`common_chat_peg_parse` / `<|channel>` token in model output). Not evaluated as reliable for deterministic JSON control-plane tasks in this pass.

**Context compression prompt** — Not run to completion after routing crash; deferred to A17 Pro device pass with `PREXUS_LOCAL_INFERENCE_BENCHMARK=1`.

### Assessment against PREXUS criteria

| Criterion | Result |
| --- | --- |
| GGUF loads via llama.cpp | **Pass** (architecture `gemma4` recognized) |
| Stable streaming output | **Fail** on Mac and iPhone 17 (degenerate / 2-token output) |
| First-token / decode latency | **Marginal** (2–4 t/s decode, slow cold start) |
| Peak memory | **High** (~4.6 GiB RSS on Mac; tight on phone) |
| Thermal / battery risk | **High** for interactive use at this size |
| Japanese short-form quality | **Fail** on Mac and iPhone 17 (`？` / token soup) |
| Local fallback usefulness | **Not demonstrated** |
| Privacy-preserving local mode | **Compatible in principle** (on-device GGUF, no cloud) |
| Default model switch | **No** |

### Blocker classification

Primary blocker for adoption: **runtime output quality** on the current llama.cpp + bartowski Q4_K_M artifact (Mac validation). Secondary concerns: **memory footprint** and **decode speed**.

This is **not** a model-format load failure. LiteRT-LM is **not** integrated; if A17 Pro device validation reproduces garbled output or OOM, record a **separate LiteRT-LM backend evaluation** (docs only — no backend switch in this PR).

### PREXUS diagnostics added

Set `PREXUS_LOCAL_INFERENCE_BENCHMARK=1` in the Xcode scheme to log:

- `cold_load_ms`, `first_token_ms`, `total_gen_ms`, `generatedTokenCount`, `decode_tps`

from `PREXUSLlamaBridge` / `LlamaCppInferenceEngine` during on-device runs.

### Next steps

1. **A17 Pro+ device run** with `PREXUS_LOCAL_MODEL_PATH` → `prexus-eval-gemma4-e2b-it.gguf` and benchmark env enabled.
2. If device output is still degenerate, try **newer llama.cpp submodule** (Gemma 4 template/EOS fixes) or **alternate GGUF publisher** (e.g. ggml-org / unsloth builds) — evaluation only.
3. If llama.cpp remains unstable on-device, open a **LiteRT-LM evaluation plan** doc (no runtime switch without explicit approval).
4. Keep **Qwen 0.5B** as default until Gemma passes device quality + latency gates.

### Reproduce (Mac)

```bash
./tools/scripts/fetch_gemma4_e2b_eval_model.sh
cd vendor/llama.cpp
cmake -B build-mac -DCMAKE_BUILD_TYPE=Release -DGGML_METAL=ON
cmake --build build-mac -j --target llama-bench llama-cli
./vendor/llama.cpp/build-mac/bin/llama-bench -m models/prexus-eval-gemma4-e2b-it.gguf -ngl 99 -p 512 -n 64 -r 2 -o md
./tools/scripts/benchmark_local_gguf.sh models/prexus-eval-gemma4-e2b-it.gguf
```

### Device evaluation (A17 Pro+, Wang / iPhone 17)

**Status (2026-05-27):** Device smoke test completed on **Wang (iPhone 17 / `iPhone18,3`)**. Gemma loads via PREXUS bridge but **generation quality remains unusable** (2-token output `？`). Default model unchanged.

```bash
git submodule update --init vendor/llama.cpp
./tools/scripts/build_llama_xcframework.sh
ruby tools/scripts/generate_xcodeproj.rb
./tools/scripts/fetch_gemma4_e2b_eval_model.sh
./tools/scripts/eval_gemma4_on_device.sh "Wang"
```

The eval script:

1. Installs Debug `PREXUS.app` via `devicectl`
2. Copies `prexus-eval-gemma4-e2b-it.gguf` into `Documents/Models/` (does **not** overwrite default MVP filename)
3. Prompts for manual chat turns + log capture

`LocalGGUFModelPlacement` resolves the eval artifact when `prexus-local-mvp.gguf` is absent on device. Debug builds log `[PREXUS][local-inference-benchmark]` metrics to Console without requiring scheme env vars.

Log capture:

```bash
log stream --device --predicate 'eventMessage CONTAINS "local-inference-benchmark"'
```

#### Device results (Wang, iPhone 17, 2026-05-27)

Captured via Debug smoke runner → `Documents/prexus-device-eval.log` → `./tools/scripts/fetch_device_eval_log.sh "Wang"`.

| Metric | Value |
| --- | --- |
| Device | iPhone 17 (Wang), `iPhone18,3`, A19-class |
| Model path on device | `Documents/Models/prexus-local-mvp.gguf` (Gemma Q4_K_M content, eval session) |
| Cold load (`prewarm-ready`) | **8863 ms** |
| Bridge `cold_load_ms` | **8783 ms** |
| First-token latency | **95 ms** (after load; smoke prompt) |
| Total generation | **169 ms**, **2 tokens** |
| Decode throughput | **27.2 t/s** (misleading at 2 tokens) |
| Japanese smoke response | **`？`** (degenerate / unusable) |
| Routing JSON | Not run (smoke test only) |
| App stability | **Pass** (no OOM after single-engine prewarm fix) |
| Thermal / battery | Not instrumented; ~8.9 s cold load + short decode suggests **high cost per turn** at 3.2 GiB |

**Device conclusion:** Gemma-4-E2B-it Q4_K_M **loads on A17 Pro+ hardware** through the existing PREXUS llama.cpp path with acceptable first-token latency **once loaded**, but **output quality is not viable** for local fallback (matches Mac-side garbled-output class). **Do not adopt as default.** Next options: llama.cpp Gemma 4 template/EOS fixes, alternate GGUF build, or separate **LiteRT-LM** evaluation (docs only).

Restore default Qwen on device after eval:

```bash
./tools/scripts/fetch_local_model.sh
PREXUS_LOCAL_MODEL_DEST=prexus-local-mvp.gguf ./tools/scripts/push_local_model_to_device.sh "Wang"
```

#### Manual chat UI (Wang, 2026-05-27 ~18:45 JST)

User executed the eval prompts in the PREXUS chat UI (screenshots `IMG_0895`, `IMG_0896`).

| Prompt | Observed assistant output | Interpretation |
| --- | --- | --- |
| Japanese fallback (`明日の予定を整理する時…`) | Assistant bubble shows duplicated `User:` lines; **no coherent Japanese answer** | Consistent with degenerate Gemma output / prompt echo (smoke log returned `？` only) |
| Routing JSON (`ルーティング JSON 用プロンプト`) | `Embedded local runtime handled … with compact on-device heuristics.` | **llama.cpp primary failed or returned unusable output** → `FallbackLocalModelClient` used `EmbeddedHeuristicLocalModelClient` |

**UI nuance:** The status banner still reads **llama.cpp On-Device Runtime** because `RuntimeExecutionMetadata` uses `FallbackLocalModelClient.descriptor` (primary path). The **message body** is the reliable indicator of which backend actually answered.

**Manual UI conclusion:** Interactive chat under Gemma eval conditions does **not** deliver usable local LLM answers. Routing JSON falls back to embedded heuristics, not structured JSON. This reinforces **no adoption** until Gemma 4 + llama.cpp output quality is fixed.

