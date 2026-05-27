# PREXUS Local Model Assets

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

Evaluation-only Gemma push (does not replace default filename):

```bash
PREXUS_LOCAL_MODEL_SOURCE=models/prexus-eval-gemma4-e2b-it.gguf \
PREXUS_LOCAL_MODEL_DEST=prexus-eval-gemma4-e2b-it.gguf \
./tools/scripts/push_local_model_to_device.sh "Wang"
```

Or run the full device eval workflow: `./tools/scripts/eval_gemma4_on_device.sh "Wang"`.

## Fallback behavior

If the GGUF is missing, llama.cpp fails to load, or the device is below A17 Pro class, PREXUS falls back to `EmbeddedHeuristicLocalModelClient` without crashing.

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

