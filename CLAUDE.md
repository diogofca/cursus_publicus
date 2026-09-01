# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Cursus Publicus is a private, two-person letters app: one account (the author) writes letters and schedules when they become visible; the other account (the recipient) reads them in a feed, newest first. Flutter app targeting iOS, Android, and Web, backed by Firebase (Auth + Firestore only — deliberately no Cloud Storage, see below). Dart/Flutter SDK constraint is bleeding-edge (`sdk: ^3.12.2` in `pubspec.yaml`).

## Commands

```
flutter pub get                          # install deps
flutter analyze                          # lint/typecheck — keep this clean before considering work done
flutter run -d chrome                    # run on web
flutter run -d <device-id>               # run on a specific simulator/emulator/device (see `flutter devices`)
flutter build web --release              # production web build, output to build/web
firebase deploy --only hosting           # deploy build/web to Firebase Hosting (after the build above)
firebase deploy --only firestore:rules   # deploy firestore.rules after editing it
flutterfire configure --platforms=ios,android,web   # regenerate lib/firebase_options.dart + platform config
```

There are currently no tests in the repo (the default `flutter_test` counter-demo test was removed since it no longer matched the app and would require Firebase to be initialized to even build the widget tree). If you add tests, `flutter test` is the standard entry point.

`build/` is gitignored and gets polluted by `flutter analyze`/`flutter build` with Swift Package Manager `SourcePackages` checkouts (from Firebase's iOS/macOS SPM dependencies) that include their own test fixtures — these are excluded via `analyzer: exclude: [build/**]` in `analysis_options.yaml`. If `flutter analyze` ever reports thousands of unrelated errors from `build/macos/SourcePackages/...`, that exclude was removed or `rm -rf build/` and retry.

## Architecture

`lib/` is layered by responsibility, all flat directories (no feature-folders):

- `models/` — `Letter` (the only real data model; Firestore (de)serialization via `fromFirestore`/`toMap`).
- `services/` — thin wrappers around Firebase SDKs: `AuthService` (FirebaseAuth), `LettersRepository` (Firestore CRUD/streams), `SpotifyService` (oEmbed HTTP fetch, no API key).
- `providers/` — Riverpod providers wrapping the services above (`authStateProvider`, `visibleLettersProvider`, `allLettersProvider`, etc.).
- `screens/` — one widget per route: `LoginScreen`, `RecipientFeedScreen`, `AuthorConsoleScreen`, `ComposeLetterScreen`, `LetterDetailScreen`.
- `widgets/` — shared UI: `LetterListView`/`LetterCard` (used by both the recipient feed and the author's "My Letters" list), `SpotifyPreviewCard`.
- `constants.dart` — `kAuthorUid`/`kRecipientUid` (the two hardcoded account UIDs the whole app's access control keys off of), `kMaxImagesPerLetter`/`kMaxTotalImageBytes` (see below), `kAppName`.
- `theme.dart` — `AppTheme` color tokens.

**Routing**: no router package. `main.dart`'s `AuthGate` (`ConsumerWidget`) watches `authStateProvider` and picks the screen directly: signed out → `LoginScreen`; signed-in UID matches `kAuthorUid` → `AuthorConsoleScreen`; matches `kRecipientUid` → `RecipientFeedScreen`; anything else → an "unknown account" fallback. Within a screen, plain `Navigator.push`/`MaterialPageRoute`, except `LetterDetailScreen.route()` which is a custom `PageRouteBuilder` paired with a `Hero` (tag `letter-${id}`) on the originating `LetterCard` for the "opening a letter" transition.

**No Cloud Storage — this is the load-bearing architectural decision.** Firebase Storage now requires the paid Blaze plan even at zero usage, and this app intentionally stays on the free Spark plan. Consequences that aren't obvious from any single file:
- There are no file attachments, only up to `kMaxImagesPerLetter` (3) photos per letter.
- Photos are compressed at pick time (`image_picker` with `imageQuality`/`maxWidth`/`maxHeight`) and stored as base64 strings directly on the `Letter.images` field in Firestore, rendered back with `Image.memory(base64Decode(...))`. `kMaxTotalImageBytes` (550 KB raw, pre-base64) keeps documents under Firestore's 1 MiB cap after base64's ~33% overhead.
- If Storage is ever reintroduced, it needs the Blaze plan — that's a deliberate tradeoff to revisit explicitly, not a gap to silently "fix".

**Access control is two hardcoded UIDs, not a roles system.** `kAuthorUid`/`kRecipientUid` in `constants.dart` and the identical constants embedded in `firestore.rules` (`AUTHOR_UID_HERE`/`RECIPIENT_UID_HERE` placeholders, filled in locally, not committed with real values) both gate access — the recipient can only read Firestore docs where `visibleAt <= now`, the author can read/write everything. There's no signup flow; both accounts are created manually in the Firebase console.

**Firebase config files are gitignored** (`lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`) since the repo is public — `lib/firebase_options.example.dart` is the committed placeholder template. `firebase.json`, `firestore.rules`, and `storage`-free hosting config *are* committed; none of that is secret (project/app IDs and even the web API key aren't sufficient for data access — Firestore rules are the actual boundary). Full setup steps are in `README.md`.

**State management is Riverpod**, not Provider or bare `setState` — new async/stream-backed state should go through a provider in `lib/providers/`, following the existing `StreamProvider`/`Provider` pattern rather than `StatefulWidget` + manual subscriptions.
