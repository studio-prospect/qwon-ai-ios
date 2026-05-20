# PREXUS Ad-hoc Screenshots

This directory holds **informal and device QA** screenshots. It is separate from the committed simulator export set under `docs/design/runtime-surface-captures/`.

## Layout

| Path | Purpose |
| --- | --- |
| `device-qa/` | Physical iPhone captures for PR / polish evidence |
| `*.png` (root) | Legacy or one-off simulator exports (e.g. `chat-iphone16-seeded.png`) |
| `se-run/` | Exported XCTest attachment dumps with UUID filenames |
| `manifest.json` | Export metadata when screenshots came from a specific `.xcresult` |

## Device QA (recommended for real hardware)

1. Capture on device (Side button + Volume up)
2. Copy to `device-qa/` with a descriptive name (see `docs/design/device_install_and_screenshot_workflow.md`)
3. Reference the path in the PR test plan

## Simulator (committed design set)

Do **not** hand-place simulator runtime-surface PNGs here for long-term docs. Use:

```bash
ruby tools/scripts/refresh_prexus_runtime_surface_captures.rb --all
```

Output: `docs/design/runtime-surface-captures/<device-slug>/`

Index: `docs/design/runtime_surface_capture_index.md`

## Commit guidance

- Prefer committing `runtime-surface-captures/` refreshes when surfaces change materially
- Treat `device-qa/` and root ad-hoc files as optional unless reviewers need pixel evidence
- Avoid committing Xcode `.xcresult` bundles or test log files from the repo root
