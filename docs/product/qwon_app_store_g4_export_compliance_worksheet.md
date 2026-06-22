# QWON — App Store G4 Export Compliance Worksheet (External Share)

**Last updated:** 2026-06-22 (Historical G4 intake source — Legal/RE **approved for intake recording** in [#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144); current gate sign-off **Closed/Ready** in [#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146))
**Status:** **Historical intake worksheet** with Legal/RE decision draft — intake rows **Q-AS-09 … Q-AS-10** are **Answered** in the [intake ledger](./qwon_app_store_public_readiness_intake.md) ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)). Current checklist gate **G4** is **Closed/Ready** in the [G4 gate sign-off worksheet](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)). **Not** export compliance final submission. **Not** App Store public release approval. **Not** Build `4` approval. **TestFlight upload / tag / version bump / ASC submission not approved.**
**Purpose:** Historical shareable English worksheet for **Legal / Release Engineering** — G4 intake answers recorded in [#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144); current gate readiness is governed by [G4 gate sign-off](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)).

日本語版: [G4 輸出コンプライアンス回答フォーム（日本語）](./qwon_app_store_g4_export_compliance_worksheet_ja.md)

Related: [Intake ledger — G4](./qwon_app_store_public_readiness_intake.md#g4--export-compliance--encryption-declaration) · [Checklist — G4](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [TestFlight prep — export compliance gate](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) · [M3 distribution compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [G3 gate sign-off](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)


**Historical source note:** This worksheet is a **historical intake source** for G4 intake [#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144). The current canonical gate decision is the [G4 gate sign-off worksheet](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)), where checklist gate **G4** is **Closed/Ready**. Worksheet-time gate status references below are marked **historical at worksheet time**.

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
| **Draft suggestions** | Superseded by [approved for intake recording](#legal-re-decision-draft--awaiting-explicit-approval) — historical suggested drafts below |
| **Recording answers** | Legal / RE **approved for intake recording** 2026-06-08 — intake **Answered** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)); historical at worksheet time: **Open** before sign-off; current **G4 Closed/Ready** ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)) |

---

<a id="legal-re-decision-draft--awaiting-explicit-approval"></a>

## Legal / Release Engineering decision draft — **approved for intake recording**

**Label:** **Legal/RE decision draft — approved for intake recording (2026-06-08)** — recorded in [intake ledger — G4 answer details](./qwon_app_store_public_readiness_intake.md#g4-legalre-answer-details-2026-06-08) ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144); worksheet prep [#143](https://github.com/studio-prospect/qwon-ai-ios/pull/143)). Historical at worksheet time: **not** G4 Closed/Ready; current **G4 Closed/Ready** ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)). **Not** export compliance final submission. **Not** public release or Build `4` approval.

| Field | Value |
| --- | --- |
| **Prepared** | 2026-06-08 — docs-only hygiene under Stay ([#142](https://github.com/studio-prospect/qwon-ai-ios/pull/142)) |
| **Approved for intake recording** | 2026-06-08 — Legal / RE explicit approval → intake **Answered** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)) |
| **Gate sign-off** | **Done** — preparation [#145](https://github.com/studio-prospect/qwon-ai-ios/pull/145) led to [G4 sign-off](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)); checklist gate **G4 Closed/Ready** |

### Q-AS-09 — Export compliance vs TestFlight build `2` attestation

| Field | Legal/RE decision draft |
| --- | --- |
| **Question ID** | Q-AS-09 |
| **Draft answer** | **Yes — updated export compliance / encryption declaration review is required** before public App Store submit vs relying on TestFlight build **`2`** attestation alone. Public release ships a **public submission binary** — treat as a **new compliance event** even if encryption use matches TestFlight **`0.1.0 (3)`**. Legal must confirm standard exemption paths (e.g. exempt encryption / HTTPS-only) for the **public-release candidate** and whether build `2` answers may be reused or must be re-attested. |
| **Encryption posture changed? (draft)** | **Planning assumption:** no material encryption change vs TestFlight **`0.1.0 (3)`** for build `3` class binary — **RE/Legal verify** on public-release candidate; build **`3`** export compliance **not re-verified in docs** must be closed before submit. |
| **Build `3` doc gap (draft)** | Close documentation gap — RE/Legal verify encryption use on candidate binary; do **not** infer compliance from Wang installability alone. |
| **Public-release binary vs TestFlight (draft)** | Public submission binary may differ from TestFlight **`0.1.0 (3)`** — compliance answers must reference **submit binary**, not TestFlight history alone. |
| **Decision owner** | Legal (**approved for intake recording** — 2026-06-08) |
| **Source** | Elaborated from [suggested draft § Q-AS-09](#q-as-09--export-compliance-vs-testflight-build-2-attestation); [TestFlight prep — export compliance gate](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) |
| **Constraints** | **Not** export compliance **submitted**; historical at worksheet time: **Open** before sign-off; current **G4 Closed/Ready** ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)) |

### Q-AS-10 — ASC export compliance sign-off owner and re-verification

| Field | Legal/RE decision draft |
| --- | --- |
| **Question ID** | Q-AS-10 |
| **Draft answer** | **Release Engineering** owns ASC export compliance questionnaire completion for the **public submission build**; **Legal** reviews and approves answers before App Store submit. Re-verification required even if answers match TestFlight build **`2`** attestation. |
| **Sign-off owner (draft)** | **Release Engineering** (primary) · **Legal** (review/approve ASC answers) |
| **Re-verification steps (draft)** | (1) Identify public-release candidate binary · (2) Verify encryption use (app, llama.cpp, HTTPS/TLS, non-exempt crypto) · (3) Compare vs TestFlight build **`2`** attestation · (4) Complete ASC export compliance for **public submission build** — do **not** assume TestFlight carry-forward · (5) Record attestation audit trail · (6) Legal sign-off before submit |
| **Pre-submit checklist (draft)** | Adapt [TestFlight prep operator checklist](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) for **App Store public submit** — separate from internal TestFlight upload ops |
| **Documentation location (draft)** | Intake ledger + this worksheet after approval; ASC attestation evidence in ops record (not git) |
| **Decision owner** | Release Engineering (**approved for intake recording** — 2026-06-08) |
| **Source** | Elaborated from [suggested draft § Q-AS-10](#q-as-10--asc-export-compliance-sign-off-owner-and-re-verification) |
| **Constraints** | **Not** ASC compliance **submitted**; historical at worksheet time: **not** G4 Closed/Ready; current **G4 Closed/Ready** ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)) |

