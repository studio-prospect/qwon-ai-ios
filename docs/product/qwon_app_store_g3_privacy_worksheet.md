# QWON — App Store G3 Privacy Nutrition Labels Worksheet (External Share)

**Last updated:** 2026-06-08 (G3 Legal/Product decision draft prepared — intake **Unanswered**)
**Status:** **Worksheet with Legal/Product decision draft / awaiting explicit approval** — intake rows **Q-AS-07 … Q-AS-08** remain **Unanswered** in the [intake ledger](./qwon_app_store_public_readiness_intake.md). **Not** final App Store privacy nutrition label answers. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump / ASC privacy label publish not approved.**
**Purpose:** Shareable English worksheet for **Legal / Product** to answer **G3 — Privacy nutrition labels** before answers are recorded in the intake ledger via a separate docs-only PR.

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
| **Draft suggestions** | Blocks marked **draft / not approved** — Legal / Product must replace or reject before intake recording |
| **Recording answers** | After Legal / Product **explicit approval**, open a **separate docs-only PR** to set intake rows to **Answered** |

---

<a id="legal-product-decision-draft--awaiting-explicit-approval"></a>

## Legal/Product decision draft — **awaiting explicit approval**

**Label:** **Legal/Product decision draft / awaiting explicit Legal/Product approval** — prepared from suggested worksheet drafts and build `3` evidence. **Not** intake **Answered**. **Not** G3 Closed/Ready. **Not** final privacy label or public release approval.

| Field | Value |
| --- | --- |
| **Prepared** | 2026-06-08 — docs-only hygiene under Stay ([#137](https://github.com/studio-prospect/qwon-ai-ios/pull/137)) |
| **Intake ledger** | **Q-AS-07 … Q-AS-08** remain **Unanswered** until Legal / Product explicit approval + follow-up PR |
| **Next step** | Legal / Product confirms, edits, or rejects each draft → docs-only PR records **Answered** in [intake ledger](./qwon_app_store_public_readiness_intake.md) |

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
| **Decision owner** | Legal (draft — **awaiting explicit Legal/Product approval**) |
| **Source** | Elaborated from [suggested draft § Q-AS-07](#q-as-07--asc-privacy-nutrition-labels-build-3-posture); aligned with [G1/G2 inputs](#g1--g2-inputs-for-g3-reference) |
| **Constraints** | **Not** final ASC privacy label publish; **not** intake **Answered** until follow-up PR |

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
| **Decision owner** | Legal (draft — **awaiting explicit Legal/Product approval**) |
| **Source** | Elaborated from [suggested draft § Q-AS-08](#q-as-08--privacy-label-impact-of-model-download--cloud--diagnostics) · [M3 gate answers](./qwon_m3_gate_answer_intake.md) |
| **Constraints** | **Not** final privacy label approval; **not** intake **Answered** until follow-up PR |

---

## Current evidence

| Field | Value |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **Checklist gate G2** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) ([#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)) |
| **Intake ledger total** | **24 questions · 18 Unanswered · 6 Answered** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · ASC **`6775685841`** · **no M3 downloader UI** |
| **M3 posture** | **Option A selected** — compile-gated **default-off**; M3 lane **closed** · [decision record](./qwon_m3_spike_outcome_decision.md#decision-record) |
| **Tester-visible model path** | M2 **Place GGUF via Mac** + USB — [guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement); app does **not** download GGUF in-app on build `3` |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |
| **Checklist gate G3** | **Open** |
| **G3 intake** | **Q-AS-07 … Q-AS-08** — **Unanswered** |

### G1 + G2 inputs for G3 (reference)

| Source | Summary |
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
| **Intake status** | **Unanswered** (unchanged until follow-up PR) |

### Question

What **ASC privacy nutrition label** answers apply for on-device LLM inference on the current build **`3`** posture (no M3 downloader UI on TestFlight)?

### Legal / Product answer (fill in)

**See [Legal/Product decision draft](#legal-product-decision-draft--awaiting-explicit-approval)** — **draft / awaiting explicit Legal/Product approval**; intake row remains **Unanswered**.

| Field | Your answer |
| --- | --- |
| **Approved answer** | For public-readiness planning on TestFlight **`0.1.0 (3)`** (no M3 downloader UI): on-device LLM inference; user chat/content processed locally when local model available; no in-app model HTTPS download; M2 **Place GGUF via Mac** + USB is tester-visible path. *(draft — awaiting explicit approval)* |
| **ASC data types declared** | Legal to map **User Content** (or equivalent) for on-device processing — not for third-party advertising. *(draft)* |
| **Data linked to user?** | **No** for third-party advertising/tracking — RE/Legal verify. *(draft)* |
| **Data used to track user?** | **No** third-party tracking SDK on build `3`. *(draft)* |
| **Cloud-optional path (if any)** | Separate disclosure if optional cloud LLM escalation exists — Legal to confirm. *(draft)* |
| **Diagnostics / crash data** | Local-only runtime diagnostics; no crash-analytics SDK — RE verify. *(draft)* |
| **Decision owner** | Legal (draft) |
| **Source** | [Legal/Product decision draft § Q-AS-07](#legal-product-decision-draft--awaiting-explicit-approval) |
| **Constraints** | Not final ASC publish; not intake **Answered** |

### Suggested draft — **draft / not approved**

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
| **Intake status** | **Unanswered** |

### Question

If a future **public build** includes in-app model download (M3 or successor), what privacy label changes are required vs build **`3`**?

### Legal / Product answer (fill in)

**See [Legal/Product decision draft](#legal-product-decision-draft--awaiting-explicit-approval)** — **draft / awaiting explicit Legal/Product approval**; intake row remains **Unanswered**.

| Field | Your answer |
| --- | --- |
| **Approved answer** | Future build with user-initiated in-app model download requires privacy label update vs build `3`; network for acquisition not per-message chat; release-time ASC/privacy re-check before download build. *(draft — awaiting explicit approval)* |
| **Categories changed vs build `3`** | Legal to map network-related / product-interaction categories — not final list. *(draft)* |
| **Network disclosure requirement** | Disclose HTTPS fetch (~400 MB class) before download starts. *(draft)* |
| **Model download impact** | User-initiated foreground fetch; local-first after install; no fully-offline claim. *(draft)* |
| **Cloud-optional impact** | Separate disclosure from local path and download acquisition if shipped. *(draft)* |
| **Diagnostics / support impact** | Additional label updates if crash analytics or support PII added — out of build `3` baseline. *(draft)* |
| **Decision owner** | Legal (draft) |
| **Source** | [Legal/Product decision draft § Q-AS-08](#legal-product-decision-draft--awaiting-explicit-approval) |
| **Constraints** | Depends on Q-AS-11; not intake **Answered** |

### Suggested draft — **draft / not approved**

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
| Q-AS-07 Legal/Product decision draft prepared | **Done** — [awaiting explicit approval](#legal-product-decision-draft--awaiting-explicit-approval) |
| Q-AS-08 Legal/Product decision draft prepared | **Done** — awaiting explicit approval |
| Legal / Product **explicit approval** of G3 drafts | **Pending** |
| Follow-up docs-only PR updates intake to **Answered** | **Pending** |
| Checklist gate G3 marked Closed/Ready | **No** — separate sign-off gate |
| Public release approved | **No** |
| Build `4` / ASC privacy label publish approved | **No** |

---

## Agent note

Share with **Legal / Product** for **explicit approval**. **Do not** copy Legal/Product decision drafts into the intake ledger as **Answered** or publish ASC privacy labels until Legal confirms and a follow-up docs-only PR records them. Stay-allowed hygiene only.
