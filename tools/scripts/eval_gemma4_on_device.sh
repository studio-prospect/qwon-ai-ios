#!/usr/bin/env bash
# End-to-end Gemma-4-E2B-it device evaluation on A17 Pro+ (evaluation only).
#
# Prerequisites:
#   - iPhone unlocked, trusted, Developer Mode on
#   - models/prexus-eval-gemma4-e2b-it.gguf present (fetch_gemma4_e2b_eval_model.sh)
#   - vendor/llama-cpp-artifacts/llama.xcframework built
#   - ruby tools/scripts/generate_xcodeproj.rb already run
#
# Usage:
#   ./tools/scripts/eval_gemma4_on_device.sh
#   ./tools/scripts/eval_gemma4_on_device.sh "Wang"

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DEVICE_FILTER="${1:-Wang}"
EVAL_MODEL="$ROOT/models/prexus-eval-gemma4-e2b-it.gguf"

if [[ ! -f "$EVAL_MODEL" ]]; then
  echo "error: missing $EVAL_MODEL" >&2
  echo "Run: ./tools/scripts/fetch_gemma4_e2b_eval_model.sh" >&2
  exit 1
fi

echo "==> Step 1/3: build + install Debug app (unlock iPhone first)"
"$ROOT/tools/scripts/install_on_device.sh" "$DEVICE_FILTER"

echo ""
echo "==> Step 2/4: push Gemma eval GGUF (3.2 GiB — may take several minutes)"
echo "    Note: if an older Qwen MVP file exists on device, Step 2b overwrites it for this eval session."
PREXUS_LOCAL_MODEL_SOURCE="$EVAL_MODEL" \
PREXUS_LOCAL_MODEL_DEST="prexus-eval-gemma4-e2b-it.gguf" \
"$ROOT/tools/scripts/push_local_model_to_device.sh" "$DEVICE_FILTER"

echo ""
echo "==> Step 2b/4: also copy Gemma into MVP slot so placement picks it over any stale Qwen file"
PREXUS_LOCAL_MODEL_SOURCE="$EVAL_MODEL" \
PREXUS_LOCAL_MODEL_DEST="prexus-local-mvp.gguf" \
"$ROOT/tools/scripts/push_local_model_to_device.sh" "$DEVICE_FILTER"

echo ""
echo "==> Step 3/4: launch PREXUS (Debug build runs one device smoke prompt on large models)"
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
)" --console jp.studio-prospect.prexus.ios || true

echo ""
echo "==> Step 4/4: optional manual prompts + log capture"
echo "Send these in PREXUS Chat (local route):"
echo "  1) 明日の予定を整理する時、最初に何を確認すべきですか？"
echo "  2) Classify intent as JSON: chat|summarize|memory_write|tool_request|cloud_needed"
echo ""
echo "Capture Debug logs (Xcode Console or Terminal while app runs from Xcode):"
echo "  /usr/bin/log stream --predicate 'eventMessage CONTAINS \"local-inference-benchmark\" OR eventMessage CONTAINS \"device-eval\"'"
echo ""
echo "Look for: cold_load_ms, first_token_ms, decode_tps, device-eval response"
echo "Restore default Qwen on device after eval:"
echo "  ./tools/scripts/fetch_local_model.sh && PREXUS_LOCAL_MODEL_DEST=prexus-local-mvp.gguf ./tools/scripts/push_local_model_to_device.sh \"$DEVICE_FILTER\""
