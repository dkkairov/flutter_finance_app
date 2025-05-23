// lib/features/transactions/presentation/widgets/transaction_create_screen/category_picker_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/common/theme/custom_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/icon_helper.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../transaction_categories/data/models/transaction_category_model.dart';
import '../../../../transaction_categories/presentation/providers/transaction_category_provider.dart';
import '../../providers/transaction_controller.dart';
import '../../screens/transaction_create_screen.dart'; // Для TransactionType enum

// ИЗМЕНЕНО: теперь ConsumerStatefulWidget
class CategoryPickerWidget extends ConsumerStatefulWidget {
  const CategoryPickerWidget({super.key});

  @override
  ConsumerState<CategoryPickerWidget> createState() => _CategoryPickerWidgetState();
}

class _CategoryPickerWidgetState extends ConsumerState<CategoryPickerWidget> {
  late PageController _pageController; // Объявляем PageController
  int _currentPageIndex = 0; // Для отслеживания текущей страницы

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Инициализируем контроллер
    _pageController.addListener(() {
      // Обновляем состояние текущей страницы при свайпе
      if (_pageController.page?.round() != _currentPageIndex) {
        setState(() {
          _currentPageIndex = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Не забудьте освободить контроллер
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { // У ConsumerStatefulWidget в build нет WidgetRef ref
    final transactionType = ref.watch(transactionTypeProvider);
    final transactionCreateController = ref.read(transactionCreateControllerProvider.notifier);

    final categoriesAsyncValue = ref.watch(transactionCategoriesProvider(
      transactionType == TransactionType.expense ? 'expense' : 'income',
    ));

    return categoriesAsyncValue.when(
      loading: () {
        print('DEBUG: CategoryPickerWidget loading categories...');
        return const SizedBox(
          height: 320,
          child: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stack) {
        print('DEBUG: CategoryPickerWidget error: $error');
        return SizedBox(
          height: 320,
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

        const int itemsPerPage = 12;
        final int pageCount = (categoriesToShow.length / itemsPerPage).ceil();

        if (categoriesToShow.isEmpty) {
          return const SizedBox(
            height: 320,
            child: Center(child: Text('Нет доступных категорий')),
          );
        }

        // --- ДОБАВЛЕН КОНТЕЙНЕР Column для PageView и индикатора ---
        return Column(
          children: [
            SizedBox(
              height: 270, // Скорректированная высота для GridView, чтобы оставить место для индикатора
              child: PageView.builder(
                controller: _pageController, // Привязываем контроллер
                itemCount: pageCount,
                itemBuilder: (context, pageIndex) {
                  final int startIndex = pageIndex * itemsPerPage;
                  int endIndex = startIndex + itemsPerPage;
                  if (endIndex > categoriesToShow.length) {
                    endIndex = categoriesToShow.length;
                  }
                  final List<TransactionCategoryModel> pageCategories =
                  categoriesToShow.sublist(startIndex, endIndex);

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    children: pageCategories.map((category) {
                      return InkWell(
                        onTap: () async {
                          final freshController = ref.read(transactionCreateControllerProvider.notifier);
                          final freshRawAmount = freshController.rawAmount;
                          print('DEBUG: CategoryPickerWidget - rawAmount before parsing: "$freshRawAmount"');
                          final cleanedRawAmount = freshRawAmount.replaceAll(' ', '').replaceAll(',', '.');
                          print('DEBUG: CategoryPickerWidget - cleanedRawAmount: "$cleanedRawAmount"');
                          final parsedAmount = double.tryParse(cleanedRawAmount);
                          print('DEBUG: CategoryPickerWidget - parsed amount: $parsedAmount');

                          if (parsedAmount == null || parsedAmount <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(LocaleKeys.transactionAmountInvalid.tr()),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          freshController.updateTransactionCategory(category.id);

                          final errorMessage = await freshController.createTransaction();

                          if (errorMessage == null) {
                            freshController.resetForm();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(LocaleKeys.transactionCreatedSuccessfully.tr()),
                                backgroundColor: Colors.green,
                              ),
                            );
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
                              backgroundColor: Colors.grey.shade200,
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            // --- ИНДИКАТОР СТРАНИЦ ---
            if (pageCount > 1) // Показываем индикатор только если страниц больше одной
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pageCount, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      height: 8.0,
                      width: _currentPageIndex == index ? 24.0 : 8.0,
                      decoration: BoxDecoration(
                        color: _currentPageIndex == index ? CustomColors.primary : CustomColors.mainLightGrey,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    );
                  }),
                ),
              ),
          ],
        );
      },
    );
  }
}