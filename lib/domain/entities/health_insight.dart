import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_insight.freezed.dart';
part 'health_insight.g.dart';

@freezed
abstract class HealthInsight with _$HealthInsight {
  const factory HealthInsight({
    required String ingredient,
    required List<String> benefits,
    required List<String> warnings,
    required int recommendedAgeMonths,
    @Default('') String preparationTip,
  }) = _HealthInsight;

  factory HealthInsight.fromJson(Map<String, dynamic> json) =>
      _$HealthInsightFromJson(json);
}
