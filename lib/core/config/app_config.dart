class AppConfig {
  AppConfig._();

  // Injected at build time via --dart-define (see deploy section).
  static const _geminiKey1 = String.fromEnvironment('GEMINI_API_KEY_1');
  static const _geminiKey2 = String.fromEnvironment('GEMINI_API_KEY_2');
  static const _geminiKey3 = String.fromEnvironment('GEMINI_API_KEY_3');
  static const _geminiKey4 = String.fromEnvironment('GEMINI_API_KEY_4');
  static const _geminiKey5 = String.fromEnvironment('GEMINI_API_KEY_5');
  static const _appEnv =
      String.fromEnvironment('APP_ENV', defaultValue: 'development');

  static List<String> get geminiApiKeys => [
    _geminiKey1,
    _geminiKey2,
    _geminiKey3,
    _geminiKey4,
    _geminiKey5,
  ].where((k) => k.isNotEmpty).toList();

  static const deepseekApiKey = String.fromEnvironment('DEEPSEEK_API_KEY');

  static bool get isDevelopment => _appEnv == 'development';

  static const geminiModel = 'gemini-2.5-flash';
  static const geminiFileExpiryHours = 47;
}
