import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'firebase_options.dart';
import 'Data/audio_recorder_service.dart';
import 'Data/deepgram_token_provider.dart';
import 'Data/text_to_speech.dart';
import 'Data/translation_api.dart';
import 'Data/websocket_transcription_engine.dart';
import 'Presentation/bloc/transcription_bloc.dart';
import 'Presentation/UI/transcription_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Force portrait orientation for consistent UI streaming
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 2. Initialize Firebase Services
  // Ensure you've run `flutterfire configure` to generate firebase_options.dart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode && const bool.fromEnvironment('USE_FIREBASE_EMULATORS')) {
    const emulatorHost = String.fromEnvironment(
      'FIREBASE_EMULATOR_HOST',
      defaultValue: '10.0.2.2',
    );
    FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
    FirebaseFunctions.instanceFor(
      region: 'us-central1',
    ).useFunctionsEmulator(emulatorHost, 5001);
    debugPrint('Using Firebase emulators at $emulatorHost');
  }

  try {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
  } on FirebaseAuthException catch (error) {
    // The app can open without auth, but Firestore writes stay protected until
    // Anonymous sign-in is enabled in the Firebase console.
    debugPrint('Firebase anonymous sign-in failed: ${error.code}');
  }

  // 3. Dependency Injection Instantiations
  final audioRepository = AudioRecorderService();
  final transcriptionEngine = DeepgramWebSocketEngine();
  final translationRepository = TranslationRepository();
  final textToSpeechService = TextToSpeechService();

  runApp(
    LiveSTTApp(
      audioRepository: audioRepository,
      transcriptionEngine: transcriptionEngine,
      translationRepository: translationRepository,
      textToSpeechService: textToSpeechService,
    ),
  );
}

class LiveSTTApp extends StatelessWidget {
  final AudioStreamRepository audioRepository;
  final TranscriptionEngine transcriptionEngine;
  final TranslationRepository translationRepository;
  final TextToSpeechService textToSpeechService;

  const LiveSTTApp({
    super.key,
    required this.audioRepository,
    required this.transcriptionEngine,
    required this.translationRepository,
    required this.textToSpeechService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AudioStreamRepository>.value(value: audioRepository),
        RepositoryProvider<TranscriptionEngine>.value(
          value: transcriptionEngine,
        ),
        RepositoryProvider<TranslationRepository>.value(
          value: translationRepository,
        ),
      ],
      child: BlocProvider<TranscriptionBloc>(
        create: (context) => TranscriptionBloc(
          audioRepository: context.read<AudioStreamRepository>(),
          transcriptionEngine: context.read<TranscriptionEngine>(),
          translationRepository: translationRepository,
          textToSpeechService: textToSpeechService,
          deepgramTokenProvider: FirebaseDeepgramTokenProvider(),
        ),
        child: MaterialApp(
          title: 'Live Audio Translator',
          debugShowCheckedModeBanner: false,

          // Material 3 Dynamic Light Theme
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6750A4),
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 2,
            ),
          ),

          // Material 3 Dynamic Dark Theme
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFD0BCFF),
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 2,
            ),
          ),

          themeMode: ThemeMode.system,
          home: const TranscriptionScreen(),
        ),
      ),
    );
  }
}

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:transcription_app/Data/text_to_speech.dart';
// import 'package:transcription_app/firebase_options.dart';
// import 'package:transcription_app/Data/translation_api.dart';
// import 'package:transcription_app/Bloc/translation_bloc.dart';
// import 'package:transcription_app/Presentation/translation_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Transcription App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: BlocProvider(
//         create: (context) => TranslationBloc(
//           TranslationRepository(),
//           TextToSpeechService(),
//         ),
//         child: TranslationScreen(),
//       ),
//     );
//   }
// }
