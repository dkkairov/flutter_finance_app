// lib/features/common/widgets/custom_picker_fields/picker_item.dart
import 'package:flutter/material.dart'; // Обязательно добавьте этот импорт для IconData

class PickerItem<T> {
  final T value; // ИЗМЕНЕНО: Снова 'value' вместо 'id'
  final String displayValue;
  final String? imageUrl;
  final IconData? iconData; // ДОБАВЛЕНО: Вернули поле для IconData

  PickerItem({
    required this.value, // ИЗМЕНЕНО: Теперь снова 'value'
    required this.displayValue,
    this.imageUrl,
    this.iconData, // ДОБАВЛЕНО: Инициализация поля
  });
}