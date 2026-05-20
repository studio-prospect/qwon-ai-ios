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
#   ./tools/scripts/install_on_device.sh "My iPhone"   # optional name substring filter

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
DEVICE_JSON="$(mktemp)"
trap 'rm -f "$DEVICE_JSON"' EXIT

if ! xcrun devicectl list devices --json-output "$DEVICE_JSON" --quiet 2>/dev/null; then
  echo "error: devicectl list devices failed" >&2
  exit 1
fi

RESOLVE_STATUS=0
DEVICE_RESOLUTION="$(
  DEVICE_JSON="$DEVICE_JSON" DEVICE_FILTER="$DEVICE_FILTER" python3 <<'PY'
import json
import os
import sys

path = os.environ["DEVICE_JSON"]
name_filter = os.environ.get("DEVICE_FILTER", "")

with open(path, encoding="utf-8") as handle:
    payload = json.load(handle)

devices = payload.get("result", {}).get("devices", [])
if not devices:
    sys.exit(2)

matches = []
for device in devices:
    identifier = device.get("identifier", "")
    if not identifier:
        continue

    properties = device.get("deviceProperties", {})
    name = properties.get("name", "")
    if name_filter and name_filter not in name:
        continue

    connection = device.get("connectionProperties", {})
    tunnel_connected = connection.get("tunnelState") == "connected"
    matches.append((tunnel_connected, name, identifier))

if not matches:
    sys.exit(3)

matches.sort(key=lambda item: (not item[0], item[1].casefold()))
name, identifier = matches[0][1], matches[0][2]
print(f"{identifier}\t{name}")
PY
)" || RESOLVE_STATUS=$?

if [[ "$RESOLVE_STATUS" -eq 2 ]]; then
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

if [[ "$RESOLVE_STATUS" -ne 0 ]] || [[ -z "$DEVICE_RESOLUTION" ]]; then
  echo "error: could not resolve a device identifier." >&2
  if [[ -n "$DEVICE_FILTER" ]]; then
    echo "No device matched filter: $DEVICE_FILTER" >&2
  fi
  xcrun devicectl list devices 2>&1 || true
  echo ""
  echo "Pass a device name substring: ./tools/scripts/install_on_device.sh \"Wang\""
  exit 1
fi

DEVICE_ID="${DEVICE_RESOLUTION%%$'\t'*}"
DEVICE_NAME="${DEVICE_RESOLUTION#*$'\t'}"

echo "==> Installing to device: $DEVICE_NAME ($DEVICE_ID)"
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
