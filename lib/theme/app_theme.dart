import 'package:flutter/material.dart';

import 'app_colors.dart';

/// docs/diseno.md pide Inter; se deja la fuente del sistema para no sumar
/// una dependencia solo por la tipografía, tal como permite ese documento.
class AppTheme {
  static ThemeData get tema {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brand600),
    );
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.canvas,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.brand600,
        secondary: AppColors.brand400,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      textTheme: _textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static const _textTheme = TextTheme(
    displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        height: 58 / 48,
        color: AppColors.textPrimary),
    headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 40 / 32,
        color: AppColors.textPrimary),
    headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 30 / 22,
        color: AppColors.textPrimary),
    titleLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        height: 24 / 17,
        color: AppColors.textPrimary),
    bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 26 / 16,
        color: AppColors.textPrimary),
    bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 22 / 14,
        color: AppColors.textSecondary),
    bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 20 / 13,
        color: AppColors.textSecondary),
    labelLarge: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        color: AppColors.textPrimary),
    labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 15 / 11,
        color: AppColors.textMuted),
  );
}
