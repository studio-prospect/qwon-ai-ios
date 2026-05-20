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

## Fallback behavior

If the GGUF is missing, llama.cpp fails to load, or the device is below A17 Pro class, PREXUS falls back to `EmbeddedHeuristicLocalModelClient` without crashing.
