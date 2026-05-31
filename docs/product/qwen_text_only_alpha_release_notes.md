# Qwen Text-Only Alpha — Release Notes

**Release candidate:** Qwen + llama.cpp text-only alpha
**Target window:** 2026-06 mid-month (internal / TestFlight)
**Main reference:** [qwen_text_only_alpha_release.md](./qwen_text_only_alpha_release.md)

## What ships

- Text chat with local-first routing on supported iPhone hardware (A17 Pro-class+).
- Production local backend: **Qwen2.5-0.5B-Instruct Q4_K_M** via **llama.cpp** (`automatic` / `deviceRuntime`).
- Deterministic fallback to **embedded heuristic** when the GGUF is missing or llama.cpp fails (no crash).
- Four sensitivity modes: `localOnly`, `localPreferred`, `escalationAllowed`, `providerRestricted`.
- Runtime diagnostics: route, execution mode, `answered_by`, `primary_failure`, `fallback_reason` (when applicable).

## What does not ship

- LiteRT-LM as production behavior (eval/prototype only).
- L2 backend selector.
- OCR, compression v1, audio, live camera.
- In-app model download UX.
- Cloud-quality factual guarantees from the 0.5B local model.

## Known limitations

| Area | Limitation |
| --- | --- |
| Model size | ~400MB Q4_K_M; demo-grade, not encyclopedic |
| Facts / reasoning | May hallucinate; not a replacement for cloud models on hard tasks |
| Model install | Manual: `fetch_local_model.sh`, `push_local_model_to_device.sh`, or Documents placement — see [models/README.md](../../models/README.md) |
| Hardware | Real Qwen path requires A17 Pro-class+; other devices use embedded heuristic |
| Cloud keys | Without provider API keys, escalation routes reroute to local execution |
| Diagnostics | Stored locally on device (last 20 turns); not synced to cloud |
| Markdown fences | Local model output format varies; strict JSON eval is evidence-only, not chat UX |

## Upgrade path (post-alpha)

- Phase 1: OCR, compression v1, richer memory/RAG integration.
- LiteRT-LM: adoption only after policy/legal/thermal sign-off (see routing policy eval docs).
- Multimodal: Phase 2 (audio, camera).

## Verification artifacts

| Artifact | Location |
| --- | --- |
| RC checklist | [qwen_text_only_alpha_release_readiness.md](./qwen_text_only_alpha_release_readiness.md) |
| TestFlight prep | [qwen_text_only_alpha_testflight_prep.md](./qwen_text_only_alpha_testflight_prep.md) |
| Tester steps | [qwen_text_only_alpha_tester_instructions.md](./qwen_text_only_alpha_tester_instructions.md) |
| Automated Wang smoke | [`tools/scripts/alpha_smoke_wang.sh`](../../tools/scripts/alpha_smoke_wang.sh) → `.eval-logs/` (gitignored) |

## Build requirements (developers)

```bash
./tools/scripts/fetch_local_model.sh
./tools/scripts/build_llama_xcframework.sh   # once per machine
ruby tools/scripts/generate_xcodeproj.rb
```

Simulator-only checkouts without `llama.xcframework` can still run `PREXUSTests` on the default generated project; device builds need the framework.
