# Changelog

This file is published with a public repository.

It must never contain IP addresses, hostnames, MAC addresses, internal paths, usernames, email addresses, vault IDs, credentials, or pane IDs.

Detailed private notes may go into `CHANGELOG.private.md`. That file is gitignored in a public repository. Do not commit it.

Newest first. Dates are Europe/Berlin, `YYYY-MM-DD`.

Use one heading per change: `## YYYY-MM-DD — title`. Under it, keep only the subsections that have items. End with a Why line.

## 2026-11-13 — Work tracking rule

### Changed

- AGENTS.md has a Work tracking section: open work goes on the owner's GitHub Project board, not into new TODO.md items.

**Why:** one board for all open work (Axel, 2026-11-13).

## 2026-11-13 — Public repo standard

### Added

- The repo-standard file set: `AGENTS.md` skeleton, `CLAUDE.md` symlink, `CHANGELOG.md`, `ROADMAP.md`, `TODO.md`, `BUGFIXES.md`, `SECURITY.md`, `justfile`, `just/dotfiles.just`, `.githooks/pre-commit`, `scripts/check-secrets.sh`, `scripts/lint.sh`, `scripts/docs-index.sh`, `scripts/repo-audit.sh`, `.gitleaks.toml`, `.github/workflows/gitleaks.yml`, and `.env.example` (names only; this repo has no settings).
- `docs/README.md` as the index. `docs/vi_nano_summary.md` stays in place. The editor limits are BF-001 and BF-002.
- Public gitignore rules so `HANDOFF.md` and `CHANGELOG.private.md` stay untracked. The existing `secrets/` ignore rule stays.

### Changed

- `LICENSE` is PolyForm Noncommercial 1.0.0. Versions published before this commit remain under CC0-1.0. Axel is the sole contributor.
- `README.md` follows the repo-standard layout and keeps the prompt, alias, wget, and install facts.
- `AGENTS.md` follows the skeleton. The Herdr agent line is Frida (Dotfiles) · ZimaOS shell dotfiles.
- `docs/vi_nano_summary.md` records the date 2025-04-03. There was no `CLAUDE.md`, `IDEAS.md`, `PLAN.md`, or `docs/roadmap.md` to merge.

### Security

- Branch protection on main (set by Shepherd on GitHub): pull request required (0 approvals, administrators included), force-push and deletion blocked. From now on changes reach the default branch through a pull request.
- `pre-commit` runs `scripts/check-secrets.sh --staged` after `just setup`.
- GitHub Actions runs gitleaks on push and pull_request.

**Why:** This public repository needs an explicit noncommercial license, a secret check, and a file map before further edits.

## 2026-11-12 — Documentation, commit, and push rule

### Added

- Standing rule in `AGENTS.md`: document changes, secret-check the staged diff, and commit only this agent's own work.

**Why:** Every agent working in this repo follows the same commit rule.

## 2025-04-08 — Editor note typo

### Fixed

- Typo in the vi and nano note. The editor limits are unchanged.

**Why:** The note should name the build system correctly.

## 2025-04-03 — Shell files published

### Added

- Interactive bash setup, a login script that sources it, and a wget rc.
- A README for the prompt, aliases, and wget settings.
- Notes on the vi and nano limits.
- CC0-1.0 license. Those published versions remain under CC0-1.0.

**Why:** Publish a shell setup for ZimaOS that does not need git on the machine.
