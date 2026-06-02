# QWON Text Alpha — TestFlight Preparation (Phase 3)

**Last updated:** 2026-06-02
**Status:** **Wang + Matisse TestFlight lab verified** (2026-06-02). **Git tag** **pending**. ASC `6775685841`.

**Historical line:** PREXUS alpha `0.1.0 (1)` on `jp.studio-prospect.prexus.ios` remains frozen — see [Qwen text-only alpha TestFlight prep](./qwen_text_only_alpha_testflight_prep.md). **Do not** upload QWON builds to ASC app **PREXUS** (Apple ID `6775110218`).

**Related:** [QWON rename migration plan](./qwon_rename_migration_plan.md) · [QWON bundle memo](./qwon_bundle_id_decision_memo.md) · [PREXUS bundle memo](./bundle_id_decision_memo.md) (historical)

---

## Product ops status (QWON line)

| Item | Owner | Status | Action |
| --- | --- | --- | --- |
| Repo Bundle ID + scripts | Engineering | **Done** (Phase 2, #48) | `generate_xcodeproj.rb`, device scripts, committed `project.pbxproj` |
| Display name | Engineering | **Done** (Phase 1, #47) | `CFBundleDisplayName` = **QWON** |
| Apple gate (App ID, profiles, ASC app) | Release engineering | **Done** (2026-06-02) | [Apple gate checklist](#apple-gate-checklist-operator) · ASC `6775685841` |
| Distribution archive (QWON bundle + llama) | Release engineering | **Done** (2026-06-02) | [Distribution archive validation](#distribution-archive-validation-2026-06-02) |
| Device smoke on QWON bundle | Release engineering | **Done** (2026-06-02, Wang) | [`alpha_smoke_wang.sh`](../../tools/scripts/alpha_smoke_wang.sh) — `VALIDATION PASSED` |
| TestFlight upload | Release engineering | **Done** (2026-06-02) | [TestFlight upload record](#testflight-upload-2026-06-02) · ASC `6775685841` |
| Lab TestFlight install (Wang + Matisse) | Release engineering | **Done** (2026-06-02) | [Wang](#wang-testflight-verification-2026-06-02) llama.cpp · [Matisse](#matisse-testflight-verification-2026-06-02) Embedded Heuristic |
| Git tag | Release engineering | **Not created** | Proposed: `qwon-text-alpha-0.1.0-rc1` on archive commit `d4f2a0b` |
| Ops evidence folder | Release engineering | **Path decided** | `~/QWON-alpha-evidence/qwon-text-0.1.0-build1/` (no overwrite of PREXUS build `1` paths) |

**Version proposal (first QWON TestFlight):** marketing `0.1.0`, build `1` (matches current `Info.plist`; bump build only on respin).

**Explicitly out of scope:** App Store public release; PREXUS alpha **build `2`**; rewriting PREXUS frozen ledger or upload history.

---

## Apple gate checklist (operator)

**Completed 2026-06-02** for App ID, profiles, and ASC app record. Canonical values: [QWON bundle memo](./qwon_bundle_id_decision_memo.md).

Complete [distribution validation](#distribution-archive-validation-2026-06-02) before [upload outline](#testflight-upload-outline-operator).

| Step | Status | Notes |
| --- | --- | --- |
| Register App ID `jp.studio-prospect.qwon.ios` | [x] | **Done** 2026-06-02 |
| Development provisioning profile | [x] | `DevelopmentQWON_20260602` — expires **2026-10-07** |
| App Store / Distribution provisioning profile | [x] | `AppStoreQWON_20260602` — expires **2026-10-07** |
| **New** ASC app record for **QWON** | [x] | Apple ID `6775685841` — **not** PREXUS (`6775110218`) |
| ASC Apple ID for QWON app | [x] | `6775685841` |
| ASC categories | [x] | Primary **ユーティリティ** / Secondary **仕事効率化** |
| Distribution archive validates for QWON bundle | [x] | **Done** 2026-06-02 — [validation record](#distribution-archive-validation-2026-06-02) |
| Internal TestFlight group on **QWON** app | [ ] | Assign build `0.1.0 (1)` to **Wang + Matisse** group in ASC — **not done in repo** |

---

## Physical device lab (unchanged policy)

Same two-device lab as PREXUS alpha — see [PREXUS prep — device lab](./qwen_text_only_alpha_testflight_prep.md#physical-device-lab-ops-policy).

| Device | Role under QWON bundle |
| --- | --- |
| **Wang** | Primary — llama.cpp after `push_local_model_to_device.sh`; `alpha_smoke_wang.sh` three scenarios |
| **Matisse** | Secondary — Embedded Heuristic acceptable; crash-free Diagnostics |

**Before first QWON Debug/TestFlight install:** uninstall `jp.studio-prospect.prexus.ios` and legacy `com.prexus.ios` builds on lab phones to avoid confusion.

---

## Pre-TestFlight gate (repo + device)

Run on `main` after Apple gate profiles exist locally.

### A. Simulator / unit tests (no llama in git)

```bash
ruby tools/scripts/generate_xcodeproj.rb
cd app/ios
xcodebuild -project PREXUS.xcodeproj -scheme PREXUS \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' \
  -derivedDataPath ../../.derivedData-release test
```

Committed `project.pbxproj` must remain **no-llama** (Matisse/no-artifact policy). Do not commit llama-linked pbxproj.

### B. Device build prerequisites (Qwen / llama path)

- [x] `./tools/scripts/fetch_local_model.sh` — `models/prexus-local-mvp.gguf` (2026-06-02 validation)
- [x] `./tools/scripts/build_llama_xcframework.sh` — `vendor/llama-cpp-artifacts/llama.xcframework` (local only)
- [x] `ruby tools/scripts/generate_xcodeproj.rb` **with** llama present for **device** archive only (do not commit llama-linked pbxproj)

### C. Required device smoke

```bash
./tools/scripts/alpha_smoke_wang.sh "Wang"
```

Pass criteria unchanged from [PREXUS prep smoke table](./qwen_text_only_alpha_testflight_prep.md#c-required-device-smoke-alpha_smoke_wangsh). **2026-06-02:** `./tools/scripts/alpha_smoke_wang.sh "Wang"` on `jp.studio-prospect.qwon.ios` — **`VALIDATION PASSED`** (`with_model`, `no_model`, `sensitivity_matrix`).

Store copies under `~/QWON-alpha-evidence/qwon-text-0.1.0-build1/` (gitignored logs: `.eval-logs/wang-alpha-smoke-*.json`).

### D. GGUF for testers

- [ ] `./tools/scripts/push_local_model_to_device.sh "Wang"` (and Matisse if testing llama there)
- [ ] ASC “What to Test” states model is **not** bundled in IPA

---

## Distribution archive validation (2026-06-02)

Local Release archive + **App Store Connect export** on `main` at `d4f2a0b` (no TestFlight upload). Prerequisites: `fetch_local_model.sh`, `build_llama_xcframework.sh`, then `ruby tools/scripts/generate_xcodeproj.rb` **with** `llama.xcframework` present (local only — do not commit llama-linked `project.pbxproj`).

```bash
cd app/ios
xcodebuild -project PREXUS.xcodeproj -scheme PREXUS \
  -destination 'generic/platform=iOS' -configuration Release \
  -archivePath ../../.archive/QWON-0.1.0.xcarchive \
  DEVELOPMENT_TEAM=BWSS94LH28 CODE_SIGN_STYLE=Automatic \
  -allowProvisioningUpdates archive

xcodebuild -exportArchive \
  -archivePath ../../.archive/QWON-0.1.0.xcarchive \
  -exportPath ../../.archive/QWON-Export \
  -exportOptionsPlist ../../.archive/ExportOptions-appstore.plist \
  -allowProvisioningUpdates
```

`ExportOptions-appstore.plist` (local, not in git): `method` = `app-store-connect`, `teamID` = `BWSS94LH28`, `signingStyle` = `automatic`.

| Check | Result |
| --- | --- |
| Archive | **ARCHIVE SUCCEEDED** |
| Export | **EXPORT SUCCEEDED** |
| Bundle ID in archive | `jp.studio-prospect.qwon.ios` |
| Display name | **QWON** |
| Version / build | `0.1.0` / `1` |
| Embedded llama | `llama.framework` present |
| IPA signature | `Apple Distribution: studio PROSPECT, Inc (BWSS94LH28)` — cert expires **2026-10-07** |
| Export profile (automatic) | `iOS Team Store Provisioning Profile: jp.studio-prospect.qwon.ios` |
| Named profiles (gate) | `AppStoreQWON_20260602` / `DevelopmentQWON_20260602` registered locally |
| IPA path (ops, not in git) | `.archive/QWON-Export/PREXUS.ipa` — uploaded 2026-06-02 via [TestFlight upload](#testflight-upload-2026-06-02) |

Re-run after version bumps or runtime changes intended for TestFlight. Upload must target **QWON** ASC (`6775685841`) only — **not** PREXUS (`6775110218`).

---

## TestFlight upload (2026-06-02)

Uploaded from archive built on `main` at `d4f2a0b` (Distribution validation commit; docs-only commits after archive do not require re-archive unless runtime changes).

```bash
xcodebuild -exportArchive \
  -archivePath .archive/QWON-0.1.0.xcarchive \
  -exportPath .archive/QWON-Upload \
  -exportOptionsPlist .archive/ExportOptions-upload.plist \
  -allowProvisioningUpdates
```

`ExportOptions-upload.plist` (local, not in git): `destination` = `upload`, `method` = `app-store-connect`, `teamID` = `BWSS94LH28`.

| Field | Value |
| --- | --- |
| Version | `0.1.0` (build `1`) |
| Bundle ID | `jp.studio-prospect.qwon.ios` |
| ASC app | **QWON** (Apple ID `6775685841`) |
| Archive commit | `d4f2a0b` |
| Git tag | _pending_ — proposed `qwon-text-alpha-0.1.0-rc1` |
| Internal TestFlight group | _pending_ — assign in ASC (**Wang + Matisse** policy) |
| Upload result | **Upload succeeded** (`xcodebuild -exportArchive`, `destination=upload`) |

**Still pending after upload:** git tag; optional Diagnostics screenshots in ops folder.

**Not uploaded to:** PREXUS ASC (`6775110218`).

---

## Wang TestFlight verification (2026-06-02)

| Step | Result |
| --- | --- |
| TestFlight install `0.1.0 (1)` on **QWON** bundle | **Pass** |
| App launch (display name **QWON**) | **Pass** |
| GGUF on device (`prexus-local-mvp.gguf`) | **Pass** — required for llama.cpp path on TestFlight build |
| Chat turn with local route | **Pass** — prompt: *6月最初の満月は何日？*; model replied (alpha accuracy not gated) |
| UI: primary chip | **Local runtime** |
| UI: backend chip | **llama.cpp On-Device Runtime** |
| Executed route | **Local** · Tier 2 · Prefer · Local default |
| Screenshot (ops, not in git) | `~/QWON-alpha-evidence/qwon-text-0.1.0-build1/wang-qwon-testflight-chat-2026-06-02.png` |

**UI note:** Same as [PREXUS Wang verification](./qwen_text_only_alpha_testflight_prep.md#wang-testflight-verification-2026-05-31) — **Local runtime** banner = `executionMode=local`; backend name may read `llama.cpp On-Device Runtime` in detail.

## Matisse TestFlight verification (2026-06-02)

| Step | Result |
| --- | --- |
| TestFlight install `0.1.0 (1)` on **QWON** bundle | **Pass** |
| App launch (display name **QWON**) | **Pass** |
| Chat turn with local route | **Pass** — prompt: *6月最初の満月は何日？*; embedded heuristic reply (expected on A12) |
| UI: primary chip | **Local runtime** |
| UI: backend chip | **Embedded Heuristic Runtime** |
| Backend detail | *Local lightweight fallback path without a packaged LLM.* |
| Executed route | **Local** · Tier 2 · Prefer · Local default |
| Screenshot (ops, not in git) | `~/QWON-alpha-evidence/qwon-text-0.1.0-build1/matisse-qwon-testflight-chat-2026-06-02.png` |

**Expected on A12:** Matisse does **not** use llama.cpp even with GGUF; **Embedded Heuristic Runtime** is acceptable — same policy as [PREXUS Matisse verification](./qwen_text_only_alpha_testflight_prep.md#matisse-testflight-verification-2026-05-31).

---

## TestFlight upload outline (operator)

Archive validation and initial upload are **done** (2026-06-02). Remaining operator steps:
1. [x] Upload to **QWON** ASC (`6775685841`) — [record](#testflight-upload-2026-06-02).
2. [ ] Complete export compliance in ASC if prompted.
3. [ ] Assign build `0.1.0 (1)` to internal group (**Wang + Matisse** policy).
4. [ ] Paste [ASC What to Test](#asc-what-to-test-copy) + link [PREXUS-era tester instructions](./qwen_text_only_alpha_tester_instructions.md) until QWON-specific copy exists.
5. [x] Wang + Matisse TestFlight Chat verified (2026-06-02); screenshots on file under `~/QWON-alpha-evidence/qwon-text-0.1.0-build1/`.
6. [ ] Tag archive commit `d4f2a0b`: `qwon-text-alpha-0.1.0-rc1` (manual; not in automation).
7. [ ] Docs-only follow-up: ledger subsection for QWON build `1` (new doc or appendix — **do not** edit PREXUS frozen ledger).

**Re-upload / respin:** Confirm version/build bump, re-archive with llama locally, validate, then upload to **QWON** ASC only.

**Not in scope:** Public App Store listing; uploading to PREXUS bundle; PREXUS alpha build `2`.

---

## ASC What to Test copy (draft)

Paste into the **QWON** ASC app internal TestFlight build:

```text
QWON 0.1.0 is the text-only alpha on a new bundle (internal lab: Wang + Matisse only).

- Display name: QWON. Not the historical PREXUS TestFlight app.
- Local Qwen path requires developer USB push of prexus-local-mvp.gguf (see repo models/README).
- Matisse (A12) may show Embedded Heuristic even with GGUF; that is expected.
- Report issues with device model, iOS version, and Settings → Runtime Diagnostics screenshot.
```

---

## Git tag procedure (do not run in automation)

| Field | Proposed value |
| --- | --- |
| Tag | `qwon-text-alpha-0.1.0-rc1` |
| Commit | Exact commit archived for TestFlight |
| Notes | First QWON-bundle upload; separate from `qwen-text-alpha-0.1.0-rc1` (PREXUS) |

```bash
git tag -a qwon-text-alpha-0.1.0-rc1 <commit> -m "QWON text alpha 0.1.0 build 1 (TestFlight internal)"
git push origin qwon-text-alpha-0.1.0-rc1
```

---

## Evidence retention

| Build | Ops path (outside git) |
| --- | --- |
| QWON `0.1.0 (1)` | `~/QWON-alpha-evidence/qwon-text-0.1.0-build1/` |
| PREXUS `0.1.0 (1)` (historical) | `~/PREXUS-alpha-evidence/qwen-text-0.1.0-build1/` — **immutable** |

No PNG, IPA, GGUF, or logs in git. Docs reference filenames as `on file (ops)` only.
