# Qwen Text-Only Alpha — TestFlight Preparation

**Status:** TestFlight **0.1.0 (1)** verified on **Wang** (llama.cpp) and **Matisse** (Embedded Heuristic). Physical lab is **two devices only**; keep ASC group **`internal_tester`** aligned with that lab. **Not** an App Store public submission.

This doc records the RC-to-internal-TestFlight steps and provides copy for **lab-only** tester onboarding (Wang + Matisse).

| Doc | Role |
| --- | --- |
| [qwen_text_only_alpha_release.md](./qwen_text_only_alpha_release.md) | Alpha scope and exclusions |
| [qwen_text_only_alpha_release_readiness.md](./qwen_text_only_alpha_release_readiness.md) | RC code readiness (merged) |
| [qwen_text_only_alpha_release_notes.md](./qwen_text_only_alpha_release_notes.md) | Tester-facing limitations |
| [qwen_text_only_alpha_tester_instructions.md](./qwen_text_only_alpha_tester_instructions.md) | Manual tester flow |
| [qwen_text_only_alpha_lab_evidence.md](./qwen_text_only_alpha_lab_evidence.md) | Two-device evidence fields, retention rules, frozen ledger |
| [bundle_id_decision_memo.md](./bundle_id_decision_memo.md) | Approved Bundle ID, owned domain, post-decision gates |
| [models/README.md](../../models/README.md) | GGUF placement |

---

## Product ops status (from RC checklist)

