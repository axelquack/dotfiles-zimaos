#!/usr/bin/env bash
# Shellcheck the shell scripts and hooks, then reject whitespace errors in the diff.
# Read-only apart from shellcheck's own output.

set -euo pipefail

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "lint: not inside a git repository." >&2
  exit 2
fi

root="$(git rev-parse --show-toplevel)"
cd "$root"

rc=0

if command -v shellcheck >/dev/null 2>&1; then
  files=()
  for f in scripts/* .githooks/*; do
    if [[ ! -f "$f" || -L "$f" ]]; then
      continue
    fi
    if head -n 1 "$f" | grep -Eq 'bash|sh'; then
      files+=("$f")
    fi
  done
  if ((${#files[@]} > 0)); then
    shellcheck "${files[@]}" || rc=1
  fi
else
  echo "lint: shellcheck is not installed. Skipped the shell check." >&2
fi

git diff --check || rc=1
git diff --cached --check || rc=1

exit "$rc"
