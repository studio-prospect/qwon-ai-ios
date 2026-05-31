# LiteRT-LM Adoption Decision Memo

## Purpose

This memo records the **post-feasibility adoption question** for LiteRT-LM in PREXUS. It does **not** authorize production adoption. It defines what must be compared next, what would justify a second local backend, and how to scope the following prototype without disturbing the Qwen MVP path.

Related evidence:

- [LiteRT-LM Evaluation Plan](./litert_lm_evaluation_plan.md) — P1-4 feasibility lane and device logs
- [Gemma-4-E2B-it Evaluation Plan](./gemma4_e2b_evaluation_plan.md) — GGUF path results on Wang
- [Local LLM Notes](./local_llm_notes.md) — research directions
- [Local Inference MVP](../requirements/local_inference_mvp.md) — production P1-1 contract
- [LiteRT-LM Routing Policy Evaluation](./litert_lm_routing_policy_evaluation.md) — post-P1-4b L2 selection policy draft

---

## 1. Current status

| Area | Status |
| --- | --- |
| LiteRT-LM feasibility (A17 Pro+) | **Proven on Wang** (iPhone 17 / `iPhone18,3`, A19-class) via isolated `PREXUSLiteRTEval` (reproducible — see [evaluation plan](./litert_lm_evaluation_plan.md)) |
| LiteRT-LM on sub–A17 Pro | **Not supported** in current eval — Matisse (iPhone XS Max / A12) failed with `Failed to create engine` |
| Production local runtime | **Unchanged** — llama.cpp via `LlamaCppLocalModelClient` |
| Default local model | **Unchanged** — `Qwen2.5-0.5B-Instruct` Q4_K_M as `prexus-local-mvp.gguf` |
| Gemma 4 E2B via GGUF + llama.cpp | **Evaluated, not adoptable** — loads on Wang but output unusable (`？`) |
| Gemma 4 E2B via LiteRT-LM `.litertlm` | **Feasible on Wang** — coherent Japanese + valid routing JSON in smoke eval |
| PREXUS main app integration | **P1-4b complete** — `LiteRTLocalModelClient` behind `PREXUS_LITERT_LM_PROTOTYPE=1`; production automatic path unchanged |
| Isolated eval app | `jp.studio-prospect.prexus.ios.literteval` — regenerate with `PREXUS_LITERT_LM_EVAL=1` when eval target changes |

### Wang feasibility snapshot (2026-05-30)

| Metric | LiteRT-LM + Gemma 4 E2B `.litertlm` |
| --- | --- |
| Cold load | ~6952 ms |
| JA first-token | ~754 ms |
| Japanese short answer | Coherent |
| Routing JSON | Valid (`intent`, `confidence`, `needs_cloud`) |
| Artifact size on device | ~2.41 GiB |

### Device class assumption

**A12-class and older iPhones are not assumed supported** for LiteRT-LM + Gemma 4 E2B in the current artifact/backend combination. Product routing must continue to treat sub–A17 Pro hardware as **llama.cpp + Qwen MVP or embedded heuristic fallback**, unless a future eval proves otherwise.

---

## 2. Adoption question

**Should PREXUS add LiteRT-LM as a second local backend for high-end devices only?**

This is **separate** from replacing the MVP path:

| Question | Answer today |
| --- | --- |
| Replace Qwen MVP default? | **No** — not justified by feasibility alone |
| Replace llama.cpp as the only production backend? | **No** |
| Add optional high-tier path (A17 Pro+) for Gemma-class tasks? | **Maybe** — requires comparison and prototype evidence |
| Use LiteRT-LM for routing / compression control plane? | **Maybe** — routing JSON smoke passed; needs PREXUS-integrated prompts and policy review |

**Decision today:** **Defer adoption.** Continue production on **Qwen + llama.cpp**. Authorize a **bounded debug/compile-gated prototype** to compare backends inside PREXUS-shaped prompts, not a runtime rewrite.

---

## 3. Required comparison before adoption

Side-by-side evidence on **the same device class (A17 Pro+)** and **the same prompt set** is required. Feasibility smoke alone is insufficient.

### Comparison matrix

