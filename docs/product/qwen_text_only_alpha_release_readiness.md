# Qwen Text-Only Alpha — Release Readiness Checklist

Companion to [qwen_text_only_alpha_release.md](./qwen_text_only_alpha_release.md) and [local_inference_mvp.md](../requirements/local_inference_mvp.md).

Target: **2026-06 mid-month** internal / TestFlight alpha. Production local path: **Qwen2.5-0.5B-Instruct Q4_K_M + llama.cpp** only.

## Scope guard

| Check | Status |
| --- | --- |
| No L2 backend selector | Required |
| `automatic` / device runtime stays Qwen + llama.cpp (no LiteRT in production) | Required |
| No OCR / compression v1 / audio / camera in alpha exit criteria | Required |
| No `.gguf` / `.litertlm` / `.eval-logs` / DerivedData in git | Required |

## Code readiness

| Item | Verification |
| --- | --- |
| Qwen missing model → embedded heuristic, no crash | `FallbackLocalModelClient` + `PREXUSTests.testRunTurnMarksFallbackWhenLlamaPrimaryFails` |
| llama.cpp load/generation failure → embedded heuristic | Same chain; `LocalModelError.diagnosticDescription` in trace |
| Diagnostics show `answered_by`, `primary_failure`, `fallback_reason` | `LocalModelExecutionTrace.formattedDetail`; runtime turn uses `.fallback` when trace has `primary_failure` |
| Simulator uses mock/safe backend | `AppLocalModelFactory` + `PREXUSTests` factory tests |
| Sensitivity routing unchanged | Existing `PREXUSTests` sensitivity / routing tests |
| Cloud key missing → local path, no invalid cloud call | `testRunTurnUsesLocalPrimaryWhenCloudKeyIsMissing` |

## Build & test commands

Default project (no LiteRT prototype):

```bash
ruby tools/scripts/generate_xcodeproj.rb
cd app/ios
xcodebuild -project PREXUS.xcodeproj -scheme PREXUS \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' \
  -derivedDataPath ../../.derivedData-release test
```

Optional device smoke (environment-specific):

```bash
./tools/scripts/fetch_local_model.sh
./tools/scripts/build_llama_xcframework.sh   # if not already built
ruby tools/scripts/generate_xcodeproj.rb
./tools/scripts/push_local_model_to_device.sh "Wang"
# Install Debug build, send one local-routed chat turn, open Settings → Runtime diagnostics
```

## Manual smoke (physical device)

- [ ] App launches; Chat accepts a text turn without crash
- [ ] With GGUF in `Documents/Models/prexus-local-mvp.gguf`, response comes from llama.cpp (diagnostics `answered_by=llama.cpp On-Device Runtime`)
- [ ] With GGUF removed, response still returns (embedded heuristic); diagnostics `mode=fallback`, `primary_failure` mentions `model_asset_unavailable`, `fallback_reason=embedded_heuristic`
- [ ] All four sensitivity modes send one turn each
- [ ] Diagnostics list shows route + execution detail for last turns

## Known limitations (alpha)

| Topic | Expectation |
| --- | --- |
| Model quality | 0.5B demo-grade; may hallucinate on facts |
| Model install | Manual copy / `push_local_model_to_device.sh`; no in-app download UX |
| Hardware | A17 Pro-class+ for real Qwen; older devices use embedded heuristic |
| LiteRT-LM | Prototype/eval only; not alpha behavior |
| Multimodal | Text-only alpha; OCR/camera/audio deferred |

## Release candidate sign-off

Alpha is **release-candidate evaluable** when:

1. Simulator `PREXUSTests` green on default generated project.
2. Device smoke (if available) confirms Qwen path and missing-model fallback with diagnostics.
3. PR body lists concrete test results and links this checklist.
4. No production routing or automatic backend change beyond Qwen + llama.cpp.
