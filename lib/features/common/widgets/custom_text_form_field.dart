import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/custom_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String? initialValue;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final dynamic controller;
  final String? Function(String?)? validator; // Добавляем параметр validator
  final dynamic suffixText;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.initialValue,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    this.controller,
    this.validator, // Принимаем validator в конструкторе
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      controller: controller,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      validator: validator, // Передаем validator во внутренний TextFormField
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: CustomColors.mainLightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixText: suffixText,
        labelStyle: TextStyle(color: CustomColors.mainDarkGrey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      // TODO: Добавить onChanged или controller для обработки ввода
    );
  }
}