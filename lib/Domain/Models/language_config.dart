import 'package:equatable/equatable.dart';

class LanguageConfig extends Equatable {
  final String code;
  final String name;
  final String nativeName;
  final String flagEmoji;
  final bool supportsAutoDetect;

  const LanguageConfig({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flagEmoji,
    this.supportsAutoDetect = true,
  });

  static const List<LanguageConfig> supportedLanguages = [
    LanguageConfig(
      code: 'auto',
      name: 'Auto Detect',
      nativeName: 'Auto',
      flagEmoji: '🌐',
    ),
    LanguageConfig(
      code: 'en-US',
      name: 'English (US)',
      nativeName: 'English',
      flagEmoji: '🇺🇸',
    ),
    LanguageConfig(
      code: 'es-ES',
      name: 'Spanish (Spain)',
      nativeName: 'Español',
      flagEmoji: '🇪🇸',
    ),
    LanguageConfig(
      code: 'zh-CN',
      name: 'Chinese (Mandarin)',
      nativeName: '中文',
      flagEmoji: '🇨🇳',
    ),
    LanguageConfig(
      code: 'hi-IN',
      name: 'Hindi',
      nativeName: 'हिन्दी',
      flagEmoji: '🇮🇳',
    ),
    LanguageConfig(
      code: 'ar-SA',
      name: 'Arabic',
      nativeName: 'العربية',
      flagEmoji: '🇸🇦',
    ),
    LanguageConfig(
      code: 'fr-FR',
      name: 'French',
      nativeName: 'Français',
      flagEmoji: '🇫🇷',
    ),
    LanguageConfig(
      code: 'de-DE',
      name: 'German',
      nativeName: 'Deutsch',
      flagEmoji: '🇩🇪',
    ),
    LanguageConfig(
      code: 'ja-JP',
      name: 'Japanese',
      nativeName: '日本語',
      flagEmoji: '🇯🇵',
    ),
    LanguageConfig(
      code: 'pt-BR',
      name: 'Portuguese (Brazil)',
      nativeName: 'Português',
      flagEmoji: '🇧🇷',
    ),
  ];

  @override
  List<Object?> get props => [
    code,
    name,
    nativeName,
    flagEmoji,
    supportsAutoDetect,
  ];
}
