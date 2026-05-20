#!/usr/bin/env bash
# Build PREXUS for a physical iPhone and install/launch via devicectl.
#
# Prerequisites:
#   - iPhone connected by USB, unlocked, "Trust This Computer" accepted
#   - Developer Mode enabled (Settings > Privacy & Security > Developer Mode)
#   - Apple Development signing for com.prexus.ios on your team
#
# Usage:
#   DEVELOPMENT_TEAM=YOUR_TEAM_ID ./tools/scripts/install_on_device.sh
#   ./tools/scripts/install_on_device.sh "My iPhone"   # optional device name filter

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
IOS="$ROOT/app/ios"
DERIVED="$ROOT/.derivedData"
TEAM="${DEVELOPMENT_TEAM:-BWSS94LH28}"
BUNDLE_ID="com.prexus.ios"
APP="$DERIVED/Build/Products/Debug-iphoneos/PREXUS.app"
DEVICE_FILTER="${1:-}"

echo "==> Building for device (DEVELOPMENT_TEAM=$TEAM)"
cd "$IOS"
xcodebuild \
  -project PREXUS.xcodeproj \
  -scheme PREXUS \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "$DERIVED" \
  DEVELOPMENT_TEAM="$TEAM" \
  -allowProvisioningUpdates \
  build

if [[ ! -d "$APP" ]]; then
  echo "error: expected app at $APP" >&2
  exit 1
fi

echo "==> Looking for connected iOS devices"
if ! xcrun devicectl list devices 2>&1 | tee /tmp/prexus-devices.txt | grep -q "devices found"; then
  if grep -qi "no devices found" /tmp/prexus-devices.txt 2>/dev/null; then
    echo ""
    echo "No iPhone detected. Please:"
    echo "  1. Connect iPhone via USB and unlock it"
    echo "  2. Tap Trust on the device"
    echo "  3. Enable Developer Mode on the iPhone"
    echo "  4. Re-run: ./tools/scripts/install_on_device.sh"
    echo ""
    echo "Or open Xcode and Run (⌘R) on your device:"
    echo "  open $IOS/PREXUS.xcodeproj"
    exit 1
  fi
fi

# devicectl prints a table; pick first hardware iPhone row (skip header/separators).
DEVICE_ID=""
while IFS= read -r line; do
  [[ "$line" =~ ^[[:space:]]*$ ]] && continue
  [[ "$line" =~ ^- ]] && continue
  [[ "$line" =~ Name ]] && continue
  if [[ -n "$DEVICE_FILTER" ]] && [[ "$line" != *"$DEVICE_FILTER"* ]]; then
    continue
  fi
  # First column is typically the device name; devicectl also accepts name.
  DEVICE_ID="$(echo "$line" | awk '{print $1}')"
  break
done < <(xcrun devicectl list devices 2>/dev/null | tail -n +2 || true)

if [[ -z "$DEVICE_ID" ]]; then
  echo "error: could not resolve a device id. Raw listing:" >&2
  xcrun devicectl list devices 2>&1 || true
  echo ""
  echo "Pass a device name substring: ./tools/scripts/install_on_device.sh \"iPhone\""
  exit 1
fi

echo "==> Installing to device: $DEVICE_ID"
INSTALL_LOG="$(mktemp)"
if ! xcrun devicectl device install app --device "$DEVICE_ID" "$APP" >"$INSTALL_LOG" 2>&1; then
  cat "$INSTALL_LOG" >&2
  echo "" >&2
  if grep -q "Developer Mode is disabled" "$INSTALL_LOG"; then
    echo "Developer Mode is off on the iPhone." >&2
    echo "  Settings > Privacy & Security > Developer Mode → ON (reboot may be required)" >&2
  fi
  echo "Re-run: ./tools/scripts/install_on_device.sh" >&2
  rm -f "$INSTALL_LOG"
  exit 1
fi
rm -f "$INSTALL_LOG"

echo "==> Launching $BUNDLE_ID"
xcrun devicectl device process launch --device "$DEVICE_ID" "$BUNDLE_ID" || true

echo ""
echo "Done. On device, verify Chat:"
echo "  - Header + settings button (glass)"
echo "  - Composer card (glass)"
echo "  - Send a message → Planned Route chips"
echo "  - Message bubbles stay opaque (no glass)"
echo "  - Settings → Accessibility → Reduce Transparency (opaque fallbacks)"
