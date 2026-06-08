# QWON — App Store Public Readiness Answer Intake Ledger

**Last updated:** 2026-06-08 (Stay selected — G5 answers prepared in worksheet, **not yet recorded**)
**Status:** **Intake ledger** — **24 questions · 14 Unanswered · 10 Answered**. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump not approved.**
**Purpose:** Decompose [App Store public readiness checklist](./qwon_app_store_public_readiness_checklist.md) gates **G1–G10** into **answerable questions** for Product / Legal / Release Engineering. Record answers in **separate docs-only PRs** when stakeholders supply written responses.

Related: [G5 model distribution worksheet (EN)](./qwon_app_store_g5_model_distribution_worksheet.md) · [G5 モデル配布ポリシー回答フォーム（日本語）](./qwon_app_store_g5_model_distribution_worksheet_ja.md) · [G4 gate sign-off worksheet](./qwon_app_store_g4_gate_signoff_worksheet.md) · [G4 export compliance worksheet (EN)](./qwon_app_store_g4_export_compliance_worksheet.md) · [G4 輸出コンプライアンス回答フォーム（日本語）](./qwon_app_store_g4_export_compliance_worksheet_ja.md) · [G3 gate sign-off worksheet](./qwon_app_store_g3_gate_signoff_worksheet.md) · [G3 privacy worksheet (EN)](./qwon_app_store_g3_privacy_worksheet.md) · [G3 プライバシー回答フォーム（日本語）](./qwon_app_store_g3_privacy_worksheet_ja.md) · [G2 gate sign-off worksheet](./qwon_app_store_g2_gate_signoff_worksheet.md) · [G2 metadata worksheet (EN)](./qwon_app_store_g2_metadata_worksheet.md) · [G2 メタデータフォーム（日本語）](./qwon_app_store_g2_metadata_worksheet_ja.md) · [G1 gate sign-off worksheet](./qwon_app_store_g1_gate_signoff_worksheet.md) · [G1 Product worksheet (EN)](./qwon_app_store_g1_product_worksheet.md) · [G1 Product 回答フォーム（日本語）](./qwon_app_store_g1_product_worksheet_ja.md) · [Public readiness checklist](./qwon_app_store_public_readiness_checklist.md) · [Next work queue — App Store readiness](./qwon_next_work_queue.md#app-store-public-release) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record) · [M3 gate answer intake (format reference)](./qwon_m3_gate_answer_intake.md) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

---

## How to use this ledger

| Rule | Detail |
| --- | --- |
| **Who answers** | Product, Legal, Release Engineering, Codex (planning only) — **not** implementation agents |
| **How to record an answer** | **Separate docs-only PR** after stakeholder provides written response; link PR in **Answer source** and **Follow-up PR** |
| **Do not** | Infer, draft, or commit final App Store copy, legal conclusions, privacy label answers, or release decisions without stakeholder source |
| **Answer recorded ≠ public release approved** | Updating a row to **Answered** does **not** approve App Store submission, Build `4`, or TestFlight upload |
| **Gate disposition** | **G1 Closed/Ready** ([sign-off](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) [#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)). **G2 Closed/Ready** ([sign-off](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) [#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)). **G3 Closed/Ready** ([sign-off](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) [#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)). **G4 Closed/Ready** ([sign-off](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) This PR). **G5–G10** remain **Open** or **Partial** until Product / Legal / RE records explicit gate sign-off — separate from intake answers |
| **Agents on Stay** | May append **real** answers only when Product/Legal/RE explicitly supplies them; otherwise leave **Unanswered** |
| **External worksheets** | [G1 gate sign-off](./qwon_app_store_g1_gate_signoff_worksheet.md) — **Approved** 2026-06-08 ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)); checklist gate **G1 Closed/Ready** · [G2 gate sign-off](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) — **Approved** 2026-06-08 ([#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)); checklist gate **G2 Closed/Ready** · [G3 gate sign-off](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) — **Approved** 2026-06-08 ([#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)); checklist gate **G3 Closed/Ready** · [G4 gate sign-off](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) — **Approved** 2026-06-08 ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)); checklist gate **G4 Closed/Ready** · [G5 model distribution worksheet](./qwon_app_store_g5_model_distribution_worksheet.md#legal-product-decision-draft--awaiting-explicit-approval) — **draft prepared** (This PR) · [G4 export compliance worksheet](./qwon_app_store_g4_export_compliance_worksheet.md#legal-re-decision-draft--awaiting-explicit-approval) — **approved for intake recording** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)) · [G1 Product worksheet](./qwon_app_store_g1_product_worksheet.md) |

### Intake summary

| Metric | Value |
| --- | --- |
| **Total questions** | **24** |
| **Unanswered** | **14** |
| **Answered** | **10** |
| **Public release approved?** | **No** |
| **Stay in effect?** | **Yes** |
| **G1 intake** | **Q-AS-01 … Q-AS-03 Answered** — checklist gate **G1 Closed/Ready** |
| **G2 intake** | **Q-AS-04 … Q-AS-06 Answered** ([#134](https://github.com/studio-prospect/qwon-ai-ios/pull/134)) — checklist gate **G2 Closed/Ready** |
| **G3 intake** | **Q-AS-07 … Q-AS-08 Answered** ([#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)) — checklist gate **G3 Closed/Ready** |
| **G4 intake** | **Q-AS-09 … Q-AS-10 Answered** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)) — checklist gate **G4 Closed/Ready** ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)) |
| **G5 worksheet** | **Legal/Product decision draft prepared** — [worksheet](./qwon_app_store_g5_model_distribution_worksheet.md#legal-product-decision-draft--awaiting-explicit-approval) · **not yet recorded** in intake (Q-AS-11…12 **Unanswered**) |

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

**External share:** [G3 privacy worksheet (EN)](./qwon_app_store_g3_privacy_worksheet.md) · [G3 プライバシー回答フォーム（日本語）](./qwon_app_store_g3_privacy_worksheet_ja.md) · [G3 gate sign-off worksheet](./qwon_app_store_g3_gate_signoff_worksheet.md) · [M3 network memo](./qwon_m3_network_device_expectation_memo.md)

**G3 intake + gate (2026-06-08):** **Q-AS-07 … Q-AS-08 Answered** ([#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)). Checklist gate **G3 Closed/Ready** — [sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) (This PR). **Not** final ASC privacy label publish, public release, Build `4`, or ASC submission approval.

| Question ID | Gate | Owner | Question | Answer status | Answer source | Blocks | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-AS-07 | G3 | Legal | What **ASC privacy nutrition label** answers apply for on-device LLM inference on the current build **`3`** posture (no M3 downloader UI on TestFlight)? | Answered | [G3 worksheet — Legal/Product decision draft § Q-AS-07](./qwon_app_store_g3_privacy_worksheet.md#q-as-07--asc-privacy-nutrition-labels-build-3-posture) | — | [#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139) |
| Q-AS-08 | G3 | Legal | If a future **public build** includes in-app model download (M3 or successor), what privacy label changes are required vs build **`3`**? | Answered | [G3 worksheet — Legal/Product decision draft § Q-AS-08](./qwon_app_store_g3_privacy_worksheet.md#q-as-08--privacy-label-impact-of-model-download--cloud--diagnostics) | Q-AS-11 | [#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139) |

### G3 Legal/Product answer details (2026-06-08)

**Source:** Legal / Product approval of [G3 worksheet — approved for intake recording](./qwon_app_store_g3_privacy_worksheet.md#legal-product-decision-draft--awaiting-explicit-approval) ([#138](https://github.com/studio-prospect/qwon-ai-ios/pull/138) worksheet prep; intake recorded [#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)).
**Scope (historical — #139):** Recorded **Answered** intake rows only; gate sign-off followed in This PR ([#140](https://github.com/studio-prospect/qwon-ai-ios/pull/140) worksheet prep).

| Question ID | Answer |
| --- | --- |
| **Q-AS-07** | **Build `3` posture:** On-device LLM inference — user chat/content processed **locally** when local model available; **no in-app model HTTPS download**; M2 **Place GGUF via Mac** + USB is tester-visible path. **ASC mapping (planning):** Legal to map **User Content** (or equivalent) for on-device processing — not for third-party advertising; **no** contact info, location, browsing history, or advertising identifiers planned. **Linked to user / tracking:** **No** third-party advertising/tracking SDK on build `3` — RE/Legal verify. **Cloud-optional:** Separate disclosure if optional cloud LLM escalation exists. **Diagnostics:** Local-only runtime diagnostics; no crash-analytics SDK — RE verify. |
| **Q-AS-08** | **Future in-app download build:** User-initiated HTTPS model fetch (~400 MB class) requires **privacy label update** vs build `3` — network for **acquisition**, not per-message chat; disclose before download starts; **local-first after install** (no fully-offline claim). **Cloud optional:** Separate disclosure from local path and download acquisition if shipped. **Dependencies:** [Q-AS-11](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) model distribution policy; **release-time ASC/privacy re-check** before any download build; build `3` answers do **not** automatically transfer. |

### G3 gate sign-off (2026-06-08)

**Source:** [G3 gate sign-off worksheet — Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) (This PR).
**Scope:** Records G3 sign-off only. Checklist gate **G3 Closed/Ready**; final ASC privacy label publish, public release, Build `4`, TestFlight upload, tag, version bump, and ASC submission remain **not approved**.

---

## G4 — Export compliance / encryption declaration

**External share:** [G4 export compliance worksheet (EN)](./qwon_app_store_g4_export_compliance_worksheet.md) · [G4 輸出コンプライアンス回答フォーム（日本語）](./qwon_app_store_g4_export_compliance_worksheet_ja.md) · [G4 gate sign-off worksheet](./qwon_app_store_g4_gate_signoff_worksheet.md) · [TestFlight prep — export compliance gate](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate)

**G4 intake + gate (2026-06-08):** **Q-AS-09 … Q-AS-10 Answered** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)). Checklist gate **G4 Closed/Ready** — [sign-off Approved](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) (This PR). **Not** export compliance final submission, public release, Build `4`, or ASC submission approval.

| Question ID | Gate | Owner | Question | Answer status | Answer source | Blocks | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-AS-09 | G4 | Legal | Does **public release** require updated **export compliance / encryption declaration** vs the TestFlight build `2` attestation documented in [TestFlight prep](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate)? | Answered | [G4 worksheet — Legal/RE decision draft § Q-AS-09](./qwon_app_store_g4_export_compliance_worksheet.md#q-as-09--export-compliance-vs-testflight-build-2-attestation) | — | [#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144) |
| Q-AS-10 | G4 | Release Engineering | Who owns **ASC export compliance sign-off** for public App Store submission, and what re-verification steps are required before submit? | Answered | [G4 worksheet — Legal/RE decision draft § Q-AS-10](./qwon_app_store_g4_export_compliance_worksheet.md#q-as-10--asc-export-compliance-sign-off-owner-and-re-verification) | — | [#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144) |

### G4 Legal/RE answer details (2026-06-08)

**Source:** Legal / RE approval of [G4 worksheet — approved for intake recording](./qwon_app_store_g4_export_compliance_worksheet.md#legal-re-decision-draft--awaiting-explicit-approval) ([#143](https://github.com/studio-prospect/qwon-ai-ios/pull/143) worksheet prep; intake recorded [#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)).
**Scope (historical — #144):** Recorded **Answered** intake rows only; gate sign-off followed in This PR ([#145](https://github.com/studio-prospect/qwon-ai-ios/pull/145) worksheet prep).

| Question ID | Answer |
| --- | --- |
| **Q-AS-09** | **Yes — updated review required:** Public App Store submit requires **updated export compliance / encryption declaration review** vs relying on TestFlight build **`2`** attestation alone. Public release ships a **public submission binary** — treat as a **new compliance event** even if encryption use matches TestFlight **`0.1.0 (3)`**. **Planning assumption:** no material encryption change vs TestFlight **`0.1.0 (3)`** for build `3` class binary — **RE/Legal verify** on public-release candidate. **Build `3` doc gap:** export compliance **not re-verified in docs** — close gap before submit; do **not** infer compliance from installability alone. **Public-release binary** may differ from TestFlight **`0.1.0 (3)`** — compliance answers must reference **submit binary**. Legal must confirm standard exemption paths (e.g. exempt encryption / HTTPS-only) and whether build `2` TestFlight answers may be reused or must be re-attested. |
| **Q-AS-10** | **Sign-off owner:** **Release Engineering** (primary) completes ASC export compliance questionnaire for the **public submission build**; **Legal** reviews and approves answers before App Store submit. **Re-verification (required even if matching build `2` attestation):** (1) Identify public-release candidate binary · (2) Verify encryption use — app binary, linked libraries (e.g. llama.cpp), HTTPS/TLS, non-exempt crypto · (3) Compare vs TestFlight build **`2`** attestation — document deltas or reuse rationale · (4) Complete ASC export compliance for **public submission build** — do **not** assume TestFlight carry-forward · (5) Record attestation audit trail (ops record, not git) · (6) **Legal sign-off** before submit. **Pre-submit checklist:** Adapt [TestFlight prep operator checklist](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) for App Store public submit — separate from internal TestFlight upload ops. |

### G4 gate sign-off (2026-06-08)

**Source:** [G4 gate sign-off worksheet — Approved](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) (This PR).
**Scope:** Records G4 sign-off only. Checklist gate **G4 Closed/Ready**; export compliance final submission, public release, Build `4`, TestFlight upload, tag, version bump, and ASC submission remain **not approved**.

---

## G5 — Model distribution policy

**External share:** [G5 model distribution worksheet (EN)](./qwon_app_store_g5_model_distribution_worksheet.md) · [G5 モデル配布ポリシー回答フォーム（日本語）](./qwon_app_store_g5_model_distribution_worksheet_ja.md) · [M3 distribution compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [M3 hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md) · [M2 guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement)

**G5 answers prepared in worksheet, not yet recorded:** [Legal/Product decision draft — awaiting explicit approval](./qwon_app_store_g5_model_distribution_worksheet.md#legal-product-decision-draft--awaiting-explicit-approval) covers **Q-AS-11 … Q-AS-12**. Intake rows below remain **Unanswered** until Legal / Product **explicit approval** and a follow-up docs-only PR. **Not** final model distribution policy approval. **Not** in-app download / M3 reopen / hosted distribution. **Not** G5 Closed/Ready.

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
| **G3** | Closed/Ready | Q-AS-07 … Q-AS-08 | **Yes** — intake **Answered**; gate sign-off **Approved** · [worksheet](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) |
| **G4** | Closed/Ready | Q-AS-09 … Q-AS-10 | **Yes** — intake **Answered**; gate sign-off **Approved** · [worksheet](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) |
| **G5** | Open | Q-AS-11 … Q-AS-12 | **No** — [worksheet draft prepared](./qwon_app_store_g5_model_distribution_worksheet.md#legal-product-decision-draft--awaiting-explicit-approval), **not recorded** in intake |
| **G6** | Open | Q-AS-13 … Q-AS-15 | **No** |
| **G7** | Partial | Q-AS-16 … Q-AS-18 | **No** |
| **G8** | Open | Q-AS-19 … Q-AS-20 | **No** |
| **G9** | Open | Q-AS-21 … Q-AS-22 | **No** |
| **G10** | Partial | Q-AS-23 … Q-AS-24 | **No** |

**Public release approved?** **No** — answering intake questions does **not** change this until Product records an explicit release gate.

---

## Agent note

This ledger is **Stay-allowed docs hygiene**. Maintain question text and links only unless Product/Legal/RE supplies answers. **G5 worksheet draft prepared** (This PR) does **not** mark intake **Answered** or **G5 Closed/Ready**. Do **not** mark **G6–G10 Closed/Ready**, reopen M3, or approve public release from worksheet updates alone.
