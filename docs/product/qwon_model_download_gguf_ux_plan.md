# QWON - Model Download / GGUF UX - Scoped Plan

**Last updated:** 2026-06-06
**Status:** **Scoped plan** - implementation, spike, Build `4`, TestFlight upload, tag, version bump, GGUF commit, and filename migration are **not approved** by this document.
**Purpose:** Define the safe implementation boundary for reducing QWON text-alpha model acquisition friction after [Product selected Model download / GGUF UX](./qwon_model_download_gguf_ux_decision.md). This plan turns that lane decision into a staged UX/ops path without changing the current runtime contract.

Related: [Decision memo](./qwon_model_download_gguf_ux_decision.md) · [models/README.md](../../models/README.md) · [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) · [QWON lab evidence](./qwon_text_alpha_lab_evidence.md) · [UI polish / onboarding](./qwon_ui_polish_onboarding_plan.md) · [Preserved PREXUS inventory](./qwon_preserved_prexus_surface_inventory.md)

---

## Baseline (do not override)

| Field | Value |
| --- | --- |
| **Active TestFlight** | **QWON `0.1.0 (3)`** - stable alpha |
| **Build `4`** | **Not approved** |
| **Current local model file** | `prexus-local-mvp.gguf` - preserved until a dedicated migration PR |
| **Current default local model** | Qwen2.5-0.5B-Instruct Q4_K_M (`~379-400 MB`) |
| **Current placement contract** | `PREXUS_LOCAL_MODEL_PATH` -> app bundle `prexus-local-mvp.gguf` -> on-device `Documents/Models/prexus-local-mvp.gguf` |
| **Wang path** | A17 Pro+ tier; GGUF present; expected backend is `llama.cpp On-Device Runtime` |
| **Matisse path** | A12 tier; Embedded Heuristic Runtime is expected; GGUF is optional/not required |
| **Model binaries** | Not committed to git; stored locally or on device only |

---

## Product Goal

Reduce model-acquisition friction before tester expansion while preserving QWON alpha stability.

| Goal | Intended result |
| --- | --- |
| **Tester clarity** | A tester can understand whether the local model is present and what to do if it is missing. |
| **Ops reliability** | Release engineering can verify model placement without ad-hoc screenshots or ambiguous fallback reports. |
| **Runtime safety** | Missing, corrupt, or unsupported model states still fall back without crash. |
| **Scope control** | Guided placement and status UX can ship before any fully in-app download work. |

---

## Non-goals

| Do not do | Reason |
| --- | --- |
| Bundle or commit GGUF files | Model weights remain git-excluded and ops/device-local. |
| Rename `prexus-local-mvp.gguf` | Preserved filename; migration needs a separate product-approved PR. |
| Rename `PREXUS_LOCAL_MODEL_*` env vars | Preserved runtime/script contracts. |
| Change `LocalGGUFModelPlacement` order in the first implementation PR | Current lookup order is the stability contract. |
| Add LiteRT, OCR, memory retention, or backend selector work | Separate post-alpha lanes. |
| Claim "fully offline" or "fully in-app download" until implementation proves it | QWON is local-first, not offline-only; guided ops may still be required. |
| Approve Build `4`, TestFlight upload, tag, or version bump | Release engineering gate remains separate. |

---

## Current USB Push Flow

Today, QWON alpha relies on release engineering or developer ops to place the GGUF file.

| Step | Command / surface | Result |
| --- | --- | --- |
| 1 | `./tools/scripts/fetch_local_model.sh` | Downloads `models/prexus-local-mvp.gguf` locally. |
| 2 | `./tools/scripts/build_llama_xcframework.sh` + `ruby tools/scripts/generate_xcodeproj.rb` | Prepares llama.cpp local builds for device validation when needed. |
| 3 | `./tools/scripts/install_on_device.sh "Wang"` | Installs debug/device build for smoke workflows. |
| 4 | `./tools/scripts/push_local_model_to_device.sh "Wang"` | Copies the GGUF into the app sandbox as `Documents/Models/prexus-local-mvp.gguf`. |
| 5 | TestFlight/manual smoke | Confirms Chat local runtime and Diagnostics `answered_by=llama.cpp On-Device Runtime`. |

### Current tester pain

