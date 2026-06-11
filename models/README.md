# QWON Local Model Assets

GGUF weights are **not** committed to git.

## Default MVP model

| Property | Value |
| --- | --- |
| File name | `prexus-local-mvp.gguf` |
| Suggested quant | Qwen2.5-0.5B-Instruct Q4_K_M (default; ~400MB) |
| Alternate (smaller) | SmolLM2-360M-Instruct Q4_K_M (~220MB; weaker Japanese QA) |
| Download | `./tools/scripts/fetch_local_model.sh` |

## Placement contract

`LocalGGUFModelPlacement` resolves the model in this order:

1. `PREXUS_LOCAL_MODEL_PATH` environment variable (absolute path)
2. App bundle resource `prexus-local-mvp.gguf` (optional debug packaging)
3. `Documents/Models/prexus-local-mvp.gguf` on device

## Device requirements

- A17 Pro-class hardware or newer (iPhone 15 Pro / 16 / 17 families)
- llama.cpp XCFramework built locally: `./tools/scripts/build_llama_xcframework.sh`
- Xcode project regenerated after the framework exists: `ruby tools/scripts/generate_xcodeproj.rb`

## Developer workflow

```bash
git submodule update --init --recursive vendor/llama.cpp
./tools/scripts/build_llama_xcframework.sh
./tools/scripts/fetch_local_model.sh
ruby tools/scripts/generate_xcodeproj.rb
./tools/scripts/install_on_device.sh "Wang"
```

Copy `models/prexus-local-mvp.gguf` into the app sandbox `Documents/Models/` on first device run, or set `PREXUS_LOCAL_MODEL_PATH` in the Xcode scheme.

## Internal tester placement (TestFlight / USB)

QWON **does not download** the GGUF inside the app in this alpha. Internal testers and support use **Mac + USB ops**:

| Step | Action |
| --- | --- |
| 1 | On a Mac with repo access: `./tools/scripts/fetch_local_model.sh` |
| 2 | Connect iPhone via USB (unlock, Trust, Developer Mode on) |
| 3 | `./tools/scripts/push_local_model_to_device.sh "DEVICE_NAME"` — e.g. `"Wang"` |
| 4 | In QWON: **Settings → Local Runtime → Place GGUF via Mac** for the full checklist |
| 5 | Verify **Local Model File** status and **Runtime Diagnostics** after a chat turn |

| Device tier | Expected after placement |
| --- | --- |
| **Wang (A17 Pro+)** | `Present (unverified)` → llama.cpp On-Device Runtime when Chat runs locally |
| **Matisse (A12)** | Embedded Heuristic Runtime remains expected; GGUF optional |

Do **not** tell testers the model is bundled in TestFlight or that QWON can download it in-app. Evidence PNG/JSON stays in `~/QWON-alpha-evidence/` — not in git.

See [Model download / GGUF UX plan](../docs/product/qwon_model_download_gguf_ux_plan.md).

## Naming notes (Phase 4)

| Surface | Current active value | Notes |
| --- | --- | --- |
| Xcode project path | `app/ios/PREXUS.xcodeproj` | **Container name deferred** — use `-scheme QWON` |
| App target / product | `QWON` / `QWON.app` | |
| Swift module | `QWON` | |
| Unit / UI tests | `QWONTests` / `QWONUITests` | |
| Model file | `prexus-local-mvp.gguf` | **Preserved** filename — separate migration if product approves |
| Env vars | `PREXUS_LOCAL_MODEL_PATH`, `PREXUS_RUN_*`, … | **Preserved** runtime contracts until a dedicated migration |

Historical PREXUS alpha docs (`qwen_text_only_alpha_*`) keep frozen command snippets for audit trail. Full preserve/defer catalog: [Preserved PREXUS surface inventory](../docs/product/qwon_preserved_prexus_surface_inventory.md).

Evaluation-only Gemma push (does not replace default filename):

```bash
PREXUS_LOCAL_MODEL_SOURCE=models/prexus-eval-gemma4-e2b-it.gguf \
PREXUS_LOCAL_MODEL_DEST=prexus-eval-gemma4-e2b-it.gguf \
./tools/scripts/push_local_model_to_device.sh "Wang"
```

Or run the full device eval workflow: `./tools/scripts/eval_gemma4_on_device.sh "Wang"`.

## Fallback behavior

If the GGUF is missing, llama.cpp fails to load, or the device is below A17 Pro class, QWON falls back to `EmbeddedHeuristicLocalModelClient` without crashing.

Runtime diagnostics (Settings → Runtime diagnostics) record:

- `answered_by` — backend that produced the reply (e.g. `llama.cpp On-Device Runtime` or `Embedded Heuristic Runtime`)
- `primary_failure` — why the primary backend failed (e.g. `model_asset_unavailable: …`)
- `fallback_reason=embedded_heuristic` — when the embedded path answered after a primary failure

See [Qwen text-only alpha release readiness](../docs/product/qwen_text_only_alpha_release_readiness.md).

## Evaluation candidate (not default)

| Property | Value |
| --- | --- |
| File name | `prexus-eval-gemma4-e2b-it.gguf` |
| Model | `google/gemma-4-E2B-it` |
| Suggested quant | Q4_K_M (~3.2 GiB) via bartowski |
| Download | `./tools/scripts/fetch_gemma4_e2b_eval_model.sh` |
| Status | Evaluation only — **default remains Qwen 0.5B** |

Use `PREXUS_LOCAL_MODEL_PATH` (absolute path) or copy into `Documents/Models/` under a custom name and point the env var at it for device experiments. See [Gemma-4-E2B-it Evaluation Plan](../docs/research/gemma4_e2b_evaluation_plan.md).

Mac-side throughput checks:

```bash
./tools/scripts/fetch_gemma4_e2b_eval_model.sh
cd vendor/llama.cpp && cmake -B build-mac -DCMAKE_BUILD_TYPE=Release -DGGML_METAL=ON
cmake --build build-mac -j --target llama-bench llama-cli
./tools/scripts/benchmark_local_gguf.sh models/prexus-eval-gemma4-e2b-it.gguf
```

## LiteRT-LM evaluation (not production)

| Property | Value |
| --- | --- |
| File name | `prexus-eval-gemma4-e2b.litertlm` |
| Model | `litert-community/gemma-4-E2B-it-litert-lm` → `gemma-4-E2B-it.litertlm` |
| Download | `./tools/scripts/fetch_litert_lm_eval_model.sh` |
| Device eval app | `PREXUSLiteRTEval` (`jp.studio-prospect.qwon.ios.literteval`) |
| Full workflow | `./tools/scripts/eval_litert_lm_on_device.sh "Wang"` |

See [LiteRT-LM Evaluation Plan](../docs/research/litert_lm_evaluation_plan.md). **Default remains Qwen 0.5B + llama.cpp in QWON.**

### LiteRT-LM E4B evaluation (not production)

| Property | Value |
| --- | --- |
| File name | `prexus-eval-gemma4-e4b.litertlm` |
| Model | `litert-community/gemma-4-E4B-it-litert-lm` → `gemma-4-E4B-it.litertlm` |
| Download | `./tools/scripts/fetch_litert_lm_e4b_eval_model.sh` |
| Device eval app | `PREXUSLiteRTEval` (same isolated target; E4B filename via launch env) |
| Full workflow | `./tools/scripts/eval_litert_lm_e4b_on_device.sh "Wang"` |

**Not** the `google/gemma-4-E4B-it-qat-mobile-transformers` Safetensors artifact. See [Gemma 4 E4B Mobile Evaluation Plan](../docs/research/gemma4_e4b_mobile_evaluation_plan.md).

