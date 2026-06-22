# QWON — App Store G4 Gate Sign-Off Worksheet

**Last updated:** 2026-06-22 (Post-merge PR reference hygiene — G4 sign-off **Approved**; checklist gate **G4 Closed/Ready**)
**Status:** **Sign-off recorded** — checklist gate **G4** **Closed/Ready** ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)). **Not** export compliance final submission. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump / ASC submission not approved.**
**Purpose:** Legal / Release Engineering decision surface to record whether checklist gate **G4 — Export compliance / encryption declaration** may move from **Partial** to **Closed/Ready** after intake **Q-AS-09 … Q-AS-10** are **Answered**.

Related: [Public readiness checklist — G4](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [Intake ledger — G4](./qwon_app_store_public_readiness_intake.md#g4--export-compliance--encryption-declaration) · [G4 export compliance worksheet](./qwon_app_store_g4_export_compliance_worksheet.md) · [G4 輸出コンプライアンス回答フォーム（日本語）](./qwon_app_store_g4_export_compliance_worksheet_ja.md) · [G3 gate sign-off](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) · [G2 gate sign-off](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) · [G1 gate sign-off](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) · [TestFlight prep — export compliance gate](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) · [Next work queue — App Store readiness](./qwon_next_work_queue.md#app-store-public-release) · [M3 distribution compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## Explicit boundaries (read first)

| Boundary | Meaning |
| --- | --- |
| **G4 sign-off ≠ export compliance final submission** | Closing gate **G4** does **not** submit ASC export compliance / encryption answers or complete App Store Connect compliance ops |
| **G4 sign-off ≠ public release approval** | Closing gate **G4** does **not** approve App Store public listing or go-live |
| **G4 sign-off ≠ Build `4` approval** | No TestFlight upload, tag, or **`CFBundleVersion` bump** |
| **G4 sign-off ≠ ASC submission** | No App Store Connect upload, export compliance publish, or submission ops from this worksheet |
| **Stay selected** | Sign-off worksheet maintenance does **not** lift Stay or authorize implementation |
| **Intake complete ≠ gate Ready** | All G4 intake rows **Answered** is **necessary** but **not sufficient** — Legal / Release Engineering must record sign-off below |

---

## Current evidence

| Field | Value |
| --- | --- |
| **Checklist gate** | **G4 — Export compliance / encryption declaration** — **Closed/Ready** ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)) |
| **Intake questions** | **Q-AS-09 … Q-AS-10** — **Answered** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)) |
| **Intake ledger total** | **24 questions · 14 Unanswered · 10 Answered** |
| **Answer detail** | [G4 Legal/RE answer details](./qwon_app_store_public_readiness_intake.md#g4-legalre-answer-details-2026-06-08) |
| **Source worksheets** | [G4 export compliance worksheet](./qwon_app_store_g4_export_compliance_worksheet.md) · [日本語フォーム](./qwon_app_store_g4_export_compliance_worksheet_ja.md) |
| **Checklist gates G1 + G2 + G3** | **Closed/Ready** — [G1 sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) · [G2 sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) · [G3 sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · ASC **`6775685841`** |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |
| **Export compliance final submission approved?** | **No** |

### Recorded intake answers (summary)

| Question ID | Topic | Status |
| --- | --- | --- |
| **Q-AS-09** | Export compliance vs TestFlight build `2` attestation — updated review required for public submit | **Answered** |
| **Q-AS-10** | ASC export compliance sign-off owner (RE primary, Legal review) and re-verification steps | **Answered** |

---

## Remaining gate question

**May checklist gate G4 — Export compliance / encryption declaration — be marked Closed/Ready?**

Legal / Release Engineering should confirm:

1. **Q-AS-09 … Q-AS-10** answers in the [intake ledger](./qwon_app_store_public_readiness_intake.md#g4--export-compliance--encryption-declaration) are **final enough** for public-readiness planning (not necessarily final ASC export compliance questionnaire answers or submitted attestation).
2. **G5** (model distribution policy) and downstream gates may proceed using G4 export compliance / encryption direction without reopening G4.
3. No **Needs revision** blockers remain on public-submit vs TestFlight build `2` attestation posture, sign-off owner assignment, or re-verification step scope.
4. **RE/Legal verification** items noted in intake (e.g. build `3` doc gap, public-release candidate binary vs TestFlight **`0.1.0 (3)`**, pre-submit operator checklist adaptation) are acknowledged as **pre-submission verify** — not waived by gate closure.

If **Needs revision**, record what must change and **do not** mark gate **G4** Closed/Ready until intake rows are updated via a separate docs-only PR.

---

<a id="sign-off-record-legal-re"></a>

## Sign-off record (Legal / Release Engineering)

| Field | Record |
| --- | --- |
| **Decision** | **Approved** |
| **Owner** | Legal / Release Engineering |
| **Date** | 2026-06-08 |
| **Source** | [#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146) |
| **Notes** | G4 export compliance direction is sufficient for public-readiness planning; final ASC submission / public release / Build `4` remain **not approved**. |

### Decision guide

| Decision | Checklist gate G4 | Next docs-only step |
| --- | --- | --- |
| **Approved** | May mark **Closed/Ready** in follow-up PR | [G5 intake](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) (Q-AS-11 … Q-AS-12) when Product scopes next gate |
| **Not approved** | Stays **Partial** | Legal / RE revises G4 export compliance / encryption direction; may require intake row updates |
| **Needs revision** | Stays **Partial** | Amend intake answers via separate docs-only PR; re-run this worksheet |

---

## Sign-off checklist

| Item | Status |
| --- | --- |
| Q-AS-09 … Q-AS-10 **Answered** in intake | **Done** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)) |
| Legal / RE **Decision** recorded above | **Done** — **Approved** (2026-06-08) |
| Follow-up docs-only PR updates checklist **G4** to Closed/Ready | **Done** — [#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146) |
| Export compliance final submission approved | **No** |
| Public release approved | **No** |
| Build `4` / TestFlight upload / ASC submission approved | **No** |

---

## Agent note

Gate **G4** sign-off **Approved** — next docs-only step: **G5 worksheet preparation / model distribution policy** · [intake G5](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) (Q-AS-11 … Q-AS-12) when Product scopes next gate. **Do not** submit ASC export compliance, approve public release, or approve Build `4` from gate closure alone.
