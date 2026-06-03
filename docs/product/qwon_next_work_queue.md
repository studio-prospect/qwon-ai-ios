# QWON — Next Work Queue

**Last updated:** 2026-06-03 (post build `3` lab verification; feedback intake handoff)
**Status:** **Queue / guardrail only** — no implementation authorization in this document.
**Purpose:** After Phase 4 rename docs are complete, classify what agents **may** do next vs what requires **product gates**. Prevents drift into ungated **build `4`**, project-container rename, or blind PREXUS cleanup.

Related: [QWON rename docs index](./qwon_rename_docs_index.md) · [QWON feedback intake](./qwon_text_alpha_feedback_intake.md) · [Preserved PREXUS inventory](./qwon_preserved_prexus_surface_inventory.md) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

---

## Current baseline

| Field | Value |
| --- | --- |
| **Active TestFlight** | **QWON `0.1.0 (3)`** · ASC **`6775685841`** · Bundle **`jp.studio-prospect.qwon.ios`** |
| **Phase 4 rename docs** | **Complete** — index (#67), inventory (#66), Phase 4 series (#59–#65) |
| **Phase 4E ops** | **Upload done** (2026-06-02) — intentional Product/RE; docs record catches up |
| **Wang GGUF (build `3`)** | **Present** — re-pushed 2026-06-03 · [lab evidence](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03) |
| **Wang smoke / Matisse check (build `3`)** | **Done** (2026-06-03) — Wang manual smoke **pass** · Matisse launch **pass** |
| **Active app (repo)** | Target/scheme/module **`QWON`** · sources **`app/ios/QWON/`** |
| **Build `4`** | **Not approved** |
| **Project container rename** | **`PREXUS.xcodeproj`** — **deferred** |
| **Preserved PREXUS surfaces** | [Inventory](./qwon_preserved_prexus_surface_inventory.md) — env vars, model filenames, eval target, historical docs |

**Default posture:** Stay on TestFlight **`0.1.0 (3)`**; intake feedback and docs-ops unless a **verified release blocker** or **explicit product gate** says otherwise.

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

### Tester feedback intake (ongoing)

| Field | Detail |
| --- | --- |
| **Trigger** | New tester report arrives for QWON build **`3`**; ongoing alpha lab |
| **Required evidence** | Report using [QWON feedback intake template](./qwon_text_alpha_feedback_intake.md#copy-paste-template); device + build **`0.1.0 (3)`** |
| **First doc to read** | [QWON feedback intake](./qwon_text_alpha_feedback_intake.md) · [operational handoff](./qwon_text_alpha_feedback_intake.md#operational-handoff-when-a-real-report-arrives) · [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) |
| **Do not start if** | Treating intake as approval for build **`4`**; rewriting historical PREXUS feedback log baseline rows |

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

### Build `3` feedback triage

| Field | Detail |
| --- | --- |
| **Trigger** | Intake classifies an issue as **release blocker** vs watch / defer |
| **Required evidence** | Repro on **`0.1.0 (3)`**; steps; device; classification per [QWON intake rules](./qwon_text_alpha_feedback_intake.md#classification-rules); Wang llama issues require **confirmed GGUF** |
| **First doc to read** | [QWON feedback intake](./qwon_text_alpha_feedback_intake.md) · [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) · [Phase 4 plan — release blocker rule](./qwon_phase4_target_rename_plan.md#entry-gates) |
| **Do not start if** | Issue is cosmetic, model-quality-only, or unverified; Wang Fallback before GGUF confirmed; using triage to justify build **`4`** or rename cleanup |

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
| Log tester feedback | Ready / docs-ops | [QWON feedback intake](./qwon_text_alpha_feedback_intake.md) |
| Fix a bug | Ready / code if blocker | [Triage](#build-3-feedback-triage) → [Minimal fix](#minimal-fix-pr-verified-release-blocker-only) |
| Verify build `3` lab | **Done** (2026-06-03) | [Lab evidence](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03) |
| Upload build `4` | Conditional | **Not approved** — product gate required |
| Rename `PREXUS.xcodeproj` | Conditional | [Inventory](./qwon_preserved_prexus_surface_inventory.md) — **deferred** |
| Clean up remaining PREXUS strings | **Stop** | [Inventory](./qwon_preserved_prexus_surface_inventory.md) first — default **preserve** |
| Add OCR / LiteRT / App Store | Deferred | This queue — **post-alpha** |

---

## Agent note

Phase 4 rename **documentation is complete**. Build **`3` upload is done**; complete lab verification and intake before build **`4`**. Ordinary QWON work should **not** reopen rename series, global replace, or ungated upload.
