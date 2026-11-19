# Project Flow and Architecture

## Overview

This Flutter application combines live speech transcription, translation, spoken output, and camera-based text translation.

The main capabilities are:

- Live microphone transcription
- Simultaneous interim and final translation
- Spoken translated output
- On-device camera text recognition
- Firebase anonymous authentication
- Firestore translation history
- Deletion of user history and the anonymous account
- Privacy confirmation before microphone or camera use

The application entry point is `lib/main.dart`. The active UI and state management use the newer `TranscriptionBloc` and `TranscriptionScreen` implementation.

## High-Level Architecture

```mermaid
flowchart LR
    User["User"] --> UI["Presentation<br/>Screens and Widgets"]
    UI --> Bloc["TranscriptionBloc"]

    Bloc --> Audio["AudioRecorderService"]
    Bloc --> STT["DeepgramWebSocketEngine"]
    Bloc --> Translation["TranslationRepository"]
    Bloc --> Token["FirebaseDeepgramTokenProvider"]
    Bloc --> TTS["TextToSpeechService"]

    Audio --> Microphone["Device Microphone"]
    STT <-->|16 kHz PCM over WebSocket| Deepgram["Deepgram Nova 3"]
    Token --> Functions["Firebase Cloud Functions"]
    Functions --> DeepgramAuth["Short-Lived Deepgram Token"]
    Translation --> Google["Google Translate"]
    Translation --> Firestore["Cloud Firestore"]
    TTS --> Device["Device Text-to-Speech"]

    UI --> Camera["Camera Translation Screen"]
    Camera --> MLKit["Google ML Kit on Device"]
    Camera --> Google
    Camera --> DeviceCamera["Device Camera"]
```

## Project Structure

```text
lib/
|-- main.dart
|-- Domain/
|   `-- Models/
|       |-- language_config.dart
|       `-- transcript_segment.dart
|-- Data/
|   |-- audio_recorder_service.dart
|   |-- deepgram_token_provider.dart
|   |-- text_to_speech.dart
|   |-- translation_api.dart
|   `-- websocket_transcription_engine.dart
`-- Presentation/
    |-- UI/
    |   |-- transcription_screen.dart
    |   `-- audio_visualizer.dart
    |-- bloc/
    |   |-- transcription_bloc.dart
    |   |-- transcription_event.dart
    |   `-- transcription_state.dart
    |-- camera_translation_screen.dart
    `-- pulsing_mic_animation.dart
```

### Presentation layer

The Presentation layer contains widgets and user interaction logic.

The main [transcription screen](../lib/Presentation/UI/transcription_screen.dart):

- Starts and stops recording
- Pauses and resumes transcription
- Displays interim and finalized transcripts
- Displays translations
- Changes source and target languages
- Enables or disables translated speech
- Opens camera translation
- Deletes user data
- Shows privacy and deletion confirmation dialogs

### Domain layer

The Domain layer contains application models and language definitions.

- `TranscriptionSegment` represents an interim or finalized transcript.
- `LanguageConfig` stores supported source and target languages.

### Data layer

The Data layer contains external integrations and service implementations.

- `AudioRecorderService` captures microphone audio.
- `DeepgramWebSocketEngine` sends audio to Deepgram and receives transcript segments.
- `FirebaseDeepgramTokenProvider` obtains temporary Deepgram credentials.
- `TranslationRepository` translates text and stores successful history.
- `TextToSpeechService` plays translated text.

## Startup Flow

```mermaid
sequenceDiagram
    participant App as Flutter App
    participant Firebase as Firebase
    participant Auth as Firebase Auth
    participant UI as LiveSTTApp
    participant Bloc as TranscriptionBloc

    App->>App: Initialize Flutter bindings
    App->>App: Lock preferred orientation
    App->>Firebase: Initialize Firebase
    Firebase-->>App: Firebase initialized
    App->>Auth: Check current user
    alt No anonymous user
        App->>Auth: Sign in anonymously
        Auth-->>App: Anonymous user
    end
    App->>App: Create repositories and services
    App->>UI: Run application
    UI->>UI: Install repository providers
    UI->>Bloc: Create TranscriptionBloc
    UI->>App: Show TranscriptionScreen
