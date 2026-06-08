# QWON — App Store G5 Model Distribution Policy Worksheet (External Share)

**Last updated:** 2026-06-08 (G5 Legal/Product **approved for intake recording** — gate sign-off **Open**)
**Status:** **Worksheet with Legal/Product decision draft — approved for intake recording** — intake rows **Q-AS-11 … Q-AS-12** are **Answered** in the [intake ledger](./qwon_app_store_public_readiness_intake.md) (This PR). **Not** final model distribution policy approval. **Not** in-app download / M3 reopen approval. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump / ASC submission not approved.**
**Purpose:** Shareable English worksheet for **Legal / Product** — G5 intake answers recorded; **G5 gate sign-off** remains **Open** (separate worksheet).

日本語版: [G5 モデル配布ポリシー回答フォーム（日本語）](./qwon_app_store_g5_model_distribution_worksheet_ja.md)

Related: [Intake ledger — G5](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) · [Checklist — G5](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [M3 distribution compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [M3 hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md) · [M2 guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement) · [M3 spike outcome — Option A](./qwon_m3_spike_outcome_decision.md#decision-record) · [G3 privacy worksheet](./qwon_app_store_g3_privacy_worksheet.md) · [G4 gate sign-off](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## Explicit boundaries (read first)

| Boundary | Meaning |
| --- | --- |
| **G5 worksheet ≠ model distribution policy final approval** | Filling this worksheet does **not** approve public model distribution policy or App Store go-live posture |
| **G5 worksheet ≠ in-app download / M3 reopen** | Worksheet maintenance does **not** enable M3 in-app download, lift M3 lane closure, or approve Build `4` |
| **G5 worksheet ≠ bundled weights approval** | No approval to ship GGUF inside the App Store binary without separate Product / Legal gate |
| **G5 worksheet ≠ public release approval** | Worksheet maintenance does **not** approve App Store public listing or go-live |
| **G5 worksheet ≠ ASC submission** | No App Store Connect upload, hosting ops, or submission from this doc |
| **Stay selected** | Worksheet maintenance does **not** lift Stay or authorize implementation |
| **No product/code changes** | **No** app code, download UX, hosting pipeline, or model bundling changes from this doc |
| **Draft suggestions** | Superseded by [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval) — historical suggested drafts below |
| **Recording answers** | Legal / Product **approved for intake recording** 2026-06-08 — intake **Answered** (This PR); **G5 gate sign-off** still **Open** |

---

<a id="legal-product-decision-draft--awaiting-explicit-approval"></a>

## Legal / Product decision draft — **approved for intake recording**

**Label:** **Legal/Product decision draft — approved for intake recording (2026-06-08)** — recorded in [intake ledger — G5 answer details](./qwon_app_store_public_readiness_intake.md#g5-legalproduct-answer-details-2026-06-08) (This PR; worksheet prep [#148](https://github.com/studio-prospect/qwon-ai-ios/pull/148)). **Not** G5 Closed/Ready. **Not** final model distribution policy, in-app download, hosted distribution, bundled weights, public release, or Build `4` approval.

| Field | Value |
| --- | --- |
| **Prepared** | 2026-06-08 — docs-only hygiene under Stay ([#147](https://github.com/studio-prospect/qwon-ai-ios/pull/147); decision draft [#148](https://github.com/studio-prospect/qwon-ai-ios/pull/148)) |
| **Intake ledger** | **Q-AS-11 … Q-AS-12 Answered** (This PR) |
| **Next step** | **G5 gate sign-off worksheet preparation** → on Legal / Product approval, separate docs-only PR sets checklist gate **G5 Closed/Ready** |

### Q-AS-11 — Public model distribution policy

| Field | Legal/Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-11 |
| **Draft answer** | **First public-readiness planning recommends Mac+USB Place GGUF via Mac only (Option A)** — aligned with TestFlight **`0.1.0 (3)`** and M2 guided placement. **In-app download, bundled weights, and phased combination are deferred** until explicit Product / Legal gates. |
| **Mac+USB Place GGUF via Mac (draft)** | **Interim recommended posture** for public-readiness planning — user obtains `prexus-local-mvp.gguf` via Mac ops + USB; app binary does **not** redistribute weights. |
| **In-app download (draft)** | **Deferred** — M3 remains **Option A / compile-gated default-off / lane closed**; reopening M3 or enabling download UX requires separate Product gate. |
| **Bundled weights (draft)** | **Deferred** — build `3` class binary ships **without** GGUF in IPA; embedding weights requires separate Legal / RE review. |
| **Phased combination (draft)** | **Deferred** — if pursued later, Product must define phase boundaries and keep **Place GGUF via Mac** fallback visible per [M3 rollback memo](./qwon_m3_rollback_release_gate_memo.md). |
| **M3 posture (draft)** | **Unchanged** — Option A selected; spike complete; **not** M3 reopen or default-on from this draft. |
| **Build `3` alignment (draft)** | Consistent with tester-visible M2 path on **`0.1.0 (3)`** — **not** Build `4` or public release approval. |
| **Decision owner** | Legal / Product (**approved for intake recording** — 2026-06-08) |
| **Source** | Elaborated from [suggested draft § Q-AS-11](#q-as-11--public-model-distribution-policy); [M3 spike outcome](./qwon_m3_spike_outcome_decision.md#decision-record) |
| **Constraints** | **Not** in-app download / hosted distribution / bundled weights **approved**; **not** G5 Closed/Ready |

### Q-AS-12 — License and redistribution constraints

| Field | Legal/Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-12 |
| **Draft answer** | **Legal must confirm** license and redistribution posture for **Qwen base model**, **bartowski GGUF quant**, and any **QWON-hosted mirror** before public release copy is finalized. Planning draft organizes App Review / user-facing direction around **user-managed side data** and **third-party model attribution / notices** — **not** a final Legal conclusion. |
| **Qwen base model (draft)** | [Qwen2.5-0.5B-Instruct](https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct) — HF metadata cites **Apache-2.0**; Legal confirms attribution, mobile on-device use, and notice requirements. |
| **bartowski GGUF (draft)** | Community repack [Q4_K_M artifact](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF) — **third-party repack**; end-user redistribution rights via QWON app or servers **unconfirmed** · [M3 Gate 3 memo](./qwon_m3_model_distribution_compliance_memo.md) |
| **QWON-hosted mirror (draft)** | Discussed in M3 spike planning — **not approved** for public release; Legal review required if pursued · [M3 hosting memo](./qwon_m3_model_hosting_checksum_memo.md) |
| **App Review narrative (draft)** | **User-managed side data** — optional on-device ML asset; model file not bundled in IPA when Option A applies; QWON does not redistribute weights in app binary under Mac+USB-only posture. |
| **User-facing copy (draft)** | Disclose user-provided / separately acquired compatible GGUF; plan **third-party model attribution / notices**; do **not** claim official Qwen / bartowski endorsement without Legal review. |
| **Hosted distribution (draft)** | In-app download or QWON-hosted mirror makes QWON a **distribution channel** — **not approved** by this draft; separate Legal gate. |
| **Decision owner** | Legal (**approved for intake recording** — 2026-06-08) |
| **Source** | Elaborated from [suggested draft § Q-AS-12](#q-as-12--license-and-redistribution-constraints) |
| **Constraints** | **Not** final Legal conclusion; **not** hosted distribution **approved**; **not** G5 Closed/Ready |

---

## Current evidence

| Field | Value |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **Checklist gate G2** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) ([#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)) |
| **Checklist gate G3** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) ([#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)) |
| **Checklist gate G4** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)) |
| **Intake ledger total** | **24 questions · 12 Unanswered · 12 Answered** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · ASC **`6775685841`** · **GGUF not bundled** in shipped binary |
| **M3 posture** | **Option A selected** — compile-gated **default-off**; M3 lane **closed** · [decision record](./qwon_m3_spike_outcome_decision.md#decision-record) |
| **Tester-visible model path** | M2 **Place GGUF via Mac** + USB — [guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement); app does **not** download GGUF in-app on build `3` |
| **G5 intake** | **Q-AS-11 … Q-AS-12 Answered** (This PR) |
| **Checklist gate G5** | **Open** — gate sign-off pending |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |

### G1–G4 + M3 inputs for G5 (reference)

| Source | Summary |
| --- | --- |
| **G1 Q-AS-01** | Local-first cognitive runtime — on-device inference by default |
| **G3 Q-AS-07** | Build `3`: on-device LLM inference; no in-app model HTTPS download on TestFlight |
| **G3 Q-AS-08** | Future in-app download build requires privacy label update — depends on [Q-AS-11](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) |
| **G4 Q-AS-09 … Q-AS-10** | Public submit needs updated export compliance review; RE/Legal re-verification on candidate binary |
| **M3 compliance memo** | M3 in-app download makes QWON a **distribution channel** for third-party weights — license / redistribution review required · [Gate 3 memo](./qwon_m3_model_distribution_compliance_memo.md) |
| **M3 hosting memo** | Ops default: bartowski Qwen2.5 Q4_K_M GGUF; QWON-hosted mirror discussed for M3 spike — **not** approved public hosting URL · [hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md) |
| **M3 Option A** | Spike complete; M2 **Place GGUF via Mac** remains official acquisition path — **not** M3 default-on |

---

## Answer format (copy for each question)

```text
Question ID:
Approved answer:
Decision owner:
Source (meeting / email / memo / PR):
App Review / user-facing copy notes (if applicable):
Constraints or deferrals:
```

---

<a id="q-as-11--public-model-distribution-policy"></a>

## Q-AS-11 — Public model distribution policy

| Field | Value |
| --- | --- |
| **Gate** | G5 |
| **Owner** | Legal, Product |
| **Intake status** | **Answered** (This PR) |

### Question

What is the approved **public model distribution policy** — Mac+USB **Place GGUF via Mac** only, in-app download, bundled weights, or a phased combination?

### Legal / Product answer (fill in)

**See [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval)** — intake **Answered** (This PR); **G5 gate sign-off** still **Open**.

| Field | Your answer |
| --- | --- |
| **Approved answer** | **Mac+USB Place GGUF via Mac only (Option A)** for first public-readiness planning — in-app download, bundled weights, phased combination **deferred**. *(approved for intake recording)* |
| **First public release posture** | Option A interim recommendation — aligned with TestFlight **`0.1.0 (3)`**. *(approved for intake recording)* |
| **Mac+USB Place GGUF via Mac** | **Interim recommended** — M2 guided placement + USB; app does not redistribute weights. *(approved for intake recording)* |
| **In-app download (M3 or successor)** | **Deferred** — M3 Option A / default-off / lane closed unchanged. *(approved for intake recording)* |
| **Bundled weights in App Store binary** | **Deferred** — separate Legal / RE review if pursued. *(approved for intake recording)* |
| **Phased combination (if any)** | **Deferred** — phase boundaries TBD if Product scopes later. *(approved for intake recording)* |
| **Build `3` baseline alignment** | Consistent with M2 path on **`0.1.0 (3)`** — **not** Build `4` approval. *(approved for intake recording)* |
| **Decision owner** | Legal / Product (approved for intake recording) |
| **Source** | [Intake ledger — G5 answer details](./qwon_app_store_public_readiness_intake.md#g5-legalproduct-answer-details-2026-06-08) |
| **Constraints** | Not final policy approval; not G5 Closed/Ready |

### Suggested draft — **superseded (historical)**

> *Superseded by [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval) — retained for traceability.*

> **Public model distribution policy (planning draft):**
>
> **Policy options to decide (not approved):**
>
> | Option | Description | Build `3` / TestFlight today | Public-release planning notes (draft) |
> | --- | --- | --- | --- |
> | **A. Mac+USB Place GGUF via Mac only** | User obtains `prexus-local-mvp.gguf` via Mac ops + USB; M2 guided placement in Settings | **Yes** — tester-visible path on **`0.1.0 (3)`** | Aligns with current alpha; App Review narrative: optional on-device ML asset, user-managed side data, **not bundled in IPA** |
> | **B. In-app download** | App initiates HTTPS fetch into sandbox (`Documents/Models/…`) | **No** on build `3`; M3 spike **Option A / default-off / lane closed** | Requires separate Product gate to reopen M3; triggers [G3 Q-AS-08](./qwon_app_store_public_readiness_intake.md#g3--privacy-nutrition-labels), [G4 export compliance re-check](./qwon_app_store_public_readiness_intake.md#g4--export-compliance--encryption-declaration), hosting + checksum policy · [M3 memos](./qwon_m3_model_distribution_compliance_memo.md) |
> | **C. Bundled weights** | Ship GGUF inside App Store binary | **No** — build `3` ships without GGUF | Large IPA size, update cadence, license redistribution in binary — **separate Legal / RE review** |
> | **D. Phased combination** | e.g. Phase 1 external placement only → later in-app download or bundled tier | Partial today (A only) | Product must define **phase boundaries**, fallback (keep **Place GGUF via Mac** visible per [M3 rollback memo](./qwon_m3_rollback_release_gate_memo.md)), and release-time re-check gates |
>
> **Planning draft answer (hypothesis — not approved):** **Phase 1 public-readiness planning assumes Option A (Mac+USB Place GGUF via Mac only)** consistent with TestFlight **`0.1.0 (3)`** — **in-app download and bundled weights deferred** until explicit Product / Legal gates. Product / Legal must confirm or replace.
>
> **Not** M3 reopen. **Not** Build `4`. **Not** public release approval.

Legal / Product must edit, replace, or reject. **Not** final model distribution policy.

### Unblocks

Q-AS-12, Q-AS-19 (partial), G5 sign-off

---

<a id="q-as-12--license-and-redistribution-constraints"></a>

## Q-AS-12 — License and redistribution constraints

| Field | Value |
| --- | --- |
| **Gate** | G5 |
| **Owner** | Legal |
| **Intake status** | **Answered** (This PR) |

### Question

What **license and redistribution constraints** (e.g. bartowski GGUF, QWON-hosted mirror) must be documented for App Review and user-facing copy?

### Legal answer (fill in)

**See [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval)** — intake **Answered** (This PR); **G5 gate sign-off** still **Open**.

| Field | Your answer |
| --- | --- |
| **Approved answer** | Legal must confirm Qwen / bartowski / QWON-hosted mirror license + redistribution; planning draft: **user-managed side data** + **third-party model attribution / notices**. *(approved for intake recording)* |
| **Qwen base model license posture** | Apache-2.0 cited on HF — Legal confirms attribution and notices. *(approved for intake recording)* |
| **bartowski GGUF redistribution** | Third-party repack — redistribution rights **unconfirmed**; Legal review required. *(approved for intake recording)* |
| **QWON-hosted mirror (if any)** | **Not approved** for public release in draft; Legal review if pursued. *(approved for intake recording)* |
| **Attribution / notices required** | Plan third-party model attribution / notices — Legal to finalize. *(approved for intake recording)* |
| **App Review narrative** | User-managed side data; optional on-device ML asset not bundled in IPA (Option A). *(approved for intake recording)* |
| **User-facing copy constraints** | Disclose separately acquired GGUF; no official Qwen/bartowski endorsement without Legal review. *(approved for intake recording)* |
| **Decision owner** | Legal (approved for intake recording) |
| **Source** | [Intake ledger — G5 answer details](./qwon_app_store_public_readiness_intake.md#g5-legalproduct-answer-details-2026-06-08) |
| **Constraints** | Not final Legal conclusion; not hosted distribution approved |

### Suggested draft — **superseded (historical)**

> *Superseded by [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval) — retained for traceability.*

> **License / redistribution constraints (planning draft):**
>
> **Artifact stack (research summary — needs Legal confirmation):**
>
> | Layer | Source | Primary links | Draft constraint notes |
> | --- | --- | --- | --- |
> | **Qwen base model** | Qwen2.5-0.5B-Instruct | [Model card](https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct) · [LICENSE](https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct/blob/main/LICENSE) | HF metadata cites **Apache-2.0** — Legal must confirm attribution, mobile on-device use, and any notice requirements for public release copy |
> | **bartowski GGUF quant** | Community repack `Qwen2.5-0.5B-Instruct-Q4_K_M.gguf` | [bartowski model card](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF) · [Q4_K_M artifact](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF/blob/main/Qwen2.5-0.5B-Instruct-Q4_K_M.gguf) | **Third-party repack** — rights to **redistribute this file to end users** via QWON app, QWON servers, or embedded URLs **unconfirmed** · [M3 Gate 3 memo](./qwon_m3_model_distribution_compliance_memo.md) |
> | **Dev ops fetch URL** | `fetch_local_model.sh` default | [HF resolve URL](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/Qwen2.5-0.5B-Instruct-Q4_K_M.gguf) | **Developer convenience only** — **not** approved product hosting URL |
> | **QWON-hosted mirror** | Discussed for M3 spike planning | [M3 hosting memo — Gate 1](./qwon_m3_model_hosting_checksum_memo.md#gate-1--model-hosting-source--url-ownership) | QWON-hosted mirror of bartowski artifact **not approved** for public release — requires Gate 1/2/3 sign-off stack if pursued |
>
> **Distribution path implications (draft):**
> - **Mac+USB only (Option A):** Treat GGUF as **user-managed side data** — QWON app binary does not redistribute weights; still may need **user-facing guidance** on obtaining compatible GGUF and upstream license awareness.
> - **In-app download / QWON-hosted mirror:** QWON becomes a **distribution channel** — Legal must approve redistribution, hosting ToS, checksum publication, and App Review narrative (**optional ML asset**, not embedded in binary).
> - **Bundled weights:** Strongest redistribution event — separate license review for embedding in IPA.
>
> **App Review / user-facing copy (draft checklist — not approved):**
> - Disclose that local LLM requires user-provided or separately acquired model file when not bundled.
> - Do **not** claim official Qwen / bartowski endorsement without Legal review.
> - Plan attribution / third-party notices section if redistribution is approved.
> - Align with [G8 Q-AS-19](./qwon_app_store_public_readiness_intake.md#g8--known-limitations--app-review-notes) tester-visible limitations once [Q-AS-11](#q-as-11--public-model-distribution-policy) is decided.
>
> **Not** final Legal conclusion. **Not** approved hosting URL. **Not** M3 implementation.

Legal must edit, replace, or reject. **Not** final license sign-off.

### Unblocks

G5 sign-off; informs Q-AS-19

---

## G5 completion checklist (worksheet — not gate sign-off)

| Item | Status |
| --- | --- |
| Q-AS-11 Legal/Product decision draft prepared | **Done** — [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval) |
| Q-AS-12 Legal/Product decision draft prepared | **Done** — approved for intake recording |
| Legal / Product **approved for intake recording** | **Done** — 2026-06-08 (This PR) |
| Follow-up docs-only PR updates intake to **Answered** | **Done** — This PR |
| **G5 gate sign-off worksheet** preparation | **Next** |
| Checklist gate G5 marked Closed/Ready | **No** — separate sign-off gate |
| In-app download / M3 reopen / hosted distribution approved | **No** |
| Public release approved | **No** |
| Build `4` / TestFlight upload / ASC submission approved | **No** |

---

## Agent note

Share with **Legal / Product** for **G5 gate sign-off**. **Do not** mark **G5 Closed/Ready**, reopen M3, or approve in-app download / hosted distribution from intake recording alone. Stay-allowed hygiene only.
