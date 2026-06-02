# PREXUS Device Install and Screenshot Workflow

## Purpose

This document is the **entry point** for installing PREXUS on a physical iPhone and collecting screenshots for Chat / runtime-surface QA.

It complements the simulator-only automation in:

- `docs/design/runtime_surface_capture_workflow.md` — committed XCTest simulator captures
- `docs/design/runtime_surface_capture_index.md` — index of committed simulator PNGs

Use this note when:

- validating Liquid Glass, keyboard behavior, or safe-area layout on a real device
- installing a local debug build without opening Xcode every time
- attaching device QA evidence to a PR

## Choose the Right Path

| Goal | Path | Output location |
| --- | --- | --- |
| Refresh committed design captures (simulator) | `ruby tools/scripts/refresh_prexus_runtime_surface_captures.rb --all` | `docs/design/runtime-surface-captures/<slug>/` |
| Ad-hoc simulator Chat capture | XCTest UI smoke or manual Simulator screenshot | `docs/design/screenshots/` (optional, see README there) |
| Physical device install + manual QA | `./tools/scripts/install_on_device.sh` | On-device verification; screenshots optional |
| Physical device screenshots for a PR | Manual capture (Side button + Volume up) | `docs/design/screenshots/device-qa/` |

**Rule of thumb:** simulator automation owns the committed runtime-surface matrix; physical device work owns glass, keyboard, and safe-area behavior that XCTest does not model reliably.

---

## Prerequisites

### Mac

- Xcode with iOS platform support
- PREXUS project generated:

```bash
ruby tools/scripts/generate_xcodeproj.rb
```

- Apple Development signing for bundle id `jp.studio-prospect.qwon.ios` on your team ([QWON bundle memo](../product/qwon_bundle_id_decision_memo.md); historical PREXUS alpha used `jp.studio-prospect.prexus.ios`)

### iPhone

1. Connect by USB, unlock, tap **Trust This Computer**
2. **Settings → Privacy & Security → Developer Mode → ON** (reboot if prompted)
3. Keep the device awake during install

### Team ID

The install script defaults to `DEVELOPMENT_TEAM=BWSS94LH28`. Override when needed:

```bash
DEVELOPMENT_TEAM=YOUR_TEAM_ID ./tools/scripts/install_on_device.sh
```

---

## Physical Device Install

### One-command install and launch

From the repository root:

```bash
./tools/scripts/install_on_device.sh
```

Filter by device name substring when multiple phones are connected:

```bash
./tools/scripts/install_on_device.sh "Wang"
```

The script:

1. Builds `Debug-iphoneos` with `xcodebuild`
2. Resolves the device **UUID** via `devicectl --json-output` (not truncated name parsing)
3. Prefers a tunnel-connected device when multiple names match
4. Installs with `devicectl device install app`
5. Launches `jp.studio-prospect.qwon.ios`

### Xcode alternative

```bash
open app/ios/PREXUS.xcodeproj
```

Select the physical device and press **⌘R**.

### Troubleshooting

