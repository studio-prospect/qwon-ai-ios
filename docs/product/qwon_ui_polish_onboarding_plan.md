# QWON UI Polish / Onboarding — Scoped Plan

**Last updated:** 2026-06-03 (UI-1 complete · UI-2 need assessment)
**Status:** **PR UI-1 complete** (#80 + #81 post-merge verification) — **UI-2 deferred / not opened**; **UI-2 not approved**; **Build `4` not approved**.
**Purpose:** Define the first post-alpha UI polish / onboarding lane after **QWON `0.1.0 (3)` stable alpha**. Keep runtime behavior, model placement, TestFlight build number, and historical PREXUS records unchanged.

Related: [Post-alpha option lanes](./qwon_post_alpha_options.md#product-lane-decision) · [Next work queue](./qwon_next_work_queue.md#next-decision-checkpoint) · [QWON feedback intake close](./qwon_text_alpha_feedback_intake.md#feedback-window-close-2026-06-03) · [QWON lab evidence](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

---

## Baseline

| Field | Value |
| --- | --- |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha |
| **Feedback window** | **Closed** — **QWON-FB-001**, **QWON-FB-002** operational pass; no blockers |
| **Wang expectation** | Local model present; Chat shows local runtime and `llama.cpp On-Device Runtime` in Diagnostics |
| **Matisse expectation** | Older-device path; install/launch pass; Embedded Heuristic backend/detail is expected |
| **Build `4`** | **Not approved** |
| **Runtime policy** | Qwen + llama.cpp remains the QWON alpha local path; no LiteRT selector or backend change |

This plan is a UI/copy/onboarding boundary. It does **not** reopen feedback intake and does **not** create a release-engineering gate.

---

## Product Goal

Improve first-use comprehension without changing app behavior:

| Goal | Intended result |
| --- | --- |
| **First-run clarity** | A new tester understands what QWON does before sending the first prompt. |
| **Local runtime clarity** | Wang vs Matisse expectations are readable without interpreting raw diagnostics. |
| **GGUF status clarity** | Missing local model and heuristic fallback are presented as state, not mystery failure. |
| **Diagnostics literacy** | `answered_by`, `primary_failure`, and `fallback_reason` map to plain-language meanings. |
| **Sensitivity clarity** | The four sensitivity modes remain visible and their local/cloud implication is easier to understand. |

---

## Non-Goals

| Do not do | Reason |
| --- | --- |
| Change routing, fallback, model loading, or backend selection | This lane is UI polish only. |
| Add model download, delete USB push workflow, or rename `prexus-local-mvp.gguf` | Model acquisition is a separate post-alpha lane. |
| Add LiteRT, OCR, multimodal capture, memory retention, or cloud policy changes | Deferred lanes need separate Codex plans. |
| Approve or imply build `4`, TestFlight upload, tag, or version bump | Product/release-engineering gate remains separate. |
| Rewrite historical `qwen_text_only_alpha_*` PREXUS docs | Frozen historical baseline. |
| Rename preserved `PREXUS_*` env flags, `PREXUSLiteRTEval`, or `PREXUS.xcodeproj` | Covered by preserved-surface inventory and deferred infra gates. |

---

## Screen Scope

| Screen / surface | Allowed polish |
| --- | --- |
| **Chat header** | Refine subtitle/status wording so the local-first runtime premise is clear. |
| **Chat status area** | Clarify latest execution state, local fallback state, and backend label without adding logic. |
| **Composer** | Improve placeholder/helper copy for sensitivity and send behavior; preserve compact SE-width layout. |
| **Settings** | Clarify Runtime control, Local Runtime picker, Provider/Cloud settings, and Recent Runtime Decisions entry. |
| **Runtime Diagnostics** | Improve intro, empty state, summary labels, and detail explanations for `answered_by`, `primary_failure`, and `fallback_reason`. |

Prefer existing UI primitives and patterns already present in QWON (`QWONLiquidGlass`, `QWONSurfaceCard`, `QWONStatusChip`, current SwiftUI layout style). Do not introduce a new design system layer for this lane.

---

## Copy Map

### Required meanings

| Concept | Plain-language meaning to preserve |
| --- | --- |
| **Local runtime** | QWON tries to answer locally first when a local model path is available. |
| **Wang / local model present** | The expected backend is `llama.cpp On-Device Runtime`. |
| **Matisse / older device path** | Embedded Heuristic Runtime can be the expected local fallback; this is not a lab failure. |
| **Model missing** | Local model file is not available; QWON may answer through heuristic fallback. Do not imply in-app download exists. |
| **Provider Restricted** | Current alpha behavior is local-fixed fallback unless provider policy changes elsewhere. |
| **Diagnostics** | A support screen showing how the last turn was answered and why fallback happened. |

### Do not say

| Avoid wording | Why |
| --- | --- |
| “Fully offline” | Cloud/provider settings exist; local-first is not the same as offline-only. |
| “Download the model in QWON” | In-app model download is not implemented. |
| “Matisse failed because no llama.cpp” | Matisse heuristic path is expected for this alpha tier. |
| “Build `4` coming” | Build `4` is not approved. |
| “PREXUS was removed” | Historical/preserved surfaces remain intentionally. |

---

## Implementation PR Split

### PR UI-1 — Copy and comprehension polish

| Field | Requirement |
| --- | --- |
| **Scope** | Chat, Settings, Runtime Diagnostics copy/labels/helper text only; use existing layout primitives. |
| **Allowed code changes** | SwiftUI text, labels, accessibility labels/identifiers if needed, tests that assert updated copy. |
| **Forbidden** | Runtime logic, routing logic, model placement, backend selection, build number, TestFlight docs claiming upload. |
| **Expected review focus** | Does the UI explain Wang/Matisse/local fallback correctly without overclaiming? |

### PR UI-2 — Optional small onboarding structure

Open only if UI-1 shows the current surfaces cannot explain the alpha state clearly with copy alone.

| Field | Requirement |
| --- | --- |
| **Scope** | One small first-run/empty-state card or diagnostics explainer using existing components. |
| **Gate** | Codex review of UI-1 outcome; no automatic follow-up. |
| **Forbidden** | New storage state, onboarding persistence, model download CTA, or release bump. |

### PR UI-3 — Evidence/docs update

Open only after UI changes land and screenshots/evidence exist.

| Field | Requirement |
| --- | --- |
| **Scope** | Docs-only: screenshot filenames, device QA notes, and updated tester guidance if needed. |
| **Artifact rule** | PNG/log files remain ops storage unless an existing design-doc screenshot workflow explicitly allows repo screenshots. |
| **Forbidden** | Fabricated lab results or TestFlight upload claims. |

---

## Acceptance Criteria

| Area | Criteria |
| --- | --- |
| **Runtime behavior** | No changes to route decisions, fallback chain, model lookup, local/cloud policy, or LiteRT wiring. |
| **Wang clarity** | UI/docs still communicate local model present → `llama.cpp On-Device Runtime`. |
| **Matisse clarity** | UI/docs do not present Embedded Heuristic Runtime as a failure for the alpha secondary tier. |
| **Diagnostics clarity** | `answered_by`, `primary_failure`, and `fallback_reason` have understandable labels or helper text. |
| **Sensitivity** | Four modes remain reachable, including compact-width fallback behavior. |
| **Small-device layout** | iPhone SE width remains usable; no selector or composer regression. |
| **Release gate** | Build `4`, TestFlight upload, tag, and version bump remain unapproved. |
| **Historical surfaces** | Frozen PREXUS docs and preserved PREXUS runtime names remain untouched. |

---

## Verification Plan

For the docs-only plan PR:

```sh
git diff --check
```

For the first implementation PR:

```sh
ruby tools/scripts/generate_xcodeproj.rb
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' test
```

Recommended manual QA for implementation PRs:

| Device / surface | Check |
| --- | --- |
| **iPhone 16 simulator** | Chat, Settings, Diagnostics copy; compact/regular layout sanity. |
| **iPhone SE width** | Sensitivity selector fallback and composer still usable. |
| **Wang** | If device QA is run, local model present path reads as local/llama.cpp. |
| **Matisse** | If device QA is run, heuristic wording reads as expected secondary-tier fallback. |

Do not run TestFlight upload or tag from UI polish PRs unless product opens a separate release-engineering gate.

---

## Post-merge verification (2026-06-03)

**Base commit:** `fbee72f` — [PR #80](https://github.com/studio-prospect/qwon-ai-ios/pull/80) merged to `main`.

**Scope:** Simulator layout/copy sanity only. **No additional implementation.** **Build `4`**, TestFlight upload, tag, and version bump **not approved**.

| Check | Device / surface | Result | Notes |
| --- | --- | --- | --- |
| Chat composer + Send | iPhone SE (3rd generation), iOS 18.2 Simulator | **Pass** | `Ask QWON` field and Send button visible; no horizontal clip. |
| Sensitivity selector (compact fallback) | iPhone SE width | **Pass** | `ViewThatFits` falls back to menu picker (`Local Preferred ▾`); four modes reachable. |
| Sensitivity footnote | iPhone SE width | **Pass** | Helper + footnote wrap; composer remains usable. |
| Onboarding hint (UI-only strip) | iPhone SE width | **Pass** | Wang / Matisse copy wraps inside `QWONRuntimeStrip`; system seed stays `QWON runtime initialized.` |
| Fallback status helper | iPhone SE width | **Pass (structural)** | Same strip + `fixedSize` pattern as onboarding hint; not triggered in default UI-test launch (no post-turn Fallback banner). |
| Chat / Settings / Diagnostics copy | iPhone 16, iOS 18.4 Simulator | **Pass** | `QWONUITests` navigation + seeded surfaces passed; updated copy readable on all three screens. |
| Runtime / routing / backend | — | **Unchanged** | Verification docs-only; no code changes in this step. |

**Commands run:**

```sh
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation),OS=18.2' \
  -only-testing:QWONUITests test
# ** TEST SUCCEEDED ** (2 tests)

xcodebuild -project app/ios/PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' \
  -only-testing:QWONUITests test
# ** TEST SUCCEEDED ** (2 tests)

git diff --check
```

**Artifacts:** UI-test screenshots exported locally from `.xcresult` bundles (`/tmp/qwon-ui1-se.xcresult`, `/tmp/qwon-ui1-16.xcresult`); **not committed** to git per artifact rules.

**Outcome:** Closes PR #80 residual risk — iPhone SE width layout sanity for UI-1 copy surfaces. See [UI-2 need assessment](#ui-2-need-assessment-2026-06-03) for follow-up gate.

---

## UI-2 need assessment (2026-06-03)

**Purpose:** Fix whether **PR UI-2** (small first-run / empty-state card or diagnostics explainer) is warranted after UI-1 copy polish. **Docs-only judgment memo** — **not** implementation approval.

**Base:** `origin/main` after [PR #80](https://github.com/studio-prospect/qwon-ai-ios/pull/80) (UI-1) and [PR #81](https://github.com/studio-prospect/qwon-ai-ios/pull/81) (post-merge verification).

### UI-1 completion state

| Field | Value |
| --- | --- |
| **Implementation** | [PR #80](https://github.com/studio-prospect/qwon-ai-ios/pull/80) merged — Chat / Settings / Runtime Diagnostics copy + UI-only onboarding hint |
| **Verification** | [PR #81](https://github.com/studio-prospect/qwon-ai-ios/pull/81) merged — iPhone SE (3rd gen, iOS 18.2) + iPhone 16 (iOS 18.4) simulator **pass** |
| **Runtime behavior** | **Unchanged** — system seed remains neutral; Wang/Matisse guidance is UI-only |
| **Build `4` / TestFlight** | **Not approved** — UI-1 did not authorize upload, tag, or version bump |

### When to open UI-2 (all must be true)

| # | Condition | Evidence required |
| --- | --- | --- |
| 1 | **Copy alone is insufficient** for first-use comprehension | Reproducible tester confusion **after** UI-1 — template-complete report, ops screenshot filename, or product observation; not speculation |
| 2 | **Diagnostics terms need structured explanation** beyond intro/empty/summary copy | Concrete gap: users cannot map `answered_by`, `primary_failure`, or `fallback_reason` with current text |
| 3 | **A small first-run or empty-state card** is needed **within existing QWON UI primitives** | Codex scoped note describing one card/explainer; no new design system, no persistence |

**Gate before any UI-2 implementation PR:** Product **and** Codex explicit approval after evidence above. UI-2 remains **not approved** until then.

### When **not** to open UI-2

| Condition | Rationale |
| --- | --- |
| **No new feedback** since UI-1 verification | Feedback intake **closed** — **QWON-FB-001**, **QWON-FB-002** pass only; no new **`QWON-FB-*`** rows |
| **UI-1 verification found no comprehension or layout blockers** | SE width + iPhone 16 simulator pass; copy readable on Chat / Settings / Diagnostics |
| **Opening UI-2 would imply build `4` or TestFlight upload** | UI polish does not create a release-engineering gate |
| **Need requires runtime, routing, backend, or model placement change** | Out of UI-2 scope — separate lane |
| **Need requires model download CTA or persistent onboarding state** | Forbidden in [PR UI-2 split](#pr-ui-2--optional-small-onboarding-structure) |

### Recommended judgment (2026-06-03)

| Field | Value |
| --- | --- |
| **UI-2 status** | **Defer / not opened** |
| **Rationale** | UI-1 copy + UI-only onboarding hint + Settings/Diagnostics helper text address the product goals in [Product Goal](#product-goal); post-merge verification found **no** SE-width regression and **no** comprehension gap requiring structural UI |
| **Next posture** | **Stay** on build **`3`** stable alpha until **product/design** records new evidence that copy alone is insufficient |
| **UI-3** | **Not opened** — no new UI screenshots or device QA artifacts since UI-1 verification |

### UI-2 forbidden (if ever opened)

| Do not do | Why |
| --- | --- |
| Change routing, fallback, model loading, or backend selection | UI structure only |
| Add **model download** CTA or in-app GGUF acquisition | Separate post-alpha lane |
| Add **persistent onboarding state** (UserDefaults, first-run flags, dismissal storage) | UI-2 scope is ephemeral display using existing components |
| Approve or imply **build `4`**, TestFlight upload, tag, or version bump | Release gate remains separate |
| Rewrite historical PREXUS docs or rename preserved PREXUS surfaces | Frozen baseline |

---

## Cursor Task Boundary

**PR UI-1:** **Complete** — do not reopen unless product identifies a copy regression on build **`3`**.

**PR UI-2:** **Not approved.** Cursor must **not** implement until Product **and** Codex approve after [UI-2 need assessment](#ui-2-need-assessment-2026-06-03) evidence.

**PR UI-3:** **Not opened** — docs/evidence only after any future UI change lands.

If UI-2 is ever approved:

1. Branch from latest `main`.
2. Keep changes limited to one small card/explainer using existing primitives (`QWONSurfaceCard`, `QWONScreenIntro`, etc.).
3. Do not change runtime logic, model files, backend selection, build number, or TestFlight state.
4. Regenerate the Xcode project if iOS source/test files change.
5. Include concrete simulator test results in the PR body.
6. Leave artifacts, screenshots, GGUF, logs, IPA, and DerivedData out of git.

**Default:** **Stay** — no UI-2 implementation PR.
