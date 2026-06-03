# QWON — Post-Alpha Option Lanes (v0.2+ Planning)

**Last updated:** 2026-06-03 (UI polish / onboarding scoped plan)
**Status:** **Planning only** — **first post-alpha lane selected** and [scoped plan created](./qwon_ui_polish_onboarding_plan.md); **implementation not approved** in this document.
**Purpose:** After **QWON `0.1.0 (3)` stable alpha** and [closed feedback intake](./qwon_text_alpha_feedback_intake.md#feedback-window-close-2026-06-03), outline **v0.2 / post-alpha candidate lanes** for product to choose from. Does **not** approve build **`4`**, TestFlight upload, tag, version bump, or code work.

Related: [UI polish / onboarding scoped plan](./qwon_ui_polish_onboarding_plan.md) · [Next decision checkpoint](./qwon_next_work_queue.md#next-decision-checkpoint) · [QWON next work queue — deferred](./qwon_next_work_queue.md#deferred--post-alpha) · [Agent collaboration workflow](./agent_collaboration_workflow.md) · [Preserved PREXUS inventory](./qwon_preserved_prexus_surface_inventory.md)

---

## Current baseline (do not override)

| Field | Value |
| --- | --- |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — **stable alpha** |
| **Feedback** | **Closed** — **QWON-FB-001**, **QWON-FB-002** operational pass; **no blockers** |
| **Build `4`** | **Not approved** |
| **Selected first lane (planning)** | **UI polish / onboarding** — [Product lane decision](#product-lane-decision) · [Scoped plan](./qwon_ui_polish_onboarding_plan.md) |
| **This doc** | Lane catalog + product decision record — selection does **not** authorize implementation |

**v0.2** below means **post-alpha product direction candidates**, not an approved release or marketing version bump.

---

## Recommended workflow

Do **not** start with a broad implementation PR. Use this sequence:

1. **Product chooses one lane** (or explicitly defers all — Stay on build **`3`**).
2. ~~**Codex creates a scoped plan**~~ **Done** — [UI polish / onboarding scoped plan](./qwon_ui_polish_onboarding_plan.md).
3. **Cursor implements** — only after scoped plan merge and any required product gate (separate from this catalog).

Planning PRs for this doc are **docs-only**. First engineering PR after selection is usually **spike** or **narrow implementation**, never upload/tag/bump without an explicit release gate.

---

## Option summary

| Lane | Goal (one line) | User impact | Technical risk | Suggested first PR |
| --- | --- | --- | --- | --- |
| [LiteRT / local backend policy](#1-litert--local-backend-policy) | Decide non–llama.cpp on-device backend strategy | Better A12+ coverage; clearer routing | High — runtime swap, eval debt | **docs-only** → spike |
| [OCR / camera input](#2-ocr--camera-input) | Multimodal text-from-scene input | Camera as sensor; new workflows | High — latency, privacy, routing | **docs-only** → spike |
| [Model download / GGUF UX](#3-model-download--gguf-placement-ux) | Replace USB push with in-app model acquisition | Easier onboarding; fewer ops steps | Medium — storage, background, signing | **docs-only** → spike |
| [Project container rename](#4-project-container-rename-prexusxcodeproj) | Rename **`PREXUS.xcodeproj`** container | None direct; dev/CI clarity | Medium — generator, CI, muscle memory | **docs-only** → scoped implementation |
| [Public / App Store readiness](#5-public--app-store-readiness) | Exit TestFlight-only phase | Public availability | High — compliance, support, quality bar | **docs-only** only until product gate |
| [Runtime memory / context retention](#6-runtime-memory--context-retention) | Durable cognitive layer; compression | Longer sessions; less re-explaining | High — privacy, battery, SQLite/vectors | **docs-only** → spike |
| [UI polish / onboarding](#7-ui-polish--onboarding) | Calm first-run; clearer local/heuristic story | Lower friction; fewer misreads | Low–medium — mostly UI/copy | **docs-only** → implementation |

**Compare lanes:** [Selection matrix](#selection-matrix) — product decision aid; does **not** pick a winner.

---

## Selection matrix

**Purpose:** Help **product** compare lanes. **Product decision recorded** — [UI polish / onboarding](#product-lane-decision) selected 2026-06-03. Matrix retained for audit of deferred lanes.

**Scale (qualitative, 2026-06-03):**

| Scale | Meaning |
| --- | --- |
| **User value** | Near-term tester/user benefit on build **`3`** stable alpha line |
| **Engineering risk** | Runtime regression, preserved-surface breakage, review blast radius |
| **Evidence readiness** | Existing docs/eval/ops proof in repo today |
| **Runtime / privacy impact** | Touch to orchestrator, retention, permissions, cloud egress |
| **Time to first useful PR** | Calendar effort to a mergeable **docs-only** or **spike** PR (not full feature) |

| Lane | User value | Engineering risk | Evidence readiness | Runtime / privacy impact | Time to first useful PR | Recommended if | Avoid if |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **LiteRT / local backend** | Medium–High | **High** | Medium — [research memo](../research/litert_lm_adoption_decision.md) exists; device eval incomplete | **High** — routing, Metal, tier policy | Medium — docs memo + eval plan first | Product prioritizes **backend strategy** and A12+ path clarity before UX | Need quick user-visible win; no eval bandwidth; want to avoid `runtime/` churn |
| **OCR / camera** | High (long term) | **High** | Low — architecture sketches only | **High** — camera permission, vision pipeline, routing | Medium–Long — design memo before spike | Product commits to **multimodal sensor** roadmap | Text-alpha scope still primary; no Codex architecture plan |
| **Model download / GGUF UX** | **High** (testers) | Medium | Medium — [models/README](../../models/README.md), USB push ops proven; no in-app UX | Medium — storage, network, file integrity | Medium — UX memo → download spike | Product wants to **remove USB push friction** for lab + future testers | Filename migration bundled; upload implied |
| **Project container rename** | **Low** (dev-only) | Medium | High — [inventory](./qwon_preserved_prexus_surface_inventory.md), Phase 4 audit complete | **Low** — infra only | Medium — checklist then scoped PR | Product prioritizes **contributor/CI clarity** over user features | Any user-facing lane active; no migration plan |
| **App Store readiness** | High (long term) | **High** | Low — TestFlight prep only; no public checklist | Medium — compliance, support, privacy labels | Long — checklist doc only at first | Product plans **public release horizon** explicitly | Conflated with build **`4`** gate; alpha still internal-only |
| **Runtime memory / retention** | Medium–High | **High** | Low–Medium — architecture principles; no retention policy doc | **High** — SQLite/vectors, retention law, battery | Medium–Long — policy doc before schema | Product prioritizes **cognitive runtime** core thesis | Privacy/retention policy undefined; cloud dump acceptable shortcut |
| **UI polish / onboarding** | **High** (near term) | **Low–Medium** | **High** — [FB-001/002 pass](./qwon_text_alpha_feedback_intake.md#triage-log-build-3), tier policy, ops PNGs | **Low** — mostly copy/UI; watch runtime coupling | **Short** — copy/screen map docs-only PR | Product wants **lowest-risk first useful PR** after stable alpha | Backend/routing must change first; gamified UI pressure |

### Low-risk first candidate (superseded by product decision)

**UI polish / onboarding** scored best on the [selection matrix](#selection-matrix) for engineering risk and evidence readiness. Product has **selected** this lane — see [Product lane decision](#product-lane-decision). Matrix rows remain for audit; agents must **not** implement without Codex scoped plan.

### After product selects a lane

1. ~~Product records the choice~~ **Done** — [Product lane decision](#product-lane-decision) (2026-06-03).
2. ~~**Codex opens a scoped plan** for **UI polish / onboarding**~~ **Done** — [scoped plan](./qwon_ui_polish_onboarding_plan.md).
3. Cursor implements per [Recommended workflow](#recommended-workflow) — **only after plan merge**; **no** TestFlight upload/tag/bump unless a **separate** product gate approves.

---

## Product lane decision (2026-06-03)

**Recorded by:** Product
**Scope:** First post-alpha lane for **planning** on build **`3`** stable alpha line — **not** implementation approval, **not** build **`4`** approval.

### Selected first lane

| Field | Value |
| --- | --- |
| **Lane** | **[UI polish / onboarding](#7-ui-polish--onboarding)** |
| **Status** | **Selected for planning** — [scoped plan created](./qwon_ui_polish_onboarding_plan.md); Cursor implementation **after** plan merge |
| **Build `4`** | **Not approved** — lane work does not authorize upload, tag, or version bump |

### Rationale

- Build **`3`** stable alpha has Wang/Matisse **operational pass** evidence (**QWON-FB-001**, **QWON-FB-002**) and ops PNGs on file.
- **Near-term user value** — improve first-run experience without reopening feedback intake.
- **Lower risk** than runtime, privacy-permission, or TestFlight-ops lanes: mostly copy/UI; minimal orchestrator change if scoped correctly.
- Target improvements: first-run clarity, **GGUF status** communication, **Matisse Embedded Heuristic** as expected path, **Diagnostics** literacy (Wang llama vs Matisse heuristic).

### Not selected for first lane (deferred)

| Lane | Why deferred (summary) |
| --- | --- |
| **LiteRT / local backend** | Runtime risk and eval debt are **high** |
| **OCR / camera** | Privacy, permissions, and runtime scope are **high** |
| **Model download / GGUF UX** | Valuable — needs storage, network, and integrity design **first** |
| **Project container rename** | **Dev-only** value; no user impact |
| **App Store readiness** | Public release gate is **premature** for text-alpha |
| **Runtime memory / context retention** | Privacy, schema, and battery policy needed **first** |

### Next step (agents)

| Agent | Action |
| --- | --- |
| **Codex** | Maintain/review the [scoped plan](./qwon_ui_polish_onboarding_plan.md) and review implementation PRs against it |
| **Cursor** | **Wait until plan is merged** — then implement only the first scoped UI-1 PR |
| **All** | **No** implementation PR, **no** TestFlight/tag/bump from this decision record |

---

## Option detail

### 1. LiteRT / local backend policy

| Field | Detail |
| --- | --- |
| **Goal** | Evaluate LiteRT (or alternate local backend) vs llama.cpp + Embedded Heuristic tier policy; define Wang/Matisse routing after alpha. |
| **User impact** | Potential better on-device inference on more hardware; clearer Diagnostics labels; may change Matisse path over time. |
| **Technical risk** | **High** — touches `runtime/`, Metal/CoreML paths, `PREXUSLiteRTEval` preserve surface, battery/thermal; wrong swap breaks Wang llama path. |
| **Required evidence** | [LiteRT adoption decision](../research/litert_lm_adoption_decision.md) updated; device eval on Wang/Matisse; routing policy memo; inventory sign-off for preserved names. |
| **Suggested first PR type** | **docs-only** (decision memo + criteria) → **spike** (eval harness / prototype inference) → implementation only after Codex plan. |
| **Do not start if** | Conflated with rename cleanup; no eval numbers; implies build **`4`** or TestFlight upload; renames `PREXUSLiteRTEval` without scoped migration PR. |

**First docs to read:** [LiteRT adoption decision](../research/litert_lm_adoption_decision.md) · [Preserved PREXUS inventory — eval target](./qwon_preserved_prexus_surface_inventory.md) · [TestFlight tier policy](./qwon_text_alpha_testflight_prep.md#physical-device-lab-tier-policy)

---

### 2. OCR / camera input

| Field | Detail |
| --- | --- |
| **Goal** | Add camera/OCR as multimodal input into orchestrator (sensor platform), not chat decoration. |
| **User impact** | Point-at-text workflows; realtime scene understanding; new permissions UX. |
| **Technical risk** | **High** — Vision pipeline latency, memory, routing to cloud vs local, privacy consent; conflicts with text-only alpha scope. |
| **Required evidence** | Codex architecture plan; routing/memory doc updates; offline-first behavior spec; device battery note. |
| **Suggested first PR type** | **docs-only** (design memo + routing implications) → **spike** (capture + OCR prototype) → implementation in scoped PRs. |
| **Do not start if** | No architecture plan; bundled with unrelated UI; alpha blocker work reopening; PREXUS historical doc edits. |

**First docs to read:** [Phase 1 remaining tasks memo](./phase1_remaining_tasks_design_memo.md) · [architecture.md](../requirements/architecture.md) · [AGENTS.md](../../AGENTS.md) multimodal principles

---

### 3. Model download / GGUF placement UX

| Field | Detail |
| --- | --- |
| **Goal** | In-app model download or guided placement replacing `./tools/scripts/push_local_model_to_device.sh` for **`prexus-local-mvp.gguf`**. |
| **User impact** | Testers skip USB ops; clearer “model missing” vs Fallback; optional progressive download. |
| **Technical risk** | **Medium** — storage quotas, background download, integrity checks, Keychain/network policy; filename **`prexus-local-mvp.gguf`** is preserved until migration PR. |
| **Required evidence** | UX flow mock or memo; storage/battery bounds; Wang re-smoke plan; [models/README.md](../../models/README.md) alignment. |
| **Suggested first PR type** | **docs-only** (UX + ops migration plan) → **spike** (download + verify hash) → implementation. |
| **Do not start if** | Renames GGUF without [inventory](./qwon_preserved_prexus_surface_inventory.md) migration; commits model binaries to git; implies TestFlight upload approval. |

**First docs to read:** [models/README.md](../../models/README.md) · [local inference MVP](../requirements/local_inference_mvp.md) · [QWON feedback intake — Wang GGUF note](./qwon_text_alpha_feedback_intake.md#device-expectations-quick-reference)

---

### 4. Project container rename (`PREXUS.xcodeproj`)

| Field | Detail |
| --- | --- |
| **Goal** | Rename Xcode project **container** from **`PREXUS.xcodeproj`** to QWON-aligned name; keep target/scheme/module **`QWON`** as today. |
| **User impact** | **None** in app UI — developer and CI ergonomics only. |
| **Technical risk** | **Medium** — `generate_xcodeproj.rb`, CI paths, docs links, contributor confusion; easy to break scheme IDs if hand-edited. |
| **Required evidence** | Scoped migration plan; full test matrix; [inventory category 6](./qwon_preserved_prexus_surface_inventory.md) sign-off; no drive-by env/model rename. |
| **Suggested first PR type** | **docs-only** (migration checklist) → **scoped implementation** (generator + paths only) — not bundled with features. |
| **Do not start if** | Bundled with LiteRT/OCR/feature work; cosmetic global PREXUS replace; no CI/regen verification plan. |

**First docs to read:** [Preserved PREXUS inventory — deferred infrastructure](./qwon_preserved_prexus_surface_inventory.md) · [Phase 4 surface audit](./qwon_phase4_rename_surface_audit.md) · [Agent workflow — iOS project regen](./agent_collaboration_workflow.md#ios-project-regeneration)

---

### 5. Public / App Store readiness

| Field | Detail |
| --- | --- |
| **Goal** | Define checklist to exit **TestFlight-only** text-alpha: compliance, support, quality bar, marketing version strategy (**not** build **`4`** approval). |
| **User impact** | Public App Store availability; support burden; broader device matrix. |
| **Technical risk** | **High** — export compliance at scale, crash/quality SLAs, privacy nutrition labels, model distribution policy. |
| **Required evidence** | Release checklist doc; privacy review; support plan; explicit product gate — separate from alpha stable line. |
| **Suggested first PR type** | **docs-only** (readiness checklist + gaps) — **no** upload/tag/bump from planning PRs. |
| **Do not start if** | Conflated with internal alpha build **`4`** decision; unfinished stable alpha posture; PREXUS ASC `6775110218` confusion. |

**First docs to read:** [QWON TestFlight prep — out of scope](./qwon_text_alpha_testflight_prep.md) · [QWON bundle memo](./qwon_bundle_id_decision_memo.md)

---

### 6. Runtime memory / context retention

| Field | Detail |
| --- | --- |
| **Goal** | Persistent cognitive layer — summarization, compression, retrieval, bounded memory growth per [AGENTS.md](../../AGENTS.md) runtime principles. |
| **User impact** | Multi-session continuity; fewer repeated prompts; better long-thread quality without cloud dump. |
| **Technical risk** | **High** — SQLite/vector storage, privacy retention semantics, battery for background compaction; routing/token policy changes. |
| **Required evidence** | Architecture doc updates; retention/privacy matrix; memory ceiling benchmarks; Codex plan before schema changes. |
| **Suggested first PR type** | **docs-only** (retention policy + schema sketch) → **spike** (compression benchmark) → incremental implementation PRs. |
| **Do not start if** | Policy invented in code without Codex review; sends full history to cloud by default; no battery/memory bounds. |

**First docs to read:** [architecture.md](../requirements/architecture.md) · [Agent collaboration workflow](./agent_collaboration_workflow.md) · [next work queue — memory-related deferrals](./qwon_next_work_queue.md#deferred--post-alpha)

---

### 7. UI polish / onboarding

| Field | Detail |
| --- | --- |
| **Goal** | Calm Apple-like onboarding: GGUF status, Wang vs Matisse expectations, Diagnostics literacy, sensitivity explainer — without feature creep. |
| **User impact** | Fewer Fallback misreads; clearer Embedded Heuristic on Matisse; faster first successful turn. |
| **Technical risk** | **Low–medium** — mostly SwiftUI/copy; risk of coupling UI to runtime internals incorrectly. |
| **Required evidence** | DESIGN or copy memo; device QA PNGs (ops/docs paths only); Wang/Matisse tier copy reviewed against [intake template](./qwon_text_alpha_feedback_intake.md#device-expectations-quick-reference). |
| **Suggested first PR type** | **docs-only** (copy + screen map) → **implementation** (scoped UI PR) — still **no** TestFlight upload from UI PR alone. |
| **Do not start if** | Gamified/noisy UI per AGENTS.md; changes routing policy in UI layer; bundled with backend spike. |

**First docs to read:** [AGENTS.md](../../AGENTS.md) UI principles · [QWON feedback intake — device expectations](./qwon_text_alpha_feedback_intake.md#device-expectations-quick-reference)

---

## What is explicitly out of scope for this catalog

| Item | Status |
| --- | --- |
| **TestFlight upload / next internal binary** | **Build `4` not approved** — see [decision checkpoint](./qwon_next_work_queue.md#next-decision-checkpoint) |
| **Implementation PRs** | Require Codex scoped plan after product lane selection |
| **PREXUS historical docs** | Read-only — [PREXUS alpha index](./qwen_text_only_alpha_docs_index.md) |
| **New feedback triage rows** | Intake **closed** — no **`QWON-FB-*`** append |

---

## Quick routing

| Product question | Read |
| --- | --- |
| Which lane should we explore first? | **[Product lane decision](#product-lane-decision)** — UI polish / onboarding selected; [Selection matrix](#selection-matrix) for audit |
| What is the next agent step? | **Codex scoped plan** — implementation **not** approved yet |
| Can we ship code now? | **No** — [Recommended workflow](#recommended-workflow) |
| Can we upload the next TestFlight build? | **Build `4` not approved** — [checkpoint](./qwon_next_work_queue.md#next-decision-checkpoint) |
| Stay on build **`3`** only? | **Yes** — default; no lane selection required |
