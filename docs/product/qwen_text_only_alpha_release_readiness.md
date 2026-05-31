# Qwen Text-Only Alpha — Release Candidate Checklist

**Status:** Release candidate (RC) for 2026-06 mid-month internal / TestFlight alpha.
**Production local path:** Qwen2.5-0.5B-Instruct Q4_K_M + llama.cpp only.

| Doc | Purpose |
| --- | --- |
| [qwen_text_only_alpha_release.md](./qwen_text_only_alpha_release.md) | Scope and exclusions |
| [qwen_text_only_alpha_release_notes.md](./qwen_text_only_alpha_release_notes.md) | Release notes + known limitations |
| [qwen_text_only_alpha_tester_instructions.md](./qwen_text_only_alpha_tester_instructions.md) | Manual tester flow |
| [local_inference_mvp.md](../requirements/local_inference_mvp.md) | P1-1 architecture |
| [models/README.md](../../models/README.md) | GGUF placement |

## Scope guard (RC)

| Check | RC status |
| --- | --- |
| No L2 backend selector | Required |
| `automatic` / device runtime = Qwen + llama.cpp | Required |
| LiteRT-LM not in production behavior | Required |
| No OCR / compression v1 / audio / camera in RC | Required |
| No model artifacts / eval logs in git | Required |

## Code readiness

| Item | Verification |
| --- | --- |
| Qwen missing → embedded heuristic, no crash | `FallbackLocalModelClient`, `PREXUSTests`, Wang `no_model` smoke |
| llama.cpp failure diagnostics | `LocalModelError.diagnosticDescription`, trace fields |
| Nested fallback preserves real responder | `testNestedFallbackDoesNotEmitEmbeddedHeuristicReasonWhenQwenAnswers` |
| Simulator safe backend | `AppLocalModelFactory` + `PREXUSTests` |
| Sensitivity routing | `PREXUSTests` + Wang `sensitivity_matrix` smoke |
| Cloud key missing → no invalid cloud call | `testRunTurnUsesLocalPrimaryWhenCloudKeyIsMissing` |

## Build & test commands

```bash
ruby tools/scripts/generate_xcodeproj.rb
cd app/ios
xcodebuild -project PREXUS.xcodeproj -scheme PREXUS \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' \
  -derivedDataPath ../../.derivedData-release test
```

Device RC smoke (Wang or equivalent A17 Pro+):

```bash
./tools/scripts/fetch_local_model.sh
./tools/scripts/build_llama_xcframework.sh   # once per machine
ruby tools/scripts/generate_xcodeproj.rb
./tools/scripts/alpha_smoke_wang.sh "Wang"
```

Optional faster re-run after build: `PREXUS_SKIP_BUILD=1 ./tools/scripts/alpha_smoke_wang.sh "Wang"`

Artifacts (gitignored): `.eval-logs/wang-alpha-smoke-*.json`

## Wang automated smoke (2026-05-31, RC refresh)

| Scenario | Result |
| --- | --- |
| `with_model` | Pass — `llama.cpp On-Device Runtime`, `local`, `answered_by=llama.cpp` |
| `no_model` | Pass — `fallback`, embedded heuristic, `model_asset_unavailable`, `fallback_reason=embedded_heuristic` |
| `sensitivity_matrix` | Pass — four modes complete without error; `localOnly` + `providerRestricted` stay local; `escalationAllowed` may route OpenAI when keys exist (Wang: cloud fail → local llama fallback, no crash) |

## RC manual checklist

- [x] App launches; local turn without crash (automated + manual path documented)
- [x] GGUF present → llama.cpp (`with_model`)
- [x] Forced missing model → embedded fallback (`no_model`)
- [x] Four sensitivity modes — one turn each (`sensitivity_matrix`)
- [x] Diagnostics show route + execution detail (including fallback fields)
- [ ] TestFlight / internal distribution build tagged (product ops)
- [ ] Optional: escalation with real OpenAI key on device (not required for RC)

## RC sign-off criteria

PREXUS may be called a **release candidate** when all are true:

1. Simulator `PREXUSTests` green on default generated project (no LiteRT prototype).
2. Wang smoke (or equivalent device) passes `with_model`, `no_model`, and `sensitivity_matrix`.
3. Release notes, tester instructions, and this checklist are linked from the alpha scope doc.
4. No production routing or automatic backend change beyond Qwen + llama.cpp.

**Not required for RC:** LiteRT adoption, OCR, compression v1, model download UX, four-provider cloud matrix on device.
