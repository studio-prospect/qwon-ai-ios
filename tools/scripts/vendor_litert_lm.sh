#!/usr/bin/env bash
# Vendor LiteRT-LM for Xcode local Swift package resolution.
#
# Upstream tag v0.12.0 uses Git LFS for Android prebuilts; SPM remote checkout can fail
# with "remote missing object". Shallow clone with LFS smudge skipped is enough for iOS.
#
# Usage:
#   ./tools/scripts/vendor_litert_lm.sh
#
# Optional:
#   PREXUS_LITERT_LM_TAG=v0.12.0 ./tools/scripts/vendor_litert_lm.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DEST="$ROOT/vendor/LiteRT-LM"
TAG="${PREXUS_LITERT_LM_TAG:-v0.12.0}"
URL="https://github.com/google-ai-edge/LiteRT-LM"

if [[ -f "$DEST/Package.swift" ]]; then
  echo "LiteRT-LM already vendored: $DEST"
  exit 0
fi

mkdir -p "$(dirname "$DEST")"
echo "==> Cloning LiteRT-LM ($TAG) into vendor/ (GIT_LFS_SKIP_SMUDGE=1)"
GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 --branch "$TAG" "$URL" "$DEST"

echo "Done. Regenerate Xcode project:"
echo "  PREXUS_LITERT_LM_EVAL=1 ruby tools/scripts/generate_xcodeproj.rb"
