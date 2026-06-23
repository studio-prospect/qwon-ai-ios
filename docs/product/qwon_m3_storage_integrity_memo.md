# QWON — M3 Storage + Partial Download Integrity Memo (Gates 4 & 5)

**Last updated:** 2026-06-06 (Batch B / Gates 4–5 Ready)
**Status:** **Evidence memo** — Batch B answers recorded and Gates **4–5** marked **Ready** for readiness tracking; **not** M3 implementation approval, **not** Build `4` approval.
**Purpose:** Document open **iOS storage budget / available-space check** (Gate 4) and **partial download / resume / atomic move** (Gate 5) questions for a future **M3 in-app download** spike of `prexus-local-mvp.gguf`.

Related: [M3 readiness checklist — Gates 4 & 5](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) · [Batch B review](./qwon_m3_gate_readiness_review_plan.md#batch-b-review-session-2026-06-05) · [Integrity states](./qwon_model_download_gguf_ux_plan.md#integrity-and-storage-requirements) · [Gate 1/2 hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md) · [Gate 3 compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [M2 guided placement](./qwon_model_download_gguf_ux_plan.md#pr-m2-post-merge-verification-2026-06-04) · [models/README.md](../../models/README.md)

---

## Baseline artifact (unchanged)

| Field | Value |
| --- | --- |
| **On-device filename** | `prexus-local-mvp.gguf` — preserved |
| **Placement contract** | `Documents/Models/prexus-local-mvp.gguf` — **lookup order unchanged** |
| **Suggested quant** | Qwen2.5-0.5B-Instruct **Q4_K_M** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — GGUF **not bundled**; M2 **Mac + USB** guided placement is the known-good path |
| **Build `4`** | **Not approved** |

---

## Why Gates 4 and 5 are paired

| Gate | Question | Depends on |
| --- | --- | --- |
| **Gate 4** | Is there enough free sandbox space **before** download starts? | Gate 2 expected byte size; temp-file peak during Gate 5 write path |
| **Gate 5** | How is the file written safely so partial bytes never appear as installed? | Gate 4 headroom (temp + atomic move); Gate 2 verification policy |

Gate 4 without Gate 5 risks silent partial files filling Documents. Gate 5 without Gate 4 risks mid-download sandbox exhaustion and corrupt `partial` state.

---

## Model size context (Gate 2 reference)

Gate **2** Ready sign-off records the hosted artifact byte size as **`397808192`** and SHA-256 as **`6eb923e7d26e9cea28811e1a8e852009b21242fb157b26149d3b188f3a8c8653`**. Historical observed ranges remain useful for context only.

| Source | Approximate size |
| --- | --- |
| Wang lab device (USB push) | **~379.4 MB** |
| bartowski HF listing (Q4_K_M) | **~398 MB** |
| Engineering estimate | **~379–400 MB** |

**Gate 4 threshold answer:** M3 should require **`1064051840` bytes** free before download start: `397808192 * 2 + 268435456`.

---

## Gate 4 — iOS storage budget and available-space check

### Requirement (Ready direction)

Any future M3 download must **check available capacity in the app sandbox before starting a network fetch or claiming success**. Do **not** silently fill `Documents/` until the OS rejects the write.

| Requirement | Status |
| --- | --- |
| Pre-download **available-space check** | **Required in principle** — implementation **not approved** |
| **Minimum free-space threshold** (bytes) | **Answered** — `1064051840` bytes before download start |
| User-visible failure when space insufficient | **Answered direction** — explain QWON needs about **1.1 GB free**, does not delete user data, and can fall back to M2 placement / heuristic behavior |
| No silent sandbox fill / no “installed” UX on failure | **Required in principle** |
| Storage schema change | **Not approved** |
| `LocalGGUFModelPlacement` lookup order change | **Not approved** |

### Storage location (unchanged contract)

| Path | Role |
| --- | --- |
| `Documents/Models/prexus-local-mvp.gguf` | Final resolved model path (existing contract) |
| `Documents/Models/` (directory) | Must exist or be created before write; same sandbox as M2 USB push target |

M3 must write into the **same final path** M1/M2 already surface in Settings → Local Runtime. No alternate schema without a separate approved migration.

### Threshold planning answers (Product / Codex)

| Question | Notes |
| --- | --- |
| Base threshold | `397808192 * 2 + 268435456 = 1064051840` bytes |
| Temp-file peak | **~2×** artifact size for M3 planning |
| Safety margin | Fixed **256 MiB** buffer |
| Re-check during download | Abort and clean retry; re-check capacity before retry |
| Matisse / low-storage devices | De-emphasize download; Embedded Heuristic Runtime remains expected |

### Gate 4 disposition

| Field | Value |
| --- | --- |
| **Recommended status** | **Ready** |
| **Ready?** | **Yes** — closed by Batch B Ready sign-off |
| **Blocked by** | — |

---

## Gate 5 — Partial download / resume / atomic move plan

### Integrity state machine (reference)

M3 download/copy must align with [integrity and storage requirements](./qwon_model_download_gguf_ux_plan.md#integrity-and-storage-requirements):

| State | Meaning | M3 download behavior (required direction) |
| --- | --- | --- |
| `missing` | No file at resolved path | Pre-download default; offer download or M2 fallback |
| `partial` | Temp file or byte-size mismatch | **Must not** show as installed; block `verified` UX |
| `present-unverified` | File exists; hash/size not confirmed | Current M1 alpha behavior for USB-placed files |
| `verified` | Hash + size match Gate 2 policy | Wang may use llama.cpp on supported hardware |
| `corrupt` | Hash mismatch or load failure | Fallback without crash; actionable Diagnostics |
| `unsupported-device` | Below required tier | No download pressure; heuristic path expected |

### Temp filename strategy — answered for M3

Any in-app download must use a **non-final temp name** until Gate 2 verification passes, then **atomically** promote to `prexus-local-mvp.gguf`.

| Temp path | Reason |
| --- | --- |
| `Documents/Models/prexus-local-mvp.gguf.download` | Same directory as final path for atomic promotion; non-final name remains outside `LocalGGUFModelPlacement` resolution |

Runtime placement must continue resolving only `Documents/Models/prexus-local-mvp.gguf`.

### Atomic move to final path — **required direction**

| Step | Requirement |
| --- | --- |
| 1 | Stream/download to **temp path** only |
| 2 | Verify **byte size** (Gate 2) and **SHA-256** (Gate 2) on temp file |
| 3 | **Atomic rename/replace** to `Documents/Models/prexus-local-mvp.gguf` |
| 4 | On verification failure | Delete or quarantine temp; **do not** leave partial file at final path |
| 5 | On success | Transition UI/Diagnostics to `verified` (or `present-unverified` if hash check deferred — **not recommended** for M3) |

Lookup order remains: `PREXUS_LOCAL_MODEL_PATH` → bundle → `Documents/Models/prexus-local-mvp.gguf`.

### Clean retry / no partial-as-installed — **required direction**

| Scenario | Required behavior |
| --- | --- |
| User cancels mid-download | Temp removed or marked `partial`; final path unchanged or previous good file retained |
| Download fails (network) | Same — no `prexus-local-mvp.gguf` at partial size presented as installed |
| Retry | Wipe temp and clean restart; re-check available capacity first |
| Existing good file | Retry must not destroy verified file without explicit user action (deletion UX **not approved** for M3 spike unless Product gates it) |

### Resume — clean restart for M3

| Approach | Gate 5 status |
| --- | --- |
| **No resume — clean restart only** | **Selected for M3**; simpler and sufficient for first spike |
| **HTTP Range resume** | Deferred; reconsider after downloader evidence exists |
| **Background URLSession resume** | Deferred; separate from first M3 spike scope |

### Diagnostics and Settings display requirements

When M3 download exists, surfaces must reflect integrity states — extending M1 [Local Runtime status](./qwon_model_download_gguf_ux_plan.md#m1-model-status-ux):

| Surface | `partial` / in-progress | `verified` | `corrupt` / failed |
| --- | --- | --- | --- |
| **Settings → Local Runtime** | Show download in progress or incomplete — **not** “installed” | Model file verified / present per M1 copy patterns | Clear failure + retry or fallback guidance |
| **Runtime Diagnostics** | Include model file state; do not claim llama.cpp path until verified | `answered_by=llama.cpp On-Device Runtime` when load succeeds | `primary_failure` / fallback reason aligned with [diagnostic mapping](./qwon_model_download_gguf_ux_plan.md#diagnostic-mapping) |
| **Chat fallback strip** | Plain language — download incomplete | Unchanged from alpha when verified | Missing/corrupt model explanation; no crash |

Copy must **not** say “Tap to download” until Product approves network UX ([Gate 6](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist)). This memo only defines state display **when** download exists.

### Gate 5 disposition

| Field | Value |
| --- | --- |
| **Recommended status** | **Ready** |
| **Ready?** | **Yes** — closed by Batch B Ready sign-off |
| **Blocked by** | — |

---

## Rollback path — M2 Mac + USB guided placement (maintained)

M3 spike must **not** remove or regress the known-good manual path:

| Fallback | How |
| --- | --- |
| **Settings → Place GGUF via Mac** | M2 guided placement ([M2 section](./qwon_model_download_gguf_ux_plan.md#pr-m2-post-merge-verification-2026-06-04)) |
| **`push_local_model_to_device.sh`** | USB copy to `Documents/Models/prexus-local-mvp.gguf` |
| **`fetch_local_model.sh`** | Mac-side fetch (dev ops; not in-app) |
| **Gate 8 checklist row** | Formal rollback gate — see [M3 checklist Gate 8](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) |

If in-app download fails or the future spike is not approved for ship, testers and support continue on **Build `3` baseline + M2 ops**. Partial or failed M3 download must **not** block manual USB recovery.

---

## Cross-gate dependencies

| Gate | Relationship |
| --- | --- |
| **Gate 2 → Gate 4** | Expected byte size drives minimum space threshold |
| **Gate 2 → Gate 5** | SHA-256 / size verification on temp before atomic promote |
| **Gate 4 ↔ Gate 5** | Temp peak size affects pre-download space check |
| **Gate 6** | Network disclosure copy — separate from storage/integrity mechanics |
| **Gate 7** | Wang/Matisse download expectations |
| **Gate 8** | M2 USB rollback — must remain valid regardless of Gates 4/5 outcome |
| **Gate 9** | Build `4` / TestFlight — **not approved** |

---

## Batch B review status (2026-06-06)

**Review:** [Batch B session](./qwon_m3_gate_readiness_review_plan.md#batch-b-review-session-2026-06-05) documented open items; [answer intake](./qwon_m3_gate_answer_intake.md#batch-b-storage-and-integrity-answer-details-2026-06-06) records Q-B-01…Q-B-11; [Batch B Ready sign-off](./qwon_m3_gate_readiness_review_plan.md#batch-b-ready-sign-off-2026-06-06) marks Gates **4–5** **Ready**.

### Gate 4 — Ready (summary)

| Topic | Status |
| --- | --- |
| Minimum free-space threshold | `1064051840` bytes |
| Sandbox available-capacity check | Required before download starts; exact API/timing remains implementation detail |
| Temp peak size (1× vs 2×) | **~2×** artifact size |
| Insufficient-space user copy | About **1.1 GB free** required; QWON does not delete user data; M2/fallback path remains |

Full item list: [G4-1 … G4-9](./qwon_m3_gate_readiness_review_plan.md#gate-4--open-items-storage-budget--available-space-check)

### Gate 5 — Ready (summary)

| Topic | Status |
| --- | --- |
| Temp filename/path | `Documents/Models/prexus-local-mvp.gguf.download` |
| Resume vs clean retry | Clean restart only for M3; resume deferred |
| Atomic move mechanism | Verify temp before atomic promote to final path |
| Partial/corrupt cleanup | Delete failed temp; keep prior final file untouched |
| Diagnostics mapping | `partial`, `corrupt`, and `in-progress` mappings recorded in answer intake |
| Verify-before-promote | Use Gate **2** byte size and SHA-256 |

Full item list: [G5-1 … G5-12](./qwon_m3_gate_readiness_review_plan.md#gate-5--open-items-partial-download--integrity)

---

## Recommended Product / Codex actions after Gates 4/5 Ready sign-off

1. Proceed to Batch **C** / Gates **6–7** answer intake and Ready review.
2. Keep `Documents/Models/prexus-local-mvp.gguf` and `prexus-local-mvp.gguf.download` scoped to M3 planning; no Swift implementation until all gates are Ready.
3. Verify M2 rollback in the later spike test plan (Gate **8**) before any TestFlight binary with download UX.

---

## Checklist disposition (Gates 4 & 5)

| Gate | Recommended status | M3 implementation | Build `4` |
| --- | --- | --- | --- |
| **4 — Storage / available-space check** | **Ready** | **Not approved** | **Not approved** |
| **5 — Partial download / atomic move** | **Ready** | **Not approved** | **Not approved** |

Gates **1–5** are Ready; Gates **6–9** remain **Pending** until individually marked **Ready** with Product/Codex evidence. **Do not open M3 spike** until **all** gates are Ready.

---

## Evidence boundaries (this PR)

| Included | Excluded |
| --- | --- |
| Storage check requirement and final minimum free-space threshold | Swift / downloader implementation |
| Integrity state + Diagnostics direction | Final Gate 6/7 user-facing copy |
| Temp/resume/atomic move decisions for M3 planning | Storage schema or lookup order change |
| M2 rollback path affirmation | M3 spike approval |
| Links from M3 checklist | GGUF commit; Build `4` approval |
