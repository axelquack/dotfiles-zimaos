Herdr agent: Frida (Dotfiles) · ZimaOS shell dotfiles

Lead bot: Frida / Visibility: public / Default branch: main / Push: PR only

`CLAUDE.md` is a symlink to `AGENTS.md` (`ln -sf AGENTS.md CLAUDE.md`). Edit `AGENTS.md` only. Do not keep a second copy.

## Role

### Project

This repository is the shell dotfiles for ZimaOS: an interactive bash setup, a login script that sources it, and a wget rc. It holds those files. It does not apply them.

### This agent owns

- `.bashrc`, `.bash_profile`, and `.wgetrc`.
- The docs for those files, including the vi and nano limits.
- The public repo-standard files in the file map.

### Out of scope & handoff

- Applying the dotfiles, opening a shell on a ZimaOS host, or changing a live home directory. The install steps in `README.md` are for a person at the machine.
- Hosts, devices, VMs, and containers.
- Other repositories. Do not edit agent-platform from this tree. Its handoff folder is handled separately.

## Start here

Read in this order:

1. `AGENTS.md` (this file).
2. `README.md`.
3. `BUGFIXES.md` and `SECURITY.md`.
4. `HANDOFF.md`, the last three entries in `CHANGELOG.md`, and `git log -5`. In this public repo `HANDOFF.md` is gitignored.
5. The current ticket, or else `TODO.md` and `ROADMAP.md`.
6. `docs/README.md`.

## File map

| File | What it is for | Who updates it |
| --- | --- | --- |
| `README.md` | What the repo is, the status line, and where to start | The person who changes the project |
| `AGENTS.md` | Rules for the herdr agent | The owning agent, when the role or the rules change |
| `CLAUDE.md` | Symlink to `AGENTS.md`. Same text. No second copy | Nobody. Recreate it with `ln -sf AGENTS.md CLAUDE.md` |
| `CHANGELOG.md` | What changed, newest first, with a why. Public sanitized variant | Whoever makes the change |
| `ROADMAP.md` | Now, next, later, ideas, and done recently | The owning agent, when the plan moves |
| `TODO.md` | Interim task list until the agent-ops board exists | The agent who holds the work |
| `BUGFIXES.md` | Durable bug writeups, `BF-NNN`. Holds the vi and nano limits | Whoever records the fix |
| `HANDOFF.md` | Done, next, and open questions. Tracked in a private repo. Gitignored in a public repo | The agent, before stopping |
| `SECURITY.md` | Threat model, where secrets live, and leak response | The owning agent, when the threat model changes |
| `LICENSE` | Rights granted for this repo. PolyForm Noncommercial 1.0.0 | Axel |
| `justfile` | Repeatable recipes, including the secret check. Imports `just/dotfiles.just` | Whoever adds a recipe |
| `just/dotfiles.just` | Dotfiles recipes. Preview only until Axel asks. Not a file at the repository root | Whoever adds a recipe |
| `docs/` | Longer docs. The index is `docs/README.md` | Whoever writes the doc |
| `docs/README.md` | Index of every docs page | Whoever adds or removes a docs page |
| `docs/vi_nano_summary.md` | Why vi and nano stay uncustomized | Whoever retests the editors |
| `.bashrc` | Interactive shell: prompt, aliases, history, and welcome text | Whoever changes the shell setup |
| `.bash_profile` | Login shell. Sources the bashrc from the ZimaOS data directory | Whoever changes login behavior |
| `.wgetrc` | wget timeouts, retries, and reject list | Whoever changes download defaults |
| `.env.example` | Setting names only. This repo has no settings. No secret values | Whoever adds a setting |
| `.gitignore` | Ignore rules. Base fragment plus the public fragment. Keeps the handoff and the private changelog untracked | Whoever changes ignore rules |
| `.githooks` | Git hooks. `pre-commit` runs the secret check | Whoever changes the check |
| `.githooks/pre-commit` | Runs `scripts/check-secrets.sh --staged` | Whoever changes the check |
| `scripts/check-secrets.sh` | Fails when a secret-shaped file name or a gitleaks finding is in scope | Whoever changes the check |
| `scripts/lint.sh` | Shellcheck the scripts and hooks, then reject whitespace errors | Whoever changes the check |
| `scripts/docs-index.sh` | Refresh the generated list in `docs/README.md` | Whoever changes the index |
| `scripts/repo-audit.sh` | Report standard files that are missing | Whoever changes the standard |
| `.gitleaks.toml` | Gitleaks rules and the license-text allowlist | Whoever changes the secret check |
| `.github/workflows/gitleaks.yml` | Gitleaks on push and pull_request. Actions are pinned to commit SHAs | Whoever changes the CI check |
| `.github/dependabot.yml` | Weekly update check for the `github-actions` ecosystem only | Whoever changes the update schedule |

