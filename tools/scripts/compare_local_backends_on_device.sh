#!/usr/bin/env bash
# P1-4b: Run Qwen vs LiteRT comparison prompts inside Debug PREXUS on device.
#
# Prerequisites:
#   - models/prexus-eval-gemma4-e2b.litertlm and prexus-local-mvp.gguf fetched
#   - PREXUS_LITERT_LM_PROTOTYPE=1 project generation + Debug device build
#   - A17 Pro+ device (e.g. Wang)
#
# Usage:
#   ./tools/scripts/compare_local_backends_on_device.sh "Wang"

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DEVICE_FILTER="${1:-Wang}"
IOS="$ROOT/app/ios"
DERIVED="$ROOT/.derivedData-litert-prototype"
TEAM="${DEVELOPMENT_TEAM:-BWSS94LH28}"
APP="$DERIVED/Build/Products/Debug-iphoneos/QWON.app"
BUNDLE_ID="jp.studio-prospect.qwon.ios"
LOG_OUT="$ROOT/.eval-logs/litert-backend-comparison-${DEVICE_FILTER}.log"

if [[ ! -f "$ROOT/models/prexus-eval-gemma4-e2b.litertlm" ]]; then
  echo "error: missing LiteRT eval model — run ./tools/scripts/fetch_litert_lm_eval_model.sh" >&2
  exit 1
fi

if [[ ! -f "$ROOT/models/prexus-local-mvp.gguf" ]]; then
  echo "error: missing Qwen MVP — run ./tools/scripts/fetch_local_model.sh" >&2
  exit 1
fi

echo "==> Vendor + regenerate PREXUS with LiteRT prototype"
"$ROOT/tools/scripts/vendor_litert_lm.sh"
PREXUS_LITERT_LM_PROTOTYPE=1 ruby "$ROOT/tools/scripts/generate_xcodeproj.rb"

echo "==> Build Debug PREXUS for device"
cd "$IOS"
xcodebuild \
  -project PREXUS.xcodeproj \
  -scheme QWON \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "$DERIVED" \
  DEVELOPMENT_TEAM="$TEAM" \
  -allowProvisioningUpdates \
  build

DEVICE_ID="$(
  DEVICE_JSON="$(mktemp)"
  xcrun devicectl list devices --json-output "$DEVICE_JSON" --quiet
  DEVICE_JSON="$DEVICE_JSON" DEVICE_FILTER="$DEVICE_FILTER" python3 <<'PY'
import json, os, sys
with open(os.environ["DEVICE_JSON"], encoding="utf-8") as handle:
    devices = json.load(handle).get("result", {}).get("devices", [])
matches = []
for device in devices:
    name = device.get("deviceProperties", {}).get("name", "")
    if os.environ.get("DEVICE_FILTER") and os.environ["DEVICE_FILTER"] not in name:
        continue
    if device.get("identifier"):
        matches.append((device.get("connectionProperties", {}).get("tunnelState") == "connected", name, device["identifier"]))
if not matches:
    sys.exit(1)
matches.sort(key=lambda item: (not item[0], item[1].casefold()))
print(matches[0][2])
PY
)"

echo "==> Install PREXUS Debug"
xcrun devicectl device install app --device "$DEVICE_ID" "$APP"

echo "==> Push Qwen MVP + LiteRT eval artifacts"
PREXUS_LOCAL_MODEL_DEST=prexus-local-mvp.gguf "$ROOT/tools/scripts/push_local_model_to_device.sh" "$DEVICE_FILTER"
xcrun devicectl device copy to \
  --device "$DEVICE_ID" \
  --source "$ROOT/models/prexus-eval-gemma4-e2b.litertlm" \
  --destination "Documents/Models/prexus-eval-gemma4-e2b.litertlm" \
  --domain-type appDataContainer \
  --domain-identifier "$BUNDLE_ID"

echo "==> Launch PREXUS with comparison env"
xcrun devicectl device process launch \
  --device "$DEVICE_ID" \
  --environment-variables '{"PREXUS_RUN_BACKEND_COMPARISON":"1"}' \
  "$BUNDLE_ID"

echo "==> Wait for comparison runner"
sleep 180

echo "==> Fetch comparison log"
mkdir -p "$(dirname "$LOG_OUT")"
xcrun devicectl device copy from \
  --device "$DEVICE_ID" \
  --source Documents/prexus-backend-comparison.log \
  --destination "$LOG_OUT" \
  --domain-type appDataContainer \
  --domain-identifier "$BUNDLE_ID"

echo "Done. Log: $LOG_OUT"
cat "$LOG_OUT"
