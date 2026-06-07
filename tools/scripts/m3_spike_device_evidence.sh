#!/usr/bin/env bash
# Capture M3 spike device evidence (model status, optional download, chat smoke).
#
# Usage:
#   ./tools/scripts/m3_spike_device_evidence.sh "Matisse" model_status
#   ./tools/scripts/m3_spike_device_evidence.sh "Wang" model_status
#   ./tools/scripts/m3_spike_device_evidence.sh "Wang" m3_download
#   ./tools/scripts/m3_spike_device_evidence.sh "Wang" with_model

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DEVICE_FILTER="${1:?device name substring required}"
SCENARIO="${2:-model_status}"
BUNDLE_ID="jp.studio-prospect.qwon.ios"
LOG_DIR="${M3_EVIDENCE_DIR:-$HOME/QWON-alpha-evidence/qwon-m3-spike}"
RESULT_NAME="prexus-alpha-smoke-${SCENARIO}.json"
OUT_NAME="$(echo "$DEVICE_FILTER" | tr '[:upper:]' '[:lower:]')-${SCENARIO}-$(date -u +%Y%m%dT%H%M%SZ).json"

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

ENV_JSON="$(python3 -c "import json; print(json.dumps({'PREXUS_RUN_ALPHA_SMOKE':'1','PREXUS_ALPHA_SMOKE_SCENARIO':'${SCENARIO}'}))")"
START_ISO="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
POLL_MAX=120
if [[ "$SCENARIO" == "m3_download" ]]; then
  POLL_MAX=900
elif [[ "$SCENARIO" == "with_model" ]]; then
  POLL_MAX=300
fi

echo "==> Launch $SCENARIO smoke on $DEVICE_FILTER ($DEVICE_ID)"
xcrun devicectl device process launch \
  --device "$DEVICE_ID" \
  --terminate-existing \
  --environment-variables "$ENV_JSON" \
  "$BUNDLE_ID" >/dev/null

DEST="$LOG_DIR/$OUT_NAME"
for _ in $(seq 1 "$POLL_MAX"); do
  if xcrun devicectl device copy from \
    --device "$DEVICE_ID" \
    --source "Documents/$RESULT_NAME" \
    --destination "$DEST" \
    --domain-type appDataContainer \
    --domain-identifier "$BUNDLE_ID" 2>/dev/null; then
    if RESULT_PATH="$DEST" START_ISO="$START_ISO" SCENARIO="$SCENARIO" python3 <<'PY'
import json, os, sys
from datetime import datetime
with open(os.environ["RESULT_PATH"], encoding="utf-8") as handle:
    data = json.load(handle)
if data.get("scenario") != os.environ["SCENARIO"]:
    sys.exit(1)
generated = datetime.fromisoformat(data["generatedAt"].replace("Z", "+00:00"))
start = datetime.fromisoformat(os.environ["START_ISO"].replace("Z", "+00:00"))
if generated < start:
    sys.exit(1)
if (generated - start).total_seconds() > 3600:
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

echo "error: timed out waiting for $RESULT_NAME on $DEVICE_FILTER ($SCENARIO)" >&2
exit 1
