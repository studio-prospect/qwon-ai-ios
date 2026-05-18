# PREXUS Runtime Surface Capture Workflow

## Purpose

This document explains how to collect **live simulator screenshots** for PREXUS runtime surfaces without confusing screenshot tooling limits with product UI issues.

Use this note when:

- updating visual docs
- collecting evidence for UI polish changes
- deciding whether a capture problem is a tooling problem or a layout problem

Related note:

- automation backlog: `docs/design/runtime_surface_automation_backlog.md`
- accessibility identifier plan: `docs/design/runtime_surface_accessibility_identifier_plan.md`

## Current Reliable Capture Scope

As of 2026-05-18, the current environment can reliably do the following:

- boot an iOS simulator with `simctl`
- launch PREXUS in the simulator
- run test/build verification before capture
- take screenshots of the currently visible app surface
- export screenshots from the first XCTest smoke out of `.xcresult`

This is now enough to verify or refresh:

- compact-width Chat on iPhone SE (3rd generation)
- iPhone 16 runtime-surface captures for Chat / Settings / Diagnostics / Memory
- iPhone 16 seeded Diagnostics / Memory captures for non-empty docs refreshes

## Current Unreliable / Blocked Scope

The current environment does **not** yet provide a reliable way to:

- use coordinate-based GUI automation consistently from the current session
- cover additional devices beyond the first iPhone 16 smoke without extra automation work
- broaden seeded screenshots beyond the current first-pass Diagnostics / Memory examples

Known constraints:

- `simctl` still does not expose a direct tap API for ad-hoc workflow driving outside XCTest
- `osascript` coordinate clicks are blocked by accessibility limitations in the current environment
- broader multi-state capture remains a tooling problem, not a confirmed product problem

## Recommended Capture Sequence

When you need new live screenshots:

1. Run the first UI smoke:
   - `xcodebuild -project app/ios/PREXUS.xcodeproj -scheme PREXUS -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' -only-testing:PREXUSUITests test`
2. Export the attachments into a deterministic directory:
   - `ruby tools/scripts/export_prexus_xcuitest_screenshots.rb --xcresult '<xcresult-path>' --output-dir docs/design/runtime-surface-captures/iphone16`
3. Record:
   - device class
   - date
   - which `.xcresult` the images came from
   - whether the captures reflect empty or populated runtime state

The export script normalizes the attachment names to:

- `prexus-chat-iphone16.png`
- `prexus-settings-iphone16.png`
- `prexus-diagnostics-iphone16.png`
- `prexus-memory-iphone16.png`

When the seeded UI smoke is present in the same `.xcresult`, it also exports:

- `prexus-diagnostics-seeded-iphone16.png`
- `prexus-memory-seeded-iphone16.png`

## When To Open a Separate Tooling Task

Create a separate tooling / automation task if you need:

- repeatable Settings screenshots
- repeatable Diagnostics screenshots
- repeatable Memory screenshots
- multi-screen visual documentation updates in one pass
- seeded non-empty screenshot variants
- deterministic export for additional device classes

That task should focus on:

- accessibility permissions
- simulator interaction automation
- reliable nested navigation control

It should **not** be mixed into ordinary UI polish implementation unless the actual product UI is broken.

Use `docs/design/runtime_surface_automation_backlog.md` as the starting scope for that separate task.
