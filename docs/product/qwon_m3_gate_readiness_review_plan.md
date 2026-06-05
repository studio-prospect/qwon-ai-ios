# QWON — M3 Gate Readiness Review Plan

**Last updated:** 2026-06-05
**Status:** **Review plan only** — **not** gate Ready sign-off, **not** M3 implementation approval, **not** Build `4` approval.
**Purpose:** Define **review order**, **owners**, **required evidence**, and **exit criteria** for moving M3 checklist Gates **1–9** from **Pending** to **Ready**. Evidence memos exist ([#91](https://github.com/studio-prospect/qwon-ai-ios/pull/91)–[#95](https://github.com/studio-prospect/qwon-ai-ios/pull/95)); this plan does **not** mark any gate **Ready**.

Related: [M3 readiness checklist](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) · [Queue — M3 status](./qwon_next_work_queue.md#m3-readiness-status-2026-06-05) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

---

## Current state (unchanged by this plan)

| Field | Value |
| --- | --- |
| **Gates 1–9** | Evidence memos linked — **all Pending** |
| **M3 in-app download spike** | **Not approved** |
| **Build `4` / TestFlight upload / tag / version bump** | **Not approved** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** |
| **M2 rollback** | **Place GGUF via Mac** + USB ops — must remain |

---

## Review principles

| Principle | Rule |
| --- | --- |
| **Docs-first** | Ready decisions recorded in **docs-only PRs** with linked evidence — no Swift, no GGUF commit |
| **Batch order** | **A → B → C → D** — later batches may depend on earlier decisions |
| **No partial spike** | Do **not** open M3 downloader code until **all nine** gates are **Ready** |
| **Build `4` separate** | Gate 9 Ready ≠ TestFlight upload approval |
| **Codex vs Product** | **Codex** — architecture, checksum policy, integrity mechanics. **Product** — hosting owner, copy, legal escalation, release timing. **Legal** — Gate 3 only (Product coordinates) |

---

## Review batch overview

| Batch | Gates | Theme | Suggested order | Memo |
| --- | --- | --- | --- | --- |
| **A** | 1–3 | Hosting, checksum, compliance | **1st** | [Hosting + checksum](./qwon_m3_model_hosting_checksum_memo.md) · [Compliance](./qwon_m3_model_distribution_compliance_memo.md) |
| **B** | 4–5 | Storage budget, download integrity | **2nd** | [Storage + integrity](./qwon_m3_storage_integrity_memo.md) |
| **C** | 6–7 | Network disclosure, device tiers | **3rd** | [Network + device expectation](./qwon_m3_network_device_expectation_memo.md) |
| **D** | 8–9 | Rollback path, release gate | **4th** | [Rollback + release gate](./qwon_m3_rollback_release_gate_memo.md) |

**All batches:** current disposition **Pending** — this plan does **not** change checklist rows.

---

## Batch A — Gates 1–3: Hosting, checksum, compliance

### Gates in scope

| Gate | Topic | Evidence memo |
| --- | --- | --- |
| **1** | Model hosting source / URL ownership | [Hosting memo — Gate 1](./qwon_m3_model_hosting_checksum_memo.md#gate-1--model-hosting-source--url-ownership) |
| **2** | SHA-256 checksum and expected byte size | [Hosting memo — Gate 2](./qwon_m3_model_hosting_checksum_memo.md#gate-2--sha-256-checksum-and-expected-byte-size) |
| **3** | License / redistribution / export compliance | [Compliance memo](./qwon_m3_model_distribution_compliance_memo.md) |

### Owners

| Role | Responsibility |
| --- | --- |
| **Product** | Hosting owner; approve or reject third-party HF as product URL; legal escalation for Gate 3 |
| **Codex** | Checksum policy; reproducibility; architecture sign-off on hosting option |
| **Legal** (via Product) | Gate 3 license, redistribution, export compliance **written confirmation** |

### Required evidence (to mark Ready — **not produced by this plan**)

| Gate | Evidence Product/Codex must produce |
| --- | --- |
| **1** | Named storage/CDN owner; approved HTTPS URL or “self-host artifact X” decision; reproducibility pin (version/object key) |
| **2** | Published SHA-256 + exact byte size for **Gate 1 artifact**; verification policy doc |
| **3** | Legal/Product sign-off memo revision or checklist row update — not investigation memo alone |

### Exit criteria (batch A complete)

1. Gates **1–3** checklist rows updated to **Ready** in a **separate docs-only sign-off PR** (future).
2. Gate **2** byte size matches Gate **1** pinned artifact (no range).
3. Gate **3** explicitly **not blocked** on redistribution for chosen hosting model.
4. Dev ops HF URL remains documented as **not** product hosting unless Product explicitly approves otherwise.

### Blocked-by

| Gate | Blocked by |
| --- | --- |
| **1** | Product hosting decision; Gate 3 legal input on redistribution |
| **2** | Gate **1** approved artifact |
| **3** | Legal/Product review of [HF primary links](./qwon_m3_model_distribution_compliance_memo.md#primary-source-links-product--legal-traceability) |

### Batch A disposition

| Field | Value |
| --- | --- |
| **Status** | **Pending** |
| **Ready?** | **No** |

---

## Batch B — Gates 4–5: Storage budget, download integrity

### Gates in scope

| Gate | Topic | Evidence memo |
| --- | --- | --- |
| **4** | iOS storage budget / available-space check | [Storage memo — Gate 4](./qwon_m3_storage_integrity_memo.md#gate-4--ios-storage-budget-and-available-space-check) |
| **5** | Partial download / resume / atomic move | [Storage memo — Gate 5](./qwon_m3_storage_integrity_memo.md#gate-5--partial-download--resume--atomic-move-plan) |

### Owners

| Role | Responsibility |
| --- | --- |
| **Product** | Minimum free-space threshold; user-visible failure copy for insufficient space |
| **Codex** | Temp filename strategy; atomic promote; resume vs clean-retry policy; integrity state machine |

### Required evidence (future sign-off PR)

| Gate | Evidence |
| --- | --- |
| **4** | Documented minimum bytes free before download (= Gate 2 size + temp peak + Product margin) |
| **5** | Named temp path; atomic move spec; resume decision (required vs optional); corrupt/partial → Diagnostics mapping |

### Exit criteria (batch B complete)

1. Gates **4–5** marked **Ready** in sign-off PR.
2. Gate **4** threshold math references **Gate 2** final byte size (not ~379–400 MB range).
3. Gate **5** defers no required behavior to “TBD at implementation” without Product ack.
4. `Documents/Models/prexus-local-mvp.gguf` contract unchanged.

### Blocked-by

| Gate | Blocked by |
| --- | --- |
| **4** | Gate **2** pinned byte size; Gate **5** temp peak assumption |
| **5** | Gate **2** verification policy; Gate **4** headroom policy |

### Batch B disposition

| Field | Value |
| --- | --- |
| **Status** | **Pending** |
| **Ready?** | **No** |

---

## Batch C — Gates 6–7: Network disclosure, device expectation

### Gates in scope

| Gate | Topic | Evidence memo |
| --- | --- | --- |
| **6** | Privacy / network disclosure copy | [Network memo — Gate 6](./qwon_m3_network_device_expectation_memo.md#gate-6--privacy--network-disclosure-copy) |
| **7** | Wang / Matisse behavior expectation | [Network memo — Gate 7](./qwon_m3_network_device_expectation_memo.md#gate-7--wang--matisse-behavior-expectation) |

### Owners

| Role | Responsibility |
| --- | --- |
| **Product** | Final Settings/TestFlight/onboarding copy; privacy label impact; Matisse download visibility |
| **Codex** | Copy migration list (M2 strings retire vs keep); Diagnostics mapping consistency |

### Required evidence (future sign-off PR)

| Gate | Evidence |
| --- | --- |
| **6** | Approved disclosure strings; no-surprise-fetch rule; ASC/privacy label decision if needed |
| **7** | Tier matrix signed off; Matisse “not a failure” copy; Wang optional-download framing |

### Exit criteria (batch C complete)

1. Gates **6–7** marked **Ready** in sign-off PR.
2. Gate **6** copy **consistent** with M2 [guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement) — no contradictory “never uses network” claims after download ships.
3. Gate **7** drafts in memo **replaced or adopted** as Product-approved final copy list (still docs-only until UI PR gated separately).
4. Matisse download prompts do **not** imply device failure.

### Blocked-by

| Gate | Blocked by |
| --- | --- |
| **6** | Gate **3** privacy/export angle; Product copy owner |
| **7** | Gate **5** integrity states surfaced in UI; Gate **6** network framing |

### Batch C disposition

| Field | Value |
| --- | --- |
| **Status** | **Pending** |
| **Ready?** | **No** |

---

## Batch D — Gates 8–9: Rollback, release gate

### Gates in scope

| Gate | Topic | Evidence memo |
| --- | --- | --- |
| **8** | Mac + USB guided placement rollback | [Rollback memo — Gate 8](./qwon_m3_rollback_release_gate_memo.md#gate-8--rollback-to-mac--usb-guided-placement) |
| **9** | Build `4` / TestFlight release gate | [Rollback memo — Gate 9](./qwon_m3_rollback_release_gate_memo.md#gate-9--build-4--testflight-release-gate-separate) |

### Owners

| Role | Responsibility |
| --- | --- |
| **Product** | Build `4` decision timing; whether download UX ships to TestFlight |
| **Codex** | Spike regression test plan for M2 path; rollback runbook |
| **Release engineering** | Verify `fetch_local_model.sh` + `push_local_model_to_device.sh` after any spike (Gate 8) |

### Required evidence (future sign-off PR)

| Gate | Evidence |
| --- | --- |
| **8** | Documented rollback runbook; spike test plan item “M2 guided placement still reachable”; push script still works |
| **9** | Explicit Product memo: Build `4` **approved** or **deferred** — Gate 9 Ready for **spike-only** may mean “Build `4` still not approved” (clarify at review) |

### Exit criteria (batch D complete)

1. Gate **8** **Ready** — M2 path preservation signed off for any binary containing download UX.
2. Gate **9** disposition recorded — at minimum: **M3 spike does not authorize Build `4`** (may stay **Pending — not approved** even if spike proceeds internally).
3. TestFlight upload / tag / `CFBundleVersion` bump **not** implied.

### Blocked-by

| Gate | Blocked by |
| --- | --- |
| **8** | None for **review** — can review rollback requirements before spike; **Ready** may wait until spike test plan exists |
| **9** | Product release decision; independent of Gates 1–8 spike readiness |

### Batch D disposition

| Field | Value |
| --- | --- |
| **Status** | **Pending** |
| **Ready?** | **No** |

---

## End-to-end exit (M3 spike decision — **not approved**)

All of the following must be true **before** Codex scopes an M3 downloader spike PR:

| # | Criterion |
| --- | --- |
| 1 | Batches **A → B → C → D** reviewed in order (or documented exception with Product ack) |
| 2 | Checklist rows **1–9** each **Ready** with linked sign-off evidence |
| 3 | [Exit criteria in UX plan](./qwon_model_download_gguf_ux_plan.md#exit-criteria-to-open-m3-spike-future) satisfied |
| 4 | **Separate** Product decision if any TestFlight binary ships download UX (Gate 9 / Build `4`) |

**This review plan alone satisfies none of the above.**

---

## Suggested review schedule (Product/Codex — optional)

| Step | Activity | Output |
| --- | --- | --- |
| 1 | Batch **A** review session | Action items for Gates 1–3; legal ticket if needed |
| 2 | Batch **B** review session | Threshold + integrity spec draft for sign-off PR |
| 3 | Batch **C** review session | Final copy list; M2 migration checklist |
| 4 | Batch **D** review session | Rollback runbook + Build `4` stance |
| 5 | **Gate Ready sign-off PR(s)** | Checklist row updates — **still docs-only** |
| 6 | Codex **M3 spike plan** PR | Implementation scope — **only after step 5** |

---

## Explicit non-approvals

| Item | Status |
| --- | --- |
| Mark any gate **Ready** in this PR | **No** |
| M3 Swift / downloader implementation | **Not approved** |
| Build `4` / TestFlight upload / tag / version bump | **Not approved** |
| GGUF / logs / screenshots commit | **Not approved** |

---

## Evidence boundaries (this PR)

| Included | Excluded |
| --- | --- |
| Review batch order A–D | Gate Ready sign-off |
| Owners, evidence, exit criteria per batch | Implementation PR |
| Links from queue + UX plan | Checklist status changes |
