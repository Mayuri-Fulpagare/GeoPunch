# GeoPunch: agent and contributor guide

Geo-fenced attendance system. Read `summary.md` for current status, known bugs and next steps before starting work.

## Repo map

| Path | What | Stack |
|---|---|---|
| `geopunch_api/` | REST API | NestJS 11, Prisma 7 + `@prisma/adapter-pg`, PostgreSQL (Neon), JWT, class-validator |
| `geopunch_app/` | Mobile app (Android, iOS) | Flutter, GetX, Dio, Geolocator, flutter_map |
| `geopunch design/` | PNG mockups, reference only | |
| `summary.md` | Status, bugs, roadmap | |

Detailed per-stack rules live in `.claude/rules/backend.md` and `.claude/rules/flutter.md`. Task recipes live in `.claude/skills/`.

## Commands

API (`cd geopunch_api`):
- `npm ci`, then `cp .env.example .env` and fill it in
- `npm run start:dev`, `npm run build`, `npm run lint`, `npm test`
- `npm run db:generate`, `npm run db:migrate`, `npm run db:seed`

App (`cd geopunch_app`):
- `flutter pub get`, `flutter run`, `flutter analyze`, `flutter test`

## Architecture rules

- API is feature-modular: `src/modules/<feature>/` holds `<feature>.module.ts`, `.controller.ts`, `.service.ts`, `dto/`, and specs next to the code. Shared helpers go in `src/common/`. Prisma access goes through the global `PrismaService` in `src/prisma/`.
- Controller is thin: parse DTO, call service, return result. Business rules and DB access live in the service.
- Routes keep the prefix `api/v1/<feature>` declared in `@Controller(...)`.
- App is feature-first: `lib/features/<feature>/{controllers,screens,models,services}`. Cross-feature code goes in `lib/core/`. One GetX controller per feature area. Screens contain UI only, no HTTP calls and no business logic.
- All HTTP from the app goes through `lib/core/network/api_client.dart`. GPS goes through `lib/core/services/location_service.dart`.
- Colors come from `core/constants/app_colors.dart`, theme from `core/theme/app_theme.dart`. No hardcoded colors in screens.
- Import with `package:geopunch_app/...`.

## Security rules (non-negotiable)

- Every new API route except register and login must be protected by a JWT guard. Take the user id from the verified token, never from the request body or URL.
- Never trust client-supplied `officeId`, coordinates, accuracy or "is mocked" flags for a security decision without server-side validation.
- No secrets, tokens, passwords, LAN IPs or personal paths in code or commits. Config goes in `.env` (API) or build-time config (app). `.env` is ignored, `.env.example` is tracked and holds placeholders only.
- Do not log passwords, tokens, emails or full request bodies.
- Login must return the same error for unknown email and wrong password (known gap, see `summary.md`).

## Coding conventions

- API: TypeScript, Prettier (single quotes, trailing commas), ESLint. DTOs use class-validator decorators. Use Nest exceptions (`BadRequestException`, `UnauthorizedException`, ...) with clear messages.
- App: Dart, `flutter_lints`. Prefer `const` widgets, wrap only the smallest reactive subtree in `Obx`, release controller resources on close.
- Files: API dotted kebab-case (`attendance.service.ts`), app `snake_case.dart`. Classes `PascalCase`, members `camelCase`.
- Add or update a spec/test for every new service method or controller route. Mock `PrismaService` and `JwtService` instead of writing "should be defined" tests that cannot resolve providers.
- Keep `summary.md` current when you finish a roadmap item or find a new bug.

## Git rules

- This is a personal project. Commit identity is `Mayuri-Fulpagare <mayurifulpagare13@gmail.com>`, remote uses SSH host alias `github-personal`. Never use the work account or SSH alias `github-work`, and do not change global git or `gh` auth.
- Work on a branch, use Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`). Do not push or force-push unless asked.
- Never commit `.env`, build output, `node_modules`, or the generated Prisma client.
