import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:translator/translator.dart';

String normalizeTranslationLanguageCode(String languageCode) {
  final normalized = languageCode.trim().replaceAll('_', '-').toLowerCase();
  if (normalized == 'zh' || normalized == 'zh-cn') return 'zh-cn';
  if (normalized == 'zh-tw') return 'zh-tw';
  return normalized.split('-').first;
}

class TranslationRepository {
  late final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const _translationTimeout = Duration(seconds: 15);

  // Language codes mappings
  final Map<String, String> languages = {
    'English': 'en',
    'Hindi': 'hi',
    'Gujarati': 'gu',
    'Spanish': 'es',
    'French': 'fr',
  };

  Future<String> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    final translator = GoogleTranslator();
    final translation = await translator
        .translate(
          text,
          from: normalizeTranslationLanguageCode(sourceLang),
          to: normalizeTranslationLanguageCode(targetLang),
        )
        .timeout(_translationTimeout);
    final translatedText = translation.text.trim();
    if (translatedText.isEmpty) {
      throw StateError('The translation service returned empty text.');
    }
    return translatedText;
  }

  Future<void> saveTranslationHistory(
    String original,
    String translated,
    String from,
    String to,
  ) async {
    await _firestore.collection('translations').add({
      'originalText': original,
      'translatedText': translated,
      'sourceLanguage': from,
      'targetLanguage': to,
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
