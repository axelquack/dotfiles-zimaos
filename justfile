# Repo-standard recipes.
# The type snippet is required and lives at just/dotfiles.just.
# Use `import`, so a missing file makes `just` fail.
# Do not load a dotenv file. Secrets stay out of the recipe environment.

set dotenv-load := false
set shell := ["bash", "-euo", "pipefail", "-c"]

import 'just/dotfiles.just'

# List the recipes.
default:
    just --list

# Point this clone at .githooks so pre-commit runs the secret check.
setup:
    git config core.hooksPath .githooks

# Secret-check the staged diff.
check:
    scripts/check-secrets.sh --staged

# Secret-check commits.
check-history:
    scripts/check-secrets.sh --history

# Shellcheck the scripts and the hooks, then look for whitespace errors.
lint:
    scripts/lint.sh

# Refresh the generated list in docs/README.md.
docs:
    scripts/docs-index.sh --write

# Report standard files that are missing. Read-only.
audit:
    scripts/repo-audit.sh

# Public repositories, before push: staged secret check, then the outgoing diff.
pre-push:
    just check
    git diff '@{u}..HEAD'
