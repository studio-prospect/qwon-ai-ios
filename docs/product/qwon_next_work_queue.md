# QWON — Next Work Queue

**Last updated:** 2026-06-02 (post PR #67 on `main`)
**Status:** **Queue / guardrail only** — no implementation authorization in this document.
**Purpose:** After Phase 4 rename docs are complete, classify what agents **may** do next vs what requires **product gates**. Prevents drift into build `3`, project-container rename, or blind PREXUS cleanup.

Related: [QWON rename docs index](./qwon_rename_docs_index.md) · [Preserved PREXUS inventory](./qwon_preserved_prexus_surface_inventory.md) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

---

## Current baseline

| Field | Value |
| --- | --- |
| **Active TestFlight** | **QWON `0.1.0 (2)`** · ASC **`6775685841`** · Bundle **`jp.studio-prospect.qwon.ios`** |
| **Phase 4 rename docs** | **Complete** — index (#67), inventory (#66), Phase 4 series (#59–#65) |
| **Active app (repo)** | Target/scheme/module **`QWON`** · sources **`app/ios/QWON/`** |
| **Build `3`** | **Not approved / not executed** |
| **Project container rename** | **`PREXUS.xcodeproj`** — **deferred** |
| **Preserved PREXUS surfaces** | [Inventory](./qwon_preserved_prexus_surface_inventory.md) — env vars, model filenames, eval target, historical docs |

**Default posture:** Stay on TestFlight **`0.1.0 (2)`**; intake feedback and docs-ops unless a **verified release blocker** or **explicit product gate** says otherwise.

---

## How to use this queue

| Lane | Meaning |
| --- | --- |
| **Ready / low-risk docs-ops** | Safe to continue without product approval; docs and evidence only |
| **Ready / code only if blocker** | Code allowed **only** when triage confirms a release blocker on build `2` |
| **Conditional / product gate required** | Do **not** start without explicit product decision and linked gate docs |
| **Deferred / post-alpha** | Out of current alpha scope; plan elsewhere, do not slip into rename follow-ups |

Each item below lists: **trigger**, **required evidence**, **first doc to read**, **do not start if**.

---

## Ready / low-risk docs-ops

### Tester feedback intake (ongoing)

| Field | Detail |
| --- | --- |
| **Trigger** | New tester report arrives for QWON build `2`; ongoing alpha lab |
| **Required evidence** | Report using [PREXUS-era feedback template](./qwen_text_only_alpha_tester_instructions.md#tester-feedback-report-template) until QWON-specific copy exists; device + build number |
| **First doc to read** | [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) → [PREXUS intake rules](./qwen_text_only_alpha_release_notes.md#feedback-intake-processing-build-1) (process pattern; log rows append-only) |
| **Do not start if** | Treating intake as approval for build `3`; rewriting historical PREXUS feedback log baseline rows |

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
| **Trigger** | New device smoke, screenshot set, or sign-off after **actual** lab run on build `2` |
| **Required evidence** | PNG/log artifacts in ops storage (`~/QWON-alpha-evidence/`); Wang/Matisse policy from prep doc |
| **First doc to read** | [QWON lab evidence](./qwon_text_alpha_lab_evidence.md) |
| **Do not start if** | No new run occurred; duplicating [frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) rows; committing binaries to git |

---

## Ready / code only if blocker

### Build `2` feedback triage

| Field | Detail |
| --- | --- |
| **Trigger** | Intake classifies an issue as **release blocker** vs watch / defer |
| **Required evidence** | Repro on **`0.1.0 (2)`**; steps; device; severity aligned with [known-issues triage pattern](./qwen_text_only_alpha_release_notes.md#known-issues-triage-for-build-1) |
| **First doc to read** | [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) · [Phase 4 plan — release blocker rule](./qwon_phase4_target_rename_plan.md#entry-gates) |
| **Do not start if** | Issue is cosmetic, model-quality-only, or unverified; using triage to justify build `3` or rename cleanup |

### Minimal fix PR (verified release blocker only)

| Field | Detail |
| --- | --- |
| **Trigger** | Product/Codex confirms **one** minimal fix is required for build `2` usability |
| **Required evidence** | Triage row; repro; test plan on device; PR scoped to blocker — no drive-by rename |
| **First doc to read** | [Agent collaboration workflow](./agent_collaboration_workflow.md) · [Preserved PREXUS inventory](./qwon_preserved_prexus_surface_inventory.md) |
| **Do not start if** | No verified blocker; fix bundles project-container rename, env var rename, or global PREXUS replace; fix bumps build number without release-engineering plan |

---

## Conditional / product gate required

**Do not start any item in this section without explicit product approval.** Docs describe gates; they do **not** approve execution.

### Build `3` archive smoke (Phase 4E)

| Field | Detail |
| --- | --- |
| **Trigger** | Product asks whether rename closure needs a **new binary** validated on archive/device tooling |
| **Required evidence** | All [4E entry gates](./qwon_phase4_target_rename_plan.md#pr-4e--optional-archive-smoke-decision-gate) true; at least one motivator in [TestFlight build `3` gate](./qwon_text_alpha_testflight_prep.md#phase-4-build-3-decision-gate) |
| **First doc to read** | [Phase 4 target rename plan — PR 4E](./qwon_phase4_target_rename_plan.md#pr-4e--optional-archive-smoke-decision-gate) |
| **Do not start if** | Build `2` has an unresolved release blocker; motivator is “rename feels incomplete” alone; treating 4E as automatic next step |

### TestFlight upload build `3`

| Field | Detail |
| --- | --- |
| **Trigger** | Product approves upload **after** archive smoke passes (if 4E ran) |
| **Required evidence** | Successful Distribution archive; export compliance; lab re-smoke; explicit upload approval — separate from 4E docs |
| **First doc to read** | [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) · [build `3` numbering rules](./qwon_text_alpha_testflight_prep.md#phase-4-build-3-decision-gate) |
| **Do not start if** | 4E not evaluated; archive smoke failed; no product upload approval; uploading to PREXUS ASC `6775110218` |

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
| Log tester feedback | Ready / docs-ops | [Feedback intake](#tester-feedback-intake-ongoing) |
| Fix a bug | Ready / code if blocker | [Triage](#build-2-feedback-triage) → [Minimal fix](#minimal-fix-pr-verified-release-blocker-only) |
| Archive build `3` | Conditional | [4E gate](./qwon_phase4_target_rename_plan.md#pr-4e--optional-archive-smoke-decision-gate) — **not approved** |
| Rename `PREXUS.xcodeproj` | Conditional | [Inventory](./qwon_preserved_prexus_surface_inventory.md) — **deferred** |
| Clean up remaining PREXUS strings | **Stop** | [Inventory](./qwon_preserved_prexus_surface_inventory.md) first — default **preserve** |
| Add OCR / LiteRT / App Store | Deferred | This queue — **post-alpha** |

---

## Agent note

Phase 4 rename **documentation is complete**. Ordinary QWON work should **not** reopen rename series, global replace, or build `3` unless product explicitly moves an item from **Conditional** to approved execution with evidence recorded in the linked docs.