| Pain | Consequence |
| --- | --- |
| USB push is outside TestFlight | New testers cannot self-serve local Qwen setup. |
| Missing GGUF looks like fallback behavior | Wang can be misread as broken unless Diagnostics are checked. |
| Filename remains PREXUS-branded | Correct but surprising; global rename would break placement. |
| Manual evidence lives in ops folders | Repo docs need filename-only ledger entries, not artifacts. |

---

## Placement Contract

The plan preserves the current `LocalGGUFModelPlacement` lookup order until a scoped implementation explicitly changes it:

1. `PREXUS_LOCAL_MODEL_PATH` environment variable, absolute path.
2. App bundle resource `prexus-local-mvp.gguf`, optional debug packaging.
3. On-device `Documents/Models/prexus-local-mvp.gguf`.

### Contract rules

| Rule | Requirement |
| --- | --- |
| Filename | Keep `prexus-local-mvp.gguf` for QWON alpha. |
| Location | Guided placement must target `Documents/Models/prexus-local-mvp.gguf`. |
| Discovery | UI may read/reflect model availability, but must not silently alter lookup order in the first PR. |
| Migration | Any future `qwon-local-mvp.gguf` rename needs migration design for already-pushed devices. |
| Env vars | Keep `PREXUS_LOCAL_MODEL_PATH`, `PREXUS_LOCAL_MODEL_SOURCE`, and `PREXUS_LOCAL_MODEL_DEST` unless a dedicated env migration lands. |

---

## Integrity And Storage Requirements

Any future download or guided-placement implementation must treat model availability as a state machine, not a boolean.

| State | Meaning | Required UX / runtime behavior |
| --- | --- | --- |
| `missing` | No file at resolved model path | Explain local model is not installed; fallback path is expected; no crash. |
| `present-unverified` | File exists but hash/size not confirmed | Show caution in Settings/Diagnostics; allow runtime attempt only if current code path already does so. |
| `verified` | File exists and expected hash/size match | Wang should use llama.cpp on supported hardware. |
| `partial` | Temporary or size-mismatch file | Do not present as installed; clean retry path required before download implementation. |
| `corrupt` | Hash mismatch or load failure | Keep file quarantined or report failure; fallback remains embedded heuristic. |
| `unsupported-device` | Device below required tier | Matisse path remains expected heuristic; do not encourage repeated model install attempts. |

### Minimum metadata for future implementation

| Metadata | Purpose |
| --- | --- |
| Expected byte size | Fast partial-file detection before hash. |
| SHA-256 | Integrity verification after copy/download. |
| Model family / quant label | User-readable Settings/Diagnostics copy. |
| Source URL or source label | Support reproducibility; do not expose unstable third-party URLs as product promises. |
| Verified timestamp | Ops/debugging evidence. |

### Storage constraints

| Constraint | Plan requirement |
| --- | --- |
| App sandbox storage | Check available space before download/copy UX claims success. |
| Temporary files | Use a temporary filename and atomic move for any future download. |
| Deletion | Do not add delete UX in the first implementation unless product explicitly gates it. |
| Backup | Model files should not be treated as user data requiring backup. |

---

## UX Options

### Option A - Guided placement/status UX (recommended first implementation)

Add Settings/Diagnostics surfaces that explain and verify the existing manual model path without adding network download.

| Field | Plan |
| --- | --- |
| User value | High; converts opaque ops state into actionable guidance. |
| Risk | Low-medium; mostly UI/status plus file presence/metadata reads. |
| Runtime change | None to lookup order or fallback chain. |
| Best first PR | Settings + Diagnostics model status card, copy, tests. |
| Exit evidence | Simulator copy tests; Wang with GGUF present; Wang with GGUF missing; Matisse expected heuristic copy. |

Recommended wording direction:

- "Local model file: installed / missing / unsupported on this device."
- "Wang-class devices can use Qwen locally after `prexus-local-mvp.gguf` is placed in Documents/Models."
- "Matisse-class devices may use Embedded Heuristic Runtime; this is expected for the alpha."
- Avoid "download in QWON" until actual in-app download exists.

### Option B - Guided external acquisition

Provide in-app or tester-doc guided steps for obtaining and placing the model while the actual transfer still happens outside QWON.

| Field | Plan |
| --- | --- |
| User value | Medium-high for internal testers. |
| Risk | Medium; copy must not imply QWON can complete the transfer alone. |
| Runtime change | None required. |
| Best PR timing | After Option A status UX proves model-state copy. |
| Key constraint | If USB/Mac ops remain required, state that clearly. |

