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
# Does NOT modify QWON production app/runtime or Qwen MVP files.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DEVICE_FILTER="${1:-Wang}"
EVAL_MODEL="$ROOT/models/prexus-eval-gemma4-e2b.litertlm"

if [[ ! -f "$EVAL_MODEL" ]]; then
  echo "error: missing $EVAL_MODEL" >&2
  echo "Run: ./tools/scripts/fetch_litert_lm_eval_model.sh" >&2
  exit 1
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

echo "==> Step 1/6: fresh install (uninstall prior eval app + UserDefaults)"
xcrun devicectl device uninstall app --device "$DEVICE_ID" jp.studio-prospect.qwon.ios.literteval 2>/dev/null || true

echo "==> Step 2/6: regenerate Xcode project + build/install PREXUSLiteRTEval (no launch)"
"$ROOT/tools/scripts/install_litert_eval_on_device.sh" "$DEVICE_FILTER"

echo ""
echo "==> Step 3/6: push .litertlm eval artifact (~2.6 GiB — may take several minutes)"
"$ROOT/tools/scripts/push_litert_lm_model_to_device.sh" "$DEVICE_FILTER"

echo ""
echo "==> Step 4/6: launch eval app (smoke runs only after model is present)"
xcrun devicectl device process launch --device "$DEVICE_ID" jp.studio-prospect.qwon.ios.literteval

echo ""
echo "==> Step 5/6: wait for smoke eval (cold load + prompts; ~1–3 min on A17 Pro+)"
sleep 120

echo ""
echo "==> Step 6/6: fetch eval log"
LOG_OUT="$ROOT/.eval-logs/litert-device-eval-${DEVICE_FILTER}.log"
PREXUS_LITERT_EVAL_LOG_OUTPUT="$LOG_OUT" "$ROOT/tools/scripts/fetch_litert_device_eval_log.sh" "$DEVICE_FILTER"

echo ""
echo "Look for: cold_load_ms, ja-first_token_ms, ja-response, routing-response, eval-complete"
echo "Log saved to: $LOG_OUT"
echo "Record results in docs/research/litert_lm_evaluation_plan.md"
echo ""
echo "QWON production app/runtime (Qwen MVP) is unchanged. Remove PREXUSLiteRTEval from device when done."
