#!/usr/bin/env bash
# Pull prexus-litert-device-eval.log from PREXUSLiteRTEval app container.
#
# Usage:
#   ./tools/scripts/fetch_litert_device_eval_log.sh
#   ./tools/scripts/fetch_litert_device_eval_log.sh "Wang"

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="${PREXUS_LITERT_EVAL_LOG_OUTPUT:-$ROOT/.eval-logs/litert-device-eval.log}"
BUNDLE_ID="jp.studio-prospect.qwon.ios.literteval"
DEVICE_FILTER="${1:-Wang}"
DEVICE_JSON="$(mktemp)"
trap 'rm -f "$DEVICE_JSON"' EXIT

mkdir -p "$(dirname "$OUT")"

if ! xcrun devicectl list devices --json-output "$DEVICE_JSON" --quiet 2>/dev/null; then
  echo "error: devicectl list devices failed" >&2
  exit 1
fi

DEVICE_ID="$(
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
print(matches[0][2])
PY
)"

echo "==> Fetching Documents/prexus-litert-device-eval.log -> $OUT"
xcrun devicectl device copy from \
  --device "$DEVICE_ID" \
  --source Documents/prexus-litert-device-eval.log \
  --destination "$OUT" \
  --domain-type appDataContainer \
  --domain-identifier "$BUNDLE_ID"

echo "Done."
cat "$OUT"
