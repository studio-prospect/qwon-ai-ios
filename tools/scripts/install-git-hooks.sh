#!/usr/bin/env bash
# Install optional git hooks (pre-commit: git diff --check on staged files).
#
# Usage:
#   ./tools/scripts/install-git-hooks.sh          # install only if no pre-commit hook
#   ./tools/scripts/install-git-hooks.sh --force  # backup existing hook, then install
#
set -euo pipefail

FORCE=0
for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    -h | --help)
      sed -n '2,6p' "$0"
      exit 0
      ;;
    *)
      echo "error: unknown argument: $arg (try --force)" >&2
      exit 1
      ;;
  esac
done

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GIT_DIR="$(git -C "$ROOT" rev-parse --git-dir 2>/dev/null)" || {
  echo "error: not inside a git repository ($ROOT)" >&2
  exit 1
}

HOOK_DIR="$(cd "$ROOT/$GIT_DIR" && pwd)/hooks"
HOOK="$HOOK_DIR/pre-commit"
MARKER="Installed by tools/scripts/install-git-hooks.sh"

write_hook() {
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
}

mkdir -p "$HOOK_DIR"

if [[ -f "$HOOK" ]]; then
  if grep -qF "$MARKER" "$HOOK" 2>/dev/null; then
    write_hook
    echo "Refreshed pre-commit hook (already installed by this script): $HOOK"
    exit 0
  fi

  if [[ "$FORCE" -ne 1 ]]; then
    echo "error: $HOOK already exists and was not installed by this script." >&2
    echo "Refusing to overwrite. Use --force to backup and replace, or remove the hook manually." >&2
    exit 1
  fi

  BACKUP="$HOOK.bak.$(date +%Y%m%d-%H%M%S)"
  cp "$HOOK" "$BACKUP"
  echo "Backed up existing hook to: $BACKUP"
fi

write_hook
echo "Installed pre-commit hook: $HOOK"
