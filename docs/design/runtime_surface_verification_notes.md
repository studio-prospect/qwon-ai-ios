# PREXUS Runtime Surface Verification Notes

## Purpose

This note separates **UI verification evidence** and **environment-level capture limits** from the main polish plan.

Use this document when:

- confirming what has actually been checked on simulators
- tracking which surfaces have live screenshot evidence
- recording capture blockers that are tooling-related rather than product-related
- isolating known presentation issues that should not be mixed into normal UI polish work

Related notes:

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

Validation command:

- `xcodebuild -project app/ios/PREXUS.xcodeproj -scheme PREXUS -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' test`

### iPhone SE (3rd generation) Simulator

Verified on 2026-05-18:

- PREXUS launched successfully on an SE-width simulator
- the Chat header fit within compact width
- the system bubble fit without clipping
- the composer card fit without layout breakage
- the sensitivity control, helper text, text field, and send button all remained usable at compact width

Evidence:

- live simulator launch completed
- screenshot capture succeeded for the Chat surface
- compact-width support is therefore backed by both code fallbacks and live simulator evidence

## Live Screenshot Coverage

Currently captured live:

- Chat on iPhone SE (3rd generation)
- Chat on iPhone 16
- Settings on iPhone 16
- Diagnostics on iPhone 16
- Memory on iPhone 16
- Seeded Diagnostics on iPhone 16
- Seeded Memory on iPhone 16

Saved exports:

- `docs/design/runtime-surface-captures/iphone16/prexus-chat-iphone16.png`
- `docs/design/runtime-surface-captures/iphone16/prexus-settings-iphone16.png`
- `docs/design/runtime-surface-captures/iphone16/prexus-diagnostics-iphone16.png`
- `docs/design/runtime-surface-captures/iphone16/prexus-memory-iphone16.png`
- `docs/design/runtime-surface-captures/iphone16/prexus-diagnostics-seeded-iphone16.png`
- `docs/design/runtime-surface-captures/iphone16/prexus-memory-seeded-iphone16.png`

Not yet captured live:

- Settings on iPhone SE-width
- Diagnostics on iPhone SE-width
- Memory on iPhone SE-width
- Seeded variants on iPhone SE-width

Reason:

- the current environment can boot devices, launch apps, and take screenshots with `simctl`
- iPhone 16 nested navigation is now covered by XCTest UI automation
- `simctl` still does not expose direct tap automation for ad-hoc non-XCTest workflows
- coordinate-based `osascript` clicking remains blocked by accessibility limitations in the current session

This is a **tooling / automation gap**, not evidence of a UI regression.

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

1. If visual documentation becomes important, add a dedicated automation task for secondary-surface screenshot capture.
2. If black bands recur in future captures, open a separate issue or note focused on simulator presentation behavior.
3. Keep the main polish plan focused on design intent and implementation state; keep environment-level evidence and blockers here.
