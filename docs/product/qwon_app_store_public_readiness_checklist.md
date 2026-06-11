# QWON — App Store Public Release Readiness Checklist

**Last updated:** 2026-06-08 (Stay selected — G5 gate sign-off worksheet added; gate **Open**)
**Status:** **Docs-only** — **Stay selected**. **App Store public release not approved.** **Build `4` not approved.** **TestFlight upload / tag / version bump not approved.**
**Purpose:** While **Stay** remains in effect, make **open Product/Legal/RE decisions** visible for a future move from TestFlight **`0.1.0 (3)`** stable alpha to **public App Store availability**. This checklist does **not** authorize implementation, release engineering, App Store submission, or Build `4`.

Related: [Answer intake ledger](./qwon_app_store_public_readiness_intake.md) · [G5 gate sign-off worksheet](./qwon_app_store_g5_gate_signoff_worksheet.md) · [G5 model distribution worksheet](./qwon_app_store_g5_model_distribution_worksheet.md) · [G5 モデル配布ポリシー回答フォーム（日本語）](./qwon_app_store_g5_model_distribution_worksheet_ja.md) · [G4 gate sign-off worksheet](./qwon_app_store_g4_gate_signoff_worksheet.md) · [G4 export compliance worksheet](./qwon_app_store_g4_export_compliance_worksheet.md) · [G4 輸出コンプライアンス回答フォーム（日本語）](./qwon_app_store_g4_export_compliance_worksheet_ja.md) · [G3 gate sign-off worksheet](./qwon_app_store_g3_gate_signoff_worksheet.md) · [G3 privacy worksheet](./qwon_app_store_g3_privacy_worksheet.md) · [G3 プライバシー回答フォーム（日本語）](./qwon_app_store_g3_privacy_worksheet_ja.md) · [G2 gate sign-off worksheet](./qwon_app_store_g2_gate_signoff_worksheet.md) · [G2 metadata worksheet](./qwon_app_store_g2_metadata_worksheet.md) · [G2 メタデータフォーム（日本語）](./qwon_app_store_g2_metadata_worksheet_ja.md) · [G1 gate sign-off worksheet](./qwon_app_store_g1_gate_signoff_worksheet.md) · [G1 Product worksheet](./qwon_app_store_g1_product_worksheet.md) · [G1 回答フォーム（日本語）](./qwon_app_store_g1_product_worksheet_ja.md) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record) · [Next work queue](./qwon_next_work_queue.md#app-store-public-release) · [Post-alpha option — App Store readiness](./qwon_post_alpha_options.md#5-public--app-store-readiness) · [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) · [QWON bundle memo](./qwon_bundle_id_decision_memo.md) · [M3 distribution compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

---

## 1. Status

| Field | Value |
| --- | --- |
| **Work type** | **Docs-only** — checklist and gap visibility; no code or ASC ops from this doc |
| **Product posture** | **Stay selected** — [decision record](./qwon_post_m3_next_lane_decision.md#decision-record) |
| **App Store public release** | **Not approved** |
| **Build `4`** | **Not approved** |
| **TestFlight upload / tag / version bump** | **Not approved** |
| **Implementation authorization** | **None** — lifting Stay + explicit public-release gate required before any lane opens |

---

## 2. Current baseline

| Field | Value |
| --- | --- |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — **stable alpha** |
| **Bundle ID** | **`jp.studio-prospect.qwon.ios`** |
| **ASC Apple ID** | **`6775685841`** (QWON line — not historical PREXUS **`6775110218`**) |
| **Feedback intake** | **Closed** — **QWON-FB-001**, **QWON-FB-002** operational pass; **no blockers** |
| **M3 model download spike** | **Option A selected** — compile-gated **default-off**; M3 lane **closed** · [decision record](./qwon_m3_spike_outcome_decision.md#decision-record) |
| **Tester-visible model acquisition** | M2 **Place GGUF via Mac** + USB ops — unchanged on TestFlight **`0.1.0 (3)`** |
| **Historical PREXUS alpha** | Frozen — [PREXUS alpha index](./qwen_text_only_alpha_docs_index.md); **do not** conflate with QWON public release |

**Distinction:** Public release readiness is a **long-term product horizon** gate. It is **separate** from the internal **Build `4` / TestFlight binary** decision documented in [TestFlight prep — build `4` gate](./qwon_text_alpha_testflight_prep.md#phase-4-build-3-decision-gate).

---

## 3. Public readiness gates

Each row is an **open decision or artifact** until Product/Legal/RE records completion. Status **Open** = not decided or not documented for public release. **Answerable questions:** [App Store readiness intake ledger](./qwon_app_store_public_readiness_intake.md) — **12 Unanswered · 12 Answered** (G1 + G2 + G3 + G4 gates **Closed/Ready**; G5 intake **Answered**, gate sign-off **Pending** — This PR).

| # | Gate | Status | Notes / first doc |
| --- | --- | --- | --- |
| **G1** | **Product positioning / value proposition** | **Closed/Ready** | Intake **Q-AS-01 … Q-AS-03 Answered** · [G1 sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) (This PR) · [intake G1](./qwon_app_store_public_readiness_intake.md#g1--product-positioning--value-proposition) |
| **G2** | **App Store metadata and screenshots** | **Closed/Ready** | Intake **Q-AS-04 … Q-AS-06 Answered** · [G2 sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) (This PR) · [intake G2](./qwon_app_store_public_readiness_intake.md#g2--app-store-metadata--screenshots--localization) |
| **G3** | **Privacy nutrition labels** | **Closed/Ready** | Intake **Q-AS-07 … Q-AS-08 Answered** · [G3 sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) (This PR) · [intake G3](./qwon_app_store_public_readiness_intake.md#g3--privacy-nutrition-labels) · **Not** final ASC privacy label publish / public release / Build `4` |
| **G4** | **Export compliance / encryption declaration** | **Closed/Ready** | Intake **Q-AS-09 … Q-AS-10 Answered** · [G4 sign-off Approved](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) (This PR) · [intake G4](./qwon_app_store_public_readiness_intake.md#g4--export-compliance--encryption-declaration) · **Not** export compliance final submission / public release / Build `4` |
| **G5** | **Model distribution policy** | **Open** | Intake **Q-AS-11 … Q-AS-12 Answered** ([#149](https://github.com/studio-prospect/qwon-ai-ios/pull/149)) · [G5 gate sign-off worksheet](./qwon_app_store_g5_gate_signoff_worksheet.md#sign-off-record-legal-product) **Pending** · [intake G5](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) · [G5 model distribution worksheet](./qwon_app_store_g5_model_distribution_worksheet.md) · [日本語フォーム](./qwon_app_store_g5_model_distribution_worksheet_ja.md) · [M3 Gate 3 memo](./qwon_m3_model_distribution_compliance_memo.md) · [M3 hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md) · **Not** in-app download / M3 reopen / hosted distribution / bundled weights / public release / Build `4` |
| **G6** | **Support contact / website / terms / privacy policy** | **Open** | [Q-AS-13 … Q-AS-15](./qwon_app_store_public_readiness_intake.md#g6--support--website--terms--privacy-policy) |
| **G7** | **Crash-free / device lab expectations** | **Partial** | [Q-AS-16 … Q-AS-18](./qwon_app_store_public_readiness_intake.md#g7--device-lab--crash-free-bar) · [lab evidence](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03) |
| **G8** | **Known limitations and App Review notes** | **Open** | [Q-AS-19 … Q-AS-20](./qwon_app_store_public_readiness_intake.md#g8--known-limitations--app-review-notes) |
| **G9** | **Release notes and versioning** | **Open** | [Q-AS-21 … Q-AS-22](./qwon_app_store_public_readiness_intake.md#g9--release-notes--versioning) |
| **G10** | **Rollback / TestFlight fallback** | **Partial** | [Q-AS-23 … Q-AS-24](./qwon_app_store_public_readiness_intake.md#g10--rollback--testflight-fallback) · [rollback memo](./qwon_m3_rollback_release_gate_memo.md) |

**Review owners:** Product (G1, G2, G8, G9), Legal (G3, G4, G5, G6), Release engineering (G4, G7, G10).

---

## 4. Explicit non-goals (this checklist)

| Do not do | Why |
| --- | --- |
| **App Store submission** or public listing go-live | **Public release not approved** |
| **Build `4`**, TestFlight upload, tag, or **`CFBundleVersion` bump** | Separate RE gate — [TestFlight prep](./qwon_text_alpha_testflight_prep.md) |
| **Swift / app / tools / pbxproj changes** from this checklist | Docs-only surface |
| **M3 default-on** or M3 lane reopen without Product gate | Option A — compile-gated default-off |
| **GGUF / IPA / logs / screenshots commit to git** | Ops storage only |
| **PREXUS historical rewrite** (`qwen_text_only_alpha_*`, frozen ledger rows) | Immutable baseline |
| **Conflate public release with Build `4`** | Internal TestFlight binary ≠ App Store availability |

---

## 5. Decision record

| Field | Value |
| --- | --- |
| **Public release approved?** | **No** |
| **Stay in effect?** | **Yes** — [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record) |
| **Next action** | **Product / Legal / RE review only** — **G5 sign-off decision** · [G5 gate sign-off worksheet](./qwon_app_store_g5_gate_signoff_worksheet.md#sign-off-record-legal-product) · [intake G5](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) (**12 Unanswered**) · **no** implementation or submission |
| **To open implementation** | Product **lifts Stay**, selects **App Store public release readiness** (or combined horizon gate), records approval in this section, then Codex scoped plan → Cursor — **still no** upload/submission without explicit release gate |

**Checklist created:** 2026-06-07 — Stay-allowed docs hygiene; does not change Product posture.

---

## Agent note

This document is the **entry checklist** for [Post-alpha option §5 — Public / App Store readiness](./qwon_post_alpha_options.md#5-public--app-store-readiness). Answerable questions live in the [App Store readiness intake ledger](./qwon_app_store_public_readiness_intake.md). Agents on **Stay** may maintain this checklist and intake (gap updates, links, answer append) under [Ready / low-risk docs-ops](./qwon_next_work_queue.md#ready--low-risk-docs-ops). Do **not** treat checklist or intake maintenance as public-release or Build `4` approval.
