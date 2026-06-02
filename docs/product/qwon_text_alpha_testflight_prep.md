# QWON Text Alpha — TestFlight Preparation (Phase 3)

**Last updated:** 2026-06-02  
**Status:** **Prep only** — Apple gate and TestFlight upload **not executed**. Repo defaults to `jp.studio-prospect.qwon.ios` after Phase 2 merge (#48).

**Historical line:** PREXUS alpha `0.1.0 (1)` on `jp.studio-prospect.prexus.ios` remains frozen — see [Qwen text-only alpha TestFlight prep](./qwen_text_only_alpha_testflight_prep.md). **Do not** upload QWON builds to ASC app **PREXUS** (Apple ID `6775110218`).

**Related:** [QWON rename migration plan](./qwon_rename_migration_plan.md) · [QWON bundle memo](./qwon_bundle_id_decision_memo.md) · [PREXUS bundle memo](./bundle_id_decision_memo.md) (historical)

---

## Product ops status (QWON line)

| Item | Owner | Status | Action |
| --- | --- | --- | --- |
| Repo Bundle ID + scripts | Engineering | **Done** (Phase 2, #48) | `generate_xcodeproj.rb`, device scripts, committed `project.pbxproj` |
| Display name | Engineering | **Done** (Phase 1, #47) | `CFBundleDisplayName` = **QWON** |
| Apple gate (App ID, profiles, ASC app) | Release engineering | **Pending** | [Apple gate checklist](#apple-gate-checklist-operator) |
| Distribution archive (QWON bundle + llama) | Release engineering | **Pending** | [Distribution archive validation](#distribution-archive-validation-not-executed) |
| Device smoke on QWON bundle | Release engineering | **Pending** | [`alpha_smoke_wang.sh`](../../tools/scripts/alpha_smoke_wang.sh) on `jp.studio-prospect.qwon.ios` |
| TestFlight upload | Release engineering | **Not started** | [Upload outline](#testflight-upload-outline-operator) |
| Git tag | Release engineering | **Not created** | Proposed: `qwon-text-alpha-0.1.0-rc1` on archived commit |
| Ops evidence folder | Release engineering | **Path decided** | `~/QWON-alpha-evidence/qwon-text-0.1.0-build1/` (no overwrite of PREXUS build `1` paths) |

**Version proposal (first QWON TestFlight):** marketing `0.1.0`, build `1` (matches current `Info.plist`; bump build only on respin).

**Explicitly out of scope:** App Store public release; PREXUS alpha **build `2`**; rewriting PREXUS frozen ledger or upload history.

---

## Apple gate checklist (operator)

Complete before [upload outline](#testflight-upload-outline-operator). Record outcomes in [QWON bundle memo](./qwon_bundle_id_decision_memo.md) when issued.

| Step | Status | Notes |
| --- | --- | --- |
| Register App ID `jp.studio-prospect.qwon.ios` | [ ] | Apple Developer → Identifiers |
| Development provisioning profile | [ ] | e.g. `DevelopmentQWON_YYYYMMDD` |
| App Store / Distribution provisioning profile | [ ] | e.g. `AppStoreQWON_YYYYMMDD` |
| **New** ASC app record for **QWON** | [ ] | **Not** PREXUS (`6775110218`) |
| ASC Apple ID for QWON app | [ ] | Record in bundle memo when created |
| Distribution archive validates for QWON bundle | [ ] | Release + `app-store-connect` export |
| Internal TestFlight group on **QWON** app | [ ] | Suggest reusing policy: **Wang + Matisse only** (`internal_tester` or equivalent on new app) |

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

- [ ] `./tools/scripts/fetch_local_model.sh` — `models/prexus-local-mvp.gguf` (filename unchanged; path in [models/README](../../models/README.md))
- [ ] `./tools/scripts/build_llama_xcframework.sh` — `vendor/llama-cpp-artifacts/llama.xcframework` (local only)
- [ ] `ruby tools/scripts/generate_xcodeproj.rb` **with** llama present for **device** archive only

### C. Required device smoke

```bash
./tools/scripts/alpha_smoke_wang.sh "Wang"
```

Pass criteria unchanged from [PREXUS prep smoke table](./qwen_text_only_alpha_testflight_prep.md#c-required-device-smoke-alpha_smoke_wangsh). Script already targets `jp.studio-prospect.qwon.ios` (Phase 2).

Store copies under `~/QWON-alpha-evidence/qwon-text-0.1.0-build1/` (gitignored logs: `.eval-logs/wang-alpha-smoke-*.json`).

### D. GGUF for testers

- [ ] `./tools/scripts/push_local_model_to_device.sh "Wang"` (and Matisse if testing llama there)
- [ ] ASC “What to Test” states model is **not** bundled in IPA

---

## Distribution archive validation (not executed)

Local Release archive checklist for **QWON** bundle after profiles exist. Do not claim TestFlight until export succeeds.

Prerequisites: `fetch_local_model.sh`, `build_llama_xcframework.sh`, regenerate project **with** llama (local only).

```bash
cd app/ios
xcodebuild -project PREXUS.xcodeproj -scheme PREXUS \
  -configuration Release -destination 'generic/platform=iOS' \
  -archivePath ../../.archive/QWON-0.1.0.xcarchive archive
```

Validate:

| Check | Expected |
| --- | --- |
| Bundle ID in archive | `jp.studio-prospect.qwon.ios` |
| Display name | QWON |
| Signing | **Distribution** profile for QWON (not PREXUS profile names) |
| Embedded llama | `llama.framework` present when built with xcframework |
| Export | Organizer → Distribute → **App Store Connect** → upload targets **QWON** ASC app only |

Record date, profile names, and export result in this section when executed (operator PR or comment on Phase 3 upload PR).

---

## TestFlight upload outline (operator)

**Do not start** until [Apple gate](#apple-gate-checklist-operator) and [distribution validation](#distribution-archive-validation-not-executed) pass.

1. Confirm `CFBundleShortVersionString` / `CFBundleVersion` (`0.1.0` / `1` unless product bumps).
2. Regenerate Xcode project **with** llama for device linkage (local).
3. **Product → Archive** (Release, generic iOS device).
4. Validate Distribution signing for `jp.studio-prospect.qwon.ios`.
5. Upload to **QWON** ASC app record (new Apple ID — fill in bundle memo).
6. Assign build to internal group (**Wang + Matisse** policy).
7. Paste [ASC What to Test](#asc-what-to-test-copy) + link [PREXUS-era tester instructions](./qwen_text_only_alpha_tester_instructions.md) until QWON-specific copy exists.
8. Reinstall on Wang + Matisse; capture evidence under `~/QWON-alpha-evidence/qwon-text-0.1.0-build1/`.
9. Tag archived commit: `qwon-text-alpha-0.1.0-rc1` (manual; not in automation).
10. Docs-only follow-up: ledger subsection for QWON build `1` (new doc or appendix — **do not** edit PREXUS frozen ledger).

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
