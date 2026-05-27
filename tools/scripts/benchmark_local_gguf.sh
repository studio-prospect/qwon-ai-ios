#!/usr/bin/env bash
# Benchmark a GGUF model with llama-cli (macOS Metal). Does not modify app defaults.
#
# For throughput numbers prefer llama-bench (see models/README.md).
# llama-cli runs single-turn qualitative checks; use -st to avoid interactive hang.
#
# Prerequisites:
#   - vendor/llama.cpp built: cmake -B build-mac ... && cmake --build build-mac --target llama-cli
#   - Model file from fetch_local_model.sh or fetch_gemma4_e2b_eval_model.sh
#
# Usage:
#   ./tools/scripts/benchmark_local_gguf.sh models/prexus-eval-gemma4-e2b-it.gguf
#   ./tools/scripts/benchmark_local_gguf.sh   # defaults to models/prexus-local-mvp.gguf if present

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LLAMA_DIR="$ROOT/vendor/llama.cpp"
CLI="$LLAMA_DIR/build-mac/bin/llama-cli"
MODEL="${1:-$ROOT/models/prexus-local-mvp.gguf}"
N_PRED="${PREXUS_BENCH_N_PRED:-64}"
N_CTX="${PREXUS_BENCH_N_CTX:-2048}"
N_GPU="${PREXUS_BENCH_N_GPU_LAYERS:-99}"

if [[ ! -x "$CLI" ]]; then
  echo "error: llama-cli not found at $CLI" >&2
  echo "Build with:" >&2
  echo "  cd vendor/llama.cpp && cmake -B build-mac -DCMAKE_BUILD_TYPE=Release -DGGML_METAL=ON && cmake --build build-mac -j --target llama-cli" >&2
  exit 1
fi

if [[ ! -f "$MODEL" ]]; then
  echo "error: model not found: $MODEL" >&2
  exit 1
fi

JAPANESE_PROMPT='あなたはPREXUSのローカル補助モデルです。短く自然な日本語で答えてください。
質問: 明日の予定を整理する時、最初に何を確認すべきですか？'

ROUTING_PROMPT='Classify the user intent as one of: chat, summarize, memory_write, tool_request, cloud_needed.
User: この長いメモを3点に要約して、あとで見返せるようにして
Return only JSON.'

echo "==> PREXUS local GGUF benchmark"
echo "    model: $MODEL"
echo "    cli:   $CLI"
echo "    n_predict=$N_PRED n_ctx=$N_CTX n_gpu_layers=$N_GPU"
echo ""

run_case() {
  local label="$1"
  local prompt="$2"
  echo "---- $label ----"
  /usr/bin/time -l "$CLI" \
    -m "$MODEL" \
    -ngl "$N_GPU" \
    -c "$N_CTX" \
    -n "$N_PRED" \
    --temp 0.2 \
    -st \
    --no-display-prompt \
    -p "$prompt" 2>&1 | tail -40
  echo ""
}

echo "---- cold load + japanese (first run) ----"
/usr/bin/time -l "$CLI" \
  -m "$MODEL" \
  -ngl "$N_GPU" \
  -c "$N_CTX" \
  -n "$N_PRED" \
  --temp 0.2 \
  -st \
  --no-display-prompt \
  -p "$JAPANESE_PROMPT" 2>&1 | tail -40
echo ""

echo "---- warm decode + routing JSON ----"
run_case "routing-json" "$ROUTING_PROMPT"

echo "---- warm decode + japanese (repeat) ----"
run_case "japanese-repeat" "$JAPANESE_PROMPT"

echo "Done. Paste llama-cli timing lines into docs/research/gemma4_e2b_evaluation_plan.md."
