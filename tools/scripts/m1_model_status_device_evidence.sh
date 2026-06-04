#!/usr/bin/env bash
# Capture read-only M1 model status JSON from a physical device (DEBUG build).
#
# Usage:
#   ./tools/scripts/m1_model_status_device_evidence.sh "Wang"
#   ./tools/scripts/m1_model_status_device_evidence.sh "Matisse"

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DEVICE_FILTER="${1:?device name substring required}"
BUNDLE_ID="jp.studio-prospect.qwon.ios"
LOG_DIR="${M1_EVIDENCE_DIR:-$HOME/QWON-alpha-evidence/qwon-m1-post-merge}"
RESULT_NAME="prexus-alpha-smoke-model_status.json"
OUT_NAME="$(echo "$DEVICE_FILTER" | tr '[:upper:]' '[:lower:]')-m1-model-status.json"

mkdir -p "$LOG_DIR"

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

ENV_JSON='{"PREXUS_RUN_ALPHA_SMOKE":"1","PREXUS_ALPHA_SMOKE_SCENARIO":"model_status"}'
START_ISO="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

echo "==> Launch model_status smoke on $DEVICE_FILTER ($DEVICE_ID)"
xcrun devicectl device process launch \
  --device "$DEVICE_ID" \
  --terminate-existing \
  --environment-variables "$ENV_JSON" \
  "$BUNDLE_ID" >/dev/null

DEST="$LOG_DIR/$OUT_NAME"
for _ in $(seq 1 24); do
  if xcrun devicectl device copy from \
    --device "$DEVICE_ID" \
    --source "Documents/$RESULT_NAME" \
    --destination "$DEST" \
    --domain-type appDataContainer \
    --domain-identifier "$BUNDLE_ID" 2>/dev/null; then
    if RESULT_PATH="$DEST" START_ISO="$START_ISO" python3 <<'PY'
import json, os, sys
from datetime import datetime
with open(os.environ["RESULT_PATH"], encoding="utf-8") as handle:
    data = json.load(handle)
if data.get("scenario") != "model_status":
    sys.exit(1)
generated = datetime.fromisoformat(data["generatedAt"].replace("Z", "+00:00"))
start = datetime.fromisoformat(os.environ["START_ISO"].replace("Z", "+00:00"))
if (start - generated).total_seconds() > 5:
    sys.exit(1)
print(json.dumps(data, ensure_ascii=False, indent=2))
PY
    then
      echo "==> Wrote $DEST"
      exit 0
    fi
  fi
  sleep 2
done

echo "error: timed out waiting for $RESULT_NAME on $DEVICE_FILTER" >&2
exit 1
