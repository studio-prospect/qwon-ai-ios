#!/usr/bin/env bash
# Download Gemma-4-E2B-it evaluation GGUF (not committed; gitignored under models/).
#
# Default quant: Q4_K_M (~3.2 GiB) from bartowski — balances quality vs iPhone RAM.
# Smaller override example:
#   PREXUS_GEMMA4_EVAL_URL=https://huggingface.co/bartowski/google_gemma-4-E2B-it-GGUF/resolve/main/google_gemma-4-E2B-it-Q3_K_S.gguf ./tools/scripts/fetch_gemma4_e2b_eval_model.sh
#
# Usage:
#   ./tools/scripts/fetch_gemma4_e2b_eval_model.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MODELS_DIR="$ROOT/models"
OUTPUT="${PREXUS_GEMMA4_EVAL_OUTPUT:-$MODELS_DIR/prexus-eval-gemma4-e2b-it.gguf}"
URL="${PREXUS_GEMMA4_EVAL_URL:-https://huggingface.co/bartowski/google_gemma-4-E2B-it-GGUF/resolve/main/google_gemma-4-E2B-it-Q4_K_M.gguf}"

mkdir -p "$MODELS_DIR"

if [[ -f "$OUTPUT" ]]; then
  echo "Evaluation model already present: $OUTPUT"
  ls -lh "$OUTPUT"
  exit 0
fi

echo "==> Downloading Gemma-4-E2B-it evaluation GGUF"
echo "    URL: $URL"
echo "    -> $OUTPUT"
echo "    (evaluation candidate only — default MVP model unchanged)"

curl -L --fail --progress-bar "$URL" -o "$OUTPUT"

echo ""
echo "Done."
echo "Run benchmarks:"
echo "  ./tools/scripts/benchmark_local_gguf.sh \"$OUTPUT\""
echo "On device (A17 Pro+), set Xcode scheme env:"
echo "  PREXUS_LOCAL_MODEL_PATH=<absolute path to this file>"
