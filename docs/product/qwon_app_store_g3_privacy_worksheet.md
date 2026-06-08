# QWON — App Store G3 Privacy Nutrition Labels Worksheet (External Share)

**Last updated:** 2026-06-08 (G3 privacy worksheet added — intake **Unanswered**)
**Status:** **Shareable worksheet** — intake rows **Q-AS-07 … Q-AS-08** remain **Unanswered** in the [intake ledger](./qwon_app_store_public_readiness_intake.md). **Not** final App Store privacy nutrition label answers. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump / ASC submission not approved.**
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
| **Intake status** | **Unanswered** (unchanged until follow-up PR) |

### Question

What **ASC privacy nutrition label** answers apply for on-device LLM inference on the current build **`3`** posture (no M3 downloader UI on TestFlight)?

### Legal / Product answer (fill in)

| Field | Your answer |
| --- | --- |
| **Approved answer** | |
| **ASC data types declared** | |
| **Data linked to user?** | |
| **Data used to track user?** | |
| **Cloud-optional path (if any)** | |
| **Diagnostics / crash data** | |
| **Decision owner** | Legal |
| **Source** | |
| **Constraints** | Not final ASC publish; not intake **Answered** until follow-up PR |

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

| Field | Your answer |
| --- | --- |
| **Approved answer** | |
| **Categories changed vs build `3`** | |
| **Network disclosure requirement** | |
| **Model download impact** | |
| **Cloud-optional impact** | |
| **Diagnostics / support impact** | |
| **Decision owner** | Legal |
| **Source** | |
| **Constraints** | Depends on [Q-AS-11](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy); not intake **Answered** until follow-up PR |

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
| Q-AS-07 worksheet draft prepared | **Done** — [suggested draft § Q-AS-07](#q-as-07--asc-privacy-nutrition-labels-build-3-posture) |
| Q-AS-08 worksheet draft prepared | **Done** — [suggested draft § Q-AS-08](#q-as-08--privacy-label-impact-of-model-download--cloud--diagnostics) |
| Legal / Product **explicit approval** of G3 answers | **Pending** |
| Follow-up docs-only PR updates intake to **Answered** | **Pending** |
| Checklist gate G3 marked Closed/Ready | **No** — separate sign-off gate |
| Public release approved | **No** |
| Build `4` / ASC privacy label publish approved | **No** |

---

## Agent note

Share with **Legal / Product** for review and answer preparation. **Do not** copy suggested drafts into the intake ledger as **Answered** or publish ASC privacy labels until Legal confirms and a follow-up docs-only PR records them. Stay-allowed hygiene only.
