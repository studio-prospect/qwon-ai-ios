# QWON — Model Download / GGUF UX — Product Lane Decision

**Last updated:** 2026-06-03
**Status:** **Selected for scoped planning only** — **not** implementation, spike, or build **`4`** approval.
**Purpose:** Record Product selection of **Model download / GGUF UX** as the **second post-alpha lane** after [UI polish / onboarding](./qwon_ui_polish_onboarding_plan.md) (UI-1 complete). Enables Codex to author a scoped plan; does **not** authorize Cursor implementation.

Related: [Scoped plan](./qwon_model_download_gguf_ux_plan.md) · [Post-alpha next lane checkpoint](./qwon_post_alpha_options.md#next-lane-selection-checkpoint-2026-06-03) · [Option detail — Model download / GGUF UX](./qwon_post_alpha_options.md#3-model-download--gguf-placement-ux) · [Next work queue](./qwon_next_work_queue.md#next-decision-checkpoint) · [models/README.md](../../models/README.md) · [Preserved PREXUS inventory](./qwon_preserved_prexus_surface_inventory.md)

---

## Baseline (do not override)

| Field | Value |
| --- | --- |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha |
| **First post-alpha lane** | **UI polish / onboarding** — **complete** (UI-1 #80, #81) · UI-2 **deferred** (#82) |
| **Build `4`** | **Not approved** |
| **Model filename** | **`prexus-local-mvp.gguf`** — **preserved** until dedicated migration PR |
| **Scoped plan** | [qwon_model_download_gguf_ux_plan.md](./qwon_model_download_gguf_ux_plan.md) |
| **This doc** | Lane **selection** only |

---

## Decision (2026-06-03)

| Field | Value |
| --- | --- |
| **Selected next lane** | **[Model download / GGUF UX](./qwon_post_alpha_options.md#3-model-download--gguf-placement-ux)** |
| **Status** | **Selected for scoped planning only** |
| **Recorded by** | Product |
| **Build `4`** | **Not approved** — lane selection does not authorize TestFlight upload, tag, or version bump |

### Rationale

- **Wang manual GGUF push** (`./tools/scripts/push_local_model_to_device.sh`) is the **largest tester onboarding friction** on the text-alpha line today.
- UI-1 improved **copy** about missing models and Wang vs Matisse paths, but did **not** change acquisition workflow.
- Before expanding beyond the two-device lab, designing **UX + ops** for model placement (download vs guided steps) has **high near-term tester value** with **medium** engineering risk compared to runtime-memory or LiteRT lanes.
- USB push remains **proven** for build **`3`** lab; this lane designs a **successor path**, not an emergency fix.

### Not selected (remain deferred)

| Lane | Why still deferred |
| --- | --- |
| **Runtime memory / context retention** | Privacy, schema, and battery policy needed first |
| **OCR / camera input** | High permissions/runtime scope; no architecture plan |
| **LiteRT / local backend policy** | High eval/runtime risk |
| **Project container rename** | Dev-only; no user onboarding impact |
| **App Store readiness** | Premature for text-alpha |
| **UI polish UI-2** | [Deferred](./qwon_ui_polish_onboarding_plan.md#ui-2-need-assessment-2026-06-03) — no new evidence |

---

## Non-goals (this decision)

| Do not do | Reason |
| --- | --- |
| **In-app download implementation** | Requires Codex scoped plan + explicit implementation gate |
| **Spike or prototype PR** | Not approved by this decision memo |
| **Commit GGUF binaries to git** | [models/README.md](../../models/README.md) — device/sandbox placement only |
| **Rename `prexus-local-mvp.gguf`** | [Preserved inventory](./qwon_preserved_prexus_surface_inventory.md) — separate migration PR |
| **Build `4`**, TestFlight upload, tag, or version bump | Release-engineering gate remains separate |
| **Runtime / routing / backend selection changes** | Acquisition UX lane — not backend swap |
| **Model placement contract changes in code** | Plan first; `LocalGGUFModelPlacement` order unchanged until scoped implementation |
| **Reopen UI-2** | Gated separately unless new evidence |

---

## Required scoped plan contents (Codex)

Codex should produce **`docs/product/qwon_model_download_gguf_ux_plan.md`** (or equivalent) covering at minimum:

| # | Topic | Must address |
| --- | --- | --- |
| 1 | **Current USB push flow** | `./tools/scripts/fetch_local_model.sh`, `push_local_model_to_device.sh`, `install_on_device.sh`; Wang lab ops; what testers do today |
| 2 | **Model file name and placement contract** | `prexus-local-mvp.gguf`; resolution order per [models/README.md](../../models/README.md) (`PREXUS_LOCAL_MODEL_PATH` → bundle → `Documents/Models/`) |
| 3 | **Storage / integrity / checksum** | On-device quota, partial download handling, hash verification, failure surfaces |
| 4 | **Download vs guided placement options** | In-app HTTPS download vs step-by-step “copy via Files/USB” UX; offline-first constraints; no false “fully in-app” claim if ops still required |
| 5 | **User copy and Settings/Diagnostics implications** | Align with [UI-1 copy](./qwon_ui_polish_onboarding_plan.md); Fallback vs missing-model messaging; no contradiction with Matisse heuristic expected path |
| 6 | **Wang / Matisse expectations** | Wang: llama.cpp after GGUF present · Matisse: Embedded Heuristic expected; GGUF optional/not required on A12 tier |
| 7 | **Rollback / fallback behavior** | Missing/corrupt model → existing embedded heuristic path; no crash; Diagnostics fields (`answered_by`, `primary_failure`, `fallback_reason`) |
| 8 | **Test / device evidence plan** | Wang re-smoke after any future implementation; simulator bounds; ops PNG filenames only — **no** fabricated lab rows |

**First safe PR after plan merge:** **docs-only** plan PR (this memo’s follow-up) or **spike** only if plan explicitly gates it — never bundled with TestFlight ops.

---

## Agent boundaries

| Agent | Action |
| --- | --- |
| **Product** | **Done** — lane selected in this memo |
| **Codex** | **Done** — [scoped plan](./qwon_model_download_gguf_ux_plan.md) authored for review |
| **Cursor** | **Wait** — no implementation or spike until scoped plan merge and explicit task |
| **All** | **No** build **`4`**, upload, tag, bump, GGUF commit, or filename migration from this decision |

---

## Cursor task boundary

Cursor must **not** implement download UI, background transfer, storage schema, or routing changes until:

1. Codex scoped plan is **merged** to `main`, and
2. Product/Codex explicitly assigns an implementation or spike PR.

Until then: **docs-only** maintenance on this lane is allowed; **Swift/runtime changes are not**.

---

## Verification (this decision PR)

```sh
git diff --check
```

Docs-only — `xcodebuild` not required.
