# MVP Completion Plan

## Purpose

This document summarizes:

- what has already been implemented in the current QWON iOS scaffold
- what remains to reach the next "MVP completion" checkpoint

For this plan, "MVP completion" means the current mobile runtime scaffold is coherent end-to-end across:

- Chat UI
- routing and sensitivity policy
- local/cloud execution handoff
- diagnostics and settings
- test coverage for current behavior
- minimum required documentation

It does **not** mean QWON is feature-complete as a cognitive runtime. It marks a stable milestone for the current scaffold.

## Completed Work

### Recent completed implementation

| Area | Status | Implemented |
|---|---|---|
| Planned route preview | Done | Added per-turn preview routing in Chat before send |
| Per-turn sensitivity override | Done | Added `localOnly`, `localPreferred`, `escalationAllowed`, `providerRestricted` support in the iOS Chat flow |
| Route display labels | Done | Replaced raw route codes with human-readable route and reason labels |
| Diagnostics history | Done | Persisted recent runtime decisions and exposed them in Settings |
| Cloud prompt budgeting | Done | Trimmed cloud prompt packaging to configured token budget |
| Provider key fallback | Done | Rerouted cloud selections to local when provider keys are unavailable |
| Provider-restricted policy path | Done | `providerRestricted` now evaluates an explicit approved-provider allowlist and fails closed to local when no approved provider matches |
| Sensitivity UI fallback | Done | Added short segmented labels and a menu fallback for narrow layouts |
| Sensitivity helper copy | Done | Added and refined helper text for each sensitivity mode |
| Provider-restricted policy docs | Done | Documented current behavior and approved-provider meaning in routing docs |
| Sensitivity policy ownership docs | Done | Documented runtime-vs-UI ownership for sensitivity policy in architecture docs |
| Diagnostics prioritization | Done | Surfaced primary routing cause ahead of secondary reasons in runtime diagnostics |
| In-flight Chat state | Done | Kept active route and sensitivity visible while a turn is executing |
| Memory retention policy | Done | Enforced sensitivity-based episodic memory retention rules |
| Multimodal sensitivity contract | Done | Aligned image / OCR / audio routing with the same sensitivity and fallback rules |
| Routing evaluation loop | Done | Added a repeatable MVP routing evaluation checklist |

### Relevant recent commits

| Commit | Summary |
|---|---|
| `f1d85c4` | Add routing evaluation checklist |
| `2542131` | Align multimodal sensitivity routing |
| `8a3e0cf` | Enforce sensitivity-based memory retention |
| `5f029d8` | Clarify in-flight chat routing state |
| `7a7f4d7` | Document route decision contract |
| `314d457` | Prioritize primary diagnostics reasons |
| `ea05853` | Clarify routing policy in settings |
| `231ca9e` | Unify sensitivity labels and test coverage |
| `8125549` | Document sensitivity policy ownership |
| `0b5a14c` | Add provider restriction allowlist policy |
| `70b79f8` | Document provider-restricted routing policy |
| `43e0577` | Merge PR for provider-restricted sensitivity UI improvements |

### Current verified state

| Item | State |
|---|---|
| Main branch status | Integrated and pushed through `origin/main` |
| iPhone 16 simulator check | Route labels and sensitivity UI verified |
| Unit test suite | Passing |
| Most recent local verification | `xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' test` |
| Current test count | 30 passing tests |
| Current MVP checkpoint | Achieved for the present iOS routing scaffold |

## Current MVP Scope

The current scaffold already covers:

- local-first text chat flow
- routing preview before execution
- sensitivity-aware routing
- local/cloud runtime execution switching
- provider unavailability fallback
- runtime diagnostics persistence
- settings-based runtime configuration

The scaffold is coherent for the current MVP checkpoint. Remaining work now sits mostly beyond this checkpoint, not inside it.

## Remaining Tasks To MVP Completion

Current status: no blocking tasks remain for the current MVP completion checkpoint.

### Plan table

