# QWON — App Store G1 Product Answer Worksheet (External Share)

**Last updated:** 2026-06-07 (G1 Product decision draft prepared — intake still **Unanswered**)
**Status:** **Worksheet with Product decision draft / awaiting explicit approval** — intake rows **Q-AS-01 … Q-AS-03** remain **Unanswered** in the [intake ledger](./qwon_app_store_public_readiness_intake.md). **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump not approved.**
**Purpose:** Shareable English worksheet for Product to answer **G1 — Product positioning / value proposition** before answers are recorded in the intake ledger via a separate docs-only PR.

日本語版（記入フォーム）: [G1 Product 回答フォーム（日本語）](./qwon_app_store_g1_product_worksheet_ja.md)

Related: [App Store readiness intake — G1](./qwon_app_store_public_readiness_intake.md#g1--product-positioning--value-proposition) · [Public readiness checklist — G1](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## Boundaries (read first)

| Rule | Detail |
| --- | --- |
| **Stay selected** | Filling this worksheet does **not** lift Stay or authorize implementation |
| **Public release not approved** | Worksheet answers are **input only** until Product records them in the intake ledger |
| **No ASC ops** | No submission, metadata upload, screenshots, or new binaries from this doc |
| **Draft suggestions** | Any “Suggested draft” blocks below are **draft / not approved** — Product must replace or reject |
| **Recording answers** | After Product **explicit approval**, open a **separate docs-only PR** to set intake rows to **Answered** |

---

<a id="product-decision-draft--awaiting-explicit-approval"></a>

## Product decision draft — **awaiting explicit approval**

**Label:** **Product decision draft / awaiting explicit approval** — prepared from recommended worksheet drafts for Product review. **Not** intake **Answered**. **Not** G1 Closed/Ready. **Not** public release approval.

| Field | Value |
| --- | --- |
| **Prepared** | 2026-06-07 — docs-only hygiene under Stay |
| **Intake ledger** | **Q-AS-01 … Q-AS-03** remain **Unanswered** until Product explicit approval + follow-up PR |
| **Next step** | Product confirms, edits, or rejects each draft → docs-only PR records **Answered** in [intake ledger](./qwon_app_store_public_readiness_intake.md) |

### Q-AS-01 — Public positioning statement

| Field | Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-01 |
| **Approved answer (draft)** | QWON is a local-first cognitive runtime for iPhone that keeps inference and context on-device by default — not a cloud-only chat wrapper. |
| **Decision owner** | Product (draft — **awaiting explicit approval**) |
| **Source** | Elaborated from [recommended draft § Q-AS-01](#q-as-01--public-positioning-statement); aligned with [AGENTS.md](../../AGENTS.md) product thesis |
| **Constraints** | **Not** approved App Store listing copy; **not** intake **Answered** until follow-up PR |

### Q-AS-02 — Primary audience

| Field | Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-02 |
| **Approved answer (draft)** | **Primary:** privacy-conscious iPhone users and early adopters who want on-device AI assistance without default cloud dependency. **Secondary:** developers and power users evaluating local LLM workflows. |
| **Decision owner** | Product (draft — **awaiting explicit approval**) |
| **Source** | Elaborated from [recommended draft § Q-AS-02](#q-as-02--primary-audience) |
| **Constraints** | Audience may narrow before metadata (Q-AS-04) work |

### Q-AS-03 — Pricing model

| Field | Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-03 |
| **Pricing model (draft)** | **TBD** for first public release planning |
| **Rationale (draft)** | Text-alpha validated core runtime; monetization requires separate Product decision on support cost, model distribution, and App Store category expectations. |
| **Decision owner** | Product (draft — **awaiting explicit approval**) |
| **Source** | Elaborated from [recommended draft § Q-AS-03](#q-as-03--pricing-model) |
| **Constraints** | Pricing **not decided**; do **not** imply paid/subscription approval |

---

## Current baseline (context for Product)

| Field | Value |
| --- | --- |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha |
| **Product thesis (engineering docs)** | Local-first cognitive runtime — **not** positioned as a generic chat clone · [AGENTS.md](../../AGENTS.md) |
| **Tester-visible model path** | M2 **Place GGUF via Mac** + USB — unchanged on build `3` |
| **M3 downloader** | Option A — compile-gated **default-off**; lane **closed** |

---

## Answer format (copy for each question)

```text
Question ID:
Approved answer:
Decision owner:
Source (meeting / email / memo / PR):
Constraints or deferrals:
Blocks cleared (if any):
```

---

## Q-AS-01 — Public positioning statement

| Field | Value |
| --- | --- |
| **Gate** | G1 |
| **Owner** | Product |
| **Intake status** | **Unanswered** (unchanged until follow-up PR) |

### Question

What is the approved **public positioning statement** (one sentence) for QWON on the App Store — **local-first cognitive runtime** vs **generic chat assistant**?

### Product answer (fill in)

**See [Product decision draft](#product-decision-draft--awaiting-explicit-approval)** — **Product decision draft / awaiting explicit approval**; intake row remains **Unanswered**.

| Field | Your answer |
| --- | --- |
| **Approved answer** | QWON is a local-first cognitive runtime for iPhone that keeps inference and context on-device by default — not a cloud-only chat wrapper. *(draft — awaiting explicit approval)* |
| **Decision owner** | Product (draft) |
| **Source** | [Product decision draft § Q-AS-01](#product-decision-draft--awaiting-explicit-approval) |
| **Constraints** | Not approved App Store copy; not intake **Answered** |

### Suggested draft — **draft / not approved**

> QWON is a local-first cognitive runtime for iPhone that keeps inference and context on-device by default — not a cloud-only chat wrapper.

Product must edit, replace, or reject this draft. **Do not** treat as approved App Store copy.

### Unblocks

Q-AS-02, Q-AS-04 (metadata copy), G1 sign-off (separate from this worksheet)

---

## Q-AS-02 — Primary audience

| Field | Value |
| --- | --- |
| **Gate** | G1 |
| **Owner** | Product |
| **Intake status** | **Unanswered** |

### Question

Who is the **primary audience** for the first public App Store release (e.g. power users, privacy-conscious users, developers, general consumer)?

### Product answer (fill in)

**See [Product decision draft](#product-decision-draft--awaiting-explicit-approval)** — **Product decision draft / awaiting explicit approval**; intake row remains **Unanswered**.

| Field | Your answer |
| --- | --- |
| **Approved answer** | **Primary:** privacy-conscious iPhone users and early adopters who want on-device AI assistance without default cloud dependency. **Secondary:** developers and power users evaluating local LLM workflows. *(draft — awaiting explicit approval)* |
| **Decision owner** | Product (draft) |
| **Source** | [Product decision draft § Q-AS-02](#product-decision-draft--awaiting-explicit-approval) |
| **Constraints** | Not intake **Answered** |

### Suggested draft — **draft / not approved**

> Primary audience: **privacy-conscious iPhone users and early adopters** who want on-device AI assistance without default cloud dependency. Secondary: developers and power users evaluating local LLM workflows.

### Unblocks

Q-AS-04, Q-AS-05 (screenshots narrative), G1 sign-off

---

## Q-AS-03 — Pricing model

| Field | Value |
| --- | --- |
| **Gate** | G1 |
| **Owner** | Product |
| **Intake status** | **Unanswered** |

### Question

What **pricing model** (free, paid, subscription, or TBD) applies to the first public release, and what is the **decision rationale**?

### Product answer (fill in)

**See [Product decision draft](#product-decision-draft--awaiting-explicit-approval)** — **Product decision draft / awaiting explicit approval**; intake row remains **Unanswered**.

| Field | Your answer |
| --- | --- |
| **Pricing model** | TBD *(draft — awaiting explicit approval)* |
| **Rationale** | Text-alpha validated core runtime; monetization requires separate Product decision on support cost, model distribution, and App Store category expectations. |
| **Decision owner** | Product (draft) |
| **Source** | [Product decision draft § Q-AS-03](#product-decision-draft--awaiting-explicit-approval) |
| **Constraints** | Pricing not decided; not intake **Answered** |

### Suggested draft — **draft / not approved**

> **Pricing model:** TBD for first public release planning.
> **Rationale (working hypothesis):** Text-alpha validated core runtime; monetization requires separate Product decision on support cost, model distribution, and App Store category expectations. **Not approved.**

### Unblocks

Q-AS-04 (store listing economics copy), G1 sign-off

---

## G1 completion checklist (worksheet — not gate sign-off)

| Item | Status |
| --- | --- |
| Q-AS-01 Product decision draft prepared | **Done** — [awaiting explicit approval](#product-decision-draft--awaiting-explicit-approval) |
| Q-AS-02 Product decision draft prepared | **Done** — awaiting explicit approval |
| Q-AS-03 Product decision draft prepared | **Done** — awaiting explicit approval |
| Product **explicit approval** of G1 drafts | **Pending** |
| Follow-up docs-only PR updates intake ledger to **Answered** | **Pending** |
| Checklist gate G1 marked Closed/Ready | **No** — requires explicit Product gate sign-off |

**Public release approved?** **No**

---

## Agent note

Share this worksheet with Product for **explicit approval**. **Do not** copy Product decision drafts into the intake ledger as **Answered** until Product confirms and a follow-up docs-only PR records them. Stay-allowed hygiene only.
