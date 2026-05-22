import 'package:flutter/material.dart';

// 8pt grid design tokens
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppColors {
  static const primary = Color(0xFF6B9E78);
  static const secondary = Color(0xFFF4A261);
  static const background = Color(0xFFFFF8F0);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFE76F51);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onBackground = Color(0xFF2D3436);
  static const onSurface = Color(0xFF2D3436);
  static const muted = Color(0xFF636E72);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
        ),
      );
}
