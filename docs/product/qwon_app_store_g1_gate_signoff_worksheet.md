# QWON — App Store G1 Gate Sign-Off Worksheet

**Last updated:** 2026-06-08 (Stay selected — G1 sign-off **Approved**; checklist gate **Closed/Ready**)
**Status:** **Sign-off recorded** — checklist gate **G1** **Closed/Ready** (This PR). **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump not approved.**
**Purpose:** Product decision surface to record whether checklist gate **G1 — Product positioning / value proposition** may move from **Open** to **Closed/Ready** after intake **Q-AS-01 … Q-AS-03** are **Answered**.

Related: [Public readiness checklist — G1](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [Intake ledger — G1](./qwon_app_store_public_readiness_intake.md#g1--product-positioning--value-proposition) · [G1 Product worksheet](./qwon_app_store_g1_product_worksheet.md) · [Next work queue — App Store readiness](./qwon_next_work_queue.md#app-store-public-release) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## Explicit boundaries (read first)

| Boundary | Meaning |
| --- | --- |
| **G1 sign-off ≠ public release approval** | Closing gate **G1** does **not** approve App Store public listing or go-live |
| **G1 sign-off ≠ Build `4` approval** | No TestFlight upload, tag, or **`CFBundleVersion` bump** |
| **G1 sign-off ≠ App Store submission** | No ASC metadata upload, screenshots, or submission ops from this worksheet |
| **Stay selected** | Sign-off worksheet maintenance does **not** lift Stay or authorize implementation |
| **Intake complete ≠ gate Ready** | All G1 intake rows **Answered** is **necessary** but **not sufficient** — Product must record sign-off below |

---

## Current evidence

| Field | Value |
| --- | --- |
| **Checklist gate** | **G1 — Product positioning / value proposition** — **Closed/Ready** (This PR) |
| **Intake questions** | **Q-AS-01 … Q-AS-03** — **Answered** ([#129](https://github.com/studio-prospect/qwon-ai-ios/pull/129)) |
| **Intake ledger total** | **24 questions · 21 Unanswered · 3 Answered** |
| **Answer detail** | [G1 Product answer details](./qwon_app_store_public_readiness_intake.md#g1-product-answer-details-2026-06-07) |
| **Source worksheets** | [G1 Product worksheet](./qwon_app_store_g1_product_worksheet.md) · [日本語フォーム](./qwon_app_store_g1_product_worksheet_ja.md) |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |

### Recorded intake answers (summary)

| Question ID | Topic | Status |
| --- | --- | --- |
| **Q-AS-01** | Public positioning statement | **Answered** |
| **Q-AS-02** | Primary audience | **Answered** |
| **Q-AS-03** | Pricing model + rationale | **Answered** |

---

## Remaining gate question

**May checklist gate G1 — Product positioning / value proposition — be marked Closed/Ready?**

Product should confirm:

1. **Q-AS-01 … Q-AS-03** answers in the [intake ledger](./qwon_app_store_public_readiness_intake.md#g1--product-positioning--value-proposition) are **final enough** for public-readiness planning (not necessarily final App Store listing copy).
2. **Q-AS-04** (metadata) may proceed using G1 positioning/audience/pricing inputs without reopening G1.
3. No **Needs revision** blockers remain on positioning, audience, or pricing-model direction.

If **Needs revision**, record what must change and **do not** mark gate **G1** Closed/Ready until intake rows are updated via a separate docs-only PR.

---

## Sign-off record (Product)

| Field | Record |
| --- | --- |
| **Decision** | **Approved** |
| **Owner** | Product |
| **Date** | 2026-06-08 |
| **Source** | This PR |
| **Notes** | G1 positioning / audience / pricing direction is sufficient for public-readiness planning; this does **not** approve public release or Build `4`. |

### Decision guide

| Decision | Checklist gate G1 | Next docs-only step |
| --- | --- | --- |
| **Approved** | May mark **Closed/Ready** in follow-up PR | [G2 worksheet preparation](./qwon_app_store_public_readiness_intake.md#g2--app-store-metadata--screenshots--localization) (Q-AS-04 … Q-AS-06) |
| **Not approved** | Stays **Open** | Product revises G1 direction; may require intake row updates |
| **Needs revision** | Stays **Open** | Amend intake answers via separate docs-only PR; re-run this worksheet |

---

## Sign-off checklist

| Item | Status |
| --- | --- |
| Q-AS-01 … Q-AS-03 **Answered** in intake | **Done** ([#129](https://github.com/studio-prospect/qwon-ai-ios/pull/129)) |
| Product **Decision** recorded above | **Done** — **Approved** (2026-06-08) |
| Follow-up docs-only PR updates checklist **G1** to Closed/Ready | **Done** — This PR |
| Public release approved | **No** |
| Build `4` / TestFlight upload approved | **No** |

---

## Agent note

Gate **G1** sign-off **Approved** — next docs-only step: **G2 worksheet preparation** ([intake G2](./qwon_app_store_public_readiness_intake.md#g2--app-store-metadata--screenshots--localization)). **Do not** create G2 answers unless scoped in a separate task.