## Hard limits

- Secrets never go into git. No tokens, auth keys, `.env` files other than `.env.example`, `auth.json`, credential files, private keys, or session exports. Use a placeholder such as `<SECRET>`.
- This repository is public. Never add IP addresses, hostnames, MAC addresses, internal paths, usernames, email addresses, vault IDs, credentials, or pane IDs.
- Never apply the dotfiles, ssh to a ZimaOS host, or touch the live home directory.
- `just preview` only prints a reminder. Do not apply files from a recipe.
- The bash prompt shows username and hostname with the generic escapes. Leave those escapes generic.
- Do not commit `HANDOFF.md` or `CHANGELOG.private.md`.
- vi and nano stay as they are (BF-001, BF-002).
- Mark anything you have not verified as **unverified**.

## Workflow

- Work through tickets and pull requests when the agent-ops board exists. Until then, track the task in `TODO.md`.
- One ticket at a time. Write a holder line on the ticket before you start, so two agents do not take the same ticket.
- When Push says PR only, open a pull request against the default branch. Axel or a lead merges. Branch protection on `main` (set by Shepherd on GitHub): pull request required (0 approvals, administrators included), force-push and deletion blocked.
- Stage by explicit path. Do not use `git add -A` or `git add .`.
- No force-push. A history rewrite needs Axel's approval.
- If a permission question or a blocker cannot be resolved, stop and say so.

## Documentation, commit & push

Standing rule from Axel (2026-11-12), for every Grok bot and herdr agent working in this repo:

- Document every change in this project: README, `docs/`, and the changelog (`CHANGELOG.md` or `docs/changelog.md`), with date and what/why.
- Commit with a clear message, then push to the repo's existing remote, public or private, after the secret check.
- Before each commit, run a secret check: `git diff --cached --name-only` and `git diff --cached`. Never commit `.env*`, keys, tokens, `auth.json`, credentials, session exports, or `*.bak*` files. If one is staged, unstage it and add it to `.gitignore`.
- Public repos (`gh repo view --json visibility`): be extra strict. Before pushing, review the full diff being pushed (`git diff @{u}..HEAD`) for secrets, tokens, private IPs and hostnames the repo does not already contain, personal data, and session exports. If anything looks sensitive, do not push; report it to Axel.
- If the repo has no remote, commit locally and report that.
- Commit only your own change; do not sweep in someone else's uncommitted work.

## Secrets

Secrets live in Proton Pass, in `~/.grok/.env`, or on Axel's secure secret cards. They do not live in this repository.

Before every commit, run:

```
git diff --cached --name-only
git diff --cached
scripts/check-secrets.sh --staged
```

The `pre-commit` hook runs `scripts/check-secrets.sh --staged` after `just setup`.

If a secret was committed: rotate it first, tell Axel, and do not rewrite history unless Axel approves the force-push.

## Handoff

Before you stop, write what you did, what is next, and the open questions.

In a private repository, update `HANDOFF.md` and keep it tracked.

In a public repository, `HANDOFF.md` is gitignored. Write the note in the agent-platform repository at `handoffs/<repo>.md`.
