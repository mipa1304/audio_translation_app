import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:translator/translator.dart';

class TranslationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Language codes mappings
  final Map<String, String> languages = {
    'English': 'en',
    'Hindi': 'hi',
    'Gujarati': 'gu',
    'Spanish': 'es',
    'French': 'fr'
  };

  Future<String> translateText({
    required String text,
    required String sourceLang,
    required String targetLang
  }) async {
    final translator = GoogleTranslator();
    final translation = await translator.translate(
      text,
      from: sourceLang,
      to: targetLang,
    );
    return translation.text;
  }

  Future<void> saveTranslationHistory(String original, String translated, String from, String to) async {
    await _firestore.collection('translations').add({
      'originalText': original,
      'translatedText': translated,
      'sourceLanguage': from,
      'targetLanguage': to,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}