# QWON — App Store G2 Metadata Worksheet (External Share)

**Last updated:** 2026-06-08 (Stay selected — G2 worksheet entry; intake **Unanswered**)
**Status:** **Worksheet only** — intake rows **Q-AS-04 … Q-AS-06** remain **Unanswered** in the [intake ledger](./qwon_app_store_public_readiness_intake.md). **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump not approved.**
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

---

## Current evidence

| Field | Value |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **G1 intake** | **Q-AS-01 … Q-AS-03** — **Answered** ([#129](https://github.com/studio-prospect/qwon-ai-ios/pull/129)) |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · ASC **`6775685841`** |
| **G2 intake** | **Q-AS-04 … Q-AS-06** — **Unanswered** |
| **Checklist gate G2** | **Open** |
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

| Field | Your answer |
| --- | --- |
| **App name / title** | |
| **Subtitle** | |
| **Primary description** | |
| **Decision owner** | |
| **Source** | |
| **Constraints** | |

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

| Field | Your answer |
| --- | --- |
| **Required device sizes** | |
| **Orientations** | |
| **Screenshot count / narrative** | |
| **Decision owner** | |
| **Source** | |
| **Constraints** | |

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

| Field | Your answer |
| --- | --- |
| **Primary locale(s)** | |
| **Deferred locales** | |
| **Decision owner** | |
| **Source** | |
| **Constraints** | |

### Suggested draft — **draft / not approved**

> **Primary:** English (U.S.) — `en-US` metadata and screenshots for first public release planning.
> **Deferred:** Japanese (`ja`) and additional locales — **TBD**; not required for initial G2 intake unless Product selects otherwise.

### Unblocks

G2 sign-off

---

## G2 completion checklist (worksheet — not gate sign-off)

| Item | Status |
| --- | --- |
| Q-AS-04 Product answer written | **Pending** |
| Q-AS-05 Product answer written | **Pending** |
| Q-AS-06 Product answer written | **Pending** |
| Product **explicit approval** of G2 answers | **Pending** |
| Follow-up docs-only PR updates intake to **Answered** | **Pending** |
| Checklist gate G2 marked Closed/Ready | **No** — separate sign-off gate |
| Public release approved | **No** |
| Build `4` / ASC metadata upload approved | **No** |

---

## Agent note

Share this worksheet with Product for G2 review. **Do not** copy draft suggestions into the intake ledger as **Answered** without Product explicit approval and a follow-up docs-only PR. Stay-allowed hygiene only.
