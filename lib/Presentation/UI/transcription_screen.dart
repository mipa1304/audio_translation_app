import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/language_config.dart';
import '../bloc/transcription_bloc.dart';
import '../bloc/transcription_event.dart';
import '../bloc/transcription_state.dart';
import 'audio_visualizer.dart';

const _deepgramApiKey = String.fromEnvironment('DEEPGRAM_API_KEY');

class TranscriptionScreen extends StatefulWidget {
  const TranscriptionScreen({super.key});

  @override
  State<TranscriptionScreen> createState() => _TranscriptionScreenState();
}

class _TranscriptionScreenState extends State<TranscriptionScreen> {
  final ScrollController _scrollController = ScrollController();

  void _autoScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Audio Translation'),
        centerTitle: true,
        actions: [
          BlocBuilder<TranscriptionBloc, TranscriptionState>(
            builder: (context, state) {
              final activeConfig = LanguageConfig.supportedLanguages.firstWhere(
                (l) => l.code == state.currentLanguage,
                orElse: () => LanguageConfig.supportedLanguages.first,
              );
              return TextButton.icon(
                onPressed: () => _showLanguageSelector(context),
                icon: Text(
                  activeConfig.flagEmoji,
                  style: const TextStyle(fontSize: 18),
                ),
                label: Text(activeConfig.nativeName),
              );
            },
          ),
          BlocBuilder<TranscriptionBloc, TranscriptionState>(
            builder: (context, state) {
              final targetConfig = LanguageConfig.supportedLanguages.firstWhere(
                (language) => language.code == state.targetLanguage,
                orElse: () => LanguageConfig.supportedLanguages.first,
              );
              return IconButton(
                tooltip: 'Choose translation language',
                icon: Text(
                  targetConfig.flagEmoji,
                  style: const TextStyle(fontSize: 18),
                ),
                onPressed: () => _showLanguageSelector(context, target: true),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<TranscriptionBloc, TranscriptionState>(
                listener: (context, state) {
                  if (state.interimSegment != null ||
                      state.finalizedSegments.isNotEmpty) {
                    _autoScrollToBottom();
                  }
                  if (state.status == TranscriptionStatus.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.errorMessage ?? 'An error occurred',
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.finalizedSegments.isEmpty &&
                      state.interimSegment == null) {
                    return Center(
                      child: Text(
                        state.status == TranscriptionStatus.recording
                            ? 'Listening for speech...'
                            : 'Press record to initiate session.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount:
                        state.finalizedSegments.length +
                        (state.interimSegment != null ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < state.finalizedSegments.length) {
                        final seg = state.finalizedSegments[index];
                        final translated = index < state.translatedTexts.length
                            ? state.translatedTexts[index]
                            : 'Translating...';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    seg.text,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    translated,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        final interim = state.interimSegment!;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer
                                    .withAlpha(120),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                interim.text,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            BlocBuilder<TranscriptionBloc, TranscriptionState>(
              builder: (context, state) {
                return Column(
                  children: [
                    if (state.status == TranscriptionStatus.recording)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AudioVisualizer(
                          audioLevels: state.audioLevels,
                          activeColor: theme.colorScheme.primary,
                        ),
                      ),
                    Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (state.status ==
                              TranscriptionStatus.recording) ...[
                            IconButton.filledTonal(
                              iconSize: 32,
                              icon: const Icon(Icons.pause),
                              onPressed: () => context
                                  .read<TranscriptionBloc>()
                                  .add(PauseTranscriptionRequested()),
                            ),
                            IconButton.filled(
                              iconSize: 36,
                              style: IconButton.styleFrom(
                                backgroundColor: theme.colorScheme.error,
                              ),
                              icon: const Icon(Icons.stop),
                              onPressed: () => context
                                  .read<TranscriptionBloc>()
                                  .add(StopTranscriptionRequested()),
                            ),
                          ] else if (state.status ==
                              TranscriptionStatus.paused) ...[
                            IconButton.filled(
                              iconSize: 36,
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () => context
                                  .read<TranscriptionBloc>()
                                  .add(ResumeTranscriptionRequested()),
                            ),
                            IconButton.filled(
                              iconSize: 36,
                              style: IconButton.styleFrom(
                                backgroundColor: theme.colorScheme.error,
                              ),
                              icon: const Icon(Icons.stop),
                              onPressed: () => context
                                  .read<TranscriptionBloc>()
                                  .add(StopTranscriptionRequested()),
                            ),
                          ] else ...[
                            FloatingActionButton.extended(
                              icon: const Icon(Icons.mic),
                              label: const Text('Start Recording'),
                              onPressed: () {
                                context.read<TranscriptionBloc>().add(
                                  const StartTranscriptionRequested(
                                    languageCode: 'auto',
                                    apiKey: _deepgramApiKey,
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, {bool target = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (modalContext) {
        return LanguageSelectionModal(target: target);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class LanguageSelectionModal extends StatefulWidget {
  final bool target;

  const LanguageSelectionModal({super.key, this.target = false});

  @override
  State<LanguageSelectionModal> createState() => _LanguageSelectionModalState();
}

class _LanguageSelectionModalState extends State<LanguageSelectionModal> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = LanguageConfig.supportedLanguages.where((l) {
      if (widget.target && l.code == 'auto') return false;
      final q = _searchQuery.toLowerCase();
      return l.name.toLowerCase().contains(q) ||
          l.nativeName.toLowerCase().contains(q);
    }).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search Language',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final lang = filtered[index];
                return ListTile(
                  leading: Text(
                    lang.flagEmoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(lang.name),
                  subtitle: Text(lang.nativeName),
                  onTap: () {
                    context.read<TranscriptionBloc>().add(
                      widget.target
                          ? TargetLanguageChanged(lang.code)
                          : LanguageChanged(lang.code),
                    );
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
