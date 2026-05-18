# PREXUS Runtime Surface Capture Workflow

## Purpose

This document explains how to collect **live simulator screenshots** for PREXUS runtime surfaces without confusing screenshot tooling limits with product UI issues.

Use this note when:

- updating visual docs
- collecting evidence for UI polish changes
- deciding whether a capture problem is a tooling problem or a layout problem

## Current Reliable Capture Scope

As of 2026-05-18, the current environment can reliably do the following:

- boot an iOS simulator with `simctl`
- launch PREXUS in the simulator
- run test/build verification before capture
- take screenshots of the currently visible app surface

This was enough to verify:

- compact-width Chat on iPhone SE (3rd generation)

## Current Unreliable / Blocked Scope

The current environment does **not** yet provide a reliable way to:

- tap through nested in-app navigation for screenshot capture
- drive Settings -> Diagnostics -> Memory interactions automatically
- use coordinate-based GUI automation consistently from the current session

Known constraints:

- `simctl` does not expose a direct tap API for this workflow
- `osascript` coordinate clicks are blocked by accessibility limitations in the current environment
- because of that, secondary-surface screenshots are currently a tooling problem, not a confirmed product problem

## Recommended Capture Sequence

When you need new live screenshots:

1. Run the standard iPhone 16 regression command first:
   - `xcodebuild -project app/ios/PREXUS.xcodeproj -scheme PREXUS -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' test`
2. Boot the target simulator device with `simctl`
3. Launch PREXUS
4. Capture the currently visible surface
5. Record:
   - device class
   - date
   - what was actually visible
   - whether navigation was possible or blocked

## When To Open a Separate Tooling Task

Create a separate tooling / automation task if you need:

- repeatable Settings screenshots
- repeatable Diagnostics screenshots
- repeatable Memory screenshots
- multi-screen visual documentation updates in one pass

That task should focus on:

- accessibility permissions
- simulator interaction automation
- reliable nested navigation control

It should **not** be mixed into ordinary UI polish implementation unless the actual product UI is broken.
