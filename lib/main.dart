import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'data/audio_recorder_service.dart';
import 'data/text_to_speech.dart';
import 'data/translation_api.dart';
import 'data/websocket_transcription_engine.dart';
import 'presentation/bloc/transcription_bloc.dart';
import 'presentation/ui/transcription_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Force portrait orientation for consistent UI streaming
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 2. Initialize Firebase Services
  // Ensure you've run `flutterfire configure` to generate firebase_options.dart
  await Firebase.initializeApp();

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
      ],
      child: BlocProvider<TranscriptionBloc>(
        create: (context) => TranscriptionBloc(
          audioRepository: context.read<AudioStreamRepository>(),
          transcriptionEngine: context.read<TranscriptionEngine>(),
          translationRepository: translationRepository,
          textToSpeechService: textToSpeechService,
        ),
        child: MaterialApp(
          title: 'OmniScribe Live STT',
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
