#!/usr/bin/env bash
# Build and install the isolated PREXUSLiteRTEval app (does not touch QWON production app/runtime).
#
# Prerequisites:
#   PREXUS_LITERT_LM_EVAL=1 ruby tools/scripts/generate_xcodeproj.rb
#
# Usage:
#   ./tools/scripts/install_litert_eval_on_device.sh
#   ./tools/scripts/install_litert_eval_on_device.sh "Wang"

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
IOS="$ROOT/app/ios"
DERIVED="$ROOT/.derivedData-litert-eval"
TEAM="${DEVELOPMENT_TEAM:-BWSS94LH28}"
BUNDLE_ID="jp.studio-prospect.qwon.ios.literteval"
APP="$DERIVED/Build/Products/Debug-iphoneos/PREXUSLiteRTEval.app"
DEVICE_FILTER="${1:-}"

if [[ ! -d "$IOS/PREXUS.xcodeproj" ]]; then
  echo "error: missing $IOS/PREXUS.xcodeproj — run PREXUS_LITERT_LM_EVAL=1 ruby tools/scripts/generate_xcodeproj.rb" >&2
  exit 1
fi

echo "==> Vendoring LiteRT-LM Swift package (avoids broken upstream Git LFS checkout)"
"$ROOT/tools/scripts/vendor_litert_lm.sh"

echo "==> Regenerating Xcode project with LiteRT-LM eval target"
PREXUS_LITERT_LM_EVAL=1 ruby "$ROOT/tools/scripts/generate_xcodeproj.rb"

echo "==> Building PREXUSLiteRTEval for device (DEVELOPMENT_TEAM=$TEAM)"
cd "$IOS"
xcodebuild \
  -project PREXUS.xcodeproj \
  -scheme PREXUSLiteRTEval \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "$DERIVED" \
  -resolvePackageDependencies \
  DEVELOPMENT_TEAM="$TEAM" \
  -allowProvisioningUpdates \
  build

if [[ ! -d "$APP" ]]; then
  echo "error: expected app at $APP" >&2
  exit 1
fi

DEVICE_JSON="$(mktemp)"
trap 'rm -f "$DEVICE_JSON"' EXIT

if ! xcrun devicectl list devices --json-output "$DEVICE_JSON" --quiet 2>/dev/null; then
  echo "error: devicectl list devices failed" >&2
  exit 1
fi

DEVICE_RESOLUTION="$(
  DEVICE_JSON="$DEVICE_JSON" DEVICE_FILTER="$DEVICE_FILTER" python3 <<'PY'
import json
import os
import sys

with open(os.environ["DEVICE_JSON"], encoding="utf-8") as handle:
    payload = json.load(handle)

devices = payload.get("result", {}).get("devices", [])
matches = []
for device in devices:
    identifier = device.get("identifier", "")
    if not identifier:
        continue
    name = device.get("deviceProperties", {}).get("name", "")
    if os.environ.get("DEVICE_FILTER") and os.environ["DEVICE_FILTER"] not in name:
        continue
    tunnel = device.get("connectionProperties", {}).get("tunnelState") == "connected"
    matches.append((tunnel, name, identifier))

if not matches:
    sys.exit(1)

matches.sort(key=lambda item: (not item[0], item[1].casefold()))
print(f"{matches[0][2]}\t{matches[0][1]}")
PY
)" || {
  echo "error: could not resolve device" >&2
  exit 1
}

DEVICE_ID="${DEVICE_RESOLUTION%%$'\t'*}"
DEVICE_NAME="${DEVICE_RESOLUTION#*$'\t'}"

echo "==> Installing PREXUSLiteRTEval to $DEVICE_NAME ($DEVICE_ID)"
xcrun devicectl device install app --device "$DEVICE_ID" "$APP"

echo ""
echo "Done (install only — do not launch before the model is on device)."
echo "Next: run the full eval workflow (push, launch, wait, fetch log):"
echo "  ./tools/scripts/eval_litert_lm_on_device.sh \"$DEVICE_FILTER\""
echo "  # or manually: push_litert_lm_model_to_device.sh, then devicectl launch"
