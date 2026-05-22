import 'package:freezed_annotation/freezed_annotation.dart';

part 'baby.freezed.dart';
part 'baby.g.dart';

@freezed
abstract class Baby with _$Baby {
  const Baby._();

  const factory Baby({
    required String id,
    required String name,
    required DateTime birthDate,
  }) = _Baby;

  factory Baby.fromJson(Map<String, dynamic> json) => _$BabyFromJson(json);

  int get ageInMonths {
    final now = DateTime.now();
    final months = (now.year - birthDate.year) * 12 +
        now.month -
        birthDate.month;
    return months < 0 ? 0 : months;
  }
}
