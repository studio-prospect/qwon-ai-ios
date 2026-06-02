# LiteRT-LM Evaluation Plan

## Purpose

This document defines the PREXUS evaluation lane for LiteRT-LM / Google AI Edge after the Gemma-4-E2B-it GGUF evaluation showed that Gemma can load through the current llama.cpp path but does not produce usable output.

LiteRT-LM is an evaluation candidate only. It is not the PREXUS production runtime, and it must not replace the current Qwen2.5-0.5B-Instruct Q4_K_M MVP default without a later adoption decision.

**Adoption decision (post-feasibility):** see [LiteRT-LM Adoption Decision Memo](./litert_lm_adoption_decision.md).
**Routing-policy evaluation (post-P1-4b):** see [LiteRT-LM Routing Policy Evaluation](./litert_lm_routing_policy_evaluation.md).

## Current Decision

| Area | Decision |
| --- | --- |
| Production local runtime | Keep the existing llama.cpp path |
| Production local model | Keep Qwen2.5-0.5B-Instruct Q4_K_M as `prexus-local-mvp.gguf` |
| LiteRT-LM role | Backend feasibility evaluation candidate |
| First target | iOS Swift API + Metal path |
| Model target | Gemma 4 E2B / E4B `.litertlm` artifacts if available and distributable |
| Implementation owner | Cursor |
| Planning / review owner | Codex |

## Why Evaluate LiteRT-LM

Official Google AI Edge docs position LiteRT as Google's on-device framework for high-performance ML and GenAI deployment across Android, iOS, web, desktop, and edge devices. The LiteRT GenAI docs describe LiteRT-LM as the orchestration layer for LLM-specific concerns such as session cloning, KV-cache management, prompt caching, and stateful inference.

Official LiteRT-LM docs now expose a Swift API for iOS and macOS with Metal GPU acceleration. The LiteRT-LM repository lists Swift as Early Preview as of v0.12.0, so this path is promising but still requires PREXUS-specific validation before any architecture shift.

Google's May 19, 2026 LiteRT-LM announcement reports Gemma 4 E2B decode performance on iPhone 17 Pro through the iOS Metal path, plus session management, constrained decoding, tool-use, and multimodal support. These claims map well to PREXUS' long-term needs, but they do not prove that LiteRT-LM is a better default for the current MVP.

Sources:

- LiteRT overview: https://ai.google.dev/edge/litert/overview
- LiteRT GenAI deployment overview: https://ai.google.dev/edge/litert/genai/overview
- LiteRT-LM Swift API: https://ai.google.dev/edge/litert-lm/swift
- LiteRT-LM GitHub repository: https://github.com/google-ai-edge/LiteRT-LM
- Google Developers Blog: https://developers.googleblog.com/blazing-fast-on-device-genai-with-litert-lm/

## Non-Goals

- Do not replace `LocalGGUFModelPlacement`.
- Do not switch `prexus-local-mvp.gguf` away from Qwen.
- Do not replace the P1-1 llama.cpp production backend.
- Do not add large model files or generated LiteRT artifacts to git.
- Do not redesign routing, memory, or chat UI as part of this evaluation.
- Do not introduce multimodal runtime work in the first LiteRT-LM slice.
- Do not require Google AI Edge Gallery behavior as a product dependency.

## Evaluation Questions

1. Can PREXUS integrate LiteRT-LM's Swift package in an isolated iOS spike without destabilizing the committed Xcode project?
2. Can an iPhone target load a `.litertlm` model artifact from app Documents or another reviewable non-git model location?
3. Does the iOS Swift API work with Metal on a supported device in a way that can be measured from PREXUS?
4. Does Gemma 4 E2B or E4B produce coherent Japanese short-form answers where the GGUF llama.cpp path failed?
5. Can LiteRT-LM produce deterministic compact JSON for routing/control-plane prompts?
6. What are the cold load, first-token, decode throughput, memory, thermal, and package-size costs?
7. What are the model license, artifact distribution, App Store, and binary-size implications?
8. What runtime abstraction would be required if LiteRT-LM later becomes a second backend?

## Required Measurements

Any implementation PR must include concrete test-plan results for:

- LiteRT-LM version or commit
- Swift package version
- model artifact name, source, quantization, and file size
- device model and OS version
- backend used (`.gpu` / Metal or `.cpu`)
- cold load time
- first-token latency
- decode tokens/sec on at least one short and one medium prompt
- peak memory or best available proxy
- thermal / battery observation for a bounded session
- Japanese short-answer transcript
- routing JSON transcript
- failure mode if a step cannot run

## Acceptance Criteria

### Successful feasibility result

- LiteRT-LM can be integrated in an isolated spike or sample path without changing the production local backend.
- A `.litertlm` model can be loaded on an iPhone target.
- At least one Japanese answer and one routing JSON response are coherent enough to justify deeper evaluation.
- Performance and memory numbers are captured and compared against the existing Qwen MVP baseline and Gemma GGUF evaluation.
- The PR keeps generated artifacts and large model files out of git.

