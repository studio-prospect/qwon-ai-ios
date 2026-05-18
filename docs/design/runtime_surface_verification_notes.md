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
- simulator presentation issue: `docs/design/simulator_presentation_issue_note.md`

## Verified So Far

### iPhone 16 Simulator

Verified repeatedly during the polish pass:

- Chat surface builds and renders with the current PREXUS visual language
- Settings, Diagnostics, and Memory changes compile cleanly through the main regression loop
- test suite remains green after each visual refinement pass

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

Not yet captured live:

- Settings
- Diagnostics
- Memory

Reason:

- the current environment can boot devices, launch apps, and take screenshots with `simctl`
- however, it does not currently provide a reliable in-app interaction path for nested navigation inside PREXUS
- `simctl` does not expose direct tap automation for this workflow
- coordinate-based `osascript` clicking is blocked by accessibility limitations in the current session

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