| Symptom | Fix |
| --- | --- |
| `No iPhone detected` | USB, unlock, Trust, Developer Mode |
| `Developer Mode is disabled` | Enable Developer Mode; reboot; re-run script |
| `No device matched filter` | Run `xcrun devicectl list devices`; pass a unique substring |
| Black bars top/bottom on new iPhones | Ensure `UILaunchScreen` is present in `Info.plist` (see PR #6); delete app and reinstall if cached |
| Build/signing errors | Set team in Xcode Signing & Capabilities; pass `DEVELOPMENT_TEAM` |

### Post-install Chat checklist (device QA)

After install, verify on device:

- [ ] Full-screen layout (no compatibility letterboxing)
- [ ] Header / settings button / composer use control-surface glass
- [ ] Message bubbles stay **opaque** (no glass)
- [ ] Typing shows **Planned Route** above composer
- [ ] Send shows **Executing Route** briefly, then **Executed Route** persists
- [ ] Latest messages auto-scroll above composer / route banner
- [ ] Keyboard dismiss: tap message area, downward swipe, scroll dismiss
- [ ] **Settings → Accessibility → Reduce Transparency** shows opaque fallbacks
- [ ] Home screen icon: full-bleed routing-first icon (no inner rounded frame)

Record results in the PR test plan when device QA is required.

---

## Unit Tests Before Device or PR Work

`xcodebuild test` can hang when UI tests build in the same invocation. For a fast, reliable unit pass:

```bash
cd app/ios

xcodebuild -project PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' \
  -derivedDataPath ../../.derivedData \
  -only-testing:QWONTests build-for-testing

xcodebuild -project PREXUS.xcodeproj -scheme QWON \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' \
  -derivedDataPath ../../.derivedData \
  test-without-building \
  -only-testing:QWONTests \
  -skip-testing:QWONUITests \
  -parallel-testing-enabled NO
```

Expect **66** `QWONTests` on success.

---

## Physical Device Screenshots

### When to capture

- Chat UI polish (Liquid Glass, keyboard, route banner, scroll behavior)
- Before/after PR evidence on iPhone 17 class hardware vs older devices
- Issues that do not reproduce in simulator Material fallbacks

### How to capture

On iPhone: **Side button + Volume up** (screenshot saves to Photos).

AirDrop or sync to Mac, then copy into the repo if the capture should support a PR or design review.

### Where to store ad-hoc device captures

```
docs/design/screenshots/device-qa/
```

Use descriptive filenames:

```
<surface>-<device-slug>-<optional-owner>-<date>-<state>.png
```

Examples:

- `chat-iphone17-planned-route-2026-05-20.png`
- `chat-iphone17-executed-route-2026-05-20.png`
- `chat-iphone-xsmax-keyboard-2026-05-20.png`

Add a one-line note in the PR test plan linking the file path. **Do not** mix device QA PNGs into `docs/design/runtime-surface-captures/` — that directory is reserved for deterministic simulator exports.

### Optional commit policy

- **Commit** when refreshing intentional design evidence or a milestone capture set
- **Leave untracked** for personal iteration; keep large binary churn out of ordinary fix PRs unless reviewers need pixels

See `docs/design/screenshots/README.md` for how this folder relates to simulator exports.

---

## Simulator Screenshots (Committed Set)

For the supported simulator matrix (`iphone16`, `iphonese3`):

```bash
ruby tools/scripts/refresh_prexus_runtime_surface_captures.rb --all
```

This runs `QWONUITests`, exports attachments, and updates `manifest.json` per device slug.

Details:

- Workflow: `docs/design/runtime_surface_capture_workflow.md`
- Index: `docs/design/runtime_surface_capture_index.md`
- XCTest spec: `docs/design/runtime_surface_xctest_screenshot_spec.md`

Seeded Chat / Diagnostics / Memory states use launch argument `PREXUS_UI_TEST_SEEDED_SURFACES` (see `AppEnvironment.seededRuntimeSurfacesArgument`).

---

## Suggested PR Test Plan Wording

When a change touches Chat layout on device:

```markdown
- [x] QWONTests (66, 0 failures) — command in device_install_and_screenshot_workflow.md
- [x] Physical iPhone — `./tools/scripts/install_on_device.sh "<name>"` — Chat checklist passed
- [x] Screenshots — `docs/design/screenshots/device-qa/<file>.png` (if UI-visible)
```

---

## Related Docs

| Document | Role |
| --- | --- |
| `tools/scripts/install_on_device.sh` | Device build / install / launch script |
| `docs/design/screenshots/README.md` | Ad-hoc screenshot folder layout |
| `docs/design/runtime_surface_capture_workflow.md` | Simulator capture automation |
| `docs/design/runtime_surface_capture_index.md` | Committed simulator PNG index |
| `docs/design/liquid_glass_adoption_strategy.md` | Glass scope (control surfaces only) |
| `docs/product/agent_collaboration_workflow.md` | Codex review / merge workflow |
