import 'package:flutter_test/flutter_test.dart';
import 'package:transcription_app/Data/translation_api.dart';

void main() {
  test('preserves Google Translate Chinese locale codes', () {
    expect(normalizeTranslationLanguageCode('zh-CN'), 'zh-cn');
    expect(normalizeTranslationLanguageCode('zh_TW'), 'zh-tw');
  });

  test('normalizes other regional language codes', () {
    expect(normalizeTranslationLanguageCode('hi-IN'), 'hi');
    expect(normalizeTranslationLanguageCode('pt-BR'), 'pt');
    expect(normalizeTranslationLanguageCode('auto'), 'auto');
  });
}
