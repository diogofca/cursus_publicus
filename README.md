# Letters

A private letters app for two people. One account writes weekly letters
(text, a few photos, a Spotify link) and schedules when each becomes
visible; the other account reads them in a feed, newest first. Built with
Flutter (iOS, Android, and Web) and Firebase — on Firebase's **free Spark
plan**, no billing account needed.

## Why no file attachments, and why photos are limited

Cloud Storage for Firebase now requires the paid Blaze plan, even at zero
usage — it's no longer available on the free Spark plan. To keep this app
fully free, it doesn't use Firebase Storage at all: photos are compressed
on-device and embedded directly in the Firestore document as base64, and
general file attachments aren't supported (there's nowhere free to put
them). Firestore caps a document at 1 MiB, so letters are limited to 3
photos with a combined raw size budget of 550 KB (see `lib/constants.dart`)
— comfortably under that cap even after base64's ~33% overhead.

## Firebase setup

This repo does **not** include any Firebase project config — it's public on
GitHub, and that config identifies which backend project the app talks to.
You'll generate it locally; it's gitignored (see `.gitignore`) and never
committed. The real access control lives in `firestore.rules`, which *is*
committed since it contains no secrets.

1. **Create the Firebase project.** Go to
   [console.firebase.google.com](https://console.firebase.google.com) →
   "Add project" → give it a name → disable Google Analytics (not needed) →
   Create. Leave it on the default **Spark (free)** plan — nothing in this
   app needs Blaze.

2. **Enable Email/Password auth and create the two accounts.**
   Console → Build → Authentication → Get started → Sign-in method tab →
   enable "Email/Password".
   Then Authentication → Users tab → "Add user" twice: one account for you
   (the author), one for her (the recipient). Pick strong passwords. After
   creating each, copy its **UID** — you'll need both in step 5.

3. **Enable Firestore.** Console → Build → Firestore Database → Create
   database → pick a region → **start in production mode** (safe default:
   everything is denied until you deploy the rules in step 5). Firestore is
   fully available on Spark, with a generous free daily quota.

4. **Generate the app's Firebase config.**
   ```
   dart pub global activate flutterfire_cli
   firebase login
   flutterfire configure --project=<your-firebase-project-id> --platforms=ios,android,web
   ```
   This writes `lib/firebase_options.dart`, `android/app/google-services.json`,
   and `ios/Runner/GoogleService-Info.plist` — all gitignored. It may also
   touch `android/app/build.gradle.kts` / `ios/Runner/Info.plist` to wire up
   the Firebase plugin; those *are* safe to commit (no secrets, just plugin
   config).

5. **Fill in the two UIDs and deploy the security rules.**
   - Open `lib/constants.dart` and set `kAuthorUid` / `kRecipientUid` to the
     two UIDs from step 2.
   - Open `firestore.rules` and replace `AUTHOR_UID_HERE` /
     `RECIPIENT_UID_HERE` the same way.
   - Then, from the repo root:
     ```
     firebase use --add          # pick your project
     firebase deploy --only firestore:rules
     ```

6. **Run it.**
   ```
   flutter pub get
   flutter run -d chrome      # or an iOS simulator / Android emulator
   ```

## Notes

- No self-signup — the two accounts are created directly in the Firebase
  console. There's no "forgot password" flow either; reset a password from
  the console if needed.
- Firestore rules restrict the recipient to letters whose `visibleAt` has
  already passed; the author can always see everything, including
  future-scheduled letters (shown with a "Scheduled" badge).
