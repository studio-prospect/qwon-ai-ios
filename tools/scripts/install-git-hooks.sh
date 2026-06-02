#!/usr/bin/env bash
# Install optional git hooks (pre-commit: git diff --check on staged files).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GIT_DIR="$(git -C "$ROOT" rev-parse --git-dir 2>/dev/null)" || {
  echo "error: not inside a git repository ($ROOT)" >&2
  exit 1
}

HOOK_DIR="$(cd "$ROOT/$GIT_DIR" && pwd)/hooks"
HOOK="$HOOK_DIR/pre-commit"

mkdir -p "$HOOK_DIR"
cat >"$HOOK" <<'EOF'
#!/bin/sh
# Installed by tools/scripts/install-git-hooks.sh
git diff --check --cached || {
  echo "pre-commit: trailing whitespace or conflict marker in staged diff." >&2
  echo "Fix with: git diff --check" >&2
  exit 1
}
EOF
chmod +x "$HOOK"
echo "Installed pre-commit hook: $HOOK"
