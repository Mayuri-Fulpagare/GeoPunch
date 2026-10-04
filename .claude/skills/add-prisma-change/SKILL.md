---
name: add-prisma-change
description: Change the Prisma data model in geopunch_api (new model, field, enum or relation) with a migration, regenerated client and updated seed/DTOs. Use whenever schema.prisma changes.
---

# Change the Prisma schema

Config: Prisma 7. Schema `geopunch_api/prisma/schema.prisma`, connection in `prisma.config.ts` (`DIRECT_URL` falling back to `DATABASE_URL`). Runtime client uses `@prisma/adapter-pg`.

1. Edit `prisma/schema.prisma`. Follow existing style: `id String @id @default(uuid())`, `createdAt`/`updatedAt`, enums in PascalCase with UPPER values, relations with explicit `userId`-style fields.
2. `cd geopunch_api && npx prisma validate`.
3. Create the migration against a dev database: `npm run db:migrate -- --name <short_snake_case>`. Commit the generated `prisma/migrations/` folder. Never edit an applied migration.
4. `npm run db:generate`.
5. Update dependents: DTOs in `src/modules/<feature>/dto/`, services using the model, `prisma/seed.ts` if seed data is affected.
6. Destructive changes (drop column/table, type change on existing data): stop and ask the user, describe the data loss risk.
7. Run the `pre-commit-check` skill.

Never put real connection strings in the repo. New env vars go in `.env.example`.
