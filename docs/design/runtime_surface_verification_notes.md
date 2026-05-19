# PREXUS Runtime Surface Verification Notes

## Purpose

This note separates **UI verification evidence** and **environment-level capture limits** from the main polish plan.

Use this document when:

- confirming what has actually been checked on simulators
- tracking which surfaces have live screenshot evidence
- recording capture blockers that are tooling-related rather than product-related
- isolating known presentation issues that should not be mixed into normal UI polish work

Related notes:

- capture index: `docs/design/runtime_surface_capture_index.md`
- capture workflow: `docs/design/runtime_surface_capture_workflow.md`
- automation backlog: `docs/design/runtime_surface_automation_backlog.md`
- accessibility identifier plan: `docs/design/runtime_surface_accessibility_identifier_plan.md`
- simulator presentation issue: `docs/design/simulator_presentation_issue_note.md`

## Verified So Far

### iPhone 16 Simulator

Verified repeatedly during the polish pass:

- Chat surface builds and renders with the current PREXUS visual language
- Settings, Diagnostics, and Memory changes compile cleanly through the main regression loop
- test suite remains green after each visual refinement pass
- XCTest screenshot smoke now traverses Chat → Settings → Diagnostics → Memory automatically
- seeded XCTest screenshot smoke now captures non-empty Diagnostics and Memory states
- the capture-refresh wrapper now regenerates the committed iPhone 16 capture set end to end

Validation command:

- `xcodebuild -project app/ios/PREXUS.xcodeproj -scheme PREXUS -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' test`

### iPhone SE (3rd generation) Simulator

Verified on 2026-05-18 and expanded on 2026-05-19:

- PREXUS launched successfully on an SE-width simulator
- the Chat header fit within compact width
- the system bubble fit without clipping
- the composer card fit without layout breakage
- the sensitivity control, helper text, text field, and send button all remained usable at compact width
- XCTest screenshot smoke now traverses Chat → Settings → Diagnostics → Memory automatically on SE width
- seeded XCTest screenshot smoke now captures non-empty Diagnostics and Memory states on SE width

Validation command:

- `xcodebuild -project app/ios/PREXUS.xcodeproj -scheme PREXUS -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation),OS=18.2' -only-testing:PREXUSUITests test`

Evidence:

- live simulator launch completed
- screenshot capture succeeded first for the Chat surface
- full runtime-surface screenshot automation later succeeded for Chat / Settings / Diagnostics / Memory
- the capture-refresh wrapper now regenerates the committed SE-width capture set end to end
- compact-width support is therefore backed by both code fallbacks and automated simulator evidence

## Live Screenshot Coverage

Currently captured live:

- Chat on iPhone SE (3rd generation)
- Settings on iPhone SE (3rd generation)
- Diagnostics on iPhone SE (3rd generation)
- Memory on iPhone SE (3rd generation)
- Seeded Diagnostics on iPhone SE (3rd generation)
- Seeded Memory on iPhone SE (3rd generation)
- Seeded Chat on iPhone SE (3rd generation)
- Seeded Settings on iPhone SE (3rd generation)
- Chat on iPhone 16
- Settings on iPhone 16
- Diagnostics on iPhone 16
- Memory on iPhone 16
- Seeded Chat on iPhone 16
- Seeded Settings on iPhone 16
- Seeded Diagnostics on iPhone 16
- Seeded Memory on iPhone 16

Saved exports:

- `docs/design/runtime-surface-captures/iphone16/prexus-chat-iphone16.png`
- `docs/design/runtime-surface-captures/iphone16/prexus-chat-seeded-iphone16.png`
- `docs/design/runtime-surface-captures/iphone16/prexus-settings-seeded-iphone16.png`
- `docs/design/runtime-surface-captures/iphone16/prexus-settings-iphone16.png`
- `docs/design/runtime-surface-captures/iphone16/prexus-diagnostics-iphone16.png`
- `docs/design/runtime-surface-captures/iphone16/prexus-memory-iphone16.png`
- `docs/design/runtime-surface-captures/iphone16/prexus-diagnostics-seeded-iphone16.png`
- `docs/design/runtime-surface-captures/iphone16/prexus-memory-seeded-iphone16.png`
- `docs/design/runtime-surface-captures/iphonese3/prexus-chat-iphonese3.png`
- `docs/design/runtime-surface-captures/iphonese3/prexus-chat-seeded-iphonese3.png`
- `docs/design/runtime-surface-captures/iphonese3/prexus-settings-seeded-iphonese3.png`
- `docs/design/runtime-surface-captures/iphonese3/prexus-settings-iphonese3.png`
- `docs/design/runtime-surface-captures/iphonese3/prexus-diagnostics-iphonese3.png`
- `docs/design/runtime-surface-captures/iphonese3/prexus-memory-iphonese3.png`
- `docs/design/runtime-surface-captures/iphonese3/prexus-diagnostics-seeded-iphonese3.png`
- `docs/design/runtime-surface-captures/iphonese3/prexus-memory-seeded-iphonese3.png`

Remaining limitation:

- ad-hoc non-XCTest nested navigation is still awkward in the current session because `simctl` does not expose direct tap automation and `osascript` coordinate clicking remains accessibility-bound

This is now a **tooling convenience gap**, not evidence of missing runtime-surface coverage.

## Known Separate Issue

### Black bands around the rendered app surface

Observed on 2026-05-18 during iPhone SE screenshot capture:

- screenshots showed black bands above and below the rendered PREXUS surface

What was checked:

- a temporary full-height `ChatView` experiment was attempted
- that experiment did not change the black-band behavior
- the temporary change was reverted and not kept

Current interpretation:

- treat this as a simulator/runtime presentation issue until proven otherwise
- do not treat it as a blocker on the current UI polish pass
- do not fold it into ordinary surface-level polish tasks

## Recommended Follow-up

1. Extend the current UI smoke to additional device classes only when a new breakpoint or layout class needs explicit evidence beyond iPhone 16 and SE.
2. If black bands recur in future captures, open a separate issue or note focused on simulator presentation behavior.
3. Keep the main polish plan focused on design intent and implementation state; keep environment-level evidence and capture operations here.
