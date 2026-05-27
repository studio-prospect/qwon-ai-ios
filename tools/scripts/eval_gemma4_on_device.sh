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
echo "==> Step 2/3: push Gemma eval GGUF (3.2 GiB — may take several minutes)"
PREXUS_LOCAL_MODEL_SOURCE="$EVAL_MODEL" \
PREXUS_LOCAL_MODEL_DEST="prexus-eval-gemma4-e2b-it.gguf" \
"$ROOT/tools/scripts/push_local_model_to_device.sh" "$DEVICE_FILTER"

echo ""
echo "==> Step 3/3: manual chat prompts on device"
echo "Send these in PREXUS Chat (local route):"
echo "  1) 明日の予定を整理する時、最初に何を確認すべきですか？"
echo "  2) Classify intent as JSON: chat|summarize|memory_write|tool_request|cloud_needed"
echo ""
echo "Capture Debug logs (Xcode Console or Terminal):"
echo "  log stream --device --predicate 'eventMessage CONTAINS \"local-inference-benchmark\"'"
echo ""
echo "Look for: cold_load_ms, first_token_ms, decode_tps"
echo "Default MVP model unchanged; eval file used when prexus-local-mvp.gguf is absent on device."
