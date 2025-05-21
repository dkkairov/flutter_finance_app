// lib/features/transactions/presentation/widgets/transaction_create_screen/category_picker_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../common/widgets/custom_show_bottom_sheet.dart'; // УДАЛЯЕМ этот импорт
import '../../../../../core/utils/icon_helper.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../transaction_categories/data/models/transaction_category_model.dart';
import '../../../../transaction_categories/presentation/providers/transaction_category_provider.dart';
import '../../providers/transaction_controller.dart';
import '../../screens/transaction_create_screen.dart'; // Для TransactionType enum

class CategoryPickerWidget extends ConsumerWidget {
  const CategoryPickerWidget({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionType = ref.watch(transactionTypeProvider);
    final transactionCreateController = ref.read(transactionCreateControllerProvider.notifier);
    final rawAmount = transactionCreateController.rawAmount; // Получаем текущую сумму

    final categoriesAsyncValue = ref.watch(transactionCategoriesProvider(
      transactionType == TransactionType.expense ? 'expense' : 'income',
    ));

    return categoriesAsyncValue.when(
      loading: () {
        print('DEBUG: CategoryPickerWidget loading categories...');
        return const SizedBox(
          height: 300, // Минимальная высота для индикатора загрузки
          child: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stack) {
        print('DEBUG: CategoryPickerWidget error: $error');
        return SizedBox(
          height: 300, // Минимальная высота для сообщения об ошибке
          child: Center(
            child: Text('Ошибка загрузки категорий: ${error.toString()}'),
          ),
        );
      },
      data: (categories) {
        print('DEBUG: CategoryPickerWidget received ${categories.length} categories.');
        final List<TransactionCategoryModel> categoriesToShow = categories
            .where((category) =>
        category.type ==
            (transactionType == TransactionType.expense ? 'expense' : 'income'))
            .toList();
        print('DEBUG: CategoryPickerWidget showing ${categoriesToShow.length} categories after filtering.');

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          children: categoriesToShow.map((category) {
            // final isSelected = transactionCreateController.state.categoryId == category.id; // Это можно использовать для визуального выделения
            return InkWell(
              onTap: () async {
                // ПОЛУЧАЕМ ТЕКУЩУЮ СУММУ ВНУТРИ onTap, а не при build
                final freshController = ref.read(transactionCreateControllerProvider.notifier);
                final freshRawAmount = freshController.rawAmount;
                print('DEBUG: CategoryPickerWidget - rawAmount before parsing: "$freshRawAmount"');
                final cleanedRawAmount = freshRawAmount.replaceAll(' ', '').replaceAll(',', '.');
                print('DEBUG: CategoryPickerWidget - cleanedRawAmount: "$cleanedRawAmount"');
                final parsedAmount = double.tryParse(cleanedRawAmount); // Временно сохраним результат парсинга
                print('DEBUG: CategoryPickerWidget - parsed amount: $parsedAmount');
                if (parsedAmount == null || parsedAmount <= 0) {
                  // Показываем SnackBar, если сумма недействительна
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocaleKeys.transactionAmountInvalid.tr()),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return; // Не создаем транзакцию
                }

                // Обновляем категорию в состоянии
                freshController.updateTransactionCategory(category.id);

                // Вызываем метод создания транзакции
                final errorMessage = await freshController.createTransaction();

                if (errorMessage == null) {
                  freshController.resetForm();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('transactionCreatedSuccessfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // TODO: Навигация или обновление списка
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey.shade200, // Убрал isSelected для простоты, если не требуется визуальное выделение
                    child: Icon(
                      iconFromString(category.icon),
                      color: Colors.grey.shade600,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}