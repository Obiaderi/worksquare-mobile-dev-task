# Worksquare Housing

A responsive Flutter property listings app with filtering, search, favorites, and a polished UI across mobile, tablet, and desktop breakpoints.

## Setup And Run
- Prerequisites: Flutter SDK (`sdk: ^3.9.2`), Xcode for iOS, Android SDK for Android
- Install dependencies: `flutter pub get`
- iOS:
  - Minimum deployment target: iOS 14.0 (configured in `ios/Podfile` and `ios/Flutter/AppFrameworkInfo.plist`)
  - Open workspace: `open ios/Runner.xcworkspace`
  - Run: `flutter run -d <ios_device>` or from Xcode
- Android:
  - Run: `flutter run -d <android_device>`
- Web/Desktop (if enabled in your Flutter toolchain): `flutter run -d chrome` or platform-specific devices
- Data asset: ensure `assets/listings.json` exists (declared in `pubspec.yaml`)

## Tools And Libraries
- Navigation: custom router via `AppRouter` and route constants (`RoutePath`) using `Navigator.pushNamed`
- State management: `provider` for `PropertyProvider` (listings, filters, layout, favorites)
- UI responsiveness: `flutter_screenutil` for adaptive sizing and spacing
- Images: `cached_network_image` for efficient thumbnail loading and caching
- Currency/formatting: `intl`
- Maps: `flutter_map` + `latlong2` rendering OpenStreetMap tiles (no API key required)
- Persistence: `shared_preferences` to store favorite listing IDs

## Approach And Thought Process
- Data loading: reads `assets/listings.json` and robustly maps fields to `PropertyModel`. Fallback data generation is used if JSON is missing or malformed.
- Layout: `CustomScrollView` with slivers for virtualization and performance; switches between grid and list based on screen width and a UI toggle.
- Filters and search: Provider-centric state with location/type/price filters and full-text search over core attributes.
- Accessibility: semantics on interactive controls (favorite buttons, clear filters), keyboard-focusable buttons, adequate contrast and touch targets.
- Performance: virtualization (`SliverGrid`, `SliverList`), lightweight animations, cached images, and efficient set operations for favorites.
- UX polish: animated splash, modern details screen with sliver header, map section, chips, and clear feedback for actions.

## Limitations And Trade‑offs
- JSON schema normalization: the loader infers `city`/`neighborhood` and parses prices; for strict schemas, a DTO or validation step could be added.
- Favorites storage: `shared_preferences` is simple but not ideal for very large datasets; consider Hive/SQLite for richer offline features.
- iOS build tooling: project currently shows a guidance message about migrating CocoaPods integration to Swift Package Manager; the app builds fine, but migration can improve build times.
- Maps: default OSM tiles have usage limits; for high-traffic scenarios, configure a tile provider (e.g., MapTiler) and add an API key.
- Animations: UI uses lightweight transitions; dedicated shimmer/advanced animations can be added if desired.

## Where And How AI Was Used
- Assisted in planning features, implementing UI components, resolving layout errors, and refactoring.
- Automated code edits: wiring `flutter_map`, favorites with `shared_preferences`, robust JSON parsing, dropdown fixes, and sliver-based layout.
- Continuous verification: analyzer runs and widget tests updated to ensure stability and performance.

## Scripts And Commands
- Analyze and test: `flutter analyze && flutter test -r compact`
- Run iOS no‑codesign build: `flutter build ios --no-codesign`
- Run the app: `flutter run`

## Project Structure Highlights
- `lib/features/property/` models, repository, provider
- `lib/ui/listings/` screens and widgets (grid/list, details, cards)
- `lib/ui/` app scaffolding (bottom navigation, splash)
- `lib/core/` theme, routes, utilities

