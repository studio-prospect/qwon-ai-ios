#!/usr/bin/env bash
# End-to-end LiteRT-LM device evaluation (isolated PREXUSLiteRTEval app).
#
# Prerequisites:
#   - iPhone unlocked, trusted, Developer Mode on
#   - models/prexus-eval-gemma4-e2b.litertlm (fetch_litert_lm_eval_model.sh)
#
# Usage:
#   ./tools/scripts/eval_litert_lm_on_device.sh
#   ./tools/scripts/eval_litert_lm_on_device.sh "Wang"
#
# Does NOT modify PREXUS production app or Qwen MVP files.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DEVICE_FILTER="${1:-Wang}"
EVAL_MODEL="$ROOT/models/prexus-eval-gemma4-e2b.litertlm"

if [[ ! -f "$EVAL_MODEL" ]]; then
  echo "error: missing $EVAL_MODEL" >&2
  echo "Run: ./tools/scripts/fetch_litert_lm_eval_model.sh" >&2
  exit 1
fi

echo "==> Step 1/4: regenerate Xcode project + build/install PREXUSLiteRTEval"
"$ROOT/tools/scripts/install_litert_eval_on_device.sh" "$DEVICE_FILTER"

echo ""
echo "==> Step 2/4: push .litertlm eval artifact (~2.6 GiB — may take several minutes)"
"$ROOT/tools/scripts/push_litert_lm_model_to_device.sh" "$DEVICE_FILTER"

echo ""
echo "==> Step 3/4: relaunch eval app (runs one automated smoke per install)"
xcrun devicectl device process launch --device "$(
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
)" --console com.prexus.ios.literteval || true

echo ""
echo "==> Step 4/4: fetch eval log"
echo "Wait for cold load + two prompts to finish, then:"
echo "  ./tools/scripts/fetch_litert_device_eval_log.sh \"$DEVICE_FILTER\""
echo ""
echo "Look for: cold_load_ms, ja-first_token_ms, ja-response, routing-response"
echo "Record results in docs/research/litert_lm_evaluation_plan.md"
echo ""
echo "PREXUS production (Qwen MVP) is unchanged. Remove PREXUSLiteRTEval from device when done."