### Valid blocked result

A blocked result is acceptable if the PR documents the blocker precisely. Valid blocker categories:

- Swift package or binary integration issue
- iOS deployment target mismatch
- Metal backend unavailable or unstable
- `.litertlm` model artifact unavailable or not distributable
- model license or redistribution constraint
- memory, thermal, or startup cost too high for PREXUS MVP
- output quality still unusable for Japanese or routing JSON

## Reproducible eval lane (on `main`)

Production **PREXUS** and **Qwen MVP** are unchanged. Evaluation uses a separate iOS app target and bundle id — not wired into `AppLocalModelFactory`.

| Item | Value |
| --- | --- |
| App sources | `app/ios/PREXUSLiteRTEval/` |
| Xcode target | `PREXUSLiteRTEval` — added only when regenerating with `PREXUS_LITERT_LM_EVAL=1` |
| Scheme | `PREXUSLiteRTEval.xcscheme` — generated alongside the eval target (gitignored; recreated by scripts) |
| Bundle id | `jp.studio-prospect.qwon.ios.literteval` |
| Model on device | `Documents/Models/prexus-eval-gemma4-e2b.litertlm` |
| Eval log | `Documents/prexus-litert-device-eval.log` |
| LiteRT-LM package | Shallow vendor at `vendor/LiteRT-LM` (see `vendor_litert_lm.sh`) |

### Xcode project generation

Committed `PREXUS.xcodeproj` stays **without** the LiteRT eval target so clean checkouts can run `PREXUSTests` without resolving LiteRT-LM.

```bash
# Default — production + unit tests only
ruby tools/scripts/generate_xcodeproj.rb

# Adds PREXUSLiteRTEval + LiteRT-LM Swift package (evaluation only)
PREXUS_LITERT_LM_EVAL=1 ruby tools/scripts/generate_xcodeproj.rb
```

Eval scripts call the `PREXUS_LITERT_LM_EVAL=1` variant automatically. To restore a reviewer-clean project after local eval work:

```bash
ruby tools/scripts/generate_xcodeproj.rb
```

### SPM / Git LFS note

Remote Swift Package Manager checkout of `LiteRT-LM` v0.12.0 can fail on Android LFS prebuilts (`remote missing object`). Use the vendor script first:

```bash
./tools/scripts/vendor_litert_lm.sh
PREXUS_LITERT_LM_EVAL=1 ruby tools/scripts/generate_xcodeproj.rb
```

### Device workflow

```bash
./tools/scripts/fetch_litert_lm_eval_model.sh
./tools/scripts/eval_litert_lm_on_device.sh "Wang"
# runs uninstall → install → push → launch → wait → fetch log
# output: .eval-logs/litert-device-eval-Wang.log (gitignored)
```

To re-fetch a log without re-running the full eval:

```bash
./tools/scripts/fetch_litert_device_eval_log.sh "Wang"
```

Pass a device name substring from `xcrun devicectl list devices` (e.g. `Wang`, `Matisse`). **A17 Pro+ recommended** for Gemma 4 E2B `.litertlm`.

Helper scripts (all under `tools/scripts/`):

| Script | Role |
| --- | --- |
| `vendor_litert_lm.sh` | Shallow-clone LiteRT-LM into `vendor/` (LFS smudge skipped) |
| `fetch_litert_lm_eval_model.sh` | Download `models/prexus-eval-gemma4-e2b.litertlm` (gitignored) |
| `install_litert_eval_on_device.sh` | Vendor + regenerate + build + install eval app (**does not launch**) |
| `push_litert_lm_model_to_device.sh` | Copy `.litertlm` into eval app `Documents/Models/` |
| `eval_litert_lm_on_device.sh` | End-to-end: uninstall → install → push → launch → wait → **fetch log** |
| `fetch_litert_device_eval_log.sh` | Pull `prexus-litert-device-eval.log` only (optional re-fetch) |

### Recorded device results (2026-05-30)

#### Matisse (iPhone XS Max, 2026-05-30)

Captured via `PREXUSLiteRTEval` → `Documents/prexus-litert-device-eval.log` → `./tools/scripts/fetch_litert_device_eval_log.sh "Matisse"`.

| Metric | Value |
| --- | --- |
| Device | iPhone XS Max (Matisse), `iPhone11,6`, A12 (below A17 Pro class) |
| LiteRT-LM | v0.12.0 (local shallow vendor) |
| Model on device | `Documents/Models/prexus-eval-gemma4-e2b.litertlm` (2.41 GiB) |
| Backend requested | `.gpu` / Metal |
| Cold load | **Failed** (~13 s after launch) |
| Error | `Failed to create engine` |
| Japanese / routing smoke | Not run (engine did not start) |
| PREXUS production | Unchanged |

