# QWON — App Store G5 Model Distribution Policy Worksheet (External Share)

**Last updated:** 2026-06-08 (Stay selected — G5 worksheet added; intake **Unanswered**)
**Status:** **Worksheet only** — intake rows **Q-AS-11 … Q-AS-12** remain **Unanswered** in the [intake ledger](./qwon_app_store_public_readiness_intake.md). **Not** final model distribution policy approval. **Not** in-app download / M3 reopen approval. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump / ASC submission not approved.**
**Purpose:** Shareable English worksheet for **Legal / Product** to answer **G5 — Model distribution policy** before answers are recorded in the intake ledger via a separate docs-only PR.

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
| **Draft suggestions** | Blocks marked **draft / not approved** — Legal / Product must replace or reject before intake recording |
| **Recording answers** | After Legal / Product **explicit approval**, open a **separate docs-only PR** to set intake rows to **Answered** |

---

## Current evidence

| Field | Value |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **Checklist gate G2** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) ([#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)) |
| **Checklist gate G3** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) ([#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)) |
| **Checklist gate G4** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)) |
| **Intake ledger total** | **24 questions · 14 Unanswered · 10 Answered** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · ASC **`6775685841`** · **GGUF not bundled** in shipped binary |
| **M3 posture** | **Option A selected** — compile-gated **default-off**; M3 lane **closed** · [decision record](./qwon_m3_spike_outcome_decision.md#decision-record) |
| **Tester-visible model path** | M2 **Place GGUF via Mac** + USB — [guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement); app does **not** download GGUF in-app on build `3` |
| **G5 intake** | **Q-AS-11 … Q-AS-12** — **Unanswered** |
| **Checklist gate G5** | **Open** |
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
| **Intake status** | **Unanswered** (unchanged until follow-up PR) |

### Question

What is the approved **public model distribution policy** — Mac+USB **Place GGUF via Mac** only, in-app download, bundled weights, or a phased combination?

### Legal / Product answer (fill in)

| Field | Your answer |
| --- | --- |
| **Approved answer** | |
| **First public release posture** | |
| **Mac+USB Place GGUF via Mac** | |
| **In-app download (M3 or successor)** | |
| **Bundled weights in App Store binary** | |
| **Phased combination (if any)** | |
| **Build `3` baseline alignment** | |
| **Decision owner** | Legal / Product |
| **Source** | |
| **Constraints** | Not final policy approval; not intake **Answered** until follow-up PR |

### Suggested draft — **draft / not approved**

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
| **Intake status** | **Unanswered** |

### Question

What **license and redistribution constraints** (e.g. bartowski GGUF, QWON-hosted mirror) must be documented for App Review and user-facing copy?

### Legal answer (fill in)

| Field | Your answer |
| --- | --- |
| **Approved answer** | |
| **Qwen base model license posture** | |
| **bartowski GGUF redistribution** | |
| **QWON-hosted mirror (if any)** | |
| **Attribution / notices required** | |
| **App Review narrative** | |
| **User-facing copy constraints** | |
| **Decision owner** | Legal |
| **Source** | |
| **Constraints** | Not final Legal conclusion; not ASC submission |

### Suggested draft — **draft / not approved**

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
| Q-AS-11 worksheet draft prepared | **Done** — [suggested draft § Q-AS-11](#q-as-11--public-model-distribution-policy) |
| Q-AS-12 worksheet draft prepared | **Done** — [suggested draft § Q-AS-12](#q-as-12--license-and-redistribution-constraints) |
| Legal / Product **explicit approval** of G5 answers | **Pending** |
| Follow-up docs-only PR updates intake to **Answered** | **Pending** |
| Checklist gate G5 marked Closed/Ready | **No** — separate sign-off gate |
| In-app download / M3 reopen approved | **No** |
| Public release approved | **No** |
| Build `4` / TestFlight upload / ASC submission approved | **No** |

---

## Agent note

Share with **Legal / Product** for review and answer preparation. **Do not** copy suggested drafts into the intake ledger as **Answered**, reopen M3, or approve in-app download until stakeholders confirm and a follow-up docs-only PR records them. Stay-allowed hygiene only.
