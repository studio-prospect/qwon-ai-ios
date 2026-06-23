# QWON — App Store G5 Model Distribution Policy Gate Sign-off Worksheet

**Last updated:** 2026-06-22 (Post-merge PR reference hygiene — G5 gate sign-off **Approved**; checklist gate **G5 Closed/Ready**)
**Status:** **Sign-off Approved** — intake **Q-AS-11 … Q-AS-12 Answered** ([#149](https://github.com/studio-prospect/qwon-ai-ios/pull/149)); checklist gate **G5 Closed/Ready** ([#157](https://github.com/studio-prospect/qwon-ai-ios/pull/157)). **Not** in-app download / M3 reopen approval. **Not** hosted distribution approval. **Not** bundled weights approval. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump / ASC submission not approved.**
**Purpose:** Legal / Product decision surface to record whether checklist gate **G5 — Model distribution policy** may move from **Open** to **Closed/Ready** after intake **Q-AS-11 … Q-AS-12** are **Answered**.

Related: [Public readiness checklist — G5](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [Intake ledger — G5](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) · [G5 model distribution worksheet](./qwon_app_store_g5_model_distribution_worksheet.md) · [G5 モデル配布ポリシー回答フォーム（日本語）](./qwon_app_store_g5_model_distribution_worksheet_ja.md) · [G4 gate sign-off](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) · [G3 gate sign-off](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) · [G2 gate sign-off](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) · [G1 gate sign-off](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) · [M3 distribution compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [M3 hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md) · [M2 guided placement](./qwon_model_download_gguf_ux_plan.md#pr-m2-post-merge-verification-2026-06-04) · [M3 spike outcome — Option A](./qwon_m3_spike_outcome_decision.md#decision-record) · [Next work queue — App Store readiness](./qwon_next_work_queue.md#app-store-public-release) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## Explicit boundaries (read first)

| Boundary | Meaning |
| --- | --- |
| **G5 sign-off ≠ in-app download / M3 reopen** | Closing gate **G5** does **not** enable M3 in-app download, lift M3 lane closure, or approve Build `4` |
| **G5 sign-off ≠ hosted distribution approval** | Closing gate **G5** does **not** approve QWON-hosted mirror, in-app HTTPS model fetch, or any QWON distribution channel for third-party weights |
| **G5 sign-off ≠ bundled weights approval** | Closing gate **G5** does **not** approve shipping GGUF inside the App Store binary |
| **G5 sign-off ≠ public release approval** | Closing gate **G5** does **not** approve App Store public listing or go-live |
| **G5 sign-off ≠ Build `4` approval** | No TestFlight upload, tag, or **`CFBundleVersion` bump** |
| **G5 sign-off ≠ ASC submission** | No App Store Connect upload, hosting ops, or submission from this worksheet |
| **Stay selected** | Sign-off worksheet maintenance does **not** lift Stay or authorize implementation |
| **Intake complete ≠ gate Ready** | All G5 intake rows **Answered** is **necessary** but **not sufficient** — Legal / Product must record sign-off below |

---

## Current evidence

| Field | Value |
| --- | --- |
| **Checklist gate** | **G5 — Model distribution policy** — **Closed/Ready** |
| **Intake questions** | **Q-AS-11 … Q-AS-12** — **Answered** ([#149](https://github.com/studio-prospect/qwon-ai-ios/pull/149)) |
| **Intake ledger total** | **24 questions · 12 Unanswered · 12 Answered** |
| **Answer detail** | [G5 Legal/Product answer details](./qwon_app_store_public_readiness_intake.md#g5-legalproduct-answer-details-2026-06-08) |
| **Source worksheets** | [G5 model distribution worksheet](./qwon_app_store_g5_model_distribution_worksheet.md) · [日本語フォーム](./qwon_app_store_g5_model_distribution_worksheet_ja.md) |
| **Checklist gates G1 + G2 + G3 + G4 + G5** | **Closed/Ready** — [G1 sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) · [G2 sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) · [G3 sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) · [G4 sign-off Approved](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) · [G5 sign-off Approved](#sign-off-record-legal-product) ([#157](https://github.com/studio-prospect/qwon-ai-ios/pull/157)) |
| **M3 posture** | **Option A selected** — compile-gated **default-off**; M3 lane **closed** · [decision record](./qwon_m3_spike_outcome_decision.md#decision-record) |
| **Tester-visible model path** | M2 **Place GGUF via Mac** + USB — [guided placement](./qwon_model_download_gguf_ux_plan.md#pr-m2-post-merge-verification-2026-06-04); app does **not** download GGUF in-app on build `3` |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · ASC **`6775685841`** · **GGUF not bundled** in shipped binary |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |
| **In-app download / hosted distribution / bundled weights approved?** | **No** |

### Recorded intake answers (summary)

| Question ID | Topic | Status |
| --- | --- | --- |
| **Q-AS-11** | Public model distribution policy — Mac+USB Place GGUF via Mac only (Option A) interim recommendation; in-app download / bundled weights / phased combination **deferred** | **Answered** |
| **Q-AS-12** | License and redistribution constraints — user-managed side data + third-party model attribution / notices direction; Legal confirmation required before final copy | **Answered** |

---

## Remaining gate question

**Can G5 be marked Closed/Ready for public-readiness planning while keeping distribution implementation and release ops unapproved?**

**Answer (2026-06-11):** **Yes** — Legal / Product **Approved** sign-off below. **Option A (Mac+USB Place GGUF via Mac only)** interim posture is acceptable for first public-readiness planning aligned with TestFlight **`0.1.0 (3)`** — without approving in-app download, hosted distribution, bundled weights, M3 reopen, or Build `4`. **G6** may proceed using G5 model distribution direction. Legal verification items (e.g. bartowski redistribution rights, QWON-hosted mirror, final attribution / notices) remain **pre-submission verify** — not waived by gate closure.

---

<a id="sign-off-record-legal-product"></a>

## Sign-off record (Legal / Product)

| Field | Record |
| --- | --- |
| **Decision** | **Approved** |
| **Owner** | Legal / Product |
| **Date** | 2026-06-11 |
| **Source** | [#157](https://github.com/studio-prospect/qwon-ai-ios/pull/157) |
| **Notes** | G5 model distribution direction (Option A Mac+USB interim) is sufficient for public-readiness planning; in-app download, hosted distribution, bundled weights, M3 reopen, final public release, and Build `4` remain **not approved**. |

### Decision guide

| Decision | Checklist gate G5 | Next docs-only step |
| --- | --- | --- |
| **Approved** | May mark **Closed/Ready** in follow-up PR | [G6 intake](./qwon_app_store_public_readiness_intake.md#g6--support--website--terms--privacy-policy) (Q-AS-13 … Q-AS-15) when Product scopes next gate |
| **Not approved** | Stays **Open** | Legal / Product revises G5 model distribution / license direction; may require intake row updates |
| **Needs revision** | Stays **Open** | Amend intake answers via separate docs-only PR; update worksheet / intake source first; re-run this worksheet |

---

## Sign-off checklist

| Item | Status |
| --- | --- |
| Q-AS-11 … Q-AS-12 **Answered** in intake | **Done** ([#149](https://github.com/studio-prospect/qwon-ai-ios/pull/149)) |
| Legal / Product **Decision** recorded above | **Done** — **Approved** (2026-06-11) |
| Follow-up docs-only PR updates checklist **G5** to Closed/Ready | **Done** — [#157](https://github.com/studio-prospect/qwon-ai-ios/pull/157) |
| In-app download / M3 reopen / hosted distribution approved | **No** |
| Bundled weights approved | **No** |
| Public release approved | **No** |
| Build `4` / TestFlight upload / ASC submission approved | **No** |

---

## Agent note

Gate **G5** sign-off **Approved** — checklist gate **G5 Closed/Ready**. Next docs-only step: **G6 worksheet preparation / support–website–terms–privacy** · [intake G6](./qwon_app_store_public_readiness_intake.md#g6--support--website--terms--privacy-policy) (Q-AS-13 … Q-AS-15) when Product scopes next gate. **Do not** reopen M3, approve in-app download / hosted distribution / bundled weights, approve public release, or approve Build `4` from gate closure alone. Stay-allowed hygiene only.