---

## Current evidence

| Field | Value |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **Checklist gate G2** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) ([#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)) |
| **Checklist gate G3** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) ([#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)) |
| **Intake ledger total** | **24 questions · 14 Unanswered · 10 Answered** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · ASC **`6775685841`** |
| **G4 intake** | **Q-AS-09 … Q-AS-10 Answered** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)) |
| **Checklist gate G4** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)) |
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
| **Intake status** | **Answered** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)) |

### Question

Does **public release** require updated **export compliance / encryption declaration** vs the TestFlight build `2` attestation documented in [TestFlight prep](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate)?

### Legal answer (fill in)

**See [approved for intake recording](#legal-re-decision-draft--awaiting-explicit-approval)** — intake **Answered** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)); historical at worksheet time: **Open** before sign-off; current **G4 Closed/Ready** ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)).

| Field | Your answer |
| --- | --- |
| **Approved answer** | **Yes** — updated export compliance / encryption declaration review required before public submit vs TestFlight build **`2`** attestation alone; new compliance event for public submission binary. *(approved for intake recording)* |
| **Encryption posture changed?** | No material change assumed vs TestFlight **`0.1.0 (3)`** — **RE/Legal verify** on public-release candidate. *(approved for intake recording)* |
| **Build `3` doc gap impact** | Close doc gap — verify candidate binary; do not infer from installability alone. *(approved for intake recording)* |
| **Public-release binary vs TestFlight** | Submit binary may differ — compliance must reference submit binary. *(approved for intake recording)* |
| **Decision owner** | Legal (approved for intake recording) |
| **Source** | [Intake ledger — G4 answer details](./qwon_app_store_public_readiness_intake.md#g4-legalre-answer-details-2026-06-08) |
| **Constraints** | Not export compliance **submitted**; historical at worksheet time: **Open** before sign-off; current **G4 Closed/Ready** ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)) |

### Suggested draft — **superseded (historical)**

