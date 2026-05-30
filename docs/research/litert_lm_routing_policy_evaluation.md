# LiteRT-LM Routing Policy Evaluation

## Purpose

This document defines the routing-policy evaluation axis for LiteRT-LM after P1-4b proved that PREXUS can compare Qwen + llama.cpp and LiteRT-LM + Gemma 4 E2B on Wang.

It is a **policy review draft**, not an implementation approval. Production defaults remain unchanged until Codex and product sign off on a separate adoption decision.

Related docs:

- [LiteRT-LM Adoption Decision Memo](./litert_lm_adoption_decision.md)
- [LiteRT-LM Evaluation Plan](./litert_lm_evaluation_plan.md)
- [Local Inference MVP](../requirements/local_inference_mvp.md)

---

## 1. Production invariants

These constraints are fixed for the next implementation step:

| Area | Required behavior |
| --- | --- |
| Production automatic local runtime | Qwen2.5-0.5B-Instruct Q4_K_M via llama.cpp |
| Default model file | `Documents/Models/prexus-local-mvp.gguf` |
| LiteRT-LM status | Prototype/evaluation only |
| User-facing adoption | Not approved |
| Artifact policy | No `.litertlm`, `.gguf`, `.eval-logs`, DerivedData, or screenshots in git |
| Device boundary | LiteRT-LM candidate only on A17 Pro-class and newer devices with artifact present |

No routing policy may silently switch `automatic` from Qwen + llama.cpp to LiteRT-LM.

---

## 2. Two-layer routing model

LiteRT evaluation must not blur cloud-routing policy with local-backend selection.

| Layer | Question | Current owner | Current answer |
| --- | --- | --- | --- |
| L1: execution target | Local vs cloud? | `DefaultRoutingEngine` + `ExecutionPolicy` | Existing sensitivity, modality, key availability, and provider rules |
| L2: local backend | If local, Qwen vs LiteRT candidate? | Not implemented; Codex policy draft only | Qwen default; LiteRT may be evaluated for specific Tier-2 tasks |

L2 selection is only meaningful after L1 has already selected `.local`. It must not override `localOnly`, provider restrictions, cloud-key checks, or modality policy.

---

## 3. Candidate signals

Any future L2 selector must be explainable from bounded, inspectable signals:

| Signal | Use |
| --- | --- |
| Device capability | Gate LiteRT to A17 Pro-class and newer only |
| Artifact availability | Require `prexus-eval-gemma4-e2b.litertlm` or future approved artifact in `Documents/Models` |
| Runtime intent | Consider LiteRT only for intents where Wang evidence suggests quality advantage |
| Sensitivity level | Never use LiteRT to relax local/cloud policy; both backends are local |
| Modality | Text-only candidate for now; vision/audio/tool-use are out of scope |
| Latency budget | Prefer Qwen for short low-complexity prompts unless LiteRT quality advantage is required |
| Contract requirement | Prefer candidates that reliably satisfy structured output contracts |

Signals should be logged in diagnostics when selection becomes implemented.

---

## 4. Evaluation axes

### A. Task fit

| Task shape | Current candidate | Rationale |
| --- | --- | --- |
| General short chat | Qwen | Wang P1-4b showed Qwen is much faster on short prompts |
| Summarization / compression | LiteRT candidate | Wang showed more coherent control-plane summary |
| Routing JSON / schema output | LiteRT candidate | Wang showed valid JSON structure; Qwen output used invalid separators |
| Code reasoning | Out of scope | No P1-4b evidence |
| Creative writing | Out of scope | Not a PREXUS control-plane priority |
| Vision / OCR / audio | Out of scope | LiteRT text backend evidence only |

### B. Latency and responsiveness

P1-4b Wang snapshot:

| Backend | Prompt | Total |
| --- | --- | --- |
| Qwen + llama.cpp | `ja_short` | 402.4 ms |
| Qwen + llama.cpp | `routing_json` | 253.9 ms |
| Qwen + llama.cpp | `control_plane_medium` | 163.3 ms |
| LiteRT + Gemma 4 E2B | `ja_short` | 2671.0 ms (cold load 1768.8 ms) |
| LiteRT + Gemma 4 E2B | `routing_json` | 731.6 ms (warm) |
| LiteRT + Gemma 4 E2B | `control_plane_medium` | 600.0 ms (warm) |

