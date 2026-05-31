# Qwen Text-Only Alpha Release Scope

## Decision

PREXUS の最初の正式リリースは **Qwen text-only alpha** として定義する。

この alpha は、Phase 1 全体の完成版ではない。目的は、Qwen + llama.cpp による local-first text runtime を安定版として切り出し、以後の LiteRT、OCR、compression、multimodal 拡張をリリース後のバージョンアップ要件として扱える状態にすること。

## Target Window

| Item | Decision |
| --- | --- |
| Target release window | 2026-06 mid-month |
| Release type | Internal / TestFlight alpha |
| Product slice | Text-only local-first runtime |
| Production local backend | Qwen2.5-0.5B-Instruct Q4_K_M via llama.cpp |
| Default routing | Existing automatic policy; no L2 selector |
| LiteRT-LM | Research / prototype only; not part of alpha behavior |

## Alpha Scope

### Included

| Area | Requirement |
| --- | --- |
| Text chat | User can send text turns and receive coherent local responses on supported physical iPhone hardware |
| Local backend | `deviceRuntime` / `automatic` uses Qwen + llama.cpp on supported devices |
| Fallback | llama.cpp failure falls back to embedded heuristic behavior without crash |
| Simulator | Simulator continues to use mock/local-safe behavior |
| Routing | Existing local/cloud routing and sensitivity policy remain intact |
| Sensitivity | `localOnly`, `localPreferred`, `escalationAllowed`, `providerRestricted` remain selectable and documented |
| Diagnostics | Runtime decisions, responding backend, fallback state, and primary reasons remain visible |
| Settings | Provider key state and runtime policy remain understandable |
| Model handling | No large model binaries in git; local model setup is documented |
| Privacy posture | Local-first behavior and cloud escalation limits are documented |

### Explicitly excluded from alpha

| Feature | Post-alpha status |
| --- | --- |
| LiteRT-LM production adoption | Deferred until policy/legal/thermal evidence sign-off |
| L2 local backend selector | Deferred; forbidden until routing policy checklist is approved |
| OCR input MVP | Post-alpha Phase 1 upgrade |
| Compression v0/v1 | Post-alpha runtime upgrade |
| Audio input / ASR | Phase 2 |
| Live camera / vision reasoning | Phase 2 |
| User-managed model download UX | Post-alpha product decision |
| Broad backend registry / plugin architecture | Not justified for alpha |

## Release Blockers

The alpha should not ship if any of these remain unresolved:

| Blocker | Exit criteria |
| --- | --- |
| App crash on launch or first text turn | Wang / supported physical device smoke passes |
| Qwen model missing path is unclear | User/developer sees a deterministic fallback or setup diagnostic |
| llama.cpp failure breaks Chat flow | Failure routes to embedded heuristic and diagnostics record the cause |
| Sensitivity policy regression | Existing sensitivity tests pass and manual smoke verifies all four modes |
| Cloud/provider fallback regression | Missing provider keys do not produce invalid cloud calls |
| Release scope ambiguity | Docs and PR body state text-only alpha and list post-alpha exclusions |

## Non-Blockers

These should not delay the Qwen text-only alpha:

| Item | Reason |
| --- | --- |
| LiteRT P1-4c-b result | Useful for future adoption, not required for Qwen alpha |
| LiteRT strict JSON advantage | Evidence only; not an alpha product behavior |
| OCR not implemented | Explicitly post-alpha |
| Compression v1 not implemented | Explicitly post-alpha |
| UI glass polish beyond regressions | Not required for local runtime validation |
| Production model download UX | Alpha can use documented model placement |

## Required Verification

Before cutting the alpha candidate:

1. Run default simulator tests.
2. Regenerate the default Xcode project with no LiteRT prototype linkage.
3. Confirm a supported iPhone can run Qwen + llama.cpp from `prexus-local-mvp.gguf`.
4. Confirm missing or failed local model path falls back without crashing.
5. Smoke test Chat, Settings, Diagnostics, and four sensitivity modes.
6. Record known limitations in release notes.

Recommended commands:

```bash
ruby tools/scripts/generate_xcodeproj.rb
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme PREXUS -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' test
```

Device checks should be recorded manually because physical device availability and model placement are environment-specific.

Release candidate docs:

- [qwen_text_only_alpha_release_readiness.md](./qwen_text_only_alpha_release_readiness.md) — RC checklist
- [qwen_text_only_alpha_release_notes.md](./qwen_text_only_alpha_release_notes.md) — release notes and known limitations
- [qwen_text_only_alpha_tester_instructions.md](./qwen_text_only_alpha_tester_instructions.md) — internal / TestFlight tester steps
- [qwen_text_only_alpha_testflight_prep.md](./qwen_text_only_alpha_testflight_prep.md) — version/tag naming, pre-TestFlight gate, upload outline (ops only; no tag/upload in repo)

## Cursor Task

Title: Harden Qwen text-only alpha release path

Goal: prepare PREXUS for a 2026-06 mid-month Qwen + llama.cpp text-only alpha without adding new product features.

Allowed changes:

- Improve Qwen + llama.cpp failure handling, user/developer diagnostics, and model-missing messaging.
- Add or update tests around local backend fallback, diagnostics, sensitivity routing, and provider-key fallback.
- Add release checklist docs, setup notes, and known limitations for Qwen text-only alpha.
- Keep default project generation clean: no LiteRT SPM, no eval target, no model artifacts.
- Update PR bodies with concrete simulator/device test results.

Forbidden changes:

- Do not implement an L2 selector.
- Do not change production `automatic` away from Qwen + llama.cpp.
- Do not wire LiteRT-LM into production behavior.
- Do not make OCR, compression v1, audio, live camera, or model download UX alpha blockers.
- Do not commit `.gguf`, `.litertlm`, `.eval-logs`, DerivedData, screenshots, or local device logs.
- Do not introduce broad backend registries or plugin abstractions.

Expected first PR:

1. Add a release readiness checklist for Qwen text-only alpha.
2. Audit current local model missing/failure diagnostics.
3. Patch only narrow gaps that can block alpha smoke.
4. Include test plan results for simulator tests and any available Wang/device smoke.

Stop condition: the PR should prove that Qwen text-only alpha can be evaluated as a release candidate without expanding scope beyond text-only runtime hardening.

