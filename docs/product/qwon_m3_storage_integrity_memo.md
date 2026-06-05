# QWON — M3 Storage + Partial Download Integrity Memo (Gates 4 & 5)

**Last updated:** 2026-06-05 (Batch B review — Gates 4–5 still Pending)
**Status:** **Investigation memo only** — **not** M3 implementation approval, **not** Gates 4/5 **Ready**, **not** Build `4` approval.
**Purpose:** Document open **iOS storage budget / available-space check** (Gate 4) and **partial download / resume / atomic move** (Gate 5) questions for a future **M3 in-app download** spike of `prexus-local-mvp.gguf`.

Related: [M3 readiness checklist — Gates 4 & 5](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) · [Batch B review](./qwon_m3_gate_readiness_review_plan.md#batch-b-review-session-2026-06-05) · [Integrity states](./qwon_model_download_gguf_ux_plan.md#integrity-and-storage-requirements) · [Gate 1/2 hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md) · [Gate 3 compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [M2 guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement) · [models/README.md](../../models/README.md)

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

## Model size context (Gate 2 reference — not Gate 4 threshold)

Artifact byte size is **not final** until Gates 1/2 are Ready. For storage planning, use the observed range from [hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md#observed-file-sizes-ops-evidence--not-gate-2-final):

| Source | Approximate size |
| --- | --- |
| Wang lab device (USB push) | **~379.4 MB** |
| bartowski HF listing (Q4_K_M) | **~398 MB** |
| Engineering estimate | **~379–400 MB** |

**Gate 4 minimum free-space threshold is undecided.** Product must choose headroom above the Gate 2 pinned byte size (temp file peak, OS overhead, user-visible margin).

---

## Gate 4 — iOS storage budget and available-space check

### Requirement (directional — not Ready)

Any future M3 download must **check available capacity in the app sandbox before starting a network fetch or claiming success**. Do **not** silently fill `Documents/` until the OS rejects the write.

| Requirement | Status |
| --- | --- |
| Pre-download **available-space check** | **Required in principle** — implementation **not approved** |
| **Minimum free-space threshold** (bytes) | **Undecided** — not fixed in this memo |
| User-visible failure when space insufficient | **Required in principle** — copy **undecided** |
| No silent sandbox fill / no “installed” UX on failure | **Required in principle** |
| Storage schema change | **Not approved** |
| `LocalGGUFModelPlacement` lookup order change | **Not approved** |

### Storage location (unchanged contract)

| Path | Role |
| --- | --- |
| `Documents/Models/prexus-local-mvp.gguf` | Final resolved model path (existing contract) |
| `Documents/Models/` (directory) | Must exist or be created before write; same sandbox as M2 USB push target |

M3 must write into the **same final path** M1/M2 already surface in Settings → Local Runtime. No alternate schema without a separate approved migration.

### Threshold planning questions (Product / Codex — all **open**)

| Question | Notes |
| --- | --- |
| Base threshold | Gate 2 **expected byte size** + how much headroom? |
| Temp-file peak | During Gate 5 download, is peak usage **~1×** artifact (write temp, then atomic replace) or **~2×** (temp + existing partial)? |
| Safety margin | Fixed MB buffer vs percentage vs device-tier-specific — **undecided** |
| Re-check during download | If available space drops mid-transfer (other apps), abort vs resume — ties to Gate 5 |
| Matisse / low-storage devices | Download UX should not pressure installs; see [Gate 7](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) |

### Gate 4 disposition

| Field | Value |
| --- | --- |
| **Recommended status** | **Pending** |
| **Ready?** | **No** — minimum threshold not decided |
| **Blocked by** | Gate 2 pinned byte size; Product margin policy |

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

### Temp filename strategy — **undecided**

Any in-app download must use a **non-final temp name** until Gate 2 verification passes, then **atomically** promote to `prexus-local-mvp.gguf`.

| Option (examples only — **not selected**) | Tradeoff |
| --- | --- |
| `prexus-local-mvp.gguf.part` in `Documents/Models/` | Simple; must ensure runtime never loads `.part` |
| `prexus-local-mvp.gguf.downloading` | Explicit state in filename |
| Temp under `tmp/` or `Caches/` then move | Different peak storage location; move must remain atomic at final path |

**Product/Codex must pick one strategy before Gate 5 → Ready.**

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
| Retry | **Undecided:** wipe temp and restart vs resume (see below) |
| Existing good file | Retry must not destroy verified file without explicit user action (deletion UX **not approved** for M3 spike unless Product gates it) |

### Resume — **required vs optional: undecided**

| Approach | Gate 5 status |
| --- | --- |
| **No resume — clean restart only** | Simpler; re-download full artifact; higher bandwidth cost |
| **HTTP Range resume** | Requires server support (Gate 1); more complex temp/state tracking |
| **Background URLSession resume** | iOS API considerations; separate from foreground spike scope |

**Product/Codex must decide whether resume is required for M3 spike or deferrable to a later iteration.** This memo does **not** mark resume as required or optional.

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
| **Recommended status** | **Pending** |
| **Ready?** | **No** — temp name, resume policy, and verification-on-promote details undecided |
| **Blocked by** | Gates 1/2 (artifact + checksum); Gate 4 (space headroom for temp peak) |

---

## Rollback path — M2 Mac + USB guided placement (maintained)

M3 spike must **not** remove or regress the known-good manual path:

| Fallback | How |
| --- | --- |
| **Settings → Place GGUF via Mac** | M2 guided placement ([M2 section](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement)) |
| **`push_local_model_to_device.sh`** | USB copy to `Documents/Models/prexus-local-mvp.gguf` |
| **`fetch_local_model.sh`** | Mac-side fetch (dev ops; not in-app) |
| **Gate 8 checklist row** | Formal rollback gate — see [M3 checklist Gate 8](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) |

If in-app download fails or Gates 4/5 are not Ready for ship, testers and support continue on **Build `3` baseline + M2 ops**. Partial or failed M3 download must **not** block manual USB recovery.

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

## Batch B review status (2026-06-05)

**Review:** [Batch B session](./qwon_m3_gate_readiness_review_plan.md#batch-b-review-session-2026-06-05) — open items documented; Gates **4–5** remain **Pending**.

### Gate 4 — unresolved (summary)

| Topic | Status |
| --- | --- |
| Minimum free-space threshold | **Undecided** — **Batch A blocked** (Gate 2 byte size) |
| Sandbox available-capacity check | Required in principle; API/timing **undecided** |
| Temp peak size (1× vs 2×) | **Undecided** |
| Insufficient-space user copy | **Undecided** |

Full item list: [G4-1 … G4-9](./qwon_m3_gate_readiness_review_plan.md#gate-4--open-items-storage-budget--available-space-check)

### Gate 5 — unresolved (summary)

| Topic | Status |
| --- | --- |
| Temp filename/path | **Not selected** |
| Resume vs clean retry | **Undecided** |
| Atomic move mechanism | Direction only — spec **undecided** |
| Partial/corrupt cleanup | **Undecided** |
| Diagnostics mapping | Direction only — final copy **undecided** |
| Verify-before-promote | **Batch A blocked** (Gate 2 SHA/size) |

Full item list: [G5-1 … G5-12](./qwon_m3_gate_readiness_review_plan.md#gate-5--open-items-partial-download--integrity)

---

## Recommended Product / Codex actions (before Gates 4/5 → Ready)

1. **Pin Gate 2 byte size** so Gate 4 threshold math is deterministic.
2. **Set minimum free-space threshold** (artifact + temp peak + margin) — document in a future decision memo, not here.
3. **Choose temp filename strategy** and atomic promote mechanism.
4. **Decide resume policy** (required for spike vs clean-retry-only).
5. **Specify Diagnostics/Settings strings** per integrity state for M3 spike scope.
6. **Verify M2 rollback** in spike test plan (Gate 8) before any TestFlight binary with download UX.

---

## Checklist disposition (Gates 4 & 5)

| Gate | Recommended status | M3 implementation | Build `4` |
| --- | --- | --- | --- |
| **4 — Storage / available-space check** | **Pending** | **Not approved** | **Not approved** |
| **5 — Partial download / atomic move** | **Pending** | **Not approved** | **Not approved** |

All M3 checklist gates remain **Pending** until individually marked **Ready** with Product/Codex evidence. **Do not open M3 spike** until **all** gates are Ready.

---

## Evidence boundaries (this PR)

| Included | Excluded |
| --- | --- |
| Storage check requirement (principle) | Final minimum free-space threshold |
| Integrity state + Diagnostics direction | Swift / downloader implementation |
| Temp/resume/atomic move options as open questions | Storage schema or lookup order change |
| M2 rollback path affirmation | Gates 4/5 marked **Ready** |
| Links from M3 checklist | GGUF commit; Build `4` approval |
