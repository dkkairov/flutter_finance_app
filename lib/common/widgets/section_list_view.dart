import 'package:flutter/material.dart';
import 'custom_divider.dart';
import 'section_list_item.dart';

class SectionListItemModel {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  SectionListItemModel({
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
}

class SectionListView extends StatelessWidget {
  final List<SectionListItemModel> items;
  final Widget? themeToggle;

  const SectionListView({
    super.key,
    required this.items,
    this.themeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length + 1 + (themeToggle != null ? 1 : 0),
      separatorBuilder: (context, index) {
        if (index < items.length - 1 + (themeToggle != null ? 1 : 0)) {
          return CustomDivider();
        } else {
          return const SizedBox.shrink();
        }
      },
      itemBuilder: (context, index) {
        if (index < items.length) {
          final item = items[index];
          return SectionListItem(
            icon: item.icon,
            title: item.title,
            subtitle: item.subtitle,
            trailing: item.trailing,
            onTap: item.onTap,
          );
        } else if (index == items.length && themeToggle != null) {
          return themeToggle!;
        } else {
          return const Padding(
            padding: EdgeInsets.all(0),
            child: CustomDivider(),
          );
        }
      },
    );
  }
}
