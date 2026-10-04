---
name: add-flutter-feature
description: Scaffold a new feature in geopunch_app (GetX controller, screen, model, API call) in the feature-first layout. Use when adding a screen, tab or flow such as notifications or settings.
---

# Add a Flutter feature

Input: feature name `<feature>` (snake_case, e.g. `notifications`).

1. Create `geopunch_app/lib/features/<feature>/` with only the folders needed:
   - `controllers/<feature>_controller.dart`: `GetxController`, state as `.obs`, loading and error state, calls `ApiClient` from `package:geopunch_app/core/network/api_client.dart`
   - `screens/<feature>_screen.dart`: UI only, reads the controller, wraps the smallest subtree in `Obx`
   - `models/<name>_model.dart`: plain class with `fromJson` (see `features/history/models/attendance_history_model.dart`)
   - `services/`: only for feature-specific helpers (see `features/history/services/pdf_export_service.dart`)
2. Colors from `AppColors` (`core/constants/app_colors.dart`), theme from `core/theme/app_theme.dart`. Reuse `core/widgets/` before adding widgets. Move a widget to `core/widgets/` once two features use it.
3. Navigation: `Get.to(() => const <Feature>Screen())`, or add a tab in the `IndexedStack` of `features/attendance/screens/attendance_screen.dart`.
4. Errors: show the server message, never report success from a `catch`.
5. If it needs a new API endpoint, run the `add-api-module` skill first and match its DTOs.
6. Add a widget or controller test under `geopunch_app/test/` mirroring the `lib/` path.
7. New permissions go in both `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist`.
8. Run the `pre-commit-check` skill. Update `geopunch_app/README.md` structure if you add a new feature folder, and `summary.md` status.

Imports always use `package:geopunch_app/...`.
