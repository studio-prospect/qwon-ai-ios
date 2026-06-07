# QWON — Post-M3 Next Lane Decision Checkpoint

**Last updated:** 2026-06-07 (Stay selected — active docs wording audit)
**Status:** **Stay selected** — no third post-alpha lane. M3 **Option A selected / lane closed**. **Build `4` not approved.** **TestFlight upload / tag / version bump not approved.**
**Purpose:** After [Model download / GGUF UX](./qwon_model_download_gguf_ux_plan.md) M3 spike completion ([#118](https://github.com/studio-prospect/qwon-ai-ios/pull/118), verification [#119](https://github.com/studio-prospect/qwon-ai-ios/pull/119), outcome [#120](https://github.com/studio-prospect/qwon-ai-ios/pull/120), Option A [#121](https://github.com/studio-prospect/qwon-ai-ios/pull/121)), give Product a **comparable view** of remaining post-alpha lanes. **Docs-only** — does **not** authorize implementation, spike, or release ops.

Related: [Post-alpha option lanes](./qwon_post_alpha_options.md) · [Next work queue](./qwon_next_work_queue.md#next-decision-checkpoint) · [M3 spike outcome decision](./qwon_m3_spike_outcome_decision.md) · [Rename docs index](./qwon_rename_docs_index.md) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

---

## 1. Current state

| Field | Value |
| --- | --- |
| **TestFlight** | **QWON `0.1.0 (3)`** — **stable alpha** · ASC **`6775685841`** |
| **Feedback intake** | **Closed** — **QWON-FB-001**, **QWON-FB-002** operational pass; **no blockers** |
| **Build `4`** | **Not approved** — no TestFlight upload, tag, or version bump |
| **UI-1** | **Complete** — [#80](https://github.com/studio-prospect/qwon-ai-ios/pull/80), verification [#81](https://github.com/studio-prospect/qwon-ai-ios/pull/81) |
| **UI-2** | **Deferred / not opened** — [#82](https://github.com/studio-prospect/qwon-ai-ios/pull/82) · [need assessment](./qwon_ui_polish_onboarding_plan.md#ui-2-need-assessment-2026-06-03) |
| **Model download / GGUF UX** | M1/M2 **complete** · M3 spike **merged** · **Option A selected** — compile-gated **default-off** · lane **closed** · [decision record](./qwon_m3_spike_outcome_decision.md#decision-record) |
| **Tester-visible model acquisition** | M2 **Place GGUF via Mac** + USB ops — unchanged on TestFlight **`0.1.0 (3)`** |
| **Next lane selected** | **Stay** — no third post-alpha lane · [decision record](#decision-record) |

**Closed lanes (do not re-select without new Product record):**

| Lane | Outcome |
| --- | --- |
| **UI polish / onboarding (UI-1)** | **Complete** |
| **Model download / GGUF UX (M3 spike)** | **Closed** — Option A; internal/debug evidence only |

---

## 2. Next lane candidates

Product may choose **Stay** (recommended default) or **one** lane. Do **not** start multiple lanes from this checkpoint.

| # | Candidate | Summary | First safe step | Gate |
| --- | --- | --- | --- | --- |
| **0** | **Stay / docs-ops hygiene** | Maintain TestFlight **`0.1.0 (3)`**; index/queue/evidence docs only | [Ready / low-risk docs-ops](./qwon_next_work_queue.md#ready--low-risk-docs-ops) | **Default** — no product gate for docs |
| **1** | **UI-2 reopen** | Structural onboarding — **not opened** since UI-1 | [UI-2 need assessment](./qwon_ui_polish_onboarding_plan.md#ui-2-need-assessment-2026-06-03) | **New evidence required** — Product re-open only |
| **2** | **OCR / camera / multimodal planning** | Camera/OCR as orchestrator input — planning only | [OCR / camera option](./qwon_post_alpha_options.md#2-ocr--camera-input) · Codex design memo | Product selects lane → Codex scoped plan |
| **3** | **LiteRT follow-up planning** | Local backend policy beyond llama.cpp + Embedded Heuristic | [LiteRT option](./qwon_post_alpha_options.md#1-litert--local-backend-policy) · [research memo](../research/litert_lm_adoption_decision.md) | Product selects lane → Codex scoped plan |
| **4** | **App Store public release readiness** | Long-term exit from TestFlight-only — checklist only | [App Store public readiness checklist](./qwon_app_store_public_readiness_checklist.md) | **Separate** from Build `4`; product horizon gate |
| **5** | **Phase 4 residual cleanup** | e.g. **`PREXUS.xcodeproj`** container rename — **deferred** | [Preserved inventory](./qwon_preserved_prexus_surface_inventory.md) · [project container option](./qwon_post_alpha_options.md#4-project-container-rename-prexusxcodeproj) | Product **explicitly** wants infra cleanup — not default hygiene |
| **6** | **Runtime memory / context retention** | Durable cognitive layer — high privacy/runtime impact | [Memory option](./qwon_post_alpha_options.md#6-runtime-memory--context-retention) | Product selects lane → Codex scoped plan |

**Not a next lane (separate gates):**

| Item | Why listed separately |
| --- | --- |
| **Build `4` / new TestFlight binary** | Release-engineering gate — not a post-alpha feature lane · [TestFlight prep](./qwon_text_alpha_testflight_prep.md#phase-4-build-3-decision-gate) |
| **M3 default-on / Option C hardening** | M3 lane **closed** — reopen only via [M3 outcome decision](./qwon_m3_spike_outcome_decision.md#decision-record) |

---

## 3. Recommended default

| Recommendation | Rationale |
| --- | --- |
| **Stay** unless Product selects **exactly one** next lane | TestFlight **`0.1.0 (3)`** is stable; M3 spike evidence is complete; no verified release blocker |
| **Do not start implementation while Stay is in effect** | Allowed work: docs/readme/index/evidence hygiene only |
| **To start a new lane** | Product must **lift Stay** and record one candidate in the Decision record — then Codex scoped plan → Cursor implementation |

**Current posture (2026-06-07):** **Stay selected** — recorded below.

---

## 4. Guardrails

| Do not do | Why |
| --- | --- |
| **Build `4`**, TestFlight upload, tag, or version bump | **Not approved** |
| **Default-on M3** downloader or M3 lane reopen without Product gate | Option A — compile-gated default-off |
| **Swift / app / tools / pbxproj changes** from this checkpoint | Docs-only decision surface |
| **PREXUS historical rewrite** (`qwen_text_only_alpha_*`, frozen ledger rows) | Immutable baseline |
| **GGUF / IPA / logs / screenshots commit to git** | Ops storage only |
| **Global PREXUS string cleanup** outside scoped migration PR | [Preserved inventory](./qwon_preserved_prexus_surface_inventory.md) |
| **Open UI-2** without new evidence | [UI-2 need assessment](./qwon_ui_polish_onboarding_plan.md#ui-2-need-assessment-2026-06-03) |
| **Start implementation/spike** without Codex scoped plan merge | Checkpoint is **selection only** |

---

## 5. Workflow after Product decides

While **Stay** is selected, agents follow [Ready / low-risk docs-ops](./qwon_next_work_queue.md#ready--low-risk-docs-ops) only.

To **lift Stay** and open a new lane:

1. Product records **one lane** (not Stay) in the [Decision record](#decision-record) below.
2. **Codex** opens a **scoped plan** for that lane — **not** automatic.
3. **Cursor** implements or spikes — only after plan merge and any required product gate.
4. **Build `4`** remains a **separate** decision even if a lane is selected.

---

## Decision record

| Field | Value |
| --- | --- |
| **Date** | **2026-06-07** |
| **Posture** | **Stay** |
| **Third post-alpha lane selected?** | **No** |
| **Build `4` approved?** | **No** |
| **Approver** | Product decision (docs record) |
| **Notes** | No third post-alpha lane selected. QWON remains on TestFlight **`0.1.0 (3)`**. Allowed work is docs/readme/index/evidence hygiene only. Any future UI-2 / OCR / LiteRT / App Store / project-container rename / memory work requires lifting Stay, a new Product lane decision, and a Codex scoped plan. M3 Option A / lane closed unchanged ([#121](https://github.com/studio-prospect/qwon-ai-ios/pull/121)). Checkpoint [#122](https://github.com/studio-prospect/qwon-ai-ios/pull/122). Stay recorded [#123](https://github.com/studio-prospect/qwon-ai-ios/pull/123). |

---

## Active docs wording audit (2026-06-07)

Cross-doc hygiene pass: active/current tables and entry points aligned to **Stay selected** / **feedback intake closed** / **Build `4` not approved**; historical sections left intact with **historical** or **superseded** labels where needed.
