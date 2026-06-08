# QWON — App Store G2 Gate Sign-Off Worksheet

**Last updated:** 2026-06-08 (Stay selected — G2 gate sign-off worksheet added; checklist gate **G2 Open**)
**Status:** **Sign-off pending** — intake **Q-AS-04 … Q-AS-06 Answered** ([#134](https://github.com/studio-prospect/qwon-ai-ios/pull/134)); checklist gate **G2** remains **Open**. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump not approved.**
**Purpose:** Product decision surface to record whether checklist gate **G2 — App Store metadata / screenshots / localization** may move from **Open** to **Closed/Ready** after intake **Q-AS-04 … Q-AS-06** are **Answered**.

Related: [Public readiness checklist — G2](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [Intake ledger — G2](./qwon_app_store_public_readiness_intake.md#g2--app-store-metadata--screenshots--localization) · [G2 metadata worksheet](./qwon_app_store_g2_metadata_worksheet.md) · [G2 メタデータフォーム（日本語）](./qwon_app_store_g2_metadata_worksheet_ja.md) · [G1 gate sign-off](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) · [Next work queue — App Store readiness](./qwon_next_work_queue.md#app-store-public-release) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## Explicit boundaries (read first)

| Boundary | Meaning |
| --- | --- |
| **G2 sign-off ≠ public release approval** | Closing gate **G2** does **not** approve App Store public listing or go-live |
| **G2 sign-off ≠ Build `4` approval** | No TestFlight upload, tag, or **`CFBundleVersion` bump** |
| **G2 sign-off ≠ App Store metadata upload** | No ASC metadata upload, screenshot upload, or submission ops from this worksheet |
| **Stay selected** | Sign-off worksheet maintenance does **not** lift Stay or authorize implementation |
| **Intake complete ≠ gate Ready** | All G2 intake rows **Answered** is **necessary** but **not sufficient** — Product must record sign-off below |

---

## Current evidence

| Field | Value |
| --- | --- |
| **Checklist gate** | **G2 — App Store metadata and screenshots** — **Open** |
| **Intake questions** | **Q-AS-04 … Q-AS-06** — **Answered** ([#134](https://github.com/studio-prospect/qwon-ai-ios/pull/134)) |
| **Intake ledger total** | **24 questions · 18 Unanswered · 6 Answered** |
| **Answer detail** | [G2 Product answer details](./qwon_app_store_public_readiness_intake.md#g2-product-answer-details-2026-06-08) |
| **Source worksheets** | [G2 metadata worksheet](./qwon_app_store_g2_metadata_worksheet.md) · [日本語フォーム](./qwon_app_store_g2_metadata_worksheet_ja.md) |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |

### Recorded intake answers (summary)

| Question ID | Topic | Status |
| --- | --- | --- |
| **Q-AS-04** | App Store title, subtitle, primary description | **Answered** |
| **Q-AS-05** | Screenshot set and device sizes | **Answered** |
| **Q-AS-06** | Locales for metadata and screenshots | **Answered** |

---

## Remaining gate question

**May checklist gate G2 — App Store metadata / screenshots / localization — be marked Closed/Ready?**

Product should confirm:

1. **Q-AS-04 … Q-AS-06** answers in the [intake ledger](./qwon_app_store_public_readiness_intake.md#g2--app-store-metadata--screenshots--localization) are **final enough** for public-readiness planning (not necessarily final ASC listing copy or screenshot assets).
2. **G3** (privacy nutrition labels) and downstream gates may proceed using G2 metadata/screenshot/locale direction without reopening G2.
3. No **Needs revision** blockers remain on title/subtitle/description direction, screenshot set scope, or primary locale selection.

If **Needs revision**, record what must change and **do not** mark gate **G2** Closed/Ready until intake rows are updated via a separate docs-only PR.

---

<a id="sign-off-record-product"></a>

## Sign-off record (Product)

| Field | Record |
| --- | --- |
| **Decision** | **Pending** |
| **Owner** | Product |
| **Date** | — |
| **Source** | — |
| **Notes** | — |

### Decision guide

| Decision | Checklist gate G2 | Next docs-only step |
| --- | --- | --- |
| **Approved** | May mark **Closed/Ready** in follow-up PR | [G3 intake](./qwon_app_store_public_readiness_intake.md#g3--privacy-nutrition-labels) (Q-AS-07 … Q-AS-08) when Product scopes next gate |
| **Not approved** | Stays **Open** | Product revises G2 metadata/screenshot/locale direction; may require intake row updates |
| **Needs revision** | Stays **Open** | Amend intake answers via separate docs-only PR; re-run this worksheet |

---

## Sign-off checklist

| Item | Status |
| --- | --- |
| Q-AS-04 … Q-AS-06 **Answered** in intake | **Done** ([#134](https://github.com/studio-prospect/qwon-ai-ios/pull/134)) |
| Product **Decision** recorded above | **Pending** |
| Follow-up docs-only PR updates checklist **G2** to Closed/Ready | **Pending** |
| Public release approved | **No** |
| Build `4` / TestFlight upload / ASC metadata upload approved | **No** |

---

## Agent note

Share this worksheet with Product for **explicit G2 gate sign-off**. **Do not** mark checklist gate **G2 Closed/Ready** or approve public release from worksheet creation alone. Stay-allowed hygiene only.
