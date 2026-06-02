# QWON Rename — Documentation Index

**Last updated:** 2026-06-02 (post PR #67 on `main`)
**Purpose:** **Information architecture only** — where to start reading QWON rename / Phase 4 docs and in what order. Does **not** add new policy; it summarizes and links existing decisions.

**Next work (post-rename docs):** [QWON next work queue](./qwon_next_work_queue.md) — what to do / not do after rename docs are complete.

**Historical PREXUS alpha:** frozen under [qwen_text_only_alpha_docs_index.md](./qwen_text_only_alpha_docs_index.md) — do not rewrite; append or link from QWON docs instead.

---

## Current state (summary)

| Field | Value |
| --- | --- |
| **Active product** | **QWON** — target/scheme/module **`QWON`**, sources **`app/ios/QWON/`** |
| **Active TestFlight** | marketing **`0.1.0`**, **`CFBundleVersion` `2`** |
| **Bundle ID** | **`jp.studio-prospect.qwon.ios`** · ASC Apple ID **`6775685841`** |
| **Phase 4 rename** | **Complete** — implementation **4A–4D** (#59–#64); **4E decision gate** documented (#65) |
| **Preserved PREXUS guardrail** | [Preserved surface inventory](./qwon_preserved_prexus_surface_inventory.md) (PR #66) — intentional remaining PREXUS strings |
| **Build `3`** | **Not approved / not executed** — archive only after [4E gate](./qwon_phase4_target_rename_plan.md#pr-4e--optional-archive-smoke-decision-gate) + [TestFlight prep](./qwon_text_alpha_testflight_prep.md#phase-4-build-3-decision-gate) |
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
| **Should I rename a PREXUS string?** | [Preserved PREXUS inventory](./qwon_preserved_prexus_surface_inventory.md) — default **no** unless listed as safe or product opens a scoped migration PR |
| **Should we ship build `3`?** | [4E decision gate](./qwon_phase4_target_rename_plan.md#pr-4e--optional-archive-smoke-decision-gate) + [TestFlight build `3` gate](./qwon_text_alpha_testflight_prep.md#phase-4-build-3-decision-gate) — **not approved** today |
| **Which app / Bundle ID is active?** | [QWON bundle memo](./qwon_bundle_id_decision_memo.md) + [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) — QWON `6775685841`; PREXUS `6775110218` is historical only |
| **Can I edit PREXUS historical docs?** | **No** — [PREXUS alpha index](./qwen_text_only_alpha_docs_index.md); append-only QWON docs or link; never rewrite frozen rows |
| **Where is Phase 4 implementation detail?** | [Phase 4 target rename plan](./qwon_phase4_target_rename_plan.md) PR table + [surface audit](./qwon_phase4_rename_surface_audit.md) |
| **Ordinary feature work — global replace OK?** | **No** — [inventory agent guardrail](./qwon_preserved_prexus_surface_inventory.md#agent-guardrail-read-first) |

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

**Related (outside this index):** [models/README.md](../../models/README.md) (GGUF placement) · [agent_collaboration_workflow.md](./agent_collaboration_workflow.md) (Codex/Cursor roles) · [next work queue](./qwon_next_work_queue.md)

---

## Agent note

This index does **not** authorize cleanup, build `3`, project-container rename, or env/model migration. Those require explicit product gates documented in the linked files above.
