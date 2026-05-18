# PREXUS Runtime Surface Automation Backlog

## Purpose

This note defines the **separate tooling task** for collecting repeatable live screenshots of PREXUS secondary runtime surfaces.

Use this document when:

- live screenshots for Settings, Diagnostics, or Memory become important
- design docs need repeatable multi-screen visual evidence
- simulator interaction automation needs to be scoped without mixing it into normal UI polish work

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

The missing part is reliable navigation through:

- Settings
- Diagnostics
- Memory

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

Potential focus:

- route and settings accessibility identifiers
- stable screenshot naming
- separation between regression UI tests and design-capture flows

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

## Non-Goals

This task should **not** be used to:

- redesign PREXUS surfaces
- change routing behavior
- reopen already-completed Chat polish work
- treat simulator tooling limits as evidence of layout regressions

## Inputs From Existing Notes

Related documents:

- `docs/design/prexus_chat_ui_polish_plan.md`
- `docs/design/runtime_surface_accessibility_identifier_plan.md`
- `docs/design/runtime_surface_xctest_screenshot_spec.md`
- `docs/design/runtime_surface_verification_notes.md`
- `docs/design/runtime_surface_capture_workflow.md`
- `docs/design/simulator_presentation_issue_note.md`
