# QWON — Next Work Queue

**Last updated:** 2026-06-08 (Stay selected — G4 gate **Closed/Ready** — This PR)
**Status:** **Queue / guardrail only** — **Stay selected**; docs/readme/index/evidence hygiene only; no implementation authorization.
**Purpose:** After Phase 4 rename docs are complete, classify what agents **may** do next vs what requires **product gates**. Prevents drift into ungated **build `4`**, project-container rename, or blind PREXUS cleanup.

Related: [QWON rename docs index](./qwon_rename_docs_index.md) · [Next decision checkpoint](#next-decision-checkpoint) · [Post-M3 next lane decision](./qwon_post_m3_next_lane_decision.md) · [M3 spike outcome decision](./qwon_m3_spike_outcome_decision.md) · [Model download / GGUF UX plan](./qwon_model_download_gguf_ux_plan.md) · [Post-alpha option lanes](./qwon_post_alpha_options.md#post-m3-next-lane-checkpoint-2026-06-07) · [UI polish / onboarding plan](./qwon_ui_polish_onboarding_plan.md) · [QWON feedback intake](./qwon_text_alpha_feedback_intake.md) · [Preserved PREXUS inventory](./qwon_preserved_prexus_surface_inventory.md) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

---

## Current baseline

| Field | Value |
| --- | --- |
| **Active TestFlight** | **QWON `0.1.0 (3)`** · ASC **`6775685841`** · Bundle **`jp.studio-prospect.qwon.ios`** |
| **Phase 4 rename docs** | **Complete** — index (#67), inventory (#66), Phase 4 series (#59–#65) |
| **Phase 4E ops** | **Upload done** (2026-06-02) — intentional Product/RE; docs record catches up |
| **Wang GGUF (build `3`)** | **Present** — re-pushed 2026-06-03 · [lab evidence](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03) |
| **Wang smoke / Matisse check (build `3`)** | **Done** (2026-06-03) — Wang manual smoke **pass** · Matisse launch **pass** |
| **Feedback intake (build `3`)** | **Closed** (2026-06-03) — **QWON-FB-001**, **QWON-FB-002** operational pass; **no blockers** · [#74](https://github.com/studio-prospect/qwon-ai-ios/pull/74) |
| **Active app (repo)** | Target/scheme/module **`QWON`** · sources **`app/ios/QWON/`** |
| **Build `4`** | **Not approved** |
| **Project container rename** | **`PREXUS.xcodeproj`** — **deferred** |
| **Preserved PREXUS surfaces** | [Inventory](./qwon_preserved_prexus_surface_inventory.md) — env vars, model filenames, eval target, historical docs |

**Default posture:** Stay on TestFlight **`0.1.0 (3)`** as **stable alpha**. Feedback intake is **closed** — no new reports expected. Code work requires a **verified release blocker** on build **`3`** or an **explicit product-approved build `4` gate** — not “waiting for feedback.”

---

## Next decision checkpoint

**Start here** when choosing what to do after build **`3`** stable alpha — release vs post-alpha planning. This section is the **decision entry point**; lanes below are detail.

### Current (2026-06-07)

| Field | Value |
| --- | --- |
| **TestFlight** | **QWON `0.1.0 (3)`** — **stable alpha** · ASC **`6775685841`** · **does not include** M3 downloader UI |
| **Feedback** | **Closed** — **QWON-FB-001**, **QWON-FB-002** operational pass only; **no blockers** · [intake close](./qwon_text_alpha_feedback_intake.md#feedback-window-close-2026-06-03) |
| **Build `4`** | **Not approved** — no upload, tag, or version bump without explicit product gate |
| **Lab** | Wang + Matisse build `3` verified · [lab evidence](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03) |
| **Model download / GGUF UX** | M1/M2 **complete** · M3 spike **merged** ([#118](https://github.com/studio-prospect/qwon-ai-ios/pull/118), verification [#119](https://github.com/studio-prospect/qwon-ai-ios/pull/119)) |
| **M3 compile gate** | `QWON_M3_MODEL_DOWNLOAD_SPIKE` — **default off** |
| **M3 outcome** | **Option A selected** — compile-gated default-off; M3 lane **closed** · [decision record](./qwon_m3_spike_outcome_decision.md#decision-record) |
| **Next post-alpha lane** | **Stay selected** — no third lane · [decision record](./qwon_post_m3_next_lane_decision.md#decision-record) |
| **Next agent step** | **Stay** — docs/readme/index/evidence hygiene only |

### Choose a branch

| Branch | When | First doc | Agent default |
| --- | --- | --- | --- |
| **Stay** | Maintain build **`3`**; docs/readme/index/evidence hygiene only | [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record) · [Ready / low-risk docs-ops](#ready--low-risk-docs-ops) | **Yes** — **Stay selected** |
| **Product gate: build `4` decision** | Product explicitly evaluates whether a **new TestFlight binary** is warranted | [M3 spike outcome decision](./qwon_m3_spike_outcome_decision.md) · [TestFlight prep — build `4` gate](./qwon_text_alpha_testflight_prep.md#phase-4-build-3-decision-gate) · [Conditional upload build `4`](#testflight-upload-build-4) | **No** — gate docs only until product approves |
| **Post-alpha: lift Stay / pick lane** | Product **lifts Stay** and selects **one** new lane | [Post-M3 next lane decision §2](./qwon_post_m3_next_lane_decision.md#2-next-lane-candidates) | **Not active** — Stay in effect |
| **Model download / GGUF UX (M3)** | Lane **closed** (Option A) | [M3 spike outcome decision](./qwon_m3_spike_outcome_decision.md) | **Closed** — no implementation without Product re-open |

**Build `4` decision ≠ build `4` approved.** Documenting criteria or opening a product discussion does **not** authorize archive, upload, tag, or `CFBundleVersion` bump.

### Next allowed actions (without product gate)

| Action | Lane |
| --- | --- |
| Docs / README / index maintenance | [Ready / low-risk docs-ops](#ready--low-risk-docs-ops) |
| **Product-approved build `4` planning** docs only (criteria, checklist, gate memo — **not** upload) | [Conditional — build `4`](#testflight-upload-build-4) |
| Post-alpha — **next lane selection** | [Post-M3 next lane decision](./qwon_post_m3_next_lane_decision.md) · [Post-alpha options](./qwon_post_alpha_options.md) |
| **Stay posture docs hygiene** | Index/queue/link fixes; App Store checklist + intake + **G2 worksheet** maintenance; **no** feature implementation | [Ready / low-risk docs-ops](#ready--low-risk-docs-ops) |
| UI polish **UI-2** (gated) | [UI-2 need assessment](./qwon_ui_polish_onboarding_plan.md#ui-2-need-assessment-2026-06-03) — **not opened** unless new evidence |
| Minimal fix on build **`3`** | **Only** with [verified release blocker](#minimal-fix-pr-verified-release-blocker-only) + Codex/Product sign-off |

### Not allowed (default)

| Action | Why |
| --- | --- |
| TestFlight **upload**, **tag**, or **`CFBundleVersion` / build number bump** | Build **`4` not approved**; RE ops require explicit product gate |
| Implementation PR without **verified blocker** or **product gate** | Stable alpha — no drive-by features or rename cleanup |
| Edit PREXUS historical docs (`qwen_text_only_alpha_*`) or frozen ledger rows | Immutable baseline — link from QWON docs only |
| Append **`QWON-FB-*`** triage rows while intake is closed | [Feedback window closed](./qwon_text_alpha_feedback_intake.md#feedback-window-close-2026-06-03) |
| Commit PNG / logs / GGUF / IPA to git | Ops storage only (`~/QWON-alpha-evidence/`) |

---

<a id="m3-spike-status-2026-06-07"></a>

## M3 spike status (2026-06-07)

**Spike merged · post-merge verification recorded · Option A selected · M3 lane closed · Build `4` not approved.**

| Field | Value |
| --- | --- |
| **Implementation** | [#118](https://github.com/studio-prospect/qwon-ai-ios/pull/118) merged — compile-gated downloader |
| **Verification** | [#119](https://github.com/studio-prospect/qwon-ai-ios/pull/119) merged — Wang `m3_download` + Matisse `model_status` |
| **Compile gate** | `QWON_M3_MODEL_DOWNLOAD_SPIKE` — **default off**; TestFlight **`0.1.0 (3)`** has no M3 downloader UI |
| **Outcome checkpoint** | [#120](https://github.com/studio-prospect/qwon-ai-ios/pull/120) merged — Option A selected |
| **Selected outcome** | **Option A** — keep spike default-off; M3 lane **closed** for implementation |
| **Historical readiness** | [M3 readiness gate checklist](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) — Gates **1–9 Ready** (pre-merge record) |
| **Build `4` / TestFlight upload / tag / version bump** | **Not approved** |
| **M2 rollback** | **Place GGUF via Mac** + USB ops remain tester-visible acquisition path |

### Allowed work (M3 lane — Option A)

| Action | Owner | Notes |
| --- | --- | --- |
| **Internal debug spike builds** | RE / lab | `QWON_M3_MODEL_DOWNLOAD_SPIKE=1` — not TestFlight Release |
| **Docs / evidence append** | Cursor / Codex | Queue, index, lab evidence — no policy change without Product |
| **M3 implementation / default-on / Build `4`** | — | **Forbidden** until Product explicitly reopens Option B or C |

---

<a id="m3-readiness-status-2026-06-05"></a>

## M3 readiness status (2026-06-05) — historical

**Superseded by [M3 spike status (2026-06-07)](#m3-spike-status-2026-06-07).** Kept for audit trail.

**Batch A Ready · Batch B Ready · Batch C Ready · Batch D Ready · Gates 1–9 Ready · M3 spike plan added · Build `4` not approved.**

| Field | Value |
| --- | --- |
| **Checklist** | [M3 readiness gate checklist](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) — Gates **1–9** each have linked evidence memos ([#91](https://github.com/studio-prospect/qwon-ai-ios/pull/91)–[#95](https://github.com/studio-prospect/qwon-ai-ios/pull/95)) |
| **Gate status** | Gates **1–9 Ready** |
| **M3 in-app download spike** | **Merged** ([#118](https://github.com/studio-prospect/qwon-ai-ios/pull/118)) |
| **Build `4` / TestFlight upload / tag / version bump** | **Not approved** — Gate 9 separate from spike |
| **M2 rollback** | **Place GGUF via Mac** + USB ops remain known-good path |
| **Review plan** | [M3 gate readiness review plan](./qwon_m3_gate_readiness_review_plan.md) — batches A–D documented; Batch **A/B/C/D** Ready sign-offs recorded |
| **Batch A questionnaire** | [M3 Batch A external questionnaire](./qwon_m3_batch_a_external_questionnaire.md) / [日本語版](./qwon_m3_batch_a_external_questionnaire_ja.md) — shareable Product/legal/Codex question set |
| **Answer intake** | [M3 gate answer intake ledger](./qwon_m3_gate_answer_intake.md) — **49 questions · 49 answered**; Batch **A/B/C/D fully answered** and Gates **1–9 Ready** |
| **Gate 2 artifact record** | [Artifact finalization runbook](./qwon_m3_gate2_artifact_finalization_runbook.md) + [record template](./qwon_m3_gate2_artifact_record_template.md) — Q-A-06/Q-A-07 values recorded in intake and signed off for Gate **2** |

### Evidence memos (by gate)

| Gates | Memo |
| --- | --- |
| 1–2 | [Hosting + checksum](./qwon_m3_model_hosting_checksum_memo.md) |
| 3 | [Distribution compliance](./qwon_m3_model_distribution_compliance_memo.md) |
| 4–5 | [Storage + integrity](./qwon_m3_storage_integrity_memo.md) |
| 6–7 | [Network + device expectation](./qwon_m3_network_device_expectation_memo.md) |
| 8–9 | [Rollback + release gate](./qwon_m3_rollback_release_gate_memo.md) |

### Next allowed docs-only work (M3 lane) — historical

| Action | Owner | Notes |
| --- | --- | --- |
| ~~**M3 spike implementation PR**~~ | — | **Done** ([#118](https://github.com/studio-prospect/qwon-ai-ios/pull/118)) |
| **Build `4` release work** | — | **Forbidden** until separate Product release gate |

---

## How to use this queue

| Lane | Meaning |
| --- | --- |
| **Ready / low-risk docs-ops** | Safe to continue without product approval; docs and evidence only |
| **Ready / code only if blocker** | Code allowed **only** when triage confirms a release blocker on build **`3`** |
| **Conditional / product gate required** | Do **not** start without explicit product decision and linked gate docs |
| **Deferred / post-alpha** | Out of current alpha scope; plan elsewhere, do not slip into rename follow-ups |

Each item below lists: **trigger**, **required evidence**, **first doc to read**, **do not start if**.

---

## Ready / low-risk docs-ops

### Tester feedback intake — closed (2026-06-03)

| Field | Detail |
| --- | --- |
| **Status** | **Closed** — no new reports expected |
| **Final reports** | **QWON-FB-001** (Wang pass), **QWON-FB-002** (Matisse pass) — [intake triage log](./qwon_text_alpha_feedback_intake.md#triage-log-build-3) |
| **Outcome** | **Operational pass**; **no release blockers**; **build `4` not approved** |
| **Trigger to reopen** | Explicit product decision only (new binary, lab policy change, verified blocker on build `3`) |
| **First doc to read** | [QWON feedback intake — window close](./qwon_text_alpha_feedback_intake.md#feedback-window-close-2026-06-03) |
| **Do not start if** | Treating closed intake as build **`4`** approval; appending triage rows without reopen |

### QWON rename docs index maintenance

| Field | Detail |
| --- | --- |
| **Trigger** | New QWON product doc added; link rot; status line drift after a **merged** PR |
| **Required evidence** | Merged PR that changes doc ownership or reading order; no new policy without Codex plan |
| **First doc to read** | [QWON rename docs index](./qwon_rename_docs_index.md) |
| **Do not start if** | Using index maintenance to sneak in build `3` approval, project rename, or env/model migration |

### Lab evidence append (when evidence exists)

| Field | Detail |
| --- | --- |
| **Trigger** | New device smoke, screenshot set, or sign-off after **actual** lab run on build **`3`** |
| **Required evidence** | PNG/log artifacts in ops storage (`~/QWON-alpha-evidence/`); Wang/Matisse policy from prep doc |
| **First doc to read** | [QWON lab evidence](./qwon_text_alpha_lab_evidence.md) |
| **Do not start if** | No new run occurred; duplicating [frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) rows; committing binaries to git |

---

## Ready / code only if blocker

### Build `3` feedback triage — closed

| Field | Detail |
| --- | --- |
| **Status** | **Closed** (2026-06-03) — final triage rows logged; no blockers |
| **Trigger to reopen** | Product reopens intake or **verified release blocker** on **`0.1.0 (3)`** |
| **Required evidence** | Repro on **`0.1.0 (3)`**; template-complete report; Wang llama issues require **confirmed GGUF** |
| **First doc to read** | [QWON feedback intake](./qwon_text_alpha_feedback_intake.md) · [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) |
| **Do not start if** | Issue is cosmetic, model-quality-only, or unverified; using triage to justify build **`4`**; appending rows while window is closed |

### Minimal fix PR (verified release blocker only)

| Field | Detail |
| --- | --- |
| **Trigger** | Product/Codex confirms **one** minimal fix is required for build **`3`** usability |
| **Required evidence** | Triage row; repro; test plan on device; PR scoped to blocker — no drive-by rename |
| **First doc to read** | [Agent collaboration workflow](./agent_collaboration_workflow.md) · [Preserved PREXUS inventory](./qwon_preserved_prexus_surface_inventory.md) |
| **Do not start if** | No verified blocker; fix bundles project-container rename, env var rename, or global PREXUS replace; fix bumps build number without release-engineering plan |

---

## Conditional / product gate required

**Do not start any item in this section without explicit product approval.** Docs describe gates; they do **not** approve execution.

### Build `3` lab verification — completed (2026-06-03)

| Field | Detail |
| --- | --- |
| **Status** | **Done** — Wang primary manual smoke **pass**; Matisse secondary launch **pass** |
| **Evidence** | [lab evidence § build 3](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03) · ops PNGs under `~/QWON-alpha-evidence/` (`qwon-text-0.1.0-build3/` preferred; legacy `qwen-text-0.1.0-build3/` for 2026-06-03 lab captures) |
| **Note** | `alpha_smoke_wang.sh` is DEBUG-only; TestFlight Release uses manual verification |

### TestFlight upload build `4`

| Field | Detail |
| --- | --- |
| **Trigger** | Product approves next binary after build `3` lab sign-off and any blocker fixes |
| **Required evidence** | Successful Distribution archive; export compliance; lab re-smoke; explicit upload approval |
| **First doc to read** | [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) |
| **Do not start if** | Build `3` verification incomplete; no product upload approval; uploading to PREXUS ASC `6775110218` |

### Build `3` archive smoke (Phase 4E) — completed (upload)

**Status:** 4E docs gate (#65) + **intentional upload** (2026-06-02) + **lab verification** (2026-06-03). Do not re-run upload without product approval.

### TestFlight upload build `3` — completed

**Status:** **Done** — see [build 3 record](./qwon_text_alpha_testflight_prep.md#testflight-build-3-2026-06-02). Wang smoke **pass**; Matisse launch **pass**.

### Project container `PREXUS.xcodeproj` rename

| Field | Detail |
| --- | --- |
| **Trigger** | Product opens deferred infrastructure migration (not ordinary QWON feature work) |
| **Required evidence** | Scoped migration plan; CI/generator audit; full test matrix; inventory category 6 sign-off |
| **First doc to read** | [Preserved PREXUS inventory — deferred infrastructure](./qwon_preserved_prexus_surface_inventory.md) · [Phase 4 audit preserve list](./qwon_phase4_rename_surface_audit.md) |
| **Do not start if** | Bundled with feature work; done as cosmetic cleanup; build `3` gate not considered for release impact |

### Env / model filename migration (`PREXUS_*`, `prexus-local-mvp.gguf`, etc.)

| Field | Detail |
| --- | --- |
| **Trigger** | Product approves coordinated runtime + script + device smoke migration |
| **Required evidence** | Inventory category 2–4 checklist; device smoke scripts updated; persisted-data impact reviewed |
| **First doc to read** | [Preserved PREXUS inventory](./qwon_preserved_prexus_surface_inventory.md) |
| **Do not start if** | Global replace; partial rename (env only without scripts); no device re-smoke plan |

---

## Deferred / post-alpha

**Not in the current work queue for agents.** Track for planning; do not pull forward without a new Codex plan.

**Option catalog (v0.2+ lanes):** [QWON post-alpha option lanes](./qwon_post_alpha_options.md) — **Stay selected**; catalog for future lane lift only ([#123](https://github.com/studio-prospect/qwon-ai-ios/pull/123)).

### LiteRT adoption decision

| Field | Detail |
| --- | --- |
| **Trigger** | Product requests eval → production path decision |
| **Required evidence** | Device eval results; decision memo update |
| **First doc to read** | [LiteRT adoption decision](../research/litert_lm_adoption_decision.md) · [PREXUSLiteRTEval preserve note](./qwon_preserved_prexus_surface_inventory.md) |
| **Do not start if** | Conflated with QWON rename cleanup or build `3` |

### OCR / multimodal

| Field | Detail |
| --- | --- |
| **Trigger** | Phase 1+ roadmap item after alpha text path is stable |
| **Required evidence** | Codex plan; routing/memory impact |
| **First doc to read** | [Phase 1 remaining tasks memo](./phase1_remaining_tasks_design_memo.md) |
| **Do not start if** | Alpha release blocker work is unfinished; no architecture plan |

### Model download UX

| Field | Detail |
| --- | --- |
| **Status** | **Lane closed** — M3 Option A ([#121](https://github.com/studio-prospect/qwon-ai-ios/pull/121)); compile-gated default-off |
| **Trigger** | Product **lifts Stay** and reopens M3 or selects a new acquisition lane |
| **Required evidence** | [M3 spike outcome decision](./qwon_m3_spike_outcome_decision.md) · Codex scoped plan |
| **First doc to read** | [Model download / GGUF UX plan](./qwon_model_download_gguf_ux_plan.md) |
| **Do not start if** | Treating merged spike as active implementation lane while **Stay** is selected |

<a id="app-store-public-release"></a>

### App Store public release readiness (docs-only)

| Field | Detail |
| --- | --- |
| **Status** | **Checklist + intake ledger** — G1 + G2 + G3 + G4 **Closed/Ready**; **14 Unanswered**; **public release not approved** |
| **Trigger** | Product plans **public App Store horizon** (separate from Build `4`) |
| **Required evidence** | **G5 worksheet preparation** / model distribution policy (Q-AS-11 … Q-AS-12) — **no** submission or code |
| **Next stage** | **G5 worksheet preparation / model distribution policy** · [intake G5](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) |
| **First doc to read** | [Intake ledger — G5 model distribution policy](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) · [M3 distribution compliance memo](./qwon_m3_model_distribution_compliance_memo.md) |
| **Do not start if** | Conflated with Build `4` / TestFlight upload; treating checklist as implementation authorization; **Stay** lifted without explicit lane record |

### App Store public release (historical stub)

**Superseded by [App Store public release readiness (docs-only)](#app-store-public-release-readiness-docs-only).** Kept for link compatibility.

| Field | Detail |
| --- | --- |
| **Trigger** | Product exits text-alpha / TestFlight-only phase |
| **First doc to read** | [App Store public readiness checklist](./qwon_app_store_public_readiness_checklist.md) |

---

## Quick routing (agents)

| I want to… | Lane | Start here |
| --- | --- | --- |
| **Decide what to do next** | **Checkpoint** | [Post-M3 next lane decision](./qwon_post_m3_next_lane_decision.md) · [Next decision checkpoint](#next-decision-checkpoint) |
| Log tester feedback | **Closed** | [Feedback window close](./qwon_text_alpha_feedback_intake.md#feedback-window-close-2026-06-03) |
| Fix a bug | Ready / code if blocker | [Triage (closed)](#build-3-feedback-triage--closed) → [Minimal fix](#minimal-fix-pr-verified-release-blocker-only) |
| Verify build `3` lab | **Done** (2026-06-03) | [Lab evidence](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03) |
| Upload build `4` | Conditional | **Not approved** — product gate required |
| Rename `PREXUS.xcodeproj` | Conditional | [Inventory](./qwon_preserved_prexus_surface_inventory.md) — **deferred** |
| Clean up remaining PREXUS strings | **Stop** | [Inventory](./qwon_preserved_prexus_surface_inventory.md) first — default **preserve** |
| Plan UI polish / onboarding | **Complete** (UI-1) | [UI polish plan](./qwon_ui_polish_onboarding_plan.md) · UI-2 **deferred** |
| Select next post-alpha lane | **Stay selected** | [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record) |
| Model download / GGUF UX (M3) | **Closed** (Option A) | [M3 spike outcome decision](./qwon_m3_spike_outcome_decision.md) · [UX plan](./qwon_model_download_gguf_ux_plan.md) |
| Open UI-2 onboarding structure | **Deferred** | **Not approved** — [UI-2 need assessment](./qwon_ui_polish_onboarding_plan.md#ui-2-need-assessment-2026-06-03) |
| Add OCR / LiteRT / App Store readiness | Stay — docs-only | [Checklist](./qwon_app_store_public_readiness_checklist.md) · [Intake ledger](./qwon_app_store_public_readiness_intake.md) · [Selection matrix](./qwon_post_alpha_options.md#selection-matrix) |

---

## Agent note

Phase 4 rename **documentation is complete**. Build **`3`** is **stable alpha** on TestFlight; **feedback intake closed** (2026-06-03). **Stay selected** — docs/readme/index/evidence hygiene only; M3 Option A / lane **closed**. App Store **G1 + G2 + G3 + G4 Closed/Ready**; intake **14 Unanswered**; **public release not approved**. Build **`4`** / TestFlight upload / tag / version bump require **explicit product gate**. To start implementation, Product must **lift Stay** and select one lane + Codex scoped plan.