| Dimension | Qwen MVP + llama.cpp (production) | LiteRT-LM + Gemma 4 E2B (candidate) | Adoption threshold (draft) |
| --- | --- | --- | --- |
| **Cold load** | Lower ( ~400 MB artifact; Wang QA observed fast enough for daily use) | ~7 s on Wang smoke | LiteRT must not regress perceived “open app → first useful reply” beyond agreed budget (TBD ms, product-owned) |
| **First-token latency** | Acceptable on Wang for general chat (manual QA) | ~754 ms post-load on Wang smoke | Must meet or beat Qwen on Tier-2 control prompts, not only chat |
| **Decode throughput** | Adequate for MVP chat on Wang | ~0.9 t/s on 1-sentence smoke (not representative) | Medium-prompt bench required; compare tokens/sec at stable thermal state |
| **Memory / thermal** | ~374 MiB class (Mac bench); device QA stable on Wang | ~2.4 GiB artifact; thermal not instrumented in P1-4 | Peak memory and 5–10 min session thermal must stay within PREXUS battery policy |
| **Package size** | ~400 MB user-downloaded GGUF | ~2.4 GB `.litertlm` | Distribution model (on-demand download, CDN, cap) must be explicit before ship |
| **Artifact distribution & licensing** | HF GGUF via `fetch_local_model.sh`; Qwen license | HF `litert-community/gemma-4-E2B-it-litert-lm`; Apache-2.0 model card | Legal/product sign-off on redistribution, attribution, and App Store narrative |
| **Japanese short-form quality** | Coherent on Wang (production QA) | Coherent on Wang (LiteRT smoke) | LiteRT must win on **Tier-2** prompts (summarize, route, compress), not merely match chat |
| **Deterministic routing JSON** | Supported by Qwen path in production | Valid JSON in LiteRT smoke | Schema conformance rate ≥ agreed bar under fixed prompts; no markdown fence drift in production prompts |
| **Failure / fallback** | `FallbackLocalModelClient` → embedded heuristics | Not wired in PREXUS app | On LiteRT failure: silent fallback to Qwen llama.cpp, then heuristics; never user-visible crash |
| **Device class boundary** | A17 Pro+ for llama.cpp primary | A17 Pro+ proven; A12 blocked | Runtime gate: LiteRT only when `DeviceCapability` ≥ A17 Pro and artifact present |

### Evidence gaps (must close in prototype)

1. **Head-to-head bench exists for the P1-4b prompt set**, but strict schema success rates, thermal/memory runs, and broader prompt coverage are still missing.
2. **No peak memory or thermal** capture for LiteRT-LM in PREXUS-shaped sessions.
3. **No App Store / download UX** for a second large artifact.
4. **Integrated fallback (prototype only)** — P1-4b: LiteRT → Qwen llama.cpp → heuristics when debug toggle + gates pass; not production default.
5. **Gemma vs Qwen role split** undefined — adoption needs a routing policy (when to select LiteRT), not only backend availability.

---

## 4. Adoption conditions (draft)

Adopt LiteRT-LM as a **second** local backend (not default) only if **all** hold:

1. **Device gate:** A17 Pro-class and newer only; sub–A17 Pro never attempts LiteRT load.
2. **Comparison win:** On Wang (or equivalent), LiteRT path meets or beats Qwen MVP on agreed Tier-2 prompts for JSON reliability and Japanese task quality, within latency/memory budgets.
3. **Operational fit:** On-demand artifact download, storage cap, and recovery are designed (no silent 2.4 GiB ship in app bundle).
4. **Fallback proven:** LiteRT timeout/OOM/engine failure routes to Qwen llama.cpp, then embedded heuristics, with diagnostics surfaced.
5. **Policy approval:** Codex + product accept routing implications (when Gemma-class model runs vs Qwen MVP).
6. **API stability:** Swift API Early Preview risk accepted or mitigated (pinned vendor commit, crash isolation).

## 5. Non-adoption conditions (draft)

Do **not** adopt LiteRT-LM as a production backend if any of the following persist:

1. Side-by-side comparison shows **no clear Tier-2 advantage** over Qwen MVP on A17 Pro+.
2. **Cold load + artifact size** break local-first UX or storage constraints.
3. **Thermal/memory** cost fails battery strategy targets.
4. **Licensing or distribution** blocks App Store or enterprise deployment.
5. **Sub–A17 Pro** support is required for the same Gemma-class capability — current path does not provide it.
6. Integration requires a **premature generic “multi-backend” framework** before two-backend behavior is proven in code.

---

## 6. Proposed next prototype (P1-4b)

**Title:** Debug-only second backend prototype — LiteRT-LM on A17 Pro+

