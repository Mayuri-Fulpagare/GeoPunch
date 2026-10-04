# GeoPunch

Geo-fenced employee attendance. Employees check in and out from a mobile app; the server verifies they are inside the office radius (Haversine distance) with good GPS accuracy.

| Part | Path | Stack |
|---|---|---|
| API | [`geopunch_api`](geopunch_api) | NestJS 11, Prisma 7, PostgreSQL (Neon), JWT |
| Mobile app | [`geopunch_app`](geopunch_app) | Flutter, GetX, Dio, Geolocator, flutter_map |
| Design | [`geopunch design`](<geopunch design>) | PNG mockups |

## Quick start

```bash
# API
cd geopunch_api
npm ci && cp .env.example .env     # fill in values
npm run db:generate && npm run db:migrate && npm run db:seed
npm run start:dev

# App (second terminal)
cd geopunch_app
flutter pub get && flutter run
```

## Docs

- [`summary.md`](summary.md): current status, known bugs, security gaps, next steps
- [`AGENTS.md`](AGENTS.md): conventions and rules for contributors and AI agents
