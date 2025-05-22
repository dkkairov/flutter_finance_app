// lib/features/transaction_categories/features/screens/transaction_categories_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/transaction_categories/presentation/screens/add_category_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/icon_helper.dart';
import '../../../generated/locale_keys.g.dart';
import '../../common/widgets/custom_floating_action_button.dart';
import '../../common/widgets/custom_list_view/custom_list_item.dart';
import '../../common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import 'providers/transaction_category_provider.dart';

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
            leading: Icon(iconFromString(item.icon)), // Использование iconFromString - БЕЗ ИЗМЕНЕНИЙ
            onTap: () {
              // TODO: Открыть bottom sheet для редактирования item
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Ошибка: $err')),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return AddCategoryBottomSheet(type: type);
            },
          );
        },
      ),
    );
  }
}