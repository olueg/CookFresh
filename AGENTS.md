# CookFresh

Native SwiftUI app (iOS, iPadOS, macOS, visionOS) for recipe management and an AI kitchen assistant. Swift 5.0 language mode, deployment target 27.2, Xcode 27+.

## Build

```sh
xcodebuild -project CookFresh.xcodeproj -scheme CookFresh -destination 'platform=macOS' build
```

- No test targets exist; build success is the verification step.
- No third-party packages/SPM dependencies.
- Project file is `CookFresh.xcodeproj/project.xcproj` (JSON/Xcode 27 format), not a classic `.pbxproj`.

## Architecture

- Entry point: `CookFresh/CookFreshApp.swift` — `WindowGroup` hosts `RootView`, plus a separate `Settings` scene hosting `SettingsView`.
- Data: SwiftData. `ModelContainer` schema: `ChatMessage`, `ChatSession`, `GeminiServiceModel` (see `CookFreshApp.swift`).
- Concurrency: `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` and approachable concurrency are enabled. SwiftUI views and `@Observable` services are MainActor by default; keep async work in `Task`/`.task`.
- Localization via `CookFresh/Localizable.xcstrings` (string catalog, symbol generation on). Scheme launch language is German (`de`).

## Conventions

- Program Apple-conformant: follow Apple Developer documentation and standard SwiftUI/macOS patterns. No experimental workarounds or hallucinated APIs.
- Explain every change and its rationale before applying it.

## Gotchas

- App sandbox is enabled (`ENABLE_APP_SANDBOX = YES`) with outgoing network allowed; Gemini calls need that entitlement.
- `ENABLE_USER_SELECTED_FILES = readonly` — file access is read-only.
- macOS Settings window is a separate scene; changes there persist via `@AppStorage` (e.g. `gemini_api_key`, `FreshCookModel`).
- `STRING_CATALOG_GENERATE_SYMBOLS = YES` — localized keys get generated symbols; keep catalog in sync.