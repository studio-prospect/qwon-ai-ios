# QWON Rename — Documentation Index

**Last updated:** 2026-06-03 (Model download / GGUF UX scoped plan)
**Purpose:** **Information architecture only** — where to start reading QWON rename / Phase 4 docs and in what order. Does **not** add new policy; it summarizes and links existing decisions.

**Next decision (release vs post-alpha):** [QWON next work queue — decision checkpoint](./qwon_next_work_queue.md#next-decision-checkpoint) · [Model download / GGUF UX scoped plan](./qwon_model_download_gguf_ux_plan.md)

**Post-alpha option lanes (v0.2+ planning):** [qwon_post_alpha_options.md](./qwon_post_alpha_options.md) — **selected next lane:** [Model download / GGUF UX](./qwon_model_download_gguf_ux_plan.md) (scoped plan; build **`4` not approved**)

**Next work (post-rename docs):** [QWON next work queue](./qwon_next_work_queue.md) — what to do / not do after rename docs are complete.

**Historical PREXUS alpha:** frozen under [qwen_text_only_alpha_docs_index.md](./qwen_text_only_alpha_docs_index.md) — do not rewrite; append or link from QWON docs instead.

---

## Current state (summary)

| Field | Value |
| --- | --- |
| **Active product** | **QWON** — target/scheme/module **`QWON`**, sources **`app/ios/QWON/`** |
| **Active TestFlight** | marketing **`0.1.0`**, **`CFBundleVersion` `3`** — **stable alpha** · [upload record](./qwon_text_alpha_testflight_prep.md#testflight-build-3-2026-06-02) |
| **Bundle ID** | **`jp.studio-prospect.qwon.ios`** · ASC Apple ID **`6775685841`** |
| **Phase 4 rename** | **Complete** — implementation **4A–4D** (#59–#64); **4E decision gate** documented (#65); **upload ops done** (2026-06-02) |
| **Preserved PREXUS guardrail** | [Preserved surface inventory](./qwon_preserved_prexus_surface_inventory.md) (PR #66) — intentional remaining PREXUS strings |
| **Build `3` lab / Wang GGUF** | **Verified** (2026-06-03) — [lab evidence](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03) |
| **Build `3` feedback intake** | **Closed** (2026-06-03) — **QWON-FB-001**, **QWON-FB-002** pass; **no blockers** · [intake](./qwon_text_alpha_feedback_intake.md#feedback-window-close-2026-06-03) |
| **Build `4`** | **Not approved** |
| **Next decision** | [Decision checkpoint](./qwon_next_work_queue.md#next-decision-checkpoint) — **Stay** · build `4` gate · [Model download / GGUF UX decision](./qwon_model_download_gguf_ux_decision.md) |
| **Post-alpha / v0.2 candidates** | [Option lanes](./qwon_post_alpha_options.md) · [Selection matrix](./qwon_post_alpha_options.md#selection-matrix) |
| **First post-alpha lane** | **UI polish — complete** (UI-1 #80, #81) · UI-2 **deferred** (#82) |
| **Selected next lane** | **[Model download / GGUF UX](./qwon_model_download_gguf_ux_plan.md)** — scoped plan available; implementation still gated |
| **Xcode project container** | **`PREXUS.xcodeproj`** — deferred; see [preserved inventory](./qwon_preserved_prexus_surface_inventory.md) |

---

## Start here (reading order)

| Order | Document | Why read |
| --- | --- | --- |
| **1** | [qwon_rename_migration_plan.md](./qwon_rename_migration_plan.md) | **Overall migration state** — naming decision, Apple gate, phase map, do-not rules |
| **2** | [qwon_phase4_target_rename_plan.md](./qwon_phase4_target_rename_plan.md) | **Phase 4 PR split and status** — what was renamed (#59–#65), 4E gate, series closed |
| **3** | [qwon_preserved_prexus_surface_inventory.md](./qwon_preserved_prexus_surface_inventory.md) | **What not to rename** — historical, runtime, model, eval, deferred infra |
| **4** | [qwon_text_alpha_testflight_prep.md](./qwon_text_alpha_testflight_prep.md) | **TestFlight ops / build `3` gate** — active upload line, lab policy, next build criteria |
| **5** | [qwon_text_alpha_lab_evidence.md](./qwon_text_alpha_lab_evidence.md) | **Lab evidence / frozen ledger** — Wang/Matisse sign-off, ops filenames |
| **6** | [qwon_bundle_id_decision_memo.md](./qwon_bundle_id_decision_memo.md) | **Apple identity / signing** — App ID, profiles, ASC record vs historical PREXUS |

**Supplementary (after the above):** [qwon_phase4_rename_surface_audit.md](./qwon_phase4_rename_surface_audit.md) — file-level audit trail for Phase 4; [rename surface audit](./qwon_phase4_rename_surface_audit.md) is reference, not a second entry point.

---

## Decision shortcuts

| Question | Read first |
| --- | --- |
| **What should I do next?** | [Next decision checkpoint](./qwon_next_work_queue.md#next-decision-checkpoint) — use the [Model download / GGUF UX scoped plan](./qwon_model_download_gguf_ux_plan.md) |
| **Which post-alpha lane should product pick next?** | **Decided** — [Model download / GGUF UX decision](./qwon_model_download_gguf_ux_decision.md) |
| **Should we open UI-2 (onboarding structure)?** | **Not now** — **defer / not opened** · [UI-2 need assessment](./qwon_ui_polish_onboarding_plan.md#ui-2-need-assessment-2026-06-03) |
| **Should I rename a PREXUS string?** | [Preserved PREXUS inventory](./qwon_preserved_prexus_surface_inventory.md) — default **no** unless listed as safe or product opens a scoped migration PR |
| **Should we ship build `4`?** | **Not approved** — build **`3` stable alpha**; feedback **closed** · [intake close](./qwon_text_alpha_feedback_intake.md#feedback-window-close-2026-06-03) |
| **Which app / Bundle ID is active?** | [QWON bundle memo](./qwon_bundle_id_decision_memo.md) + [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) — QWON `6775685841`; PREXUS `6775110218` is historical only |
| **Can I edit PREXUS historical docs?** | **No** — [PREXUS alpha index](./qwen_text_only_alpha_docs_index.md); append-only QWON docs or link; never rewrite frozen rows |
| **Where is Phase 4 implementation detail?** | [Phase 4 target rename plan](./qwon_phase4_target_rename_plan.md) PR table + [surface audit](./qwon_phase4_rename_surface_audit.md) |
| **Ordinary feature work — global replace OK?** | **No** — [inventory agent guardrail](./qwon_preserved_prexus_surface_inventory.md#agent-guardrail-read-first) |
| **Submit or triage tester feedback?** | **Window closed** — [QWON feedback intake](./qwon_text_alpha_feedback_intake.md#feedback-window-close-2026-06-03); final rows **QWON-FB-001**, **QWON-FB-002** |

---

## Document responsibilities (one line each)

| Document | Responsibility |
| --- | --- |
| [qwon_rename_migration_plan.md](./qwon_rename_migration_plan.md) | Master rename plan — phases, Apple gates, execution order |
| [qwon_phase4_target_rename_plan.md](./qwon_phase4_target_rename_plan.md) | Phase 4 scope, PR split (#59–#65), 4E gate, rename series status |
| [qwon_phase4_rename_surface_audit.md](./qwon_phase4_rename_surface_audit.md) | File/path audit for Phase 4 — what changed vs preserved |
| [qwon_preserved_prexus_surface_inventory.md](./qwon_preserved_prexus_surface_inventory.md) | Guardrail catalog — why PREXUS remains; do-not-touch list |
| [qwon_text_alpha_testflight_prep.md](./qwon_text_alpha_testflight_prep.md) | QWON TestFlight ops — builds, ASC copy, build `3` gate |
| [qwon_text_alpha_lab_evidence.md](./qwon_text_alpha_lab_evidence.md) | QWON lab evidence — frozen ledger, device policy |
| [qwon_bundle_id_decision_memo.md](./qwon_bundle_id_decision_memo.md) | QWON Bundle ID / signing / ASC app record |
| [qwen_text_only_alpha_docs_index.md](./qwen_text_only_alpha_docs_index.md) | **Historical** PREXUS alpha index — separate product line |
| [qwon_next_work_queue.md](./qwon_next_work_queue.md) | **Post-rename work queue** — ready vs gated vs deferred |
| [qwon_text_alpha_feedback_intake.md](./qwon_text_alpha_feedback_intake.md) | **Build `3` feedback template + triage log** — live intake entry point |
| [qwon_post_alpha_options.md](./qwon_post_alpha_options.md) | **Post-alpha lane catalog** — UI polish complete; Model download / GGUF UX selected |
| [qwon_model_download_gguf_ux_decision.md](./qwon_model_download_gguf_ux_decision.md) | **Second post-alpha lane decision** — scoped planning gate, Codex plan requirements |
| [qwon_model_download_gguf_ux_plan.md](./qwon_model_download_gguf_ux_plan.md) | **Second post-alpha scoped plan** — model status UX first, guided placement next, in-app download gated later |
| [qwon_ui_polish_onboarding_plan.md](./qwon_ui_polish_onboarding_plan.md) | **First post-alpha scoped plan** — UI-1 complete, [UI-2 need assessment](./qwon_ui_polish_onboarding_plan.md#ui-2-need-assessment-2026-06-03) |

**Related (outside this index):** [models/README.md](../../models/README.md) (GGUF placement) · [agent_collaboration_workflow.md](./agent_collaboration_workflow.md) (Codex/Cursor roles) · [feedback intake](./qwon_text_alpha_feedback_intake.md) · [next work queue](./qwon_next_work_queue.md)

---

## Agent note

This index does **not** authorize build **`4`**, project-container rename, or env/model migration without explicit product gates.
