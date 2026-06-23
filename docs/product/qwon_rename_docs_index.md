# QWON Rename — Documentation Index

**Last updated:** 2026-06-22 (G6 support / web / policy worksheet indexed — **not release approval**)
**Purpose:** **Information architecture only** — where to start reading QWON rename / Phase 4 docs and in what order. Does **not** add new policy; it summarizes and links existing decisions.

**Next decision (release vs post-alpha):** [Post-M3 next lane decision](./qwon_post_m3_next_lane_decision.md) · [QWON next work queue — decision checkpoint](./qwon_next_work_queue.md#next-decision-checkpoint) · [M3 spike outcome decision](./qwon_m3_spike_outcome_decision.md)

**Post-alpha option lanes (v0.2+ planning):** [qwon_post_alpha_options.md](./qwon_post_alpha_options.md) — **Stay selected**; no third lane; M3 **Option A / lane closed**; build **`4` not approved**

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
| **Next decision** | [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record) — **Stay selected** · build `4` gate separate |
| **Post-alpha / v0.2 candidates** | [Post-M3 checkpoint](./qwon_post_m3_next_lane_decision.md) · [Option lanes](./qwon_post_alpha_options.md) · [Selection matrix](./qwon_post_alpha_options.md#selection-matrix) |
| **First post-alpha lane** | **UI polish — complete** (UI-1 #80, #81) · UI-2 **deferred** (#82) |
| **Second post-alpha lane** | **Model download / GGUF UX — closed** (M3 Option A) · [decision record](./qwon_m3_spike_outcome_decision.md#decision-record) |
| **Third post-alpha posture** | **Stay selected** — no new lane · [decision record](./qwon_post_m3_next_lane_decision.md#decision-record) |
| **Xcode project container** | **`PREXUS.xcodeproj`** — deferred; see [preserved inventory](./qwon_preserved_prexus_surface_inventory.md) |
| **Gemma 4 E4B Mobile** | **E4B-0〜E4B-3 complete** on `main` — **research/eval candidate only**; **not QWON default** · [next work queue § E4B](./qwon_next_work_queue.md#gemma4-e4b-mobile-research-2026-06-11) |

---

## Start here (reading order)

| Order | Document | Why read |
| --- | --- | --- |
| **1** | [qwon_rename_migration_plan.md](./qwon_rename_migration_plan.md) | **Overall migration state** — naming decision, Apple gate, phase map, do-not rules |
| **2** | [qwon_phase4_target_rename_plan.md](./qwon_phase4_target_rename_plan.md) | **Phase 4 PR split and status** — what was renamed (#59–#65), 4E gate, series closed |
| **3** | [qwon_preserved_prexus_surface_inventory.md](./qwon_preserved_prexus_surface_inventory.md) | **What not to rename** — historical, runtime, model, eval, deferred infra |
| **4** | [qwon_text_alpha_testflight_prep.md](./qwon_text_alpha_testflight_prep.md) | **TestFlight ops / build `3` stable line** — **Stay selected**; build `4` not approved |
| **5** | [qwon_text_alpha_lab_evidence.md](./qwon_text_alpha_lab_evidence.md) | **Lab evidence / frozen ledger** — Wang/Matisse sign-off, ops filenames |
| **6** | [qwon_bundle_id_decision_memo.md](./qwon_bundle_id_decision_memo.md) | **Apple identity / signing** — App ID, profiles, ASC record vs historical PREXUS |

**Supplementary (after the above):** [qwon_phase4_rename_surface_audit.md](./qwon_phase4_rename_surface_audit.md) — file-level audit trail for Phase 4; [rename surface audit](./qwon_phase4_rename_surface_audit.md) is reference, not a second entry point.

---

## Decision shortcuts

| Question | Read first |
| --- | --- |
| **What should I do next?** | [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record) — **Stay** · docs/readme/index/evidence hygiene |
| **Which post-alpha lane should product pick next?** | **Stay selected** — lift Stay + pick one lane to open UI-2 / OCR / LiteRT / etc. |
| **Should we open UI-2 (onboarding structure)?** | **Not now** — **defer / not opened** · [UI-2 need assessment](./qwon_ui_polish_onboarding_plan.md#ui-2-need-assessment-2026-06-03) |
| **Should I rename a PREXUS string?** | [Preserved PREXUS inventory](./qwon_preserved_prexus_surface_inventory.md) — default **no** unless listed as safe or product opens a scoped migration PR |
| **Should we ship build `4`?** | **Not approved** — build **`3` stable alpha**; see [M3 spike outcome decision](./qwon_m3_spike_outcome_decision.md) for Build `4` prerequisites |
| **Public App Store release readiness?** | **Not approved** — [Checklist](./qwon_app_store_public_readiness_checklist.md) · G1–G5 **Closed/Ready** (G5 Option A Mac+USB interim) · [Intake ledger](./qwon_app_store_public_readiness_intake.md) (**12 Unanswered** — G6–G10); separate from Build `4` |
| **Public-repo security hygiene?** | [Public repository security hardening](../requirements/public_repo_security_hardening.md) — tracked identifiers redacted; release/security follow-ups remain separate from approval |
| **What is M3 downloader status?** | **Option A selected** — merged compile-gated spike ([#118](https://github.com/studio-prospect/qwon-ai-ios/pull/118)); **default off**; TestFlight **`0.1.0 (3)`** has no downloader UI; lane **closed** · [decision record](./qwon_m3_spike_outcome_decision.md#decision-record) |
| **Which app / Bundle ID is active?** | [QWON bundle memo](./qwon_bundle_id_decision_memo.md) + [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) — QWON `6775685841`; PREXUS `6775110218` is historical only |
| **Can I edit PREXUS historical docs?** | **No** — [PREXUS alpha index](./qwen_text_only_alpha_docs_index.md); append-only QWON docs or link; never rewrite frozen rows |
| **Where is Phase 4 implementation detail?** | [Phase 4 target rename plan](./qwon_phase4_target_rename_plan.md) PR table + [surface audit](./qwon_phase4_rename_surface_audit.md) |
| **Ordinary feature work — global replace OK?** | **No** — [inventory agent guardrail](./qwon_preserved_prexus_surface_inventory.md#agent-guardrail-read-first) |
| **Submit or triage tester feedback?** | **Window closed** — [QWON feedback intake](./qwon_text_alpha_feedback_intake.md#feedback-window-close-2026-06-03); final rows **QWON-FB-001**, **QWON-FB-002** |
| **Is Gemma 4 E4B adopted or default?** | **No** — research **complete**; Wang runtime feasibility **pass**; strict JSON **not** proven (fenced); Qwen MVP unchanged · [E4B evaluation plan](../research/gemma4_e4b_mobile_evaluation_plan.md) |

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
| [qwon_text_alpha_feedback_intake.md](./qwon_text_alpha_feedback_intake.md) | **Build `3` feedback — closed intake record + template** (not live intake) |
| [qwon_post_m3_next_lane_decision.md](./qwon_post_m3_next_lane_decision.md) | **Post-M3 decision** — **Stay selected**; no third lane; lift Stay to open new lane |
| [qwon_post_alpha_options.md](./qwon_post_alpha_options.md) | **Post-alpha lane catalog** — UI-1 complete; M3 closed; v0.2+ candidates |
| [qwon_model_download_gguf_ux_decision.md](./qwon_model_download_gguf_ux_decision.md) | **Second post-alpha lane decision** — scoped planning gate, Codex plan requirements |
| [qwon_model_download_gguf_ux_plan.md](./qwon_model_download_gguf_ux_plan.md) | **Second post-alpha scoped plan** — M1/M2/M3 spike merged; [post-merge verification](./qwon_model_download_gguf_ux_plan.md#pr-m3-post-merge-verification-2026-06-07) |
| [qwon_m3_spike_outcome_decision.md](./qwon_m3_spike_outcome_decision.md) | **M3 post-spike decision** — **Option A selected**; Build `4` prerequisites; default-off boundary |
| [qwon_m3_spike_plan.md](./qwon_m3_spike_plan.md) | **M3 implementation boundary** — compile-gated in-app download spike (merged); Build `4` remains separate |
| [qwon_m3_model_hosting_checksum_memo.md](./qwon_m3_model_hosting_checksum_memo.md) | **M3 Gate 1–2 evidence** — hosting / checksum (**Ready**) |
| [qwon_m3_model_distribution_compliance_memo.md](./qwon_m3_model_distribution_compliance_memo.md) | **M3 Gate 3 evidence** — license / redistribution / export (**Ready**) |
| [qwon_m3_storage_integrity_memo.md](./qwon_m3_storage_integrity_memo.md) | **M3 Gate 4–5 evidence** — storage budget / partial download integrity (**Ready**) |
| [qwon_m3_network_device_expectation_memo.md](./qwon_m3_network_device_expectation_memo.md) | **M3 Gate 6–7 evidence** — network disclosure / Wang–Matisse expectation (**Ready**) |
| [qwon_m3_rollback_release_gate_memo.md](./qwon_m3_rollback_release_gate_memo.md) | **M3 Gate 8–9 evidence** — Mac+USB rollback / Build `4` release boundary (**Ready**; Build `4` not approved) |
| [qwon_app_store_public_readiness_checklist.md](./qwon_app_store_public_readiness_checklist.md) | **App Store public readiness** — G1–G10 checklist; **public release not approved**; Stay-allowed docs hygiene |
| [qwon_app_store_public_readiness_intake.md](./qwon_app_store_public_readiness_intake.md) | **App Store readiness intake** — Q-AS-01…24 answer ledger; **12 Answered · 12 Unanswered** (G1–G5 **Closed/Ready**); not release approval |
| [qwon_app_store_g6_support_web_policy_worksheet.md](./qwon_app_store_g6_support_web_policy_worksheet.md) | **G6 collection worksheet (EN)** — Product / Legal answer surface; authoritative state remains [intake ledger — G6](./qwon_app_store_public_readiness_intake.md#g6--support--website--terms--privacy-policy); **Unanswered**; gate **Open** |
| [qwon_app_store_g6_support_web_policy_worksheet_ja.md](./qwon_app_store_g6_support_web_policy_worksheet_ja.md) | **G6 collection worksheet (JA)** — 回答収集フォーム；正本は [intake ledger — G6](./qwon_app_store_public_readiness_intake.md#g6--support--website--terms--privacy-policy)；**Unanswered**；gate sign-off は別 PR |
| [public_repo_security_hardening.md](../requirements/public_repo_security_hardening.md) | **Public-repo security hygiene** — tracked identifier boundaries, ignored local artifacts, and pre-release security follow-ups |
| [qwon_ui_polish_onboarding_plan.md](./qwon_ui_polish_onboarding_plan.md) | **First post-alpha scoped plan** — UI-1 complete, [UI-2 need assessment](./qwon_ui_polish_onboarding_plan.md#ui-2-need-assessment-2026-06-03) |

**Related (outside this index):** [models/README.md](../../models/README.md) (GGUF placement) · [Gemma 4 E4B Mobile evaluation plan](../research/gemma4_e4b_mobile_evaluation_plan.md) (research/eval candidate only — **not default**) · [local LLM notes](../research/local_llm_notes.md) · [agent_collaboration_workflow.md](./agent_collaboration_workflow.md) (Codex/Cursor roles) · [feedback intake](./qwon_text_alpha_feedback_intake.md) · [next work queue](./qwon_next_work_queue.md)

---

## Agent note

This index does **not** authorize build **`4`**, default-on M3, project-container rename, or env/model migration without explicit product gates. **Current posture:** **Stay selected** — docs hygiene only · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record). [App Store readiness intake](./qwon_app_store_public_readiness_intake.md) — G1–G5 **Closed/Ready**; **12 Unanswered** (G6–G10); **public release not approved** (2026-06-11).
