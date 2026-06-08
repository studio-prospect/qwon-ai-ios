# QWON — App Store Public Readiness Answer Intake Ledger

**Last updated:** 2026-06-08 (Stay selected — G3 intake **Q-AS-07 … Q-AS-08 Answered**; gate sign-off **Open**)
**Status:** **Intake ledger** — **24 questions · 16 Unanswered · 8 Answered**. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump not approved.**
**Purpose:** Decompose [App Store public readiness checklist](./qwon_app_store_public_readiness_checklist.md) gates **G1–G10** into **answerable questions** for Product / Legal / Release Engineering. Record answers in **separate docs-only PRs** when stakeholders supply written responses.

Related: [G3 privacy worksheet (EN)](./qwon_app_store_g3_privacy_worksheet.md) · [G3 プライバシー回答フォーム（日本語）](./qwon_app_store_g3_privacy_worksheet_ja.md) · [G2 gate sign-off worksheet](./qwon_app_store_g2_gate_signoff_worksheet.md) · [G2 metadata worksheet (EN)](./qwon_app_store_g2_metadata_worksheet.md) · [G2 メタデータフォーム（日本語）](./qwon_app_store_g2_metadata_worksheet_ja.md) · [G1 gate sign-off worksheet](./qwon_app_store_g1_gate_signoff_worksheet.md) · [G1 Product worksheet (EN)](./qwon_app_store_g1_product_worksheet.md) · [G1 Product 回答フォーム（日本語）](./qwon_app_store_g1_product_worksheet_ja.md) · [Public readiness checklist](./qwon_app_store_public_readiness_checklist.md) · [Next work queue — App Store readiness](./qwon_next_work_queue.md#app-store-public-release) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record) · [M3 gate answer intake (format reference)](./qwon_m3_gate_answer_intake.md) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

---

## How to use this ledger

| Rule | Detail |
| --- | --- |
| **Who answers** | Product, Legal, Release Engineering, Codex (planning only) — **not** implementation agents |
| **How to record an answer** | **Separate docs-only PR** after stakeholder provides written response; link PR in **Answer source** and **Follow-up PR** |
| **Do not** | Infer, draft, or commit final App Store copy, legal conclusions, privacy label answers, or release decisions without stakeholder source |
| **Answer recorded ≠ public release approved** | Updating a row to **Answered** does **not** approve App Store submission, Build `4`, or TestFlight upload |
| **Gate disposition** | **G1 Closed/Ready** ([sign-off](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) [#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)). **G2 Closed/Ready** ([sign-off](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) This PR). **G3–G10** remain **Open** or **Partial** until Product records explicit gate sign-off — separate from intake answers |
| **Agents on Stay** | May append **real** answers only when Product/Legal/RE explicitly supplies them; otherwise leave **Unanswered** |
| **External worksheets** | [G1 gate sign-off](./qwon_app_store_g1_gate_signoff_worksheet.md) — **Approved** 2026-06-08 ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)); checklist gate **G1 Closed/Ready** · [G2 gate sign-off](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) — **Approved** 2026-06-08 ([#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)); checklist gate **G2 Closed/Ready** · [G3 privacy worksheet](./qwon_app_store_g3_privacy_worksheet.md#legal-product-decision-draft--awaiting-explicit-approval) — **approved for intake recording** (This PR) · [G1 Product worksheet](./qwon_app_store_g1_product_worksheet.md) |

### Intake summary

| Metric | Value |
| --- | --- |
| **Total questions** | **24** |
| **Unanswered** | **16** |
| **Answered** | **8** |
| **Public release approved?** | **No** |
| **Stay in effect?** | **Yes** |
| **G1 intake** | **Q-AS-01 … Q-AS-03 Answered** — checklist gate **G1 Closed/Ready** |
| **G2 intake** | **Q-AS-04 … Q-AS-06 Answered** ([#134](https://github.com/studio-prospect/qwon-ai-ios/pull/134)) — checklist gate **G2 Closed/Ready** |
| **G3 intake** | **Q-AS-07 … Q-AS-08 Answered** (This PR) — checklist gate **G3 Open** (sign-off pending) |

---

## Column definitions

| Column | Meaning |
| --- | --- |
| **Question ID** | Stable ID — maps to checklist gate **G1–G10** |
| **Gate** | Checklist gate affected |
| **Owner** | Who must answer — Product / Legal / Release Engineering / Codex |
| **Question** | Answerable question text |
| **Answer status** | `Unanswered` until a real stakeholder response is linked |
| **Answer source** | Memo, email, meeting notes, PR — **—** until answered |
| **Blocks** | Other questions or gates waiting on this answer |
| **Follow-up PR** | PR that recorded the answer — **—** until exists |

---

## G1 — Product positioning / value proposition

**External share:** [G1 Product worksheet (EN)](./qwon_app_store_g1_product_worksheet.md) · [G1 Product 回答フォーム（日本語）](./qwon_app_store_g1_product_worksheet_ja.md)

**G1 intake + gate (2026-06-08):** **Q-AS-01 … Q-AS-03 Answered** ([#129](https://github.com/studio-prospect/qwon-ai-ios/pull/129)). Checklist gate **G1 Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) (This PR). **Not** public release or Build `4` approval.

| Question ID | Gate | Owner | Question | Answer status | Answer source | Blocks | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-AS-01 | G1 | Product | What is the approved **public positioning statement** (one sentence) for QWON on the App Store — local-first cognitive runtime vs generic chat assistant? | Answered | [G1 worksheet — Product decision draft § Q-AS-01](./qwon_app_store_g1_product_worksheet.md#q-as-01--public-positioning-statement) | — | This PR |
| Q-AS-02 | G1 | Product | Who is the **primary audience** for the first public App Store release (e.g. power users, privacy-conscious, developers, general consumer)? | Answered | [G1 worksheet — Product decision draft § Q-AS-02](./qwon_app_store_g1_product_worksheet.md#q-as-02--primary-audience) | — | This PR |
| Q-AS-03 | G1 | Product | What **pricing model** (free, paid, subscription, or TBD) applies to the first public release, and what is the decision rationale? | Answered | [G1 worksheet — Product decision draft § Q-AS-03](./qwon_app_store_g1_product_worksheet.md#q-as-03--pricing-model) | — | This PR |

### G1 Product answer details (2026-06-07)

**Source:** Product explicit approval of [G1 Product decision draft](./qwon_app_store_g1_product_worksheet.md#product-decision-draft--awaiting-explicit-approval) ([#128](https://github.com/studio-prospect/qwon-ai-ios/pull/128) worksheet prep; intake recorded [#129](https://github.com/studio-prospect/qwon-ai-ios/pull/129)).
**Scope (historical — #129):** Recorded **Answered** intake rows only; gate sign-off followed in [#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131) / This PR.

| Question ID | Answer |
| --- | --- |
| **Q-AS-01** | QWON is a local-first cognitive runtime for iPhone that keeps inference and context on-device by default — not a cloud-only chat wrapper. |
| **Q-AS-02** | **Primary:** privacy-conscious iPhone users and early adopters who want on-device AI assistance without default cloud dependency. **Secondary:** developers and power users evaluating local LLM workflows. |
| **Q-AS-03** | **Pricing model:** TBD for first public release planning. **Rationale:** Text-alpha validated core runtime; monetization requires separate Product decision on support cost, model distribution, and App Store category expectations. |

### G1 gate sign-off (2026-06-08)

**Source:** [G1 gate sign-off worksheet — Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) (This PR).
**Scope:** Records G1 sign-off only. Checklist gate **G1 Closed/Ready**; public release, Build `4`, TestFlight upload, tag, and version bump remain **not approved**.

---

## G2 — App Store metadata / screenshots / localization

**External share:** [G2 metadata worksheet (EN)](./qwon_app_store_g2_metadata_worksheet.md) · [G2 メタデータフォーム（日本語）](./qwon_app_store_g2_metadata_worksheet_ja.md) · [G2 gate sign-off worksheet](./qwon_app_store_g2_gate_signoff_worksheet.md)

**G2 intake + gate (2026-06-08):** **Q-AS-04 … Q-AS-06 Answered** ([#134](https://github.com/studio-prospect/qwon-ai-ios/pull/134)). Checklist gate **G2 Closed/Ready** — [sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) (This PR). **Not** public release, Build `4`, or ASC metadata upload approval.

| Question ID | Gate | Owner | Question | Answer status | Answer source | Blocks | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-AS-04 | G2 | Product | What **App Store title, subtitle, and primary description** copy are approved for the first public listing? | Answered | [G2 worksheet — Product decision draft § Q-AS-04](./qwon_app_store_g2_metadata_worksheet.md#q-as-04--app-store-title-subtitle-primary-description) | — | [#134](https://github.com/studio-prospect/qwon-ai-ios/pull/134) |
| Q-AS-05 | G2 | Product | What **screenshot set and device sizes** (iPhone models, orientations) are required for the first public listing? | Answered | [G2 worksheet — Product decision draft § Q-AS-05](./qwon_app_store_g2_metadata_worksheet.md#q-as-05--screenshot-set-and-device-sizes) | — | [#134](https://github.com/studio-prospect/qwon-ai-ios/pull/134) |
| Q-AS-06 | G2 | Product | Which **locales** are in scope for metadata and screenshots at first public launch? | Answered | [G2 worksheet — Product decision draft § Q-AS-06](./qwon_app_store_g2_metadata_worksheet.md#q-as-06--locales-for-metadata-and-screenshots) | — | [#134](https://github.com/studio-prospect/qwon-ai-ios/pull/134) |

### G2 Product answer details (2026-06-08)

**Source:** Product approval of [G2 worksheet — approved for intake recording](./qwon_app_store_g2_metadata_worksheet.md#product-decision-draft--awaiting-explicit-approval) ([#133](https://github.com/studio-prospect/qwon-ai-ios/pull/133) worksheet prep; intake recorded [#134](https://github.com/studio-prospect/qwon-ai-ios/pull/134)).
**Scope (historical — #134):** Recorded **Answered** intake rows only; gate sign-off followed in This PR ([#135](https://github.com/studio-prospect/qwon-ai-ios/pull/135) worksheet prep).

| Question ID | Answer |
| --- | --- |
| **Q-AS-04** | **Title:** QWON. **Subtitle:** Local-first AI on your iPhone. **Primary description:** QWON is a local-first cognitive runtime for iPhone. Keep inference and context on-device by default — not a cloud-only chat wrapper. Built for privacy-conscious users who want on-device AI assistance without default cloud dependency. |
| **Q-AS-05** | **Device sizes:** iPhone 6.7" and 6.5" display classes (verify current ASC required sizes at submission time). **Orientation:** Portrait only for v1. **Set:** 3–5 screenshots — (1) chat/home, (2) on-device/local indicator or model placement note, (3) privacy/local-first value prop. |
| **Q-AS-06** | **Primary:** English (U.S.) — `en-US` metadata and screenshots. **Deferred:** Japanese (`ja`) and additional locales — **TBD**. |

### G2 gate sign-off (2026-06-08)

**Source:** [G2 gate sign-off worksheet — Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) (This PR).
**Scope:** Records G2 sign-off only. Checklist gate **G2 Closed/Ready**; public release, Build `4`, TestFlight upload, tag, version bump, and ASC metadata upload remain **not approved**.

---

## G3 — Privacy nutrition labels

**External share:** [G3 privacy worksheet (EN)](./qwon_app_store_g3_privacy_worksheet.md) · [G3 プライバシー回答フォーム（日本語）](./qwon_app_store_g3_privacy_worksheet_ja.md) · [M3 network memo](./qwon_m3_network_device_expectation_memo.md)

**G3 intake (2026-06-08):** **Q-AS-07 … Q-AS-08 Answered** (This PR). Legal / Product approval recorded from [G3 worksheet — approved for intake recording](./qwon_app_store_g3_privacy_worksheet.md#legal-product-decision-draft--awaiting-explicit-approval) ([#138](https://github.com/studio-prospect/qwon-ai-ios/pull/138) worksheet prep). Checklist gate **G3** remains **Open** — gate sign-off pending. **Not** final ASC privacy label publish, public release, Build `4`, or ASC submission approval.

| Question ID | Gate | Owner | Question | Answer status | Answer source | Blocks | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-AS-07 | G3 | Legal | What **ASC privacy nutrition label** answers apply for on-device LLM inference on the current build **`3`** posture (no M3 downloader UI on TestFlight)? | Answered | [G3 worksheet — Legal/Product decision draft § Q-AS-07](./qwon_app_store_g3_privacy_worksheet.md#q-as-07--asc-privacy-nutrition-labels-build-3-posture) | — | This PR |
| Q-AS-08 | G3 | Legal | If a future **public build** includes in-app model download (M3 or successor), what privacy label changes are required vs build **`3`**? | Answered | [G3 worksheet — Legal/Product decision draft § Q-AS-08](./qwon_app_store_g3_privacy_worksheet.md#q-as-08--privacy-label-impact-of-model-download--cloud--diagnostics) | G3 sign-off; Q-AS-11 | This PR |

### G3 Legal/Product answer details (2026-06-08)

**Source:** Legal / Product approval of [G3 worksheet — approved for intake recording](./qwon_app_store_g3_privacy_worksheet.md#legal-product-decision-draft--awaiting-explicit-approval) ([#138](https://github.com/studio-prospect/qwon-ai-ios/pull/138) worksheet prep; intake recorded This PR).
**Scope (This PR):** Recorded **Answered** intake rows only; **G3 gate sign-off** and checklist **Closed/Ready** remain **pending** — separate docs-only PR. **Not** final ASC privacy label publish.

| Question ID | Answer |
| --- | --- |
| **Q-AS-07** | **Build `3` posture:** On-device LLM inference — user chat/content processed **locally** when local model available; **no in-app model HTTPS download**; M2 **Place GGUF via Mac** + USB is tester-visible path. **ASC mapping (planning):** Legal to map **User Content** (or equivalent) for on-device processing — not for third-party advertising; **no** contact info, location, browsing history, or advertising identifiers planned. **Linked to user / tracking:** **No** third-party advertising/tracking SDK on build `3` — RE/Legal verify. **Cloud-optional:** Separate disclosure if optional cloud LLM escalation exists. **Diagnostics:** Local-only runtime diagnostics; no crash-analytics SDK — RE verify. |
| **Q-AS-08** | **Future in-app download build:** User-initiated HTTPS model fetch (~400 MB class) requires **privacy label update** vs build `3` — network for **acquisition**, not per-message chat; disclose before download starts; **local-first after install** (no fully-offline claim). **Cloud optional:** Separate disclosure from local path and download acquisition if shipped. **Dependencies:** [Q-AS-11](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) model distribution policy; **release-time ASC/privacy re-check** before any download build; build `3` answers do **not** automatically transfer. |

---

## G4 — Export compliance / encryption declaration

| Question ID | Gate | Owner | Question | Answer status | Answer source | Blocks | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-AS-09 | G4 | Legal | Does **public release** require updated **export compliance / encryption declaration** vs the TestFlight build `2` attestation documented in [TestFlight prep](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate)? | Unanswered | — | Q-AS-10, G4 sign-off | — |
| Q-AS-10 | G4 | Release Engineering | Who owns **ASC export compliance sign-off** for public App Store submission, and what re-verification steps are required before submit? | Unanswered | — | G4 sign-off | — |

---

## G5 — Model distribution policy

| Question ID | Gate | Owner | Question | Answer status | Answer source | Blocks | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-AS-11 | G5 | Legal, Product | What is the approved **public model distribution policy** — Mac+USB **Place GGUF via Mac** only, in-app download, bundled weights, or a phased combination? | Unanswered | — | Q-AS-08, Q-AS-12, Q-AS-19, G5 sign-off | — |
| Q-AS-12 | G5 | Legal | What **license and redistribution constraints** (e.g. bartowski GGUF, QWON-hosted mirror) must be documented for App Review and user-facing copy? | Unanswered | — | G5 sign-off; Q-AS-19 | — |

---

## G6 — Support / website / terms / privacy policy

| Question ID | Gate | Owner | Question | Answer status | Answer source | Blocks | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-AS-13 | G6 | Product | What **public support contact** (email, URL, or in-app path) is approved for App Store listing and review? | Unanswered | — | G6 sign-off | — |
| Q-AS-14 | G6 | Legal | Where will **hosted privacy policy and terms of service** URLs live for App Review — and who owns content updates? | Unanswered | — | Q-AS-07, G6 sign-off | — |
| Q-AS-15 | G6 | Product | What **marketing or product website URL** (if any) links from the App Store listing, and is it live before submit? | Unanswered | — | G6 sign-off | — |

---

## G7 — Device lab / crash-free bar

| Question ID | Gate | Owner | Question | Answer status | Answer source | Blocks | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-AS-16 | G7 | Release Engineering | What **minimum device matrix and iOS versions** are required for public release beyond Wang + Matisse build `3` verification? | Unanswered | — | Q-AS-17, G7 sign-off | — |
| Q-AS-17 | G7 | Product, Release Engineering | What **crash-free rate or quality bar** must be met before public go-live (metric, measurement window, tooling)? | Unanswered | — | G7 sign-off | — |
| Q-AS-18 | G7 | Release Engineering | What **crash analytics or monitoring** tooling is required for public users vs internal TestFlight? | Unanswered | — | G7 sign-off | — |

---

## G8 — Known limitations / App Review notes

| Question ID | Gate | Owner | Question | Answer status | Answer source | Blocks | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-AS-19 | G8 | Product | What **tester-visible limitations** must be documented for App Review — Mac+USB GGUF placement, local-only inference, heuristic fallback, offline behavior? | Unanswered | — | Q-AS-11, G8 sign-off | — |
| Q-AS-20 | G8 | Product, Codex | What **preserved PREXUS filenames or technical debt** (e.g. `prexus-local-mvp.gguf`) must be explained in App Review notes without misleading users? | Unanswered | — | G8 sign-off | — |

---

## G9 — Release notes / versioning

| Question ID | Gate | Owner | Question | Answer status | Answer source | Blocks | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-AS-21 | G9 | Product, Release Engineering | What **marketing version and build numbering strategy** applies to the first public release beyond TestFlight **`0.1.0 (3)`**? | Unanswered | — | Q-AS-22, G9 sign-off | — |
| Q-AS-22 | G9 | Product | Which **features are in vs explicitly deferred** for the first public build (M3 downloader, UI-2, multimodal, etc.)? | Unanswered | — | Q-AS-21, G9 sign-off | — |

---

## G10 — Rollback / TestFlight fallback

| Question ID | Gate | Owner | Question | Answer status | Answer source | Blocks | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-AS-23 | G10 | Product, Release Engineering | What is the approved **rollback plan** if public release must be reversed — delist, hotfix binary, or revert to TestFlight-only? | Unanswered | — | Q-AS-24, G10 sign-off | — |
| Q-AS-24 | G10 | Release Engineering | Does TestFlight **`0.1.0 (3)`** remain the documented **internal fallback** during and after public release, and who operates that fallback? | Unanswered | — | G10 sign-off | — |

---

## Gate checklist cross-reference

| Gate | Checklist status | Intake questions | All answered? |
| --- | --- | --- | --- |
| **G1** | Closed/Ready | Q-AS-01 … Q-AS-03 | **Yes** — intake **Answered**; gate sign-off **Approved** · [worksheet](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) |
| **G2** | Closed/Ready | Q-AS-04 … Q-AS-06 | **Yes** — intake **Answered**; gate sign-off **Approved** · [worksheet](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) |
| **G3** | Open | Q-AS-07 … Q-AS-08 | **Yes** — intake **Answered** (This PR); **gate sign-off still Open** · [worksheet](./qwon_app_store_g3_privacy_worksheet.md#legal-product-decision-draft--awaiting-explicit-approval) |
| **G4** | Partial | Q-AS-09 … Q-AS-10 | **No** |
| **G5** | Open | Q-AS-11 … Q-AS-12 | **No** |
| **G6** | Open | Q-AS-13 … Q-AS-15 | **No** |
| **G7** | Partial | Q-AS-16 … Q-AS-18 | **No** |
| **G8** | Open | Q-AS-19 … Q-AS-20 | **No** |
| **G9** | Open | Q-AS-21 … Q-AS-22 | **No** |
| **G10** | Partial | Q-AS-23 … Q-AS-24 | **No** |

**Public release approved?** **No** — answering intake questions does **not** change this until Product records an explicit release gate.

---

## Agent note

This ledger is **Stay-allowed docs hygiene**. Maintain question text and links only unless Product/Legal/RE supplies answers. **G3 intake Answered** (This PR) does **not** mark checklist gate **G3 Closed/Ready** or publish ASC privacy labels. Do **not** mark **G4–G10 Closed/Ready** or approve public release from intake updates alone.
