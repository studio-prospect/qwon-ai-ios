# QWON Text Alpha — TestFlight Preparation (Phase 3)

**Last updated:** 2026-06-02
**Status:** **Active lab build `0.1.0 (2)`** on TestFlight (keyboard Return → Send fix). Build `1` baseline + tag `qwon-text-alpha-0.1.0-rc1` remain historical. ASC `6775685841`.

**Historical line:** PREXUS alpha `0.1.0 (1)` on `jp.studio-prospect.prexus.ios` remains frozen — see [Qwen text-only alpha TestFlight prep](./qwen_text_only_alpha_testflight_prep.md). **Do not** upload QWON builds to ASC app **PREXUS** (Apple ID `6775110218`).

**Related:** [QWON rename migration plan](./qwon_rename_migration_plan.md) · [QWON bundle memo](./qwon_bundle_id_decision_memo.md) · [QWON lab evidence](./qwon_text_alpha_lab_evidence.md) · [PREXUS bundle memo](./bundle_id_decision_memo.md) (historical)

---

## Product ops status (QWON line)

| Item | Owner | Status | Action |
| --- | --- | --- | --- |
| Repo Bundle ID + scripts | Engineering | **Done** (Phase 2, #48) | `generate_xcodeproj.rb`, device scripts, committed `project.pbxproj` |
| Display name | Engineering | **Done** (Phase 1, #47) | `CFBundleDisplayName` = **QWON** |
| Apple gate (App ID, profiles, ASC app) | Release engineering | **Done** (2026-06-02) | [Apple gate checklist](#apple-gate-checklist-operator) · ASC `6775685841` |
| Distribution archive (QWON bundle + llama) | Release engineering | **Done** (2026-06-02) | [Distribution archive validation](#distribution-archive-validation-2026-06-02) |
| Device smoke on QWON bundle | Release engineering | **Done** (2026-06-02, Wang) | [`alpha_smoke_wang.sh`](../../tools/scripts/alpha_smoke_wang.sh) — `VALIDATION PASSED` |
| TestFlight upload (build `1`) | Release engineering | **Done** (2026-06-02) | [TestFlight upload — build 1](#testflight-upload-2026-06-02) |
| TestFlight upload (build `2`) | Release engineering | **Done** (2026-06-02) | [Build 2 — keyboard fix](#testflight-build-2-2026-06-02) · `main` `1bac472` |
| Lab TestFlight install (Wang + Matisse) | Release engineering | **Done** (build `1`, 2026-06-02) | [Wang](#wang-testflight-verification-2026-06-02) · [Matisse](#matisse-testflight-verification-2026-06-02) |
| Lab build `2` verification | Release engineering | **Done** (2026-06-02) | Return **sends** on Wang + Matisse — [build 2 record](#testflight-build-2-2026-06-02) · [tier policy](#physical-device-lab-tier-policy) |
| Export compliance (ASC) | Release engineering | **Done** (build `2`, 2026-06-02) | [Export compliance gate](#export-compliance-operator-gate) — required before build `2` TestFlight install |
| Git tag | Release engineering | **Done** (2026-06-02) | `qwon-text-alpha-0.1.0-rc1` on `d4f2a0b` — [tag record](#git-tag-2026-06-02) |
| Ops evidence folder | Release engineering | **In use** | [QWON build `1` ledger](./qwon_text_alpha_lab_evidence.md#frozen-ledger-qwon-010-build-1) — Chat PNGs on file |
| ASC What to Test | Release engineering | **Done** (2026-06-02) | [Copy block](#asc-what-to-test-copy) pasted to internal builds `1` and `2` |
| QWON build `1` frozen ledger | Release engineering | **Done** (2026-06-02) | [lab evidence](./qwon_text_alpha_lab_evidence.md#frozen-ledger-qwon-010-build-1) — PREXUS ledger untouched |

**Active build:** marketing `0.1.0`, **`CFBundleVersion` `2`** on `main` (keyboard fix). Bump build number for each TestFlight binary upload.

**Explicitly out of scope:** App Store public release; **PREXUS** alpha **build `2`** (separate product line — not this QWON build `2`); rewriting PREXUS frozen ledger or upload history.

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
| Internal TestFlight group on **QWON** app | [x] | Wang + Matisse in ASC; build `1` full lab on both; build `2` install + Return-key on both — [tier policy](#physical-device-lab-tier-policy) |

---

## Physical device lab (tier policy)

Two-device lab inherited from PREXUS alpha — see [PREXUS prep — device lab](./qwen_text_only_alpha_testflight_prep.md#physical-device-lab-ops-policy). **QWON alpha (2026-06-02):** per-build requirements are **tiered** — Wang primary, Matisse secondary.

| Device | Tier | Role |
| --- | --- | --- |
| **Wang** | **Primary** | llama.cpp after `push_local_model_to_device.sh`; `alpha_smoke_wang.sh` before upload when runtime changes; full Chat + Diagnostics on baseline / major builds |
| **Matisse** | **Secondary** | A12 / Embedded Heuristic path; **install + launch + crash-free** on every TestFlight build; full Diagnostics ledger on **baseline** builds only unless runtime changes |

### Per-build verification tiers

| Build class | Wang | Matisse |
| --- | --- | --- |
| **Baseline / runtime change** (e.g. build `1`, routing, model path) | Full — smoke script + TestFlight Chat + Diagnostics (`answered_by=llama.cpp`) | Full — TestFlight Chat + Diagnostics (**Local runtime** + **Embedded Heuristic**) |
| **Minor UX-only** (e.g. build `2` keyboard Return → Send) | Feature check on TestFlight + prior smoke lineage | TestFlight **install + Return sends** (not newline); no new Diagnostics ledger required |

**ASC `internal_tester`:** keep **Wang + Matisse** membership. Matisse remains in the group for install/regression on secondary tier; do not widen beyond the two lab devices without product decision.

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
| Git tag | `qwon-text-alpha-0.1.0-rc1` on `d4f2a0b` |
| Internal TestFlight group | **Wang + Matisse** — install confirmed via TestFlight (2026-06-02) |
| Upload result | **Upload succeeded** (`xcodebuild -exportArchive`, `destination=upload`) |

**Phase 3 build `1` baseline complete** (2026-06-02). Optional: additional Diagnostics PNGs in ops folder; ASC “What to Test” copy refresh.

**Not uploaded to:** PREXUS ASC (`6775110218`).

---

## Export compliance (operator gate)

After each upload, ASC may hold the build until **暗号化に関する輸出コンプライアンス** (export compliance / encryption) is answered. Upload success alone does not make the build installable on TestFlight.

| Build | Upload | Compliance | TestFlight install |
| --- | --- | --- | --- |
| `0.1.0 (1)` | 2026-06-02 | Completed at first upload | Wang + Matisse verified |
| `0.1.0 (2)` | 2026-06-02 | **Re-submission required** — was pending; **submitted 2026-06-02** | Wang + Matisse — Return sends (secondary tier) |

**Operator checklist (every new build):**

1. Upload succeeds (`Upload succeeded` in Xcode / `xcodebuild -exportArchive`).
2. ASC → **QWON** → TestFlight → select build → complete **輸出コンプライアンス** if status shows missing.
3. Wait for processing → assign build to internal group if not auto-assigned.
4. TestFlight app on device → **更新** → confirm version shows `(2)` etc.

Build `2` was uploaded while compliance was outstanding; devices stayed on build `1` until compliance was submitted — not an upload failure.

---

## TestFlight build 2 (2026-06-02)

**Purpose:** UX fix — soft keyboard Return **sends** instead of inserting a newline (PR #56, `f28d925` on `main`).

| Field | Value |
| --- | --- |
| Version | `0.1.0` (build **`2`**) |
| Repo commit (archive) | `1bac472` (`CFBundleVersion` bump + keyboard fix) |
| Change | Remove `TextField` `axis: .vertical`; `submitLabel(.send)` + `onSubmit` send on Return |
| ASC app | **QWON** (`6775685841`) |
| Archive (ops) | `.archive/QWON-0.1.0-build2.xcarchive` |
| Upload | **Upload succeeded** — compliance gating delayed install until submitted |
| Wang verification | **Pass** — Return sends message (not newline) on TestFlight build `2` |
| Matisse verification | **Pass** — Return sends (not newline); install + launch crash-free — [secondary tier](#physical-device-lab-tier-policy) |
| PREXUS alpha build `2` | **Unrelated** — do not conflate with QWON line |

No new git tag for build `2` (tag `qwon-text-alpha-0.1.0-rc1` remains on build `1` archive commit `d4f2a0b` unless product adds a build-2 tag later).

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

### Matisse build `2` verification (2026-06-02)

Secondary-tier check after export compliance cleared — UX-only build; no new Diagnostics ledger.

| Step | Result |
| --- | --- |
| TestFlight install `0.1.0 (2)` on **QWON** bundle | **Pass** |
| App launch (display name **QWON**) | **Pass** |
| Return key in Chat | **Pass** — **sends** message (not newline), same as Wang |

---

## TestFlight upload outline (operator)

Archive validation and build `1` upload are **done** (2026-06-02). **Build `2`** uploaded same day (keyboard fix). Operator steps for **future builds**:
1. [x] Upload to **QWON** ASC (`6775685841`) — [build 1](#testflight-upload-2026-06-02) · [build 2](#testflight-build-2-2026-06-02).
2. [x] Complete **export compliance** in ASC when prompted — [gate notes](#export-compliance-operator-gate) (build `2` required re-submission).
3. [x] Internal TestFlight access for **Wang + Matisse** — build `1` full lab; build `2` install on both ([tier policy](#physical-device-lab-tier-policy)).
4. [x] Paste [ASC What to Test](#asc-what-to-test-copy) + link [PREXUS-era tester instructions](./qwen_text_only_alpha_tester_instructions.md) until QWON-specific copy exists — **done** 2026-06-02.
5. [x] Build `1`: Wang + Matisse Chat verified (2026-06-02). Build `2`: Return-key **sends** on Wang + Matisse (2026-06-02).
6. [x] Tag archive commit `d4f2a0b`: `qwon-text-alpha-0.1.0-rc1` — [record](#git-tag-2026-06-02) (build `1` only).
7. [x] [QWON build `1` frozen ledger](./qwon_text_alpha_lab_evidence.md#frozen-ledger-qwon-010-build-1) — **do not** edit [PREXUS frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1).

**Re-upload / respin:** Confirm version/build bump, re-archive with llama locally, validate, then upload to **QWON** ASC only.

**Not in scope:** Public App Store listing; uploading to PREXUS bundle; PREXUS alpha build `2`.

---

## ASC What to Test copy

**Applied 2026-06-02** to **QWON** ASC (`6775685841`) internal TestFlight builds **`0.1.0 (1)`** and **`0.1.0 (2)`**. Re-paste when marketing version or lab policy changes.

Link testers to [PREXUS-era tester instructions](./qwen_text_only_alpha_tester_instructions.md) (feedback template and Diagnostics steps) until QWON-specific onboarding exists.

```text
QWON 0.1.0 — text-only alpha on jp.studio-prospect.qwon.ios (internal lab: Wang primary + Matisse secondary).

- Display name: QWON. Not the historical PREXUS TestFlight app (jp.studio-prospect.prexus.ios).
- Active build: 0.1.0 (2) — keyboard Return sends the message (does not insert a newline). Build 1 baseline is tagged qwon-text-alpha-0.1.0-rc1.
- Local Qwen path (Wang / A17 Pro+): developer USB push of prexus-local-mvp.gguf required (see repo models/README). Not bundled in the IPA.
- Matisse (A12): may show Embedded Heuristic even with GGUF — expected on secondary tier; not a failure.
- Report issues with device model, iOS version, TestFlight build number, and Settings → Runtime Diagnostics screenshot.
```

---

## Git tag (2026-06-02)

| Field | Value |
| --- | --- |
| Tag | `qwon-text-alpha-0.1.0-rc1` |
| Commit | `d4f2a0b` (archive source; Apple gate docs on `main`) |
| Pushed | `origin` (2026-06-02) |
| Notes | First QWON-bundle TestFlight; separate from `qwen-text-alpha-0.1.0-rc1` (PREXUS) |

```bash
git tag -a qwon-text-alpha-0.1.0-rc1 d4f2a0b -m "QWON text alpha 0.1.0 build 1 (TestFlight internal, archive commit)"
git push origin qwon-text-alpha-0.1.0-rc1
```

---

## Git tag procedure (historical — executed 2026-06-02)

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

Canonical ledger: [QWON lab evidence](./qwon_text_alpha_lab_evidence.md). PREXUS ledger: [historical](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) — **immutable**.

| Build | Ops path (outside git) | Ledger |
| --- | --- | --- |
| QWON `0.1.0 (1)` | `~/QWON-alpha-evidence/qwon-text-0.1.0-build1/` | [Frozen — build 1](./qwon_text_alpha_lab_evidence.md#frozen-ledger-qwon-010-build-1) |
| QWON `0.1.0 (2)` | Spot-check on device (Return key) | [Spot check — not frozen](./qwon_text_alpha_lab_evidence.md#build-2-spot-check-2026-06-02--not-frozen-ledger) |
| PREXUS `0.1.0 (1)` (historical) | `~/PREXUS-alpha-evidence/qwen-text-0.1.0-build1/` | [PREXUS frozen](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) |

No PNG, IPA, GGUF, or logs in git. Docs reference filenames as `on file (ops)` only.
