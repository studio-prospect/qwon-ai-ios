#!/usr/bin/env bash
# Download the default QWON local MVP GGUF model into models/ (gitignored).
#
# Default asset:
#   Qwen2.5-0.5B-Instruct Q4_K_M (~400MB, better multilingual QA than SmolLM2-360M)
#
# SmolLM2 fallback (smaller, English-biased demo):
#   PREXUS_LOCAL_MODEL_URL=https://huggingface.co/bartowski/SmolLM2-360M-Instruct-GGUF/resolve/main/SmolLM2-360M-Instruct-Q4_K_M.gguf ./tools/scripts/fetch_local_model.sh
#
# Usage:
#   ./tools/scripts/fetch_local_model.sh
#
# Optional override:
#   PREXUS_LOCAL_MODEL_URL=... PREXUS_LOCAL_MODEL_OUTPUT=... ./tools/scripts/fetch_local_model.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MODELS_DIR="$ROOT/models"
OUTPUT="${PREXUS_LOCAL_MODEL_OUTPUT:-$MODELS_DIR/prexus-local-mvp.gguf}"
URL="${PREXUS_LOCAL_MODEL_URL:-https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/Qwen2.5-0.5B-Instruct-Q4_K_M.gguf}"

mkdir -p "$MODELS_DIR"

if [[ -f "$OUTPUT" ]]; then
  echo "Model already present: $OUTPUT"
  exit 0
fi

echo "==> Downloading local MVP model"
echo "    URL: $URL"
echo "    -> $OUTPUT"

curl -L --fail --progress-bar "$URL" -o "$OUTPUT"

echo ""
echo "Done."
echo "Place on device via one of:"
echo "  - Xcode → Devices → QWON → Download container → Documents/Models/prexus-local-mvp.gguf"
echo "  - PREXUS_LOCAL_MODEL_PATH when running from Xcode"
echo "  - Optional app bundle copy for local device debug builds (see models/README.md)"
