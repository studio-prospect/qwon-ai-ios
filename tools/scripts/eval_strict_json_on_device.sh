#!/usr/bin/env bash
# P1-4c-a: Strict JSON structured-output benchmark on Wang (Qwen vs LiteRT).
#
# Prerequisites:
#   - models/prexus-eval-gemma4-e2b.litertlm and prexus-local-mvp.gguf
#   - PREXUS_LITERT_LM_PROTOTYPE=1 project generation + Debug device build
#   - A17 Pro+ device (e.g. Wang), unlocked
#
# Usage:
#   ./tools/scripts/eval_strict_json_on_device.sh "Wang"

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DEVICE_FILTER="${1:-Wang}"
IOS="$ROOT/app/ios"
DERIVED="$ROOT/.derivedData-litert-prototype"
TEAM="${DEVELOPMENT_TEAM:-BWSS94LH28}"
APP="$DERIVED/Build/Products/Debug-iphoneos/PREXUS.app"
BUNDLE_ID="jp.studio-prospect.qwon.ios"
LOG_DIR="$ROOT/.eval-logs"
DETAIL_OUT="$LOG_DIR/litert-strict-json-${DEVICE_FILTER}-detail.csv"
SUMMARY_OUT="$LOG_DIR/litert-strict-json-${DEVICE_FILTER}-summary.json"

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
  -scheme PREXUS \
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

echo "==> Push models"
PREXUS_LOCAL_MODEL_DEST=prexus-local-mvp.gguf "$ROOT/tools/scripts/push_local_model_to_device.sh" "$DEVICE_FILTER"
xcrun devicectl device copy to \
  --device "$DEVICE_ID" \
  --source "$ROOT/models/prexus-eval-gemma4-e2b.litertlm" \
  --destination "Documents/Models/prexus-eval-gemma4-e2b.litertlm" \
  --domain-type appDataContainer \
  --domain-identifier "$BUNDLE_ID"

mkdir -p "$LOG_DIR"
BENCHMARK_START_ISO="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "==> Launch strict JSON benchmark (12 prompts x 2 backends) started_at=$BENCHMARK_START_ISO"

is_summary_fresh() {
  BENCHMARK_START_ISO="$BENCHMARK_START_ISO" SUMMARY_OUT="$SUMMARY_OUT" DETAIL_OUT="$DETAIL_OUT" python3 <<'PY'
import csv, json, os, sys
from datetime import datetime

start = datetime.fromisoformat(os.environ["BENCHMARK_START_ISO"].replace("Z", "+00:00"))
summary_path = os.environ["SUMMARY_OUT"]
with open(summary_path, encoding="utf-8") as handle:
    data = json.load(handle)
generated = datetime.fromisoformat(data["generatedAt"].replace("Z", "+00:00"))
if generated <= start:
    sys.exit(1)
litert = next((b for b in data.get("backends", []) if b.get("backend") == "litert_lm_gemma4"), None)
qwen = next((b for b in data.get("backends", []) if b.get("backend") == "qwen_llama_cpp"), None)
if not litert or not qwen:
    sys.exit(1)
if litert.get("runs", 0) != 12 or qwen.get("runs", 0) != 12:
    sys.exit(1)
if litert.get("medianTotalMs", 0) <= 100:
    sys.exit(1)
detail_path = os.environ.get("DETAIL_OUT", "")
if detail_path and os.path.isfile(detail_path):
    with open(detail_path, encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    if len(rows) != 24:
        sys.exit(1)
sys.exit(0)
PY
}

LAUNCHED=0
for attempt in 1 2 3 4 5 6 7 8 9 10; do
  if xcrun devicectl device process launch \
    --device "$DEVICE_ID" \
    --environment-variables '{"PREXUS_RUN_STRICT_JSON_BENCHMARK":"1"}' \
    "$BUNDLE_ID" 2>&1 | grep -q "Launched application"; then
    LAUNCHED=1
    echo "Launched on attempt ${attempt}"
    break
  fi
  echo "Launch attempt ${attempt} failed (unlock device?)"
  sleep 10
done

if [[ "$LAUNCHED" -ne 1 ]]; then
  echo "error: could not launch PREXUS on device (locked or unavailable)" >&2
  exit 1
fi

echo "==> Wait for benchmark (poll fresh summary on device, up to 35 min)"
POLL_SECONDS=2100
INTERVAL=30
ELAPSED=0
FRESH=0
while (( ELAPSED < POLL_SECONDS )); do
  xcrun devicectl device copy from \
    --device "$DEVICE_ID" \
    --source Documents/prexus-strict-json-benchmark-detail.csv \
    --destination "$DETAIL_OUT" \
    --domain-type appDataContainer \
    --domain-identifier "$BUNDLE_ID" 2>/dev/null || true
  if xcrun devicectl device copy from \
    --device "$DEVICE_ID" \
    --source Documents/prexus-strict-json-benchmark-summary.json \
    --destination "$SUMMARY_OUT" \
    --domain-type appDataContainer \
    --domain-identifier "$BUNDLE_ID" 2>/dev/null \
    && is_summary_fresh; then
    FRESH=1
    echo "Fresh benchmark summary detected after ${ELAPSED}s"
    break
  fi
  echo "  ... still running (${ELAPSED}s / ${POLL_SECONDS}s)"
  sleep "$INTERVAL"
  ELAPSED=$((ELAPSED + INTERVAL))
done

if [[ "$FRESH" -ne 1 ]]; then
  echo "error: timed out without a fresh benchmark summary (refusing stale logs)" >&2
  exit 1
fi

echo "==> Fetch logs"
xcrun devicectl device copy from \
  --device "$DEVICE_ID" \
  --source Documents/prexus-strict-json-benchmark-detail.csv \
  --destination "$DETAIL_OUT" \
  --domain-type appDataContainer \
  --domain-identifier "$BUNDLE_ID"

if ! is_summary_fresh; then
  echo "error: summary on device is stale after fetch" >&2
  exit 1
fi

echo "Done."
echo "  Detail:  $DETAIL_OUT"
echo "  Summary: $SUMMARY_OUT"
echo "--- summary ---"
cat "$SUMMARY_OUT"
