# QWON — App Store G1 Product Answer Worksheet (External Share)

**Last updated:** 2026-06-07
**Status:** **Worksheet only** — intake rows **Q-AS-01 … Q-AS-03** remain **Unanswered** in the [intake ledger](./qwon_app_store_public_readiness_intake.md). **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump not approved.**
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
| **Recording answers** | After Product approves written answers, open a **separate docs-only PR** to update [intake ledger](./qwon_app_store_public_readiness_intake.md) rows |

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

| Field | Your answer |
| --- | --- |
| **Approved answer** | |
| **Decision owner** | |
| **Source** | |
| **Constraints** | |

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

| Field | Your answer |
| --- | --- |
| **Approved answer** | |
| **Decision owner** | |
| **Source** | |
| **Constraints** | |

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

| Field | Your answer |
| --- | --- |
| **Pricing model** | (free / paid / subscription / TBD) |
| **Rationale** | |
| **Decision owner** | |
| **Source** | |
| **Constraints** | |

### Suggested draft — **draft / not approved**

> **Pricing model:** TBD for first public release planning.  
> **Rationale (working hypothesis):** Text-alpha validated core runtime; monetization requires separate Product decision on support cost, model distribution, and App Store category expectations. **Not approved.**

### Unblocks

Q-AS-04 (store listing economics copy), G1 sign-off

---

## G1 completion checklist (worksheet — not gate sign-off)

| Item | Status |
| --- | --- |
| Q-AS-01 approved answer written by Product | Pending |
| Q-AS-02 approved answer written by Product | Pending |
| Q-AS-03 approved answer written by Product | Pending |
| Follow-up docs-only PR updates intake ledger | Pending |
| Checklist gate G1 marked Closed/Ready | **No** — requires explicit Product gate sign-off |

**Public release approved?** **No**

---

## Agent note

Share this worksheet with Product externally. **Do not** copy suggested drafts into the intake ledger as **Answered**. Stay-allowed hygiene only.
