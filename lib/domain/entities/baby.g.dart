// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baby.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Baby _$BabyFromJson(Map<String, dynamic> json) => _Baby(
  id: json['id'] as String,
  name: json['name'] as String,
  birthDate: DateTime.parse(json['birthDate'] as String),
);

Map<String, dynamic> _$BabyToJson(_Baby instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'birthDate': instance.birthDate.toIso8601String(),
};
