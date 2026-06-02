# QWON Phase 4 — Rename Surface Audit

**Status:** Pre-implementation inventory for PR 4C-a / 4C-b / 4C-c / 4D / 4E. **No code changes in this doc.**
**Baseline:** `main` after Phase 4 PR 4B (#59) — active target/scheme **QWON**; Swift module **`PREXUS`** via `PRODUCT_MODULE_NAME`; source paths unchanged.

Related: [Phase 4 target rename plan](./qwon_phase4_target_rename_plan.md) · [QWON migration plan](./qwon_rename_migration_plan.md)

---

## Purpose

Before PR 4C-a, record **what still says PREXUS**, assign each surface to **4C-a / 4C-b / 4C-c / 4D / 4E**, and mark **preserve** items that must not be mass-renamed.

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

Use **three separate implementation PRs** for path/test/module work. Do **not** combine directory moves, test target renames, and Swift module rename in one PR.

| Phase | Owns | Does not own |
| --- | --- | --- |
| **4C-a** | **App source path move** `app/ios/PREXUS/` → `app/ios/QWON/`; `generate_xcodeproj.rb` app paths (`INFOPLIST_FILE`, bridging header **path**, app globs); regenerate project/scheme; active docs that cite `app/ios/PREXUS/` | Test dirs/targets; Swift module; type renames; behavior |
| **4C-b** | **Test path + target rename** `PREXUSTests`/`PREXUSUITests` → `QWONTests`/`QWONUITests`; generator test wiring; `-only-testing:` / scheme testables; test class filenames if required by target names | Swift module; `@testable import`; app Swift type renames |
| **4C-c** | **Swift module rename** — drop `PRODUCT_MODULE_NAME = PREXUS`; `@testable import QWON`; entry point (`PREXUSApp` → `QWONApp`); UI/bridge **type and file** renames required by module | Behavior; Bundle ID; historical docs |
| **4D** | Active **docs/scripts narrative** after 4C series; README/models QWON ops text; optional script echo/help cleanup | Historical PREXUS alpha docs; env-var contracts; model filenames. **Alternative home for 4C-c** if product defers module rename to sit after docs pass |
| **4E** | Optional Distribution archive + TestFlight smoke after rename series | Required for Phase 4 naming closure |

### Recommended order (one PR each; merge between)

1. **4C-a** — app directory move only; keep `PRODUCT_MODULE_NAME = PREXUS` so `@testable import PREXUS` still works.
2. **4C-b** — test directories/targets; still `PRODUCT_MODULE_NAME = PREXUS`.
3. **4C-c** — module + imports + Swift symbols (or defer to early **4D** slice if product wants docs-only gate before module churn).

**Validation after each PR:** same simulator test as PR 4B + `git diff --check` + no-llama committed `project.pbxproj`.

Stop and re-plan if simulator tests fail for non-naming reasons.

---

## PR 4C-a — App source path move

**Scope:** filesystem + generator app paths only. **No** test target rename. **No** Swift module or type rename.

### Directory move (4C-a only)

| Current path | Proposed | Files (approx.) | PR |
| --- | --- | --- | --- |
| `app/ios/PREXUS/` | `app/ios/QWON/` | 28× `.swift`, `Info.plist`, `Assets.xcassets`, bridge | **4C-a** |
| `app/ios/PREXUSTests/` | `app/ios/QWONTests/` | 1× `PREXUSTests.swift` | **4C-b** (not 4C-a) |
| `app/ios/PREXUSUITests/` | `app/ios/QWONUITests/` | 1× `PREXUSUITests.swift` | **4C-b** (not 4C-a) |

**Preserve paths (all phases):**

| Path | Reason |
| --- | --- |
| `app/ios/PREXUSLiteRTEval/` | Isolated eval target; scheme `PREXUSLiteRTEval` |
| `app/ios/shared/` | No PREXUS directory segment |
| `runtime/` | No path rename |

### `generate_xcodeproj.rb` — 4C-a slice

| Reference | Current | 4C-a action |
| --- | --- | --- |
| App source glob | `IOS_ROOT.join("PREXUS", …)` | → `QWON` |
| App group | `main_group.new_group("PREXUS", "PREXUS")` | → `QWON` |
| `INFOPLIST_FILE` | `PREXUS/Resources/Info.plist` | → `QWON/Resources/Info.plist` |
| Bridging header **path** | `PREXUS/LlamaCppBridge/…` | → `QWON/LlamaCppBridge/…` (filename may stay `PREXUS-Bridging-Header.h` until 4C-c) |
| `PRODUCT_MODULE_NAME` | `PREXUS` | **Keep** through 4C-a and 4C-b |
| Test globs / target names | `PREXUSTests`, `PREXUSUITests` | **Unchanged in 4C-a** → 4C-b |
| `PROJECT_PATH` | `PREXUS.xcodeproj` | **Defer** — optional later PR |

### Active docs — 4C-a

| Doc | Example | PR |
| --- | --- | --- |
| [agent_collaboration_workflow.md](./agent_collaboration_workflow.md) | `files under app/ios/PREXUS/` | **4C-a** |

---

## PR 4C-b — Test path and target rename

**Scope:** test directories, Xcode test targets, `-only-testing:` strings. **No** Swift module rename.

### `generate_xcodeproj.rb` — 4C-b slice

| Reference | 4C-b action |
| --- | --- |
| Test globs | `PREXUSTests` → `QWONTests`, `PREXUSUITests` → `QWONUITests` |
| Test target names / products | `QWONTests.xctest`, `QWONUITests.xctest` |
| `QWON.xcscheme` testables | Blueprint names updated on regenerate |
| `PRODUCT_MODULE_NAME` | **Keep** `PREXUS` |

### Scripts — 4C-b

| Script | PREXUS reference | PR |
| --- | --- | --- |
| `tools/scripts/refresh_prexus_runtime_surface_captures.rb` | `-only-testing:PREXUSUITests` | **4C-b** |
| `tools/scripts/export_prexus_xcuitest_screenshots.rb` | path/target assumptions | **4C-b** review |

### Active docs — 4C-b

| Doc | Example | PR |
| --- | --- | --- |
| Design/runtime surface docs | `-only-testing:PREXUSUITests` | **4C-b** |
| [device_install_and_screenshot_workflow.md](../design/device_install_and_screenshot_workflow.md) | `PREXUSTests` count labels | **4C-b** |

Device scripts already use `-scheme QWON` (4B). **Project path** `PREXUS.xcodeproj` unchanged until explicitly scoped.

---

## PR 4C-c — Swift module and symbol rename

**Scope:** module name, imports, entry point, and Swift/ObjC **symbols/files** whose names embed PREXUS. **No** behavior changes.

| Surface | Current | 4C-c action |
| --- | --- | --- |
| `PRODUCT_MODULE_NAME` | `PREXUS` (override) | **Remove** — module becomes `QWON` |
| `@testable import` | `PREXUS` in `PREXUSTests.swift` | → `QWON` |
| `PREXUSApp.swift` / `PREXUSApp` | app entry | → `QWONApp` |
| `PREXUSAccessibilityID`, `PREXUSStatusChip`, … | UI types | Rename types; **keep accessibility string values** stable |
| `PREXUSLiquidGlass.swift` | UI file | Rename file + types |
| `PREXUSLlamaBridge.h` / `.mm` | ObjC bridge | Rename in same PR slice as Swift interop |
| `PREXUS-Bridging-Header.h` | filename | → `QWON-Bridging-Header.h` (or equivalent) |

**Alternative:** defer 4C-c to an early **4D** docs+code slice if product wants path/test renames merged and soak-tested before module churn. Default recommendation: **4C-c** as its own PR before broad 4D narrative cleanup.

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
| [device_install_and_screenshot_workflow.md](../design/device_install_and_screenshot_workflow.md) | Test count labels — updated in **4C-b** |
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

## Preserve list (do not rename in 4C-a–4D)

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
| Source path in docs | PREXUS alpha prep (`app/ios/PREXUS/Resources/Info.plist`) | QWON ops docs → `app/ios/QWON/…` after **4C-a** |
| Test bundle `-only-testing:` | — | `PREXUSUITests` → `QWONUITests` in **4C-b** |

---

## Risk notes for Codex review (4C-a / 4C-b / 4C-c)

| Risk | Mitigation |
| --- | --- |
| Single PR mixing path + module renames | **Split:** 4C-a → 4C-b → 4C-c; one concern per PR |
| Mixing behavior change with moves | Each 4C PR: naming/build wiring only |
| Stale `BlueprintIdentifier` in schemes | Regenerate via `generate_xcodeproj.rb`; commit scheme |
| llama-linked pbxproj committed | Regenerate on machine **without** `llama.xcframework` |
| UI test accessibility IDs drift | Keep identifier **string values** stable in **4C-c** even if Swift enum renamed |
| ObjC bridge symbol rename | **4C-c only** — coordinate Swift/ObjC names in that PR |

---

## Next step

When [entry gates](./qwon_phase4_target_rename_plan.md#entry-gates) are satisfied, open **PR 4C-a** using this audit as the file checklist. Merge and soak-test before **4C-b**; repeat before **4C-c**. Do not start until product confirms no active TestFlight release blocker.
