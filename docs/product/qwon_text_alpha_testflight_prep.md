# QWON Text Alpha — TestFlight Preparation (Phase 3)

**Last updated:** 2026-06-03
**Status:** **Active lab build `0.1.0 (3)`** on TestFlight — intentional Product / release engineering upload after Phase 4E docs gate (#65); ops executed outside repo before this record. Build `2` (keyboard fix) and build `1` + tag `qwon-text-alpha-0.1.0-rc1` are **previous active / historical**. ASC `6775685841`.

**Historical line:** PREXUS alpha `0.1.0 (1)` on `jp.studio-prospect.prexus.ios` remains frozen — see [Qwen text-only alpha TestFlight prep](./qwen_text_only_alpha_testflight_prep.md). **Do not** upload QWON builds to ASC app **PREXUS** (Apple ID `6775110218`).

**Related:** [QWON rename docs index](./qwon_rename_docs_index.md) · [QWON next work queue](./qwon_next_work_queue.md) · [QWON feedback intake](./qwon_text_alpha_feedback_intake.md) · [QWON rename migration plan](./qwon_rename_migration_plan.md) · [QWON bundle memo](./qwon_bundle_id_decision_memo.md) · [QWON lab evidence](./qwon_text_alpha_lab_evidence.md) · [PREXUS bundle memo](./bundle_id_decision_memo.md) (historical)

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
| TestFlight upload (build `2`) | Release engineering | **Done** (2026-06-02) | [Build 2 — keyboard fix](#testflight-build-2-2026-06-02) · `main` `1bac472` — **previous active** |
| TestFlight upload (build `3`) | Release engineering | **Done** (2026-06-02) | [Build 3 — Phase 4E ops upload](#testflight-build-3-2026-06-02) — intentional Product/RE upload |
| Lab TestFlight install (Wang + Matisse) | Release engineering | **Done** (build `1`, 2026-06-02) | [Wang](#wang-testflight-verification-2026-06-02) · [Matisse](#matisse-testflight-verification-2026-06-02) |
| Lab build `2` verification | Release engineering | **Done** (2026-06-02) | Return **sends** on Wang + Matisse — [build 2 record](#testflight-build-2-2026-06-02) · [tier policy](#physical-device-lab-tier-policy) |
| Lab build `3` verification | Release engineering | **Pending** | Wang smoke **pending** · Matisse spot check **pending** — [build 3 record](#testflight-build-3-2026-06-02) |
| Wang GGUF on build `3` | Release engineering | **Pending / unconfirmed** | Check `Documents/Models/prexus-local-mvp.gguf` on Wang after TestFlight update |
| Export compliance (ASC) | Release engineering | **Done** (build `2`, 2026-06-02) | [Export compliance gate](#export-compliance-operator-gate) — required before build `2` TestFlight install |
| Git tag | Release engineering | **Done** (2026-06-02) | `qwon-text-alpha-0.1.0-rc1` on `d4f2a0b` — [tag record](#git-tag-2026-06-02) |
| Ops evidence folder | Release engineering | **In use** | [QWON build `1` ledger](./qwon_text_alpha_lab_evidence.md#frozen-ledger-qwon-010-build-1) — Chat PNGs on file |
| ASC What to Test | Release engineering | **Done** (2026-06-02) | [Copy block](#asc-what-to-test-copy) pasted to internal builds `1` and `2` |
| QWON build `1` frozen ledger | Release engineering | **Done** (2026-06-02) | [lab evidence](./qwon_text_alpha_lab_evidence.md#frozen-ledger-qwon-010-build-1) — PREXUS ledger untouched |

**Active build:** marketing `0.1.0`, **`CFBundleVersion` `3`** on TestFlight. Committed `Info.plist` on `main` may still show `2` until a separate bump PR — upload binary is **`0.1.0 (3)`**.

**Explicitly out of scope:** App Store public release; **PREXUS** alpha **build `2`** (separate product line — not this QWON build `2`); rewriting PREXUS frozen ledger or upload history; **build `4`** without product gate.

---

## Phase 4 build 3 decision gate

**Context:** Phase 4 internal rename (#59–#64) is complete for active target/scheme **`QWON`**, sources **`app/ios/QWON/`**, tests **`QWONTests`** / **`QWONUITests`**, Swift module **`QWON`**, and active docs/scripts narrative (#64). Still **preserved/deferred:** project container **`PREXUS.xcodeproj`**, runtime **`PREXUS_*`** env/compile flags, model file **`prexus-local-mvp.gguf`**, **`PREXUSLiteRTEval`**.

**4E docs gate:** Documented in [#65](./qwon_phase4_target_rename_plan.md#pr-4e--optional-archive-smoke-decision-gate). **Not an accident:** Product / release engineering executed **archive + TestFlight upload** as **ops outside this repo** before docs caught up. Treat as **intentional build `3` upload**, not a docs-only gate violation.

**Current TestFlight:** marketing **`0.1.0`**, **`CFBundleVersion` `3`** — **active lab build** (Wang TestFlight install confirmed 2026-06-02).

**Pending verification (no fabricated results):**

| Item | Status |
| --- | --- |
| Archive commit / IPA path in git | **Not recorded** — ops artifact outside repo |
| Wang `alpha_smoke_wang.sh` on build `3` | **Pending** |
| Matisse install + spot check on build `3` | **Pending** |
| Wang GGUF (`Documents/Models/prexus-local-mvp.gguf`) | **Pending / unconfirmed** — Fallback on Wang observed; verify file exists after TestFlight update |
| Export compliance (ASC) for build `3` | **Not re-verified in docs** — installable on Wang implies processing cleared |

**Build `4`:** **Not approved.** Triage and feedback intake alone do not authorize a new binary.

### Historical: when build `3` was gated (pre-upload)

Phase 4E asked whether to produce a **build `3` candidate** to validate rename closure. **Upload has since occurred** — see [build 3 record](#testflight-build-3-2026-06-02). Retained for audit trail:

Proceed only if **all** entry gates in [Phase 4E plan](./qwon_phase4_target_rename_plan.md#pr-4e--optional-archive-smoke-decision-gate) are true **and** at least one motivator applies:

- Need **Distribution archive/export proof** on the post-rename QWON target/module/scheme.
- Need **Wang primary + Matisse secondary** device evidence tied to rename closure.
- There is a **clear product reason** for testers to receive a new binary (not rename docs alone).

### When build `3` was deferred (historical — superseded by upload)

- **No release blocker** on TestFlight **`0.1.0 (2)`**.
- Rename impact is **repo/docs/scripts only** — testers see no functional delta.
- Avoid extra **TestFlight operational cost** (export compliance, internal processing, lab time).

### Build `3` numbering rules (applied)

| Rule | Detail |
| --- | --- |
| Line | **QWON** ASC `6775685841` / `jp.studio-prospect.qwon.ios` only |
| Version | Marketing **`0.1.0`** unless product bumps marketing version separately |
| Build number | **`CFBundleVersion` `3`** — uploaded to ASC |
| Not to be confused with | **PREXUS** historical alpha **build `2`** (separate product line — never uploaded for PREXUS) |
| Tag | **Optional** and **separate** from upload; build `1` tag `qwon-text-alpha-0.1.0-rc1` remains on archive commit `d4f2a0b` |
| Upload | **Done** (2026-06-02) — intentional Product/RE; lab smoke evidence **pending** |

### Minimal 4E operator checklist (reference — build `3` upload done; smoke pending)

1. No-llama committed `project.pbxproj` on archive commit.
2. Local llama: `fetch_local_model.sh` · `build_llama_xcframework.sh` · `generate_xcodeproj.rb` (do not commit llama pbxproj).
3. Release archive + export — [Distribution archive validation](#distribution-archive-validation-2026-06-02).
4. Wang: `alpha_smoke_wang.sh` (primary).
5. Matisse: install + launch crash-free (secondary tier).
6. Update [QWON lab evidence](./qwon_text_alpha_lab_evidence.md) — build `3` row when executed.
7. Upload — **done** for build `3`; tag only if product approves separately.

Full criteria: [Phase 4 target rename plan — PR 4E](./qwon_phase4_target_rename_plan.md#pr-4e--optional-archive-smoke-decision-gate).

---

## TestFlight build 3 (2026-06-02)

**Purpose:** Phase 4E ops — post-rename QWON binary on TestFlight. **Intentional** Product / release engineering upload after 4E docs gate; archive/upload executed **outside repo** before this documentation record. **Not treated as an accident.**

| Field | Value |
| --- | --- |
| Version | `0.1.0` (build **`3`**) |
| Repo commit (archive) | **Not recorded in git** — ops outside repo; `main` `Info.plist` may still show `CFBundleVersion` `2` |
| Change vs build `2` | Post–Phase 4 rename closure binary (not keyboard-only) |
| ASC app | **QWON** (`6775685841`) |
| Upload | **Done** — Wang TestFlight shows **`0.1.0 (3)`** (2026-06-02) |
| Wang TestFlight install | **Confirmed** (2026-06-02) |
| Wang GGUF | **Pending / unconfirmed** — verify `Documents/Models/prexus-local-mvp.gguf`; Fallback observed if absent (TestFlight container may retain Documents across update; reinstall may clear) |
| Wang smoke (`alpha_smoke_wang.sh`) | **Pending** — no recorded pass on build `3` |
| Matisse spot check | **Pending** |
| PREXUS alpha build `2` | **Unrelated** — do not conflate with QWON line |

**Observed on Wang (2026-06-02, not triage-logged):** Runtime Diagnostics shows **Fallback** + *llama.cpp runtime waiting for a GGUF model asset* — consistent with **GGUF unconfirmed**; not logged as triage row in this PR.

No new git tag for build `3` unless product adds one later.

**Previous active:** [build `2`](#testflight-build-2-2026-06-02) (keyboard Return → Send).

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
xcodebuild -project PREXUS.xcodeproj -scheme QWON \
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
xcodebuild -project PREXUS.xcodeproj -scheme QWON \
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
| `0.1.0 (2)` | 2026-06-02 | **Re-submission required** — was pending; **submitted 2026-06-02** | Wang + Matisse — Return sends (secondary tier) — **previous active** |
| `0.1.0 (3)` | 2026-06-02 | **Not re-verified in docs** — Wang installable | Wang install confirmed; Matisse **pending** |

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

Archive validation and build `1` upload are **done** (2026-06-02). **Build `2`** uploaded same day (keyboard fix). **Build `3`** uploaded same day (Phase 4E ops). Operator steps for **future builds**:
1. [x] Upload to **QWON** ASC (`6775685841`) — [build 1](#testflight-upload-2026-06-02) · [build 2](#testflight-build-2-2026-06-02) · [build 3](#testflight-build-3-2026-06-02).
2. [x] Complete **export compliance** in ASC when prompted — [gate notes](#export-compliance-operator-gate) (build `2` required re-submission; build `3` not re-verified in docs).
3. [x] Internal TestFlight access for **Wang + Matisse** — build `1` full lab; build `2` install on both ([tier policy](#physical-device-lab-tier-policy)).
4. [ ] Build `3` lab verification — Wang smoke + Matisse spot check **pending**; Wang GGUF **pending / unconfirmed**.
5. [x] Paste [ASC What to Test](#asc-what-to-test-copy) — build `3` may include [feedback intake template](./qwon_text_alpha_feedback_intake.md#copy-paste-template) excerpt (review copy for testers).
6. [x] Build `1`: Wang + Matisse Chat verified (2026-06-02). Build `2`: Return-key **sends** on Wang + Matisse (2026-06-02).
7. [x] Tag archive commit `d4f2a0b`: `qwon-text-alpha-0.1.0-rc1` — [record](#git-tag-2026-06-02) (build `1` only).
8. [x] [QWON build `1` frozen ledger](./qwon_text_alpha_lab_evidence.md#frozen-ledger-qwon-010-build-1) — **do not** edit [PREXUS frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1).

**Re-upload / respin:** Confirm version/build bump, re-archive with llama locally, validate, then upload to **QWON** ASC only.

**Not in scope:** Public App Store listing; uploading to PREXUS bundle; PREXUS alpha build `2`.

---

## ASC What to Test copy

**Applied 2026-06-02** to **QWON** ASC (`6775685841`) internal TestFlight builds **`0.1.0 (1)`**, **`0.1.0 (2)`**, and **`0.1.0 (3)`**. Re-paste when marketing version or lab policy changes.

Link testers to [QWON feedback intake](./qwon_text_alpha_feedback_intake.md) (report template and triage). Manual lab steps still align with [PREXUS-era tester instructions](./qwen_text_only_alpha_tester_instructions.md) where not yet duplicated for QWON copy.

```text
QWON 0.1.0 — text-only alpha on jp.studio-prospect.qwon.ios (internal lab: Wang primary + Matisse secondary).

- Display name: QWON. Not the historical PREXUS TestFlight app (jp.studio-prospect.prexus.ios).
- Active build: 0.1.0 (3) — post–Phase 4 rename closure binary. Build 2 (keyboard fix) and build 1 (tag qwon-text-alpha-0.1.0-rc1) are previous.
- Local Qwen path (Wang / A17 Pro+): developer USB push of prexus-local-mvp.gguf required (see repo models/README). Not bundled in the IPA. Verify Documents/Models/prexus-local-mvp.gguf after TestFlight update.
- Matisse (A12): may show Embedded Heuristic even with GGUF — expected on secondary tier; not a failure.
- Report issues using the QWON feedback intake template — device model, iOS version, TestFlight build 0.1.0 (3), and Settings → Runtime Diagnostics screenshot filename.
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
