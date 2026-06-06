# QWON — M3 In-App Model Download Spike Plan

**Last updated:** 2026-06-07
**Status:** **Spike plan** — implementation may start only after this plan is merged. **Not** Build `4` approval, **not** TestFlight upload approval, **not** tag/version bump approval.
**Purpose:** Define the smallest safe M3 implementation spike for in-app acquisition of `prexus-local-mvp.gguf`, using the signed-off Gates **1–9** evidence while preserving the QWON `0.1.0 (3)` stable alpha release boundary.

Related: [Model download / GGUF UX plan](./qwon_model_download_gguf_ux_plan.md) · [M3 checklist](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) · [Hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md) · [Storage + integrity memo](./qwon_m3_storage_integrity_memo.md) · [Network + device expectation memo](./qwon_m3_network_device_expectation_memo.md) · [Rollback + release gate memo](./qwon_m3_rollback_release_gate_memo.md)

---

## Decision

M3 may proceed as a **compile-gated internal spike** after this plan is merged.

| Field | Decision |
| --- | --- |
| **Compile gate** | `QWON_M3_MODEL_DOWNLOAD_SPIKE` (new flag; default **off**) |
| **Release/TestFlight** | No change. Build `4` remains **not approved** |
| **Runtime contract** | Preserve `Documents/Models/prexus-local-mvp.gguf` and `LocalGGUFModelPlacement` lookup order |
| **Known-good fallback** | Preserve M2 **Place GGUF via Mac** and `fetch_local_model.sh` / `push_local_model_to_device.sh` |
| **Target device** | Wang-primary validation; Matisse remains Embedded Heuristic expected path |

This spike is allowed to answer: “Can QWON safely download, verify, promote, and surface a local model file without regressing M2 manual placement or runtime fallback?”

---

## Non-Goals

| Not allowed in M3 spike | Reason |
| --- | --- |
| Build `4`, TestFlight upload, tag, or `CFBundleVersion` bump | Gate 9 keeps release ops separate |
| App Store / privacy label edits | Release-time Product/Legal/RE gate |
| GGUF, IPA, archive, logs, screenshots in git | Artifact policy |
| Rename `prexus-local-mvp.gguf` | Preserved runtime/model contract |
| Rename `PREXUS_*` env vars or existing historical surfaces | Preserved PREXUS inventory |
| Change `LocalGGUFModelPlacement` lookup order | Gate 8 preservation |
| Background download / automatic first-launch fetch | Gate 6 says user-initiated foreground only |
| HTTP Range resume | Gate 5 selects clean restart for M3 |
| Deletion UX for an existing good model | Deferred; avoid destructive model removal surface |
| LiteRT / L2 selector / routing policy changes | Separate post-alpha lane |

---

## Source Artifact Contract

| Field | Value |
| --- | --- |
| **Hosted object identity** | `s3://qwon-094469122222-ap-northeast-1-an/models/qwen2.5-0.5b-instruct/q4_k_m/prexus-local-mvp.gguf` |
| **Expected byte size** | `397808192` |
| **SHA-256** | `6eb923e7d26e9cea28811e1a8e852009b21242fb157b26149d3b188f3a8c8653` |
| **Final sandbox path** | `Documents/Models/prexus-local-mvp.gguf` |
| **Temp path** | `Documents/Models/prexus-local-mvp.gguf.download` |
| **Minimum free space before start** | `1064051840` bytes |
| **Product-facing URL** | `https://models.qwon.ai/models/qwen2.5-0.5b-instruct/q4_k_m/prexus-local-mvp.gguf` |
| **HTTPS endpoint operations** | Canonical endpoint selected; Release Engineering must provision and verify DNS/CDN/object routing before downloader network code is exercised |

Do **not** use Hugging Face resolve URL as the app endpoint. If the selected QWON-owned HTTPS URL is not live when Cursor starts implementation, Cursor must stop before downloader network code and report the missing endpoint. It may still prepare code boundaries/tests that do not require a live URL.

---

## Implementation Scope

### 1. Compile-Gated Model Download Module

Create a small downloader surface behind `QWON_M3_MODEL_DOWNLOAD_SPIKE`.

Required responsibilities:

| Capability | Requirement |
| --- | --- |
| Manifest | Holds URL, expected byte size, SHA-256, final path, temp path, minimum free space |
| Capacity check | Check available capacity before starting; require `1064051840` bytes |
| Foreground download | User-initiated only; no background fetch |
| Progress state | In-progress / cancelled / failed / verified states surfaced to Settings |
| Clean retry | Delete failed temp and restart; no resume for M3 |
| Verification | Verify byte size and SHA-256 on temp file before promote |
| Atomic promote | Promote temp to `prexus-local-mvp.gguf` only after verification |
| Failure safety | Never present partial temp as installed; keep existing final file untouched on failure |

### 2. Settings UI Spike

Extend Settings → Local Runtime only when the compile flag is enabled.

