# PREXUS Runtime Surface Capture Workflow

## Purpose

This document explains how to collect **live simulator screenshots** for PREXUS runtime surfaces without confusing screenshot tooling limits with product UI issues.

Use this note when:

- updating visual docs
- collecting evidence for UI polish changes
- deciding whether a capture problem is a tooling problem or a layout problem
- refreshing the committed capture set after a runtime-surface UI change

Related note:

- automation backlog: `docs/design/runtime_surface_automation_backlog.md`
- accessibility identifier plan: `docs/design/runtime_surface_accessibility_identifier_plan.md`

## Current Reliable Capture Scope

As of 2026-05-19, the current environment can reliably do the following:

- boot an iOS simulator with `simctl`
- launch PREXUS in the simulator
- run test/build verification before capture
- take screenshots of the currently visible app surface
- run XCTest UI smoke for the supported device classes
- export screenshots from the UI smoke out of `.xcresult`

This is now enough to verify or refresh:

- compact-width runtime surfaces on iPhone SE (3rd generation)
- iPhone 16 runtime-surface captures for Chat / Settings / Diagnostics / Memory
- iPhone 16 seeded Diagnostics / Memory captures for non-empty docs refreshes
- iPhone SE (3rd generation) runtime-surface captures for Chat / Settings / Diagnostics / Memory
- iPhone SE (3rd generation) seeded Diagnostics / Memory captures for non-empty docs refreshes

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

### One-command refresh

When you want to refresh the committed captures for the supported device classes, use:

- `ruby tools/scripts/refresh_prexus_runtime_surface_captures.rb --all`

That wrapper:

- runs the PREXUS UI smoke for each supported device slug
- writes a dedicated `.xcresult` bundle in a temporary directory
- exports deterministic screenshots into `docs/design/runtime-surface-captures/<device-slug>/`
- refreshes the per-device `manifest.json` alongside the exported PNGs

Supported slugs today:

- `iphone16`
- `iphonese3`

### Manual / stepwise refresh

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

The same UI smoke now emits device-aware names, so SE-width runs will export:

- `prexus-chat-iphonese3.png`
- `prexus-settings-iphonese3.png`
- `prexus-diagnostics-iphonese3.png`
- `prexus-memory-iphonese3.png`

When the seeded UI smoke is present in the same SE-width `.xcresult`, it also exports:

- `prexus-diagnostics-seeded-iphonese3.png`
- `prexus-memory-seeded-iphonese3.png`

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
