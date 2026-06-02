#!/usr/bin/env bash
# Build llama.cpp XCFramework for QWON iOS integration.
#
# Prerequisites:
#   - git submodule: vendor/llama.cpp (see .gitmodules)
#   - cmake 3.28+
#   - Xcode command line tools
#
# Output:
#   vendor/llama-cpp-artifacts/llama.xcframework
#
# Usage:
#   ./tools/scripts/build_llama_xcframework.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
VENDOR="$ROOT/vendor/llama.cpp"
OUT_DIR="$ROOT/vendor/llama-cpp-artifacts"
OUT_FRAMEWORK="$OUT_DIR/llama.xcframework"

if [[ ! -f "$VENDOR/build-xcframework.sh" ]]; then
  echo "error: vendor/llama.cpp is missing. Run:" >&2
  echo "  git submodule update --init --recursive vendor/llama.cpp" >&2
  exit 1
fi

echo "==> Building llama.cpp XCFramework (this can take several minutes)"
cd "$VENDOR"
./build-xcframework.sh

mkdir -p "$OUT_DIR"
rm -rf "$OUT_FRAMEWORK"
cp -R "$VENDOR/build-apple/llama.xcframework" "$OUT_FRAMEWORK"

echo "==> Installed XCFramework at $OUT_FRAMEWORK"
echo "Next:"
echo "  ruby tools/scripts/generate_xcodeproj.rb"
echo "  cd app/ios && xcodebuild ..."
