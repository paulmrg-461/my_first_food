class AiException implements Exception {
  final String message;
  const AiException(this.message);
}

class QuotaExhaustedException implements Exception {
  const QuotaExhaustedException();
}

class LocalStorageException implements Exception {
  final String message;
  const LocalStorageException(this.message);
}

class FileUploadException implements Exception {
  final String message;
  const FileUploadException(this.message);
}
