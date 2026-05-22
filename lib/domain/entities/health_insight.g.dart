// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_insight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthInsight _$HealthInsightFromJson(Map<String, dynamic> json) =>
    _HealthInsight(
      ingredient: json['ingredient'] as String,
      benefits: (json['benefits'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      warnings: (json['warnings'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recommendedAgeMonths: (json['recommendedAgeMonths'] as num).toInt(),
      preparationTip: json['preparationTip'] as String? ?? '',
    );

Map<String, dynamic> _$HealthInsightToJson(_HealthInsight instance) =>
    <String, dynamic>{
      'ingredient': instance.ingredient,
      'benefits': instance.benefits,
      'warnings': instance.warnings,
      'recommendedAgeMonths': instance.recommendedAgeMonths,
      'preparationTip': instance.preparationTip,
    };
