#!/usr/bin/env bash
# Copy the default local GGUF model into PREXUS app Documents/Models on a device.
#
# Usage:
#   ./tools/scripts/push_local_model_to_device.sh
#   ./tools/scripts/push_local_model_to_device.sh "Wang"

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MODEL="${PREXUS_LOCAL_MODEL_SOURCE:-$ROOT/models/prexus-local-mvp.gguf}"
DEST="${PREXUS_LOCAL_MODEL_DEST:-prexus-local-mvp.gguf}"
BUNDLE_ID="jp.studio-prospect.prexus.ios"
DEVICE_FILTER="${1:-}"
DEVICE_JSON="$(mktemp)"
trap 'rm -f "$DEVICE_JSON"' EXIT

if [[ ! -f "$MODEL" ]]; then
  echo "error: model not found at $MODEL" >&2
  echo "Run: ./tools/scripts/fetch_local_model.sh" >&2
  exit 1
fi

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

echo "==> Copying model to $DEVICE_NAME ($DEVICE_ID)"
echo "    $MODEL -> Documents/Models/$DEST"

xcrun devicectl device copy to \
  --device "$DEVICE_ID" \
  --source "$MODEL" \
  --destination "Documents/Models/$DEST" \
  --domain-type appDataContainer \
  --domain-identifier "$BUNDLE_ID"

echo "Done. Launch PREXUS and send a local-routed prompt to verify llama.cpp output."