Policy implication: LiteRT must not be selected merely because it is available. It needs a clear quality or contract advantage for the current task.

### C. Structured-output contract

Routing/control-plane prompts require stable machine-readable output. Before LiteRT can serve a selector role, the prompt set must measure:

- strict JSON parse success rate
- markdown fence avoidance or reliable stripping
- required key presence
- enum value validity
- timeout/fallback behavior

### D. Cost and operational fit

LiteRT candidate cost remains material:

- `.litertlm` artifact is about 2.4 GiB in current eval.
- Isolated eval cold load was about 7 s; P1-4b comparison cold load was about 1.8 s under a warmed device/session.
- Memory, thermal, and download UX are not yet product-approved.

### E. Legal and distribution review

Before any shipping path:

- confirm model license and redistribution terms,
- define attribution and App Store review narrative,
- define on-demand download and deletion behavior,
- avoid bundling large artifacts in the app.

---

## 5. Draft policy matrix

This matrix is advisory. It is not an implementation spec until product/Codex sign-off.

| Runtime intent / task | Candidate backend | Status |
| --- | --- | --- |
| General chat / short answer | Qwen + llama.cpp | Keep default |
| Personal scheduling / quick helper | Qwen + llama.cpp | Keep default unless structured output required |
| Tier-2 summarization / compression | LiteRT candidate | Evaluate further |
| Routing JSON / classification | LiteRT candidate | Evaluate strict JSON contract |
| Memory write extraction | LiteRT candidate only after schema tests | Needs evidence |
| Code analysis | Qwen/cloud policy only | LiteRT out of scope |
| Vision/OCR/audio | Existing modality policy | LiteRT out of scope |
| Sub-A17 Pro devices | Qwen fallback / heuristics | LiteRT blocked |

---

## 6. Decision options

| Option | Meaning | Current recommendation |
| --- | --- | --- |
| A. Block LiteRT adoption | Keep LiteRT as research-only | Too early; P1-4b showed enough control-plane promise |
| B. Tier-2 local specialist | Use LiteRT only for selected local Tier-2 text/control-plane tasks | Plausible after more evidence |
| C. Defer with policy review | Keep prototype and gather stricter task/contract evidence | **Recommended now** |
| D. Optional download backend | User-managed high-end model download | Later product/UX decision, not current MVP |

Current path: **C -> possibly B**. Do not promote LiteRT to the default automatic backend.

---

## 7. Sign-off checklist before implementation

Complete this checklist before adding an L2 selector:

### Approved / locked

| Item | Status | Notes |
| --- | --- | --- |
| Production automatic default remains Qwen + llama.cpp | Approved invariant | No selector may change this without a later adoption PR |
| Fallback diagnostics preserve actual responding backend | Approved | Covered in P1-4b tests, including nested fallback |
| Device and artifact gates remain mandatory | Approved invariant | A17 Pro-class+, `.litertlm` present, compile/debug gate until adoption |
| L1 routing policy remains unchanged | Approved invariant | LiteRT evaluation does not change local vs cloud decisions |
| Non-goals remain enforced | Approved invariant | No broad backend registry, no model artifacts in git, no production default switch |

### Needs evidence

| Item | Status | Required evidence |
| --- | --- | --- |
| Exact intents eligible for LiteRT | Needs evidence | P1-4c-a strict JSON and control-plane prompt results |
| Strict JSON parse benchmark passes agreed threshold | Needs evidence | Parse success rate, required-key rate, enum validity, markdown-fence handling |
| 5-10 minute thermal/memory run is recorded | Needs evidence | Peak memory proxy, thermal state, failure/fallback behavior, battery observation |
| Product accepts latency trade-off for eligible intents | Needs evidence | Cold/warm latency table plus task-quality delta for candidate intents |

### Blocked until product/legal

| Item | Status | Required decision |
| --- | --- | --- |
| Artifact download/storage/deletion UX is defined | Blocked | Product UX and storage policy for ~2.4 GiB artifacts |
| Legal/distribution sign-off is recorded | Blocked | Model license, redistribution, attribution, and App Store review narrative |

### 7.5 Cursor instructions

Cursor may prepare evidence for the `Needs evidence` rows only. Cursor must not implement an L2 selector, change `automatic`, or wire LiteRT into production routing.

Allowed P1-4c work:

