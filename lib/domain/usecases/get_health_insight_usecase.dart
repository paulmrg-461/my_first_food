import 'package:dartz/dartz.dart';
import '../entities/health_insight.dart';
import '../repositories/i_ai_repository.dart';
import '../../core/error/failures.dart';

class GetHealthInsightUseCase {
  final IAiRepository _repo;
  GetHealthInsightUseCase(this._repo);

  Future<Either<Failure, HealthInsight>> call({
    required String ingredient,
    required int babyAgeMonths,
  }) =>
      _repo.getHealthInsight(
        ingredient: ingredient,
        babyAgeMonths: babyAgeMonths,
      );
}
