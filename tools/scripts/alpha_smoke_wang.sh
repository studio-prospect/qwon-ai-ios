#!/usr/bin/env bash
# Qwen text-only alpha RC smoke on Wang (backend + sensitivity matrix).
#
# Usage:
#   ./tools/scripts/alpha_smoke_wang.sh "Wang"
#   PREXUS_SKIP_BUILD=1 ./tools/scripts/alpha_smoke_wang.sh "Wang"

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DEVICE_FILTER="${1:-Wang}"
IOS="$ROOT/app/ios"
DERIVED="$ROOT/.derivedData-alpha-smoke"
TEAM="${DEVELOPMENT_TEAM:-}"
APP="$DERIVED/Build/Products/Debug-iphoneos/QWON.app"
BUNDLE_ID="jp.studio-prospect.qwon.ios"
LOG_DIR="$ROOT/.eval-logs"
RESULT_OUT="$LOG_DIR/wang-alpha-smoke-with_model.json"
MISSING_RESULT_OUT="$LOG_DIR/wang-alpha-smoke-no_model.json"
SENSITIVITY_OUT="$LOG_DIR/wang-alpha-smoke-sensitivity_matrix.json"

if [[ ! -f "$ROOT/models/prexus-local-mvp.gguf" ]]; then
  echo "error: missing models/prexus-local-mvp.gguf — run ./tools/scripts/fetch_local_model.sh" >&2
  exit 1
fi

if [[ ! -d "$ROOT/vendor/llama-cpp-artifacts/llama.xcframework" ]]; then
  echo "error: missing llama.xcframework — run ./tools/scripts/build_llama_xcframework.sh && ruby tools/scripts/generate_xcodeproj.rb" >&2
  exit 1
fi

ruby "$ROOT/tools/scripts/generate_xcodeproj.rb"

if [[ "${PREXUS_SKIP_BUILD:-0}" != "1" ]]; then
  if [[ -z "$TEAM" ]]; then
    echo "error: set DEVELOPMENT_TEAM to your Apple Developer Team ID, or set PREXUS_SKIP_BUILD=1 after a prior signed build." >&2
    exit 1
  fi

  echo "==> Build Debug QWON for device"
  cd "$IOS"
  xcodebuild \
    -project PREXUS.xcodeproj \
    -scheme QWON \
    -destination 'generic/platform=iOS' \
    -derivedDataPath "$DERIVED" \
    DEVELOPMENT_TEAM="$TEAM" \
    -allowProvisioningUpdates \
    build
else
  echo "==> Skipping build (PREXUS_SKIP_BUILD=1)"
  if [[ ! -d "$APP" ]]; then
    echo "error: missing $APP — run without PREXUS_SKIP_BUILD first" >&2
    exit 1
  fi
fi

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

echo "==> Install QWON"
xcrun devicectl device install app --device "$DEVICE_ID" "$APP"

resolve_device() {
  echo "$DEVICE_ID"
}

fetch_smoke_result() {
  local scenario="$1"
  local dest="$2"
  xcrun devicectl device copy from \
    --device "$DEVICE_ID" \
    --source "Documents/prexus-alpha-smoke-${scenario}.json" \
    --destination "$dest" \
    --domain-type appDataContainer \
    --domain-identifier "$BUNDLE_ID" 2>/dev/null
}

wait_for_smoke_result() {
  local dest="$1"
  local scenario="$2"
  local start_iso="$3"
  local poll="${4:-120}"
  local interval=5
  local elapsed=0
  while (( elapsed < poll )); do
    if fetch_smoke_result "$scenario" "$dest" && RESULT_PATH="$dest" START_ISO="$start_iso" SCENARIO="$scenario" python3 <<'PY'
import json, os, sys
from datetime import datetime

with open(os.environ["RESULT_PATH"], encoding="utf-8") as handle:
    data = json.load(handle)
if data.get("scenario") != os.environ["SCENARIO"]:
    sys.exit(1)
generated = datetime.fromisoformat(data["generatedAt"].replace("Z", "+00:00"))
start = datetime.fromisoformat(os.environ["START_ISO"].replace("Z", "+00:00"))
# Allow same-second writes; reject only results clearly from a prior launch.
if (start - generated).total_seconds() > 2:
    sys.exit(1)
if os.environ["SCENARIO"] == "sensitivity_matrix":
    results = data.get("results", [])
    if len(results) != 4 or any(item.get("error") for item in results):
        sys.exit(1)
    sys.exit(0)
if data.get("error"):
    sys.exit(1)
sys.exit(0)
PY
    then
      echo "Fresh smoke result ($scenario) after ${elapsed}s"
      return 0
    fi
    sleep "$interval"
    elapsed=$((elapsed + interval))
  done
  echo "error: timed out waiting for alpha smoke result ($scenario)" >&2
  return 1
}

