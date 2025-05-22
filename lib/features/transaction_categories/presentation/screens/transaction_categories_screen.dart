// lib/features/transaction_categories/presentation/screens/transaction_categories_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart'; // Используем Material для Scaffold, AppBar, etc.
import 'package:flutter_app_1/features/transaction_categories/presentation/screens/edit_category_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/widgets/custom_floating_action_button.dart';
import '../../../common/widgets/custom_list_view/custom_list_item.dart';
import '../../../common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/transaction_category_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen(this.type, {super.key});
  final String type; // 'expense' или 'income'

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamId = ref.watch(selectedTeamIdProvider);

    if (teamId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final categoriesAsync = ref.watch(transactionCategoriesProvider(type));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          type == 'expense'
              ? LocaleKeys.expenseCategories.tr()
              : LocaleKeys.incomeCategories.tr(),
        ),
      ),
      body: categoriesAsync.when(
        data: (categories) => CustomListViewSeparated(
          items: categories,
          itemBuilder: (context, item) => CustomListItem(
            titleText: item.name,
            leading: Icon(iconFromString(item.icon)),
            onTap: () {
              // ИЗМЕНЕНО: Открываем EditCategoryScreen для редактирования
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCategoryScreen(
                    type: type,
                    initialCategory: item, // Передаем существующую категорию для редактирования
                  ),
                ),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Ошибка: $err')), // TODO: Используйте LocaleKeys для ошибки
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          // ИЗМЕНЕНО: Открываем EditCategoryScreen для создания новой категории
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditCategoryScreen(type: type), // Не передаем initialCategory
            ),
          );
        },
      ),
    );
  }
}