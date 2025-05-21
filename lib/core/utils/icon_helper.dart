// lib/features/common/utils/icon_mapping.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Сопоставление строкового значения из API с CupertinoIcons.
/// Дополняй список по своему API!
final Map<String, IconData> kCupertinoIconMap = {
  'work': CupertinoIcons.briefcase,
  'shopping_cart': CupertinoIcons.cart,
  'home': CupertinoIcons.home,
  'car': CupertinoIcons.car,
  'food': CupertinoIcons.square_favorites,   // Можешь заменить на другой
  'flight': CupertinoIcons.airplane,
  'money': CupertinoIcons.money_dollar,
  'sport': CupertinoIcons.sportscourt,
  'settings': CupertinoIcons.settings,
  'add': CupertinoIcons.add,
  'person': CupertinoIcons.person,
  'star': CupertinoIcons.star,
  'wine_bar': Icons.wine_bar, // Пример добавления Material Icons, если смешанные иконки
  'shopping_bag': Icons.shopping_bag,
  'checkroom': Icons.checkroom,
  'format_paint': Icons.format_paint,
  'headset': Icons.headset,
  'fitness_center': Icons.fitness_center,
  'directions_car': Icons.directions_car,
  'water_drop': Icons.water_drop,
  'baby_changing_station': Icons.baby_changing_station,
  'movie': Icons.movie,
  'business': Icons.business,
  'volunteer_activism': Icons.volunteer_activism,
  'woman': Icons.woman,
  'card_giftcard': Icons.card_giftcard,
  'laptop': Icons.laptop,
  'local_hospital': Icons.local_hospital,
  'school': Icons.school,
  'theater_comedy': Icons.theater_comedy,
  'account_balance': Icons.account_balance,
  'account_balance_wallet': Icons.account_balance_wallet,
  // ...добавляй остальные по необходимости
};

/// Возвращает иконку по строковому имени из API.
/// Если не найдено — вернёт [CupertinoIcons.square_list] по умолчанию.
IconData iconFromString(String? iconName) {
  if (iconName == null) return CupertinoIcons.square_list;
  return kCupertinoIconMap[iconName] ?? CupertinoIcons.square_list;
}