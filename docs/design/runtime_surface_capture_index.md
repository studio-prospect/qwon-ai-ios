# PREXUS Runtime Surface Capture Index

## Purpose

This page is the human-readable entry point for the committed PREXUS runtime-surface screenshots.

Use it when you want to:

- quickly compare current PREXUS surfaces across supported device classes
- jump from design docs to the actual exported screenshots
- confirm which seeded and non-seeded states are already preserved in the repo

Related notes:

- capture workflow: `docs/design/runtime_surface_capture_workflow.md`
- verification notes: `docs/design/runtime_surface_verification_notes.md`
- XCTest screenshot spec: `docs/design/runtime_surface_xctest_screenshot_spec.md`

## Device Matrix

Supported exported device slugs:

- `iphone16`
- `iphonese3`

Capture directories:

- `docs/design/runtime-surface-captures/iphone16/`
- `docs/design/runtime-surface-captures/iphonese3/`

Each directory also contains a `manifest.json` that records the `.xcresult` export metadata for the latest committed refresh.

## Current Capture Set

### Standard runtime surfaces

| Surface | iPhone 16 | iPhone SE (3rd generation) |
| --- | --- | --- |
| Chat | `runtime-surface-captures/iphone16/prexus-chat-iphone16.png` | `runtime-surface-captures/iphonese3/prexus-chat-iphonese3.png` |
| Settings | `runtime-surface-captures/iphone16/prexus-settings-iphone16.png` | `runtime-surface-captures/iphonese3/prexus-settings-iphonese3.png` |
| Diagnostics | `runtime-surface-captures/iphone16/prexus-diagnostics-iphone16.png` | `runtime-surface-captures/iphonese3/prexus-diagnostics-iphonese3.png` |
| Memory | `runtime-surface-captures/iphone16/prexus-memory-iphone16.png` | `runtime-surface-captures/iphonese3/prexus-memory-iphonese3.png` |

### Seeded runtime surfaces

| Surface | iPhone 16 | iPhone SE (3rd generation) |
| --- | --- | --- |
| Chat | `runtime-surface-captures/iphone16/prexus-chat-seeded-iphone16.png` | `runtime-surface-captures/iphonese3/prexus-chat-seeded-iphonese3.png` |
| Settings | `runtime-surface-captures/iphone16/prexus-settings-seeded-iphone16.png` | `runtime-surface-captures/iphonese3/prexus-settings-seeded-iphonese3.png` |
| Diagnostics | `runtime-surface-captures/iphone16/prexus-diagnostics-seeded-iphone16.png` | `runtime-surface-captures/iphonese3/prexus-diagnostics-seeded-iphonese3.png` |
| Memory | `runtime-surface-captures/iphone16/prexus-memory-seeded-iphone16.png` | `runtime-surface-captures/iphonese3/prexus-memory-seeded-iphonese3.png` |

## How To Refresh

For the current supported device matrix, the canonical refresh path is:

- `ruby tools/scripts/refresh_prexus_runtime_surface_captures.rb --all`

That command:

- runs the PREXUS UI smoke
- regenerates exported screenshots for `iphone16` and `iphonese3`
- updates each directory’s `manifest.json`

Use the workflow note for stepwise refresh details:

- `docs/design/runtime_surface_capture_workflow.md`

## Current Interpretation

The committed capture set now preserves:

- full runtime-surface coverage for Chat / Settings / Diagnostics / Memory
- seeded runtime-surface coverage for Chat / Settings / Diagnostics / Memory
- wide and compact-width evidence for the supported device matrix

This page is intentionally an index, not the source of truth for tooling details or validation history.
