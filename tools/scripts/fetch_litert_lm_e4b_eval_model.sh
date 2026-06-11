#!/usr/bin/env bash
# Download the LiteRT-LM Gemma 4 E4B evaluation artifact into models/ (gitignored).
#
# Official iOS path (not mobile-transformers Safetensors):
#   litert-community/gemma-4-E4B-it-litert-lm — gemma-4-E4B-it.litertlm (~3.66 GiB)
#
# Usage:
#   ./tools/scripts/fetch_litert_lm_e4b_eval_model.sh
#
# Optional override:
#   PREXUS_LITERT_MODEL_URL=... PREXUS_LITERT_MODEL_OUTPUT=... ./tools/scripts/fetch_litert_lm_e4b_eval_model.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MODELS_DIR="$ROOT/models"
OUTPUT="${PREXUS_LITERT_MODEL_OUTPUT:-$MODELS_DIR/prexus-eval-gemma4-e4b.litertlm}"
URL="${PREXUS_LITERT_MODEL_URL:-https://huggingface.co/litert-community/gemma-4-E4B-it-litert-lm/resolve/main/gemma-4-E4B-it.litertlm}"

mkdir -p "$MODELS_DIR"

if [[ -f "$OUTPUT" ]]; then
  echo "Model already present: $OUTPUT"
  exit 0
fi

echo "==> Downloading LiteRT-LM E4B eval model"
echo "    URL: $URL"
echo "    -> $OUTPUT"
echo "    (~3.66 GiB — may take a while)"

curl -L --fail --progress-bar "$URL" -o "$OUTPUT"

echo ""
echo "Done."
echo "Device eval:"
echo "  ./tools/scripts/eval_litert_lm_e4b_on_device.sh \"Wang\""
