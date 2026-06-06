# QWON — Next Work Queue

**Last updated:** 2026-06-06 (M3 Batch B / Gates 4–5 Ready — docs-only)
**Status:** **Queue / guardrail only** — no implementation authorization in this document.
**Purpose:** After Phase 4 rename docs are complete, classify what agents **may** do next vs what requires **product gates**. Prevents drift into ungated **build `4`**, project-container rename, or blind PREXUS cleanup.

Related: [QWON rename docs index](./qwon_rename_docs_index.md) · [Next decision checkpoint](#next-decision-checkpoint) · [Model download / GGUF UX plan](./qwon_model_download_gguf_ux_plan.md) · [Model download / GGUF UX decision](./qwon_model_download_gguf_ux_decision.md) · [Post-alpha next lane checkpoint](./qwon_post_alpha_options.md#next-lane-selection-checkpoint-2026-06-03) · [UI polish / onboarding plan](./qwon_ui_polish_onboarding_plan.md) · [QWON feedback intake](./qwon_text_alpha_feedback_intake.md) · [Preserved PREXUS inventory](./qwon_preserved_prexus_surface_inventory.md) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

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

### Current (2026-06-03)

| Field | Value |
| --- | --- |
| **TestFlight** | **QWON `0.1.0 (3)`** — **stable alpha** · ASC **`6775685841`** |
| **Feedback** | **Closed** — **QWON-FB-001**, **QWON-FB-002** operational pass only; **no blockers** · [intake close](./qwon_text_alpha_feedback_intake.md#feedback-window-close-2026-06-03) |
| **Build `4`** | **Not approved** — no upload, tag, or version bump without explicit product gate |
| **Lab** | Wang + Matisse build `3` verified · [lab evidence](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03) |
| **First post-alpha lane** | **UI polish / onboarding — complete** (UI-1 #80, #81) · UI-2 **deferred** (#82) |
| **Selected next lane** | **[Model download / GGUF UX](./qwon_model_download_gguf_ux_decision.md)** |
| **Scoped plan** | **[qwon_model_download_gguf_ux_plan.md](./qwon_model_download_gguf_ux_plan.md)** — M1/M2 **complete** ([#86](https://github.com/studio-prospect/qwon-ai-ios/pull/86)–[#89](https://github.com/studio-prospect/qwon-ai-ios/pull/89)); M3 Gates **1–5 Ready**; Gates **6–9 Pending** |
| **Next agent step** | **Do not open M3 spike** — next valid M3 docs step is Batch **C** answer intake for Gates **6–7**; **Build `4` not approved** |

### Choose a branch

| Branch | When | First doc | Agent default |
| --- | --- | --- | --- |
| **Stay** | Maintain build **`3`**; no new binary; docs/readme hygiene only | This queue — [Ready / low-risk docs-ops](#ready--low-risk-docs-ops) | **Yes** — M1/M2 complete; M3 Gates **1–5 Ready**; Gates **6–9 Pending** |
| **Product gate: build `4` decision** | Product explicitly evaluates whether a **new TestFlight binary** is warranted | [TestFlight prep — build `4` gate](./qwon_text_alpha_testflight_prep.md#phase-4-build-3-decision-gate) · [Conditional upload build `4`](#testflight-upload-build-4) | **No** — gate docs only until product approves |
| **Post-alpha: Model download / GGUF UX** | M1/M2 complete; M3 checklist documented | [M3 readiness checklist](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) · [M3 readiness status](#m3-readiness-status-2026-06-05) | **No default** — Gates **6–9 Pending**; no in-app download spike |

**Build `4` decision ≠ build `4` approved.** Documenting criteria or opening a product discussion does **not** authorize archive, upload, tag, or `CFBundleVersion` bump.

### Next allowed actions (without product gate)

| Action | Lane |
| --- | --- |
| Docs / README / index maintenance | [Ready / low-risk docs-ops](#ready--low-risk-docs-ops) |
| **Product-approved build `4` planning** docs only (criteria, checklist, gate memo — **not** upload) | [Conditional — build `4`](#testflight-upload-build-4) |
| Post-alpha — **Model download / GGUF UX** | [Scoped plan](./qwon_model_download_gguf_ux_plan.md) · [Decision memo](./qwon_model_download_gguf_ux_decision.md) |
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

## M3 readiness status (2026-06-05)

**Batch A Ready · Batch B Ready · Gates 6–9 Pending · M3 spike not open · Build `4` not approved.**

| Field | Value |
| --- | --- |
| **Checklist** | [M3 readiness gate checklist](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) — Gates **1–9** each have linked evidence memos ([#91](https://github.com/studio-prospect/qwon-ai-ios/pull/91)–[#95](https://github.com/studio-prospect/qwon-ai-ios/pull/95)) |
| **Gate status** | Gates **1–5 Ready**; Gates **6–9 Pending** |
| **M3 in-app download spike** | **Not approved** — do **not** open until every gate is Ready + Codex scoped plan |
| **Build `4` / TestFlight upload / tag / version bump** | **Not approved** — Gate 9 separate from spike |
| **M2 rollback** | **Place GGUF via Mac** + USB ops remain known-good path |
| **Review plan** | [M3 gate readiness review plan](./qwon_m3_gate_readiness_review_plan.md) — batches A–D documented; Batch **A/B** Ready sign-offs recorded |
| **Batch A questionnaire** | [M3 Batch A external questionnaire](./qwon_m3_batch_a_external_questionnaire.md) / [日本語版](./qwon_m3_batch_a_external_questionnaire_ja.md) — shareable Product/legal/Codex question set |
| **Answer intake** | [M3 gate answer intake ledger](./qwon_m3_gate_answer_intake.md) — **49 questions · 24 answered**; Batch **A/B fully answered** and Gates **1–5 Ready** |
| **Gate 2 artifact record** | [Artifact finalization runbook](./qwon_m3_gate2_artifact_finalization_runbook.md) + [record template](./qwon_m3_gate2_artifact_record_template.md) — Q-A-06/Q-A-07 values recorded in intake and signed off for Gate **2** |

### Evidence memos (by gate)

| Gates | Memo |
| --- | --- |
| 1–2 | [Hosting + checksum](./qwon_m3_model_hosting_checksum_memo.md) |
| 3 | [Distribution compliance](./qwon_m3_model_distribution_compliance_memo.md) |
| 4–5 | [Storage + integrity](./qwon_m3_storage_integrity_memo.md) |
| 6–7 | [Network + device expectation](./qwon_m3_network_device_expectation_memo.md) |
| 8–9 | [Rollback + release gate](./qwon_m3_rollback_release_gate_memo.md) |

### Next allowed docs-only work (M3 lane)

| Action | Owner | Notes |
| --- | --- | --- |
| **Batch C answer intake** | Product / Codex | Next candidate for network disclosure / device-tier copy; docs-only; **not** implementation |
| **M3 spike implementation** | — | **Forbidden** until all gates Ready |

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

**Option catalog (v0.2+ lanes):** [QWON post-alpha option lanes](./qwon_post_alpha_options.md) — **selected:** [UI polish / onboarding](./qwon_post_alpha_options.md#product-lane-decision) with [scoped plan](./qwon_ui_polish_onboarding_plan.md).

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
| **Trigger** | Product prioritizes on-device model acquisition UX post-alpha |
| **Required evidence** | UX/design memo; storage and battery constraints |
| **First doc to read** | [models/README.md](../../models/README.md) · [local inference MVP](../requirements/local_inference_mvp.md) |
| **Do not start if** | Requires renaming `prexus-local-mvp.gguf` without approved migration PR |

### App Store public release

| Field | Detail |
| --- | --- |
| **Trigger** | Product exits text-alpha / TestFlight-only phase |
| **Required evidence** | Full release checklist; compliance; marketing — **explicitly out of scope** today |
| **First doc to read** | [QWON TestFlight prep — out of scope](./qwon_text_alpha_testflight_prep.md) |
| **Do not start if** | Still in text-alpha; conflated with build `3` archive smoke |

---

## Quick routing (agents)

| I want to… | Lane | Start here |
| --- | --- | --- |
| **Decide what to do next** | **Checkpoint** | [Next decision checkpoint](#next-decision-checkpoint) |
| Log tester feedback | **Closed** | [Feedback window close](./qwon_text_alpha_feedback_intake.md#feedback-window-close-2026-06-03) |
| Fix a bug | Ready / code if blocker | [Triage (closed)](#build-3-feedback-triage--closed) → [Minimal fix](#minimal-fix-pr-verified-release-blocker-only) |
| Verify build `3` lab | **Done** (2026-06-03) | [Lab evidence](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03) |
| Upload build `4` | Conditional | **Not approved** — product gate required |
| Rename `PREXUS.xcodeproj` | Conditional | [Inventory](./qwon_preserved_prexus_surface_inventory.md) — **deferred** |
| Clean up remaining PREXUS strings | **Stop** | [Inventory](./qwon_preserved_prexus_surface_inventory.md) first — default **preserve** |
| Plan UI polish / onboarding | **Complete** (UI-1) | [UI polish plan](./qwon_ui_polish_onboarding_plan.md) · UI-2 **deferred** |
| Select next post-alpha lane | **Done** — [Model download / GGUF UX decision](./qwon_model_download_gguf_ux_decision.md) |
| Plan Model download / GGUF UX | **M1/M2 complete** · **M3 Gates 1–5 Ready / Gates 6–9 Pending** | [Review plan](./qwon_m3_gate_readiness_review_plan.md) · [M3 status](#m3-readiness-status-2026-06-05) |
| Open UI-2 onboarding structure | **Deferred** | **Not approved** — [UI-2 need assessment](./qwon_ui_polish_onboarding_plan.md#ui-2-need-assessment-2026-06-03) |
| Add OCR / LiteRT / App Store | Deferred | [Selection matrix](./qwon_post_alpha_options.md#selection-matrix) |

---

## Agent note

Phase 4 rename **documentation is complete**. Build **`3`** is **stable alpha** on TestFlight; **feedback intake closed** (2026-06-03). **UI polish UI-1 complete**; **UI-2 deferred**. **Model download / GGUF UX M1/M2 merged**; **M3 readiness: Gates 1–5 Ready, Gates 6–9 Pending** — [status section](#m3-readiness-status-2026-06-05); **M3 spike not approved**. Build **`4`** / TestFlight upload / tag / version bump require **explicit product gate**. No in-app download, GGUF commit, or UI-2 without gates.
