import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transcription_app/Bloc/translation_event.dart';
import 'package:transcription_app/Bloc/translation_state.dart';
import 'package:transcription_app/Presentation/pulsing_mic_animation.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Universal Audio Translator"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.8),
              theme.colorScheme.secondary.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildLanguageSelectors(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: BlocBuilder<TranslationBloc, TranslationState>(
                      builder: (context, state) {
                        // Unique key for each state to trigger AnimatedSwitcher
                        if (state is TranslationInitial) {
                          return _buildInitialUI(theme);
                        } else if (state is TranslationLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        } else if (state is TranslationRecording) {
                          return _buildListeningUI(state, theme);
                        } else if (state is TranslationConversationInProgress) {
                          return _buildConversationUI(state, theme);
                        } else if (state is TranslationSuccess) {
                          return _buildSuccessUI(state, theme);
                        } else if (state is TranslationFailure) {
                          return _buildErrorUI(state, theme);
                        }
                        return _buildInitialUI(theme);
                      },
                    ),
                  ),
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialUI(ThemeData theme) {
    return Center(
      key: const ValueKey('initial'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.translate, size: 80, color: Colors.white70),
          const SizedBox(height: 20),
          Text(
            "Tap the mic to start translating",
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildListeningUI(TranslationRecording state, ThemeData theme) {
    return Center(
      key: const ValueKey('listening'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PulsingMicAnimation(),
          const SizedBox(height: 20),
          Text(
            "Listening...",
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            state.partialText,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelectors() {
    // For a real app, this should come from your TranslationRepository
    final languages = _getLanguages();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLanguageDropdown(languages, sourceLang, (newValue) {
              if (newValue != null && newValue != targetLang) {
                setState(() => sourceLang = newValue);
              }
            }),
            IconButton(
              icon: const Icon(Icons.swap_horiz, color: Colors.deepPurple),
              onPressed: () {
                setState(() {
                  final temp = sourceLang;
                  sourceLang = targetLang;
                  targetLang = temp;
                });
              },
            ),
            _buildLanguageDropdown(languages, targetLang, (newValue) {
              if (newValue != null && newValue != sourceLang) {
                setState(() => targetLang = newValue);
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(
    Map<String, String> languages,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      underline: const SizedBox.shrink(),
      items: languages.entries.map<DropdownMenuItem<String>>((entry) {
        return DropdownMenuItem<String>(
          value: entry.value,
          child: Text(entry.key),
        );
      }).toList(),
    );
  }

  Widget _buildConversationUI(
    TranslationConversationInProgress state,
    ThemeData theme,
  ) {
    return Column(
      key: const ValueKey('conversation'),
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: state.history.length,
            itemBuilder: (context, index) {
              final turn = state.history.reversed.toList()[index];
              final isPerson1 = turn.person == 1;
              return _buildChatItem(
                turn.originalText,
                turn.translatedText,
                isPerson1,
                theme,
              );
            },
          ),
        ),
        if (state.partialText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Listening: ${state.partialText}",
              style: const TextStyle(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildChatItem(
    String original,
    String translated,
    bool isPerson1,
    ThemeData theme,
  ) {
    return Align(
      alignment: isPerson1 ? Alignment.centerLeft : Alignment.centerRight,
      child: Card(
        color: isPerson1
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.secondaryContainer,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isPerson1
                ? const Radius.circular(4)
                : const Radius.circular(16),
            bottomRight: isPerson1
                ? const Radius.circular(16)
                : const Radius.circular(4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(original, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                translated,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessUI(TranslationSuccess state, ThemeData theme) {
    return Card(
      key: const ValueKey('success'),
      color: Colors.white.withOpacity(0.9),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Original:",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Text(
              state.originalText,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              "Translated:",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    state.translatedText,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.volume_up, color: theme.colorScheme.primary),
                  iconSize: 30,
                  onPressed: () {
                    context.read<TranslationBloc>().add(
                      SpeakTranslatedTextEvent(
                        state.translatedText,
                        targetLang,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorUI(TranslationFailure state, ThemeData theme) {
    return Center(
      key: const ValueKey('error'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
          const SizedBox(height: 16),
          Text(
            "An Error Occurred",
            style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            state.error,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return BlocBuilder<TranslationBloc, TranslationState>(
      builder: (context, state) {
        final isListening =
            state is TranslationRecording ||
            state is TranslationConversationInProgress;
        final isConversationMode = state is TranslationConversationInProgress;

        return Padding(
          padding: const EdgeInsets.only(bottom: 40.0, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Single Translation Button
              FloatingActionButton(
                heroTag: 'mic_button',
                tooltip: 'Single Translation',
                onPressed: () {
                  if (isListening && !isConversationMode) {
                    context.read<TranslationBloc>().add(StopListeningEvent());
                  } else {
                    context.read<TranslationBloc>().add(
                      StartListeningEvent(
                        sourceLang: sourceLang,
                        targetLang: targetLang,
                      ),
                    );
                  }
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isListening && !isConversationMode ? Icons.stop : Icons.mic,
                    key: ValueKey<bool>(isListening && !isConversationMode),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Conversation Mode Button
              FloatingActionButton(
                heroTag: 'conversation_button',
                tooltip: 'Conversation Mode',
                onPressed: () {
                  if (isConversationMode) {
                    context.read<TranslationBloc>().add(
                      StopConversationEvent(),
                    );
                  } else {
                    context.read<TranslationBloc>().add(
                      StartConversationEvent(
                        lang1: sourceLang,
                        lang2: targetLang,
                      ),
                    );
                  }
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isConversationMode
                        ? Icons.stop_circle_outlined
                        : Icons.people,
                    key: ValueKey<bool>(isConversationMode),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, String> _getLanguages() {
    // In a real app, this should be part of your TranslationRepository or a config file.
    return {
      'Afrikaans': 'af',
      'Albanian': 'sq',
      'Amharic': 'am',
      'Arabic': 'ar',
      'Armenian': 'hy',
      'Azerbaijani': 'az',
      'Basque': 'eu',
      'Belarusian': 'be',
      'Bengali': 'bn',
      'Bosnian': 'bs',
      'Bulgarian': 'bg',
      'Catalan': 'ca',
      'Cebuano': 'ceb',
      'Chichewa': 'ny',
      'Chinese (Simplified)': 'zh-cn',
      'Chinese (Traditional)': 'zh-tw',
      'Corsican': 'co',
      'Croatian': 'hr',
      'Czech': 'cs',
      'Danish': 'da',
      'Dutch': 'nl',
      'English': 'en',
      'Esperanto': 'eo',
      'Estonian': 'et',
      'Filipino': 'tl',
      'Finnish': 'fi',
      'French': 'fr',
      'Frisian': 'fy',
      'Galician': 'gl',
      'Georgian': 'ka',
      'German': 'de',
      'Greek': 'el',
      'Gujarati': 'gu',
      'Haitian Creole': 'ht',
      'Hausa': 'ha',
      'Hawaiian': 'haw',
      'Hebrew': 'he',
      'Hindi': 'hi',
      'Hmong': 'hmn',
      'Hungarian': 'hu',
      'Icelandic': 'is',
      'Igbo': 'ig',
      'Indonesian': 'id',
      'Irish': 'ga',
      'Italian': 'it',
      'Japanese': 'ja',
      'Javanese': 'jw',
      'Kannada': 'kn',
      'Kazakh': 'kk',
      'Khmer': 'km',
      'Kinyarwanda': 'rw',
      'Korean': 'ko',
      'Kurdish (Kurmanji)': 'ku',
      'Kyrgyz': 'ky',
      'Lao': 'lo',
      'Latin': 'la',
      'Latvian': 'lv',
      'Lithuanian': 'lt',
      'Luxembourgish': 'lb',
      'Macedonian': 'mk',
      'Malagasy': 'mg',
      'Malay': 'ms',
      'Malayalam': 'ml',
      'Maltese': 'mt',
      'Maori': 'mi',
      'Marathi': 'mr',
      'Mongolian': 'mn',
      'Myanmar (Burmese)': 'my',
      'Nepali': 'ne',
      'Norwegian': 'no',
      'Odia (Oriya)': 'or',
      'Pashto': 'ps',
      'Persian': 'fa',
      'Polish': 'pl',
      'Portuguese': 'pt',
      'Punjabi': 'pa',
      'Romanian': 'ro',
      'Russian': 'ru',
      'Samoan': 'sm',
      'Scots Gaelic': 'gd',
      'Serbian': 'sr',
      'Sesotho': 'st',
      'Shona': 'sn',
      'Sindhi': 'sd',
      'Sinhala': 'si',
      'Slovak': 'sk',
      'Slovenian': 'sl',
      'Somali': 'so',
      'Spanish': 'es',
      'Sundanese': 'su',
      'Swahili': 'sw',
      'Swedish': 'sv',
      'Tajik': 'tg',
      'Tamil': 'ta',
      'Tatar': 'tt',
      'Telugu': 'te',
      'Thai': 'th',
      'Turkish': 'tr',
      'Turkmen': 'tk',
      'Ukrainian': 'uk',
      'Urdu': 'ur',
      'Uyghur': 'ug',
      'Uzbek': 'uz',
      'Vietnamese': 'vi',
      'Welsh': 'cy',
      'Xhosa': 'xh',
      'Yiddish': 'yi',
      'Yoruba': 'yo',
      'Zulu': 'zu',
    };
  }
}
