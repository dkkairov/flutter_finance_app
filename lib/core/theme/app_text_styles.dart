import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // 🌞 Светлая тема
  static const TextStyle normalLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground
  );

  static const TextStyle normalMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
      color: AppColors.onBackground
  );

  static const TextStyle normalSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
      color: AppColors.onBackground
  );

  static const TextStyle onColorNormalLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary,
  );

  static const TextStyle onColorNormalMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );

  static const TextStyle onColorNormalSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.onPrimary,
  );

  static const TextStyle successText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.mainGreen,
  );

  static const TextStyle errorText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
  );



  // 🌚 Тёмная тема
  static const TextStyle darkNormalLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.normal,
    color: AppColors.onPrimary,
  );

  static const TextStyle darkNormalMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.onPrimary,
  );

  static const TextStyle darkNormalSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.onPrimary
  );
}
