# QWON — M3 Gate Answer Intake Ledger

**Last updated:** 2026-06-05
**Status:** **Intake ledger only** — Batch A Product answers **Q-A-01…Q-A-05 recorded**, **no gate Ready sign-off**, **not** M3 implementation approval, **not** Build `4` approval.
**Purpose:** Track **Product / Codex / Legal / Release Engineering** answers to [Batch A–D review questions](./qwon_m3_gate_readiness_review_plan.md) and record what each answer **unblocks** toward a future **gate Ready sign-off PR**.

Related: [Gate readiness review plan](./qwon_m3_gate_readiness_review_plan.md) · [Batch A external questionnaire](./qwon_m3_batch_a_external_questionnaire.md) · [M3 checklist](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) · [Queue — M3 status](./qwon_next_work_queue.md#m3-readiness-status-2026-06-05)

---

## How to use this ledger

| Rule | Detail |
| --- | --- |
| **Who answers** | Product, Codex, Legal (via Product), Release Engineering — **not** implementation agents |
| **How to record an answer** | **Separate docs-only PR** after stakeholder provides written response; link PR in **Answer source** and **Follow-up PR** |
| **Do not** | Infer, draft, or commit final hosting URL, SHA-256, legal conclusions, UI copy, or release decisions in this ledger without stakeholder source |
| **Answer recorded ≠ Ready** | Updating a row to **Answered** does **not** mark a checklist gate **Ready** — that requires a dedicated **sign-off PR** |
| **Agents** | May append **real** answers only when Product/legal/release explicitly supplies them; otherwise leave **Unanswered** |

### Gate checklist disposition (unchanged)

| Gates 1–9 | **All Pending** — this ledger does **not** change checklist rows |

---

## Column definitions

| Column | Meaning |
| --- | --- |
| **Question ID** | Stable ID — maps to [review plan](./qwon_m3_gate_readiness_review_plan.md) question lists |
| **Gate** | M3 checklist gate(s) affected |
| **Owner** | Who must answer |
| **Answer status** | `Unanswered` until a real stakeholder response is linked |
| **Answer source** | Memo, email, meeting notes, PR — **empty until answered** |
| **Blocks** | Other questions or gates waiting on this answer |
| **Ready impact** | Which gate **Ready sign-off** needs this answer (sign-off still separate) |
| **Follow-up PR** | PR that recorded the answer and/or gate Ready sign-off — **empty until exists** |

---

## Batch A — Gates 1–3 (hosting / checksum / compliance)

| Question ID | Gate | Owner | Answer status | Answer source | Blocks | Ready impact | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-A-01 | 1 | Product | Answered | [Product answer details](#batch-a-product-answer-details-2026-06-05) | Q-A-02, Q-A-03, Q-A-04; G2-1 | Gate **1** Ready sign-off | This PR |
| Q-A-02 | 1 | Product | Answered | [Product answer details](#batch-a-product-answer-details-2026-06-05) | Q-A-03, Q-A-04, Q-A-05; G1-3 | Gate **1** Ready sign-off | This PR |
| Q-A-03 | 1 | Product | Answered | [Product answer details](#batch-a-product-answer-details-2026-06-05) | Q-A-04, Q-A-06, Q-A-07; G2-1 | Gate **1** + **2** Ready sign-off | This PR |
| Q-A-04 | 1 | Product | Answered | [Product answer details](#batch-a-product-answer-details-2026-06-05) | Q-A-06, Q-A-07; G2-1 | Gate **1** + **2** Ready sign-off | This PR |
| Q-A-05 | 1, 3 | Product, Legal | Answered | [Product answer details](#batch-a-product-answer-details-2026-06-05) | G1-7; Q-A-13 | Gate **1** Ready sign-off | This PR |
| Q-A-06 | 2 | Product, Codex | Unanswered | — | Q-B-01; G4-1, G5-4; Batch B threshold | Gate **2** Ready sign-off | — |
| Q-A-07 | 2 | Product, Codex | Unanswered | — | G5-4; verify-before-promote | Gate **2** Ready sign-off | — |
| Q-A-08 | 2 | Product, Codex | Unanswered | — | G5-12; Q-B-11; legacy USB files | Gate **2** Ready sign-off | — |
| Q-A-09 | 3 | Legal | Unanswered | — | Q-A-10, G1-7 | Gate **3** Ready sign-off | — |
| Q-A-10 | 3 | Legal | Unanswered | — | G1 hosting model; G3-2 | Gate **3** Ready sign-off | — |
| Q-A-11 | 3 | Legal | Unanswered | — | G3-3, G3-4 | Gate **3** Ready sign-off | — |
| Q-A-12 | 3 | Legal, Product | Unanswered | — | Q-C-06; G6-7, G6-8; Q-D-10 | Gate **3** Ready sign-off | — |
| Q-A-13 | 3 | Legal | Unanswered | — | Q-A-05; G1-7 HF pin | Gate **3** Ready sign-off | — |

**Question text:** [Batch A — external questionnaire](./qwon_m3_batch_a_external_questionnaire.md) · [日本語版](./qwon_m3_batch_a_external_questionnaire_ja.md) · [Product / legal question list](./qwon_m3_gate_readiness_review_plan.md#product--legal-question-list-batch-a--answer-to-unblock-ready-sign-off)

### Batch A product answer details (2026-06-05)

**Source:** Product decision in Codex conversation, 2026-06-05.
**Scope:** Product-owned Gate **1** answers only. This records hosting direction and artifact policy for Q-A-01…Q-A-05. It does **not** mark Gates **1–3** Ready, does **not** approve M3 spike, and does **not** approve Build `4`.

| Question ID | Answer |
| --- | --- |
| **Q-A-01** | **Product** is the decision owner for whether QWON may distribute the model artifact. **Release Engineering** is the operational owner for model hosting, including object storage/CDN management, artifact upload/versioning, rollback, and incident response. |
| **Q-A-02** | Approved hosting model: **QWON-owned CDN/object storage**. Third-party URLs may be retained for traceability or dev ops, but the product-facing distribution path should be QWON-owned. |
| **Q-A-03** | Approved artifact direction: **QWON-hosted mirror of the bartowski Qwen2.5-0.5B-Instruct `Q4_K_M` GGUF**, served as the approved M3 artifact. |
| **Q-A-04** | Reproducibility pinning direction: **QWON object key/version ID + SHA-256 + exact byte size**, to be recorded in a later Gate **2** sign-off PR after the hosted object is finalized. |
| **Q-A-05** | Product stance: **No third-party Hugging Face URL for product/tester-facing builds unless Legal explicitly approves HF URL use**. Hugging Face may remain a traceability/source reference, not the default product URL. |

**Remaining dependencies:** Q-A-06…Q-A-08 still need Gate **2** byte-size/checksum decisions. Q-A-09…Q-A-13 still need Legal/Product compliance answers. Gates **1–3** remain **Pending** until a separate Batch A Ready sign-off PR.

---

## Batch B — Gates 4–5 (storage / integrity)

| Question ID | Gate | Owner | Answer status | Answer source | Blocks | Ready impact | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-B-01 | 4 | Product, Codex | Unanswered | — | **Batch A blocked** (Q-A-06) | Gate **4** Ready sign-off | — |
| Q-B-02 | 4, 5 | Product, Codex | Unanswered | — | Q-B-01; G4-3 | Gate **4** Ready sign-off | — |
| Q-B-03 | 4 | Product | Unanswered | — | Q-B-01 | Gate **4** Ready sign-off | — |
| Q-B-04 | 4 | Product | Unanswered | — | — | Gate **4** Ready sign-off | — |
| Q-B-05 | 4, 7 | Product | Unanswered | — | Q-C-09 | Gate **4** + **7** Ready sign-off | — |
| Q-B-06 | 4, 5 | Product, Codex | Unanswered | — | Q-B-08 | Gate **4** + **5** Ready sign-off | — |
| Q-B-07 | 5 | Codex, Product | Unanswered | — | G5-1; G8-6 indirect | Gate **5** Ready sign-off | — |
| Q-B-08 | 5 | Product, Codex | Unanswered | — | Q-B-06; G5-5 | Gate **5** Ready sign-off | — |
| Q-B-09 | 5 | Codex | Unanswered | — | G5-6, G5-7; Q-C-12 | Gate **5** Ready sign-off | — |
| Q-B-10 | 5, 6, 7 | Product, Codex | Unanswered | — | Q-C-12; G7-6–G7-8 | Gate **5** + **7** Ready sign-off | — |
| Q-B-11 | 5 | Product, Codex | Unanswered | — | **Batch A blocked** (Q-A-08) | Gate **5** Ready sign-off | — |

**Question text:** [Batch B — Product / Codex question list](./qwon_m3_gate_readiness_review_plan.md#product--codex-question-list-batch-b--answer-to-unblock-ready-sign-off)

---

## Batch C — Gates 6–7 (network disclosure / device expectation)

| Question ID | Gate | Owner | Answer status | Answer source | Blocks | Ready impact | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-C-01 | 6 | Product | Unanswered | — | G6-1, G6-2 | Gate **6** Ready sign-off | — |
| Q-C-02 | 6 | Product | Unanswered | — | G6-3 | Gate **6** Ready sign-off | — |
| Q-C-03 | 6 | Product | Unanswered | — | G6-4 | Gate **6** Ready sign-off | — |
| Q-C-04 | 6 | Product | Unanswered | — | G6-5; M2 migration | Gate **6** Ready sign-off | — |
| Q-C-05 | 6 | Product | Unanswered | — | G6-6 | Gate **6** Ready sign-off | — |
| Q-C-06 | 6, 3 | Legal, Product | Unanswered | — | **Gate 3 blocked** (Q-A-12) | Gate **6** Ready sign-off | — |
| Q-C-07 | 6, 9 | Product | Unanswered | — | G6-9; tester comms | Gate **6** Ready sign-off | — |
| Q-C-08 | 6 | Product | Unanswered | — | G6-11 | Gate **6** Ready sign-off | — |
| Q-C-09 | 7 | Product | Unanswered | — | G7-3; Q-B-05 | Gate **7** Ready sign-off | — |
| Q-C-10 | 7 | Product | Unanswered | — | G7-2, G7-4 | Gate **7** Ready sign-off | — |
| Q-C-11 | 7 | Product, Codex | Unanswered | — | G7-5 | Gate **7** Ready sign-off | — |
| Q-C-12 | 7, 5 | Codex, Product | Unanswered | — | **Gate 5 blocked** (Q-B-10) | Gate **7** Ready sign-off | — |
| Q-C-13 | 7 | Product | Unanswered | — | G7-9 | Gate **7** Ready sign-off | — |
| Q-C-14 | 7, 8 | Product | Unanswered | — | G7-11; Q-D-04 | Gate **7** + **8** Ready sign-off | — |

**Question text:** [Batch C — Product / Codex question list](./qwon_m3_gate_readiness_review_plan.md#product--codex-question-list-batch-c--answer-to-unblock-ready-sign-off)

---

## Batch D — Gates 8–9 (rollback / release)

| Question ID | Gate | Owner | Answer status | Answer source | Blocks | Ready impact | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-D-01 | 8 | Codex | Unanswered | — | G8-6; **spike test plan blocked** | Gate **8** Ready sign-off | — |
| Q-D-02 | 8 | Release Engineering | Unanswered | — | G8-2, G8-3 | Gate **8** Ready sign-off | — |
| Q-D-03 | 8 | Codex, RE | Unanswered | — | G8-4, G8-5 | Gate **8** Ready sign-off | — |
| Q-D-04 | 8, 7 | Product, Codex | Unanswered | — | G8-7; Q-C-14 | Gate **8** Ready sign-off | — |
| Q-D-05 | 8, 5, 7 | Product | Unanswered | — | G8-9; Q-B-09 | Gate **8** Ready sign-off | — |
| Q-D-06 | 9 | Product | Unanswered | — | G9-1; M3 spike vs TestFlight | Gate **9** disposition (not Build `4` approval by default) | — |
| Q-D-07 | 9 | Product | Unanswered | — | G9-2, G9-5; **Product release decision blocked** | Gate **9** / Build `4` gate | — |
| Q-D-08 | 9 | Product | Unanswered | — | G9-3, G9-4 | Gate **9** / Build `4` gate | — |
| Q-D-09 | 9 | Product | Unanswered | — | G9-7 | Gate **9** Ready sign-off | — |
| Q-D-10 | 9, 3 | Ops, Legal | Unanswered | — | G9-6; **Gate 3 blocked** (Q-A-12) | Gate **9** Ready sign-off | — |
| Q-D-11 | 9 | Product | Unanswered | — | G9-8; sign-off PR format | Gate **9** Ready sign-off | — |

**Question text:** [Batch D — stakeholder question list](./qwon_m3_gate_readiness_review_plan.md#product--codex--release-engineering-question-list-batch-d)

---

## Summary (current)

| Batch | Questions | Answered | Gates |
| --- | --- | --- | --- |
| **A** | 13 | **5** | 1–3 — **Pending** |
| **B** | 11 | **0** | 4–5 — **Pending** |
| **C** | 14 | **0** | 6–7 — **Pending** |
| **D** | 11 | **0** | 8–9 — **Pending** |
| **Total** | **49** | **5** | **All Pending** |

---

## Path to Ready sign-off (after answers exist)

| Step | Action | Owner |
| --- | --- | --- |
| 1 | Stakeholder provides **written** answer | Product / Legal / Codex / RE |
| 2 | **Answer intake PR** — update row(s) in this ledger only | Docs agent |
| 3 | When **all** questions for a batch are **Answered**, open **batch Ready sign-off PR** | Product + Codex |
| 4 | Sign-off PR updates checklist row(s) to **Ready** with linked evidence | Product + Codex |
| 5 | When **all nine** gates **Ready**, Codex may scope **M3 spike plan** | Codex |

**M3 spike** and **Build `4`** remain **not approved** until step 5 and separate Gate **9** / Product release decisions respectively.

---

## Evidence boundaries (this PR)

| Included | Excluded |
| --- | --- |
| Question ID ledger (49 rows) | Fabricated answers |
| Batch A Product answers Q-A-01…Q-A-05 | Gate Ready sign-off |
| Workflow for future answer PRs | Gate Ready sign-off |
| Ready impact mapping | Final URL / SHA / legal / UI / release values |
| All gates **Pending** | Swift, spike, TestFlight upload |
