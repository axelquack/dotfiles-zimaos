#!/usr/bin/env bash
# Fail when a secret-shaped file name is in scope, or when gitleaks finds a leak.
#
#   scripts/check-secrets.sh            working tree (tracked + untracked, not ignored)
#   scripts/check-secrets.sh --staged   the index (what pre-commit runs)
#   scripts/check-secrets.sh --history  every commit
#
# Bash 3.2 is enough. This script does not use associative arrays.

set -euo pipefail

mode="worktree"
case "${1:-}" in
  "")
    mode="worktree"
    ;;
  --staged)
    mode="staged"
    ;;
  --history)
    mode="history"
    ;;
  -h|--help)
    echo "usage: scripts/check-secrets.sh [--staged|--history]" >&2
    exit 0
    ;;
  *)
    echo "check-secrets: unknown argument: $1" >&2
    exit 2
    ;;
esac

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "check-secrets: gitleaks is not installed or not on PATH. Install gitleaks, then run this script again." >&2
  exit 127
fi

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "check-secrets: not inside a git repository." >&2
  exit 2
fi

root="$(git rev-parse --show-toplevel)"
cd "$root"

# .env.example is the only allowed env file. Every other pattern here is rejected.
name_forbidden() {
  local base="$1"
  if [[ "$base" == ".env.example" ]]; then
    return 1
  fi
  case "$base" in
    .env|.env.*)
      return 0
      ;;
    *.bak*)
      return 0
      ;;
    *.pem|*.key)
      return 0
      ;;
    id_rsa*|id_ed25519*)
      return 0
      ;;
    auth.json|auth*.json)
      return 0
      ;;
    *credentials*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

collect_paths() {
  case "$mode" in
    worktree)
      git ls-files -z -c -o --exclude-standard
      ;;
    staged)
      git diff --cached --name-only -z --diff-filter=ACMR
      ;;
    history)
      if git rev-parse --verify HEAD >/dev/null 2>&1; then
        git log --all --pretty=tformat: --name-only -z
      fi
      ;;
  esac
}

tmp=""
seen_file="$(mktemp)"
bad_file="$(mktemp)"
scan_file="$(mktemp)"
cleanup() {
  if [[ -n "$tmp" ]]; then
    rm -rf "$tmp"
  fi
  rm -f "$seen_file" "$bad_file" "$scan_file"
}
trap cleanup EXIT

while IFS= read -r -d '' path; do
  if [[ -z "$path" ]]; then
    continue
  fi
  if grep -Fxq -- "$path" "$seen_file"; then
    continue
  fi
  printf '%s\n' "$path" >> "$seen_file"
  base="${path##*/}"
  if name_forbidden "$base"; then
    printf '%s\n' "$path" >> "$bad_file"
  fi
  printf '%s\n' "$path" >> "$scan_file"
done < <(collect_paths)

name_rc=0
if [[ -s "$bad_file" ]]; then
  name_rc=1
  echo "check-secrets: forbidden file name (unstage it and add it to .gitignore):" >&2
  while IFS= read -r path; do
    echo "  $path" >&2
  done < "$bad_file"
fi

gl_rc=0
run_gitleaks() {
  if [[ -f "$root/.gitleaks.toml" ]]; then
    gitleaks "$@" --config "$root/.gitleaks.toml"
  else
    gitleaks "$@"
  fi
}

case "$mode" in
  staged)
    set +e
    run_gitleaks protect --staged --no-banner --redact
    gl_rc=$?
    set -e
    ;;
  history)
    if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
      echo "check-secrets: no commits to scan." >&2
      gl_rc=0
    else
      set +e
      run_gitleaks detect --no-banner --redact
      gl_rc=$?
      set -e
    fi
    ;;
  worktree)
    if [[ ! -s "$scan_file" ]]; then
      echo "check-secrets: working tree has no files to scan." >&2
    else
      tmp="$(mktemp -d)"
      while IFS= read -r path; do
        if [[ -f "$path" && ! -L "$path" ]]; then
          mkdir -p "$tmp/$(dirname "$path")"
          cp -P "$path" "$tmp/$path"
        fi
      done < "$scan_file"
      set +e
      run_gitleaks detect --no-git --source "$tmp" --no-banner --redact 2>&1 | sed "s#${tmp}/##g"
      gl_rc=${PIPESTATUS[0]}
      set -e
    fi
    ;;
esac

if [[ "$gl_rc" -ne 0 ]]; then
  echo "check-secrets: gitleaks found a leak." >&2
fi

if [[ "$name_rc" -ne 0 ]]; then
  cleanup
  exit 1
fi
if [[ "$gl_rc" -ne 0 ]]; then
  cleanup
  exit "$gl_rc"
fi

echo "check-secrets: no findings ($mode)."
cleanup
exit 0