### Option C - In-app HTTPS download (gated later)

Allow QWON to fetch the GGUF itself.

| Field | Plan |
| --- | --- |
| User value | Highest for tester expansion. |
| Risk | High; hosting, bandwidth, integrity, partial downloads, storage, backgrounding, and legal/distribution questions. |
| Runtime change | Likely storage/download manager plus model-state UI; lookup order may remain unchanged if file lands at `Documents/Models/prexus-local-mvp.gguf`. |
| Gate | Product + Codex implementation plan after Option A/B evidence. |
| Must not start if | No approved hosting URL, checksum policy, legal/distribution review, or device evidence plan. |

### Recommendation

Start with **Option A**. It directly reduces support ambiguity, does not require Build `4` by itself, and creates the evidence needed to decide whether Option B or C is worth implementing.

---

## Settings / Diagnostics Copy Plan

| Surface | Required content | Do not say |
| --- | --- | --- |
| Settings - Local Runtime | Model status, expected filename, device support tier, and where to check Diagnostics. | "Tap to download" unless download exists. |
| Runtime Diagnostics | `answered_by`, `primary_failure`, `fallback_reason`, model file state, and device-tier explanation. | "Matisse failed" when heuristic is expected. |
| Chat helper / fallback strip | Plain missing-model or heuristic-state explanation after fallback. | "Fully offline" or "Qwen unavailable forever." |
| Tester docs | Exact ops command and evidence filename conventions. | Anything implying GGUF is bundled in TestFlight. |

### Diagnostic mapping

| Diagnostic | Plain meaning |
| --- | --- |
| `answered_by=llama.cpp On-Device Runtime` | QWON answered with the local GGUF-backed runtime. |
| `answered_by=Embedded Heuristic Runtime` | QWON answered with the built-in fallback. Expected on older devices or when model is unavailable. |
| `primary_failure=model_asset_unavailable` | The GGUF was not found at the expected placement path. |
| `fallback_reason=embedded_heuristic` | Fallback answered after the primary local runtime could not. |

---

## Device Expectations

| Device tier | Expected behavior | Evidence requirement |
| --- | --- | --- |
| **Wang / A17 Pro+ primary** | With verified `prexus-local-mvp.gguf`, Chat should use local llama.cpp. Missing/corrupt file should fall back without crash. | Chat + Diagnostics screenshots/log names in ops storage; no PNG commit. |
| **Matisse / A12 secondary** | Embedded Heuristic Runtime is expected. GGUF install is optional and should not be required for pass. | Install/launch and copy sanity; full Diagnostics only for baseline/runtime changes. |
| **Simulator** | Simulator may use stub/fallback behavior; no GGUF runtime proof. | Copy/layout/tests only. |

---

## Fallback And Rollback

| Failure | Required behavior |
| --- | --- |
| Missing model | Existing embedded heuristic fallback; Diagnostics explains missing asset. |
| Corrupt model | Treat as unusable; fallback without crash; expose actionable diagnostic detail. |
| Partial download/copy | Do not mark installed; retry or guided re-copy required. |
| Unsupported device | Do not loop download prompts; explain heuristic path. |
| Future implementation regression | Roll back to manual USB push flow and existing placement contract. |

Rollback principle: the current build `3` path remains the known-good baseline. Any implementation PR must leave manual `push_local_model_to_device.sh "Wang"` usable.

---

## PR Split

### PR M1 - Model status UX and docs (recommended first)

