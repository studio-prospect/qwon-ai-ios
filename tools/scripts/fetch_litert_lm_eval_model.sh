#!/usr/bin/env bash
# Download the LiteRT-LM Gemma 4 E2B evaluation artifact into models/ (gitignored).
#
# Default asset:
#   litert-community/gemma-4-E2B-it-litert-lm — gemma-4-E2B-it.litertlm (~2.6 GiB)
#
# Usage:
#   ./tools/scripts/fetch_litert_lm_eval_model.sh
#
# Optional override:
#   PREXUS_LITERT_MODEL_URL=... PREXUS_LITERT_MODEL_OUTPUT=... ./tools/scripts/fetch_litert_lm_eval_model.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MODELS_DIR="$ROOT/models"
OUTPUT="${PREXUS_LITERT_MODEL_OUTPUT:-$MODELS_DIR/prexus-eval-gemma4-e2b.litertlm}"
URL="${PREXUS_LITERT_MODEL_URL:-https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm/resolve/main/gemma-4-E2B-it.litertlm}"

mkdir -p "$MODELS_DIR"

if [[ -f "$OUTPUT" ]]; then
  echo "Model already present: $OUTPUT"
  exit 0
fi

echo "==> Downloading LiteRT-LM eval model"
echo "    URL: $URL"
echo "    -> $OUTPUT"
echo "    (~2.6 GiB — may take a while)"

curl -L --fail --progress-bar "$URL" -o "$OUTPUT"

echo ""
echo "Done."
echo "Device push:"
echo "  ./tools/scripts/push_litert_lm_model_to_device.sh \"Wang\""
