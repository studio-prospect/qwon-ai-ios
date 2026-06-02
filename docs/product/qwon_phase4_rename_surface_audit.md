# QWON Phase 4 — Rename Surface Audit

**Status:** Pre-implementation inventory for PR 4C / 4D / 4E. **No code changes in this doc.**
**Baseline:** `main` after Phase 4 PR 4B (#59) — active target/scheme **QWON**; Swift module **`PREXUS`** via `PRODUCT_MODULE_NAME`; source paths unchanged.

Related: [Phase 4 target rename plan](./qwon_phase4_target_rename_plan.md) · [QWON migration plan](./qwon_rename_migration_plan.md)

---

## Purpose

Before PR 4C, record **what still says PREXUS**, assign each surface to **4C / 4D / 4E**, and mark **preserve** items that must not be mass-renamed.

This audit avoids a blind global replace and keeps historical PREXUS alpha docs immutable.

---

## Completed in PR 4B (#59)

| Surface | Before | After (4B) |
| --- | --- | --- |
| App Xcode target | `PREXUS` | **`QWON`** |
| App product | `PREXUS.app` | **`QWON.app`** |
| Shared scheme | `PREXUS.xcscheme` | **`QWON.xcscheme`** |
| Active device/smoke xcodebuild | `-scheme PREXUS` | **`-scheme QWON`** |
| Bundle ID | `jp.studio-prospect.qwon.ios` | unchanged |
| Swift module | `PREXUS` | **`PREXUS`** (`PRODUCT_MODULE_NAME` override) |
| Source directory | `app/ios/PREXUS/` | unchanged |
| Test targets | `PREXUSTests`, `PREXUSUITests` | unchanged |
| Project container | `PREXUS.xcodeproj` | unchanged |
| Committed `project.pbxproj` | no-llama | no-llama (verified) |

---

## PR assignment summary

| Phase | Owns | Does not own |
| --- | --- | --- |
| **4C** | Active **directory moves**, test target renames, `generate_xcodeproj.rb` path/target wiring, Swift **module** rename (`PRODUCT_MODULE_NAME` → `QWON`), `@testable import`, filename/symbol renames required by module/path moves | Behavior, Bundle ID, historical docs |
| **4D** | Active **docs/scripts narrative** cleanup after 4C paths are stable; README/models active QWON ops text; script echo/help strings | Historical PREXUS alpha docs; env-var contracts; model filenames |
| **4E** | Optional Distribution archive + TestFlight smoke after rename series | Required for Phase 4 naming closure |

**Recommended 4C order (within one PR or 4C-a / 4C-b):**

1. Move directories + update `generate_xcodeproj.rb` + regenerate project (still `PRODUCT_MODULE_NAME = PREXUS` if needed for incremental green tests).
2. Rename test targets (`PREXUSTests` → `QWONTests`, `PREXUSUITests` → `QWONUITests`) and `-only-testing:` strings.
3. Drop `PRODUCT_MODULE_NAME` override → module `QWON`; update `@testable import` and Swift type/file names tied to the app entry point.

Stop and re-plan if simulator tests fail for non-naming reasons.

---

## PR 4C — Source / test paths & build wiring

### Directory moves (filesystem)

| Current path | Proposed | Files (approx.) | Notes |
| --- | --- | --- | --- |
| `app/ios/PREXUS/` | `app/ios/QWON/` | 28× `.swift`, `Info.plist`, `Assets.xcassets`, bridge | Primary app sources |
| `app/ios/PREXUSTests/` | `app/ios/QWONTests/` | 1× `PREXUSTests.swift` | Unit tests |
| `app/ios/PREXUSUITests/` | `app/ios/QWONUITests/` | 1× `PREXUSUITests.swift` | UI tests + screenshot exports |

**Out of 4C scope (preserve as-is unless product opens a separate eval rename):**

| Path | Reason |
| --- | --- |
| `app/ios/PREXUSLiteRTEval/` | Isolated eval target; own scheme `PREXUSLiteRTEval` |
| `app/ios/shared/` | Shared resources; no PREXUS directory name |
| `runtime/` | Compiled into app; no PREXUS path segment |

### `generate_xcodeproj.rb` (must update in 4C)

| Reference | Current | 4C action |
| --- | --- | --- |
| App source glob | `IOS_ROOT.join("PREXUS", …)` | → `QWON` |
| Test globs | `PREXUSTests`, `PREXUSUITests` | → `QWONTests`, `QWONUITests` |
| App group / paths | `main_group.new_group("PREXUS", "PREXUS")` | → `QWON` |
| `INFOPLIST_FILE` | `PREXUS/Resources/Info.plist` | → `QWON/Resources/Info.plist` |
| Bridging header setting | `PREXUS/LlamaCppBridge/PREXUS-Bridging-Header.h` | → path under `QWON/` (file rename below) |
| Test target names | `PREXUSTests`, `PREXUSUITests` | → `QWONTests`, `QWONUITests` |
| `TEST_TARGET_NAME` | `QWON` (app) | unchanged |
| `PRODUCT_MODULE_NAME` | `PREXUS` (override) | **Remove override** when module rename lands |
| `PROJECT_PATH` | `PREXUS.xcodeproj` | **Defer** rename to optional 4C follow-up or 4D — high churn for docs/scripts |

### Swift files likely renamed in 4C (module / entry point)

| File / symbol | Occurrences | 4C notes |
| --- | --- | --- |
| `PREXUSApp.swift` / `PREXUSApp` | app entry | Rename to `QWONApp` when module is `QWON` |
| `PREXUSAccessibilityID` | app + tests | UI test contract; rename with module or keep identifiers stable |
| `PREXUSStatusChip`, `PREXUSSurfaceCard`, `PREXUSEmptyState`, … | UI helpers | Type renames across `SettingsView`, `ChatView`, etc. |
| `PREXUSLiquidGlass.swift` | UI | File + type rename |
| `PREXUSLlamaBridge.h` / `.mm` | ObjC bridge | Rename touches Swift bridge imports |
| `PREXUS-Bridging-Header.h` | build setting | Path + filename under `QWON/LlamaCppBridge/` |
| `@testable import PREXUS` | `PREXUSTests.swift` | → `@testable import QWON` |

### Scripts with **path/target** references (4C)

Update when directories or test bundle names change:

| Script | PREXUS reference | Phase |
| --- | --- | --- |
| `tools/scripts/generate_xcodeproj.rb` | paths, test targets, scheme testables | **4C** |
| `tools/scripts/refresh_prexus_runtime_surface_captures.rb` | `-only-testing:PREXUSUITests` | **4C** |
| `tools/scripts/export_prexus_xcuitest_screenshots.rb` | likely path assumptions | **4C** review |

Device scripts already use `-scheme QWON` (4B); **project path** `PREXUS.xcodeproj` stays until container rename is explicitly scoped.

### Active docs with **path** references (4C if not updated in 4B)

| Doc | Example | Phase |
| --- | --- | --- |
| [agent_collaboration_workflow.md](./agent_collaboration_workflow.md) | `files under app/ios/PREXUS/` | **4C** |
| [qwon_bundle_id_decision_memo.md](./qwon_bundle_id_decision_memo.md) | `PREXUS.xcodeproj` | **4C** or **4D** (container rename decision) |
| [qwon_text_alpha_testflight_prep.md](./qwon_text_alpha_testflight_prep.md) | `-project PREXUS.xcodeproj` | **4D** (commands already `-scheme QWON`) |
| [local_inference_mvp.md](../requirements/local_inference_mvp.md) | `app/ios/PREXUS.xcodeproj` | **4D** |
| Design/runtime surface docs | `-only-testing:PREXUSUITests` | **4C** after test target rename |

---

## PR 4D — Active docs / script narrative cleanup

Surfaces that describe **current QWON operation** but are not blocked on directory moves, or remain after 4C.

### Scripts — env vars, echo text, optional flags (**preserve contracts**; 4D = docs/comments only unless product approves rename)

| Pattern | Example locations | Audit decision |
| --- | --- | --- |
| `PREXUS_RUN_*` launch env | `alpha_smoke_wang.sh`, `LocalAlphaSmokeRunner` | **Preserve** — runtime contract; changing breaks device smoke |
| `PREXUS_LOCAL_MODEL_*` | `push_local_model_to_device.sh`, `fetch_local_model.sh` | **Preserve** env names; ties to `prexus-local-mvp.gguf` |
| `PREXUS_LITERT_LM_*` / `PREXUS_LITERT_LM_EVAL` | `generate_xcodeproj.rb`, eval scripts | **Preserve** — eval/prototype gate flags |
| `PREXUS_LLAMA_CPP_AVAILABLE` | `generate_xcodeproj.rb` (llama local gen only) | **Preserve** compile flag |
| `PREXUS_SKIP_BUILD` | `alpha_smoke_wang.sh` | **Preserve** or alias in 4D (optional) |
| Script filenames `*prexus*` | `refresh_prexus_runtime_surface_captures.rb`, `export_prexus_xcuitest_screenshots.rb` | **4D optional** rename — low priority; update call sites |

### Active product / ops docs (update narrative, not historical)

| Doc | Action |
| --- | --- |
| [models/README.md](../../models/README.md) | Active QWON ops; keep `prexus-local-mvp.gguf` filename; clarify env vars are legacy names until a model migration |
| [AGENTS.md](../../AGENTS.md) | Regeneration / test commands if paths change |
| [mvp_completion_plan.md](./mvp_completion_plan.md) | Verification command (scheme already QWON) |
| [device_install_and_screenshot_workflow.md](../design/device_install_and_screenshot_workflow.md) | Test count labels (`PREXUSTests` → `QWONTests` after 4C) |
| [runtime_surface_*](../design/) design docs | Active capture workflow |

### Design docs with **PREXUS in filename** (preserve)

| File | Decision |
| --- | --- |
| `docs/design/prexus_chat_ui_polish_plan.md` | **Preserve** — historical design artifact |
| `docs/design/prexus_app_icon_strategy.md` | **Preserve** |
| `docs/design/runtime-surface-captures/` tree | **Preserve** paths/filenames unless capture workflow explicitly re-run |

---

## PR 4E — Optional archive smoke

Only if product wants a TestFlight binary proving renamed target path:

| Step | Record in |
| --- | --- |
| Bump `CFBundleVersion`, local llama archive | [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) |
| Wang primary + Matisse secondary tier | [QWON lab evidence](./qwon_text_alpha_lab_evidence.md) |
| Export compliance | ASC QWON `6775685841` |

Not required to close Phase 4 naming internally.

---

## Preserve list (do not rename in 4C/4D)

| Surface | Examples | Reason |
| --- | --- | --- |
| **Historical PREXUS alpha docs** | `qwen_text_only_alpha_*`, [PREXUS bundle memo](./bundle_id_decision_memo.md), frozen ledger rows | Audit trail; includes `-scheme PREXUS` command snippets |
| **PREXUS ASC / bundle** | Apple ID `6775110218`, `jp.studio-prospect.prexus.ios` | Historical product line |
| **Tags / evidence folders** | `qwen-text-alpha-0.1.0-rc1`, `~/PREXUS-alpha-evidence/` | Immutable release record |
| **Model filename** | `prexus-local-mvp.gguf`, `prexus-eval-*.gguf`, `.litertlm` | Model placement contract — separate product decision |
| **Keychain service** | `com.prexus.api-keys` | Independent of Bundle ID ([bundle memo](./bundle_id_decision_memo.md)) |
| **PREXUSLiteRTEval** | Target, scheme, `app/ios/PREXUSLiteRTEval/`, bundle `*.literteval` | Isolated eval spike |
| **Launch env / compile flags** | `PREXUS_RUN_ALPHA_SMOKE`, `PREXUS_LITERT_LM_PROTOTYPE`, `PREXUS_LLAMA_CPP_AVAILABLE` | Runtime/tooling contract — document, do not mass-rename |
| **Closed PR titles / commits / tags** | e.g. #59 merge message | Git history |
| **Ops archive artifacts** | `.archive/*`, historical `PREXUS.ipa` names in prep docs | Past upload filenames |

---

## Historical vs active command matrix

| Command element | Historical (preserve) | Active (update when touched) |
| --- | --- | --- |
| `-scheme` | `PREXUS` in `qwen_text_only_alpha_testflight_prep.md` | **`QWON`** (4B done) |
| `-project` | PREXUS-era snippets | `PREXUS.xcodeproj` until container rename scoped |
| Source path in docs | PREXUS alpha prep (`app/ios/PREXUS/Resources/Info.plist`) | QWON ops docs → `app/ios/QWON/…` after 4C |
| Test bundle `-only-testing:` | — | `PREXUSUITests` → `QWONUITests` in 4C |

---

## Risk notes for Codex review (4C)

| Risk | Mitigation |
| --- | --- |
| Mixing behavior change with moves | 4C PR: moves + import/build fixes only |
| Stale `BlueprintIdentifier` in schemes | Regenerate via `generate_xcodeproj.rb`; commit scheme |
| llama-linked pbxproj committed | Regenerate on machine **without** `llama.xcframework` |
| UI test accessibility IDs drift | Keep identifier **string values** stable even if Swift enum renamed |
| ObjC bridge symbol rename | Coordinate `PREXUSLlamaBridge` Swift/ObjC names in same PR slice |

---

## Next step

When [entry gates](./qwon_phase4_target_rename_plan.md#entry-gates) are satisfied, open **PR 4C** using this audit as the file checklist. Do not start 4C until product confirms no active TestFlight release blocker.
