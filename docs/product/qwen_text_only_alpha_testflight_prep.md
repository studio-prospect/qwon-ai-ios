# Qwen Text-Only Alpha — TestFlight Preparation

**Status:** TestFlight build **0.1.0 (1)** uploaded 2026-05-31; ASC processing / internal group setup pending. **Not** an App Store public submission.

This doc turns the RC checklist into concrete **internal / TestFlight** steps.

| Doc | Role |
| --- | --- |
| [qwen_text_only_alpha_release.md](./qwen_text_only_alpha_release.md) | Alpha scope and exclusions |
| [qwen_text_only_alpha_release_readiness.md](./qwen_text_only_alpha_release_readiness.md) | RC code readiness (merged) |
| [qwen_text_only_alpha_release_notes.md](./qwen_text_only_alpha_release_notes.md) | Tester-facing limitations |
| [qwen_text_only_alpha_tester_instructions.md](./qwen_text_only_alpha_tester_instructions.md) | Manual tester flow |
| [bundle_id_decision_memo.md](./bundle_id_decision_memo.md) | Approved Bundle ID, owned domain, post-decision gates |
| [models/README.md](../../models/README.md) | GGUF placement |

---

## Product ops status (from RC checklist)

RC **code** criteria are satisfied on `main` (PR #22). Remaining work is **distribution ops** only:

| Item | Owner | Status | Action |
| --- | --- | --- | --- |
| **Formal Bundle ID + ASC app + signing** | Product / release engineering | **Done** | Distribution + Wang smoke + upload 2026-05-31 |
| Version / build numbers aligned with alpha naming | Release engineer | **Done** | `0.1.0` / build `1` uploaded; tag `qwen-text-alpha-0.1.0-rc1` on `a021475` |
| Device archive with llama.cpp linked | Release engineer | **Validated locally** | See [Distribution archive validation](#distribution-archive-validation-2026-05-31); repeat after each release-changing commit |
| Required device smoke green | Release engineer | **Done** (2026-05-31 Wang) | [`alpha_smoke_wang.sh`](#automated-device-smoke-alpha_smoke_wangsh) — all three scenarios on `jp.studio-prospect.prexus.ios` |
| GGUF available to testers | Ops + testers | Open | Document push path; testers need `Documents/Models/prexus-local-mvp.gguf` |
| Git release tag | Release engineer | **Done** | `qwen-text-alpha-0.1.0-rc1` (2026-05-31) |
| TestFlight upload + internal group | Release engineer | **Partial** | Build uploaded; [record](#testflight-upload-2026-05-31) — enable internal testers in ASC |
| Tester onboarding text | Product ops | Open | Paste release-notes excerpt + link to [tester instructions](./qwen_text_only_alpha_tester_instructions.md) |

**Explicitly out of scope for this alpha:** App Store public release, LiteRT production, L2 selector, OCR/compression/audio/camera, in-app model download UX.

**Not upload-ready when:** sections A–E and device smoke pass but ASC, Xcode, and Distribution signing are not aligned to the approved Bundle ID. Smoke validates runtime behavior only; it does not substitute for a valid App Store Connect identity.

---

## Bundle ID and signing gate (blocking TestFlight)

The **formal Bundle ID is decided** (`jp.studio-prospect.prexus.ios`). PREXUS remains **not upload-ready** until **Distribution signing** and Release archive validate for that ID, even if simulator tests pass.

**Decision record:** [bundle_id_decision_memo.md](./bundle_id_decision_memo.md) — ASC app `PREXUS`, Apple ID `6775110218`, profiles `AppStorePREXUS_20260531` / `DevelopmentPREXUS_20260531`, migration from dev placeholder `com.prexus.ios`.

| Topic | Current state | Upload requirement |
| --- | --- | --- |
| Formal Bundle ID | `jp.studio-prospect.prexus.ios` | Matches ASC app SKU / bundle |
| Repo + scripts | Migrated in bundle-id PR (`generate_xcodeproj.rb`, device scripts) | Regenerate `project.pbxproj` after pull |
| ASC app record | **PREXUS** (Apple ID `6775110218`) | Documented; no further ASC edits in repo PRs |
| Provisioning profiles | `AppStorePREXUS_20260531`, `DevelopmentPREXUS_20260531` installed locally | Validate Release archive against Distribution profile |
| Signing (Distribution) | **Validated** (2026-05-31) | Release archive + `app-store-connect` export; see [validation record](#distribution-archive-validation-2026-05-31) |
| Test targets | `jp.studio-prospect.prexus.ios.tests`, `.uitests` | Aligned with main app in generator |

### Exit criteria (upload-ready)

- [x] Official Bundle ID in [bundle_id_decision_memo.md](./bundle_id_decision_memo.md#sign-off) sign-off.
- [x] ASC app exists with Bundle ID `jp.studio-prospect.prexus.ios`.
- [x] Xcode / scripts `PRODUCT_BUNDLE_IDENTIFIER` matches ASC (bundle-id migration PR).
- [x] Provisioning profiles registered locally: `AppStorePREXUS_20260531`, `DevelopmentPREXUS_20260531`.
- [x] Release archive validates with **Distribution** signing for that ID ([2026-05-31 validation](#distribution-archive-validation-2026-05-31)).
- [ ] Internal TestFlight group and crash symbolication mapped to ASC app `PREXUS`.

### Xcode / script gate (complete after migration PR)

Repo and device scripts reference the formal ID. **Previous placeholder:** `com.prexus.ios` — uninstall old builds on test devices before Debug smoke.

### After Distribution archive validates

- Proceed with Wang / device smoke on the **new** Bundle ID (uninstall old `com.prexus.ios` builds first).
- Do **not** upload to TestFlight or create a distribution git tag until device smoke and ASC internal group are ready.

---

## Distribution archive validation (2026-05-31)

Local validation on `main` after bundle-id migration (no TestFlight upload). Prerequisites: `fetch_local_model.sh`, `build_llama_xcframework.sh`, then `ruby tools/scripts/generate_xcodeproj.rb` **with** `llama.xcframework` present (local only — do not commit llama-linked `project.pbxproj`).

```bash
cd app/ios
xcodebuild -project PREXUS.xcodeproj -scheme PREXUS \
  -destination 'generic/platform=iOS' -configuration Release \
  -archivePath ../../.archive/PREXUS-Release.xcarchive \
  DEVELOPMENT_TEAM=BWSS94LH28 CODE_SIGN_STYLE=Automatic \
  -allowProvisioningUpdates archive

xcodebuild -exportArchive \
  -archivePath ../../.archive/PREXUS-Release.xcarchive \
  -exportPath ../../.archive/PREXUS-Export \
  -exportOptionsPlist ../../.archive/ExportOptions-appstore.plist \
  -allowProvisioningUpdates
```

`ExportOptions-appstore.plist` (local, not in git): `method` = `app-store-connect`, `teamID` = `BWSS94LH28`, `signingStyle` = `automatic`.

| Check | Result |
| --- | --- |
| Archive | **ARCHIVE SUCCEEDED** |
| Export | **EXPORT SUCCEEDED** |
| Bundle ID in archive | `jp.studio-prospect.prexus.ios` |
| IPA signature | `Apple Distribution: studio PROSPECT, Inc (BWSS94LH28)` |

Re-run after version bumps or runtime changes intended for TestFlight.

---

## TestFlight upload (2026-05-31)

Uploaded from archive at `main` commit tagged `qwen-text-alpha-0.1.0-rc1` (`a021475`).

| Field | Value |
| --- | --- |
| Version | `0.1.0` (build `1`) |
| Bundle ID | `jp.studio-prospect.prexus.ios` |
| ASC app | PREXUS (Apple ID `6775110218`) |
| Git tag | `qwen-text-alpha-0.1.0-rc1` |
| Upload result | **Upload succeeded** (`xcodebuild -exportArchive`, `destination=upload`) |

**Next in ASC:** wait for build processing → assign to internal TestFlight group → paste [tester instructions](./qwen_text_only_alpha_tester_instructions.md) in What to Test.

---

## Wang device smoke (2026-05-31)

`./tools/scripts/alpha_smoke_wang.sh "Wang"` on `jp.studio-prospect.prexus.ios` after bundle-id migration.

| Scenario | Result |
| --- | --- |
| `with_model` | Pass — `llama.cpp On-Device Runtime`, `local` |
| `no_model` | Pass — embedded heuristic, `fallback_reason=embedded_heuristic` |
| `sensitivity_matrix` | Pass — four sensitivity modes |

**Device note:** first launch may fail if Wang is locked; unlock before smoke. Script freshness check tolerates same-second result writes (see `alpha_smoke_wang.sh`).

---

## Version and tag naming (proposals only)

Use a dedicated **0.1.x** marketing line so TestFlight builds are clearly not a future 1.0 GA. Align git tags, Xcode versions, and TestFlight “What to Test” text.

| Artifact | First alpha proposal | Notes |
| --- | --- | --- |
| **Git annotated tag** | `qwen-text-alpha-0.1.0-rc1` | Pattern: `qwen-text-alpha-<semver>-rc<N>`; bump `rc` for respins without semver change |
| **CFBundleShortVersionString** | `0.1.0` | Set in `app/ios/PREXUS/Resources/Info.plist` before archive |
| **CFBundleVersion** | `1` | Increment by **1** for every TestFlight binary upload (`2`, `3`, …) |
| **Xcode Archive display name** | `PREXUS Qwen Text Alpha 0.1.0 (1)` | Optional; helps distinguish archives in Organizer |
| **TestFlight build subtitle** | `Qwen text-only alpha rc1` | Short human label in ASC |
| **Branch naming (ops docs/PRs)** | `chore/qwen-alpha-release-ops-*` | Keeps ops churn out of runtime feature branches |

**Respins:** Same marketing version `0.1.0`, new `CFBundleVersion`, new git tag e.g. `qwen-text-alpha-0.1.0-rc2` if binaries change materially.

**Next semver slice (post-alpha, not this task):** `0.2.0` for a broader Phase 1 drop; do not conflate with this text-only alpha.

Committed alpha versioning (TestFlight-first archive):

```text
CFBundleShortVersionString = 0.1.0
CFBundleVersion = 1
```

---

## Git tag procedure (do not run in automation)

Run only after [Pre-TestFlight gate](#pre-testflight-gate-checklist) passes **including the Bundle ID gate (section G)** on the **same commit** you archive.

```bash
# Example — execute manually when ready; not part of CI/docs PRs
git checkout main
git pull origin main
git tag -a qwen-text-alpha-0.1.0-rc1 -m "Qwen text-only alpha TestFlight rc1"
git push origin qwen-text-alpha-0.1.0-rc1
```

Record the tag name in TestFlight internal notes so support can map crashes to source.

---

## Pre-TestFlight gate checklist

Complete **all** before creating an archive or tagging.

### A. Repository and simulator

- [ ] On `main` at or after RC merge (`qwen_text_only_alpha_*` docs present).
- [ ] `git diff --check` clean on changed docs.
- [ ] Default generated project (no `llama.xcframework` in git):

```bash
ruby tools/scripts/generate_xcodeproj.rb
cd app/ios
xcodebuild -project PREXUS.xcodeproj -scheme PREXUS \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' \
  -derivedDataPath ../../.derivedData-release test
```

### B. Device build prerequisites (required for real Qwen path)

- [ ] `./tools/scripts/fetch_local_model.sh` — `models/prexus-local-mvp.gguf` exists locally (not committed).
- [ ] `./tools/scripts/build_llama_xcframework.sh` — produces `vendor/llama-cpp-artifacts/llama.xcframework`.
- [ ] `ruby tools/scripts/generate_xcodeproj.rb` — links llama for **device** builds (differs from simulator-only committed `project.pbxproj`).

### C. Required device smoke ([`alpha_smoke_wang.sh`](../../tools/scripts/alpha_smoke_wang.sh))

On an **A17 Pro-class+** physical iPhone (Wang or equivalent), with USB trust and Developer Mode:

```bash
./tools/scripts/alpha_smoke_wang.sh "Wang"
# Optional faster re-run after a successful build:
PREXUS_SKIP_BUILD=1 ./tools/scripts/alpha_smoke_wang.sh "Wang"
```

| Scenario | Pass criteria |
| --- | --- |
| **with_model** | `llama.cpp On-Device Runtime`, `executionMode=local`, `answered_by=llama.cpp` |
| **no_model** | Embedded heuristic fallback, `model_asset_unavailable`, `fallback_reason=embedded_heuristic`, no crash |
| **sensitivity_matrix** | Four sensitivity modes each complete one turn without error |

Artifacts: `.eval-logs/wang-alpha-smoke-*.json` (gitignored). Keep copies for release records.

**Script prerequisites** (enforced by the script):

- `models/prexus-local-mvp.gguf`
- `vendor/llama-cpp-artifacts/llama.xcframework`
- Regenerates Xcode project before build

Environment overrides: `DEVELOPMENT_TEAM`, `PREXUS_SKIP_BUILD=1` — see script header in [`tools/scripts/alpha_smoke_wang.sh`](../../tools/scripts/alpha_smoke_wang.sh).

### D. GGUF placement for testers

- [ ] Confirm [models/README.md](../../models/README.md) path: on-device `Documents/Models/prexus-local-mvp.gguf`.
- [ ] For internal sideload/debug: `./tools/scripts/push_local_model_to_device.sh "<DeviceName>"`.
- [ ] TestFlight notes state: **model is not bundled**; testers need developer-assisted placement for full Qwen path.

### E. Release metadata (docs only in this phase)

- [ ] [Version and tag naming](#version-and-tag-naming-proposals-only) agreed.
- [ ] [Tester instructions](./qwen_text_only_alpha_tester_instructions.md) linked from ASC “What to Test”.
- [ ] [Release notes](./qwen_text_only_alpha_release_notes.md) limitations copied into tester comms.

### G. Bundle ID and signing (**blocking upload** — section A–E and smoke alone are insufficient)

**Xcode / scripts / ASC record (complete after bundle-id migration PR):**

- [x] [bundle_id_decision_memo.md](./bundle_id_decision_memo.md) sign-off: `jp.studio-prospect.prexus.ios`, ASC `PREXUS`.
- [x] `generate_xcodeproj.rb` + device scripts use formal ID (migration PR).
- [x] Regenerated `project.pbxproj` committed with formal test target IDs.
- [x] Provisioning profiles registered locally: `AppStorePREXUS_20260531`, `DevelopmentPREXUS_20260531`.

**Distribution / upload (partial):**

- [x] Distribution signing succeeds for `jp.studio-prospect.prexus.ios` ([2026-05-31](#distribution-archive-validation-2026-05-31)).
- [ ] Internal TestFlight group under ASC app `PREXUS` (manual ASC).
- [x] Wang / device smoke on new ID (2026-05-31; `VALIDATION PASSED` for `with_model`, `no_model`, `sensitivity_matrix`).

### F. Optional (not blocking text-only alpha)

- [ ] Escalation smoke with a real OpenAI key on device (`escalationAllowed` cloud path).
- [ ] Ad hoc install via `./tools/scripts/install_on_device.sh` for spot checks without TestFlight.

---

## TestFlight upload outline (not executed here)

Manual steps for the release engineer. **Do not start** until [section G](#g-bundle-id-and-signing-blocking-upload--section-ae-and-smoke-alone-are-insufficient) is checked.

0. **Bundle ID gate:** Confirm [upload-ready exit criteria](#exit-criteria-upload-ready) are met — especially **Distribution** archive for `jp.studio-prospect.prexus.ios` (Xcode/script alignment alone is insufficient).
1. Bump `CFBundleShortVersionString` / `CFBundleVersion` per [naming table](#version-and-tag-naming-proposals-only).
2. Regenerate Xcode project **with** llama artifact present (device linkage).
3. Xcode → **Product → Archive** (Release, generic iOS device).
4. Validate archive: **Distribution** signing for the **final** Bundle ID, embedded `llama.framework`, no debug-only traps.
5. **Distribute App** → App Store Connect → upload to the app record that matches section G.
6. In ASC: select build, add **internal** testers group, paste What to Test (scope + model install + [tester instructions](./qwen_text_only_alpha_tester_instructions.md) URL/path).
7. After processing: confirm install on one A17 Pro+ device before widening the group.
8. Create git tag per [tag procedure](#git-tag-procedure-do-not-run-in-automation) on the archived commit.

**Not in scope:** App Store public listing, pricing, or review submission for production.

---

## Automated device smoke (`alpha_smoke_wang.sh`)

Canonical RC / TestFlight prep smoke for physical devices:

| Item | Detail |
| --- | --- |
| Path | [`tools/scripts/alpha_smoke_wang.sh`](../../tools/scripts/alpha_smoke_wang.sh) |
| Usage | `./tools/scripts/alpha_smoke_wang.sh "<DeviceNameSubstring>"` |
| Scenarios | `with_model`, `no_model`, `sensitivity_matrix` |
| Logs | `.eval-logs/wang-alpha-smoke-*.json` |
| Also documented in | [release_readiness](./qwen_text_only_alpha_release_readiness.md), [release_notes](./qwen_text_only_alpha_release_notes.md), [tester_instructions](./qwen_text_only_alpha_tester_instructions.md) |

For day-to-day debug without TestFlight, [`install_on_device.sh`](../../tools/scripts/install_on_device.sh) builds and installs Debug; TestFlight archives should still be preceded by `alpha_smoke_wang.sh` on Release-equivalent device bits.

---

## Post-upload tester onboarding (minimal)

Send internal testers:

1. TestFlight invite link (ASC).
2. Link or PDF export of [tester instructions](./qwen_text_only_alpha_tester_instructions.md).
3. One-line model setup: GGUF via team push or documented `Documents/Models/` placement.
4. Hardware expectation: A17 Pro-class+ for real Qwen; others get embedded heuristic only.
5. Feedback channel (issue template / Slack — team choice; not defined in repo).

---

## Sign-off

**Upload-ready** (TestFlight binary may be uploaded) only when **all** are true:

1. Pre-TestFlight gate checklist sections **A–E** are checked.
2. **Section G (Bundle ID and signing)** is checked — formal ID decided, ASC app aligned, Distribution signing validated.
3. Version naming is recorded in ASC and matches proposed tag name.
4. Required device smoke (`alpha_smoke_wang.sh` or equivalent) passed on the build lineage intended for archive.

**Ready to execute prep work** (smoke, docs, simulator tests) when A–E pass. Section G **Xcode/ASC** items may be complete while **Distribution** items remain open.

After upload, additionally confirm:

5. At least one internal tester device installed via TestFlight and completed one chat turn.

Tagging and upload remain **manual**; this document only defines the procedure.
