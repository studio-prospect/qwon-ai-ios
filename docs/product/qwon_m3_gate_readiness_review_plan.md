# QWON — M3 Gate Readiness Review Plan

**Last updated:** 2026-06-05 (Batch A–C review documented — all gates Pending)
**Status:** **Review plan only** — **not** gate Ready sign-off, **not** M3 implementation approval, **not** Build `4` approval.
**Purpose:** Define **review order**, **owners**, **required evidence**, and **exit criteria** for moving M3 checklist Gates **1–9** from **Pending** to **Ready**. Evidence memos exist ([#91](https://github.com/studio-prospect/qwon-ai-ios/pull/91)–[#95](https://github.com/studio-prospect/qwon-ai-ios/pull/95)); this plan does **not** mark any gate **Ready**.

Related: [M3 readiness checklist](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) · [Queue — M3 status](./qwon_next_work_queue.md#m3-readiness-status-2026-06-05) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

---

## Current state (unchanged by this plan)

| Field | Value |
| --- | --- |
| **Gates 1–9** | Evidence memos linked — **all Pending** |
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

**All batches:** current disposition **Pending** — this plan does **not** change checklist rows.

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
| **Status** | **Pending** |
| **Ready?** | **No** |
| **Batch A review (docs-only)** | **Documented** — [2026-06-05 session](#batch-a-review-session-2026-06-05) — open items + Product/legal questions; **does not** mark Ready |

---

## Batch A review session (2026-06-05)

**Type:** Docs-only readiness review — **not** gate Ready sign-off, **not** legal approval, **not** hosting/checksum final values.

**Outcome:** Gate **1–3** open items **concretized** below. Checklist rows remain **Pending**. Next step: Product/legal answers → future **Batch A Ready sign-off** docs-only PR.

Related evidence: [Hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md#batch-a-review-status-2026-06-05) · [Compliance memo](./qwon_m3_model_distribution_compliance_memo.md#batch-a-review-status-2026-06-05)

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

**Gate 1 status:** **Pending** — **not Ready**

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

**Gate 2 status:** **Pending** — **not Ready**

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

**Gate 3 status:** **Pending** — **needs product/legal confirmation** — **not Ready**

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

### Batch A review exit (not yet met)

| Criterion | Met? |
| --- | --- |
| Open items documented | **Yes** (this section) |
| Product/legal questions issued | **Yes** (above) |
| Gates 1–3 marked **Ready** | **No** |
| Final hosting URL decided | **No** |
| Final SHA-256 / byte size published | **No** |
| Legal sign-off recorded | **No** |
| M3 spike approved | **No** |
| Build `4` approved | **No** |

**Next docs-only step:** Batch **B** review session (Gates 4–5) may proceed in parallel **only for planning** — Batch B **Ready** still blocked on Gate 2 final byte size. Recommended order: obtain Batch A answers → Batch A Ready sign-off PR → then Batch B review.

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
| **Status** | **Pending** |
| **Ready?** | **No** |
| **Batch B review (docs-only)** | **Documented** — [2026-06-05 session](#batch-b-review-session-2026-06-05) — open items + Product/Codex questions; **does not** mark Ready |
| **Batch A blocked** | Gate **4–5 Ready** blocked on Gate **2** final byte size (and Gate **1** artifact) until Batch A sign-off |

---

## Batch B review session (2026-06-05)

**Type:** Docs-only readiness review — **not** gate Ready sign-off, **not** final threshold/temp path decisions, **not** downloader implementation.

**Outcome:** Gate **4–5** open items **concretized** below. Checklist rows remain **Pending**. Several items are **Batch A blocked** until Gate **2** publishes exact byte size.

Related evidence: [Storage + integrity memo — Batch B status](./qwon_m3_storage_integrity_memo.md#batch-b-review-status-2026-06-05)

### Gate 4 — Open items (storage budget / available-space check)

| # | Open item | Current state | Blocks Ready until |
| --- | --- | --- | --- |
| G4-1 | **Minimum free-space threshold (bytes)** | **Undecided** — planning range ~379–400 MB artifact only | **Batch A blocked:** Gate **2** exact byte size + temp peak model |
| G4-2 | **Pre-download sandbox capacity check** | Required in principle — **API choice undecided** (`volumeAvailableCapacityForImportantUsage` vs equivalent) | Codex documents check timing (before URLSession start) |
| G4-3 | **Temp peak size assumption** | Undecided: ~1× artifact (temp then replace) vs ~2× (temp + existing partial) | Gate **5** temp strategy; feeds G4-1 math |
| G4-4 | **Safety margin above artifact + peak** | Fixed MB vs % vs tier-specific — **undecided** | Product policy |
| G4-5 | **Mid-download space exhaustion** | Abort vs pause vs resume — **undecided** | Gate **5** resume policy |
| G4-6 | **User-visible insufficient-space copy** | **Undecided** — no approved Settings/alert strings | Product copy owner |
| G4-7 | **Matisse / low-storage devices** | Download must not pressure install ([Gate 7](./qwon_m3_network_device_expectation_memo.md)) | Product: hide vs de-emphasize download on A12 |
| G4-8 | **Re-check after failed download** | Undecided whether to re-query capacity on retry | Codex + Product |
| G4-9 | **Lookup order / final path** | `Documents/Models/prexus-local-mvp.gguf` — **unchanged** | Confirm no schema migration in M3 spike |

**Gate 4 status:** **Pending** — **not Ready** — **Batch A blocked** on G4-1 until Gate **2** final byte size

### Gate 5 — Open items (partial download / integrity)

| # | Open item | Current state | Blocks Ready until |
| --- | --- | --- | --- |
| G5-1 | **Temp filename / path** | Examples only (`.part`, `.downloading`, `tmp/`) — **not selected** | Product/Codex pick one strategy |
| G5-2 | **Runtime must not load temp file** | Required direction — enforcement mechanism **undecided** | Codex: placement resolver ignores non-final names |
| G5-3 | **Atomic move to final path** | Required direction — `rename` vs copy+delete **undecided** | Codex spec; must land at `prexus-local-mvp.gguf` |
| G5-4 | **Verify before promote** | Size + SHA-256 on temp — **Batch A blocked:** Gate **2** values | Gate **2** Ready |
| G5-5 | **Resume vs clean retry** | **Undecided** — full restart vs HTTP Range vs URLSession background | Product scope for M3 spike; Gate **1** server support if Range |
| G5-6 | **Partial file cleanup on failure** | Delete temp vs quarantine — **undecided** | Codex policy; must not leave final path at partial size |
| G5-7 | **Corrupt hash mismatch handling** | Fallback without crash — **undecided** quarantine vs delete | Align with [integrity states](./qwon_model_download_gguf_ux_plan.md#integrity-and-storage-requirements) |
| G5-8 | **Existing verified file on retry** | Must not overwrite without user action — deletion UX **not approved** | Product decision |
| G5-9 | **Diagnostics mapping — `partial`** | Direction in memo — **no final field names/copy** | Product + Codex strings |
| G5-10 | **Diagnostics mapping — `corrupt`** | `primary_failure` / `fallback_reason` alignment **undecided** for download failures | Codex spec tied to Gate **7** |
| G5-11 | **Settings → Local Runtime in-progress UI** | Must not show “installed” during download — **copy undecided** | Gate **6** overlap; Product |
| G5-12 | **M2 USB-placed unverified files** | M1 **Present (unverified)** today — **Batch A blocked:** Gate **2-7** legacy policy | Batch A Gate **2** answer |

**Gate 5 status:** **Pending** — **not Ready**

### Product / Codex question list (Batch B — answer to unblock Ready sign-off)

Answer **in writing** in a future sign-off PR. Do **not** publish final threshold bytes or temp path in this review.

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

**Batch A blocked items (do not finalize in Batch B alone):** G4-1 threshold math, G5-4 verify constants, G5-12 legacy file policy — require Gate **2** (and Gate **1** artifact) from Batch A sign-off.

### Batch B review exit (not yet met)

| Criterion | Met? |
| --- | --- |
| Open items documented | **Yes** (this section) |
| Product/Codex questions issued | **Yes** (above) |
| Gates 4–5 marked **Ready** | **No** |
| Final minimum free-space threshold | **No** |
| Final temp filename/path | **No** |
| Gate 2 byte size available | **No** — **Batch A blocked** |
| M3 spike approved | **No** |
| Build `4` approved | **No** |

**Next docs-only step:** Batch **C** review (Gates 6–7) may proceed for planning. Batch **B Ready** sign-off waits on Batch **A** Gate **2** answers + Batch B question answers above.

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
| G6-7 | **App Store privacy label impact** | **Undecided** — **Gate 3 blocked** | Legal/Product ASC review ([compliance memo](./qwon_m3_model_distribution_compliance_memo.md#app-store--testflight--export-compliance)) |
| G6-8 | **Export compliance questionnaire (network download)** | App TLS documented — model download angle **unreviewed** | **Gate 3 blocked** |
| G6-9 | **TestFlight tester notes** | Undecided — separate from in-app copy | Product / release comms |
| G6-10 | **In-progress download visibility** | Progress UI copy **undecided**; no hidden retry loops (principle) | Codex + Product |
| G6-11 | **Wi‑Fi vs cellular disclosure** | Draft A mentions cellular — **not approved** | Product policy |
| G6-12 | **First-launch fetch prohibition** | Product rule documented — enforcement spec **undecided** | Codex |

**Gate 6 status:** **Pending** — **not Ready** — **Gate 3 blocked** on G6-7, G6-8

### Gate 7 — Open items (Wang / Matisse device expectation)

| # | Open item | Current state | Blocks Ready until |
| --- | --- | --- | --- |
| G7-1 | **Wang optional download framing** | Draft in memo — **not approved** | Product |
| G7-2 | **Matisse heuristic expected copy** | M1/M2 aligned drafts — **not approved** | Product |
| G7-3 | **Download visibility by tier** | Undecided: Wang-only entry vs Matisse de-emphasized vs hidden | Product hardware policy |
| G7-4 | **Matisse must not read as device failure** | Principle documented — final strings **undecided** | Product |
| G7-5 | **Post-download Matisse runtime expectation** | Heuristic remains expected even if GGUF present — copy **undecided** | Product + Codex |
| G7-6 | **Diagnostics — `answered_by` mapping** | Reference table in memo — M3 download states **Gate 5 blocked** | Gate **5** integrity → UI mapping |
| G7-7 | **Diagnostics — `partial` / in-progress** | Direction in [Gate 5 review](./qwon_m3_gate_readiness_review_plan.md#gate-5--open-items-partial-download--integrity) — **Gate 5 blocked** | Gate **5** Ready |
| G7-8 | **Diagnostics — corrupt / failed download** | `primary_failure` / `fallback_reason` for download failures **undecided** | Codex spec; **Gate 5 blocked** |
| G7-9 | **Chat fallback strip copy** | Draft for Wang missing model — **not approved** | Product |
| G7-10 | **Settings model status during download** | Must not show “installed” — overlaps G5-11 — **Gate 5 blocked** | Gate **5** + Product |
| G7-11 | **M2 Place GGUF via Mac coexistence** | Must remain visible — copy priority **undecided** | Product ([Gate 8](./qwon_m3_rollback_release_gate_memo.md)) |
| G7-12 | **Verified vs present-unverified copy** | Ties to Gate **2** verification — **Batch A blocked** | Gate **2** Ready |

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
| Privacy label / ASC answered | **No** — **Gate 3 blocked** |
| M3 spike approved | **No** |
| Build `4` approved | **No** |

**Next docs-only step:** Batch **D** review (Gates 8–9) for planning. Batch **C Ready** sign-off waits on Gate **3** legal input + Gate **5** integrity UI mapping + Product copy answers above.

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

---

## End-to-end exit (M3 spike decision — **not approved**)

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