**Matisse conclusion:** On **A12 / 4 GiB-class** hardware, Gemma 4 E2B `.litertlm` with Metal does **not** start. This is a valid **blocked** feasibility result for sub–A17 Pro devices; **does not disprove** LiteRT-LM on iPhone 17 / A17 Pro+.

#### Wang (iPhone 17, 2026-05-30)

Captured via `PREXUSLiteRTEval` → `Documents/prexus-litert-device-eval.log` → `./tools/scripts/fetch_litert_device_eval_log.sh "Wang"`.

| Metric | Value |
| --- | --- |
| Device | iPhone 17 (Wang), `iPhone18,3`, A19-class |
| LiteRT-LM | v0.12.0 (local shallow vendor) |
| Model on device | `Documents/Models/prexus-eval-gemma4-e2b.litertlm` (2.41 GiB) |
| Backend | `.gpu` / Metal |
| Cold load | **6952 ms** |
| JA first-token | **754 ms** |
| JA total / decode | **1091 ms**, **~0.9 t/s** (short smoke; 1 sentence) |
| Japanese smoke response | **Coherent** — 固定の予定や締め切りを確認… |
| Routing JSON | **Valid compact JSON** (`intent`, `confidence`, `needs_cloud`) |
| App stability | **Pass** (`eval-complete`) |
| PREXUS production | Unchanged |

**Wang conclusion:** LiteRT-LM + Gemma 4 E2B `.litertlm` **passes feasibility** on A17 Pro-class hardware where the GGUF llama.cpp path produced unusable output (`？`). Trade-offs: **~7 s cold load**, **~2.4 GiB** artifact, separate backend integration still required. **Do not adopt as default** without adoption review; continue Qwen MVP for production.

### Implications

- LiteRT-LM should move from "can it work?" to "should PREXUS adopt a second local backend?" evaluation.
- A17/A19-class devices are viable targets for the next prototype lane.
- A12-class devices should not be assumed supported for LiteRT-LM Gemma 4 E2B.
- Any adoption work must keep the current Qwen MVP fallback available.
- The next decision should compare LiteRT-LM against Qwen MVP on latency, memory, thermal behavior, package size, deterministic JSON reliability, and Japanese short-form quality.

## Cursor Task

### Title

`P1-4: Evaluate LiteRT-LM backend feasibility` — **complete (reproducible eval lane on `main`)**

### Status

Device evidence for Matisse (blocked) and Wang (pass) is recorded above. The eval target and scripts are on `main`.

**P1-4b (complete):** gated comparison inside PREXUS main app — see [adoption memo](./litert_lm_adoption_decision.md) §6.

| Item | Command / artifact |
| --- | --- |
| Prototype Xcode | `PREXUS_LITERT_LM_PROTOTYPE=1 ruby tools/scripts/generate_xcodeproj.rb` (requires `vendor_litert_lm.sh`) |
| Debug chat path | Settings → “Use LiteRT eval backend” on A17 Pro+ with `.litertlm` present |
| Head-to-head | `./tools/scripts/compare_local_backends_on_device.sh "Wang"` → `.eval-logs/litert-backend-comparison-*.log` |
| Comparison prompts | Same as P1-4 eval (`ja_short`, `routing_json`) + `control_plane_medium` |
| Production | Unchanged — `prexus-local-mvp.gguf` + llama.cpp automatic |
| Next policy step | Review [LiteRT-LM Routing Policy Evaluation](./litert_lm_routing_policy_evaluation.md) before any L2 selector implementation |
| P1-4c-a | **Complete (Wang 2026-05-30)** — `./tools/scripts/eval_strict_json_on_device.sh`; see [routing policy §9](./litert_lm_routing_policy_evaluation.md) |
| P1-4c-b | 5-10 minute thermal/memory eval; docs/logs only; no selector |

### Instructions (P1-4b and later)

1. Keep the current Qwen + llama.cpp MVP path untouched.
2. Do not wire LiteRT-LM into `AppLocalModelFactory` automatic mode without Codex adoption approval.
3. Do not commit model artifacts, `.litertlm` files, DerivedData, screenshots, or `.eval-logs`.
4. Regenerate with `PREXUS_LITERT_LM_EVAL=1` only when changing eval sources; commit default `ruby tools/scripts/generate_xcodeproj.rb` output for review.
5. Record exact test-plan results in the PR body using the repository PR template.
6. For P1-4c, collect evidence only: strict JSON rates and thermal/memory observations. Do not add an L2 selector or change production `automatic`.

## Codex Review Gate

Codex should reject the PR if it:

- changes the default local model away from Qwen,
- replaces the production llama.cpp backend,
- commits model binaries or generated local artifacts,
- introduces broad runtime abstractions before feasibility is proven,
- omits test-plan results for the actual device/backend path attempted.

Merge readiness is based on evidence quality, not adoption. The desired outcome is a reliable decision record: continue LiteRT-LM, block it with evidence, or scope a deeper backend prototype.
