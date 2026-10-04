---
name: pre-commit-check
description: Run lint, build, tests and git identity checks for GeoPunch before committing. Use before every commit or when asked to verify changes.
---

# Pre-commit check

Run what applies to the changed paths (`git status`), report real output, do not claim success if anything fails.

API changed (`geopunch_api/`):
```bash
cd geopunch_api
npm run lint
npm run build          # must produce dist/main.js
npx prisma validate    # if schema.prisma changed
npm test
```
Known baseline: 4 spec suites (auth/attendance controller and service) fail because providers are not mocked. A change must not add new failures; fixing these is welcome.

App changed (`geopunch_app/`):
```bash
cd geopunch_app
flutter pub get
flutter analyze
flutter test
```

Repo hygiene:
- `git status`: no `.env`, `dist/`, `node_modules/`, `build/` or secrets staged.
- `git config user.email` must print `mayurifulpagare13@gmail.com`; `git remote -v` must use `github-personal`.
- Commit message in Conventional Commits style. Do not push unless the user asks.