- P1-4c-a: strict JSON benchmark for Qwen vs LiteRT on Wang.
- P1-4c-b: 5-10 minute thermal/memory eval for LiteRT prototype runs.
- Gitignored logs under `.eval-logs/` and docs summaries with exact commands/results.

Forbidden until policy freeze:

- L2 selector implementation.
- Production `automatic` behavior changes.
- User-facing LiteRT adoption UX.
- Model artifact commits.

---

## 8. Implementation boundary

Only after policy freeze:

1. Add a narrow L2 selector for local text tasks.
2. Keep Qwen as default for all unspecified cases.
3. Keep LiteRT behind compile, device, artifact, and user/debug gates until adoption is explicitly approved.
4. Log selected backend, fallback reason, and contract outcome.
5. Add tests for every policy row.

Do not introduce a broad backend registry or plugin framework until at least two production-eligible local backends are approved.

---

## 9. P1-4c evidence plan

P1-4c exists to close the `Needs evidence` rows above. It must produce evidence, not product behavior.

### P1-4c-a: strict JSON benchmark

Goal: compare Qwen + llama.cpp and LiteRT + Gemma 4 E2B on structured control-plane prompts.

Required prompt classes:

- routing classification (`intent`, `confidence`, `needs_cloud`)
- summarization metadata (`summary`, `todos`, `local_sufficient`)
- memory extraction (`should_write_memory`, `memory_summary`, `sensitivity`)

Required measurements:

- strict JSON parse success rate
- required-key presence
- enum validity
- markdown-fence rate
- total latency per prompt
- fallback/failure count

Exit condition: docs record whether LiteRT has a clear structured-output advantage large enough to justify candidate intent rows. No selector implementation.

#### Wang results (2026-05-30, `generatedAt` 14:28:46Z)

Command:

```bash
./tools/scripts/eval_strict_json_on_device.sh "Wang"
```

Artifacts (gitignored): `.eval-logs/litert-strict-json-Wang-detail.csv`, `.eval-logs/litert-strict-json-Wang-summary.json`

Frozen prompt set: 12 prompts (`StrictJSONEvalPromptSet` — 4 routing, 4 summarization, 4 memory).

| Backend | strict pass | required keys | enum valid | markdown fence | median total ms | failures | fallbacks |
| --- | --- | --- | --- | --- | --- | --- | --- |
| qwen_llama_cpp | **8/12 (66.7%)** | 83.3% | 66.7% | 8.3% | ~423 | 0 | 0 |
| litert_lm_gemma4 | **12/12 (100%)** | 100% | 100% | **100%** | ~1218 | 0 | 0 |

By category (strict pass rate):

| Category | qwen_llama_cpp | litert_lm_gemma4 |
| --- | --- | --- |
| routingClassification | 4/4 | 4/4 |
| summarizationMetadata | 4/4 | 4/4 |
| memoryExtraction | **0/4** | 4/4 |

Interpretation (evidence only):

- LiteRT meets structured contracts on all 12 prompts on Wang when fences are stripped; **always wraps JSON in markdown fences** (100% fence rate).
- Qwen is fast (~423 ms median) but **fails all memory-extraction strict prompts** (nested object / non-JSON shapes). Routing and summarization prompts pass on-device scorer; outputs often use **`;` separators** — PR adds explicit `semicolon_separator` rejection in `StrictJSONEvalScorer` for RFC-strict reruns.
- **No L2 selector implication:** tier-2 structured tasks are a plausible LiteRT candidate on A17 Pro+, but latency ~3× Qwen and fence stripping remain product costs.
- §7 row **#9** moves to **partial evidence** (Wang run complete; product pass bar and semicolon-strict rerun TBD). **#10** latency trade-off still **Needs evidence** (product ms budget).

### P1-4c-b: thermal and memory run

Goal: determine whether LiteRT prototype sessions are operationally viable on Wang-class devices.

Required run shape:

- 5-10 minute bounded run on Wang or equivalent A17 Pro-class+ device.
- repeated Tier-2 prompts with warm engine behavior.
- capture best available memory proxy, thermal state, latency drift, and failures.
- preserve logs under `.eval-logs/` only.

Exit condition: docs record whether LiteRT can remain a candidate under PREXUS battery/thermal constraints. No adoption decision unless product/Codex later sign off.