launch_smoke() {
  local scenario="$1"
  local extra_env="${2:-}"
  local start_iso
  start_iso="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  local env_json
  env_json="$(SCENARIO="$scenario" EXTRA="$extra_env" python3 <<'PY'
import json, os
env = {
    "PREXUS_RUN_ALPHA_SMOKE": "1",
    "PREXUS_ALPHA_SMOKE_SCENARIO": os.environ["SCENARIO"],
}
extra = os.environ.get("EXTRA", "").strip()
if extra:
    for part in extra.split(","):
        key, _, value = part.partition("=")
        if key:
            env[key] = value
print(json.dumps(env))
PY
)"
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if xcrun devicectl device process launch \
      --device "$DEVICE_ID" \
      --terminate-existing \
      --environment-variables "$env_json" \
      "$BUNDLE_ID" 2>&1 | grep -q "Launched application"; then
      echo "Launched smoke ($scenario) on attempt ${attempt}" >&2
      echo "$start_iso"
      return 0
    fi
    echo "Launch attempt ${attempt} failed (unlock Wang?)" >&2
    sleep 8
  done
  echo "error: could not launch QWON for smoke ($scenario)" >&2
  exit 1
}

mkdir -p "$LOG_DIR"

echo "==> Scenario A: with_model (push GGUF)"
"$ROOT/tools/scripts/push_local_model_to_device.sh" "$DEVICE_FILTER"
START_A="$(launch_smoke with_model)"
wait_for_smoke_result "$RESULT_OUT" "with_model" "$START_A"

echo "==> Scenario B: no_model (PREXUS_LOCAL_MODEL_PATH missing)"
START_B="$(launch_smoke no_model "PREXUS_LOCAL_MODEL_PATH=/var/empty/prexus-missing.gguf")"
wait_for_smoke_result "$MISSING_RESULT_OUT" "no_model" "$START_B"

echo "==> Scenario C: sensitivity_matrix (four modes, GGUF present)"
START_C="$(launch_smoke sensitivity_matrix)"
wait_for_smoke_result "$SENSITIVITY_OUT" "sensitivity_matrix" "$START_C" 420

echo "==> Validate results"
WITH_PATH="$RESULT_OUT" NO_PATH="$MISSING_RESULT_OUT" SENS_PATH="$SENSITIVITY_OUT" python3 <<'PY'
import json, os, sys

def load(path):
    with open(path, encoding="utf-8") as handle:
        return json.load(handle)

with_data = load(os.environ["WITH_PATH"])
no_data = load(os.environ["NO_PATH"])

errors = []
if with_data.get("executionModel") != "llama.cpp On-Device Runtime":
    errors.append(f"with_model: expected llama.cpp backend, got {with_data.get('executionModel')!r}")
if with_data.get("executionMode") != "local":
    errors.append(f"with_model: expected executionMode local, got {with_data.get('executionMode')!r}")
detail = with_data.get("executionDetail") or ""
if "answered_by=llama.cpp On-Device Runtime" not in detail:
    errors.append("with_model: executionDetail missing answered_by=llama.cpp")

if no_data.get("executionMode") != "fallback":
    errors.append(f"no_model: expected executionMode fallback, got {no_data.get('executionMode')!r}")
if no_data.get("executionModel") != "Embedded Heuristic Runtime":
    errors.append(f"no_model: expected Embedded Heuristic, got {no_data.get('executionModel')!r}")
detail = no_data.get("executionDetail") or ""
if "model_asset_unavailable" not in detail:
    errors.append("no_model: executionDetail missing model_asset_unavailable")
if "fallback_reason=embedded_heuristic" not in detail:
    errors.append("no_model: executionDetail missing fallback_reason=embedded_heuristic")

sens = load(os.environ["SENS_PATH"])
rows = sens.get("results", [])
if len(rows) != 4:
    errors.append(f"sensitivity_matrix: expected 4 results, got {len(rows)}")
for row in rows:
    label = row.get("sensitivity", "?")
    if row.get("error"):
        errors.append(f"sensitivity_matrix/{label}: error {row['error']}")
        continue
    codes = row.get("routeReasonCodes", [])
    target = row.get("routeTarget")
    mode = row.get("executionMode")
    if label == "localOnly":
        if target != "Local" or "local_only" not in codes:
            errors.append(f"sensitivity_matrix/localOnly: expected local route with local_only, got {target} {codes}")
    elif label == "localPreferred":
        if target != "Local":
            errors.append(f"sensitivity_matrix/localPreferred: expected route Local, got {target!r}")
    elif label == "escalationAllowed":
        if "codeAnalysis" not in codes:
            errors.append(f"sensitivity_matrix/escalationAllowed: expected codeAnalysis in {codes}")
        if mode not in ("local", "cloud", "fallback"):
            errors.append(f"sensitivity_matrix/escalationAllowed: unexpected mode {mode!r}")
    elif label == "providerRestricted":
        if target != "Local" or "provider_restricted" not in codes:
            errors.append(f"sensitivity_matrix/providerRestricted: expected local + provider_restricted, got {target} {codes}")

if errors:
    print("VALIDATION FAILED:", file=sys.stderr)
    for err in errors:
        print(f"  - {err}", file=sys.stderr)
    sys.exit(1)

print("VALIDATION PASSED")
print("with_model:", json.dumps(with_data, ensure_ascii=False))
print("no_model:", json.dumps(no_data, ensure_ascii=False))
print("sensitivity_matrix:", json.dumps(sens, ensure_ascii=False))
PY

echo "Done."
echo "  with_model:           $RESULT_OUT"
echo "  no_model:             $MISSING_RESULT_OUT"
echo "  sensitivity_matrix:   $SENSITIVITY_OUT"
