# QWON — M3 Spike Outcome Decision Checkpoint

**Last updated:** 2026-06-07
**Status:** **Decision checkpoint** — Product/Codex must choose how to treat the merged M3 downloader spike before any Build `4` or default-on work. **Build `4` not approved.** **TestFlight upload / tag / version bump not approved.**
**Purpose:** Record the **post-spike** state after [#118](https://github.com/studio-prospect/qwon-ai-ios/pull/118) (implementation) and [#119](https://github.com/studio-prospect/qwon-ai-ios/pull/119) (post-merge verification), and define the **conditions** for moving toward Build `4` vs staying at compile-gated default-off.

Related: [Model download / GGUF UX plan](./qwon_model_download_gguf_ux_plan.md) · [M3 spike plan](./qwon_m3_spike_plan.md) · [Post-merge verification](./qwon_model_download_gguf_ux_plan.md#pr-m3-post-merge-verification-2026-06-07) · [Next work queue](./qwon_next_work_queue.md) · [TestFlight prep — Build `4` gate](./qwon_text_alpha_testflight_prep.md#phase-4-build-3-decision-gate) · [M3 rollback + release gate memo](./qwon_m3_rollback_release_gate_memo.md)

---

## 1. Current state

| Field | Value |
| --- | --- |
| **M3 spike implementation** | **Merged** — [#118](https://github.com/studio-prospect/qwon-ai-ios/pull/118) on `main` @ `a2a4f2a` |
| **Post-merge verification** | **Recorded** — [#119](https://github.com/studio-prospect/qwon-ai-ios/pull/119) on `main` @ `cb8ea51` |
| **Compile gate** | `QWON_M3_MODEL_DOWNLOAD_SPIKE` — **default off**; spike enabled only at project generation time |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha; **does not include** M3 downloader Settings UI |
| **M1 / M2** | **Complete** — model status UX + **Place GGUF via Mac** guided placement remain the production-visible path on TestFlight |
| **Build `4`** | **Not approved** |
| **Development endpoint** | `https://models.qwon.dev/.../prexus-local-mvp.gguf` — dev/ops only; **not** a production (`qwon.ai`) switch approval |

The M3 spike answers: *Can QWON safely download, verify, promote, and surface a local model file on a debug build without regressing M2 manual placement?* **Yes** — on Wang debug evidence. It does **not** authorize shipping downloader UX to TestFlight testers by default.

---

## 2. Evidence summary

Post-merge verification ([#119](https://github.com/studio-prospect/qwon-ai-ios/pull/119)) and ops evidence under `~/QWON-alpha-evidence/qwon-m3-spike/`.

### Endpoint / artifact contract

| Field | Value |
| --- | --- |
| **HTTPS URL (development)** | `https://models.qwon.dev/models/qwen2.5-0.5b-instruct/q4_k_m/prexus-local-mvp.gguf` |
| **Byte size** | `397808192` |
| **SHA-256** | `6eb923e7d26e9cea28811e1a8e852009b21242fb157b26149d3b188f3a8c8653` |
| **Final sandbox path** | `Documents/Models/prexus-local-mvp.gguf` |
| **Temp path** | `Documents/Models/prexus-local-mvp.gguf.download` |

### Device smoke (debug build, spike compile gate on)

| Device | Scenario | Result |
| --- | --- | --- |
| **Wang** (`iPhone18,3`) | `m3_download` | **Pass** — `success: true`, `manifestVerified: true`, `statusChipLabel: Verified`, `byteCount: 397808192`; llama.cpp path after verified promote |
| **Matisse** (`iPhone11,6`) | `model_status` | **Pass** — `placementState: missing` is **expected**; `Embedded Heuristic Runtime` is the normal local path; missing GGUF is **not** a failure |

### Build gates (main)

| Gate | Result |
| --- | --- |
| Default project (spike off) | **Pass** — no M3-only sources in committed `project.pbxproj` |
| Spike project (spike on) | **Pass** — full `QWONTests` including M3 gated tests |

Ops JSON filenames (not in git): `wang-m3_download-20260607T112115Z.json`, `matisse-model_status-20260607T112128Z.json`.

---

## 3. Decision options

Product/Codex must pick **one primary posture**. Options are **mutually exclusive** for the next release boundary unless explicitly re-opened.

### Option A — Keep spike default-off and stop here (**recommended default**)

| Aspect | Detail |
| --- | --- |
| **Posture** | M3 code remains on `main` behind compile gate; TestFlight stays **`0.1.0 (3)`**; testers continue M2 USB/guided placement |
| **When** | No verified release blocker; no Product appetite for Build `4`; spike evidence is sufficient for internal R&D |
| **Pros** | Lowest risk; preserves stable alpha; no tester-facing network download surface |
| **Cons** | TestFlight testers still cannot self-serve model acquisition |

### Option B — Prepare Build `4` candidate with M3 hidden or debug-gated only

| Aspect | Detail |
| --- | --- |
| **Posture** | Product **explicitly approves Build `4`**; binary may ship with M3 **still compile-gated or DEBUG-only** — not default-on for TestFlight Release |
| **When** | Product wants a new binary for other fixes/features but **not** general tester download UX yet |
| **Pros** | Refreshes TestFlight without exposing downloader to all testers |
| **Cons** | Requires full release ops (notes, lab re-smoke, ASC); M3 remains internal-only |

### Option C — Promote M3 to user-visible TestFlight feature after extra hardening

| Aspect | Detail |
| --- | --- |
| **Posture** | Remove compile gate or enable downloader in Release; Settings download visible to TestFlight testers |
| **When** | Product accepts network disclosure, Wang-primary scope, ASC/privacy re-check, and hardening beyond spike |
| **Pros** | Reduces USB friction for Wang-class testers |
| **Cons** | Highest scope — not implied by spike merge; needs dedicated implementation + verification PRs |

### Option D — Defer M3 and keep M2 guided placement as primary

| Aspect | Detail |
| --- | --- |
| **Posture** | Treat spike as **completed experiment**; no further M3 investment; M2 **Place GGUF via Mac** remains the official acquisition path |
| **When** | Product deprioritizes in-app download despite successful spike |
| **Pros** | Clear tester story; minimal ongoing M3 maintenance |
| **Cons** | Spike code remains on `main` compile-gated unless a future PR removes it (removal **not** in scope here) |

---

## 4. Recommended default

| Recommendation | Rationale |
| --- | --- |
| **Option A** unless Product **explicitly approves Build `4`** | Spike succeeded on debug evidence; TestFlight `0.1.0 (3)` is stable; downloader UI is not in the shipped binary today |
| If Product approves Build `4` | Prefer **Option B** first — new binary without default-on M3 — unless Product separately approves Option C hardening |

**This memo does not approve any option.** It records the decision surface for Product/Codex sign-off.

---

## 5. Required before Build `4`

Build `4` remains a **separate product gate** from M3 spike success ([Gate 9](./qwon_m3_rollback_release_gate_memo.md)). All rows required **before** archive/upload:

| # | Requirement | Owner |
| --- | --- | --- |
| 1 | **Product approval** for Build `4` (distinct from M3 spike merge) | Product |
| 2 | **Release notes / tester instructions** updated — state whether M3 download is included or still absent | Product + RE |
| 3 | **Wang + Matisse TestFlight verification plan** — manual smoke on **Release** build, not debug-only spike | RE / lab |
| 4 | **Rollback path** — M2 **Place GGUF via Mac** + `fetch_local_model.sh` / `push_local_model_to_device.sh` remain documented and reachable | Cursor / Codex review |
| 5 | **No GGUF binary commit** — model weights stay ops/device-local | All agents |
| 6 | If Option C (user-visible download): ASC privacy/export re-check, Gate 6 disclosure copy in Release, `qwon.ai` production endpoint decision — **separate** from dev `models.qwon.dev` | Product / Legal / RE |

Documenting Build `4` criteria **does not** approve Build `4`.

---

## 6. Non-goals (this checkpoint)

| Non-goal | Reason |
| --- | --- |
| Swift / app code changes | Decision docs only |
| Default-on downloader in Release | Spike remains compile-gated unless Option C is explicitly approved and implemented |
| TestFlight upload | Build `4` not approved |
| Tag or `CFBundleVersion` bump | Release ops gate |
| Switch to `qwon.ai` production endpoint | Dev endpoint only for spike; production cutover is a separate RE/Product decision |
| PREXUS historical cleanup | Out of M3 lane scope |
| Remove compile gate without Product approval | Would change TestFlight surface area |
| Rename `prexus-local-mvp.gguf` or change `LocalGGUFModelPlacement` order | Preserved contracts |

---

## Agent boundary (until Product decides)

| Allowed | Not allowed |
| --- | --- |
| Docs-only updates (this memo, queue, index) | Implementation PRs for default-on M3 |
| Internal debug builds with `QWON_M3_MODEL_DOWNLOAD_SPIKE=1` for lab | TestFlight upload / tag / version bump |
| M2 guided placement + USB ops | Treating spike merge as Build `4` approval |
| Recording Product decision in this memo when signed off | `qwon.ai` endpoint switch without RE plan |

When Product selects an option, append a **Decision record** subsection below (date, option chosen, approver, linked PR if any).

---

## Decision record

| Field | Value |
| --- | --- |
| **Date** | *Pending Product/Codex sign-off* |
| **Option chosen** | *A / B / C / D — not yet decided* |
| **Build `4` approved?** | **No** |
| **Notes** | Spike merge ([#118](https://github.com/studio-prospect/qwon-ai-ios/pull/118)) + verification ([#119](https://github.com/studio-prospect/qwon-ai-ios/pull/119)) complete; awaiting outcome decision |
