# Privacy Policy — Live Audio Translator

**Draft for publisher review.** Replace the contact placeholder and publish
this document at a stable public HTTPS URL before submitting the app to Google
Play. Confirm that these disclosures match the deployed Firebase and Deepgram
project settings.

**Effective date:** 9 October 2026

## Information processed

When you start a transcription, the app streams microphone audio to Deepgram
over an encrypted connection to produce a transcript. The app does not save an
audio recording to its own storage. The transcript and translated text are
sent to Google Translate to produce translations.

Finalized transcript and translation text, language selections, a Firebase
anonymous user identifier, and a server timestamp are stored in Firebase
Cloud Firestore as translation history. Camera text recognition is performed
on the device. While the camera translation feature is open, recognized text
is sent to Google Translate for live translation. The app does not upload
camera images for recognition.

The app uses Firebase Anonymous Authentication to associate stored history
with an anonymous app account. It does not request your name, email address,
contacts, or location.

## How information is used and shared

Audio is processed by Deepgram for speech recognition. Transcript text and
text recognized by the camera are sent to Google Translate for translation.
Translation history is stored by Google Firebase. These providers process
information under their own terms and privacy policies. The app publisher does
not sell personal information.

## Retention and deletion

Translation history remains in Firebase until you use **Delete my data** in the
app. That action deletes the history associated with the current anonymous
account and deletes that account. A new anonymous account is created so you can
continue using the app. Provider-side processing and retention are governed by
the providers' terms and settings.

## Permissions

Microphone access is used only when you start transcription. Camera access is
used for on-device text recognition when you choose the camera feature. You can
deny either permission; the related feature will not work without it.

## Security

Connections to Deepgram and Firebase use encrypted network transport. The app
requests short-lived Deepgram access tokens from an authenticated Firebase
function; the long-lived Deepgram API key is kept in Firebase Functions
secrets, not in the app bundle.

## Contact

For privacy questions or requests, contact: **[Replace with publisher privacy
contact email]**.