```

Dependencies are created in `main()` and injected using `RepositoryProvider` and `BlocProvider`.

The app follows the system theme and provides a Material 3 light and dark theme.

## Live Speech Translation Flow

```mermaid
flowchart TD
    Start["User starts recording"] --> Consent["Confirm audio processing"]
    Consent --> Permission["Request microphone permission"]
    Permission -->|Denied| Error["Display permission error"]
    Permission -->|Granted| Token["Request short-lived Deepgram token"]
    Token --> Socket["Connect to Deepgram WebSocket"]
    Socket --> Stream["Start 16 kHz mono PCM microphone stream"]

    Stream --> Audio["Capture audio chunk"]
    Audio --> RMS["Calculate waveform level"]
    Audio --> Send["Send PCM chunk to Deepgram"]
    Send --> Segment["Receive Deepgram segment"]

    Segment -->|Interim| Debounce["Wait 300 ms"]
    Debounce --> TranslateInterim["Translate interim text"]
    TranslateInterim --> LiveUI["Display live source and target text"]

    Segment -->|Final| Finalize["Create finalized segment"]
    Finalize --> TranslateFinal["Translate finalized text"]
    TranslateFinal --> History["Save original and translated text"]
    History --> Display["Display completed transcript"]

    Display -->|Speech enabled| PauseMic["Pause microphone"]
    PauseMic --> Speak["Speak translated text"]
    Speak --> ResumeMic["Resume microphone"]
```

### Recording details

The recorder uses:

- 16 kHz sample rate
- 16-bit PCM
- Mono audio

The [audio recorder](../lib/Data/audio_recorder_service.dart) exposes a stream of raw audio chunks through the `AudioStreamRepository` abstraction.

The [Deepgram WebSocket engine](../lib/Data/websocket_transcription_engine.dart):

- Uses Nova 3
- Enables punctuation
- Enables interim results
- Enables smart formatting
- Supports automatic or selected source language
- Sends binary audio chunks
- Sends a close-stream message before disconnecting

### Interim and final processing

Interim transcription text is translated after a 300 ms debounce period. Generation counters prevent stale interim or target-language translation results from updating the UI after the language changes.

Each finalized segment is translated and saved to Firestore. Duplicate segment IDs are tracked so the same final result is not processed twice.

Translation errors are displayed without stopping transcription.

### Microphone feedback prevention

Before speaking a translated result, the BLoC pauses microphone capture. It then:

1. Plays the translated text with `flutter_tts`.
2. Returns from the speech operation.
3. Resumes the microphone when the session was recording.

This prevents the app from transcribing its own spoken translation.

## Camera Translation Flow

```mermaid
flowchart TD
    Open["User opens camera translation"] --> Consent["Confirm camera processing"]
    Consent --> Camera["Initialize back camera"]
    Camera --> Stream["Start live camera frame stream"]
    Stream --> Process["Process frames approximately every 700 ms"]
    Process --> MLKit["Google ML Kit recognizes text"]
    MLKit --> Detect["Update recognized text"]
    Detect --> Stable{"Text unchanged for 1.2 seconds?"}
    Stable -->|No| Stream
    Stable -->|Yes| Stop["Stop image stream"]
    Stop --> Translate["Send recognized text to Google Translate"]
    Translate --> Result["Display translated text"]

    Result --> ScanAgain["Scan again"]
    ScanAgain --> Stream
```

The camera screen supports script-aware recognition:

- Latin
- Chinese
- Devanagari
- Japanese

The user may choose a source language to select the recognition script. If text remains unchanged for approximately 1.2 seconds, recognition stops automatically. The user can also translate immediately or scan again.

Camera images are not uploaded or saved. Recognized text is sent to Google Translate for translation.

## Firebase Credential Flow

```mermaid
sequenceDiagram
    participant User as User
    participant App as Flutter App
    participant Auth as Firebase Auth
    participant Functions as Cloud Functions
    participant Secret as Firebase Secret
    participant Deepgram as Deepgram API

    User->>App: Start recording
    App->>Auth: Verify anonymous user
    App->>Functions: Call getDeepgramToken
    Functions->>Auth: Verify caller authentication
    Functions->>Secret: Read DEEPGRAM_API_KEY
    Secret-->>Functions: Secret API key
    Functions->>Deepgram: POST auth/grant with 30-second TTL
    Deepgram-->>Functions: Short-lived access token
    Functions-->>App: accessToken
    App->>Deepgram: Open Bearer-authenticated WebSocket
```

The Deepgram key remains in Firebase Secrets. It is not stored in the Flutter source or supplied through a Dart define.

## Translation History and Deletion Flow

```mermaid
flowchart LR
    Final["Final transcript"] --> Translate["Google Translate"]
    Translate --> Package["Store original and translated text"]
    Package --> Firestore["Firestore translations collection"]
    Firestore --> Fields["originalText<br/>translatedText<br/>sourceLanguage<br/>targetLanguage<br/>userId<br/>timestamp"]

    Delete["User deletes data"] --> Callable["Call deleteMyData"]
    Callable --> Query["Find translations for anonymous UID"]
    Query --> Batch["Delete Firestore documents"]
    Batch --> Account["Delete Firebase Auth account"]
    Account --> SignIn["Create a new anonymous account"]