| Priority | Area | Task | Why it matters | Exit criteria |
|---|---|---|---|---|
| Done | Tests | Added regression coverage for 4-mode sensitivity labels and helper descriptions | Sensitivity UI paths now have repeatable behavior checks | `SensitivityLevel` labels and descriptions are test-covered |
| Done | Chat UX | Improve send-state and mode-state clarity during in-flight execution | In-flight turns now keep route and sensitivity state visible | User can clearly tell selected sensitivity, planned route, and execution state during a turn |
| Done | Diagnostics | Distinguish primary routing cause from secondary reasons | Multi-reason routes are easier to scan during debugging | Diagnostics highlight a dominant cause before secondary labels |
| Done | Settings UX | Expose route policy explanation near cloud/provider settings | Users can see policy context without inferring it from toggles | Settings summarize escalation, restricted providers, and cloud readiness together |
| Done | Runtime contract | Formalize route decision payload shape and reason-code vocabulary | Route payload and reason vocabulary are now explicit in docs | Route fields and reason-code categories are documented in routing requirements |
| Done | Memory policy | Define whether sensitive turns may be stored in episodic memory by mode | Sensitive turns now have explicit auto-retention behavior | Memory policy is documented and enforced per sensitivity level |
| Done | Multimodal routing | Extend the same sensitivity semantics to OCR, image, and future audio paths | Current runtime inputs now document and test shared routing semantics across modalities | Non-text requests obey the same sensitivity and fallback rules |
| Done | Evaluation | Track routing quality metrics in a repeatable checklist | The scaffold now has a lightweight routing review loop | A lightweight evaluation checklist exists for local ratio, fallback frequency, and escalation correctness |

## Recommended Execution Order

The original execution order is retained below as a record of how the checkpoint was closed.

### Phase A: Close policy gaps

1. Completed: define the provider allowlist data model
2. Completed: add regression tests for provider-restricted behavior
3. Completed: document the route payload and reason-code contract

### Phase B: Close UI gaps

1. Completed: improve Chat sensitivity affordance and execution-state clarity
2. Completed: improve diagnostics readability for multi-reason routes
3. Completed: improve Settings explanations around routing and provider policy

### Phase C: Close runtime consistency gaps

1. Completed: specify memory retention policy by sensitivity level
2. Completed: extend sensitivity semantics to OCR / image / audio paths
3. Completed: add a lightweight routing evaluation checklist

## Completion Criteria

The current MVP checkpoint should be considered complete when all of the following are true:

| Criterion | Required state |
|---|---|
| Routing policy | Sensitivity modes are implemented, documented, and test-covered |
| Provider restriction | `providerRestricted` is backed by an explicit policy model and fails closed when no approved provider matches |
| Chat UI | All sensitivity modes are selectable and understandable on narrow and standard layouts |
| Diagnostics | Recent runtime decisions are readable and useful for debugging |
| Settings | Cloud escalation and provider policy behavior are understandable from the UI |
| Tests | Current runtime and sensitivity behavior are covered by repeatable tests |
| Docs | Routing, sensitivity, and provider restriction behavior are documented in requirements and architecture docs |
| Evaluation | A repeatable routing checklist exists for local ratio, fallback frequency, and escalation correctness |

Current result:

- all completion criteria above are satisfied for the present scaffold
- future work should be tracked as post-MVP expansion, not as unresolved MVP closure work

## Risks If Left Incomplete

The items below are now primarily future-regression risks rather than current checkpoint blockers.

| Risk | Impact |
|---|---|
| `providerRestricted` policy is underdocumented | Product language may drift away from actual runtime behavior |
| Sensitivity policy stays UI-led instead of policy-led | Runtime and Settings behavior become harder to reason about |
| Diagnostics stay flat | Debugging route selection becomes slower as reason vocabulary grows |
| Memory policy remains undefined | Sensitive content handling may become inconsistent later |
| Multimodal paths diverge from text routing | QWON loses policy coherence as capabilities expand |

## Notes

- This plan intentionally favors local-first, privacy-preserving defaults.
- Any future cloud restriction feature should fail closed until policy data is present.
- The scaffold is already viable for iterative runtime work, but policy and docs must stay ahead of UX claims.
- The current routing evaluation loop is documented in [routing_evaluation_checklist.md](./routing_evaluation_checklist.md).
- The current Codex/Cursor delivery split is documented in [agent_collaboration_workflow.md](./agent_collaboration_workflow.md).
