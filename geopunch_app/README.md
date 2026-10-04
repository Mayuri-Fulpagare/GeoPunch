# GeoPunch App

Flutter (Dart ^3.9) mobile app for geo-fenced attendance. Targets Android and iOS. State and navigation via GetX, HTTP via Dio, GPS via Geolocator, maps via flutter_map.

## Run

```bash
flutter pub get
flutter run
```

The API base URL is currently hardcoded in `lib/core/network/api_client.dart`. Point it at your running `geopunch_api` (use your machine's LAN IP for a physical device).

## Structure

```
lib/
  main.dart
  core/                    shared, feature-independent code
    constants/             app_colors.dart
    theme/                 app_theme.dart
    network/               api_client.dart (single Dio instance + token)
    services/              location_service.dart (GPS, accuracy, mock detection)
    widgets/               reusable widgets (swipe_button.dart)
  features/<feature>/      auth, attendance, history, leaves, profile
    controllers/           GetX controllers
    screens/               full-page widgets
    models/                data classes (when needed)
    services/              feature-specific helpers (when needed)
```

Import with `package:geopunch_app/...`. See `../AGENTS.md` for conventions and `../summary.md` for status.
