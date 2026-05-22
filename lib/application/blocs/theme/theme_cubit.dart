import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _boxName = 'settings';
  static const _keyTheme = 'theme_mode';

  ThemeCubit() : super(ThemeMode.light) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox(_boxName);
    final isDark = box.get(_keyTheme, defaultValue: false) as bool;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    final box = await Hive.openBox(_boxName);
    await box.put(_keyTheme, next == ThemeMode.dark);
  }
}
