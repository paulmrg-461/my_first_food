import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class AiFailure extends Failure {
  const AiFailure(super.message);
}

class QuotaExhaustedFailure extends Failure {
  const QuotaExhaustedFailure() : super('All Gemini API keys quota exhausted');
}

class LocalStorageFailure extends Failure {
  const LocalStorageFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class FileUploadFailure extends Failure {
  const FileUploadFailure(super.message);
}
