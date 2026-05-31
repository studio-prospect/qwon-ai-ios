# Qwen Text-Only Alpha — Release Candidate Checklist

**Status:** RC merged to `main` (PR #22). Product ops / TestFlight prep: [testflight_prep](./qwen_text_only_alpha_testflight_prep.md).
**Production local path:** Qwen2.5-0.5B-Instruct Q4_K_M + llama.cpp only.

| Doc | Purpose |
| --- | --- |
| [qwen_text_only_alpha_release.md](./qwen_text_only_alpha_release.md) | Scope and exclusions |
| [qwen_text_only_alpha_release_notes.md](./qwen_text_only_alpha_release_notes.md) | Release notes + known limitations |
| [qwen_text_only_alpha_tester_instructions.md](./qwen_text_only_alpha_tester_instructions.md) | Manual tester flow |
| [qwen_text_only_alpha_testflight_prep.md](./qwen_text_only_alpha_testflight_prep.md) | Version/tag naming, pre-TestFlight gate, upload outline |
| [qwen_text_only_alpha_lab_evidence.md](./qwen_text_only_alpha_lab_evidence.md) | Two-device evidence ledger and retention |
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
- [x] TestFlight / internal distribution — Wang verified on `0.1.0 (1)` ([prep doc](./qwen_text_only_alpha_testflight_prep.md#wang-testflight-verification-2026-05-31))
- [x] TestFlight / Matisse (A12 heuristic path) on `0.1.0 (1)` ([prep doc](./qwen_text_only_alpha_testflight_prep.md#matisse-testflight-verification-2026-05-31))
- [ ] Optional: escalation with real OpenAI key on device (not required for RC)

## Product ops / TestFlight (post-RC)

Concrete steps live in [qwen_text_only_alpha_testflight_prep.md](./qwen_text_only_alpha_testflight_prep.md). Summary:

| Step | Gate |
| --- | --- |
| **Bundle ID + signing** | **Complete** — formal ID `jp.studio-prospect.prexus.ios`, ASC app, repo migration, local provisioning profiles, Distribution archive, upload, and tag are complete ([prep doc](./qwen_text_only_alpha_testflight_prep.md#testflight-upload-2026-05-31)) |
| Version naming | Complete — TestFlight alpha `0.1.0`, build `1` |
| Pre-upload smoke | Complete — Wang TestFlight install + local Qwen one-turn verification |
| Device archive | Complete — uploaded TestFlight build includes llama.cpp path |
| Tester comms | Ready — two-device lab only; [device lab policy](./qwen_text_only_alpha_testflight_prep.md#physical-device-lab-ops-policy), [tester instructions](./qwen_text_only_alpha_tester_instructions.md), [What to Test](./qwen_text_only_alpha_testflight_prep.md#asc-what-to-test-copy), [onboarding](./qwen_text_only_alpha_testflight_prep.md#tester-onboarding-message) |
| Tag + TestFlight upload | Complete |

## RC sign-off criteria

PREXUS may be called a **release candidate** when all are true:

1. Simulator `PREXUSTests` green on default generated project (no LiteRT prototype).
2. Wang smoke (or equivalent device) passes `with_model`, `no_model`, and `sensitivity_matrix`.
3. Release notes, tester instructions, and this checklist are linked from the alpha scope doc.
4. No production routing or automatic backend change beyond Qwen + llama.cpp.

**Not required for RC:** LiteRT adoption, OCR, compression v1, model download UX, four-provider cloud matrix on device.

---

## Next build gate (before build 2+)

**Baseline:** TestFlight `0.1.0` (build `1`) two-device lab evidence is **closed** ([frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1), PR #33 on `main`). Run this gate **before** bumping `CFBundleVersion`, archiving, uploading, or asking testers to reinstall.

**Out of scope for this gate:** App Store public release, LiteRT production, L2 selector, OCR/camera/audio, widening ASC `internal_tester` beyond Wang + Matisse.

### 1. Record the change (git docs only)

- [ ] Write **why** the respin or semver bump is needed in [release notes](./qwen_text_only_alpha_release_notes.md) (or a linked PR / issue).
- [ ] Note planned `CFBundleShortVersionString` / `CFBundleVersion` and git tag name in this section or [TestFlight prep](./qwen_text_only_alpha_testflight_prep.md#version-and-tag-naming-proposals-only) (do not edit `Info.plist` in a docs-only PR).

### 2. Code and archive (implementation PR — not docs-only)

- [ ] Simulator `PREXUSTests` green on the commit to archive.
- [ ] Optional: `./tools/scripts/alpha_smoke_wang.sh "Wang"` before upload (gitignored `.eval-logs/`).
- [ ] Distribution archive + export for `jp.studio-prospect.prexus.ios` with llama linked ([prep validation record](./qwen_text_only_alpha_testflight_prep.md#distribution-archive-validation-2026-05-31)).

### 3. Version, tag, and TestFlight (release engineer)

Follow [TestFlight upload outline](./qwen_text_only_alpha_testflight_prep.md#testflight-upload-outline-not-executed-here) and [next build evidence](./qwen_text_only_alpha_testflight_prep.md#next-build-gate-evidence-and-ops).

- [ ] Increment **`CFBundleVersion`** by 1 (or bump marketing version per naming table if intentional).
- [ ] Upload binary; assign new build to ASC group **`internal_tester`** (still **Wang + Matisse only** — do not add testers).
- [ ] Update ASC **What to Test** / onboarding if behavior or build label changed ([copy blocks](./qwen_text_only_alpha_testflight_prep.md#asc-what-to-test-copy)).
- [ ] Annotated git tag on the archived commit ([tag procedure](./qwen_text_only_alpha_testflight_prep.md#git-tag-procedure-do-not-run-in-automation)).

### 4. Two-device lab evidence (ops + ledger metadata)

- [ ] Create a **new** ops folder per build (e.g. `~/PREXUS-alpha-evidence/qwen-text-0.1.0-build2/`) — do not overwrite [build 1](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) PNGs.
- [ ] Add a **new** ledger subsection in [lab evidence](./qwen_text_only_alpha_lab_evidence.md#adding-a-new-ledger-subsection); **do not** edit or delete build `1` rows.
- [ ] **Wang:** `push_local_model_to_device.sh "Wang"` → Chat + **Runtime Diagnostics** with `answered_by=llama.cpp On-Device Runtime`.
- [ ] **Matisse:** Chat + Diagnostics — **Local runtime** + **Embedded Heuristic Runtime**; missing llama.cpp is **pass**, not failure.
- [ ] File screenshots as `wang-<semver>-<build>-diagnostics.png` / `matisse-…` per [naming](./qwen_text_only_alpha_lab_evidence.md#filename-and-path-placeholders).
- [ ] **Never** commit PNG/JPEG, device logs, IPA, GGUF, or ops `MANIFEST.txt` to git.

### 5. Sign-off

- [ ] [Regression focus](./qwen_text_only_alpha_testflight_prep.md#regression-focus-until-a-third-device-exists) completed on **both** lab devices for the new build number.
- [ ] Ledger + ops filenames recorded; PR body lists `on file (ops)` paths only.