| Field | Requirement |
| --- | --- |
| Status | **Merged** — [#86](https://github.com/studio-prospect/qwon-ai-ios/pull/86) · [post-merge verification](#pr-m1-post-merge-verification-2026-06-04) |
| Scope | Settings/Diagnostics status for model presence, filename, device tier, and fallback explanation. |
| Allowed | SwiftUI copy/status, read-only file presence/metadata helper, tests, docs. |
| Forbidden | Download manager, network fetch, filename/env migration, lookup-order change, Build `4`. |
| Validation | `generate_xcodeproj.rb`, simulator tests, Wang present/missing if device available. |

### PR M2 - Guided placement flow

| Field | Requirement |
| --- | --- |
| Status | **Merged** — [#88](https://github.com/studio-prospect/qwon-ai-ios/pull/88) · [post-merge verification](#pr-m2-post-merge-verification-2026-06-04) |
| Scope | Step-by-step guidance for internal testers and support, still using external ops/USB. |
| Allowed | Settings/help copy, tester instructions, optional copy-to-clipboard command text. |
| Forbidden | Claiming self-serve download; changing storage contract. |
| Gate | M1 merged and reviewed — **met** ([#86](https://github.com/studio-prospect/qwon-ai-ios/pull/86), [#87](https://github.com/studio-prospect/qwon-ai-ios/pull/87)). |

### PR M3 - In-app download spike (conditional)

| Field | Requirement |
| --- | --- |
| Status | **Gated** — [M3 readiness checklist](#m3-readiness-gate-checklist) must be satisfied before any spike PR |
| Scope | Prototype downloader only after hosting/checksum/legal/storage gates are answered. |
| Allowed | Spike branch/PR with explicit Product/Codex gate **after checklist sign-off**. |
| Forbidden | Shipping default UX, Build `4`, or TestFlight upload bundled with spike. |
| Gate | All rows in [M3 readiness gate checklist](#m3-readiness-gate-checklist) answered; Product + Codex explicit approval. |

**This checklist does not authorize M3 implementation.** It records prerequisites only.

---

## Acceptance Criteria

| Area | Criteria |
| --- | --- |
| Scope | Plan or implementation does not approve Build `4`, upload, tag, or version bump. |
| Model contract | `prexus-local-mvp.gguf` remains the active filename; `PREXUS_LOCAL_MODEL_PATH` remains valid. |
| Runtime behavior | Existing fallback chain remains intact; no backend selector or LiteRT changes. |
| Wang | GGUF present path is legible and verifies local llama.cpp. |
| Matisse | Heuristic expected path is not reported as failure. |
| Integrity | Any future download/copy implementation distinguishes missing, partial, corrupt, and verified states. |
| Evidence | Ops artifacts stay outside git; docs record filenames/results only. |

---

## Verification Plan

For this docs-only plan PR:

```sh
git diff --check
```

For PR M1 if implemented later:

```sh
ruby tools/scripts/generate_xcodeproj.rb
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' test
```

Recommended device evidence for implementation PRs:

| Scenario | Expected |
| --- | --- |
| Wang with GGUF present | Chat local answer; Diagnostics `answered_by=llama.cpp On-Device Runtime`. |
| Wang with GGUF missing/renamed locally | Fallback without crash; Diagnostics `primary_failure` + `fallback_reason=embedded_heuristic`. |
| Matisse | Install/launch; heuristic expected copy; no false failure. |
| iPhone SE width simulator | Status/copy surfaces fit without blocking Chat composer. |

---

## Cursor Handoff After This Plan Merges

Cursor may begin **PR M1 only** after this plan is merged and Product/Codex explicitly assigns it.

Initial task boundary for Cursor:

- Implement model status UX/copy in Settings and Runtime Diagnostics.
- Keep model lookup order and filename unchanged.
- Do not add network download.
- Do not add Build `4` release ops.
- Do not commit model binaries or artifacts.
- Preserve historical PREXUS docs and preserved runtime/env names.

Anything beyond M1 requires a new Product/Codex gate.

---

## PR M1 Implementation Evidence

| Field | Result |
| --- | --- |
| Branch | `feat/qwon-m1-model-status-ux` |
| Scope | Settings + Runtime Diagnostics read-only model status/copy only |
| Runtime changes | None to lookup order, filename, env names, routing, or LiteRT |
| Download | Not implemented |

### Surfaces added

| Surface | Content |
| --- | --- |
| Settings → Local Runtime | Model status card: filename, `Documents/Models/prexus-local-mvp.gguf`, device tier chip, expected runtime label |
| Runtime Diagnostics | Same status card plus diagnostic mapping copy for `answered_by`, `primary_failure`, and `fallback_reason` |

### Validation commands

```sh
ruby tools/scripts/generate_xcodeproj.rb
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' test
git diff --check
```

### Automated coverage

| Test | Intent |
| --- | --- |
| `testQWONLocalModelStatusReportsMissingAtExpectedPath` | Wang-class missing copy + expected placement path |
| `testQWONLocalModelStatusReportsPresentUnverifiedAtDefaultPath` | Present-unverified + llama.cpp expectation |
| `testQWONLocalModelStatusUsesMatisseExpectedHeuristicCopy` | Matisse heuristic is expected, not failure |
| `testQWONLocalModelStatusUsesSimulatorCopy` | Simulator stub copy |

Device evidence (Wang present/missing, Matisse install) remains ops-side per plan; no PNG or GGUF commits in this PR.

---

## PR M1 post-merge verification (2026-06-04)

**Purpose:** Confirm merged model status UX from [PR #86](https://github.com/studio-prospect/qwon-ai-ios/pull/86) is visible and correctly worded on simulator and physical devices. **Evidence-only** — includes DEBUG `model_status` smoke export and ops helper script (`tools/scripts/m1_model_status_device_evidence.sh`); **no M2/M3 implementation**. DEBUG smoke runs under `#if DEBUG && !targetEnvironment(simulator)` and does not ship in Release/TestFlight.

**Base:** `origin/main` @ **`6894be7`** — `Surface QWON local model status before download work (#86)`.

### Merge state

| Field | Value |
| --- | --- |
| **PR** | [#86](https://github.com/studio-prospect/qwon-ai-ios/pull/86) merged · [#87](https://github.com/studio-prospect/qwon-ai-ios/pull/87) post-merge evidence |
| **PR #87 scope** | Evidence docs + DEBUG `model_status` smoke export + ops helper script — not M2/M3 |
| **Scope delivered** | Read-only model status card in Settings → Local Runtime and Runtime Diagnostics |
| **M2 guided placement** | **Merged** ([#88](https://github.com/studio-prospect/qwon-ai-ios/pull/88)) · [post-merge verification](#pr-m2-post-merge-verification-2026-06-04) |
| **M3 in-app download** | **Still gated** — not started |
| **Build `4` / TestFlight** | **Not approved** |

### Simulator verification

| Check | Device | Result |
| --- | --- | --- |
| Settings accessibility surface | iPhone 16 (iOS 18.4) | **Pass** — `settings.model-status` wired in merged `SettingsView` |
| Diagnostics accessibility surface | iPhone 16 (iOS 18.4) | **Pass** — `diagnostics.model-status` wired in merged `RuntimeDiagnosticsView` |
| Expected filename copy | Unit tests + merged card | **Pass** — `prexus-local-mvp.gguf` present in status card and copy helpers |
| Expected placement copy | Unit tests + merged card | **Pass** — `Documents/Models/prexus-local-mvp.gguf` present |
| Simulator runtime wording | `testQWONLocalModelStatusUsesSimulatorCopy` | **Pass** — Simulator Mock Runtime / stub copy |
| Matisse heuristic wording | `testQWONLocalModelStatusUsesMatisseExpectedHeuristicCopy` | **Pass** — Embedded Heuristic expected; no failure framing |
| Wang missing fallback wording | `testQWONLocalModelStatusReportsMissingAtExpectedPath` | **Pass** — missing + Embedded Heuristic fallback without crash language |
| Wang present-unverified wording | `testQWONLocalModelStatusReportsPresentUnverifiedAtDefaultPath` | **Pass** — Present (unverified) + llama.cpp On-Device Runtime |
| No download CTA in M1 copy | `testUILabelCopyPreservesAlphaOnboardingMeanings` | **Pass** — ModelStatus footer excludes “download” |
| Settings/Diagnostics navigation usability | iPhone 16 (iOS 18.4) UI tests | **Pass** — `QWONUITests` **TEST SUCCEEDED** |
| SE-width layout / wrap sanity | iPhone SE (3rd gen, iOS 18.2) UI tests | **Pass** — `QWONUITests` **TEST SUCCEEDED**; no navigation blocker observed |

### Commands run

```sh
git diff --check
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' \
  -only-testing:QWONTests/testQWONLocalModelStatusReportsMissingAtExpectedPath \
  -only-testing:QWONTests/testQWONLocalModelStatusReportsPresentUnverifiedAtDefaultPath \
  -only-testing:QWONTests/testQWONLocalModelStatusUsesMatisseExpectedHeuristicCopy \
  -only-testing:QWONTests/testQWONLocalModelStatusUsesSimulatorCopy \
  -only-testing:QWONTests/testUILabelCopyPreservesAlphaOnboardingMeanings test
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' \
  -only-testing:QWONUITests test \
  -resultBundlePath /tmp/qwon-m1-postmerge-iphone16.xcresult
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation),OS=18.2' \
  -only-testing:QWONUITests test \
  -resultBundlePath /tmp/qwon-m1-postmerge-iphonese.xcresult
```

**Results:** all commands **pass** (`** TEST SUCCEEDED **`).

### Device evidence (2026-06-04)

Physical devices connected via USB (unlocked). Debug build from `6894be7` + M1 model-status smoke export (`PREXUS_ALPHA_SMOKE_SCENARIO=model_status`).

| Scenario | Device | Result |
| --- | --- | --- |
| **Wang with GGUF present** | Wang (`iPhone18,3`, iOS 26.5.1) | **Pass** — `Present (unverified)` · `prexus-local-mvp.gguf` at expected path · `llama.cpp On-Device Runtime` |
| **Matisse heuristic expected** | Matisse (`iPhone11,6`, iOS 18.7.9) | **Pass** — `Matisse-class (A12)` · `Embedded Heuristic Runtime` · missing GGUF **not** framed as failure |

### Ops artifacts (not in git)

| Artifact | Location |
| --- | --- |
| Wang model-status JSON | `~/QWON-alpha-evidence/qwon-m1-post-merge/wang-m1-model-status.json` |
| Matisse model-status JSON | `~/QWON-alpha-evidence/qwon-m1-post-merge/matisse-m1-model-status.json` |
| iPhone 16 UI-test xcresult | `/tmp/qwon-m1-postmerge-iphone16.xcresult` |
| iPhone SE UI-test xcresult | `/tmp/qwon-m1-postmerge-iphonese.xcresult` |

Command used for device JSON export:

```sh
./tools/scripts/m1_model_status_device_evidence.sh "Wang"
./tools/scripts/m1_model_status_device_evidence.sh "Matisse"
```

Screenshots and JSON remain in ops storage; **not committed** per artifact rules.

### Outcome

M1 model status UX is **verified on simulator and physical devices** for visibility, placement copy, tier/runtime wording, and SE-width navigation sanity. **M2 merged** ([#88](https://github.com/studio-prospect/qwon-ai-ios/pull/88)); **M3** in-app download remains **gated**.

---

## PR M2 Implementation Evidence

| Field | Result |
| --- | --- |
| Branch | `feat/qwon-m2-guided-placement` |
| Scope | Settings → Local Runtime guided external placement (Mac + USB ops) |
| Download | **Not implemented** — copy states QWON cannot fetch GGUF in-app |
| Storage / lookup | Unchanged — `Documents/Models/prexus-local-mvp.gguf` contract preserved |

### Surfaces added

| Surface | Content |
| --- | --- |
| Settings → Local Runtime | **Place GGUF via Mac** navigation to step-by-step USB ops guide |
| Guided placement screen | Mac fetch + USB push commands with copy-to-clipboard; Wang/Matisse expectations; verify-in-Settings step |

### Copy-to-clipboard commands

| Command | Purpose |
| --- | --- |
| `./tools/scripts/fetch_local_model.sh` | Fetch GGUF on Mac |
| `./tools/scripts/push_local_model_to_device.sh "DEVICE_NAME"` | Push into app sandbox `Documents/Models/prexus-local-mvp.gguf` |

### Validation commands

```sh
ruby tools/scripts/generate_xcodeproj.rb
git diff --check
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' \
  -only-testing:QWONTests test
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' \
  -only-testing:QWONUITests/testSettingsGuidedPlacementFlowIsReachable test
```

Committed `PREXUS.xcodeproj` remains **no-llama**.

---

## PR M2 post-merge verification (2026-06-04)

**Purpose:** Confirm merged guided placement flow from [PR #88](https://github.com/studio-prospect/qwon-ai-ios/pull/88) is reachable and correctly worded on simulator and physical devices. **Evidence-only** — no M3 in-app download; **Build `4` not approved**.

**Base:** `origin/main` @ **`07ed9b5`** — `Add QWON guided GGUF placement flow (#88)`.

### Merge state

| Field | Value |
| --- | --- |
| **PR** | [#88](https://github.com/studio-prospect/qwon-ai-ios/pull/88) merged |
| **Scope delivered** | Settings → Local Runtime → **Place GGUF via Mac** with USB ops steps and copy-to-clipboard commands |
| **M3 in-app download** | **Still gated** — not started |
| **Build `4` / TestFlight** | **Not approved** |

### Simulator verification

| Check | Device | Result |
| --- | --- | --- |
| Settings → Place GGUF via Mac reachable | iPhone 16 (iOS 18.4) | **Pass** — `testSettingsGuidedPlacementFlowIsReachable` |
| Guided screen accessibility id | iPhone 16 | **Pass** — `settings.guided-placement` |
| `prexus-local-mvp.gguf` visible on guided screen | iPhone 16 UI test | **Pass** |
| `Documents/Models/prexus-local-mvp.gguf` in copy | `testGuidedPlacementCommandsTargetExpectedOpsScripts` | **Pass** |
| QWON does not download in-app wording | `testUILabelCopyPreservesAlphaOnboardingMeanings` + `GuidedPlacement` copy | **Pass** — no “tap to download”; intro states QWON cannot download in-app |
| Copy buttons wired | Merged UI (`settings.guided-placement.copy.fetch-model`, `.push-model`) | **Pass** — present in `#88` implementation |
| SE-width layout sanity | iPhone SE (3rd gen, iOS 18.2) UI test | **Pass** — `testSettingsGuidedPlacementFlowIsReachable` |

### Device verification (debug build @ `07ed9b5`)

| Scenario | Device | Result |
| --- | --- | --- |
| Debug install | Wang (`iPhone18,3`) · Matisse (`iPhone11,6`) | **Pass** — `install_on_device.sh` |
| Wang Local Model File + runtime expectation | Wang | **Pass** — `Present (unverified)` · `llama.cpp On-Device Runtime` · `Documents/Models/prexus-local-mvp.gguf` |
| Matisse heuristic expected (not failure) | Matisse | **Pass** — `Embedded Heuristic Runtime` · missing GGUF not framed as failure |
| Guided placement UI navigation on device | Wang · Matisse | **Not separately verified on device** — no device UI automation in this pass; guided placement reachability verified on simulator only |

### Commands run

```sh
git diff --check
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' \
  -only-testing:QWONUITests/testSettingsGuidedPlacementFlowIsReachable test \
  -resultBundlePath /tmp/qwon-m2-postmerge-iphone16.xcresult
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,id=79219540-9B52-4DDD-A3C4-35CBA6BFBD8A' \
  -only-testing:QWONUITests/testSettingsGuidedPlacementFlowIsReachable test \
  -resultBundlePath /tmp/qwon-m2-postmerge-iphonese.xcresult
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' \
  -only-testing:QWONTests/testGuidedPlacementCommandsTargetExpectedOpsScripts \
  -only-testing:QWONTests/testUILabelCopyPreservesAlphaOnboardingMeanings test
./tools/scripts/install_on_device.sh "Wang"
./tools/scripts/install_on_device.sh "Matisse"
./tools/scripts/m1_model_status_device_evidence.sh "Wang"
./tools/scripts/m1_model_status_device_evidence.sh "Matisse"
```

**Results:** all commands **pass** (`** TEST SUCCEEDED **` where applicable).

### Ops artifacts (not in git)

| Artifact | Location |
| --- | --- |
| iPhone 16 UI-test xcresult | `/tmp/qwon-m2-postmerge-iphone16.xcresult` |
| iPhone SE UI-test xcresult | `/tmp/qwon-m2-postmerge-iphonese.xcresult` |
| Wang model-status JSON (post-M2 debug) | `~/QWON-alpha-evidence/qwon-m2-post-merge/wang-m2-model-status.json` |
| Matisse model-status JSON (post-M2 debug) | `~/QWON-alpha-evidence/qwon-m2-post-merge/matisse-m2-model-status.json` |

Screenshots/JSON remain ops-side only.

### Outcome

M2 guided external placement is **verified on simulator** (reachability, placement copy, no in-app download claims). **Physical device evidence in this pass:** debug install + model-status JSON only (Wang/Matisse M1 contract holds after M2 merge). **M3** in-app download remains **gated**. **Build `4` not approved**.

---

## M3 readiness gate checklist

**Purpose:** After M1/M2 completion, record the **prerequisites** that must be satisfied before opening an **M3 in-app download spike**. This section is a **readiness gate only** — it does **not** approve M3 implementation, network fetch, storage schema work, or TestFlight upload.

**Base:** `origin/main` @ **`cccd9e3`** — M1/M2 merged ([#86](https://github.com/studio-prospect/qwon-ai-ios/pull/86)–[#89](https://github.com/studio-prospect/qwon-ai-ios/pull/89)).

### Lane status

| Field | Value |
| --- | --- |
| **M1 model status UX** | **Complete** — merged + verified |
| **M2 guided placement** | **Complete** — merged + verified |
| **M3 in-app download spike** | **Gated** — pending checklist |
| **Build `4` / TestFlight** | **Separate gate** — **not approved** by this checklist |

### Checklist (all required before M3 spike)

| # | Gate | Required evidence / decision | Status |
| --- | --- | --- | --- |
| 1 | **Model hosting source / URL ownership** | [Hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md) — Gate 1 section; dev ops HF URL documented as **not** product hosting. Named owner for hosting; approved HTTPS source URL or CDN path; no unstable third-party URLs as product promises; reproducibility plan documented | **Pending** |
| 2 | **SHA-256 checksum and expected byte size** | [Hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md) — Gate 2 section; ops size evidence recorded; **final** SHA-256/byte size **not** published. Published SHA-256 for `prexus-local-mvp.gguf`; expected byte size for partial-file detection; verification policy after download/copy | **Pending** |
| 3 | **License / redistribution / export compliance** | [Compliance memo](./qwon_m3_model_distribution_compliance_memo.md) — questions documented; **not** sign-off. Model license review; App Store / export compliance impact; redistribution rights for in-app fetch documented | **Pending** — needs product/legal confirmation |
| 4 | **iOS storage budget and available-space check** | [Storage + integrity memo](./qwon_m3_storage_integrity_memo.md) — Gate 4 section; pre-download sandbox capacity check required in principle; **minimum threshold undecided**. Minimum free-space threshold before download starts; user-visible failure when space insufficient; no silent sandbox fill | **Pending** |
| 5 | **Partial download / resume / atomic move plan** | [Storage + integrity memo](./qwon_m3_storage_integrity_memo.md) — Gate 5 section; temp/atomic/resume **undecided**; integrity → Diagnostics mapping documented. Temp filename strategy; resume or clean retry policy; atomic move to `Documents/Models/prexus-local-mvp.gguf`; corrupt/partial state handling per [integrity states](#integrity-and-storage-requirements) | **Pending** |
| 6 | **Privacy / network disclosure copy** | [Network + device expectation memo](./qwon_m3_network_device_expectation_memo.md) — Gate 6 section; disclosure required in principle; **final** Settings/TestFlight/privacy label copy **undecided**. Settings/onboarding copy for network use; no surprise background fetch; alignment with local-first positioning | **Pending** |
| 7 | **Wang / Matisse behavior expectation** | [Network + device expectation memo](./qwon_m3_network_device_expectation_memo.md) — Gate 7 section; tier runtime matrix + **draft** copy only; aligned with M2 guided placement. **Wang:** verified GGUF → llama.cpp On-Device Runtime; missing/corrupt → embedded heuristic fallback without crash. **Matisse:** Embedded Heuristic Runtime remains expected; download must not imply Matisse failure or required GGUF install | **Pending** |
| 8 | **Rollback to Mac + USB guided placement** | M2 guided path (`Place GGUF via Mac`, `push_local_model_to_device.sh`) remains supported fallback; spike regression must not break manual ops | **Pending** |
| 9 | **Build `4` / TestFlight gate (separate)** | M3 spike ≠ Build `4` approval; no upload, tag, or `CFBundleVersion` bump implied; product gate for any binary that ships download UX to testers | **Pending** — **not approved** |

### Explicit non-approvals

| Item | Status |
| --- | --- |
| M3 Swift implementation | **Not approved** |
| Network fetch / downloader prototype in app | **Not approved** |
| Storage schema change | **Not approved** |
| `LocalGGUFModelPlacement` lookup order change | **Not approved** |
| `prexus-local-mvp.gguf` rename | **Not approved** |
| `PREXUS_*` env rename | **Not approved** |
| GGUF or binary commit to git | **Not approved** |

### Exit criteria to open M3 spike (future)

1. All checklist rows marked **Ready** with linked Product/Codex evidence (docs or decision memo — no artifact commit).
2. Codex scoped implementation plan for spike-only branch.
3. Rollback path verified: M2 guided placement + manual USB push remain usable.
4. Build `4` decision remains a **separate** product gate even if M3 spike succeeds.

### Cursor / agent boundary

- **Allowed now:** docs-only updates to this checklist and queue status.
- **Not allowed until checklist sign-off:** downloader code, network fetch, background transfer schema, TestFlight upload, Build `4` ops.
