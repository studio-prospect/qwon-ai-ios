# QWON — M3 Rollback + Release Gate Memo (Gates 8 & 9)

**Last updated:** 2026-06-05 (Batch D review — Gates 8–9 still Pending)
**Status:** **Investigation memo only** — **not** M3 implementation approval, **not** Gates 8/9 **Ready**, **not** Build `4` approval.
**Purpose:** Document **Mac + USB rollback** requirements (Gate 8) and the **Build `4` / TestFlight release gate** (Gate 9) for M3 readiness. Evidence memos exist for all nine checklist rows; Gates **1–3** are Ready, while Gates **4–9** remain Pending until Product/Codex sign-off.

Related: [M3 readiness checklist — Gates 8 & 9](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) · [Batch D review](./qwon_m3_gate_readiness_review_plan.md#batch-d-review-session-2026-06-05) · [Fallback and rollback](./qwon_model_download_gguf_ux_plan.md#fallback-and-rollback) · [M2 guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement) · [TestFlight prep](./qwon_text_alpha_testflight_prep.md) · [models/README.md](../../models/README.md)

---

## Baseline artifact (unchanged)

| Field | Value |
| --- | --- |
| **On-device filename** | `prexus-local-mvp.gguf` — preserved |
| **Placement contract** | `Documents/Models/prexus-local-mvp.gguf` — lookup order unchanged |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha; GGUF **not bundled** |
| **Known-good model path** | M2 **Mac + USB** guided placement (merged [#88](https://github.com/studio-prospect/qwon-ai-ios/pull/88)) |
| **Build `4`** | **Not approved** |

---

## Checklist completion note

With this memo, Gates **1–9** each have linked investigation or evidence documentation. Gates **1–3** are **Ready**; Gates **4–9** remain **Pending**. M3 spike approval requires **all** rows marked Ready plus Codex scoped plan — see [exit criteria](./qwon_model_download_gguf_ux_plan.md#exit-criteria-to-open-m3-spike-future).

| Gate | Memo |
| --- | --- |
| 1–2 | [Hosting + checksum](./qwon_m3_model_hosting_checksum_memo.md) |
| 3 | [Distribution compliance](./qwon_m3_model_distribution_compliance_memo.md) |
| 4–5 | [Storage + integrity](./qwon_m3_storage_integrity_memo.md) |
| 6–7 | [Network + device expectation](./qwon_m3_network_device_expectation_memo.md) |
| 8–9 | **This memo** |

---

## Gate 8 — Rollback to Mac + USB guided placement

### Known-good rollback path (must be preserved)

M3 in-app download — if ever implemented — is **additive**. The following M2 path remains the **supported fallback** and **must not be removed or replaced**:

| Step | Surface / tool | Role |
| --- | --- | --- |
| 1 | **`./tools/scripts/fetch_local_model.sh`** | Download GGUF on developer Mac into `models/prexus-local-mvp.gguf` (gitignored) |
| 2 | **`./tools/scripts/push_local_model_to_device.sh "DEVICE_NAME"`** | USB copy to app sandbox `Documents/Models/prexus-local-mvp.gguf` |
| 3 | **Settings → Local Runtime → Place GGUF via Mac** | M2 guided placement UI with copy-to-clipboard ops commands ([#88](https://github.com/studio-prospect/qwon-ai-ios/pull/88)) |
| 4 | **Settings → Local Runtime** (M1 model status) | Verify `Present (unverified)` / runtime expectation after push |
| 5 | **Runtime Diagnostics** | Confirm `answered_by` after a chat turn |

**Forbidden:** Deleting, hiding, or deprecating M2 guided placement in favor of download-only UX without Product approval and Gate 8 → Ready evidence.

### When rollback applies

| Scenario | Required behavior |
| --- | --- |
| M3 download fails or stalls | User can complete **Place GGUF via Mac** + USB push |
| Hosting URL breaks (Gate 1) | Ops revert to Mac fetch + USB; no in-app recovery required for alpha |
| Partial/corrupt download (Gate 5) | Manual re-push overwrites sandbox file via existing push script |
| M3 spike regression | Revert to **Build `3`** baseline + manual ops; spike branch must not break push script or guided screen |
| TestFlight without download UX | **Current state** — testers use M2 path only |

### Verification expectations (before Gate 8 → Ready)

| Check | Status |
| --- | --- |
| Guided placement screen reachable | **Verified** on simulator (M2 post-merge [#89](https://github.com/studio-prospect/qwon-ai-ios/pull/89)) |
| Push script + fetch script documented | **Yes** — [models/README.md](../../models/README.md), M2 section in [UX plan](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement) |
| M3 spike must re-verify after any Settings/Local Runtime change | **Undecided** — required in principle before Gate 8 Ready |
| Spike must not change `LocalGGUFModelPlacement` lookup order | **Not approved** to change |

### Gate 8 disposition

| Field | Value |
| --- | --- |
| **Recommended status** | **Pending** |
| **Ready?** | **No** — formal post-spike rollback re-verification not yet scheduled |
| **M2 path** | **Must remain** — not replaced by M3 download |

---

## Gate 9 — Build `4` / TestFlight release gate (separate)

### Separation from M3 spike

| Item | M3 in-app download spike | Build `4` / TestFlight |
| --- | --- | --- |
| **Purpose** | Engineering prototype of downloader + integrity UX on a branch | Shipping a binary to internal testers via ASC |
| **Approval** | Requires Gates **1–9** Ready + Codex plan | **Separate Product gate** — **not implied** by spike success |
| **TestFlight upload** | **Not approved** as part of spike | **Not approved** in this memo |
| **Git tag** | **Not approved** | **Not approved** |
| **`CFBundleVersion` / build number bump** | **Not approved** | **Not approved** |
| **Active release** | N/A — spike is not a release | **QWON `0.1.0 (3)`** remains stable alpha |

**Explicit rule:** M3 spike **≠** Build `4` approval. A successful downloader prototype does **not** authorize TestFlight upload, version bump, or tag without a dedicated release decision.

### What Build `4` would imply (when Product gates it — **not now**)

| Decision | Owner | Status |
| --- | --- | --- |
| Ship download UX to TestFlight testers | Product | **Undecided** |
| ASC export compliance re-check | Ops | **Undecided** — see [TestFlight prep](./qwon_text_alpha_testflight_prep.md) |
| Tester communication (GGUF still not bundled vs download available) | Product / support | **Undecided** |
| Gates 1–8 Ready with evidence | Product / Codex | Gates **1–3 Ready**; Gates **4–8 Pending** |

### Gate 9 disposition

| Field | Value |
| --- | --- |
| **Recommended status** | **Pending** — **not approved** |
| **Ready?** | **No** |
| **Build `4` / TestFlight upload / tag / version bump** | **Not approved** |

---

## Cross-gate dependencies

| Gate | Relationship |
| --- | --- |
| **Gate 1** | Hosting failure → Gate 8 USB fallback |
| **Gate 5** | Failed download → manual re-push via Gate 8 |
| **Gate 6–7** | Download copy must not remove M2 USB guidance |
| **Gates 1–8** | All must be Ready before M3 spike; Gate 9 still separate for any TestFlight ship |

---

## Batch D review status (2026-06-05)

**Review:** [Batch D session](./qwon_m3_gate_readiness_review_plan.md#batch-d-review-session-2026-06-05) — open items documented; Gates **8–9** remain **Pending**. **All batches A–D** review documented — **no gate Ready**.

### Gate 8 — unresolved (summary)

| Topic | Status |
| --- | --- |
| M2 guided placement preservation | Pre-spike verified — **post-spike regression undecided** |
| fetch/push scripts | Documented — **spike test plan blocked** for RE sign-off |
| Rollback runbook | **Not published** |
| Manual recovery path | Principle only — **test plan undecided** |

Full item list: [G8-1 … G8-10](./qwon_m3_gate_readiness_review_plan.md#gate-8--open-items-mac--usb-rollback)

### Gate 9 — unresolved (summary)

| Topic | Status |
| --- | --- |
| Build `4` decision boundary | Documented — **Product release decision blocked** |
| TestFlight upload / tag / CFBundleVersion | **Not approved** |
| ASC/export re-check | **Undecided** — Gate 3 overlap |
| Tester communication | **Undecided** |

Full item list: [G9-1 … G9-10](./qwon_m3_gate_readiness_review_plan.md#gate-9--open-items-build-4--testflight-release-gate)

---

## Recommended Product / Codex actions (before Gates 8/9 → Ready)

### Gate 8

1. **Define spike regression test plan** — guided placement + push script still pass after M3 code lands.
2. **Document rollback runbook** — ops steps when in-app download fails (link M2 screen + scripts).
3. **Sign off** that M2 surfaces remain in shipping binary for any build that includes download UX.

### Gate 9

1. **Hold Build `4` decision** until Product explicitly requests TestFlight with download UX.
2. **Separate release memo** when/if Build `4` is approved — not bundled into M3 spike PRs.
3. **Keep `0.1.0 (3)`** as active alpha until release gate closes.

---

## M3 readiness summary

| # | Gate | Status |
| --- | --- | --- |
| 1 | Hosting / URL ownership | **Ready** |
| 2 | SHA-256 / byte size | **Ready** |
| 3 | License / export compliance | **Ready** |
| 4 | Storage budget | **Pending** |
| 5 | Partial download / atomic move | **Pending** |
| 6 | Network disclosure | **Pending** |
| 7 | Wang / Matisse expectation | **Pending** |
| 8 | Mac + USB rollback | **Pending** |
| 9 | Build `4` / TestFlight | **Pending** — **not approved** |

**Do not open M3 spike** until Product/Codex mark all gates **Ready** with linked evidence.

---

## Evidence boundaries (this PR)

| Included | Excluded |
| --- | --- |
| Gate 8 rollback path documentation | M2 path removal or replacement |
| Gate 9 separation from M3 spike | Build `4` / TestFlight / tag / version bump approval |
| All-nine-gate Pending summary | Gates 8/9 marked **Ready** |
| Links from M3 checklist | Swift, GGUF, logs, screenshots commit |
