import 'package:flutter/material.dart';

import '../../theme/custom_colors.dart';
import '../../theme/custom_text_styles.dart';

/// A reusable widget for displaying a standard list item with consistent styling.
///
/// It provides a structure similar to ListTile. It accepts raw text for
/// title and subtitle to facilitate unified styling.
class CustomListItem extends StatelessWidget {
  /// Widget to display at the start of the item (e.g., an Icon or Avatar).
  final Widget? leading;

  // !!! ИЗМЕНЕНО: Принимаем String для текста заголовка
  /// Text for the main title.
  final String titleText; // Изменено с Widget на String

  // !!! ИЗМЕНЕНО: Принимаем String? для текста подзаголовка
  /// Text for the subtitle (optional).
  final String? subtitleText; // Изменено с String? (который передавался в Text) на String? (сам текст)


  /// Widget to display at the end of the item (e.g., balance, icon).
  final Widget? trailing;

  /// Callback function when the item is tapped.
  final VoidCallback? onTap;

  /// Optional padding for the item content.
  final EdgeInsetsGeometry? contentPadding;

  const CustomListItem({
    super.key,
    this.leading,
    required this.titleText, // Теперь обязательный String
    this.subtitleText, // Теперь опциональный String
    this.trailing,
    this.onTap,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    // Используем ListTile как основу
    return ListTile(
      leading: leading, // Leading остается виджетом (опциональным)
      // !!! ИСПОЛЬЗУЕМ Text() и применяем единый стиль к titleText
      title: Text(
        titleText,
        // Применяем стандартный стиль для заголовка из AppTextStyles
        // Пример стиля: normalMedium, жирность 500
        style: CustomTextStyles.normalMedium.copyWith(fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      // !!! ИСПОЛЬЗУЕМ Text() и применяем единый стиль к subtitleText (если он есть)
      subtitle: subtitleText != null && subtitleText!.isNotEmpty // Проверяем, что текст подзаголовка не null и не пустой
          ? Text(
        subtitleText!,
        // Применяем стандартный стиль для подзаголовка
        // Пример стиля: normalSmall, серый цвет
        style: CustomTextStyles.normalSmall.copyWith(color: CustomColors.mainGrey),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      )
          : null, // Если текста нет, передаем null в subtitle ListTile
      trailing: trailing, // Trailing остается виджетом (опциональным)
      onTap: onTap,

      // Применяем стандартный отступ содержимого или другой стиль ListTile
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // dense: true, // Пример более компактного вида
      // tileColor: Colors.white, // Пример цвета фона элемента
      // visualDensity: VisualDensity.compact, // Пример визуальной плотности
    );
  }
}