# MVP Completion Plan

## Purpose

This document summarizes:

- what has already been implemented in the current PREXUS iOS scaffold
- what remains to reach the next "MVP completion" checkpoint

For this plan, "MVP completion" means the current mobile runtime scaffold is coherent end-to-end across:

- Chat UI
- routing and sensitivity policy
- local/cloud execution handoff
- diagnostics and settings
- test coverage for current behavior
- minimum required documentation

It does **not** mean PREXUS is feature-complete as a cognitive runtime. It marks a stable milestone for the current scaffold.

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

### Relevant recent commits

| Commit | Summary |
|---|---|
| `70b79f8` | Document provider-restricted routing policy |
| `43e0577` | Merge PR for provider-restricted sensitivity UI improvements |
| `5679c29` | Handle provider-restricted routes locally |
| `9f7ad08` | Refine sensitivity helper copy |
| `a41df4a` | Clarify sensitivity mode descriptions |
| `b28b42d` | Improve route status display labels |
| `b80528a` | Add planned route preview |
| `6bf5bdb` | Add per-turn routing sensitivity controls |
| `81705fe` | Persist runtime diagnostics history |
| `a7fa2a2` | Enforce cloud prompt budget limits |

### Current verified state

| Item | State |
|---|---|
| Main branch status | Integrated and pushed through `origin/main` |
| iPhone 16 simulator check | Route labels and sensitivity UI verified |
| Unit test suite | Passing |
| Most recent local verification | `xcodebuild -project app/ios/PREXUS.xcodeproj -scheme PREXUS -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' test` |
| Current test count | 18 passing tests |

## Current MVP Scope

The current scaffold already covers:

- local-first text chat flow
- routing preview before execution
- sensitivity-aware routing
- local/cloud runtime execution switching
- provider unavailability fallback
- runtime diagnostics persistence
- settings-based runtime configuration

The scaffold is still incomplete in several product and runtime areas below.

## Remaining Tasks To MVP Completion

### Plan table

| Priority | Area | Task | Why it matters | Exit criteria |
|---|---|---|---|---|
| P0 | Tests | Add tests for menu fallback picker behavior and 4-mode sensitivity selection | The new UI path is runtime-safe, but UI-level regression coverage is still thin | UI behavior for segmented and menu fallback is covered by tests or snapshot checks |
| P1 | Chat UX | Improve send-state and mode-state clarity during in-flight execution | The routing preview exists, but mode/state transitions are still minimal | User can clearly tell selected sensitivity, planned route, and execution state during a turn |
| P1 | Diagnostics | Distinguish primary routing cause from secondary reasons | Reason labels are readable now, but still flat lists | Diagnostics can identify the dominant routing decision reason without parsing all codes |
| P1 | Settings UX | Expose route policy explanation near cloud/provider settings | Users can toggle cloud settings without understanding routing consequences | Settings explain how cloud escalation, provider keys, and sensitivity interact |
| P1 | Runtime contract | Formalize route decision payload shape and reason-code vocabulary | Human-readable labels exist, but the contract is still implicit | Route fields and reason codes are documented as a stable internal contract |
| P2 | Memory policy | Define whether sensitive turns may be stored in episodic memory by mode | Sensitivity affects routing, but memory retention semantics are still underdefined | Memory policy is documented and enforced per sensitivity level |
| P2 | Multimodal routing | Extend the same sensitivity semantics to OCR, image, and future audio paths | Current flow is strongest in text chat; multimodal consistency is not yet complete | Non-text requests obey the same sensitivity and fallback rules |
| P2 | Evaluation | Track routing quality metrics in a repeatable checklist | The scaffold works, but there is no stable evaluation loop yet | A lightweight evaluation checklist exists for local ratio, fallback frequency, and escalation correctness |

## Recommended Execution Order

### Phase A: Close policy gaps

1. Define the provider allowlist data model
2. Add regression tests for provider-restricted behavior

### Phase B: Close UI gaps

1. Improve Chat sensitivity affordance and execution-state clarity
2. Improve diagnostics readability for multi-reason routes
3. Improve Settings explanations around routing and provider policy

### Phase C: Close runtime consistency gaps

1. Specify memory retention policy by sensitivity level
2. Extend sensitivity semantics to OCR / image / audio paths
3. Add a lightweight routing evaluation checklist

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

## Risks If Left Incomplete

| Risk | Impact |
|---|---|
| `providerRestricted` policy is underdocumented | Product language may drift away from actual runtime behavior |
| Sensitivity policy stays UI-led instead of policy-led | Runtime and Settings behavior become harder to reason about |
| Diagnostics stay flat | Debugging route selection becomes slower as reason vocabulary grows |
| Memory policy remains undefined | Sensitive content handling may become inconsistent later |
| Multimodal paths diverge from text routing | PREXUS loses policy coherence as capabilities expand |

## Notes

- This plan intentionally favors local-first, privacy-preserving defaults.
- Any future cloud restriction feature should fail closed until policy data is present.
- The scaffold is already viable for iterative runtime work, but policy and docs must stay ahead of UX claims.
