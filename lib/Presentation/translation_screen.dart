import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transcription_app/Bloc/translation_event.dart';
import 'package:transcription_app/Bloc/translation_state.dart';

import '../Bloc/translation_bloc.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  String sourceLang = "en"; // Default English
  String targetLang = "hi"; // Default Hindi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Universal Audio Translator")),
      body: Column(
        children: [
          // Dropdowns for Selecting Languages (Gujarati, Hindi, English, Spanish, French)
          _buildLanguageSelectors(),

          Expanded(
            child: BlocBuilder<TranslationBloc, TranslationState>(
              builder: (context, state) {
                if (state is TranslationLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TranslationRecording) {
                  return Center(
                    child: Text("Listening...\n${state.partialText}"),
                  );
                } else if (state is TranslationSuccess) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Original: ${state.originalText}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Translated: ${state.translatedText}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  );
                } else if (state is TranslationFailure) {
                  return Center(child: Text("Error: ${state.error}"));
                }
                return Center(
                  child: Text("Hold the mic button and start speaking"),
                );
              },
            ),
          ),

          // Audio Trigger Button
          GestureDetector(
            onLongPressStart: (_) {
              context.read<TranslationBloc>().add(StartListeningEvent());
            },
            onLongPressEnd: (_) {
              context.read<TranslationBloc>().add(
                StopListeningAndTranslateEvent(
                  sourceLang: sourceLang,
                  targetLang: targetLang,
                ),
              );
            },
            child: FloatingActionButton(
              onPressed: () {}, // Handled by LongPress
              child: Icon(Icons.mic),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLanguageSelectors() {
    final languages = context.read<TranslationBloc>().repository.languages;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButton<String>(
          value: sourceLang,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                sourceLang = newValue;
              });
            }
          },
          items: languages.entries.map<DropdownMenuItem<String>>((
            MapEntry<String, String> entry,
          ) {
            return DropdownMenuItem<String>(
              value: entry.value,
              child: Text(entry.key),
            );
          }).toList(),
        ),
        Icon(Icons.arrow_forward),
        DropdownButton<String>(
          value: targetLang,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                targetLang = newValue;
              });
            }
          },
          items: languages.entries.map<DropdownMenuItem<String>>((
            MapEntry<String, String> entry,
          ) {
            return DropdownMenuItem<String>(
              value: entry.value,
              child: Text(entry.key),
            );
          }).toList(),
        ),
      ],
    );
  }
}
