#!/usr/bin/env bash
# Pull the on-device PREXUS evaluation log written by Debug builds.
#
# Usage:
#   ./tools/scripts/fetch_device_eval_log.sh "Wang"

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="${PREXUS_DEVICE_EVAL_LOG_OUTPUT:-$ROOT/.eval-logs/wang-device-eval.log}"
DEVICE_FILTER="${1:-Wang}"
DEVICE_JSON="$(mktemp)"
trap 'rm -f "$DEVICE_JSON"' EXIT

xcrun devicectl list devices --json-output "$DEVICE_JSON" --quiet

DEVICE_ID="$(
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

mkdir -p "$(dirname "$OUT")"
xcrun devicectl device copy from \
  --device "$DEVICE_ID" \
  --source Documents/prexus-device-eval.log \
  --destination "$OUT" \
  --domain-type appDataContainer \
  --domain-identifier jp.studio-prospect.prexus.ios

echo "==> Device eval log saved to $OUT"
cat "$OUT"
