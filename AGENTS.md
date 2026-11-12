## Documentation, commit & push

Standing rule from Axel (2026-11-12), for every Grok bot and herdr agent working in this repo:

- Document every change in this project: README, `docs/`, and the changelog (`CHANGELOG.md` or `docs/changelog.md`), with date and what/why.
- Commit with a clear message, then push to the existing remote.
- Before each commit, run a secret check: `git diff --cached --name-only` and `git diff --cached`. Never commit `.env*`, keys, tokens, `auth.json`, credentials, session exports, or `*.bak*` files. If one is staged, unstage it and add it to `.gitignore`.
- Never push to a public repo, or make a repo public, without Axel's explicit OK (`gh repo view --json visibility`).
- If the repo has no remote, commit locally and report that.
- Commit only your own change; do not sweep in someone else's uncommitted work.