> *Superseded by [approved for intake recording](#legal-re-decision-draft--awaiting-explicit-approval) — retained for traceability.*

> **Public release vs TestFlight build `2` attestation (planning draft):**
> - TestFlight build **`2`** export compliance was **re-submitted and completed** 2026-06-02 per [operator gate](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate); build **`3`** compliance was **not re-verified in docs** (installable on Wang implies processing cleared, but **not** documented for public-readiness).
> - **Public App Store release** will ship a **public submission binary** — treat as a **new compliance event** even if encryption use is unchanged vs TestFlight **`0.1.0 (3)`**.
> - **Planning draft answer:** **Yes — updated export compliance / encryption declaration review is required** before public submit — Legal must confirm whether standard exemption paths (e.g. exempt encryption / HTTPS-only) still apply to the **public-release candidate** and whether build `2` TestFlight answers may be reused or must be re-attested.
> - **Build `3` gap:** Close the documentation gap — RE/Legal verify encryption use on the candidate binary before relying on any prior TestFlight attestation.
> - **Not** a final Legal conclusion; **not** ASC submission.

Historical at worksheet time: Legal had to edit, replace, or reject before sign-off. **Not** export compliance final submission. Intake **Answered** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)); current G4 gate readiness is recorded only by sign-off [#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146).

### Historically unblocked

*Historical at worksheet time:* gate sign-off followed intake recording. **Current:** G4 **Closed/Ready** — [sign-off Approved](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)).

---

## Q-AS-10 — ASC export compliance sign-off owner and re-verification

| Field | Value |
| --- | --- |
| **Gate** | G4 |
| **Owner** | Release Engineering |
| **Intake status** | **Answered** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)) |

### Question

Who owns **ASC export compliance sign-off** for public App Store submission, and what re-verification steps are required before submit?

### Release Engineering / Legal answer (fill in)

**See [approved for intake recording](#legal-re-decision-draft--awaiting-explicit-approval)** — intake **Answered** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)); historical at worksheet time: **Open** before sign-off; current **G4 Closed/Ready** ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)).

| Field | Your answer |
| --- | --- |
| **Sign-off owner** | **Release Engineering** (primary); **Legal** review/approve ASC answers. *(approved for intake recording)* |
| **Legal review role** | Legal approves final ASC export compliance answers before submit. *(approved for intake recording)* |
| **Re-verification steps** | Identify candidate binary → verify encryption use → compare vs build **`2`** attestation → complete ASC for public submit → audit trail → Legal sign-off. *(approved for intake recording)* |
| **Pre-submit checklist** | Adapt TestFlight operator checklist for App Store public submit. *(approved for intake recording)* |
| **Documentation location** | Intake + worksheet after approval; ASC evidence in ops record. *(approved for intake recording)* |
| **Decision owner** | Release Engineering (approved for intake recording) |
| **Source** | [Intake ledger — G4 answer details](./qwon_app_store_public_readiness_intake.md#g4-legalre-answer-details-2026-06-08) |
| **Constraints** | Not ASC compliance **submitted**; historical at worksheet time: not G4 Closed/Ready; current G4 Closed/Ready ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)) |

### Suggested draft — **superseded (historical)**

> *Superseded by [approved for intake recording](#legal-re-decision-draft--awaiting-explicit-approval) — retained for traceability.*

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

Historical at worksheet time: RE/Legal had to edit, replace, or reject before sign-off. **Not** ASC compliance final approval. Intake **Answered** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)); current G4 gate readiness is recorded only by sign-off [#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146).

### Historically unblocked

*Historical at worksheet time:* gate sign-off followed intake recording. **Current:** G4 **Closed/Ready** — [sign-off Approved](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)).

---

## G4 completion checklist (worksheet — not gate sign-off)

| Item | Status |
| --- | --- |
| Q-AS-09 Legal/RE decision draft prepared | **Done** — [approved for intake recording](#legal-re-decision-draft--awaiting-explicit-approval) |
| Q-AS-10 Legal/RE decision draft prepared | **Done** — approved for intake recording |
| Legal / RE **approved for intake recording** | **Done** — 2026-06-08 ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)) |
| Follow-up docs-only PR updates intake to **Answered** | **Done** — [#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144) |
| **G4 gate sign-off worksheet** | **Done** — [#145](https://github.com/studio-prospect/qwon-ai-ios/pull/145) / sign-off [#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146) |
| Checklist gate G4 marked Closed/Ready | **Done** — [#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146) |
| Export compliance final submission approved | **No** |
| Public release approved | **No** |
| Build `4` / TestFlight upload / ASC submission approved | **No** |

---

## Agent note

Historical worksheet for **Legal / Release Engineering** G4 intake. Intake **Answered** ([#144](https://github.com/studio-prospect/qwon-ai-ios/pull/144)) did not submit ASC export compliance, approve public release, Build `4`, ASC submission, or TestFlight operations; current checklist gate **G4 Closed/Ready** is recorded only by gate sign-off [#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146). Stay-allowed hygiene only.
