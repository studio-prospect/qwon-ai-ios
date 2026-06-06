# QWON — M3 Gate Answer Intake Ledger

**Last updated:** 2026-06-06
**Status:** **Intake ledger** — Batch A answers **Q-A-01…Q-A-13**, Batch B answers **Q-B-01…Q-B-11**, and Batch C answers **Q-C-01…Q-C-14** recorded. Batch A / Gates **1–3**, Batch B / Gates **4–5**, and Batch C / Gates **6–7** have separate Ready sign-offs; Gates **8–9** remain Pending. **Not** M3 implementation approval, **not** Build `4` approval.
**Purpose:** Track **Product / Codex / Legal / Release Engineering** answers to [Batch A–D review questions](./qwon_m3_gate_readiness_review_plan.md) and record what each answer **unblocks** toward a future **gate Ready sign-off PR**.

Related: [Gate readiness review plan](./qwon_m3_gate_readiness_review_plan.md) · [Batch A external questionnaire](./qwon_m3_batch_a_external_questionnaire.md) · [Gate 2 artifact finalization runbook](./qwon_m3_gate2_artifact_finalization_runbook.md) · [M3 checklist](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) · [Queue — M3 status](./qwon_next_work_queue.md#m3-readiness-status-2026-06-05)

---

## How to use this ledger

| Rule | Detail |
| --- | --- |
| **Who answers** | Product, Codex, Legal (via Product), Release Engineering — **not** implementation agents |
| **How to record an answer** | **Separate docs-only PR** after stakeholder provides written response; link PR in **Answer source** and **Follow-up PR** |
| **Do not** | Infer, draft, or commit final hosting URL, SHA-256, legal conclusions, UI copy, or release decisions in this ledger without stakeholder source |
| **Answer recorded ≠ Ready** | Updating a row to **Answered** does **not** mark a checklist gate **Ready** — that requires a dedicated **sign-off PR** |
| **Agents** | May append **real** answers only when Product/legal/release explicitly supplies them; otherwise leave **Unanswered** |

### Gate checklist disposition

| Gate range | Disposition |
| --- | --- |
| **Gates 1–3** | **Ready** — Batch A Ready sign-off recorded 2026-06-06 |
| **Gates 4–5** | **Ready** — Batch B Ready sign-off recorded 2026-06-06 |
| **Gates 6–7** | **Ready** — Batch C Ready sign-off recorded 2026-06-06 |
| **Gates 8–9** | **Pending** — this ledger does not approve downstream release / rollback gates |

---

## Column definitions

| Column | Meaning |
| --- | --- |
| **Question ID** | Stable ID — maps to [review plan](./qwon_m3_gate_readiness_review_plan.md) question lists |
| **Gate** | M3 checklist gate(s) affected |
| **Owner** | Who must answer |
| **Answer status** | `Unanswered` until a real stakeholder response is linked |
| **Answer source** | Memo, email, meeting notes, PR — **empty until answered** |
| **Blocks** | Other questions or gates waiting on this answer |
| **Ready impact** | Which gate **Ready sign-off** needs this answer (sign-off still separate) |
| **Follow-up PR** | PR that recorded the answer and/or gate Ready sign-off — **empty until exists** |

---

## Batch A — Gates 1–3 (hosting / checksum / compliance)

| Question ID | Gate | Owner | Answer status | Answer source | Blocks | Ready impact | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-A-01 | 1 | Product | Answered | [Product answer details](#batch-a-product-answer-details-2026-06-05) | Q-A-02, Q-A-03, Q-A-04; G2-1 | Gate **1** Ready sign-off | This PR |
| Q-A-02 | 1 | Product | Answered | [Product answer details](#batch-a-product-answer-details-2026-06-05) | Q-A-03, Q-A-04, Q-A-05; G1-3 | Gate **1** Ready sign-off | This PR |
| Q-A-03 | 1 | Product | Answered | [Product answer details](#batch-a-product-answer-details-2026-06-05) | Q-A-04, Q-A-06, Q-A-07; G2-1 | Gate **1** + **2** Ready sign-off | This PR |
| Q-A-04 | 1 | Product | Answered | [Product answer details](#batch-a-product-answer-details-2026-06-05) | Q-A-06, Q-A-07; G2-1 | Gate **1** + **2** Ready sign-off | This PR |
| Q-A-05 | 1, 3 | Product, Legal | Answered | [Product answer details](#batch-a-product-answer-details-2026-06-05) | G1-7; Q-A-13 | Gate **1** Ready sign-off | This PR |
| Q-A-06 | 2 | Product, Codex | Answered | [Artifact record details](#batch-a-artifact-record-details-2026-06-06) | Q-B-01; G4-1, G5-4; Batch B threshold | Gate **2** Ready sign-off | This PR |
| Q-A-07 | 2 | Product, Codex | Answered | [Artifact record details](#batch-a-artifact-record-details-2026-06-06) | G5-4; verify-before-promote | Gate **2** Ready sign-off | This PR |
| Q-A-08 | 2 | Product, Codex | Answered | [Legacy USB answer details](#batch-a-legacy-usb-answer-details-2026-06-06) | G5-12; Q-B-11; legacy USB files | Gate **2** Ready sign-off | This PR |
| Q-A-09 | 3 | Legal | Answered | [Legal answer details](#batch-a-legal-answer-details-2026-06-05) | Q-A-10, G1-7 | Gate **3** Ready sign-off | This PR |
| Q-A-10 | 3 | Legal | Answered | [Legal answer details](#batch-a-legal-answer-details-2026-06-05) | G1 hosting model; G3-2 | Gate **3** Ready sign-off | This PR |
| Q-A-11 | 3 | Legal | Answered | [Legal answer details](#batch-a-legal-answer-details-2026-06-05) | G3-3, G3-4 | Gate **3** Ready sign-off | This PR |
| Q-A-12 | 3 | Legal, Product | Answered | [Legal answer details](#batch-a-legal-answer-details-2026-06-05) | Q-C-06; G6-7, G6-8; Q-D-10 | Gate **3** Ready sign-off | This PR |
| Q-A-13 | 3 | Legal | Answered | [Legal answer details](#batch-a-legal-answer-details-2026-06-05) | Q-A-05; G1-7 HF pin | Gate **3** Ready sign-off | This PR |

**Question text:** [Batch A — external questionnaire](./qwon_m3_batch_a_external_questionnaire.md) · [日本語版](./qwon_m3_batch_a_external_questionnaire_ja.md) · [Product / legal question list](./qwon_m3_gate_readiness_review_plan.md#product--legal-question-list-batch-a--answer-to-unblock-ready-sign-off)

### Batch A product answer details (2026-06-05)

**Source:** Product decision in Codex conversation, 2026-06-05.
**Scope:** Product-owned Gate **1** answers only. This records hosting direction and artifact policy for Q-A-01…Q-A-05. It does **not** mark Gates **1–3** Ready, does **not** approve M3 spike, and does **not** approve Build `4`.

| Question ID | Answer |
| --- | --- |
| **Q-A-01** | **Product** is the decision owner for whether QWON may distribute the model artifact. **Release Engineering** is the operational owner for model hosting, including object storage/CDN management, artifact upload/versioning, rollback, and incident response. |
| **Q-A-02** | Approved hosting model: **QWON-owned CDN/object storage**. Third-party URLs may be retained for traceability or dev ops, but the product-facing distribution path should be QWON-owned. |
| **Q-A-03** | Approved artifact direction: **QWON-hosted mirror of the bartowski Qwen2.5-0.5B-Instruct `Q4_K_M` GGUF**, served as the approved M3 artifact. |
| **Q-A-04** | Reproducibility pinning direction: **QWON object key/version ID + SHA-256 + exact byte size**, to be recorded in a later Gate **2** sign-off PR after the hosted object is finalized. |
| **Q-A-05** | Product stance: **No third-party Hugging Face URL for product/tester-facing builds unless Legal explicitly approves HF URL use**. Hugging Face may remain a traceability/source reference, not the default product URL. |

**Ready sign-off:** Gate **1** is **Ready** as part of Batch A sign-off. Gates **4–5** are Ready as part of Batch B sign-off, Gates **6–7** are Ready as part of Batch C sign-off, and Gates **8–9** remain **Pending**.

### Batch A artifact record details (2026-06-06)

**Source:** Release Engineering hosted object verification in Codex conversation, 2026-06-06.
**Scope:** Gate **2** artifact metadata for Q-A-06 and Q-A-07. This records the byte size and SHA-256 for the current QWON-hosted object. It does **not** mark Gate **2** Ready, does **not** approve M3 spike, and does **not** approve Build `4`.

| Field | Value |
| --- | --- |
| **Bucket** | `qwon-094469122222-ap-northeast-1-an` |
| **Object key** | `models/qwen2.5-0.5b-instruct/q4_k_m/prexus-local-mvp.gguf` |
| **LastModified** | `2026-06-06T04:11:44+00:00` |
| **ContentLength / exact byte size** | `397808192` |
| **ETag** | `"9027dfcbb8ab4852ad705c35c6c3ce29-48"` |
| **ServerSideEncryption** | `AES256` |
| **ContentType** | `binary/octet-stream` |
| **SHA-256** | `6eb923e7d26e9cea28811e1a8e852009b21242fb157b26149d3b188f3a8c8653` |
| **Verification repeat** | Hosted object downloaded to `/tmp/qwon-hosted-prexus-local-mvp.gguf`; `stat -f%z` returned `397808192`; `shasum -a 256` returned the SHA-256 above. |

| Question ID | Answer |
| --- | --- |
| **Q-A-06** | Exact expected byte size is `397808192` bytes for hosted object `s3://qwon-094469122222-ap-northeast-1-an/models/qwen2.5-0.5b-instruct/q4_k_m/prexus-local-mvp.gguf`. |
| **Q-A-07** | SHA-256 is `6eb923e7d26e9cea28811e1a8e852009b21242fb157b26149d3b188f3a8c8653` for the same hosted object. |

**Ready sign-off:** Gate **2** is **Ready** as part of Batch A sign-off. Download temp/atomic verification mechanics remain Gate **5**.

### Batch A legacy USB answer details (2026-06-06)

**Source:** Codex/Product policy decision in Codex conversation, 2026-06-06.
**Scope:** Gate **2** legacy USB policy for Q-A-08 only. This preserves the M2 manual placement contract while M3 remains gated. It does **not** mark Gate **2** Ready, does **not** approve M3 spike, and does **not** approve Build `4`.

| Question ID | Answer |
| --- | --- |
| **Q-A-08** | Existing USB-placed `Documents/Models/prexus-local-mvp.gguf` files remain supported as **present-unverified** until a user or support workflow explicitly replaces them. M3 download must **not** silently overwrite an existing USB-placed GGUF. A future verified download may replace the file only through explicit user action or a documented support/recovery flow. If verification fails, the app should keep or return to the M2 **Place GGUF via Mac** rollback path instead of blocking manual recovery. |

**Ready sign-off:** Gate **2** is **Ready** as part of Batch A sign-off. Replacement consent / recovery details remain Gate **5**.

### Batch A legal answer details (2026-06-05)

**Source:** Legal approval of the recommended draft in Codex conversation, 2026-06-05.
**Scope:** Legal-owned Gate **3** answers for Q-A-09…Q-A-13. This records compliance direction for the selected QWON-hosted model distribution path. It does **not** mark Gates **1–3** Ready, does **not** approve M3 spike, and does **not** approve Build `4`.

| Question ID | Answer |
| --- | --- |
| **Q-A-09** | **Yes, with Apache-2.0 obligations preserved.** Qwen2.5-0.5B-Instruct is treated as Apache-2.0 for this use, so QWON may facilitate user-device model download through the app if license obligations are preserved. |
| **Q-A-10** | **Conditionally yes.** QWON may mirror or self-host the bartowski `Q4_K_M` GGUF after confirming it follows the Qwen Apache-2.0 license path. Product-facing builds should not rely on Hugging Face direct download URLs by default. |
| **Q-A-11** | QWON should include in-app / docs attribution identifying Qwen2.5-0.5B-Instruct by Qwen, bartowski Qwen2.5-0.5B-Instruct-GGUF as the quantization source, Apache License 2.0, and upstream model card / license links. Any upstream NOTICE or additional attribution terms should be preserved. |
| **Q-A-12** | Product / Legal / App Store Connect re-check is required before any TestFlight or product-facing build with in-app model download. App HTTPS/TLS answers and model weight distribution should be treated as separate compliance surfaces; existing export/privacy answers should not be assumed sufficient. |
| **Q-A-13** | Hugging Face URLs may remain in docs for traceability / source reference unless a ToS issue is identified later. Hugging Face URLs should not be the product-facing download endpoint unless explicitly approved for that use. QWON-owned hosting remains the recommended product path. |

**Ready sign-off:** Gate **3** is **Ready** as part of Batch A sign-off. ASC/export re-check before a product-facing download build remains Gate **9** / release work.

---

## Batch B — Gates 4–5 (storage / integrity)

| Question ID | Gate | Owner | Answer status | Answer source | Blocks | Ready impact | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-B-01 | 4 | Product, Codex | Answered | [Batch B answer details](#batch-b-storage-and-integrity-answer-details-2026-06-06) | Gate 4 threshold sign-off | Gate **4** Ready sign-off | This PR |
| Q-B-02 | 4, 5 | Product, Codex | Answered | [Batch B answer details](#batch-b-storage-and-integrity-answer-details-2026-06-06) | Q-B-01; G4-3 | Gate **4** Ready sign-off | This PR |
| Q-B-03 | 4 | Product | Answered | [Batch B answer details](#batch-b-storage-and-integrity-answer-details-2026-06-06) | Q-B-01 | Gate **4** Ready sign-off | This PR |
| Q-B-04 | 4 | Product | Answered | [Batch B answer details](#batch-b-storage-and-integrity-answer-details-2026-06-06) | — | Gate **4** Ready sign-off | This PR |
| Q-B-05 | 4, 7 | Product | Answered | [Batch B answer details](#batch-b-storage-and-integrity-answer-details-2026-06-06) | Q-C-09 | Gate **4** + **7** Ready sign-off | This PR |
| Q-B-06 | 4, 5 | Product, Codex | Answered | [Batch B answer details](#batch-b-storage-and-integrity-answer-details-2026-06-06) | Q-B-08 | Gate **4** + **5** Ready sign-off | This PR |
| Q-B-07 | 5 | Codex, Product | Answered | [Batch B answer details](#batch-b-storage-and-integrity-answer-details-2026-06-06) | G5-1; G8-6 indirect | Gate **5** Ready sign-off | This PR |
| Q-B-08 | 5 | Product, Codex | Answered | [Batch B answer details](#batch-b-storage-and-integrity-answer-details-2026-06-06) | Q-B-06; G5-5 | Gate **5** Ready sign-off | This PR |
| Q-B-09 | 5 | Codex | Answered | [Batch B answer details](#batch-b-storage-and-integrity-answer-details-2026-06-06) | G5-6, G5-7; Q-C-12 | Gate **5** Ready sign-off | This PR |
| Q-B-10 | 5, 6, 7 | Product, Codex | Answered | [Batch B answer details](#batch-b-storage-and-integrity-answer-details-2026-06-06) | Q-C-12; G7-6–G7-8 | Gate **5** + **7** Ready sign-off | This PR |
| Q-B-11 | 5 | Product, Codex | Answered | [Batch B answer details](#batch-b-storage-and-integrity-answer-details-2026-06-06) | Q-A-08 answered; replacement consent / recovery details | Gate **5** Ready sign-off | This PR |

**Question text:** [Batch B — Product / Codex question list](./qwon_m3_gate_readiness_review_plan.md#product--codex-question-list-batch-b--answer-to-unblock-ready-sign-off)

### Batch B storage and integrity answer details (2026-06-06)

**Source:** Product/Codex policy decision in Codex conversation, 2026-06-06.
**Scope:** Gate **4–5** answers only. This records storage threshold, temp-file, retry, cleanup, diagnostics, and replacement policy for Q-B-01…Q-B-11. Gates **4–5** are marked Ready in the separate [Batch B Ready sign-off](./qwon_m3_gate_readiness_review_plan.md#batch-b-ready-sign-off-2026-06-06). This does **not** approve M3 spike and does **not** approve Build `4`.

| Question ID | Answer |
| --- | --- |
| **Q-B-01** | Minimum free bytes before M3 download start: **`1064051840` bytes**. Formula: Gate 2 artifact size `397808192` × **2** temp peak + **256 MiB** (`268435456`) safety margin. |
| **Q-B-02** | Temp peak model: **~2× artifact size**. M3 should budget for an existing final file plus a temp download file before atomic promotion or explicit replacement. |
| **Q-B-03** | Safety margin policy: **fixed 256 MiB** for the M3 spike/readiness gate. Do not use percentage or device-tier-specific margin until evidence shows a need. |
| **Q-B-04** | Insufficient-space copy direction: explain that QWON needs about **1.1 GB free** to safely prepare the local model, does not delete user data, and the user can free space or continue with **Place GGUF via Mac** / fallback behavior. |
| **Q-B-05** | Matisse / A12 behavior: **de-emphasize** download. Do not show Matisse as failed and do not make download a primary required action; Embedded Heuristic Runtime remains expected. |
| **Q-B-06** | Mid-download space exhaustion: **abort and clean retry** for M3. Do not attempt pause/resume recovery in the first spike. Re-check available capacity before retry. |
| **Q-B-07** | Temp filename/path: `Documents/Models/prexus-local-mvp.gguf.download`. Runtime placement must continue resolving only the final `Documents/Models/prexus-local-mvp.gguf` path. |
| **Q-B-08** | HTTP Range resume is **not required** for M3. Use **clean restart only** after failure/cancel. Resume can be reconsidered after downloader evidence exists. |
| **Q-B-09** | Verification failure handling: delete the temp `.download` file after hash/size mismatch or failed download. Keep any previous final GGUF untouched; fall back to existing runtime behavior and M2 guided placement. |
| **Q-B-10** | Diagnostics / Settings mapping: `partial` = temp/incomplete file present and not installed; `corrupt` = size/hash mismatch and temp removed or final rejected; `in-progress` = download preparation active and not installed. Surfaces must not report llama.cpp readiness until final file verifies and loads. |
| **Q-B-11** | A new download must **not** silently replace an existing USB-placed `present-unverified` GGUF. Replacement requires explicit user action in a future approved UX or documented support/recovery flow. M2 Mac + USB rollback remains valid. |

**Ready sign-off:** Gates **4–5** are **Ready** as part of Batch B sign-off. Network disclosure, device expectation, rollback, and release gates remain Gates **6–9**.

---

## Batch C — Gates 6–7 (network disclosure / device expectation)

| Question ID | Gate | Owner | Answer status | Answer source | Blocks | Ready impact | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-C-01 | 6 | Product | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | Gate 6 disclosure sign-off | Gate **6** Ready sign-off | This PR |
| Q-C-02 | 6 | Product | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | G6-3 | Gate **6** Ready sign-off | This PR |
| Q-C-03 | 6 | Product | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | G6-4 | Gate **6** Ready sign-off | This PR |
| Q-C-04 | 6 | Product | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | G6-5; M2 migration | Gate **6** Ready sign-off | This PR |
| Q-C-05 | 6 | Product | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | G6-6 | Gate **6** Ready sign-off | This PR |
| Q-C-06 | 6, 3 | Legal, Product | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | Gate **3** Ready; ASC/privacy-label re-check direction recorded | Gate **6** Ready sign-off | This PR |
| Q-C-07 | 6, 9 | Product | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | G6-9; tester comms | Gate **6** Ready sign-off | This PR |
| Q-C-08 | 6 | Product | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | G6-11 | Gate **6** Ready sign-off | This PR |
| Q-C-09 | 7 | Product | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | G7-3; Q-B-05 | Gate **7** Ready sign-off | This PR |
| Q-C-10 | 7 | Product | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | G7-2, G7-4 | Gate **7** Ready sign-off | This PR |
| Q-C-11 | 7 | Product, Codex | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | G7-5 | Gate **7** Ready sign-off | This PR |
| Q-C-12 | 7, 5 | Codex, Product | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | Gate **5** Ready; device/copy mapping recorded | Gate **7** Ready sign-off | This PR |
| Q-C-13 | 7 | Product | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | G7-9 | Gate **7** Ready sign-off | This PR |
| Q-C-14 | 7, 8 | Product | Answered | [Batch C answer details](#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) | G7-11; Q-D-04 | Gate **7** + **8** Ready sign-off | This PR |

**Question text:** [Batch C — Product / Codex question list](./qwon_m3_gate_readiness_review_plan.md#product--codex-question-list-batch-c--answer-to-unblock-ready-sign-off)

### Batch C network disclosure and device expectation answer details (2026-06-06)

**Source:** Product/Codex policy decision in Codex conversation, 2026-06-06.
**Scope:** Gate **6–7** answers only. This records disclosure, user-initiated download, local-first positioning, M2 copy transition, ASC/privacy review direction, device-tier visibility, Matisse expectations, Diagnostics copy mapping, and M2 guided placement coexistence for Q-C-01…Q-C-14. Gates **6–7** are marked Ready in the separate [Batch C Ready sign-off](./qwon_m3_gate_readiness_review_plan.md#batch-c-ready-sign-off-2026-06-06). This does **not** approve M3 spike and does **not** approve Build `4`.

| Question ID | Answer |
| --- | --- |
| **Q-C-01** | Pre-download disclosure must appear before any network fetch and require explicit user action. Approved direction: “Download the local model (~400 MB) to this iPhone. QWON uses the network for this one-time model download; local chats can run on device after the model is installed.” |
| **Q-C-02** | M3 download is **user-initiated foreground only**. No first-launch fetch, no surprise background fetch, and no background URLSession policy for the first M3 spike. |
| **Q-C-03** | Local-first positioning: QWON is **local-first, not offline-only**. Network use is for model acquisition; after verified install, the local route runs on device when supported. |
| **Q-C-04** | M2 copy transition: replace “QWON does not download the GGUF in-app” only in builds that actually include download UX. Keep **Place GGUF via Mac** as a fallback path and preserve M2 docs for build `3`. |
| **Q-C-05** | Onboarding disclosure is **Settings-first** for M3. Do not add persistent first-launch onboarding unless a later Product gate asks for it. |
| **Q-C-06** | Gate **3** legal direction is sufficient for planning, but any build shipping download UX must perform release-time ASC/privacy/export re-check. This answer does **not** change privacy labels by itself. |
| **Q-C-07** | TestFlight notes for any download build must say the local model download is optional, about 400 MB, user-initiated, and Build `4` remains separately gated. |
| **Q-C-08** | Copy should mention **Wi-Fi recommended** and that cellular may use data if the user chooses to proceed. Do not auto-restrict to Wi-Fi in docs until implementation evidence exists. |
| **Q-C-09** | Download entry point is **Wang-primary**. Matisse may show de-emphasized guidance or status copy, but must not be pressured to download. |
| **Q-C-10** | Matisse copy must explicitly state Embedded Heuristic Runtime is expected and not a failure for this alpha. |
| **Q-C-11** | If a GGUF is present on Matisse, copy must still say llama.cpp is not guaranteed on that hardware tier; Embedded Heuristic may remain the expected runtime. |
| **Q-C-12** | Diagnostics mapping: `partial` = model download not installed yet; `corrupt` = verification failed and fallback remains available; success on Wang = `llama.cpp On-Device Runtime`; success/missing on Matisse may still show `Embedded Heuristic Runtime` as expected. |
| **Q-C-13** | Chat fallback strip direction for Wang missing/corrupt model: “Local model not ready — answered with built-in fallback. Install the local model from Settings → Local Runtime.” Final wording can be polished in implementation PR, but must preserve that meaning. |
| **Q-C-14** | **Place GGUF via Mac** remains visible as the manual fallback and support path. Download UX must be additive, not a replacement. Gate **8** still owns formal rollback readiness. |

**Ready sign-off:** Gates **6–7** are **Ready** as part of Batch C sign-off. Rollback and release gates remain Gates **8–9**.

---

## Batch D — Gates 8–9 (rollback / release)

| Question ID | Gate | Owner | Answer status | Answer source | Blocks | Ready impact | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-D-01 | 8 | Codex | Unanswered | — | G8-6; **spike test plan blocked** | Gate **8** Ready sign-off | — |
| Q-D-02 | 8 | Release Engineering | Unanswered | — | G8-2, G8-3 | Gate **8** Ready sign-off | — |
| Q-D-03 | 8 | Codex, RE | Unanswered | — | G8-4, G8-5 | Gate **8** Ready sign-off | — |
| Q-D-04 | 8, 7 | Product, Codex | Unanswered | — | G8-7; Q-C-14 | Gate **8** Ready sign-off | — |
| Q-D-05 | 8, 5, 7 | Product | Unanswered | — | G8-9; Q-B-09 | Gate **8** Ready sign-off | — |
| Q-D-06 | 9 | Product | Unanswered | — | G9-1; M3 spike vs TestFlight | Gate **9** disposition (not Build `4` approval by default) | — |
| Q-D-07 | 9 | Product | Unanswered | — | G9-2, G9-5; **Product release decision blocked** | Gate **9** / Build `4` gate | — |
| Q-D-08 | 9 | Product | Unanswered | — | G9-3, G9-4 | Gate **9** / Build `4` gate | — |
| Q-D-09 | 9 | Product | Unanswered | — | G9-7 | Gate **9** Ready sign-off | — |
| Q-D-10 | 9, 3 | Ops, Legal | Unanswered | — | G9-6; Gate **3** Ready; release-time ASC/export re-check still required | Gate **9** Ready sign-off | — |
| Q-D-11 | 9 | Product | Unanswered | — | G9-8; sign-off PR format | Gate **9** Ready sign-off | — |

**Question text:** [Batch D — stakeholder question list](./qwon_m3_gate_readiness_review_plan.md#product--codex--release-engineering-question-list-batch-d)

---

## Summary (current)

| Batch | Questions | Answered | Gates |
| --- | --- | --- | --- |
| **A** | 13 | **13** | 1–3 — **Ready** |
| **B** | 11 | **11** | 4–5 — **Ready** |
| **C** | 14 | **14** | 6–7 — **Ready** |
| **D** | 11 | **0** | 8–9 — **Pending** |
| **Total** | **49** | **38** | Gates **1–7 Ready**; Gates **8–9 Pending** |

---

## Path to Ready sign-off (after answers exist)

| Step | Action | Owner |
| --- | --- | --- |
| 1 | Stakeholder provides **written** answer | Product / Legal / Codex / RE |
| 2 | **Answer intake PR** — update row(s) in this ledger only | Docs agent |
| 3 | When **all** questions for a batch are **Answered**, open **batch Ready sign-off PR** | Product + Codex |
| 4 | Sign-off PR updates checklist row(s) to **Ready** with linked evidence. Batches **A/B** are complete; next candidate is Batch **C** Ready sign-off after Q-C answers. | Product + Codex |
| 5 | When **all nine** gates **Ready**, Codex may scope **M3 spike plan** | Codex |

**M3 spike** and **Build `4`** remain **not approved** until step 5 and separate Gate **9** / Product release decisions respectively.

---

## Evidence boundaries (this PR)

| Included | Excluded |
| --- | --- |
| Question ID ledger (49 rows) | Fabricated answers |
| Batch A Product answers Q-A-01…Q-A-05 | M3 implementation approval |
| Batch A artifact answers Q-A-06…Q-A-07 | M3 implementation approval |
| Batch A Codex/Product legacy USB answer Q-A-08 | M3 implementation approval |
| Batch A Legal answers Q-A-09…Q-A-13 | M3 implementation approval |
| Batch B Product/Codex answers Q-B-01…Q-B-11 | M3 implementation approval |
| Batch C Product/Codex answers Q-C-01…Q-C-14 | M3 implementation approval |
| Workflow for future answer PRs | Gate Ready sign-off |
| Ready impact mapping | Final URL / SHA / legal / UI / release values |
| Gates **8–9 Pending** | Swift, spike, TestFlight upload |
