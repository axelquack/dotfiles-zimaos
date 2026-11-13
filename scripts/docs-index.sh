#!/usr/bin/env bash
# List docs/**/*.md between markers in docs/README.md.
# Without --write, print the block. With --write, replace the marked block
# or append it. Text outside the markers is left as it is.

set -euo pipefail

write=0
case "${1:-}" in
  "")
    write=0
    ;;
  --write)
    write=1
    ;;
  -h|--help)
    echo "usage: scripts/docs-index.sh [--write]" >&2
    exit 0
    ;;
  *)
    echo "docs-index: unknown argument: $1" >&2
    exit 2
    ;;
esac

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "docs-index: not inside a git repository." >&2
  exit 2
fi

root="$(git rev-parse --show-toplevel)"
cd "$root"

start='<!-- docs-index:start -->'
end='<!-- docs-index:end -->'
index="docs/README.md"

block_file="$(mktemp)"
tmp_index=""
cleanup() {
  rm -f "$block_file"
  if [[ -n "$tmp_index" ]]; then
    rm -f "$tmp_index"
  fi
}
trap cleanup EXIT

mkdir -p docs

{
  printf '%s\n' "$start"
  if [[ -d docs ]]; then
    find docs -type f -name '*.md' | sort | while IFS= read -r f; do
      if [[ "$f" == "docs/README.md" ]]; then
        continue
      fi
      rel="${f#docs/}"
      name="$(basename "$f" .md)"
      printf -- '- [%s](%s)\n' "$name" "$rel"
    done
  fi
  printf '%s\n' "$end"
} > "$block_file"

if [[ "$write" -eq 0 ]]; then
  cat "$block_file"
  exit 0
fi

if [[ ! -f "$index" ]]; then
  {
    printf '%s\n\n' '# Docs'
    cat "$block_file"
    printf '\n'
  } > "$index"
  echo "docs-index: wrote $index"
  exit 0
fi

if grep -qF "$start" "$index" && grep -qF "$end" "$index"; then
  tmp_index="$(mktemp)"
  awk -v start="$start" -v end="$end" -v blockfile="$block_file" '
    $0 == start {
      while ((getline line < blockfile) > 0) print line
      close(blockfile)
      skip = 1
      next
    }
    $0 == end { skip = 0; next }
    skip != 1 { print }
  ' "$index" > "$tmp_index"
  mv "$tmp_index" "$index"
  tmp_index=""
  echo "docs-index: updated $index"
else
  {
    printf '\n'
    cat "$block_file"
    printf '\n'
  } >> "$index"
  echo "docs-index: appended the index to $index"
fi
