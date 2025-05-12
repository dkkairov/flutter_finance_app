import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Для форматирования чисел

import '../../core/theme/custom_colors.dart';
import '../../core/theme/custom_text_styles.dart';

class CustomAmountText extends StatelessWidget {
  final double amount;
  final String currencySymbol; // Добавляем параметр для символа валюты

  const CustomAmountText({
    super.key,
    required this.amount,
    this.currencySymbol = '₸', // Значение по умолчанию - тенге
  });

  @override
  Widget build(BuildContext context) {
    final formattedAmount = NumberFormat('#,###', 'ru_RU').format(amount.abs());
    final sign = amount > 0 ? '+' : '';
    final color = amount < 0 ? CustomColors.error : CustomColors.primary;

    return Text(
      '$sign$formattedAmount $currencySymbol', // Используем переданный символ валюты
      style: CustomTextStyles.normalMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}