RC **code** criteria are satisfied on `main` (PR #22). Internal TestFlight distribution is complete for alpha 0.1.0:

| Item | Owner | Status | Action |
| --- | --- | --- | --- |
| **Formal Bundle ID + ASC app + signing** | Product / release engineering | **Done** | Distribution + Wang smoke + upload 2026-05-31 |
| Version / build numbers aligned with alpha naming | Release engineer | **Done** | `0.1.0` / build `1` uploaded; tag `qwen-text-alpha-0.1.0-rc1` on `a021475` |
| Device archive with llama.cpp linked | Release engineer | **Validated locally** | See [Distribution archive validation](#distribution-archive-validation-2026-05-31); repeat after each release-changing commit |
| Required device smoke green | Release engineer | **Done** (2026-05-31 Wang) | [`alpha_smoke_wang.sh`](#automated-device-smoke-alpha_smoke_wangsh) — all three scenarios on `jp.studio-prospect.prexus.ios` |
| GGUF available to testers | Ops + testers | Ready | Developers push `prexus-local-mvp.gguf` with `push_local_model_to_device.sh` per tester |
| Git release tag | Release engineer | **Done** | `qwen-text-alpha-0.1.0-rc1` (2026-05-31) |
| TestFlight upload + internal group | Release engineer | **Done** | Build `0.1.0 (1)` on **`internal_tester`** (1 build, 2 testers) |
| First TestFlight install on device | Wang + Matisse | **Done** | Wang: llama.cpp after GGUF push; Matisse: Embedded Heuristic (A12) — see [device lab](#physical-device-lab-ops-policy) |
| Tester onboarding text | Product ops | **Ready** | Use updated [ASC What to Test](#asc-what-to-test-copy) and [onboarding message](#tester-onboarding-message); **do not widen** `internal_tester` beyond the two lab devices without a new A17+ phone |

**Explicitly out of scope for this alpha:** App Store public release, LiteRT production, L2 selector, OCR/compression/audio/camera, in-app model download UX.

**Current release state:** internal TestFlight alpha is distribution-ready. **Ops policy:** regression and evidence collection stay on the [two-device lab](#physical-device-lab-ops-policy) until a new physical iPhone is available; do not invite extra ASC testers who cannot receive a developer GGUF push.

---

## Bundle ID and signing gate (blocking TestFlight)

The **formal Bundle ID is decided** (`jp.studio-prospect.prexus.ios`). Distribution signing, upload, and internal group **`internal_tester`** are configured; confirm at least one TestFlight install before widening testers.

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
- [x] Internal TestFlight group **`internal_tester`** with build `0.1.0` / `1` assigned (was 0 builds — blocker resolved).

### Xcode / script gate (complete after migration PR)

Repo and device scripts reference the formal ID. **Previous placeholder:** `com.prexus.ios` — uninstall old builds on test devices before Debug smoke.

### After Distribution archive validates

- Proceed with Wang / device smoke on the **new** Bundle ID (uninstall old `com.prexus.ios` builds first).
- Distribute alpha 0.1.0 only to internal testers.
- Keep public App Store submission out of scope.
- Collect diagnostics screenshots from **Wang** and **Matisse** only (see [device lab](#physical-device-lab-ops-policy)).

---

## Physical device lab (ops policy)

**As of 2026-05-31:** the team has **two** USB-capable lab iPhones. All alpha validation, GGUF push, and `internal_tester` membership should treat this set as authoritative.

| Device | Model | Chip | iOS (verified) | Role in alpha |
| --- | --- | --- | --- | --- |
| **Wang** | iPhone 17 | A17 Pro+ | (TestFlight verified) | **Primary** — real Qwen via `llama.cpp` after `push_local_model_to_device.sh "Wang"`; `alpha_smoke_wang.sh` three scenarios |
| **Matisse** | iPhone XS Max | A12 | **18.7.9** | **Secondary** — non–A17 Pro path; Chat chip **Local runtime** + backend **Embedded Heuristic Runtime** even with GGUF; crash-free Diagnostics |

### ASC `internal_tester` group

- **Keep membership to the two lab device owners** (Wang + Matisse) unless product explicitly adds a **new physical device** to the lab.
- If you must add an ASC email without a lab phone, state in onboarding that **llama.cpp Qwen requires a developer USB push on an A17 Pro+ device**; otherwise expect **Embedded Heuristic** only (Matisse-class behavior).
- **Do not** interpret “ready to onboard additional testers” (below) as inviting arbitrary ASC users without hardware + GGUF push capacity.

### Regression focus (until a third device exists)

1. Re-install or upgrade TestFlight build on **both** devices when build number changes.
2. **Wang:** one Chat turn with GGUF → confirm **Local runtime** / `answered_by=llama.cpp On-Device Runtime` in **Settings → Recent Runtime Decisions** (screen title: **Runtime Diagnostics**).
3. **Matisse:** one Chat turn → confirm **Local runtime** primary chip + **Embedded Heuristic Runtime** backend/model (Chat or Diagnostics); no crash; capture Diagnostics screenshot.
4. Optional on **Wang only:** re-run `./tools/scripts/alpha_smoke_wang.sh "Wang"` before each TestFlight respin.

**Evidence:** use [lab evidence](./qwen_text_only_alpha_lab_evidence.md) for field list, Wang/Matisse expectations, screenshot naming, and the **frozen ledger** for `0.1.0 (1)`. Store PNG/logs **outside git** (`on file (ops)` in docs only).

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
| Internal TestFlight group | **`internal_tester`** |
| Upload result | **Upload succeeded** (`xcodebuild -exportArchive`, `destination=upload`) |

**ASC state (2026-05-31):** export compliance completed; **`internal_tester`** shows **1 build** (`0.1.0` / `1`).

---

## Wang TestFlight verification (2026-05-31)

| Step | Result |
| --- | --- |
| TestFlight install `0.1.0 (1)` | Pass — TestFlight badge on device |
| First turn (no GGUF) | Pass — **Fallback** / Embedded Heuristic (expected) |
| `push_local_model_to_device.sh "Wang"` | Pass — `prexus-local-mvp.gguf` in Documents/Models |
| Second turn (with GGUF) | Pass — reply e.g. `Hello! How can I assist you today?`; banner **Local runtime** (`executionMode=local`, not Fallback) |

**UI note:** Chat banner **Local runtime** = `executionMode` local (see `ChatView`). Diagnostics detail may still show `answered_by=llama.cpp On-Device Runtime` for the full backend name.

## Matisse TestFlight verification (2026-05-31)

| Step | Result |
| --- | --- |
| TestFlight install `0.1.0 (1)` | Pass — `jp.studio-prospect.prexus.ios` |
| `push_local_model_to_device.sh "Matisse"` | Pass — GGUF in Documents/Models (379 MB) |
| Chat (`Hello PREXUS`) | Pass — primary chip **Local runtime**; secondary chip **Embedded Heuristic Runtime**; reply via on-device heuristics |
| Runtime Diagnostics | Pass — **Local runtime** badge; detail *Local lightweight fallback path without a packaged LLM.* (expected on A12; not llama.cpp) |

**Device:** iPhone XS Max (`iPhone11,6`), iOS **18.7.9**. Screenshots **on file (ops)** — see [frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1). Do **not** fail Matisse for missing llama.cpp — use Wang for Qwen path evidence.

**UI note (Matisse / A12):** Chat primary chip follows `executionMode` (**Local runtime** when local). **Embedded Heuristic Runtime** is the backend/model chip and Diagnostics detail — not the primary banner label (see `ChatView.runtimeBadgeRow`).

### New tester checklist (lab devices only)

**All lab testers**

1. Install from TestFlight (`internal_tester` — **lab members only**).
2. Connect iPhone to the development Mac (USB, unlocked, trusted).
3. Developer runs `./tools/scripts/push_local_model_to_device.sh "<DeviceName>"` (GGUF not in IPA).
4. Force-quit and relaunch PREXUS; send one short Chat message.
5. Open **Settings** (gear on Chat) → **Recent Runtime Decisions** → confirm **Runtime Diagnostics** matches your hardware row below.
6. Send back device model, iOS version, Diagnostics screenshot, and any crash/hang.

**Wang (A17 Pro+) — Qwen path**

- Expect Chat banner **Local runtime** and Diagnostics detail with **`answered_by=llama.cpp On-Device Runtime`** (after GGUF push).

**Matisse (A12 / pre–A17 Pro) — heuristic path**

- Expect Chat primary chip **Local runtime** plus secondary chip **Embedded Heuristic Runtime** (and caption *Local lightweight fallback path without a packaged LLM.*).
- Expect Runtime Diagnostics **Local runtime** badge with the same embedded-heuristic backend/detail — **Pass** if stable; llama.cpp is out of scope on this hardware.

### TestFlight に PREXUS が出ないとき

| Symptom | Typical fix |
| --- | --- |
| `internal_tester` shows **0 builds** | Manually add build `0.1.0 (1)` to the group after upload |
| Processing email received but no invite | Processing mail is for developers; invite sends after build is on the group |
| Build stuck 「提出準備中」 | Complete **export compliance** (exempt HTTPS → France **No** for extra declaration) |
| TestFlight empty on device | Tester must be **ASC team user**; Apple ID on phone must match |

---

## Wang device smoke (2026-05-31, pre-TestFlight)

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

**Distribution / upload:**

- [x] Distribution signing succeeds for `jp.studio-prospect.prexus.ios` ([2026-05-31](#distribution-archive-validation-2026-05-31)).
- [x] Internal TestFlight group **`internal_tester`** — **1 build** assigned.
- [x] First **TestFlight** install on Wang + local Qwen turn (2026-05-31).
- [x] Wang / device smoke on new ID (2026-05-31; `VALIDATION PASSED` for `with_model`, `no_model`, `sensitivity_matrix`).
- [ ] Uninstall any `com.prexus.ios` builds on additional test devices before re-smoking with new ID.

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

## ASC What to Test copy

Paste this into App Store Connect for the internal TestFlight build:

```text
PREXUS 0.1.0 is the Qwen text-only alpha (internal lab: two devices only).

Please verify:
1. Install the TestFlight build and launch PREXUS.
2. Connect your iPhone to the dev Mac; ask a developer to push prexus-local-mvp.gguf (not bundled in the IPA).
3. Restart PREXUS and ask one short text question in Chat.
4. Open Settings (gear) -> Recent Runtime Decisions (screen title: Runtime Diagnostics) and screenshot the latest entry.
5. On A17 Pro-class iPhones (e.g. iPhone 15 Pro+): confirm answered_by=llama.cpp On-Device Runtime after GGUF push.
6. On older iPhones (e.g. XS Max / A12): confirm Local runtime chip plus Embedded Heuristic Runtime backend/detail (not llama.cpp) and no crash.
7. Optional on A17 Pro+ only: try four sensitivity modes once each; confirm no crash.

Known limitations:
- Only lab devices receive developer GGUF push; do not join TestFlight without coordinating with the release engineer.
- A17 Pro-class hardware is recommended for real Qwen; other devices use embedded heuristic only.
- Text-only alpha: no OCR, camera, audio, compression, model download UX, or LiteRT production routing.

Report device model, iOS version, build 0.1.0 (1), GGUF pushed (yes/no), and a Runtime Diagnostics screenshot.
```

## Tester onboarding message

Send this to internal testers:

```text
PREXUS 0.1.0 alpha is on TestFlight for the internal lab (Wang + Matisse devices only).

If you are not one of those two lab phones, do not install yet — we cannot push the GGUF model or verify llama.cpp without a dev Mac session.

Setup (lab devices):
1. Install PREXUS from TestFlight (internal_tester).
2. Connect your iPhone to the dev Mac (USB, unlocked).
3. Ask a developer to run:
   ./tools/scripts/push_local_model_to_device.sh "<your device name>"
4. Force-quit and reopen PREXUS.
5. Send one short Chat message (e.g. "Hello PREXUS").
6. Open Settings -> Recent Runtime Decisions (Runtime Diagnostics screen).

What to confirm:
- iPhone 15 Pro / 16 / 17 class (A17 Pro+): latest entry should show answered_by=llama.cpp On-Device Runtime after GGUF push.
- Older iPhones (e.g. XS Max): expect Local runtime chip plus Embedded Heuristic Runtime backend/detail — still a pass if there is no crash.

Please send back:
- Device model and iOS version
- Whether the reply worked
- Screenshot of Runtime Diagnostics
- Any crash, hang, or confusing UI text

Scope: text-only local alpha. No in-app model download; OCR, camera, audio, and cloud matrix are out of scope.
```

## Post-upload tester onboarding (minimal)

For the **two-device lab** only:

1. Ensure ASC group **`internal_tester`** lists **only** Wang and Matisse owners (remove stray invites).
2. Send the [onboarding message](#tester-onboarding-message) above (includes lab-only warning).
3. Link [tester instructions](./qwen_text_only_alpha_tester_instructions.md).
4. Schedule USB session for `push_local_model_to_device.sh` per device name.
5. Collect Diagnostics screenshots from **both** devices; store with device model + iOS version.
6. Feedback channel (issue template / Slack — team choice; not defined in repo).

**Do not** add ASC testers who lack a lab device and dev Mac GGUF push.

---

## Sign-off

**Upload-ready** (TestFlight binary may be uploaded) is complete for alpha 0.1.0:

1. Pre-TestFlight gate checklist sections **A–E** are checked.
2. **Section G (Bundle ID and signing)** is checked — formal ID decided, ASC app aligned, Distribution signing validated.
3. Version naming is recorded in ASC and matches tag name.
4. Required device smoke or equivalent Wang TestFlight verification passed on the uploaded build lineage.

**Ready for internal lab testing:** yes — **Wang + Matisse** both completed one chat turn (2026-05-31). Ops evidence complete per [frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) (diagnostics PNGs on file for both lab devices).

**Do not widen `internal_tester`** beyond the lab until a new physical iPhone is added to the device table above.

Tagging and upload were performed manually; this document records the completed state and the repeatable tester-onboarding procedure.
