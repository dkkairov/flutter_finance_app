import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';


class ThemeManager {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.mainRed,
      foregroundColor: AppColors.mainWhite,
      elevation: 0,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryVariant,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      error: AppColors.error,
      onError: AppColors.onError,
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.normalLarge,
      headlineMedium: AppTextStyles.normalMedium,
      bodyLarge: AppTextStyles.normalLarge,
      bodyMedium: AppTextStyles.normalMedium,
      labelLarge: AppTextStyles.normalLarge,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryVariant,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
      error: AppColors.error,
      onError: AppColors.onError,
    ),
    textTheme: const TextTheme(
      bodyLarge: AppTextStyles.darkNormalLarge,
      bodyMedium: AppTextStyles.darkNormalMedium,
      bodySmall: AppTextStyles.darkNormalSmall,
      // Можно дополнить другими стилями, если нужно
    ),
    useMaterial3: true,
  );
}
