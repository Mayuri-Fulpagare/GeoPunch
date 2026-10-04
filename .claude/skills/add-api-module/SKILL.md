---
name: add-api-module
description: Scaffold a new NestJS feature module in geopunch_api (module, controller, service, DTOs, spec) in the project's feature-modular layout. Use when adding a new API feature or endpoint group such as leave, profile or office.
---

# Add an API module

Input: feature name `<feature>` (singular, kebab-case, e.g. `leave`).

1. Create `geopunch_api/src/modules/<feature>/` with:
   - `<feature>.module.ts`: `@Module({ controllers: [<Feature>Controller], providers: [<Feature>Service] })`
   - `<feature>.controller.ts`: `@Controller('api/v1/<feature>')`, thin handlers that call the service
   - `<feature>.service.ts`: inject `PrismaService` from `../../prisma/prisma.service` (module is global, no import needed in the module file)
   - `dto/<name>.dto.ts`: one class per request body, class-validator decorator on every field
   - `<feature>.service.spec.ts` and `<feature>.controller.spec.ts`: mock `PrismaService` (and `JwtService` if used)
2. Register `<Feature>Module` in `src/app.module.ts` `imports`.
3. Protect every route with the JWT guard (exists once auth guard work lands; until then add a `// TODO(auth)` and note it in `summary.md`). Take `userId` from the token, never from body or URL.
4. If a DB model is needed, run the `add-prisma-change` skill first.
5. Look at `src/modules/attendance/` as the reference for file shape and import paths.
6. Run the `pre-commit-check` skill. Add the new routes to the endpoint table in `geopunch_api/README.md`.

Do not: put business logic in the controller, call Prisma from the controller, return Prisma entities containing `passwordHash`, or use `console.log`.
