# QWON — App Store G4 Export Compliance Worksheet (External Share)

**Last updated:** 2026-06-08 (G4 Legal/RE decision draft prepared — intake **Unanswered**)
**Status:** **Worksheet with Legal/RE decision draft / awaiting explicit approval** — intake rows **Q-AS-09 … Q-AS-10** remain **Unanswered** in the [intake ledger](./qwon_app_store_public_readiness_intake.md). **Not** export compliance final submission. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump / ASC submission not approved.**
**Purpose:** Shareable English worksheet for **Legal / Release Engineering** to answer **G4 — Export compliance / encryption declaration** before answers are recorded in the intake ledger via a separate docs-only PR.

日本語版: [G4 輸出コンプライアンス回答フォーム（日本語）](./qwon_app_store_g4_export_compliance_worksheet_ja.md)

Related: [Intake ledger — G4](./qwon_app_store_public_readiness_intake.md#g4--export-compliance--encryption-declaration) · [Checklist — G4](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [TestFlight prep — export compliance gate](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) · [M3 distribution compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [G3 gate sign-off](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## Explicit boundaries (read first)

| Boundary | Meaning |
| --- | --- |
| **G4 worksheet ≠ export compliance final submission** | Filling this worksheet does **not** submit ASC export compliance / encryption answers or complete App Store Connect compliance ops |
| **G4 worksheet ≠ public release approval** | Worksheet maintenance does **not** approve App Store public listing or go-live |
| **G4 worksheet ≠ Build `4` approval** | No TestFlight upload, tag, or **`CFBundleVersion` bump** |
| **G4 worksheet ≠ ASC submission** | No App Store Connect upload, export compliance publish, or submission ops from this doc |
| **Stay selected** | Worksheet maintenance does **not** lift Stay or authorize implementation |
| **No product/code changes** | **No** app code, encryption behavior, or compliance plist changes from this doc |
| **Draft suggestions** | Blocks marked **draft / not approved** — Legal / RE must replace or reject before intake recording |
| **Recording answers** | After Legal / RE **explicit approval**, open a **separate docs-only PR** to set intake rows to **Answered** |

---

<a id="legal-re-decision-draft--awaiting-explicit-approval"></a>

## Legal / Release Engineering decision draft — **awaiting explicit approval**

**Label:** **Legal/RE decision draft / awaiting explicit Legal/RE approval** — prepared from suggested worksheet drafts, TestFlight export compliance history, and build `3` evidence. **Not** intake **Answered**. **Not** G4 Closed/Ready. **Not** export compliance final submission or public release approval.

| Field | Value |
| --- | --- |
| **Prepared** | 2026-06-08 — docs-only hygiene under Stay ([#142](https://github.com/studio-prospect/qwon-ai-ios/pull/142)) |
| **Intake ledger** | **Q-AS-09 … Q-AS-10** remain **Unanswered** until Legal / RE explicit approval + follow-up PR |
| **Next step** | Legal / RE confirms, edits, or rejects each draft → docs-only PR records **Answered** in [intake ledger](./qwon_app_store_public_readiness_intake.md) |

### Q-AS-09 — Export compliance vs TestFlight build `2` attestation

| Field | Legal/RE decision draft |
| --- | --- |
| **Question ID** | Q-AS-09 |
| **Draft answer** | **Yes — updated export compliance / encryption declaration review is required** before public App Store submit vs relying on TestFlight build **`2`** attestation alone. Public release ships a **public submission binary** — treat as a **new compliance event** even if encryption use matches TestFlight **`0.1.0 (3)`**. Legal must confirm standard exemption paths (e.g. exempt encryption / HTTPS-only) for the **public-release candidate** and whether build `2` answers may be reused or must be re-attested. |
| **Encryption posture changed? (draft)** | **Planning assumption:** no material encryption change vs TestFlight **`0.1.0 (3)`** for build `3` class binary — **RE/Legal verify** on public-release candidate; build **`3`** export compliance **not re-verified in docs** must be closed before submit. |
| **Build `3` doc gap (draft)** | Close documentation gap — RE/Legal verify encryption use on candidate binary; do **not** infer compliance from Wang installability alone. |
| **Public-release binary vs TestFlight (draft)** | Public submission binary may differ from TestFlight **`0.1.0 (3)`** — compliance answers must reference **submit binary**, not TestFlight history alone. |
| **Decision owner** | Legal (draft — **awaiting explicit Legal/RE approval**) |
| **Source** | Elaborated from [suggested draft § Q-AS-09](#q-as-09--export-compliance-vs-testflight-build-2-attestation); [TestFlight prep — export compliance gate](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) |
| **Constraints** | **Not** export compliance **submitted**; **not** intake **Answered** until follow-up PR |

### Q-AS-10 — ASC export compliance sign-off owner and re-verification

| Field | Legal/RE decision draft |
| --- | --- |
| **Question ID** | Q-AS-10 |
| **Draft answer** | **Release Engineering** owns ASC export compliance questionnaire completion for the **public submission build**; **Legal** reviews and approves answers before App Store submit. Re-verification required even if answers match TestFlight build **`2`** attestation. |
| **Sign-off owner (draft)** | **Release Engineering** (primary) · **Legal** (review/approve ASC answers) |
| **Re-verification steps (draft)** | (1) Identify public-release candidate binary · (2) Verify encryption use (app, llama.cpp, HTTPS/TLS, non-exempt crypto) · (3) Compare vs TestFlight build **`2`** attestation · (4) Complete ASC export compliance for **public submission build** — do **not** assume TestFlight carry-forward · (5) Record attestation audit trail · (6) Legal sign-off before submit |
| **Pre-submit checklist (draft)** | Adapt [TestFlight prep operator checklist](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) for **App Store public submit** — separate from internal TestFlight upload ops |
| **Documentation location (draft)** | Intake ledger + this worksheet after approval; ASC attestation evidence in ops record (not git) |
| **Decision owner** | Release Engineering (draft — **awaiting explicit Legal/RE approval**) |
| **Source** | Elaborated from [suggested draft § Q-AS-10](#q-as-10--asc-export-compliance-sign-off-owner-and-re-verification) |
| **Constraints** | **Not** ASC compliance **submitted**; **not** G4 Closed/Ready |

---

## Current evidence

| Field | Value |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **Checklist gate G2** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) ([#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)) |
| **Checklist gate G3** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) ([#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)) |
| **Intake ledger total** | **24 questions · 16 Unanswered · 8 Answered** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · ASC **`6775685841`** |
| **G4 intake** | **Q-AS-09 … Q-AS-10** — **Unanswered** |
| **Checklist gate G4** | **Partial** |
| **Prior TestFlight export compliance** | [TestFlight prep — export compliance operator gate](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) — build `1` completed at upload; build `2` **re-submission required** then submitted 2026-06-02; build `3` **not re-verified in docs** |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |

### G1 + G2 + G3 inputs for G4 (reference)

| Source | Summary |
| --- | --- |
| **G1 Q-AS-01** | Local-first cognitive runtime — on-device inference by default |
| **G3 Q-AS-07** | Build `3` posture: on-device LLM inference; no in-app model HTTPS download on TestFlight |
| **TestFlight prep** | Export compliance is an **operator gate per upload** — upload success ≠ installable until ASC compliance answered |
| **M3 compliance memo** | Future in-app download may require **updated export / ASC disclosures** — separate from TestFlight build `2` baseline |

---

## Answer format (copy for each question)

```text
Question ID:
Approved answer:
Decision owner:
Source (meeting / email / memo / PR):
Re-verification steps (if applicable):
Constraints or deferrals:
```

---

## Q-AS-09 — Export compliance vs TestFlight build `2` attestation

| Field | Value |
| --- | --- |
| **Gate** | G4 |
| **Owner** | Legal |
| **Intake status** | **Unanswered** (unchanged until follow-up PR) |

### Question

Does **public release** require updated **export compliance / encryption declaration** vs the TestFlight build `2` attestation documented in [TestFlight prep](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate)?

### Legal answer (fill in)

**See [Legal/RE decision draft](#legal-re-decision-draft--awaiting-explicit-approval)** — **draft / awaiting explicit Legal/RE approval**; intake row remains **Unanswered**.

| Field | Your answer |
| --- | --- |
| **Approved answer** | **Yes** — updated export compliance / encryption declaration review required before public submit vs TestFlight build **`2`** attestation alone; new compliance event for public submission binary. *(draft — awaiting explicit approval)* |
| **Encryption posture changed?** | No material change assumed vs TestFlight **`0.1.0 (3)`** — **RE/Legal verify** on public-release candidate. *(draft)* |
| **Build `3` doc gap impact** | Close doc gap — verify candidate binary; do not infer from installability alone. *(draft)* |
| **Public-release binary vs TestFlight** | Submit binary may differ — compliance must reference submit binary. *(draft)* |
| **Decision owner** | Legal (draft) |
| **Source** | [Legal/RE decision draft § Q-AS-09](#legal-re-decision-draft--awaiting-explicit-approval) |
| **Constraints** | Not export compliance **submitted**; not intake **Answered** |

### Suggested draft — **draft / not approved**

> **Public release vs TestFlight build `2` attestation (planning draft):**
> - TestFlight build **`2`** export compliance was **re-submitted and completed** 2026-06-02 per [operator gate](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate); build **`3`** compliance was **not re-verified in docs** (installable on Wang implies processing cleared, but **not** documented for public-readiness).
> - **Public App Store release** will ship a **public submission binary** — treat as a **new compliance event** even if encryption use is unchanged vs TestFlight **`0.1.0 (3)`**.
> - **Planning draft answer:** **Yes — updated export compliance / encryption declaration review is required** before public submit — Legal must confirm whether standard exemption paths (e.g. exempt encryption / HTTPS-only) still apply to the **public-release candidate** and whether build `2` TestFlight answers may be reused or must be re-attested.
> - **Build `3` gap:** Close the documentation gap — RE/Legal verify encryption use on the candidate binary before relying on any prior TestFlight attestation.
> - **Not** a final Legal conclusion; **not** ASC submission.

Legal must edit, replace, or reject. **Not** export compliance final submission. **Not** intake **Answered** until follow-up PR.

### Unblocks

Q-AS-10, G4 sign-off

---

## Q-AS-10 — ASC export compliance sign-off owner and re-verification

| Field | Value |
| --- | --- |
| **Gate** | G4 |
| **Owner** | Release Engineering |
| **Intake status** | **Unanswered** |

### Question

Who owns **ASC export compliance sign-off** for public App Store submission, and what re-verification steps are required before submit?

### Release Engineering / Legal answer (fill in)

**See [Legal/RE decision draft](#legal-re-decision-draft--awaiting-explicit-approval)** — **draft / awaiting explicit Legal/RE approval**; intake row remains **Unanswered**.

| Field | Your answer |
| --- | --- |
| **Sign-off owner** | **Release Engineering** (primary); **Legal** review/approve ASC answers. *(draft — awaiting explicit approval)* |
| **Legal review role** | Legal approves final ASC export compliance answers before submit. *(draft)* |
| **Re-verification steps** | Identify candidate binary → verify encryption use → compare vs build **`2`** attestation → complete ASC for public submit → audit trail → Legal sign-off. *(draft)* |
| **Pre-submit checklist** | Adapt TestFlight operator checklist for App Store public submit. *(draft)* |
| **Documentation location** | Intake + worksheet after approval; ASC evidence in ops record. *(draft)* |
| **Decision owner** | Release Engineering (draft) |
| **Source** | [Legal/RE decision draft § Q-AS-10](#legal-re-decision-draft--awaiting-explicit-approval) |
| **Constraints** | Not ASC compliance **submitted**; not G4 Closed/Ready |

### Suggested draft — **draft / not approved**

> **ASC export compliance sign-off (planning draft):**
> - **Primary owner (draft):** **Release Engineering** completes ASC export compliance questionnaire for the **public submission build**; **Legal** reviews/approves answers before App Store submit.
> - **Re-verification steps (draft):**
>   1. Identify **public-release candidate binary** (may differ from TestFlight **`0.1.0 (3)`**).
>   2. Verify encryption use — app binary, linked libraries (e.g. llama.cpp), HTTPS/TLS, any non-exempt crypto — against [TestFlight prep operator checklist](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate).
>   3. Compare vs TestFlight build **`2`** attestation — document deltas or confirm reuse rationale.
>   4. Complete ASC **輸出コンプライアンス / encryption** for the **public submission build** — do **not** assume TestFlight compliance carries forward automatically.
>   5. Record attestation source (PR, memo, ASC screenshot reference) for audit trail.
>   6. **Legal sign-off** on final ASC answers before submit.
> - **Build `3` note:** Close doc gap — formalize whether build `3` encryption posture matches build `2` for planning purposes.
> - **Not** operator execution of submit; **not** export compliance **submitted** from this worksheet.

RE/Legal must edit, replace, or reject. **Not** ASC compliance final approval.

### Unblocks

G4 sign-off

---

## G4 completion checklist (worksheet — not gate sign-off)

| Item | Status |
| --- | --- |
| Q-AS-09 Legal/RE decision draft prepared | **Done** — [awaiting explicit approval](#legal-re-decision-draft--awaiting-explicit-approval) |
| Q-AS-10 Legal/RE decision draft prepared | **Done** — awaiting explicit approval |
| Legal / RE **explicit approval** of G4 drafts | **Pending** |
| Follow-up docs-only PR updates intake to **Answered** | **Pending** |
| Checklist gate G4 marked Closed/Ready | **No** — separate sign-off gate |
| Export compliance final submission approved | **No** |
| Public release approved | **No** |
| Build `4` / TestFlight upload / ASC submission approved | **No** |

---

## Agent note

Share with **Legal / Release Engineering** for **explicit approval**. **Do not** copy Legal/RE decision drafts into the intake ledger as **Answered** or submit ASC export compliance until stakeholders confirm and a follow-up docs-only PR records them. Stay-allowed hygiene only.
