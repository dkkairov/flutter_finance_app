import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/app_text_styles.dart';

class SectionListItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final int maxLines;

  const SectionListItem({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.maxLines = 1,
  });

  /// Для настроек (с иконкой и шевроном)
  factory SectionListItem.settings({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return SectionListItem(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      maxLines: maxLines,
    );
  }

  /// Для транзакций (без иконки, с суммой справа)
  factory SectionListItem.transaction({
    required String title,
    String? subtitle,
    required String amountText,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return SectionListItem(
      title: title,
      subtitle: subtitle,
      trailing: Text(
        amountText,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      maxLines: maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    return ListTile(
      leading: icon != null ? Icon(icon, color: Colors.grey.shade700) : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
        hasSubtitle ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyles.normalMedium,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
          hasSubtitle
              ? Text(
            subtitle!,
            style: AppTextStyles.normalSmall,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          )
              : const SizedBox(height: 16), // выравниваем высоту
        ],
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      visualDensity: VisualDensity.compact,
      minVerticalPadding: 8,
    );
  }
}
