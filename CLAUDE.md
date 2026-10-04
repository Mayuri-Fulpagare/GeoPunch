@AGENTS.md

## Claude Code notes

- Path-scoped rules load automatically from `.claude/rules/` (`backend.md` for `geopunch_api/**`, `flutter.md` for `geopunch_app/**`).
- Project skills in `.claude/skills/`: `add-api-module`, `add-prisma-change`, `add-flutter-feature`, `pre-commit-check`. Use them instead of improvising scaffolds.
- For changes that touch both API and app (new endpoint plus screen), plan first, change the API contract and DTOs first, then the app.
- Update `summary.md` when status changes.
