class AiException implements Exception {
  final String message;
  const AiException(this.message);
  @override
  String toString() => message;
}

class QuotaExhaustedException implements Exception {
  const QuotaExhaustedException();
  @override
  String toString() => 'Todas las API keys de Gemini están agotadas';
}

class LocalStorageException implements Exception {
  final String message;
  const LocalStorageException(this.message);
  @override
  String toString() => message;
}

class FileUploadException implements Exception {
  final String message;
  const FileUploadException(this.message);
  @override
  String toString() => message;
}
