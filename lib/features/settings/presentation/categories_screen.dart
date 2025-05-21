// categories_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/icon_helper.dart';
import '../../../generated/locale_keys.g.dart';
import '../../common/widgets/custom_floating_action_button.dart';
import '../../common/widgets/custom_list_view/custom_list_item.dart';
import '../../common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../../auth/presentation/providers/auth_providers.dart'; // <--- Импорт selectedTeamIdProvider (если не было)
import '../../transaction_categories/data/models/transaction_category_model.dart';
import '../../transaction_categories/presentation/providers/transaction_category_provider.dart'; // <--- Исправленный импорт общего провайдера категорий

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen(this.type, {super.key});
  final String type; // 'expense' или 'income'

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Используем selectedTeamIdProvider вместо currentTeamIdProvider,
    // так как мы договорились использовать его для получения teamId
    final teamId = ref.watch(selectedTeamIdProvider);

    if (teamId == null) {
      // Если teamId равен null, показываем индикатор загрузки или сообщение
      return const Center(child: CircularProgressIndicator()); // Или Text('Выберите команду')
    }

    // Вместо отдельных expenseTransactionCategoriesProvider и incomeTransactionCategoriesProvider,
    // используем один transactionCategoriesProvider.family
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
            leading: Icon(iconFromString(item.icon)), // Использование iconFromString
            onTap: () {
              // Открыть bottom sheet для редактирования item
              // Для редактирования, возможно, понадобится передать item.id
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Ошибка: $err')),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          // Открыть bottom sheet для добавления категории
        },
      ),
    );
  }
}