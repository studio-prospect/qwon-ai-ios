# QWON — App Store G3 Privacy Nutrition Labels Worksheet (External Share)

**Last updated:** 2026-06-08 (G3 Legal/Product **approved for intake recording** — gate sign-off **Open**)
**Status:** **Worksheet with Legal/Product decision draft — approved for intake recording** — intake rows **Q-AS-07 … Q-AS-08** are **Answered** in the [intake ledger](./qwon_app_store_public_readiness_intake.md) (This PR). **Not** final App Store privacy nutrition label answers. **Not** ASC privacy label publish. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump not approved.**
**Purpose:** Shareable English worksheet for **Legal / Product** — G3 intake answers recorded; **G3 gate sign-off** remains **Open** (separate worksheet).

日本語版: [G3 プライバシー回答フォーム（日本語）](./qwon_app_store_g3_privacy_worksheet_ja.md)

Related: [Intake ledger — G3](./qwon_app_store_public_readiness_intake.md#g3--privacy-nutrition-labels) · [Checklist — G3](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [M3 network memo](./qwon_m3_network_device_expectation_memo.md) · [M3 distribution compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [M2 guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement) · [M3 spike outcome — Option A](./qwon_m3_spike_outcome_decision.md#decision-record) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## Explicit boundaries (read first)

| Boundary | Meaning |
| --- | --- |
| **G3 worksheet ≠ privacy label final answer** | Filling this worksheet does **not** set ASC App Privacy answers or publish nutrition labels |
| **G3 worksheet ≠ public release approval** | Worksheet maintenance does **not** approve App Store public listing or go-live |
| **G3 worksheet ≠ Build `4` approval** | No TestFlight upload, tag, or **`CFBundleVersion` bump** |
| **G3 worksheet ≠ ASC submission** | No App Store Connect metadata upload, privacy label publish, or submission ops from this doc |
| **Stay selected** | Worksheet maintenance does **not** lift Stay or authorize implementation |
| **No product/code changes** | **No** app code, analytics SDK, diagnostics SDK, or data-collection behavior changes from this doc |
| **Draft suggestions** | Superseded by [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval) — historical suggested drafts below |
| **Recording answers** | Legal / Product **approved for intake recording** 2026-06-08 — intake **Answered** (This PR); **G3 gate sign-off** still **Open** |

---

<a id="legal-product-decision-draft--awaiting-explicit-approval"></a>

## Legal/Product decision draft — **approved for intake recording**

**Label:** **Legal/Product decision draft — approved for intake recording (2026-06-08)** — recorded in [intake ledger — G3 answer details](./qwon_app_store_public_readiness_intake.md#g3-legalproduct-answer-details-2026-06-08) (This PR; worksheet prep [#138](https://github.com/studio-prospect/qwon-ai-ios/pull/138)). **Not** G3 Closed/Ready. **Not** final ASC privacy label publish. **Not** public release or Build `4` approval.

| Field | Value |
| --- | --- |
| **Prepared** | 2026-06-08 — docs-only hygiene under Stay ([#137](https://github.com/studio-prospect/qwon-ai-ios/pull/137); decision draft [#138](https://github.com/studio-prospect/qwon-ai-ios/pull/138)) |
| **Intake ledger** | **Q-AS-07 … Q-AS-08 Answered** (This PR) |
| **Next step** | **G3 gate sign-off worksheet preparation** → on Legal / Product approval, separate docs-only PR sets checklist gate **G3 Closed/Ready** |

### Q-AS-07 — ASC privacy nutrition labels (build `3` posture)

| Field | Legal/Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-07 |
| **Approved answer (draft)** | For public-readiness planning on TestFlight **`0.1.0 (3)`** (no M3 downloader UI): privacy posture centered on **on-device LLM inference** — user chat/content processed **locally** when local model is available; **no in-app model HTTPS download**; M2 **Place GGUF via Mac** + USB is the tester-visible placement path. |
| **ASC data types (draft)** | Legal to map **User Content** (or ASC-equivalent) for on-device processing — **not** used for third-party advertising; **no** contact info, location, browsing history, or advertising identifiers planned for build `3`. |
| **Data linked to user (draft)** | **No** for third-party advertising/tracking categories — **RE/Legal verify** against shipped binary. |
| **Data used to track (draft)** | **No** third-party tracking SDK assumed on build `3`. |
| **Cloud-optional path (draft)** | Any optional cloud LLM escalation (if present) requires **separate disclosure** — Legal to confirm actual behavior before ASC publish. |
| **Diagnostics / crash data (draft)** | In-app runtime diagnostics **local-only** on build `3`; **no** crash-analytics SDK — **RE verify**. |
| **Decision owner** | Legal (**approved for intake recording** — 2026-06-08) |
| **Source** | Elaborated from [suggested draft § Q-AS-07](#q-as-07--asc-privacy-nutrition-labels-build-3-posture); aligned with [G1/G2 inputs](#g1--g2-inputs-for-g3-reference) |
| **Constraints** | **Not** final ASC privacy label publish; **not** G3 Closed/Ready |

### Q-AS-08 — Privacy label impact of model download / cloud / diagnostics

| Field | Legal/Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-08 |
| **Approved answer (draft)** | A future public build with **user-initiated in-app model download** (M3 or successor) requires **privacy label update** vs build `3` — network for **model acquisition**, not per-message chat; **release-time ASC/privacy re-check** mandatory before any download build ships. |
| **Categories changed vs build `3` (draft)** | Legal to map network-related and product-interaction categories — **not** a final ASC category list. |
| **Network disclosure (draft)** | Disclose user-initiated HTTPS model fetch (~400 MB class) **before** download starts · [M3 network memo — Gate 6](./qwon_m3_network_device_expectation_memo.md#gate-6--privacy--network-disclosure-copy). |
| **Model download impact (draft)** | Foreground, user-initiated fetch only; **local-first after install** — label must **not** claim fully offline if download exists. |
| **Cloud-optional impact (draft)** | Optional cloud LLM path (if shipped) needs disclosure **separate** from local inference and from download acquisition. |
| **Diagnostics / support impact (draft)** | Crash analytics or support PII collection would require **additional** label updates — out of build `3` baseline; deferred to [Q-AS-13](./qwon_app_store_public_readiness_intake.md#g6--support--website--terms--privacy-policy). |
| **Dependency (draft)** | [Q-AS-11](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) model distribution policy; build `3` answers **do not automatically transfer**. |
| **Decision owner** | Legal (**approved for intake recording** — 2026-06-08) |
| **Source** | Elaborated from [suggested draft § Q-AS-08](#q-as-08--privacy-label-impact-of-model-download--cloud--diagnostics) · [M3 gate answers](./qwon_m3_gate_answer_intake.md) |
| **Constraints** | **Not** final privacy label approval; **not** G3 Closed/Ready |

---

## Current evidence

| Field | Value |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **Checklist gate G2** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) ([#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)) |
| **Intake ledger total** | **24 questions · 16 Unanswered · 8 Answered** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · ASC **`6775685841`** · **no M3 downloader UI** |
| **M3 posture** | **Option A selected** — compile-gated **default-off**; M3 lane **closed** · [decision record](./qwon_m3_spike_outcome_decision.md#decision-record) |
| **Tester-visible model path** | M2 **Place GGUF via Mac** + USB — [guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement); app does **not** download GGUF in-app on build `3` |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |
| **ASC privacy label publish approved?** | **No** |
| **Checklist gate G3** | **Open** — gate sign-off pending |
| **G3 intake** | **Q-AS-07 … Q-AS-08 Answered** (This PR) |

### G1 + G2 inputs for G3 (reference)

| Source | Summary |
| --- | --- |
| **G1 Q-AS-01** | Local-first cognitive runtime — on-device inference/context by default |
| **G1 Q-AS-02** | Primary: privacy-conscious early adopters |
| **G2 Q-AS-04** | App Store copy emphasizes local-first / privacy-conscious positioning |
| **M3 Gate 6 direction** | If download ships later: disclose network use before fetch; release-time ASC/privacy re-check required · [network memo](./qwon_m3_network_device_expectation_memo.md) |

---

## Answer format (copy for each question)

```text
Question ID:
Approved answer:
Decision owner:
Source (meeting / email / memo / PR):
ASC category mapping (if applicable):
Constraints or deferrals:
```

---

## Q-AS-07 — ASC privacy nutrition labels (build `3` posture)

| Field | Value |
| --- | --- |
| **Gate** | G3 |
| **Owner** | Legal |
| **Intake status** | **Answered** (This PR) |

### Question

What **ASC privacy nutrition label** answers apply for on-device LLM inference on the current build **`3`** posture (no M3 downloader UI on TestFlight)?

### Legal / Product answer (fill in)

**See [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval)** — intake **Answered** (This PR); **G3 gate sign-off** still **Open**.

| Field | Your answer |
| --- | --- |
| **Approved answer** | For public-readiness planning on TestFlight **`0.1.0 (3)`** (no M3 downloader UI): on-device LLM inference; user chat/content processed locally when local model available; no in-app model HTTPS download; M2 **Place GGUF via Mac** + USB is tester-visible path. *(approved for intake recording)* |
| **ASC data types declared** | Legal to map **User Content** (or equivalent) for on-device processing — not for third-party advertising. *(approved for intake recording)* |
| **Data linked to user?** | **No** for third-party advertising/tracking — RE/Legal verify. *(approved for intake recording)* |
| **Data used to track user?** | **No** third-party tracking SDK on build `3`. *(approved for intake recording)* |
| **Cloud-optional path (if any)** | Separate disclosure if optional cloud LLM escalation exists — Legal to confirm. *(approved for intake recording)* |
| **Diagnostics / crash data** | Local-only runtime diagnostics; no crash-analytics SDK — RE verify. *(approved for intake recording)* |
| **Decision owner** | Legal (approved for intake recording) |
| **Source** | [Intake ledger — G3 answer details](./qwon_app_store_public_readiness_intake.md#g3-legalproduct-answer-details-2026-06-08) |
| **Constraints** | Not final ASC publish; not G3 Closed/Ready |

### Suggested draft — **superseded (historical)**

> *Superseded by [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval) — retained for traceability.*

> **Build `3` baseline (planning draft):**
> - **No M3 in-app model download** on TestFlight **`0.1.0 (3)`**; M2 **Place GGUF via Mac** + USB is the tester-visible placement path.
> - **Local inference:** User chat/content processed **on-device** when local model is available — Legal to map to ASC categories (e.g. **User Content** — processed on-device; not used for third-party advertising).
> - **Third-party analytics / ads (draft):** Plan assumes **no third-party analytics or advertising SDK** on build `3` — **RE/Legal verify** against shipped binary.
> - **Network (build `3`):** No in-app model HTTPS fetch; any **optional cloud LLM escalation** (if present) must be disclosed separately — Legal to confirm actual behavior.
> - **Diagnostics:** In-app runtime diagnostics are **local-only** on build `3`; no crash-analytics SDK assumed — **RE verify**.
> - **Support contact:** In-app PII collection not assumed — deferred to [Q-AS-13](./qwon_app_store_public_readiness_intake.md#g6--support--website--terms--privacy-policy).

Legal must edit, replace, or reject. **Not** final App Store privacy nutrition label answers.

### Unblocks

Q-AS-08, G3 sign-off

---

## Q-AS-08 — Privacy label impact of model download / cloud / diagnostics

| Field | Value |
| --- | --- |
| **Gate** | G3 |
| **Owner** | Legal |
| **Intake status** | **Answered** (This PR) |

### Question

If a future **public build** includes in-app model download (M3 or successor), what privacy label changes are required vs build **`3`**?

### Legal / Product answer (fill in)

**See [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval)** — intake **Answered** (This PR); **G3 gate sign-off** still **Open**.

| Field | Your answer |
| --- | --- |
| **Approved answer** | Future build with user-initiated in-app model download requires privacy label update vs build `3`; network for acquisition not per-message chat; release-time ASC/privacy re-check before download build. *(approved for intake recording)* |
| **Categories changed vs build `3`** | Legal to map network-related / product-interaction categories — not final list. *(approved for intake recording)* |
| **Network disclosure requirement** | Disclose HTTPS fetch (~400 MB class) before download starts. *(approved for intake recording)* |
| **Model download impact** | User-initiated foreground fetch; local-first after install; no fully-offline claim. *(approved for intake recording)* |
| **Cloud-optional impact** | Separate disclosure from local path and download acquisition if shipped. *(approved for intake recording)* |
| **Diagnostics / support impact** | Additional label updates if crash analytics or support PII added — out of build `3` baseline. *(approved for intake recording)* |
| **Decision owner** | Legal (approved for intake recording) |
| **Source** | [Intake ledger — G3 answer details](./qwon_app_store_public_readiness_intake.md#g3-legalproduct-answer-details-2026-06-08) |
| **Constraints** | Depends on Q-AS-11; not G3 Closed/Ready |

### Suggested draft — **superseded (historical)**

> *Superseded by [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval) — retained for traceability.*

> **Future build with in-app download (planning draft):**
> - **User-initiated HTTPS model fetch** (~400 MB class) requires **privacy label update** vs build `3` — network for **acquisition**, not per-message chat · [M3 network memo — Gate 6](./qwon_m3_network_device_expectation_memo.md#gate-6--privacy--network-disclosure-copy).
> - **Categories likely affected (draft):** Legal to map — may include network-related disclosure, product interaction, or diagnostics; **not** a final category list.
> - **Local-first after install:** Label must **not** claim fully offline if download exists; inference remains on-device after model install.
> - **Cloud optional:** Optional cloud LLM path (if shipped) needs separate disclosure from local path and from download acquisition.
> - **Diagnostics / support:** Adding crash analytics or support contact collection would require **additional** label updates — out of scope for build `3` baseline.
> - **Dependency:** [Q-AS-11](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) model distribution policy; **release-time ASC/privacy re-check** before any download build ([M3 gate answers](./qwon_m3_gate_answer_intake.md)).
> - **Build `3` answers do not automatically transfer** — separate Legal review required.

Legal must edit, replace, or reject. **Not** final privacy label approval.

### Unblocks

G3 sign-off; informs Q-AS-11 (model distribution)

---

## G3 completion checklist (worksheet — not gate sign-off)

| Item | Status |
| --- | --- |
| Q-AS-07 Legal/Product decision draft prepared | **Done** — [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval) |
| Q-AS-08 Legal/Product decision draft prepared | **Done** — approved for intake recording |
| Legal / Product **approved for intake recording** | **Done** — 2026-06-08 (This PR) |
| Follow-up docs-only PR updates intake to **Answered** | **Done** — This PR |
| **G3 gate sign-off worksheet** preparation | **Next** |
| Checklist gate G3 marked Closed/Ready | **No** — separate sign-off gate |
| Public release approved | **No** |
| Build `4` / ASC privacy label publish approved | **No** |

---

## Agent note

Share with **Legal / Product** for **G3 gate sign-off** (next worksheet). Intake **Answered** (This PR) does **not** publish ASC privacy labels, approve public release, or mark **G3 Closed/Ready**. Stay-allowed hygiene only.
