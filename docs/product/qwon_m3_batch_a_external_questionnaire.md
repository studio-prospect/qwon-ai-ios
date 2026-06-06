# QWON — M3 Batch A External Questionnaire

**Last updated:** 2026-06-05
**Status:** **Questionnaire only** — **no answers recorded**, **no gate Ready sign-off**, **not** M3 implementation approval, **not** Build `4` approval.
**Purpose:** Provide a compact shareable question set for Product / Legal / Codex review of M3 Batch A: Gates **1–3** (hosting, checksum, compliance).

Japanese version: [M3 Batch A 外部共有用質問票](./qwon_m3_batch_a_external_questionnaire_ja.md)

Related: [Gate answer intake ledger](./qwon_m3_gate_answer_intake.md) · [Batch A review session](./qwon_m3_gate_readiness_review_plan.md#batch-a-review-session-2026-06-05) · [Hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md) · [Compliance memo](./qwon_m3_model_distribution_compliance_memo.md)

---

## Instructions for respondents

Please answer only the questions you own. Written answers are required before any gate can move from **Pending** to **Ready**.

| Rule | Detail |
| --- | --- |
| **Use Question IDs** | Keep the `Q-A-##` ID in each response so the answer can be recorded in the intake ledger. |
| **Cite source** | Link the source of truth: memo, meeting notes, email thread, legal note, PR, or decision record. |
| **Do not infer** | Silence or partial agreement is not approval. Unanswered rows remain `Unanswered`. |
| **No implementation approval** | Answers here do **not** authorize M3 spike, Swift work, Build `4`, TestFlight upload, tag, or GGUF artifact changes. |
| **No Ready sign-off** | Even when a row is answered, gates stay **Pending** until a separate Ready sign-off PR. |

### Response format

```text
Question ID:
Answer:
Decision owner:
Source / link:
Constraints:
Follow-up needed:
```

---

## Executive summary

Batch A decides whether QWON may safely proceed toward an in-app model download spike. It does **not** decide implementation details beyond the minimum policy inputs needed by later gates.

| Gate | Topic | Current state | Required outcome |
| --- | --- | --- | --- |
| **1** | Hosting / URL ownership | **Pending** | Product selects owner, hosting model, and artifact identity. |
| **2** | SHA-256 / byte size | **Pending** | Product/Codex publish exact byte size and SHA-256 policy for the Gate 1 artifact. |
| **3** | License / redistribution / export | **Pending** | Legal/Product confirms whether in-app model download and distribution path are acceptable. |

---

## Gate 1 — Hosting and artifact questions

Owner: **Product**

| ID | Question | Answer needed |
| --- | --- | --- |
| **Q-A-01** | Who is the named owner for model hosting? | Team or role accountable for URL availability, object updates, rollback, and incident response. |
| **Q-A-02** | Which hosting model is approved? | Choose one: QWON-owned CDN/object storage, pinned Hugging Face URL, QWON-built artifact hosting, or defer M3 download. |
| **Q-A-03** | What exact artifact will M3 ship? | State whether QWON uses the bartowski `Q4_K_M` GGUF as-is, a QWON-hosted mirror, or a QWON-built/repackaged blob. |
| **Q-A-04** | How will the artifact be pinned for reproducibility? | Provide immutable revision, object key, etag/version ID, or equivalent artifact identity. |
| **Q-A-05** | Is a third-party Hugging Face URL acceptable for any tester-facing build? | Product yes/no plus Legal dependency if the answer is yes. |

### Gate 1 answer checklist

| Required before Gate 1 Ready | Status |
| --- | --- |
| Hosting owner named | Pending |
| Hosting model selected | Pending |
| Product URL or artifact object identity documented | Pending |
| Artifact pinning policy documented | Pending |
| Third-party URL stance recorded | Pending |

---

## Gate 2 — Checksum and byte-size questions

Owner: **Product + Codex**

Gate 2 cannot be finalized until Gate 1 identifies the exact artifact. Do not publish an ops-only hash as final unless Product/Codex explicitly approves that artifact as the Gate 1 source.

| ID | Question | Answer needed |
| --- | --- | --- |
| **Q-A-06** | What is the exact expected byte size for the Gate 1 artifact? | A single integer byte count, not an approximate MB value or range. |
| **Q-A-07** | What is the SHA-256 of the Gate 1 artifact? | A final checksum tied to the approved artifact identity. |
| **Q-A-08** | How should existing USB-placed GGUF files without matching hash be treated? | Continue as `present-unverified`, require re-acquisition, or define another migration policy. |

### Gate 2 answer checklist

| Required before Gate 2 Ready | Status |
| --- | --- |
| Exact artifact from Gate 1 selected | Pending |
| Exact byte size published | Pending |
| SHA-256 published | Pending |
| Verification failure policy agreed | Pending |
| Legacy USB file policy agreed | Pending |

---

## Gate 3 — Legal / compliance questions

Owner: **Legal via Product**

These answers must come from Product/legal sources. Engineering should not infer license, redistribution, export, or App Store posture from public model metadata alone.

| ID | Question | Answer needed |
| --- | --- | --- |
| **Q-A-09** | Does the Qwen base model license permit QWON to facilitate model download to user devices via the app? | Legal yes/no with any required conditions. |
| **Q-A-10** | May QWON redistribute the bartowski GGUF quant to end users? | Legal/Product yes/no for direct hosting, mirroring, or third-party URL use. |
| **Q-A-11** | What attribution or NOTICE text is required? | Required in-app, docs, Settings, or legal notice copy. |
| **Q-A-12** | Does in-app model download change export compliance or App Store privacy label answers? | Required ASC/export/privacy actions before any TestFlight build with download UX. |
| **Q-A-13** | If Gate 1 selects a Hugging Face URL, are there Hugging Face ToS constraints for production app fetch? | Legal yes/no and constraints for third-party URL fetch. |

### Recommended draft for Legal review (not an answer)

The following is a Product/Codex draft to send to Legal. **This table is not an answer record.** Update rows in the [answer intake ledger](./qwon_m3_gate_answer_intake.md) to `Answered` only after Legal explicitly approves or revises the relevant response.

| ID | Recommended draft |
| --- | --- |
| **Q-A-09** | **Yes, pending Legal confirmation.** Qwen2.5-0.5B-Instruct is published as Apache-2.0 on Hugging Face, so QWON may proceed on the assumption that app-facilitated download is acceptable if Apache-2.0 obligations are preserved. Legal must confirm before Gate 3 Ready. |
| **Q-A-10** | **Conditionally yes, pending Legal confirmation.** QWON should mirror or self-host the bartowski `Q4_K_M` GGUF only after confirming that the GGUF repo inherits the Qwen Apache-2.0 license path and redistribution/mirroring is acceptable. Product-facing builds should not rely on Hugging Face direct download URLs by default. |
| **Q-A-11** | QWON should include in-app / docs attribution identifying Qwen2.5-0.5B-Instruct by Qwen, bartowski Qwen2.5-0.5B-Instruct-GGUF as the quantization source, Apache License 2.0, and upstream model card / license links. Preserve any upstream NOTICE or additional attribution terms. Legal should confirm exact copy. |
| **Q-A-12** | Product / Legal / App Store Connect re-check is required before any TestFlight or product-facing build with in-app model download. App HTTPS/TLS answers and model weight distribution should be treated as separate compliance surfaces; do not assume existing export/privacy answers remain sufficient. |
| **Q-A-13** | Hugging Face URLs may remain in docs for traceability / source reference unless Legal identifies a ToS issue. However, Hugging Face URLs should not be the product-facing download endpoint unless Legal explicitly approves that use. QWON-owned hosting remains the recommended product path. |

### Gate 3 answer checklist

| Required before Gate 3 Ready | Status |
| --- | --- |
| Qwen base license reviewed for app-facilitated download | Pending |
| bartowski GGUF redistribution/mirroring reviewed | Pending |
| attribution / NOTICE requirement recorded | Pending |
| export compliance and privacy label impact recorded | Pending |
| Hugging Face ToS stance recorded if relevant | Pending |

---

## Copy-paste request

Use this block when asking stakeholders for answers.

```text
We need written answers for QWON M3 Batch A before any in-app model download spike can be scoped.

Please answer the Question IDs you own in docs/product/qwon_m3_batch_a_external_questionnaire.md.

Scope:
- Gate 1: hosting / URL ownership
- Gate 2: checksum / byte size
- Gate 3: license / redistribution / export compliance

Important:
- This is not M3 implementation approval.
- This is not Build 4 approval.
- Answers do not mark gates Ready by themselves.
- We will record only real answers in docs/product/qwon_m3_gate_answer_intake.md, then open a separate Ready sign-off PR if the batch is complete.

Preferred response format:
Question ID:
Answer:
Decision owner:
Source / link:
Constraints:
Follow-up needed:
```

---

## After answers arrive

| Step | Action |
| --- | --- |
| 1 | Update only the answered `Q-A-##` rows in [answer intake ledger](./qwon_m3_gate_answer_intake.md). |
| 2 | Keep unanswered rows unchanged. |
| 3 | Link answer sources and follow-up PRs. |
| 4 | Keep Gates 1–3 **Pending** until a separate Batch A Ready sign-off PR. |
| 5 | Do not start M3 spike or Build `4` work from questionnaire answers alone. |