**Status:** Complete on `main`; see the Wang head-to-head results in the PR #17 test plan and the routing-policy follow-up in [LiteRT-LM Routing Policy Evaluation](./litert_lm_routing_policy_evaluation.md).

### In scope

| Item | Requirement |
| --- | --- |
| Integration surface | Compile-gated (`PREXUS_LITERT_LM_PROTOTYPE=1`) + Debug Settings toggle — **not** default `AppLocalModelFactory` automatic mode |
| Backend selection | Debug toggle for chat path; `PREXUS_RUN_BACKEND_COMPARISON=1` for head-to-head script — **no** production default switch |
| Model placement | `prexus-eval-gemma4-e2b.litertlm` under `Documents/Models/` via `LiteRTModelPlacement`; **do not** replace `prexus-local-mvp.gguf` |
| Client shape | `LiteRTLocalModelClient` on `LocalModelClient`; `LocalModelExecutionTrace` for `answered_by` + metrics in diagnostics |
| Fallback | LiteRT failure → `makeQwenFallbackChain()` (llama.cpp Qwen → embedded heuristics) |
| Measurement | `LocalBackendComparisonRunner` (ja_short, routing_json, control_plane_medium) → `Documents/prexus-backend-comparison.log` |
| Xcode | Default `ruby tools/scripts/generate_xcodeproj.rb` (no LiteRT in PREXUS); prototype: `PREXUS_LITERT_LM_PROTOTYPE=1`; eval app: `PREXUS_LITERT_LM_EVAL=1` |

### Out of scope

- Changing production default model or runtime
- Removing Qwen fallback or llama.cpp primary for A17 Pro+
- Committing `.litertlm`, GGUF, DerivedData, screenshots, or `.eval-logs`
- Multimodal, tool-use, or session-cloning features
- Broad `LocalBackendRegistry`-style refactors without measured need
- Replacing `PREXUSLiteRTEval` standalone app with production UX in the same PR

### Deliverables (P1-4b implementation)

1. `LiteRTLocalModelClient` + `LiteRTModelPlacement` (eval `.litertlm` only)
2. Debug Settings toggle: “Use LiteRT eval backend (A17 Pro+ only)” — off by default
3. `tools/scripts/compare_local_backends_on_device.sh` — install Debug PREXUS, push artifacts, launch with `PREXUS_RUN_BACKEND_COMPARISON=1`, fetch CSV log
4. Update comparison table below after Wang run (metrics in PR body)

### Exit criteria for prototype

| Outcome | Next step |
| --- | --- |
| LiteRT wins on Tier-2 comparison within budgets | Open **adoption PR** with routing policy proposal (Codex-owned) |
| Qwen sufficient; LiteRT marginal | **Block adoption**; keep LiteRT in research notes only |
| LiteRT unstable | **Block** with pinned failure evidence; stay on llama.cpp |

---

## 7. Review gates (Codex)

Codex should **reject** PRs that:

- Switch the default local model away from Qwen
- Replace the production llama.cpp backend or automatic factory path with LiteRT-LM
- Commit model binaries (`.litertlm`, `.gguf`), DerivedData, screenshots, or `.eval-logs`
- Introduce broad backend abstractions before the P1-4b prototype proves necessity
- Omit test-plan results for the actual device/backend path attempted
- Regenerate `PREXUS.xcodeproj` without documenting the `PREXUS_LITERT_LM_EVAL` flag behavior when eval targets change

Codex should **accept** docs-only PRs that record decisions without code changes.

Any iOS project or source change must include:

```bash
ruby tools/scripts/generate_xcodeproj.rb
```

(and `PREXUS_LITERT_LM_EVAL=1` only when `PREXUSLiteRTEval` or LiteRT package linkage changes).

---

## 8. Summary decision record

| Date | Decision |
| --- | --- |
| 2026-05-30 | LiteRT-LM **feasibility proven** on Wang; **not adopted** for production |
| 2026-05-30 | **Matisse blocked** — do not assume A12 support |
| 2026-05-30 | **P1-4b merged:** compile-gated `LiteRTLocalModelClient`, debug toggle, comparison runner + script; production Qwen path unchanged |
| 2026-05-30 | **Routing policy separated:** PR #18 added L2 policy evaluation before any selector implementation |
| 2026-05-30 | **Next:** P1-4c-a strict JSON benchmark and P1-4c-b thermal/memory eval; no L2 selector until checklist sign-off |

**Owner split:** Cursor implements prototype and evidence; Codex owns adoption policy, routing semantics, and merge readiness.