```

The deletion action is only available when transcription is not active.

## State Management

### BLoC pattern

The active architecture uses `flutter_bloc`.

```mermaid
flowchart LR
    Widget["Widget"] -->|Dispatches| Event["TranscriptionEvent"]
    Event --> Bloc["TranscriptionBloc"]
    Bloc -->|Updates| State["TranscriptionState"]
    State -->|BlocBuilder / BlocConsumer| Widget
    Bloc --> Services["Data Services"]
    Services --> Bloc
```

Events include:

- `StartTranscriptionRequested`
- `PauseTranscriptionRequested`
- `ResumeTranscriptionRequested`
- `StopTranscriptionRequested`
- `AudioChunkCaptured`
- `SegmentReceived`
- `TranslateInterimTextRequested`
- `LanguageChanged`
- `TargetLanguageChanged`
- `TargetAudioOnlyChanged`

The state contains:

- Current transcription status
- Interim segment
- Interim translation
- Finalized segments
- Translations
- Source and target languages
- Speech playback setting
- Audio visualization levels
- Error message

The state implements `Equatable` so widgets receive predictable state comparisons.

### Transcription status

```mermaid
stateDiagram-v2
    [*] --> Initial
    Initial --> Connecting: Start
    Connecting --> Recording: Connected
    Connecting --> Error: Permission or API error
    Recording --> Paused: Pause
    Recording --> Paused: Speaking translation
    Paused --> Recording: Resume
    Paused --> Recording: Translation speech completes
    Recording --> Completed: Stop
    Paused --> Completed: Stop
    Completed --> Initial: Create a new session
    Error --> Initial: Retry
```

## Architectural Pattern

The project uses a lightweight layered architecture combined with the BLoC pattern:

```text
Presentation
    Screens, widgets, BLoC events and states
          |
          v
Data
    Services, repositories and external integrations
          |
          v
Domain
    Models and shared configuration
```

The architecture uses these patterns:

| Pattern | Usage |
|---|---|
| BLoC | Separates UI events, application logic and immutable state |
| Repository | Abstracts translation and storage operations |
| Service abstraction | Encapsulates audio, TTS and transcription integrations |
| Dependency injection | Uses Flutter providers and constructor injection |
| Stream processing | Connects microphone chunks and WebSocket segments |
| State machine | Controls recording, pausing and connection states |
| Debouncing | Limits interim translation requests |
| Generation counters | Rejects stale async translation results |
| Stable text detection | Stops camera recognition after text stabilizes |
| Privacy confirmation | Requires consent before microphone and camera processing |

## Technologies Used

| Area | Technology |
|---|---|
| Framework | Flutter |
| Language | Dart |
| State management | `flutter_bloc` |
| State comparison | `equatable` |
| Live speech recognition | Deepgram Nova 3 |
| Audio transport | WebSocket |
| Microphone capture | `record` package |
| Translation | `translator` package using Google Translate |
| Text-to-speech | `flutter_tts` |
| Camera | `camera` package |
| On-device OCR | Google ML Kit Text Recognition |
| Authentication | Firebase Anonymous Authentication |
| Database | Cloud Firestore |
| Backend API | Firebase Cloud Functions |
| Theme | Material 3 |
| Platform permissions | Android and iOS app permissions |

## Privacy Characteristics

The app does the following:

- Streams microphone audio to Deepgram for transcription.
- Sends transcript text to Google Translate.
- Saves finalized transcript and translation text in Firestore.
- Uses an anonymous Firebase account.
- Keeps the Deepgram API key in Firebase Secrets.
- Performs camera text recognition on the device.
- Sends only recognized text to Google Translate.
- Does not upload or save camera images.
- Does not explicitly save raw audio recordings.
- Allows the user to delete saved history and the anonymous account.

## Unique Feature Combination

The app's distinctive combination is live speech transcription plus live translation plus translated speech playback and on-device camera OCR.

Important implementation details include:

- Interim speech is translated every 300 ms.
- Microphone capture pauses during translated speech playback.
- Finalized text is saved and can be retranslated after a language change.
- Camera recognition pauses after recognized text stabilizes.
- Recognition scripts can be selected for Latin, Chinese, Devanagari or Japanese text.
- The Deepgram API key is never placed in the Flutter app.
- Firestore history and the anonymous account can be deleted completely.

## Legacy and Alternate Code

The repository contains older or alternate implementations that are not used by the active `main()` entry point:

- `lib/Bloc/translation_bloc.dart`
- `lib/Presentation/translation_screen.dart`
- `lib/Presentation/camera_text_recognition_screen.dart`
- The older `MyApp` implementation in `main.dart`

The active application uses:

- `LiveSTTApp`
- `TranscriptionBloc`
- `TranscriptionScreen`
- `CameraTranslationScreen`

