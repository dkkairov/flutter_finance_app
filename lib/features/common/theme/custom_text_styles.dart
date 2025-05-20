import 'package:flutter/material.dart';
import 'custom_colors.dart';

class CustomTextStyles {
  // 🌞 Светлая тема
  static const TextStyle normalLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: CustomColors.onBackground
  );

  static const TextStyle normalMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
      color: CustomColors.onBackground
  );

  static const TextStyle normalSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
      color: CustomColors.onBackground
  );

  static const TextStyle onColorNormalLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: CustomColors.onPrimary,
  );

  static const TextStyle onColorNormalMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: CustomColors.onPrimary,
  );

  static const TextStyle onColorNormalSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: CustomColors.onPrimary,
  );

  static const TextStyle successText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: CustomColors.mainGreen,
  );

  static const TextStyle errorText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: CustomColors.error,
  );



  // 🌚 Тёмная тема
  static const TextStyle darkNormalLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.normal,
    color: CustomColors.onPrimary,
  );

  static const TextStyle darkNormalMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: CustomColors.onPrimary,
  );

  static const TextStyle darkNormalSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: CustomColors.onPrimary
  );
}
