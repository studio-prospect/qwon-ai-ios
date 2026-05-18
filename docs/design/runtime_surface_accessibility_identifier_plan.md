# PREXUS Runtime Surface Accessibility Identifier Plan

## Purpose

This note defines the **minimum accessibility identifier surface** needed if PREXUS adopts XCTest-driven navigation for live screenshot automation.

Use this document when:

- preparing UI automation for Settings, Diagnostics, or Memory
- adding accessibility identifiers to runtime surfaces
- deciding which elements must be stable across visual polish work

## Current State

As of 2026-05-18:

- PREXUS already has stable visual runtime surfaces for Chat, Settings, Diagnostics, and Memory
- the current code uses very few explicit automation-oriented identifiers
- the main blocker for secondary-surface live capture is not layout correctness, but reliable in-app navigation

That means the next useful step is not broad UI rewrites. It is a small, explicit identifier contract.

## Design Principles

Identifiers for automation should be:

- stable across routine copy tweaks
- scoped to navigation-critical controls first
- independent from visible user-facing strings when possible
- limited to elements that materially help XCTest navigation or screenshot capture

Do **not** add identifiers to every decorative surface.

## Priority 1 — Navigation Entry Points

These elements should get identifiers first because they unlock screen-to-screen traversal.

### Chat

- settings button
  - suggested identifier: `chat.open-settings`

### Settings

- done button
  - suggested identifier: `settings.done`
- diagnostics navigation row
  - suggested identifier: `settings.open-diagnostics`
- memory navigation row
  - suggested identifier: `settings.open-memory`

### Diagnostics

- clear button
  - suggested identifier: `diagnostics.clear`

### Memory

- clear all button
  - suggested identifier: `memory.clear-all`

## Priority 2 — Screenshot Anchor Surfaces

These identifiers help XCTest confirm it has reached the correct screen before capture.

### Chat

- root screen container
  - `chat.screen`
- route preview card
  - `chat.route-preview`
- composer card
  - `chat.composer`

### Settings

- root screen container
  - `settings.screen`
- summary surface
  - `settings.summary-surface`

### Diagnostics

- root screen container
  - `diagnostics.screen`
- summary card
  - `diagnostics.summary`
- empty state
  - `diagnostics.empty`

### Memory

- root screen container
  - `memory.screen`
- summary card
  - `memory.summary`
- empty state
  - `memory.empty`

## Priority 3 — Interaction Controls Inside Surfaces

Only add these if screenshot automation expands into behavioral UI tests.

### Chat

- sensitivity picker
  - `chat.sensitivity-picker`
- draft text field
  - `chat.draft-input`
- send button
  - `chat.send`

### Settings

- cloud escalation toggle
  - `settings.allow-cloud-escalation`
- local backend picker
  - `settings.local-backend`
- provider-restricted toggles
  - `settings.provider-restricted.openai`
  - `settings.provider-restricted.anthropic`
  - `settings.provider-restricted.gemini`
- API key fields
  - `settings.api-key.openai`
  - `settings.api-key.anthropic`
  - `settings.api-key.gemini`

## Recommended XCTest Navigation Shape

If XCTest automation is adopted, the minimal screenshot flow should be:

1. wait for `chat.screen`
2. tap `chat.open-settings`
3. wait for `settings.screen`
4. capture Settings
5. tap `settings.open-diagnostics`
6. wait for `diagnostics.screen`
7. capture Diagnostics
8. navigate back to Settings
9. tap `settings.open-memory`
10. wait for `memory.screen`
11. capture Memory
12. return or end

This path avoids depending on ambiguous visible strings when a stable identifier can do the job.

## Implementation Guidance

When these identifiers are added:

- keep names lowercase and dot-scoped
- prefer screen-first naming
- avoid embedding visual copy that is likely to change
- do not rename identifiers during ordinary design polish unless the navigation contract truly changes

## Non-Goals

This note does **not** require:

- immediate XCTest implementation
- app-wide identifier coverage
- changes to routing or runtime behavior
- replacing existing accessibility labels intended for VoiceOver

## Related Notes

- `docs/design/runtime_surface_automation_backlog.md`
- `docs/design/runtime_surface_xctest_screenshot_spec.md`
- `docs/design/runtime_surface_capture_workflow.md`
- `docs/design/runtime_surface_verification_notes.md`
