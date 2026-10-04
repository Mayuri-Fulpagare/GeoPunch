# GeoPunch: Project Status Summary

Last updated: 2026-10-04 (from code scan of `main` @ 2684b11).

GeoPunch is a geo-fenced employee attendance app. Backend: NestJS + Prisma 7 + Neon Postgres. Mobile: Flutter + GetX.

**Overall:** login/signup and check-in work end to end. Check-out, history, leave and profile are only partly done. Backend has no auth enforcement yet.

---

## 1. Backend (`geopunch_api`)

### Endpoints
| Method | Route | Status |
|---|---|---|
| POST | `/api/v1/auth/register` | Works. bcrypt hash, returns JWT + user |
| POST | `/api/v1/auth/login` | Works. 404 unknown email, 401 wrong password |
| POST | `/api/v1/attendance/check-in` | Works. Rejects accuracy > 20m, Haversine vs office radius, blocks double check-in |
| POST | `/api/v1/attendance/check-out` | Coded. Needs `attendanceId`. No geofence/ownership check |
| GET | `/api/v1/attendance/history/:userId?month&year` | Coded. Returns records + totals |

No leave, profile, calendar, holiday, office or admin endpoints. No logout/refresh.

### Database (Prisma)
- `User` (role EMPLOYEE/ADMIN, `deviceId` unused), `OfficeLocation`, `Attendance` (status PRESENT/LATE/ABSENT).
- No Leave/Holiday models. No migrations folder. `seed-office.ts` seeds one office (San Francisco, 200m).
- Env vars needed: `DATABASE_URL`, `DIRECT_URL`, `JWT_SECRET`, `PORT`. No `.env.example`.

### Gaps
- `UsersModule`/`UsersService` empty stubs.
- LATE status never computed. No ABSENT job.
- Tests: only auto-generated boilerplate, no real tests.

---

## 2. Mobile app (`geopunch_app`)

Packages: get, dio, geolocator, flutter_map, latlong2, table_calendar, intl, pdf, printing.

| Screen | Status |
|---|---|
| Splash | UI only |
| Login / Signup | Real API. Token in memory only, no persistence |
| Home (map + swipe punch) | Check-in real. Map office coords hardcoded (Nashik), user marker is a fixed mock point, "Within Range" static. Logout does not clear token |
| Calendar + PDF export | Wired to history API, but `userId` hardcoded `'mock-user-id'`, so real data never shows. Loads before login finishes |
| Leaves | 100% mock, no API, no backend |
| Profile | Shows name/email. Menu items do nothing |

Location service: 3-sample averaging, 20m accuracy filter, mock-GPS detection (returned position then reset to `isMocked:false`).

### Known bugs
- **Check-out is fake.** App never sends `attendanceId` (not stored after check-in). Backend returns 400, app catches it and shows success anyway. Nothing persisted.
- `officeId` hardcoded to a seeded DB value.
- `ApiClient.baseUrl` hardcoded to LAN IP over plain HTTP. No env config.
- Android INTERNET/location permissions not in main manifest (not verified for debug/iOS). Cleartext HTTP blocked on Android 9+ without network config.
- Working-hours timer from design not implemented. Punch state not restored on launch.
- Smoke widget test likely fails (plugins not mocked).

---

## 3. Design (`geopunch design`)
8 PNG mockups only (Form, Dashboard, Home, Welcome, login, map, notification, setting). Notification and settings screens not built.

---

## 4. Security issues (fix before any real use)
1. **No JWT verification.** Tokens signed but never checked. `userId` from body/URL, so anyone can read any user's history, punch for others, or check out any record (IDOR).
2. Client picks `officeId`; server trusts client lat/lon/accuracy. Mock-GPS check is client-side only.
3. Open CORS, no rate limiting, login 404/401 split allows user enumeration.
4. `auth.service.ts` logs emails and password-compare result.
5. No hardcoded secrets found. `.env` gitignored.

---

## 5. Next steps (priority order)
1. Add JWT guard + `JwtStrategy`; take `userId` from token, not request.
2. Fix check-out: store `attendanceId` from check-in, send it, show real errors, no fake success.
3. Fix history: use real `userId` after login, reload on tab open, support month change.
4. Persist token (secure storage); real logout; restore punch state from server.
5. Office-list endpoint; remove hardcoded office ID/coords; live GPS marker + real distance on map.
6. Move base URL to env config; Android permissions + network config; iOS location strings.
7. Leave module (backend models + endpoints, wire Flutter screen), holidays.
8. Profile actions, settings screen, LATE/ABSENT logic, working-hours timer.
9. FCM push notifications.
10. Prisma migrations, `.env.example`, real tests, remove debug logging.
