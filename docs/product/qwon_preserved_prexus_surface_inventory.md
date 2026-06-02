# QWON — Preserved PREXUS Surface Inventory

**Status:** Guardrail doc (post–Phase 4 #59–#65). **No cleanup implementation in this document.**
**Audience:** Cursor/Codex agents, release engineering, future rename work.
**Purpose:** Record **why PREXUS names still exist** after the QWON rename series, classify them, and prevent blind global replace.

Related: [QWON migration plan](./qwon_rename_migration_plan.md) · [Phase 4 target rename plan](./qwon_phase4_target_rename_plan.md) · [Rename surface audit](./qwon_phase4_rename_surface_audit.md) · [Phase 4E decision gate](./qwon_phase4_target_rename_plan.md#pr-4e--optional-archive-smoke-decision-gate)

---

## Agent guardrail (read first)

**Do not** run repo-wide `PREXUS` → `QWON` or `prexus` → `qwon` replace in ordinary QWON work.

Most remaining PREXUS strings are **intentional**. Renaming them without a scoped migration PR breaks device smoke, model placement, persisted user data, historical audit trails, or eval tooling.

When you see PREXUS in the tree, use this inventory to decide:

| If the surface is… | Action |
| --- | --- |
| Listed below as **preserve** | **Leave unchanged** unless product opens a dedicated migration PR |
| Active ops doc with stale target/scheme | Update **narrative only** (Phase 4D pattern) — not env vars or filenames |
| Historical `qwen_text_only_alpha_*` | **Never rewrite** — link to QWON docs instead |
| Unclear | Stop and ask — do not guess via global replace |

---

## Current QWON active state (2026-06-02, post #65)

| Surface | Active value |
| --- | --- |
| App Xcode target / scheme | **`QWON`** |
| App product | **`QWON.app`** |
| Swift module | **`QWON`** |
| App sources | **`app/ios/QWON/`** |
| Unit / UI tests | **`QWONTests`** / **`QWONUITests`** |
| `@testable import` | **`QWON`** |
| Bundle ID | **`jp.studio-prospect.qwon.ios`** |
| ASC app (QWON line) | Apple ID **`6775685841`** |
| Active TestFlight | marketing **`0.1.0`**, **`CFBundleVersion` `2`** |
| Xcode project **container** | **`app/ios/PREXUS.xcodeproj`** (**deferred**) |
| Committed `project.pbxproj` | **no-llama** default |

Phase 4 rename series (#59–#64) and 4E **decision gate** (#65) are complete. **Build `3` archive smoke is not approved** — stay on TestFlight **`0.1.0 (2)`** until product explicitly gates 4E execution.

---

## Preserve categories

Each category includes: **why it remains**, **what breaks if renamed blindly**, **allowed future PR type**, and **ordinary-work rule**.

### 1. Historical — frozen audit trail

**Do not touch in ordinary QWON work.**

| Surface | Examples | Why preserved | Breaks if renamed blindly | Future migration PR type |
| --- | --- | --- | --- | --- |
| PREXUS-era alpha doc set | `docs/product/qwen_text_only_alpha_*`, [PREXUS bundle memo](./bundle_id_decision_memo.md), [status summary](./qwen_text_only_alpha_status_summary.md) | Immutable TestFlight / ASC history for `jp.studio-prospect.prexus.ios` | Audit trail lies; command snippets no longer match shipped builds | **None** — append-only QWON docs; never rewrite frozen rows |
| Frozen lab ledgers | [PREXUS lab evidence](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1), `~/PREXUS-alpha-evidence/` paths cited in docs | Release record for build `0.1.0 (1)` | Evidence chain breaks | **None** for ledger edits; new evidence under `~/QWON-alpha-evidence/` |
| Historical ASC / bundle | PREXUS ASC Apple ID **`6775110218`**, `jp.studio-prospect.prexus.ios` | Separate product line from QWON | Product-line confusion; wrong upload target | **None** — QWON uses `6775685841` only |
| Git tags / commits on PREXUS lineage | `qwen-text-alpha-0.1.0-rc1` (PREXUS), closed PR titles | Git history | Cannot rewrite safely | **None** |
| Design docs with PREXUS in **filename** | `docs/design/prexus_chat_ui_polish_plan.md`, `prexus_app_icon_strategy.md` | Historical design artifacts | Broken links; false “current design” signal | Optional **new** QWON-named doc; keep old files |
| Runtime-surface capture tree | `docs/design/runtime-surface-captures/` historical attachment names | Past capture baseline | Compare/regression ambiguity | Re-capture workflow only; do not rename old PNGs in place |

---

### 2. Runtime contracts — env vars, compile flags, launch args

**Do not touch in ordinary QWON work.**

| Surface | Examples | Why preserved | Breaks if renamed blindly | Future migration PR type |
| --- | --- | --- | --- | --- |
| Launch env (device smoke) | `PREXUS_RUN_ALPHA_SMOKE`, `PREXUS_ALPHA_SMOKE_SCENARIO` | `alpha_smoke_wang.sh` + `LocalAlphaSmokeRunner` contract | Wang smoke fails; CI/device gates red | **Dedicated env migration PR** with script + app + doc update + device re-smoke |
| Launch env (eval) | `PREXUS_RUN_BACKEND_COMPARISON`, `PREXUS_RUN_STRICT_JSON_BENCHMARK`, `PREXUS_LITERT_MODEL_PATH` | Eval shell scripts and in-app runners | Device eval scripts fail mid-pipeline | Same — coordinated script + Swift migration |
| Local model env | `PREXUS_LOCAL_MODEL_PATH`, `PREXUS_LOCAL_MODEL_SOURCE`, `PREXUS_LOCAL_MODEL_DEST` | `push_local_model_to_device.sh`, placement helpers | Model not found on device; wrong Documents path | Model migration PR (often paired with filename migration) |
| Build skip | `PREXUS_SKIP_BUILD` | Faster iterative smoke on Wang | Script usage docs/scripts diverge | Optional alias PR (`QWON_SKIP_BUILD`) — low priority |
| Compile flags | `PREXUS_LLAMA_CPP_AVAILABLE`, `PREXUS_LITERT_LM_PROTOTYPE` | `generate_xcodeproj.rb` local llama / LiteRT prototype gates | Local device archive generation fails | **Infrastructure PR** — generator + all `#if` sites + CI docs |
| Generator env | `PREXUS_LITERT_LM_EVAL`, `PREXUS_LITERT_LM_TAG`, `PREXUS_GEMMA4_EVAL_*`, … | Optional targets and fetch scripts | LiteRT eval / Gemma eval workflows break | Scoped tooling PR per eval line |
| UI test launch arg | `PREXUS_UI_TEST_SEEDED_SURFACES` | `QWONUITests` + `AppEnvironment` | UI screenshot tests fail to seed surfaces | Coordinated test + app migration PR |
| Benchmark env | `PREXUS_LOCAL_INFERENCE_BENCHMARK` | Optional llama benchmark logging | Benchmark docs/scripts miss logs | Low-priority cosmetic migration |

**Log prefix strings** (`[PREXUS][alpha-smoke]`, `[PREXUS][device-eval-log]`, etc.) are **runtime-contract adjacent**: changing them does not usually break execution but breaks log grep/runbooks. Treat as **preserve** unless a logging migration PR updates scripts and docs together.

---

### 3. Model and on-disk file contracts

**Do not touch in ordinary QWON work.**

| Surface | Examples | Why preserved | Breaks if renamed blindly | Future migration PR type |
| --- | --- | --- | --- | --- |
| Default MVP GGUF | `prexus-local-mvp.gguf`, `models/prexus-local-mvp.gguf` | `LocalGGUFModelPlacement`, fetch/push scripts, tester docs | Device llama path fails; testers’ pushed files orphaned | **Product-approved model migration PR** — filename + placement + scripts + README + optional on-device copy migration |
| Eval GGUF | `prexus-eval-gemma4-e2b-it.gguf` | Gemma eval workflow | Eval scripts and Documents paths break | Eval migration PR |
| LiteRT artifact | `prexus-eval-gemma4-e2b.litertlm` | LiteRT eval + prototype settings UI copy | Prototype/eval cannot load model | Same |
| Device Documents names | Default dest `prexus-local-mvp.gguf` under `Documents/Models/` | Already on lab phones | Re-push required; smoke false negatives | Paired with model migration |
| Error copy referencing filename | Diagnostic strings mentioning `prexus-local-mvp.gguf` | User/dev troubleshooting | Confusing but non-fatal if filename unchanged | Update only **with** filename migration |

See also [models/README.md](../../models/README.md#naming-notes-phase-4).

---

### 4. Persistence — UserDefaults, Keychain, Documents logs

**Do not touch in ordinary QWON work.**

| Surface | Examples | Why preserved | Breaks if renamed blindly | Future migration PR type |
| --- | --- | --- | --- | --- |
| UserDefaults keys | `prexus.app-config`, `prexus.episodic-memory`, `prexus.runtime-diagnostics`, `prexus.debug.litertPrototypeEnabled`, eval completion keys | Existing installs retain settings/memory/diagnostics | **Data loss** or silent reset for TestFlight users | **Migration PR** with one-time key rewrite or versioned store |
| Keychain service | `com.prexus.api-keys` | Independent of Bundle ID ([bundle memos](./qwon_bundle_id_decision_memo.md)) | API keys appear “missing”; re-entry required | Keychain migration PR with export/import plan |
| Documents log files | `prexus-device-eval.log`, `prexus-alpha-smoke-*.json`, `prexus-backend-comparison.log`, strict-json CSV/JSON | Device eval scripts pull by fixed paths | `fetch_*` scripts fail | Coordinated script + Swift filename migration |

---

### 5. Eval target — isolated spike (not production QWON)

**Do not touch in ordinary QWON work.**

| Surface | Examples | Why preserved | Breaks if renamed blindly | Future migration PR type |
| --- | --- | --- | --- | --- |
| Target / scheme / product | `PREXUSLiteRTEval`, `PREXUSLiteRTEval.app`, `PREXUSLiteRTEval.xcscheme` | Isolated LiteRT-LM eval app | `eval_litert_lm_on_device.sh`, `install_litert_eval_on_device.sh` break | **Optional eval rename PR** — generator + scripts + eval docs only |
| Source tree | `app/ios/PREXUSLiteRTEval/` | Separate from QWON production target | Xcode project generation breaks | Same |
| Eval app symbols | `PREXUSLiteRTEvalApp`, eval UI strings “PREXUS LiteRT-LM Eval” | Eval-only UX | Eval build confusion only | Low priority; not production |
| Bundle ID suffix | `jp.studio-prospect.qwon.ios.literteval` | Already QWON-line bundle suffix | ASC/signing mismatch if renamed casually | Apple gate PR if ever renamed |

Production QWON app is **`QWON`** — eval rename does **not** require production app changes.

---

### 6. Deferred infrastructure — paths and script filenames

**Do not touch in ordinary QWON work.**

| Surface | Examples | Why preserved | Breaks if renamed blindly | Future migration PR type |
| --- | --- | --- | --- | --- |
| Xcode project container | `app/ios/PREXUS.xcodeproj` | High churn; all `-project` paths and CI assume it | Every xcodebuild line, generator, IDE habits break | **Dedicated container rename PR** (#59–#64 explicitly deferred) |
| PBX project name string | `PBXProject "PREXUS"` inside pbxproj | Tied to container rename | Scheme/container references desync | Same container PR |
| Legacy scheme cleanup hook | `LEGACY_APP_SCHEME = "PREXUS"` in generator | Removes stale `PREXUS.xcscheme` on regen | Stale scheme could return | Part of container PR or generator cleanup |
| Script filenames `*prexus*` | `refresh_prexus_runtime_surface_captures.rb`, `export_prexus_xcuitest_screenshots.rb` | Low priority; many doc links | Broken doc/runbook links | Optional **script rename PR** updating all call sites |
| Temp dir prefixes in scripts | `prexus-runtime-captures-*` mktemp prefix | Local only | None for app; grep confusion only | Cosmetic script PR |

Active commands correctly use **`-project PREXUS.xcodeproj -scheme QWON`**. Narrative docs should say **container deferred**, not imply the app is still named PREXUS.

---

### 7. Generated and ops artifacts — screenshots, manifests, archives

**Do not touch in ordinary QWON work.**

| Surface | Examples | Why preserved | Breaks if renamed blindly | Future migration PR type |
| --- | --- | --- | --- | --- |
| UI test attachment basenames | `prexus-chat-*`, `prexus-settings-*`, … in `QWONUITests` | Existing manifests and capture diff baselines | Runtime surface regression compares fail | **Re-capture PR** with manifest bump; not drive-by rename |
| Historical IPA/archive names in ops docs | `.archive/QWON-Export/PREXUS.ipa` (uploaded build 1) | Past upload record | Ops confusion only | Append new ops rows; do not rewrite historical upload tables |
| Old `.xcresult` / DerivedData paths | Local machine artifacts | Not in git | N/A | N/A |
| dSYM / archive folders under `.archive/` | `PREXUS.app.dSYM` in old archives | Historical binaries | N/A | N/A |

New captures may use QWON-prefixed names (e.g. temp `QWON-{device}.xcresult` after #64); **do not bulk-rename** committed screenshot trees without a capture workflow PR.

---

### 8. Future-candidate — cosmetic only (low priority)

These do **not** block QWON correctness but may confuse readers. **Still do not rename in drive-by PRs.**

| Surface | Examples | Notes | Allowed PR type |
| --- | --- | --- | --- |
| Alpha smoke prompt text | `"PREXUS alpha smoke: reply…"` in `LocalAlphaSmokeRunner` | Smoke JSON content; not env key | Cosmetic copy PR + smoke re-run |
| Cloud escalation copy | `runtime/llm/cloud/CloudModelClient` “PREXUS” in instructions string | Cloud prompt wording | Product copy PR |
| Benchmark Japanese prompt | `benchmark_local_gguf.sh` | Mac-side only | Tooling cosmetic PR |
| PREXUSLiteRTEval UI copy | “Production PREXUS keeps Qwen…” | Eval app only | Eval-only PR |

---

## Quick lookup — “I found PREXUS, what do I do?”

| Location pattern | Category | Ordinary work |
| --- | --- | --- |
| `docs/product/qwen_text_only_alpha_*` | Historical | **Never edit** |
| `PREXUS_*` env / `#if PREXUS_*` | Runtime contract | **Preserve** |
| `prexus-*.gguf` / `.litertlm` | Model contract | **Preserve** |
| `prexus.*` UserDefaults / Keychain | Persistence | **Preserve** |
| `PREXUSLiteRTEval` | Eval target | **Preserve** |
| `PREXUS.xcodeproj` | Deferred infrastructure | **Preserve** — document `-scheme QWON` |
| `refresh_prexus_*` script name | Deferred infrastructure | **Preserve** |
| Active QWON ops doc stale scheme | Narrative drift | **Fix text only** (4D-style) |
| Unknown | — | **Ask** — no global replace |

---

## Related completed work (do not redo)

| Phase | PRs | Outcome |
| --- | --- | --- |
| 4B | #59 | Target/scheme **QWON** |
| 4C-a | #61 | Sources **`app/ios/QWON/`** |
| 4C-b | #62 | Tests **QWONTests** / **QWONUITests** |
| 4C-c | #63 | Module **`QWON`**, Swift symbols renamed |
| 4D | #64 | Active docs/scripts narrative |
| 4E gate | #65 | Build `3` decision documented; **no archive** |

---

## Maintenance

Update this inventory when:

- A **scoped migration PR** intentionally renames a preserved surface (document the new canonical name).
- Product approves **build `3` / 4E execution** (cross-link lab evidence; do not rewrite historical rows).
- A new PREXUS-prefixed contract is **introduced** (avoid; prefer QWON for new surfaces).

**Do not** use this file as a checklist to mass-delete PREXUS strings. It is a **guardrail**, not a cleanup ticket.
