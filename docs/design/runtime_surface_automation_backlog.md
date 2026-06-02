# PREXUS Runtime Surface Automation Backlog

## Purpose

This note defines the **separate tooling task** for collecting repeatable live screenshots of PREXUS secondary runtime surfaces.

Use this document when:

- live screenshots for Settings, Diagnostics, or Memory become important
- design docs need repeatable multi-screen visual evidence
- simulator interaction automation needs to be scoped without mixing it into normal UI polish work
- you need to understand which committed captures the automation flow is expected to refresh

## Why This Is Separate

The current PREXUS UI polish pass already established that:

- the current surfaces compile and test cleanly
- Chat has live compact-width evidence on iPhone SE
- the remaining screenshot gap is mainly about **nested simulator interaction**

That means the unfinished part is not ordinary product layout work. It is a tooling problem.

## Current Gap

The current environment can already:

- boot simulators
- launch PREXUS
- run the standard iPhone 16 regression loop
- capture the currently visible surface
- run a first XCTest smoke that traverses Chat → Settings → Diagnostics → Memory

The remaining gap is no longer the first capture loop itself. That path now has:

- exported screenshot files outside `.xcresult`
- optional seeded states for non-empty Diagnostics / Memory captures
- iPhone 16 and iPhone SE (3rd generation) coverage
- a wrapper command that refreshes the committed capture set
- a capture index that documents the expected exported evidence set

The remaining work is about broadening and hardening that workflow further.

## Candidate Automation Paths

### Option 1 — Accessibility-enabled GUI automation

Use a host-side automation path that can:

- target Simulator reliably
- click or tap UI affordances predictably
- navigate through PREXUS sheets and nested screens

Potential focus:

- accessibility permission setup
- deterministic coordinate mapping
- repeatable window placement before capture

### Option 2 — XCTest UI automation

Add a dedicated UI automation target or screenshot-oriented UI tests that can:

- launch PREXUS
- navigate to each secondary surface
- capture screenshots in a deterministic order

Current state:

- **implemented as the preferred first pass**
- the initial smoke lives in `app/ios/QWONUITests/QWONUITests.swift`
- it is intentionally navigation-only and light on assertions
- `tools/scripts/refresh_prexus_runtime_surface_captures.rb` now wraps the current smoke + export flow for the supported device slugs

Potential focus:

- route and settings accessibility identifiers
- stable screenshot naming
- separation between regression UI tests and design-capture flows
- extending the device matrix beyond `iphone16` and `iphonese3`

### Option 3 — Temporary debug navigation hooks

Add temporary or gated app-side navigation shortcuts only if:

- screenshot automation becomes urgent
- host automation remains unreliable

This is the least preferred option because it risks mixing capture scaffolding into product code.

## Recommended Order

1. Try a non-invasive automation route first
   - host-side interaction automation
   - or XCTest UI navigation if that fits the repo better
2. Add accessibility identifiers where they improve both testing and automation clarity
3. Only consider temporary debug hooks if the first two paths are insufficient

## Success Criteria

This tooling task is successful when it can reliably produce:

- Settings screenshot
- Diagnostics screenshot
- Memory screenshot

with:

- named output files
- device class recorded
- date recorded
- minimal manual intervention

The first XCTest smoke and refresh wrapper now satisfy the current design-doc refresh loop for iPhone 16 and iPhone SE (3rd generation). The backlog remains open only for broader device coverage, richer seeded states, or stricter visual assertions.

## Non-Goals

This task should **not** be used to:

- redesign PREXUS surfaces
- change routing behavior
- reopen already-completed Chat polish work
- treat simulator tooling limits as evidence of layout regressions

## Inputs From Existing Notes

Related documents:

- `docs/design/prexus_chat_ui_polish_plan.md`
- `docs/design/runtime_surface_capture_index.md`
- `docs/design/runtime_surface_accessibility_identifier_plan.md`
- `docs/design/runtime_surface_xctest_screenshot_spec.md`
- `docs/design/runtime_surface_verification_notes.md`
- `docs/design/runtime_surface_capture_workflow.md`
- `docs/design/simulator_presentation_issue_note.md`
