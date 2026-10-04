---
paths:
  - "geopunch_app/**"
---

# Flutter rules

## Where things go

| Adding | Put it in |
|---|---|
| New feature | `lib/features/<feature>/` (use the `add-flutter-feature` skill) |
| Screen | `lib/features/<feature>/screens/<name>_screen.dart` |
| GetX controller | `lib/features/<feature>/controllers/<name>_controller.dart` |
| API response model | `lib/features/<feature>/models/` with `fromJson` |
| Reusable widget (used by 2+ features) | `lib/core/widgets/` |
| Colors / theme | `lib/core/constants/app_colors.dart`, `lib/core/theme/app_theme.dart` |
| HTTP | only via `lib/core/network/api_client.dart` |
| GPS | only via `lib/core/services/location_service.dart` |

## Rules

- Import with `package:geopunch_app/...`.
- Screens are UI only. API calls and state live in the feature's GetX controller. Expose state as `.obs` and wrap the smallest subtree in `Obx`.
- Create controllers (`Get.put` / `Get.lazyPut`) in the screen or binding that owns them. Do not build a controller that needs login state before login completes.
- Errors: show the real server message. Never show a success message from a `catch` block.
- No hardcoded API URLs, office ids, coordinates, user ids or colors in screens or controllers.
- Keep Android manifest and iOS `Info.plist` permission entries in sync when adding sensors or network access.
- Run `flutter analyze` and `flutter test` before commit. Fix lints, do not suppress them.
- Targets are Android and iOS. Do not re-add desktop or web platform folders.
