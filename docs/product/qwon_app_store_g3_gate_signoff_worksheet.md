# QWON — App Store G3 Gate Sign-Off Worksheet

**Last updated:** 2026-06-08 (Stay selected — G3 gate sign-off worksheet added; checklist gate **G3 Open**)
**Status:** **Sign-off pending** — intake **Q-AS-07 … Q-AS-08 Answered** ([#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)); checklist gate **G3** remains **Open**. **Not** final ASC privacy nutrition label publish. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump / ASC submission not approved.**
**Purpose:** Legal / Product decision surface to record whether checklist gate **G3 — Privacy nutrition labels** may move from **Open** to **Closed/Ready** after intake **Q-AS-07 … Q-AS-08** are **Answered**.

Related: [Public readiness checklist — G3](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [Intake ledger — G3](./qwon_app_store_public_readiness_intake.md#g3--privacy-nutrition-labels) · [G3 privacy worksheet](./qwon_app_store_g3_privacy_worksheet.md) · [G3 プライバシー回答フォーム（日本語）](./qwon_app_store_g3_privacy_worksheet_ja.md) · [G2 gate sign-off](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) · [G1 gate sign-off](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) · [Next work queue — App Store readiness](./qwon_next_work_queue.md#app-store-public-release) · [M3 network memo](./qwon_m3_network_device_expectation_memo.md) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## Explicit boundaries (read first)

| Boundary | Meaning |
| --- | --- |
| **G3 sign-off ≠ final ASC privacy label publish** | Closing gate **G3** does **not** publish or finalize App Store Connect App Privacy / nutrition label answers |
| **G3 sign-off ≠ public release approval** | Closing gate **G3** does **not** approve App Store public listing or go-live |
| **G3 sign-off ≠ Build `4` approval** | No TestFlight upload, tag, or **`CFBundleVersion` bump** |
| **G3 sign-off ≠ ASC submission** | No App Store Connect privacy label publish, metadata upload, or submission ops from this worksheet |
| **Stay selected** | Sign-off worksheet maintenance does **not** lift Stay or authorize implementation |
| **Intake complete ≠ gate Ready** | All G3 intake rows **Answered** is **necessary** but **not sufficient** — Legal / Product must record sign-off below |

---

## Current evidence

| Field | Value |
| --- | --- |
| **Checklist gate** | **G3 — Privacy nutrition labels** — **Open** |
| **Intake questions** | **Q-AS-07 … Q-AS-08** — **Answered** ([#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)) |
| **Intake ledger total** | **24 questions · 16 Unanswered · 8 Answered** |
| **Answer detail** | [G3 Legal/Product answer details](./qwon_app_store_public_readiness_intake.md#g3-legalproduct-answer-details-2026-06-08) |
| **Source worksheets** | [G3 privacy worksheet](./qwon_app_store_g3_privacy_worksheet.md) · [日本語フォーム](./qwon_app_store_g3_privacy_worksheet_ja.md) |
| **Checklist gates G1 + G2** | **Closed/Ready** — [G1 sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) · [G2 sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |
| **ASC privacy label publish approved?** | **No** |

### Recorded intake answers (summary)

| Question ID | Topic | Status |
| --- | --- | --- |
| **Q-AS-07** | ASC privacy nutrition labels — build `3` posture (on-device LLM; no M3 downloader UI) | **Answered** |
| **Q-AS-08** | Privacy label impact — future in-app model download / cloud / diagnostics vs build `3` | **Answered** |

---

## Remaining gate question

**May checklist gate G3 — Privacy nutrition labels — be marked Closed/Ready?**

Legal / Product should confirm:

1. **Q-AS-07 … Q-AS-08** answers in the [intake ledger](./qwon_app_store_public_readiness_intake.md#g3--privacy-nutrition-labels) are **final enough** for public-readiness planning (not necessarily final ASC App Privacy category selections or published nutrition labels).
2. **G4** (export compliance) and **G5** (model distribution policy) may proceed using G3 privacy / label direction without reopening G3.
3. No **Needs revision** blockers remain on build `3` privacy posture, ASC mapping direction, or future download-build label update requirements.
4. **RE/Legal verification** items noted in intake (e.g. third-party SDK absence, cloud-optional path, local-only diagnostics) are acknowledged as **pre-submission verify** — not waived by gate closure.

If **Needs revision**, record what must change and **do not** mark gate **G3** Closed/Ready until intake rows are updated via a separate docs-only PR.

---

<a id="sign-off-record-legal"></a>

## Sign-off record (Legal / Product)

| Field | Record |
| --- | --- |
| **Decision** | **Pending** |
| **Owner** | Legal / Product |
| **Date** | — |
| **Source** | — |
| **Notes** | — |

### Decision guide

| Decision | Checklist gate G3 | Next docs-only step |
| --- | --- | --- |
| **Approved** | May mark **Closed/Ready** in follow-up PR | [G4 intake](./qwon_app_store_public_readiness_intake.md#g4--export-compliance--encryption-declaration) (Q-AS-09 … Q-AS-10) when Product scopes next gate |
| **Not approved** | Stays **Open** | Legal / Product revises G3 privacy / label direction; may require intake row updates |
| **Needs revision** | Stays **Open** | Amend intake answers via separate docs-only PR; re-run this worksheet |

---

## Sign-off checklist

| Item | Status |
| --- | --- |
| Q-AS-07 … Q-AS-08 **Answered** in intake | **Done** ([#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)) |
| Legal / Product **Decision** recorded above | **Pending** |
| Follow-up docs-only PR updates checklist **G3** to Closed/Ready | **Pending** |
| Final ASC privacy label publish approved | **No** |
| Public release approved | **No** |
| Build `4` / TestFlight upload / ASC submission approved | **No** |

---

## Agent note

Share this worksheet with **Legal / Product** for **explicit G3 gate sign-off**. **Do not** mark checklist gate **G3 Closed/Ready**, publish ASC privacy labels, or approve public release from worksheet creation alone. Stay-allowed hygiene only.
