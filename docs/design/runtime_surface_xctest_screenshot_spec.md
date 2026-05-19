# PREXUS Runtime Surface XCTest Screenshot Spec

## Purpose

This note defines the **minimum XCTest-driven screenshot flow** for PREXUS runtime surfaces.

Use this document when:

- starting a UI test target or screenshot-oriented UI test flow
- converting the current automation backlog into executable XCTest work
- deciding which screens and assertions are required for the first stable capture pass

## Current Status

The first screenshot smoke is now implemented in:

- `app/ios/PREXUSUITests/PREXUSUITests.swift`

Current first-pass behavior:

- launches PREXUS
- captures Chat, Settings, Diagnostics, and Memory in order
- uses stable screen identifiers where exposed
- uses visible-label row matching for the nested Settings navigation rows
- can now be exported from `.xcresult` through `tools/scripts/export_prexus_xcuitest_screenshots.rb`
- includes a seeded variant for a route-aware Chat state plus non-empty Diagnostics and Memory captures

This keeps the initial automation path small and navigation-focused while the broader screenshot/export workflow remains a follow-on task.

## Scope

The first XCTest screenshot flow should cover:

- Chat
- Settings
- Diagnostics
- Memory

It should focus on **navigation and capture**, not broad behavioral validation.

## Preconditions

Before implementing this flow:

- the current runtime surfaces should already compile and pass the main regression suite
- navigation-critical accessibility identifiers should exist
- screenshot naming and output handling should be agreed in the test target

Current identifier source of truth:

- `docs/design/runtime_surface_accessibility_identifier_plan.md`

## Required Identifiers

The first XCTest flow depends on these identifiers:

- `chat.screen`
- `chat.open-settings`
- `settings.screen`
- `settings.done`
- `settings.open-diagnostics`
- `settings.open-memory`
- `diagnostics.screen`
- `memory.screen`

Helpful anchor identifiers:

- `chat.route-preview`
- `chat.composer`
- `settings.summary-surface`
- `diagnostics.summary`
- `diagnostics.empty`
- `memory.summary`
- `memory.empty`

## Minimum Navigation Flow

The first stable screenshot scenario should run in this order:

1. launch PREXUS
2. wait for `chat.screen`
3. capture Chat
4. tap `chat.open-settings`
5. wait for `settings.screen`
6. capture Settings
7. tap `settings.open-diagnostics`
8. wait for `diagnostics.screen`
9. capture Diagnostics
10. navigate back to Settings
11. tap `settings.open-memory`
12. wait for `memory.screen`
13. capture Memory
14. optionally dismiss Settings with `settings.done`

## Suggested Screenshot Names

Keep naming deterministic and device-aware.

Suggested pattern:

- `prexus-chat-<device>.png`
- `prexus-settings-<device>.png`
- `prexus-diagnostics-<device>.png`
- `prexus-memory-<device>.png`

Current normalized slugs:

- `iphone16`
- `iphonese3`

If date stamping is needed, append it outside the logical screen name:

- `prexus-chat-iphone16-2026-05-18.png`

## Suggested XCTest Assertions

Keep the first pass light.

Recommended assertions:

- `chat.screen` exists
- `chat.open-settings` is hittable
- `settings.screen` exists
- `settings.open-diagnostics` exists
- `settings.open-memory` exists
- `diagnostics.screen` exists
- `memory.screen` exists

Optional second-pass assertions:

- `settings.summary-surface` exists
- one of `diagnostics.summary` or `diagnostics.empty` exists
- one of `memory.summary` or `memory.empty` exists

## Data State Guidance

The screenshot flow should tolerate either:

- empty Diagnostics / Memory
- populated Diagnostics / Memory

That is why both summary and empty-state anchors are useful.

Current seeded add-on captures:

- a Chat surface with seeded route-aware state
- a Settings surface with seeded runtime policy context
- non-empty Diagnostics
- non-empty Memory

Do **not** require seeding more complex runtime data unless the docs explicitly need a richer visual state than the current seeded Chat + populated secondary-surface set.

## First Implementation Goal

The first XCTest automation task is successful when it can:

- launch the app
- traverse the 4 surfaces reliably
- capture one screenshot per surface
- finish without manual tapping

This should come before:

- visual diffing
- multiple seeded states
- device matrix expansion
- behavioral form interaction coverage

Status:

- achieved for the current iPhone 16 smoke path on 2026-05-18
- expanded to device-aware screenshot naming on 2026-05-19 so the same flow can run on iPhone SE width

## Non-Goals

The first screenshot spec should **not** try to:

- validate routing semantics
- edit settings values
- verify provider readiness states
- cover every modal or edge case
- replace the existing unit/regression test suite

## Follow-on Expansions

After the first stable flow works, later additions may include:

- SE-width screenshot variants
- screenshot artifact export into `docs/design/`
- visual regression comparison if needed

Current follow-on priority:

- keep seeded coverage centered on route-aware Chat state plus populated Diagnostics / Memory unless another runtime surface needs explicit visual evidence

## Related Notes

- `docs/design/runtime_surface_automation_backlog.md`
- `docs/design/runtime_surface_accessibility_identifier_plan.md`
- `docs/design/runtime_surface_capture_workflow.md`
- `docs/design/runtime_surface_verification_notes.md`
