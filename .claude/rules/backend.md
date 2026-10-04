---
paths:
  - "geopunch_api/**"
---

# Backend rules (NestJS + Prisma)

## Where things go

| Adding | Put it in |
|---|---|
| New feature | `src/modules/<feature>/` (use the `add-api-module` skill) |
| Request/response shape | `src/modules/<feature>/dto/<name>.dto.ts` with class-validator |
| Shared pure helper | `src/common/utils/` (see `geo.util.ts` `calculateDistance`) |
| Guard, decorator, filter, interceptor | `src/common/guards/`, `decorators/`, `filters/`, `interceptors/` |
| DB model change | `prisma/schema.prisma` (use the `add-prisma-change` skill) |
| Seed data | `prisma/seed.ts` |
| Test | `<file>.spec.ts` next to the code; e2e in `test/` |

## Layering

controller (HTTP, DTO, guard) -> service (rules, orchestration) -> `PrismaService`. Services never touch `req`/`res`. Controllers never call Prisma.

## Rules

- Register each new module in `AppModule.imports`. `PrismaModule` is global, do not re-provide `PrismaService`.
- Keep the `@Controller('api/v1/<feature>')` prefix style. Never rename existing routes without updating the app.
- Validate input with DTOs. `ValidationPipe({ whitelist: true })` is global; put a class-validator decorator on every DTO field (`@IsNotEmpty`, `@IsUUID`, `@IsNumber`, ...).
- Protect routes with the JWT guard once it exists. Derive `userId` from the token.
- Config via `ConfigService` (`JWT_SECRET`, `DATABASE_URL`, `DIRECT_URL`, `PORT`). Add every new variable to `.env.example`.
- Use Nest `Logger`, not `console.log`. Never log passwords, tokens or emails.
- Prisma 7: the client is created with the pg adapter in `PrismaService`. Do not instantiate extra `PrismaClient`s outside `prisma/seed.ts`.
- Store dates in UTC. Do not use server-local `setHours` for day boundaries in new code.
- Tests: provide mocks for `PrismaService` and `JwtService` in `Test.createTestingModule`.
- Build output must be `dist/main.js` (`tsconfig.build.json` includes only `src/`). Keep it that way so `npm run start:prod` works.
