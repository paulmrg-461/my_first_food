import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static List<String> get geminiApiKeys => [
    dotenv.get('GEMINI_API_KEY_1', fallback: ''),
    dotenv.get('GEMINI_API_KEY_2', fallback: ''),
    dotenv.get('GEMINI_API_KEY_3', fallback: ''),
    dotenv.get('GEMINI_API_KEY_4', fallback: ''),
    dotenv.get('GEMINI_API_KEY_5', fallback: ''),
  ].where((k) => k.isNotEmpty).toList();

  static String get deepseekApiKey =>
      dotenv.get('DEEPSEEK_API_KEY', fallback: '');

  static bool get isDevelopment =>
      dotenv.get('APP_ENV', fallback: 'development') == 'development';

  static const geminiModel = 'gemini-2.5-flash';
  static const geminiFileExpiryHours = 47;
}
