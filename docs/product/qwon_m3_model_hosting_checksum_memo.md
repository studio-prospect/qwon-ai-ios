# QWON — M3 Model Hosting + Checksum Memo (Gates 1 & 2)

**Last updated:** 2026-06-06 (Batch A sign-off — Gates 1–2 Ready)
**Status:** **Evidence memo** — Gates **1–2 Ready** for M3 readiness tracking; **not** M3 implementation approval, **not** Build `4` approval.
**Purpose:** Document open **hosting / URL ownership** (Gate 1) and **SHA-256 / byte size** (Gate 2) questions for a future **M3 in-app download** spike of `prexus-local-mvp.gguf`. Gate 1 and Gate 2 are coupled: the approved source artifact defines which checksum policy applies.

Related: [M3 readiness checklist — Gates 1 & 2](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) · [Batch A review](./qwon_m3_gate_readiness_review_plan.md#batch-a-review-session-2026-06-05) · [Gate 2 artifact finalization runbook](./qwon_m3_gate2_artifact_finalization_runbook.md) · [Artifact record template](./qwon_m3_gate2_artifact_record_template.md) · [Gate 3 compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [GGUF UX plan — integrity states](./qwon_model_download_gguf_ux_plan.md#integrity-and-storage-requirements) · [models/README.md](../../models/README.md)

---

## Baseline artifact (unchanged)

| Field | Value |
| --- | --- |
| **On-device filename** | `prexus-local-mvp.gguf` — preserved |
| **Suggested quant** | **Qwen2.5-0.5B-Instruct Q4_K_M** |
| **Placement contract** | `Documents/Models/prexus-local-mvp.gguf` |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — GGUF **not bundled** in shipped binary |
| **Build `4`** | **Not approved** |

---

## Why Gates 1 and 2 are paired

| Gate | Question | Depends on |
| --- | --- | --- |
| **Gate 1** | Who hosts the file? Which HTTPS URL is a **product promise**? | Product/Codex ownership decision; Gate 3 redistribution rights |
| **Gate 2** | What SHA-256 and byte size does the app verify against? | **The exact artifact** Gate 1 serves — third-party HF, QWON-built repack, or CDN mirror may differ |

Changing hosting without re-computing checksum policy causes partial-download false positives and support drift. Treat Gates 1 and 2 as one decision surface until Product publishes a **single approved source artifact**.

---

## Current dev ops fetch (not product hosting)

Engineering today uses `tools/scripts/fetch_local_model.sh` on a developer Mac. This is **operator convenience**, **not** an approved M3 product URL.

| Field | Value |
| --- | --- |
| **HF repo** | [bartowski/Qwen2.5-0.5B-Instruct-GGUF](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF) |
| **Upstream filename** | `Qwen2.5-0.5B-Instruct-Q4_K_M.gguf` |
| **Default resolve URL** | [resolve/main/...Q4_K_M.gguf](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/Qwen2.5-0.5B-Instruct-Q4_K_M.gguf) |
| **Local output** | `models/prexus-local-mvp.gguf` (gitignored; renamed on fetch) |
| **Product promise?** | **No** — unstable third-party URL; no QWON ownership; see [Gate 3 memo](./qwon_m3_model_distribution_compliance_memo.md) |

### Primary upstream links (traceability only)

| Resource | URL |
| --- | --- |
| bartowski model card | [bartowski/Qwen2.5-0.5B-Instruct-GGUF](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF) |
| Q4_K_M artifact (blob view) | [Qwen2.5-0.5B-Instruct-Q4_K_M.gguf](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF/blob/main/Qwen2.5-0.5B-Instruct-Q4_K_M.gguf) |
| Qwen base model (provenance) | [Qwen/Qwen2.5-0.5B-Instruct](https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct) |

---

## Gate 1 — Model hosting source / URL ownership

### Current alpha path (M1/M2)

| Activity | Hosting character |
| --- | --- |
| `fetch_local_model.sh` on Mac | Developer pulls from third-party HF; file lands in repo `models/` |
| `push_local_model_to_device.sh` | USB sideload into sandbox — no QWON CDN |
| TestFlight IPA | **No** model weights in binary |

### M3 would require (all **unconfirmed**)

| Decision | Status |
| --- | --- |
| **Named storage/CDN owner** (Product / release engineering) | Product owns distribution decision; Release Engineering owns storage/CDN operations |
| **QWON-owned URL or contracted CDN path** | QWON-owned object storage/CDN selected |
| **Self-host** vs **mirror bartowski artifact** vs **QWON-built GGUF** | QWON-hosted mirror of bartowski Qwen2.5 `Q4_K_M` GGUF selected |
| **Reproducibility plan** (version pin, immutable object key, rollback URL) | QWON object key + exact byte size + SHA-256 recorded in [answer intake](./qwon_m3_gate_answer_intake.md#batch-a-artifact-record-details-2026-06-06) |
| **Third-party HF URL as in-app fetch target** | **Not approved** as product promise; traceability/dev ops only |

### Hosting options (for Product/Codex review — not a recommendation)

| Option | Gate 1 pros | Gate 1 / 2 risks |
| --- | --- | --- |
| **A. QWON-hosted CDN/object storage** | Stable URL; QWON controls availability and checksum publication | Storage cost; upload pipeline; Gate 3 redistribution still required |
| **B. Pin third-party HF resolve URL in app** | Low ops setup | URL/content drift; no ownership; HF ToS/availability; **not** a product promise today |
| **C. QWON-built artifact from pinned upstream** | Clear provenance under `prexus-local-mvp.gguf` branding | Build/repro pipeline; Gate 2 tied to QWON build output |
| **D. Defer M3 download; keep M2 Mac + USB only** | No hosting gate | Does not satisfy M3 spike goal |

### Gate 1 disposition

| Field | Value |
| --- | --- |
| **Recommended status** | **Ready** |
| **Ready?** | **Yes** |
| **Blocked by** | — |

---

## Gate 2 — SHA-256 checksum and expected byte size

### Policy intent (future M3)

Per [integrity and storage requirements](./qwon_model_download_gguf_ux_plan.md#integrity-and-storage-requirements):

| Metadata | Purpose |
| --- | --- |
| **Expected byte size** | Fast `partial` detection before full hash |
| **SHA-256** | Transition `present-unverified` → `verified` after download/copy |
| **Source label** | Support/debug without exposing unstable URLs in user copy |

**Partial download, resume, temp filename, and atomic move** belong to **Gate 5** — referenced here only; not decided in this memo.

### Final checksum — Ready sign-off input

| Item | Status |
| --- | --- |
| **Published SHA-256 for `prexus-local-mvp.gguf`** | `6eb923e7d26e9cea28811e1a8e852009b21242fb157b26149d3b188f3a8c8653` — recorded in [answer intake ledger](./qwon_m3_gate_answer_intake.md#batch-a-artifact-record-details-2026-06-06) |
| **Published expected byte size for M3 verification** | `397808192` bytes — recorded in [answer intake ledger](./qwon_m3_gate_answer_intake.md#batch-a-artifact-record-details-2026-06-06) |
| **Hosted object identity** | Concrete bucket identity and ETag are kept in ops evidence outside git; public docs retain only the object path class `models/qwen2.5-0.5b-instruct/q4_k_m/prexus-local-mvp.gguf` |
| **In-app verification policy** | Gate **2** values are Ready; temp-file verification timing and atomic promotion remain Gate **5** |

### Observed file sizes (ops evidence — not Gate 2 final)

These sizes come from lab/ops records and upstream listings. **Byte size alone is insufficient for Gate 2 Ready** without a named source artifact and published SHA-256.

| Source | Observed size | Notes |
| --- | --- | --- |
| **Wang device (USB push, 2026-06-03)** | **379.4 MB** | [TestFlight prep](./qwon_text_alpha_testflight_prep.md) · [lab evidence](./qwon_text_alpha_lab_evidence.md) — `Documents/Models/prexus-local-mvp.gguf` |
| **Matisse device (ops push)** | **~379 MB** | [Historical testflight prep](./qwen_text_only_alpha_testflight_prep.md) |
| **bartowski HF listing (Q4_K_M)** | **~0.40 GB / ~398 MB** | [Model card table](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF) — upstream filename, not renamed |
| **models/README default** | **~400 MB** | Rounded engineering estimate |
| **UX plan baseline** | **~379–400 MB** | Range reflects device vs listing variance |

**Inference:** observed sizes cluster around **~379–398 MB** for Q4_K_M content placed as `prexus-local-mvp.gguf`. M3 must pin **one** expected byte size against **one** approved artifact — not a range.

### Ops checksum capture (developers only — not product publication)

After `fetch_local_model.sh` or before USB push, release engineering can capture local evidence:

```bash
# From repo root, after fetch_local_model.sh
shasum -a 256 models/prexus-local-mvp.gguf
stat -f%z models/prexus-local-mvp.gguf
```

| Command | Output use |
| --- | --- |
| `shasum -a 256 models/prexus-local-mvp.gguf` | Compare across Mac fetches **for ops debugging only** — not final Gate 2 value until source artifact is approved |
| `stat -f%z models/prexus-local-mvp.gguf` | Byte size for partial-file checks during ops — not final M3 constant |

Store ops hash/size in `~/QWON-alpha-evidence/` if needed; **do not commit** GGUF or treat ad-hoc hashes as the published M3 checksum.

### Gate 2 disposition

| Field | Value |
| --- | --- |
| **Recommended status** | **Ready** |
| **Ready?** | **Yes** |
| **Blocked by** | — |

---

## Cross-gate dependencies

| Gate | Relationship |
| --- | --- |
| **Gate 1 → Gate 2** | Checksum policy applies to the hosted artifact only |
| **Gate 3 → Gate 1** | Redistribution rights may forbid certain hosting options ([compliance memo](./qwon_m3_model_distribution_compliance_memo.md)) |
| **Gate 5** | Partial/resume/atomic move implementation — see [integrity states](./qwon_model_download_gguf_ux_plan.md#integrity-and-storage-requirements) |
| **Gate 8** | M2 Mac + USB path remains fallback regardless of Gates 1/2 outcome |

---

## Batch A review status (2026-06-06)

**Review:** [Batch A session](./qwon_m3_gate_readiness_review_plan.md#batch-a-review-session-2026-06-05) documented open items; [Batch A Ready sign-off](./qwon_m3_gate_readiness_review_plan.md#batch-a-ready-sign-off-2026-06-06) closed Gates **1–2**.

### Gate 1 — resolved (summary)

| Topic | Status |
| --- | --- |
| Hosting owner | Product distribution decision owner; Release Engineering operational storage/CDN owner |
| Product URL / CDN | `https://models.qwon.dev/models/qwen2.5-0.5b-instruct/q4_k_m/prexus-local-mvp.gguf` selected as the QWON-owned development HTTPS endpoint; DNS/CDN provisioning and live verification remain Release Engineering operations. `qwon.ai` remains reserved for production/marketing use. |
| Artifact pin (bartowski vs QWON-built) | QWON-hosted mirror of bartowski Qwen2.5 `Q4_K_M` GGUF |
| HF URL as product promise | **Not approved** — traceability/dev ops only |

Full item list: [G1-1 … G1-8](./qwon_m3_gate_readiness_review_plan.md#gate-1--open-items-hosting--url-ownership)

### Gate 2 — resolved for checksum / size

| Topic | Status |
| --- | --- |
| Final exact byte size | `397808192` bytes — recorded |
| Published SHA-256 | `6eb923e7d26e9cea28811e1a8e852009b21242fb157b26149d3b188f3a8c8653` — recorded |
| Verification policy | Gate **2** values are Ready; temp verification timing and atomic move remain Gate **5** |
| Gate Ready sign-off | **Ready** — [Batch A Ready sign-off](./qwon_m3_gate_readiness_review_plan.md#batch-a-ready-sign-off-2026-06-06) |

Full item list: [G2-1 … G2-8](./qwon_m3_gate_readiness_review_plan.md#gate-2--open-items-sha-256--byte-size--verification)

---

## Remaining Product / Codex actions after Gates 1/2 Ready

1. Use byte size `397808192` in Batch **B** storage-threshold math.
2. Use SHA-256 `6eb923e7d26e9cea28811e1a8e852009b21242fb157b26149d3b188f3a8c8653` in Batch **B** / Gate **5** verification policy.
3. Keep M2 Mac + USB placement as rollback until Gate **8** is Ready.
4. Do not expose third-party HF URLs as product download promises.

---

## Checklist disposition (Gates 1 & 2)

| Gate | Recommended status | M3 implementation | Build `4` |
| --- | --- | --- | --- |
| **1 — Hosting / URL ownership** | **Ready** | **Not approved** | **Not approved** |
| **2 — SHA-256 / byte size** | **Ready** | **Not approved** | **Not approved** |

---

## Evidence boundaries (this PR)

| Included | Excluded |
| --- | --- |
| Dev ops fetch URL as **not product hosting** | Final production URL approval |
| Observed ops byte sizes (Wang / HF listing) | **Final** published SHA-256 |
| Ops `shasum` / `stat` command reference | GGUF binary commit |
| Gate 5 referenced by link only | Gates 1/2 marked **Ready** |
| Links from M3 checklist | Network fetch / hosting setup |
