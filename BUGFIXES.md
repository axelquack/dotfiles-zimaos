# Bugfixes

Durable bug writeups. One heading per bug: `BF-NNN`. Keep the number. Do not reuse it.

The limits below come from `docs/vi_nano_summary.md`. They are still current.

## BF-001 — vi cannot be customized

- Status: wontfix
- Date: 2025-04-03
- Symptom: A user rc, a `set` command, and command-line options do not enable line numbers, color, or key maps.
- Cause: The editor is a minimal build. It does not read a vim rc. See `docs/vi_nano_summary.md`.
- Policy: Leave it as it is. Do not add a vim rc or an alias that tries to turn those features on.

## BF-002 — nano tiny build ignores its rc

- Status: wontfix
- Date: 2025-04-03
- Symptom: A nano rc does not apply. Syntax color, line numbers, and auto-indent flags are not available. A few flags, such as constant cursor position, do work.
- Cause: The build is the tiny configuration. See `docs/vi_nano_summary.md`.
- Policy: Leave it as it is. Do not add a nano rc or aliases for color or line numbers.
