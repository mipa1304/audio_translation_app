# transcription_app

A new Flutter project.

## Deepgram live transcription

The mobile app gets a short-lived Deepgram token from the authenticated
`getDeepgramToken` Firebase callable function. Never pass a Deepgram API key in
`--dart-define` or bundle it in the app.

The app connects to Deepgram's `/v1/listen` WebSocket when recording starts.
While recording, interim speech is translated into the selected target language
without stopping transcription. Final translations are saved and spoken aloud;
the microphone briefly pauses during speech playback to avoid feeding the
translated audio back into recognition.

Use **Camera translate** to scan text live. Text recognition runs on-device,
the recognized text is translated into the selected language, and the camera
image is not uploaded. The camera screen supports Latin, Chinese, Devanagari,
Japanese, and Korean text recognition. Choose a source language to improve
recognition or leave it on automatic detection. Translation requests time out
with an error message and can be retried instead of loading indefinitely.
Recognition pauses automatically once the detected text is stable; tap
**Translate now** to finish sooner or **Scan again** for another capture.

## Google Play release preparation

Before making a release build:

1. In the Firebase project `translation-1395`, enable Anonymous Authentication
   and Firestore, then set the Deepgram key as a Firebase Functions secret:

   ```powershell
   firebase functions:secrets:set DEEPGRAM_API_KEY
   firebase deploy --only functions
   ```

   Enter the key only at the Firebase prompt. Deploying the functions requires a
   Firebase project with Cloud Functions billing enabled.
   If transcription reports that Deepgram rejected the key, create a valid
   Deepgram API key with Member or higher permissions, then run the secret and
   deploy commands again.
2. Create and securely back up an Android upload keystore. Do not commit it or
   its passwords. On Windows, the `scripts/build-release.ps1` helper loads the
   current user's DPAPI-protected password from
   `%USERPROFILE%\upload-keystore-passwords.dpapi` and uses
   `%USERPROFILE%\upload-keystore.jks`. It creates and removes a temporary
   `android/key.properties` file during the build. Keep the keystore and
   protected password file backed up securely.
3. Create a Google Play Console app using the existing application ID
   `com.mihir.transcription_app`. Application IDs cannot be changed after the
   first Play upload. Enroll in Play App Signing and keep the upload keystore
   backup safe.
4. Replace the contact placeholder in
   [the privacy policy](docs/PRIVACY_POLICY.md), have the policy reviewed, and
   publish it at a stable public HTTPS URL. Enter that URL in Play Console.
5. Build the signed Android App Bundle on Windows:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\build-release.ps1 -Target appbundle
   ```

   The output is `build\app\outputs\bundle\release\app-release.aab`. Release
   builds fail rather than falling back to the debug signing key if upload
   signing is not configured. To build a signed APK instead, run
   `powershell -ExecutionPolicy Bypass -File .\scripts\build-release.ps1 -Target apk`;
   the output is
   `build\app\outputs\flutter-apk\app-release.apk`.
6. In Play Console, complete the Data safety form, app access instructions,
   content rating, target audience, store listing, screenshots, and internal
   testing. Explain that the app uses anonymous sign-in, requests microphone
   and camera access, streams audio to Deepgram, sends text to the translation
   provider, and stores finalized transcript/translation text in Firebase.

The Android target SDK is API 36. Review Play Console's current policy
deadlines, test the uploaded bundle on real devices, and increment the version
in `pubspec.yaml` for every subsequent release. The release build cannot be
signed or uploaded until the publisher creates and configures their own upload
keystore.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
