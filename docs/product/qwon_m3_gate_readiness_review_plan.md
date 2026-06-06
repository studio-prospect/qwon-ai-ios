# QWON — M3 Gate Readiness Review Plan

**Last updated:** 2026-06-06 (Batch A/B Gates 1–5 Ready; Gates 6–9 Pending)
**Status:** **Review plan** — Batch A / Gates **1–3** and Batch B / Gates **4–5** Ready sign-offs recorded; **not** M3 implementation approval, **not** Build `4` approval.
**Purpose:** Define **review order**, **owners**, **required evidence**, and **exit criteria** for moving M3 checklist Gates **1–9** from **Pending** to **Ready**. Evidence memos exist ([#91](https://github.com/studio-prospect/qwon-ai-ios/pull/91)–[#95](https://github.com/studio-prospect/qwon-ai-ios/pull/95)); Gates **6–9** remain **Pending**.

Related: [M3 readiness checklist](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) · [Answer intake ledger](./qwon_m3_gate_answer_intake.md) · [Batch A external questionnaire](./qwon_m3_batch_a_external_questionnaire.md) · [Queue — M3 status](./qwon_next_work_queue.md#m3-readiness-status-2026-06-05) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

---

## Current state (unchanged by this plan)

| Field | Value |
| --- | --- |
| **Gates 1–3** | **Ready** — Batch A sign-off recorded 2026-06-06 |
| **Gates 4–5** | **Ready** — Batch B sign-off recorded 2026-06-06 |
| **Gates 6–9** | Evidence memos linked — **Pending** |
| **M3 in-app download spike** | **Not approved** |
| **Build `4` / TestFlight upload / tag / version bump** | **Not approved** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** |
| **M2 rollback** | **Place GGUF via Mac** + USB ops — must remain |

---

## Review principles

| Principle | Rule |
| --- | --- |
| **Docs-first** | Ready decisions recorded in **docs-only PRs** with linked evidence — no Swift, no GGUF commit |
| **Batch order** | **A → B → C → D** — later batches may depend on earlier decisions |
| **No partial spike** | Do **not** open M3 downloader code until **all nine** gates are **Ready** |
| **Build `4` separate** | Gate 9 Ready ≠ TestFlight upload approval |
| **Codex vs Product** | **Codex** — architecture, checksum policy, integrity mechanics. **Product** — hosting owner, copy, legal escalation, release timing. **Legal** — Gate 3 only (Product coordinates) |

---

## Review batch overview

| Batch | Gates | Theme | Suggested order | Memo |
| --- | --- | --- | --- | --- |
| **A** | 1–3 | Hosting, checksum, compliance | **1st** | [Hosting + checksum](./qwon_m3_model_hosting_checksum_memo.md) · [Compliance](./qwon_m3_model_distribution_compliance_memo.md) |
| **B** | 4–5 | Storage budget, download integrity | **2nd** | [Storage + integrity](./qwon_m3_storage_integrity_memo.md) |
| **C** | 6–7 | Network disclosure, device tiers | **3rd** | [Network + device expectation](./qwon_m3_network_device_expectation_memo.md) |
| **D** | 8–9 | Rollback path, release gate | **4th** | [Rollback + release gate](./qwon_m3_rollback_release_gate_memo.md) |

**Current disposition:** Batch **A** / Gates **1–3** and Batch **B** / Gates **4–5** are **Ready**; C–D / Gates **6–9** remain **Pending**.

---

## Batch A — Gates 1–3: Hosting, checksum, compliance

### Gates in scope

| Gate | Topic | Evidence memo |
| --- | --- | --- |
| **1** | Model hosting source / URL ownership | [Hosting memo — Gate 1](./qwon_m3_model_hosting_checksum_memo.md#gate-1--model-hosting-source--url-ownership) |
| **2** | SHA-256 checksum and expected byte size | [Hosting memo — Gate 2](./qwon_m3_model_hosting_checksum_memo.md#gate-2--sha-256-checksum-and-expected-byte-size) |
| **3** | License / redistribution / export compliance | [Compliance memo](./qwon_m3_model_distribution_compliance_memo.md) |

### Owners

| Role | Responsibility |
| --- | --- |
| **Product** | Hosting owner; approve or reject third-party HF as product URL; legal escalation for Gate 3 |
| **Codex** | Checksum policy; reproducibility; architecture sign-off on hosting option |
| **Legal** (via Product) | Gate 3 license, redistribution, export compliance **written confirmation** |

### Required evidence (to mark Ready — **not produced by this plan**)

| Gate | Evidence Product/Codex must produce |
| --- | --- |
| **1** | Named storage/CDN owner; approved HTTPS URL or “self-host artifact X” decision; reproducibility pin (version/object key) |
| **2** | Published SHA-256 + exact byte size for **Gate 1 artifact**; verification policy doc |
| **3** | Legal/Product sign-off memo revision or checklist row update — not investigation memo alone |

### Exit criteria (batch A complete)

1. Gates **1–3** checklist rows updated to **Ready** in a **separate docs-only sign-off PR** (future).
2. Gate **2** byte size matches Gate **1** pinned artifact (no range).
3. Gate **3** explicitly **not blocked** on redistribution for chosen hosting model.
4. Dev ops HF URL remains documented as **not** product hosting unless Product explicitly approves otherwise.

### Blocked-by

| Gate | Blocked by |
| --- | --- |
| **1** | Product hosting decision; Gate 3 legal input on redistribution |
| **2** | Gate **1** approved artifact |
| **3** | Legal/Product review of [HF primary links](./qwon_m3_model_distribution_compliance_memo.md#primary-source-links-product--legal-traceability) |

### Batch A disposition

| Field | Value |
| --- | --- |
| **Status** | **Ready** |
| **Ready?** | **Yes** — Gates **1–3** only |
| **Batch A review (docs-only)** | **Documented** — [2026-06-05 session](#batch-a-review-session-2026-06-05) identified open items; [2026-06-06 sign-off](#batch-a-ready-sign-off-2026-06-06) records closure |

## Batch A Ready sign-off (2026-06-06)

**Decision:** Gates **1–3** are **Ready** for M3 readiness tracking.

**Scope:** Hosting source / ownership, checksum + exact byte size, and license / redistribution / export-compliance direction for the selected QWON-hosted Qwen2.5 `Q4_K_M` GGUF artifact.

**Evidence:** [Answer intake ledger](./qwon_m3_gate_answer_intake.md#batch-a--gates-13-hosting--checksum--compliance) Q-A-01…Q-A-13; [artifact record details](./qwon_m3_gate_answer_intake.md#batch-a-artifact-record-details-2026-06-06); [hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md); [compliance memo](./qwon_m3_model_distribution_compliance_memo.md).

| Gate | Ready basis |
| --- | --- |
| **1** | Product is the distribution decision owner; Release Engineering owns QWON object storage/CDN operations; QWON-hosted mirror is selected; third-party Hugging Face URL remains traceability/dev ops only. |
| **2** | QWON-hosted object identity, exact byte size `397808192`, SHA-256 `6eb923e7d26e9cea28811e1a8e852009b21242fb157b26149d3b188f3a8c8653`, and legacy USB `present-unverified` policy are recorded. Download temp/atomic mechanics remain Gate **5**. |
| **3** | Legal/Product approved the Apache-2.0 direction, conditional QWON-hosted bartowski `Q4_K_M` mirror, attribution requirement, HF traceability-only stance, and ASC/export re-check before product-facing download builds. |

### Non-approvals

| Item | Status |
| --- | --- |
| **Gates 4–5** | **Ready** |
| **Gates 6–9** | **Pending** |
| **M3 in-app download spike** | **Not approved** |
| **Swift / downloader / storage implementation** | **Not approved** |
| **Build `4` / TestFlight upload / tag / version bump** | **Not approved** |

**Next docs-only step:** Batch **C** / Gates **6–7** answer intake and Ready review may proceed using Gate **5** integrity-state mapping and Gate **3** compliance direction as inputs.

---

## Batch A review session (2026-06-05)

**Type:** Docs-only readiness review — **not** gate Ready sign-off, **not** legal approval, **not** hosting/checksum final values.

**Outcome:** Gate **1–3** open items were **concretized** below. They were later answered in the [answer intake ledger](./qwon_m3_gate_answer_intake.md) and closed by [Batch A Ready sign-off](#batch-a-ready-sign-off-2026-06-06). This section remains as historical review evidence.

Related evidence: [Hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md#batch-a-review-status-2026-06-06) · [Compliance memo](./qwon_m3_model_distribution_compliance_memo.md#batch-a-review-status-2026-06-06)

### Gate 1 — Open items (hosting / URL ownership)

| # | Open item | Current state | Blocks Ready until |
| --- | --- | --- | --- |
| G1-1 | **Named hosting owner** (team / role) | **Unassigned** | Product assigns owner (release engineering, infra, or vendor) |
| G1-2 | **Hosting model selection** | Options A–D in [hosting memo](./qwon_m3_model_hosting_checksum_memo.md#hosting-options-for-productcodex-review--not-a-recommendation) — **no decision** | Product picks: QWON CDN / QWON-built artifact / defer M3 / explicit HF pin (if legal allows) |
| G1-3 | **Product HTTPS URL** | Dev ops [HF resolve URL](./qwon_m3_model_hosting_checksum_memo.md#current-dev-ops-fetch-not-product-hosting) — **not** product promise | Approved stable URL or object key documented |
| G1-4 | **Artifact pinning** | No immutable version ID, commit hash, or object etag policy | Reproducibility plan: pin bartowski file revision **or** QWON-built blob ID |
| G1-5 | **Upstream artifact identity** | Ops default: `Qwen2.5-0.5B-Instruct-Q4_K_M.gguf` → renamed `prexus-local-mvp.gguf` on device | Product confirms whether shipped artifact is **bartowski binary as-is**, **QWON repack**, or **new build** |
| G1-6 | **Rollback URL / migration** | Undocumented if hosting object rotates | Plan for in-flight clients when Gate 1 URL changes |
| G1-7 | **Third-party HF as in-app target** | **Not approved** today | Explicit Product + Gate 3 legal yes/no |
| G1-8 | **Availability / SLA expectation** | None for M3 spike | Product defines minimum (best-effort vs contracted CDN) |

**Gate 1 status:** **Ready** — closed by [Batch A Ready sign-off](#batch-a-ready-sign-off-2026-06-06)

### Gate 2 — Open items (SHA-256 / byte size / verification)

| # | Open item | Current state | Blocks Ready until |
| --- | --- | --- | --- |
| G2-1 | **Gate 1 pinned artifact** | Checksum undefined without G1-4/G1-5 | Gate **1** artifact identity finalized |
| G2-2 | **Exact expected byte size** | Ops range **~379–398 MB** only — [observed sizes](./qwon_m3_model_hosting_checksum_memo.md#observed-file-sizes-ops-evidence--not-gate-2-final) | Single integer for M3 verification (not a range) |
| G2-3 | **Published SHA-256** | **Not published** — ad-hoc `shasum` ops-only | SHA-256 of **Gate 1 artifact** in sign-off doc |
| G2-4 | **Verification timing** | Undecided: verify on temp before atomic move (preferred in Gate 5) vs post-move | Codex policy doc aligned with Gate 5 |
| G2-5 | **Verification failure UX** | Undecided | Product/Codex: delete temp, retry, fallback to M2 USB |
| G2-6 | **Checksum rotation process** | Undecided | When Gate 1 artifact updates, how Gate 2 constants version |
| G2-7 | **Mismatch with M2 USB-placed files** | M1 **Present (unverified)** today — no hash in alpha | Whether legacy unverified files remain valid or require re-download |
| G2-8 | **Source label for Diagnostics** | Gate 2 memo mentions metadata — no user-facing label | Product-approved label (not raw HF URL) |

**Gate 2 status:** **Ready** — exact hosted-object byte size and SHA-256 recorded; download temp/atomic mechanics remain Gate **5**

### Gate 3 — Open items (compliance — Product/legal confirmation incomplete)

| # | Open item | Current state | Blocks Ready until |
| --- | --- | --- | --- |
| G3-1 | **Qwen base model license** | HF tag `apache-2.0`; [LICENSE](https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct/blob/main/LICENSE) linked — **unconfirmed** for mobile re-download | Legal confirms on-device use + **app-initiated redistribution** |
| G3-2 | **bartowski GGUF quant rights** | Third-party quant; README `license_link` → Qwen LICENSE — **redistribute to end users unconfirmed** | Legal/Product: deliver bartowski file vs QWON-built |
| G3-3 | **Attribution / NOTICE** | Requirements **unknown** for in-app download path | Legal specifies in-app Settings/legal notice content |
| G3-4 | **Re-packaging as `prexus-local-mvp.gguf`** | Filename branding vs upstream — **unconfirmed** | Legal OK with rename + any required credit |
| G3-5 | **Export compliance (model weights)** | ASC encryption answer covers **app TLS** — model weight export **unreviewed** | Product/legal: M3 download impact on export questionnaire |
| G3-6 | **App Store / privacy label** | Large optional download — **unreviewed** | Product: ASC privacy nutrition label updates if needed |
| G3-7 | **TestFlight internal distribution** | Build `3` without bundled GGUF | Legal/Product: in-app fetch to internal testers — disclosure requirements |
| G3-8 | **Hugging Face ToS** | Not reviewed for embedded/production URL fetch | Legal review if G1-7 selects HF |
| G3-9 | **Regional (e.g. France) declarations** | Build `2` export resubmission history | Ops/Product re-check if network download ships |

**Gate 3 status:** **Ready** — Product/legal direction recorded; ASC/export re-check before product-facing download build remains Gate **9** / release work

### Product / legal question list (Batch A — answer to unblock Ready sign-off)

Product and legal should answer **in writing** (future memo revision or sign-off PR). Engineering **must not** infer approval from silence.

#### Hosting & artifact (Gate 1 — Product owner)

1. Who is the **named owner** for model hosting (G1-1)?
2. Which **hosting model** is approved: QWON CDN (A), HF pin (B), QWON-built artifact (C), or defer M3 download (D)?
3. What is the **exact artifact** M3 will ship: bartowski `Q4_K_M` as-is, or a QWON-built/repackaged blob?
4. How is the artifact **pinned** for reproducibility (G1-4)?
5. Is embedding or hardcoding a **third-party Hugging Face URL** acceptable for any tester-facing build (G1-7)?

#### Checksum policy (Gate 2 — Product + Codex)

6. After Gate 1 artifact is fixed, what is the **exact byte size** for verification (G2-2)?
7. What is the **SHA-256** of that artifact (G2-3)? *(Publish in sign-off PR only — not in this review)*
8. Do **existing USB-placed** GGUF files without matching hash remain supported, or must users re-acquire (G2-7)?

#### Legal / compliance (Gate 3 — Legal via Product)

9. Does **Apache-2.0** (Qwen base) permit QWON to **facilitate download** of weights to user devices via the app?
10. May QWON **redistribute** the bartowski GGUF quant to end users (directly or via QWON-hosted mirror)?
11. What **attribution / NOTICE** text is required in-app or in documentation (G3-3, G3-4)?
12. Does in-app model download change **export compliance** or **App Store privacy label** answers (G3-5, G3-6)?
13. If Gate 1 selects HF URL: any **Hugging Face ToS** constraints for production app fetch (G3-8)?

### Batch A review exit (met by 2026-06-06 sign-off)

| Criterion | Met? |
| --- | --- |
| Open items documented | **Yes** (this section) |
| Product/legal questions issued | **Yes** (above) |
| Gates 1–3 marked **Ready** | **Yes** — [Batch A Ready sign-off](#batch-a-ready-sign-off-2026-06-06) |
| Final hosting object decided | **Yes** — QWON S3 bucket + object key recorded in [answer intake](./qwon_m3_gate_answer_intake.md#batch-a-artifact-record-details-2026-06-06) |
| Final SHA-256 / byte size published | **Yes** — `397808192` bytes; `6eb923e7d26e9cea28811e1a8e852009b21242fb157b26149d3b188f3a8c8653` |
| Legal sign-off recorded | **Yes** — [legal answer details](./qwon_m3_gate_answer_intake.md#batch-a-legal-answer-details-2026-06-05) |
| M3 spike approved | **No** |
| Build `4` approved | **No** |

**Next docs-only step:** Batch **C** / Gates **6–7** answer intake and Ready review may proceed. Gate **4** threshold and Gate **5** verification policy are Ready inputs for Batch C device/copy decisions. Gates **6–9** remain **Pending**.

---

## Batch B — Gates 4–5: Storage budget, download integrity

### Gates in scope

| Gate | Topic | Evidence memo |
| --- | --- | --- |
| **4** | iOS storage budget / available-space check | [Storage memo — Gate 4](./qwon_m3_storage_integrity_memo.md#gate-4--ios-storage-budget-and-available-space-check) |
| **5** | Partial download / resume / atomic move | [Storage memo — Gate 5](./qwon_m3_storage_integrity_memo.md#gate-5--partial-download--resume--atomic-move-plan) |

### Owners

| Role | Responsibility |
| --- | --- |
| **Product** | Minimum free-space threshold; user-visible failure copy for insufficient space |
| **Codex** | Temp filename strategy; atomic promote; resume vs clean-retry policy; integrity state machine |

### Required evidence (future sign-off PR)

| Gate | Evidence |
| --- | --- |
| **4** | Documented minimum bytes free before download (= Gate 2 size + temp peak + Product margin) |
| **5** | Named temp path; atomic move spec; resume decision (required vs optional); corrupt/partial → Diagnostics mapping |

### Exit criteria (batch B complete)

1. Gates **4–5** marked **Ready** in sign-off PR.
2. Gate **4** threshold math references **Gate 2** final byte size (not ~379–400 MB range).
3. Gate **5** defers no required behavior to “TBD at implementation” without Product ack.
4. `Documents/Models/prexus-local-mvp.gguf` contract unchanged.

### Blocked-by

| Gate | Blocked by |
| --- | --- |
| **4** | Gate **2** pinned byte size; Gate **5** temp peak assumption |
| **5** | Gate **2** verification policy; Gate **4** headroom policy |

### Batch B disposition

| Field | Value |
| --- | --- |
| **Status** | **Ready** |
| **Ready?** | **Yes** — Gates **4–5** only |
| **Batch B review (docs-only)** | **Documented** — [2026-06-05 session](#batch-b-review-session-2026-06-05) identified open items; [answer intake](./qwon_m3_gate_answer_intake.md#batch-b-storage-and-integrity-answer-details-2026-06-06) records Q-B-01…Q-B-11 |
| **Batch A dependency** | **Resolved** — Gate **2** final byte size and SHA-256 are available |

## Batch B Ready sign-off (2026-06-06)

**Decision:** Gates **4–5** are **Ready** for M3 readiness tracking.

**Scope:** Storage threshold, available-space policy, temp-file path, clean-retry behavior, verification-before-promote, partial/corrupt cleanup, and no silent replacement of USB-placed GGUF files.

**Evidence:** [Answer intake ledger](./qwon_m3_gate_answer_intake.md#batch-b-storage-and-integrity-answer-details-2026-06-06) Q-B-01…Q-B-11; [storage + integrity memo](./qwon_m3_storage_integrity_memo.md); [Gate 2 artifact record details](./qwon_m3_gate_answer_intake.md#batch-a-artifact-record-details-2026-06-06).

| Gate | Ready basis |
| --- | --- |
| **4** | Minimum free-space threshold is `1064051840` bytes (`397808192 * 2 + 268435456`); future download must check available capacity before starting; insufficient-space copy explains that QWON needs about **1.1 GB free**, does not delete user data, and can fall back to M2 placement / heuristic behavior. |
| **5** | Temp path is `Documents/Models/prexus-local-mvp.gguf.download`; runtime resolves only the final `Documents/Models/prexus-local-mvp.gguf`; M3 uses clean restart only, verifies Gate **2** byte size + SHA-256 before atomic promote, deletes failed temp files, keeps any prior final GGUF untouched, and does not silently replace USB-placed `present-unverified` files. |

### Non-approvals

| Item | Status |
| --- | --- |
| **Gates 6–9** | **Pending** |
| **M3 in-app download spike** | **Not approved** |
| **Swift / downloader / storage implementation** | **Not approved** |
| **Build `4` / TestFlight upload / tag / version bump** | **Not approved** |

**Next docs-only step:** Batch **C** / Gates **6–7** answer intake and Ready review may proceed using the Gate **5** integrity mapping and the Gate **4** storage threshold above.

---

## Batch B review session (2026-06-05)

**Type:** Docs-only readiness review — **not** gate Ready sign-off, **not** final threshold/temp path decisions, **not** downloader implementation.

**Outcome:** Gate **4–5** open items were **concretized** below, later answered in the [answer intake ledger](./qwon_m3_gate_answer_intake.md#batch-b-storage-and-integrity-answer-details-2026-06-06), and closed by [Batch B Ready sign-off](#batch-b-ready-sign-off-2026-06-06). This section remains as historical review evidence.

Related evidence: [Storage + integrity memo — Batch B status](./qwon_m3_storage_integrity_memo.md#batch-b-review-status-2026-06-06)

### Gate 4 — Open items (storage budget / available-space check)

| # | Open item | Current state | Blocks Ready until |
| --- | --- | --- | --- |
| G4-1 | **Minimum free-space threshold (bytes)** | **Answered** — `1064051840` bytes (`397808192 * 2 + 268435456`) | Gate **4** Ready sign-off |
| G4-2 | **Pre-download sandbox capacity check** | **Ready direction** — required before URLSession/download start; exact Foundation API remains implementation detail | Gate **4** Ready sign-off |
| G4-3 | **Temp peak size assumption** | **Answered** — plan for ~2× artifact size | Gate **4** Ready sign-off |
| G4-4 | **Safety margin above artifact + peak** | **Answered** — fixed 256 MiB margin | Gate **4** Ready sign-off |
| G4-5 | **Mid-download space exhaustion** | **Answered** — abort and clean retry; re-check capacity before retry | Gate **4–5** Ready sign-off |
| G4-6 | **User-visible insufficient-space copy** | **Answered direction** — about 1.1 GB free required, QWON does not delete user data, M2/fallback path remains | Gate **4** Ready sign-off |
| G4-7 | **Matisse / low-storage devices** | **Answered** — de-emphasize download; Embedded Heuristic Runtime expected | Gate **4** + **7** Ready sign-off |
| G4-8 | **Re-check after failed download** | **Answered** — re-query capacity before clean retry | Gate **4–5** Ready sign-off |
| G4-9 | **Lookup order / final path** | **Answered** — `Documents/Models/prexus-local-mvp.gguf` unchanged; no schema migration in M3 spike | Gate **4** Ready sign-off |

**Gate 4 status:** **Ready** — closed by [Batch B Ready sign-off](#batch-b-ready-sign-off-2026-06-06)

### Gate 5 — Open items (partial download / integrity)

| # | Open item | Current state | Blocks Ready until |
| --- | --- | --- | --- |
| G5-1 | **Temp filename / path** | **Answered** — `Documents/Models/prexus-local-mvp.gguf.download` | Gate **5** Ready sign-off |
| G5-2 | **Runtime must not load temp file** | **Answered** — resolver keeps final exact filename only | Gate **5** Ready sign-off |
| G5-3 | **Atomic move to final path** | **Answered direction** — verify temp before atomic promote to final path | Gate **5** Ready sign-off |
| G5-4 | **Verify before promote** | **Answered** — use Gate **2** size + SHA-256 on temp file before promote | Gate **5** Ready sign-off |
| G5-5 | **Resume vs clean retry** | **Answered** — clean restart only for M3; Range/background resume deferred | Gate **5** Ready sign-off |
| G5-6 | **Partial file cleanup on failure** | **Answered** — delete temp on failure/cancel; re-check capacity on retry | Gate **5** Ready sign-off |
| G5-7 | **Corrupt hash mismatch handling** | **Answered** — delete failed temp, keep prior final file untouched, fallback without crash | Gate **5** Ready sign-off |
| G5-8 | **Existing verified file on retry** | **Answered** — do not overwrite without explicit user/support action; deletion UX remains unapproved | Gate **5** Ready sign-off |
| G5-9 | **Diagnostics mapping — `partial`** | **Answered** — temp/incomplete file exists; not installed | Gate **5** + **7** Ready sign-off |
| G5-10 | **Diagnostics mapping — `corrupt`** | **Answered** — size/hash mismatch; temp removed or final rejected; no llama readiness claim | Gate **5** + **7** Ready sign-off |
| G5-11 | **Settings → Local Runtime in-progress UI** | **Answered** — in-progress/preparing, not installed, until verified final file loads; final copy remains Gate **6** | Gate **5** Ready sign-off |
| G5-12 | **M2 USB-placed unverified files** | **Answered** — no silent replacement; explicit user/support flow required | Gate **5** Ready sign-off |

**Gate 5 status:** **Ready** — closed by [Batch B Ready sign-off](#batch-b-ready-sign-off-2026-06-06)

### Product / Codex question list (Batch B — answer to unblock Ready sign-off)

Answered in [Batch B storage and integrity answer details](./qwon_m3_gate_answer_intake.md#batch-b-storage-and-integrity-answer-details-2026-06-06) and closed by [Batch B Ready sign-off](#batch-b-ready-sign-off-2026-06-06).

#### Storage budget (Gate 4 — Product + Codex)

1. After Gate **2** byte size is fixed (**Batch A**), what **minimum free bytes** are required before download starts (G4-1)? *(artifact + temp peak + margin)*
2. Is temp peak **~1×** or **~2×** artifact size during download (G4-3)?
3. What **safety margin** policy applies: fixed MB, percentage, or tier-specific (G4-4)?
4. What **user-visible copy** appears when space is insufficient (G4-6)?
5. Should download entry be **hidden or de-emphasized** on Matisse / low-storage devices (G4-7)?
6. If free space drops **mid-download**, abort only or attempt resume (G4-5)? *(ties to G5-5)*

#### Download integrity (Gate 5 — Codex + Product)

7. What is the **exact temp filename/path** under the sandbox (G5-1)?
8. Is **HTTP Range resume** required for M3 spike, or **clean restart only** (G5-5)?
9. On verification failure, **delete** temp file, quarantine, or leave for support (G5-6, G5-7)?
10. What **Diagnostics / Settings strings** map to `partial`, `corrupt`, and in-progress states (G5-9, G5-10, G5-11)?
11. May a **new download** replace an existing **USB-placed unverified** GGUF without explicit user consent (G5-12)? *(Batch A Gate 2-7 dependency)*

**Batch A inputs now available:** G4-1 threshold math may use byte size `397808192`; G5-4 may use SHA-256 `6eb923e7d26e9cea28811e1a8e852009b21242fb157b26149d3b188f3a8c8653`; G5-12 starts from the recorded legacy USB policy. Batch **B** still must answer its own threshold, temp path, retry, cleanup, Diagnostics, and replacement-consent questions.

### Batch B review exit (not yet met)

| Criterion | Met? |
| --- | --- |
| Open items documented | **Yes** (this section) |
| Product/Codex questions issued | **Yes** (above) |
| Gates 4–5 marked **Ready** | **Yes** — [Batch B Ready sign-off](#batch-b-ready-sign-off-2026-06-06) |
| Final minimum free-space threshold | **Yes** — `1064051840` bytes |
| Final temp filename/path | **Yes** — `Documents/Models/prexus-local-mvp.gguf.download` |
| Gate 2 byte size available | **Yes** — `397808192` bytes |
| M3 spike approved | **No** |
| Build `4` approved | **No** |

**Next docs-only step:** Proceed to Batch **C** answer intake for Gates **6–7**. M3 spike remains forbidden until **all nine** gates Ready.

---

## Batch C — Gates 6–7: Network disclosure, device expectation

### Gates in scope

| Gate | Topic | Evidence memo |
| --- | --- | --- |
| **6** | Privacy / network disclosure copy | [Network memo — Gate 6](./qwon_m3_network_device_expectation_memo.md#gate-6--privacy--network-disclosure-copy) |
| **7** | Wang / Matisse behavior expectation | [Network memo — Gate 7](./qwon_m3_network_device_expectation_memo.md#gate-7--wang--matisse-behavior-expectation) |

### Owners

| Role | Responsibility |
| --- | --- |
| **Product** | Final Settings/TestFlight/onboarding copy; privacy label impact; Matisse download visibility |
| **Codex** | Copy migration list (M2 strings retire vs keep); Diagnostics mapping consistency |

### Required evidence (future sign-off PR)

| Gate | Evidence |
| --- | --- |
| **6** | Approved disclosure strings; no-surprise-fetch rule; ASC/privacy label decision if needed |
| **7** | Tier matrix signed off; Matisse “not a failure” copy; Wang optional-download framing |

### Exit criteria (batch C complete)

1. Gates **6–7** marked **Ready** in sign-off PR.
2. Gate **6** copy **consistent** with M2 [guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement) — no contradictory “never uses network” claims after download ships.
3. Gate **7** drafts in memo **replaced or adopted** as Product-approved final copy list (still docs-only until UI PR gated separately).
4. Matisse download prompts do **not** imply device failure.

### Blocked-by

| Gate | Blocked by |
| --- | --- |
| **6** | Gate **3** privacy/export angle; Product copy owner |
| **7** | Gate **5** integrity states surfaced in UI; Gate **6** network framing |

### Batch C disposition

| Field | Value |
| --- | --- |
| **Status** | **Pending** |
| **Ready?** | **No** |
| **Batch C review (docs-only)** | **Documented** — [2026-06-05 session](#batch-c-review-session-2026-06-05) — open items + Product/Codex questions; **does not** mark Ready |
| **Blocked-by** | Gate **3** (privacy/ASC); Gate **5** (integrity → Diagnostics copy) |

---

## Batch C review session (2026-06-05)

**Type:** Docs-only readiness review — **not** gate Ready sign-off, **not** final UI copy approval, **not** privacy label / ASC final answers.

**Outcome:** Gate **6–7** open items **concretized** below. Checklist rows remain **Pending**. Draft strings in [network memo](./qwon_m3_network_device_expectation_memo.md) stay **drafts only**.

Related evidence: [Network + device memo — Batch C status](./qwon_m3_network_device_expectation_memo.md#batch-c-review-status-2026-06-05)

### Gate 6 — Open items (privacy / network disclosure copy)

| # | Open item | Current state | Blocks Ready until |
| --- | --- | --- | --- |
| G6-1 | **Pre-download network disclosure copy** | Draft A/B in memo — **not approved** | Product copy owner |
| G6-2 | **Download confirmation step** | Undecided — one-tap consent before fetch | Product + Codex UX flow |
| G6-3 | **No surprise background fetch** | Required in principle — background URLSession **not approved** | Product explicit policy if ever needed |
| G6-4 | **Local-first vs offline-only wording** | Must not claim fully offline after download exists | Product approved positioning |
| G6-5 | **Settings → Local Runtime strings** | M2 “does not download in-app” active on build `3` | [M2 ↔ M3 migration checklist](./qwon_m3_network_device_expectation_memo.md#m2--m3-copy-transition-undecided) |
| G6-6 | **Onboarding disclosure** | Undecided — reuse Settings vs separate screen | Product |
| G6-7 | **App Store privacy label impact** | **Undecided** — Gate **3** legal direction is Ready; release-time ASC/privacy-label answer still required | Legal/Product ASC review ([compliance memo](./qwon_m3_model_distribution_compliance_memo.md#app-store--testflight--export-compliance)) |
| G6-8 | **Export compliance questionnaire (network download)** | App TLS documented — model download angle **unreviewed**; Gate **3** legal direction is Ready | Product / Legal / Release Engineering re-check |
| G6-9 | **TestFlight tester notes** | Undecided — separate from in-app copy | Product / release comms |
| G6-10 | **In-progress download visibility** | Progress UI copy **undecided**; no hidden retry loops (principle) | Codex + Product |
| G6-11 | **Wi‑Fi vs cellular disclosure** | Draft A mentions cellular — **not approved** | Product policy |
| G6-12 | **First-launch fetch prohibition** | Product rule documented — enforcement spec **undecided** | Codex |

**Gate 6 status:** **Pending** — **not Ready** — Product/Legal/ASC copy and disclosure answers still required

### Gate 7 — Open items (Wang / Matisse device expectation)

| # | Open item | Current state | Blocks Ready until |
| --- | --- | --- | --- |
| G7-1 | **Wang optional download framing** | Draft in memo — **not approved** | Product |
| G7-2 | **Matisse heuristic expected copy** | M1/M2 aligned drafts — **not approved** | Product |
| G7-3 | **Download visibility by tier** | Undecided: Wang-only entry vs Matisse de-emphasized vs hidden | Product hardware policy |
| G7-4 | **Matisse must not read as device failure** | Principle documented — final strings **undecided** | Product |
| G7-5 | **Post-download Matisse runtime expectation** | Heuristic remains expected even if GGUF present — copy **undecided** | Product + Codex |
| G7-6 | **Diagnostics — `answered_by` mapping** | Reference table in memo; Gate **5** integrity mapping is Ready; final Gate **7** device-facing mapping still required | Product + Codex |
| G7-7 | **Diagnostics — `partial` / in-progress** | Direction in [Gate 5 review](./qwon_m3_gate_readiness_review_plan.md#gate-5--open-items-partial-download--integrity) is Ready; final copy still pending | Gate **7** copy policy |
| G7-8 | **Diagnostics — corrupt / failed download** | Gate **5** cleanup behavior is Ready; `primary_failure` / `fallback_reason` wording remains **undecided** | Codex + Product |
| G7-9 | **Chat fallback strip copy** | Draft for Wang missing model — **not approved** | Product |
| G7-10 | **Settings model status during download** | Must not show “installed” — overlaps G5-11; Gate **5** is Ready, final Product copy remains | Product |
| G7-11 | **M2 Place GGUF via Mac coexistence** | Must remain visible — copy priority **undecided** | Product ([Gate 8](./qwon_m3_rollback_release_gate_memo.md)) |
| G7-12 | **Verified vs present-unverified copy** | Gate **2** values available; final user-facing copy still tied to Gate **5** integrity state mapping | Gate **7** copy policy |

**Gate 7 status:** **Pending** — **not Ready**

### Product / Codex question list (Batch C — answer to unblock Ready sign-off)

Answer **in writing** in a future sign-off PR. **Do not** treat memo drafts as final UI copy.

#### Network disclosure (Gate 6 — Product + Legal via Product)

1. What **exact disclosure** appears before the user starts a model download (G6-1, G6-2)?
2. Is **background download** ever allowed, or **user-initiated foreground only** (G6-3)?
3. What is the approved **local-first positioning** sentence — network for acquisition only (G6-4)?
4. Which **M2 strings retire** when download ships vs remain for USB fallback (G6-5)?
5. Are **onboarding** strings required, or Settings-only disclosure (G6-6)?
6. Does model download require **App Store privacy label** or **ASC export** updates (G6-7, G6-8)? *(Gate 3 dependency)*
7. What do **TestFlight tester notes** say about optional ~400 MB download (G6-9)?
8. Must copy **explicitly mention cellular** data use (G6-11)?

#### Device expectation (Gate 7 — Product + Codex)

9. Which **device tiers** see a download entry point: Wang only, both with Matisse de-emphasis, or other (G7-3)?
10. What **Matisse copy** confirms Embedded Heuristic is expected — not failure (G7-2, G7-4)?
11. After download on Matisse (if offered), what **runtime expectation** copy is shown (G7-5)?
12. What **Diagnostics strings** map to download `partial`, `corrupt`, and success paths (G7-6–G7-8)? *(Gate 5 dependency)*
13. What **chat fallback strip** text is shown when Wang lacks a verified GGUF (G7-9)?
14. How does **Place GGUF via Mac** appear alongside download UX (G7-11)?

**Blocked-by summary:** Gate **3** blocks G6-7/G6-8 (privacy label / ASC). Gate **5** blocks G7-6–G7-8, G7-10 (integrity states in UI). Batch **A** blocks G7-12 (`verified` copy needs Gate **2**).

### Batch C review exit (not yet met)

| Criterion | Met? |
| --- | --- |
| Open items documented | **Yes** (this section) |
| Product/Codex questions issued | **Yes** (above) |
| Gates 6–7 marked **Ready** | **No** |
| Final UI copy approved | **No** |
| Privacy label / ASC answered | **No** — Gate **3** legal direction is Ready; release-time ASC/privacy-label answer still required |
| M3 spike approved | **No** |
| Build `4` approved | **No** |

**Next docs-only step:** Batch **C** answer intake for Product/Legal/ASC disclosure, device-tier, and final copy answers. Batch **C Ready** sign-off waits on those answers.

---

## Batch D — Gates 8–9: Rollback, release gate

### Gates in scope

| Gate | Topic | Evidence memo |
| --- | --- | --- |
| **8** | Mac + USB guided placement rollback | [Rollback memo — Gate 8](./qwon_m3_rollback_release_gate_memo.md#gate-8--rollback-to-mac--usb-guided-placement) |
| **9** | Build `4` / TestFlight release gate | [Rollback memo — Gate 9](./qwon_m3_rollback_release_gate_memo.md#gate-9--build-4--testflight-release-gate-separate) |

### Owners

| Role | Responsibility |
| --- | --- |
| **Product** | Build `4` decision timing; whether download UX ships to TestFlight |
| **Codex** | Spike regression test plan for M2 path; rollback runbook |
| **Release engineering** | Verify `fetch_local_model.sh` + `push_local_model_to_device.sh` after any spike (Gate 8) |

### Required evidence (future sign-off PR)

| Gate | Evidence |
| --- | --- |
| **8** | Documented rollback runbook; spike test plan item “M2 guided placement still reachable”; push script still works |
| **9** | Explicit Product memo: Build `4` **approved** or **deferred** — Gate 9 Ready for **spike-only** may mean “Build `4` still not approved” (clarify at review) |

### Exit criteria (batch D complete)

1. Gate **8** **Ready** — M2 path preservation signed off for any binary containing download UX.
2. Gate **9** disposition recorded — at minimum: **M3 spike does not authorize Build `4`** (may stay **Pending — not approved** even if spike proceeds internally).
3. TestFlight upload / tag / `CFBundleVersion` bump **not** implied.

### Blocked-by

| Gate | Blocked by |
| --- | --- |
| **8** | None for **review** — can review rollback requirements before spike; **Ready** may wait until spike test plan exists |
| **9** | Product release decision; independent of Gates 1–8 spike readiness |

### Batch D disposition

| Field | Value |
| --- | --- |
| **Status** | **Pending** |
| **Ready?** | **No** |
| **Batch D review (docs-only)** | **Documented** — [2026-06-05 session](#batch-d-review-session-2026-06-05) — open items + stakeholder questions; **does not** mark Ready |
| **Blocked-by** | Gate **8 Ready** → M3 **spike test plan**; Gate **9 Ready** → **Product release decision** |

---

## Batch D review session (2026-06-05)

**Type:** Docs-only readiness review — **not** gate Ready sign-off, **not** Build `4` approval, **not** TestFlight upload / tag / version bump.

**Outcome:** Gate **8–9** open items **concretized** below. Checklist rows remain **Pending** for Gates **8–9**. Batch **A/B** / Gates **1–5** are now Ready; Gates **6–9** remain Pending.

Related evidence: [Rollback + release memo — Batch D status](./qwon_m3_rollback_release_gate_memo.md#batch-d-review-status-2026-06-05)

### Gate 8 — Open items (Mac + USB rollback)

| # | Open item | Current state | Blocks Ready until |
| --- | --- | --- | --- |
| G8-1 | **M2 Place GGUF via Mac preservation** | Merged [#88](https://github.com/studio-prospect/qwon-ai-ios/pull/88); simulator verified [#89](https://github.com/studio-prospect/qwon-ai-ios/pull/89) | Post-spike regression re-verify on branch with download UX |
| G8-2 | **`fetch_local_model.sh` preservation** | Documented in [models/README.md](../../models/README.md) | Spike must not break script; RE sign-off after spike |
| G8-3 | **`push_local_model_to_device.sh` preservation** | Documented; Wang lab path known-good | Same as G8-2 |
| G8-4 | **Rollback runbook (ops)** | Scenarios listed in memo — **no standalone runbook doc** | Codex/RE publish runbook with M2 steps + failure modes |
| G8-5 | **Manual recovery when download fails** | Principle: USB push overwrites sandbox — **test plan undecided** | Spike test plan includes failed-download → USB recovery |
| G8-6 | **Post-spike regression checklist** | **Undecided** — which tests prove M2 path intact | **Spike test plan blocked** — Codex defines before Gate 8 Ready |
| G8-7 | **Settings/Local Runtime UI coexistence** | Download UX + M2 nav both visible — layout priority **undecided** | Product + Codex (ties [Gate 7 G7-11](./qwon_m3_gate_readiness_review_plan.md#gate-7--open-items-wang--matisse-device-expectation)) |
| G8-8 | **Lookup order unchanged** | `LocalGGUFModelPlacement` contract preserved — change **not approved** | Confirm in spike PR review |
| G8-9 | **Partial/corrupt download recovery** | Manual re-push via Gate 8 — **support copy undecided** | Gate **5** cleanup policy + Gate **7** copy |
| G8-10 | **Hosting URL break (Gate 1)** | Fallback to Mac fetch + USB — **ops alert path undecided** | Gate **1** monitoring + runbook |

**Gate 8 status:** **Pending** — **not Ready** — **spike test plan blocked** for G8-6 Ready

### Gate 9 — Open items (Build `4` / TestFlight release gate)

| # | Open item | Current state | Blocks Ready until |
| --- | --- | --- | --- |
| G9-1 | **M3 spike vs Build `4` boundary** | Documented: spike **≠** release — **Product ack undecided** | **Product release decision** |
| G9-2 | **TestFlight upload authorization** | **Not approved** — build `3` active | Explicit Product gate for any new binary |
| G9-3 | **Git tag policy** | **Not approved** for M3 work | Product release decision |
| G9-4 | **`CFBundleVersion` / build number bump** | **Not approved** | Product release decision |
| G9-5 | **Ship download UX to testers?** | **Undecided** — internal spike-only vs TestFlight with download | Product |
| G9-6 | **ASC export compliance re-check** | Documented for app TLS — download feature **unreviewed** | Ops + Gate **3** ([compliance memo](./qwon_m3_model_distribution_compliance_memo.md)) |
| G9-7 | **Tester communication template** | GGUF not bundled (today) vs optional download — **undecided** | Product / support |
| G9-8 | **Gate 9 Ready semantics** | Unclear: “Build `4` deferred” vs “Build `4` approved” as Ready evidence | Product clarifies sign-off PR format |
| G9-9 | **Gates 1–8 Ready prerequisite** | All **Pending** | Batch A–C sign-off before any TestFlight ship with download |
| G9-10 | **France / regional declarations** | Build `2` history — re-check if network download ships | Ops/Product |

**Gate 9 status:** **Pending** — **not approved** — **Product release decision blocked**

### Product / Codex / Release Engineering question list (Batch D)

Answer **in writing** in future sign-off PRs. **Do not** approve Build `4` or upload in this review.

#### Rollback (Gate 8 — Codex + Release Engineering + Product)

1. What **post-spike regression tests** prove M2 guided placement remains reachable (G8-1, G8-6)? *(spike test plan)*
2. Who **signs off** that `fetch_local_model.sh` and `push_local_model_to_device.sh` still work after spike merges (G8-2, G8-3)?
3. Where is the **rollback runbook** published, and what are the step-by-step ops for download failure → USB recovery (G8-4, G8-5)?
4. Does spike UI **hide or demote** Place GGUF via Mac, or show both paths equally (G8-7)?
5. What **support copy** directs testers to USB recovery after partial/corrupt download (G8-9)? *(Gate 5/7 dependency)*

#### Release gate (Gate 9 — Product + Ops)

6. Is **M3 spike** allowed on a branch **without** any TestFlight upload (G9-1)? — expected **yes**; confirm in writing.
7. Under what conditions does Product authorize **Build `4`** / TestFlight upload (G9-2, G9-5)?
8. Are **tag** and **`CFBundleVersion` bump** in scope for first download UX ship, or deferred (G9-3, G9-4)?
9. What **tester-facing message** explains optional ~400 MB download vs Mac + USB fallback (G9-7)?
10. Does shipping download UX require **ASC export** or **privacy label** updates (G9-6)? *(Gate 3 dependency)*
11. For Gate **9 Ready**, does sign-off mean **“Build `4` still not approved”** or **“Build `4` approved to proceed”** (G9-8)?

**Blocked-by summary:** Gate **8 Ready** requires **M3 spike test plan** (G8-6). Gate **9 Ready** requires **Product release decision** (G9-1–G9-5). Gate **9** ASC items still require release-time Product/Legal/RE confirmation (G9-6).

### Batch D review exit (not yet met)

| Criterion | Met? |
| --- | --- |
| Open items documented | **Yes** (this section) |
| Stakeholder questions issued | **Yes** (above) |
| Batches **A–D** review documented | **Yes** |
| Gates 8–9 marked **Ready** | **No** |
| Rollback runbook published | **No** |
| Spike regression test plan | **No** — **blocked** |
| Build `4` / TestFlight approved | **No** |
| M3 spike approved | **No** |

**Next docs-only step:** Record real Batch **B** answers (Q-B-01…Q-B-11) in the [M3 gate answer intake ledger](./qwon_m3_gate_answer_intake.md), using Gate **2** byte size and SHA-256 where needed. After all Batch B answers exist, open a Gates **4–5** Ready sign-off PR — still docs-only, still **not** implementation. M3 spike remains **forbidden** until **all nine** gates Ready.

---

All of the following must be true **before** Codex scopes an M3 downloader spike PR:

| # | Criterion |
| --- | --- |
| 1 | Batches **A → B → C → D** reviewed in order (or documented exception with Product ack) |
| 2 | Checklist rows **1–9** each **Ready** with linked sign-off evidence |
| 3 | [Exit criteria in UX plan](./qwon_model_download_gguf_ux_plan.md#exit-criteria-to-open-m3-spike-future) satisfied |
| 4 | **Separate** Product decision if any TestFlight binary ships download UX (Gate 9 / Build `4`) |

**This review plan alone satisfies none of the above.**

---

## Suggested review schedule (Product/Codex — optional)

| Step | Activity | Output |
| --- | --- | --- |
| 1 | Batch **A** review session | Action items for Gates 1–3; legal ticket if needed |
| 2 | Batch **B** review session | Threshold + integrity spec draft for sign-off PR |
| 3 | Batch **C** review session | Final copy list; M2 migration checklist |
| 4 | Batch **D** review session | Rollback runbook + Build `4` stance |
| 5 | **Gate Ready sign-off PR(s)** | Checklist row updates — **still docs-only** |
| 6 | Codex **M3 spike plan** PR | Implementation scope — **only after step 5** |

---

## Explicit non-approvals

| Item | Status |
| --- | --- |
| Mark any gate **Ready** in this PR | **No** |
| M3 Swift / downloader implementation | **Not approved** |
| Build `4` / TestFlight upload / tag / version bump | **Not approved** |
| GGUF / logs / screenshots commit | **Not approved** |

---

## Evidence boundaries (this PR)

| Included | Excluded |
| --- | --- |
| Review batch order A–D | Gate Ready sign-off |
| Owners, evidence, exit criteria per batch | Implementation PR |
| Links from queue + UX plan | Checklist status changes |
