# GeoPunch API

NestJS 11 + Prisma 7 (PostgreSQL via `@prisma/adapter-pg`) REST API for geo-fenced attendance.

## Setup

```bash
npm ci
cp .env.example .env        # fill in DATABASE_URL, DIRECT_URL, JWT_SECRET
npm run db:generate         # generate Prisma client
npm run db:migrate          # apply schema to the database
npm run db:seed             # create the first OfficeLocation, prints its id
npm run start:dev           # http://localhost:3000
```

## Scripts

| Script | Purpose |
|---|---|
| `npm run start:dev` | Watch mode |
| `npm run build` / `start:prod` | Compile to `dist/` and run `dist/main` |
| `npm run lint` / `format` | ESLint (auto-fix) / Prettier |
| `npm test` / `test:e2e` | Unit / e2e tests |
| `npm run db:generate` / `db:migrate` / `db:seed` | Prisma client / migrations / seed |

## Structure

```
src/
  main.ts                 bootstrap (CORS, ValidationPipe)
  app.module.ts           root module
  common/utils/           shared helpers (geo.util.ts: Haversine)
  prisma/                 global PrismaModule + PrismaService
  modules/<feature>/      module, controller, service, dto/, *.spec.ts
prisma/
  schema.prisma           data model
  seed.ts                 seed script
```

## Endpoints (prefix `api/v1`)

| Method | Route |
|---|---|
| POST | `/auth/register` |
| POST | `/auth/login` |
| POST | `/attendance/check-in` |
| POST | `/attendance/check-out` |
| GET | `/attendance/history/:userId?month&year` |

See `../summary.md` for current status and known issues, and `../AGENTS.md` for conventions.