Required behavior:

| State | Required UI |
| --- | --- |
| Missing on Wang | Offer user-initiated download and keep **Place GGUF via Mac** visible |
| Present unverified | Preserve M1 copy; do not claim verified unless hash/size match |
| Downloading | Show progress/cancel or clear in-progress state |
| Verified | Show verified local model state |
| Failed/corrupt/partial | Explain fallback and point to **Place GGUF via Mac** |
| Matisse | De-emphasize download; Embedded Heuristic Runtime remains expected / not failure |

Draft copy must preserve Gate 6/7 meaning:

- One-time optional model download, about 400 MB.
- Download uses network once; local path answers on device after install.
- QWON is local-first, not offline-only.
- Mac + USB placement remains available.

### 3. Diagnostics Mapping

Extend Runtime Diagnostics only for states created by the spike.

Required mappings:

| State | Diagnostics meaning |
| --- | --- |
| `partial` | Download incomplete; not installed; fallback remains active |
| `verified` | Size + SHA-256 matched approved artifact |
| `corrupt` | Verification failed or load failed; fallback remains active |
| Wang missing/corrupt | `Embedded Heuristic Runtime` fallback is acceptable |
| Matisse | `Embedded Heuristic Runtime` is expected |

Do not change existing `answered_by`, `primary_failure`, or `fallback_reason` semantics without a separate Codex review.

### 4. Rollback Preservation

M3 spike must preserve:

| Surface | Requirement |
| --- | --- |
| Settings → Local Runtime → **Place GGUF via Mac** | Still reachable |
| `./tools/scripts/fetch_local_model.sh` | Still documented and usable |
| `./tools/scripts/push_local_model_to_device.sh "DEVICE_NAME"` | Still documented and usable |
| `Documents/Models/prexus-local-mvp.gguf` | Final path unchanged |
| Existing good final file | Not destroyed by failed download/retry |

---

## Suggested PR Split

Keep the first implementation PR small enough to review.

| PR | Scope | Merge condition |
| --- | --- | --- |
| **M3-a** | Compile-gated manifest, downloader state machine, temp/verify/promote core, unit tests | No UI release path; no Build `4`; tests pass |
| **M3-b** | Settings + Diagnostics UI behind same gate, simulator UI tests | M3-a merged; M2 guided placement still reachable |
| **M3-c** | Wang debug smoke + Matisse fallback evidence, docs update | M3-a/b merged; ops evidence stored outside git |

If Cursor chooses a single PR, it must still keep these sections separable in commits and PR description.

---

## Validation Plan

### Local / Simulator

| Check | Required |
| --- | --- |
| `git diff --check` | Pass |
| `ruby tools/scripts/generate_xcodeproj.rb` | Pass; committed project stays no-llama unless explicitly testing llama |
| QWON unit tests | Pass |
| Downloader unit tests | Missing, insufficient space, temp path, byte-size mismatch, SHA mismatch, verified promote |
| Settings UI tests | Download entry visible only under compile gate; **Place GGUF via Mac** still reachable |
| Diagnostics tests | Partial/corrupt/verified copy does not claim llama.cpp before verified |

### Device / Ops

| Device | Required |
| --- | --- |
| Wang | Debug build with compile gate; download → verify → promote → local model status; llama.cpp path after chat if supported |
| Wang rollback | Delete temp / simulate failure; **Place GGUF via Mac** + push script still recovers |
| Matisse | Install/launch crash-free; Embedded Heuristic Runtime expected; no false failure copy |

Ops evidence goes under `~/QWON-alpha-evidence/qwon-m3-spike/` and stays out of git.

---

## Cursor Implementation Instructions

Cursor may start implementation only after this plan is merged.

1. Branch from latest `origin/main`.
2. Keep all M3 code behind `QWON_M3_MODEL_DOWNLOAD_SPIKE`.
3. Do not touch Build `4`, TestFlight, tag, version bump, ASC, privacy label, or release docs except evidence notes.
4. Do not commit GGUF, screenshots, logs, DerivedData, archives, or `.eval-logs`.
5. If QWON-owned HTTPS endpoint is missing, stop before network downloader code and report the blocker.
6. Preserve M2 guided placement and manual push scripts.
7. Include test-plan results in PR body, including no-llama project state.

---

## Completion Criteria

M3 spike is complete only when:

| Criterion | Required |
| --- | --- |
| Download path | User-initiated foreground flow works on Wang debug build |
| Integrity | Byte size + SHA-256 verification gates atomic promote |
| Safety | Partial/corrupt file never appears installed |
| Fallback | Existing final file and M2 USB path survive failure/retry |
| Device copy | Matisse remains expected fallback; Wang has clear local-model status |
| Verification | Unit/simulator/device evidence recorded |
| Release boundary | Build `4` remains not approved |

After spike completion, Codex/Product decide whether to keep iterating internally, defer, or open a separate Build `4` product release gate.
