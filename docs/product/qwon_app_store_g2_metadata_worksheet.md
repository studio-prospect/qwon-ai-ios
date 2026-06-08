# QWON — App Store G2 Metadata Worksheet (External Share)

**Last updated:** 2026-06-08 (G2 intake **Q-AS-04 … Q-AS-06 Answered** — This PR; gate sign-off **Open**)
**Status:** **Product decision draft approved** — intake rows **Q-AS-04 … Q-AS-06** recorded **Answered** in the [intake ledger](./qwon_app_store_public_readiness_intake.md) (This PR). Checklist gate **G2** remains **Open**. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump not approved.**
**Purpose:** Shareable English worksheet for Product to answer **G2 — App Store metadata / screenshots / localization** before answers are recorded in the intake ledger via a separate docs-only PR.

日本語版: [G2 メタデータ回答フォーム（日本語）](./qwon_app_store_g2_metadata_worksheet_ja.md)

Related: [Intake ledger — G2](./qwon_app_store_public_readiness_intake.md#g2--app-store-metadata--screenshots--localization) · [Checklist — G2](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [G1 sign-off](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) · [G1 intake answers](./qwon_app_store_public_readiness_intake.md#g1-product-answer-details-2026-06-07) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## Explicit boundaries (read first)

| Boundary | Meaning |
| --- | --- |
| **G2 worksheet ≠ public release approval** | Filling this worksheet does **not** approve App Store public listing or go-live |
| **G2 worksheet ≠ Build `4` approval** | No TestFlight upload, tag, or **`CFBundleVersion` bump** |
| **G2 worksheet ≠ App Store metadata upload** | No ASC metadata upload, screenshot upload, or submission ops from this doc |
| **Stay selected** | Worksheet maintenance does **not** lift Stay or authorize implementation |
| **Draft suggestions** | Blocks marked **draft / not approved** — Product must replace or reject before intake recording |
| **Recording answers** | After Product **explicit approval**, open a **separate docs-only PR** to set intake rows to **Answered** |

---

<a id="product-decision-draft--awaiting-explicit-approval"></a>

## Product decision draft — **awaiting explicit approval**

**Label:** **Product decision draft — Product approved 2026-06-08** — recorded in [intake ledger](./qwon_app_store_public_readiness_intake.md#g2-product-answer-details-2026-06-08) (This PR). **Not** G2 Closed/Ready. **Not** public release approval.

| Field | Value |
| --- | --- |
| **Prepared** | 2026-06-08 — docs-only hygiene under Stay ([#133](https://github.com/studio-prospect/qwon-ai-ios/pull/133)) |
| **Product explicit approval** | **2026-06-08** — drafts accepted as intake answers |
| **Intake ledger** | **Q-AS-04 … Q-AS-06** — **Answered** (This PR) |
| **Next step** | **G2 gate sign-off worksheet** — separate docs-only PR for checklist **Closed/Ready** |

### Q-AS-04 — App Store title, subtitle, primary description

| Field | Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-04 |
| **Title (draft)** | QWON |
| **Subtitle (draft)** | Local-first AI on your iPhone |
| **Primary description (draft)** | QWON is a local-first cognitive runtime for iPhone. Keep inference and context on-device by default — not a cloud-only chat wrapper. Built for privacy-conscious users who want on-device AI assistance without default cloud dependency. |
| **Decision owner** | Product (draft — **awaiting explicit approval**) |
| **Source** | Elaborated from [recommended draft § Q-AS-04](#q-as-04--app-store-title-subtitle-primary-description); aligned with [G1 Q-AS-01…03](./qwon_app_store_public_readiness_intake.md#g1-product-answer-details-2026-06-07) |
| **Constraints** | **Not** approved App Store listing copy; **not** intake **Answered** until follow-up PR |

### Q-AS-05 — Screenshot set and device sizes

| Field | Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-05 |
| **Approved answer (draft)** | **Device sizes:** iPhone 6.7" and 6.5" display classes (verify current ASC required sizes at submission time). **Orientation:** Portrait only for v1. **Set:** 3–5 screenshots — (1) chat/home, (2) on-device/local indicator or model placement note, (3) privacy/local-first value prop. |
| **Decision owner** | Product (draft — **awaiting explicit approval**) |
| **Source** | Elaborated from [recommended draft § Q-AS-05](#q-as-05--screenshot-set-and-device-sizes) |
| **Constraints** | No ASC screenshot upload from this worksheet; asset creation out of scope |

### Q-AS-06 — Locales for metadata and screenshots

| Field | Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-06 |
| **Primary locale(s) (draft)** | English (U.S.) — `en-US` metadata and screenshots |
| **Deferred locales (draft)** | Japanese (`ja`) and additional locales — **TBD** |
| **Decision owner** | Product (draft — **awaiting explicit approval**) |
| **Source** | Elaborated from [recommended draft § Q-AS-06](#q-as-06--locales-for-metadata-and-screenshots) |
| **Constraints** | Localized metadata/screenshots **not** approved for creation or upload |

---

## Current evidence

| Field | Value |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **G1 intake** | **Q-AS-01 … Q-AS-03** — **Answered** ([#129](https://github.com/studio-prospect/qwon-ai-ios/pull/129)) |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · ASC **`6775685841`** |
| **G2 intake** | **Q-AS-04 … Q-AS-06** — **Answered** (This PR) |
| **Checklist gate G2** | **Open** — gate sign-off pending |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |

### G1 inputs for G2 (reference)

| Question ID | Summary |
| --- | --- |
| **Q-AS-01** | Local-first cognitive runtime for iPhone — on-device inference/context by default |
| **Q-AS-02** | Primary: privacy-conscious early adopters; secondary: developers/power users |
| **Q-AS-03** | Pricing **TBD** for first public release planning |

Full text: [G1 Product answer details](./qwon_app_store_public_readiness_intake.md#g1-product-answer-details-2026-06-07).

---

## Answer format (copy for each question)

```text
Question ID:
Approved answer:
Decision owner:
Source (meeting / email / memo / PR):
Constraints or deferrals:
```

---

## Q-AS-04 — App Store title, subtitle, primary description

| Field | Value |
| --- | --- |
| **Gate** | G2 |
| **Owner** | Product |
| **Intake status** | **Unanswered** (unchanged until follow-up PR) |

### Question

What **App Store title, subtitle, and primary description** copy are approved for the first public listing?

### Product answer (fill in)

**See [Product decision draft](#product-decision-draft--awaiting-explicit-approval)** — **draft / awaiting explicit Product approval**; intake row remains **Unanswered**.

| Field | Your answer |
| --- | --- |
| **App name / title** | QWON *(draft — awaiting explicit approval)* |
| **Subtitle** | Local-first AI on your iPhone *(draft)* |
| **Primary description** | QWON is a local-first cognitive runtime for iPhone. Keep inference and context on-device by default — not a cloud-only chat wrapper. Built for privacy-conscious users who want on-device AI assistance without default cloud dependency. *(draft)* |
| **Decision owner** | Product (draft) |
| **Source** | [Product decision draft § Q-AS-04](#product-decision-draft--awaiting-explicit-approval) |
| **Constraints** | Not approved App Store copy; not intake **Answered** |

### Suggested draft — **draft / not approved**

| Field | Draft text |
| --- | --- |
| **Title** | QWON |
| **Subtitle** | Local-first AI on your iPhone |
| **Primary description** | QWON is a local-first cognitive runtime for iPhone. Keep inference and context on-device by default — not a cloud-only chat wrapper. Built for privacy-conscious users who want on-device AI assistance without default cloud dependency. |

Product must edit, replace, or reject. **Not** approved App Store listing copy. **Not** intake **Answered** until follow-up PR.

### Unblocks

Q-AS-05, Q-AS-06, G2 sign-off

---

## Q-AS-05 — Screenshot set and device sizes

| Field | Value |
| --- | --- |
| **Gate** | G2 |
| **Owner** | Product |
| **Intake status** | **Unanswered** |

### Question

What **screenshot set and device sizes** (iPhone models, orientations) are required for the first public listing?

### Product answer (fill in)

**See [Product decision draft](#product-decision-draft--awaiting-explicit-approval)** — **draft / awaiting explicit Product approval**; intake row remains **Unanswered**.

| Field | Your answer |
| --- | --- |
| **Required device sizes** | iPhone 6.7" and 6.5" display classes *(draft — verify ASC at submission)* |
| **Orientations** | Portrait only for v1 *(draft)* |
| **Screenshot count / narrative** | 3–5 screenshots — chat/home; on-device/local; privacy/local-first value prop *(draft)* |
| **Decision owner** | Product (draft) |
| **Source** | [Product decision draft § Q-AS-05](#product-decision-draft--awaiting-explicit-approval) |
| **Constraints** | No ASC upload; not intake **Answered** |

### Suggested draft — **draft / not approved**

> **Device sizes:** iPhone 6.7" and 6.5" display classes (verify current ASC required sizes at submission time).
> **Orientation:** Portrait only for v1.
> **Set:** 3–5 screenshots — (1) chat/home, (2) on-device/local indicator or model placement note, (3) privacy/local-first value prop. No ASC upload from this worksheet.

### Unblocks

G2 sign-off

---

## Q-AS-06 — Locales for metadata and screenshots

| Field | Value |
| --- | --- |
| **Gate** | G2 |
| **Owner** | Product |
| **Intake status** | **Unanswered** |

### Question

Which **locales** are in scope for metadata and screenshots at first public launch?

### Product answer (fill in)

**See [Product decision draft](#product-decision-draft--awaiting-explicit-approval)** — **draft / awaiting explicit Product approval**; intake row remains **Unanswered**.

| Field | Your answer |
| --- | --- |
| **Primary locale(s)** | English (U.S.) — `en-US` *(draft — awaiting explicit approval)* |
| **Deferred locales** | Japanese (`ja`) and additional locales — **TBD** *(draft)* |
| **Decision owner** | Product (draft) |
| **Source** | [Product decision draft § Q-AS-06](#product-decision-draft--awaiting-explicit-approval) |
| **Constraints** | No localized asset/upload approval; not intake **Answered** |

### Suggested draft — **draft / not approved**

> **Primary:** English (U.S.) — `en-US` metadata and screenshots for first public release planning.
> **Deferred:** Japanese (`ja`) and additional locales — **TBD**; not required for initial G2 intake unless Product selects otherwise.

### Unblocks

G2 sign-off

---

## G2 completion checklist (worksheet — not gate sign-off)

| Item | Status |
| --- | --- |
| Q-AS-04 Product decision draft prepared | **Done** — [awaiting explicit approval](#product-decision-draft--awaiting-explicit-approval) |
| Q-AS-05 Product decision draft prepared | **Done** — awaiting explicit approval |
| Q-AS-06 Product decision draft prepared | **Done** — awaiting explicit approval |
| Product **explicit approval** of G2 drafts | **Approved** — 2026-06-08 |
| Follow-up docs-only PR updates intake to **Answered** | **Done** — This PR |
| Checklist gate G2 marked Closed/Ready | **No** — separate sign-off gate pending |
| Public release approved | **No** |
| Build `4` / ASC metadata upload approved | **No** |

---

## Agent note

G2 intake **Answered** (This PR). **Do not** mark checklist gate **G2 Closed/Ready** or approve public release from intake recording alone. Stay-allowed hygiene only.
