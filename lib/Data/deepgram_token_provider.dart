import 'package:cloud_functions/cloud_functions.dart';

abstract interface class DeepgramTokenProvider {
  Future<String> fetchToken();
}

class FirebaseDeepgramTokenProvider implements DeepgramTokenProvider {
  FirebaseDeepgramTokenProvider()
    : _functions = FirebaseFunctions.instanceFor(region: 'us-central1');

  final FirebaseFunctions _functions;

  @override
  Future<String> fetchToken() async {
    final result = await _functions.httpsCallable('getDeepgramToken').call();
    final data = result.data;
    if (data is! Map || data['accessToken'] is! String) {
      throw StateError('The token service returned an invalid response.');
    }

    final token = (data['accessToken'] as String).trim();
    if (token.isEmpty) {
      throw StateError('The token service returned an empty access token.');
    }
    return token;
  }
}
