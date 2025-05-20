import 'package:flutter/material.dart';
import '../custom_divider.dart'; // Убедитесь, что путь правильный

/// A reusable ListView.separated widget with a custom separator and padding.
///
/// It requires a list of [items] (any type T) and an [itemBuilder] function
/// to build the widget for each item. It does not include an [Expanded] wrapper.
class CustomListViewSeparated<T> extends StatelessWidget {
  /// The list of data items to display.
  final List<T> items;

  /// A builder function that creates a widget for each item.
  /// The builder receives the context and the item data (type T).
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Optional padding for the ListView itself.
  final EdgeInsetsGeometry padding;


  const CustomListViewSeparated({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(0), // Отступ по умолчанию
  });

  @override
  Widget build(BuildContext context) {
    // Не оборачиваем в Expanded здесь
    return ListView.separated(
      padding: padding, // Используем переданный отступ
      itemCount: items.length, // Количество элементов
      separatorBuilder: (_, __) => const CustomDivider(), // Разделитель
      itemBuilder: (context, index) {
        final item = items[index];
        // Используем переданную функцию itemBuilder для построения виджета
        return itemBuilder(context, item);
      },
    );
  }
}