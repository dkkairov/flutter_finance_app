import 'package:flutter/material.dart';

import 'custom_colors.dart';
import 'custom_text_styles.dart';


class ThemeManager {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: CustomColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: CustomColors.mainRed,
      foregroundColor: CustomColors.mainWhite,
      elevation: 0,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: CustomColors.primary,
      onPrimary: CustomColors.onPrimary,
      primaryContainer: CustomColors.primaryVariant,
      secondary: CustomColors.secondary,
      onSecondary: CustomColors.onSecondary,
      secondaryContainer: CustomColors.secondaryVariant,
      surface: CustomColors.surface,
      onSurface: CustomColors.onSurface,
      error: CustomColors.error,
      onError: CustomColors.onError,
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      headlineLarge: CustomTextStyles.normalLarge,
      headlineMedium: CustomTextStyles.normalMedium,
      bodyLarge: CustomTextStyles.normalLarge,
      bodyMedium: CustomTextStyles.normalMedium,
      labelLarge: CustomTextStyles.normalLarge,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: CustomColors.primary,
      onPrimary: CustomColors.onPrimary,
      primaryContainer: CustomColors.primaryVariant,
      secondary: CustomColors.secondary,
      onSecondary: CustomColors.onSecondary,
      secondaryContainer: CustomColors.secondaryVariant,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
      error: CustomColors.error,
      onError: CustomColors.onError,
    ),
    textTheme: const TextTheme(
      bodyLarge: CustomTextStyles.darkNormalLarge,
      bodyMedium: CustomTextStyles.darkNormalMedium,
      bodySmall: CustomTextStyles.darkNormalSmall,
      // Можно дополнить другими стилями, если нужно
    ),
    useMaterial3: true,
  );
}
