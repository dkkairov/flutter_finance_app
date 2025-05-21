import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../core/utils/icon_helper.dart';
import '../../../../../features/common/theme/custom_colors.dart';
import '../../../../../features/common/theme/custom_text_styles.dart';
import '../../providers/transaction_controller.dart';
import '../../screens/transaction_create_screen.dart'; // Для TransactionType enum
import '../../../../transaction_categories/data/models/transaction_category_model.dart'; // <--- ИМПОРТ ТВОЕЙ МОДЕЛИ КАТЕГОРИИ
import '../../../../transaction_categories/presentation/providers/transaction_category_provider.dart'; // <--- ИМПОРТ ПРОВАЙДЕРА КАТЕГОРИЙ


// 1. УДАЛИТЬ КЛАСС TransactionCategoryItem! Теперь мы используем TransactionCategoryModel.
// class TransactionCategoryItem {
//   final int id;
//   final String name;
//   final IconData icon;
//   TransactionCategoryItem({required this.id, required this.name, required this.icon});
// }

// 2. УДАЛИТЬ ХАРДКОДНЫЕ СПИСКИ КАТЕГОРИЙ! Теперь мы получаем их из API.
// final List<TransactionCategoryItem> expenseTransactionCategories = [...];
// final List<TransactionCategoryItem> incomeTransactionCategories = [...];


class CategoryPickerWidget extends ConsumerWidget {
  final TransactionType transactionType;

  const CategoryPickerWidget({super.key, required this.transactionType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(transactionCategoriesProvider(
      transactionType == TransactionType.expense ? 'expense' : 'income',
    ));

    return categoriesAsyncValue.when(
      loading: () {
        print('DEBUG: CategoryPickerWidget loading categories...');
        return const SizedBox(
          height: 300,
          child: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stack) {
        print('DEBUG: CategoryPickerWidget error: $error');
        return SizedBox(
          height: 300,
          child: Center(
            child: Text('Ошибка загрузки категорий: ${error.toString()}'),
          ),
        );
      },
      data: (categories) {
        print('DEBUG: CategoryPickerWidget received ${categories.length} categories.'); // <--- ДОБАВЬ ЭТО
        final List<TransactionCategoryModel> categoriesToShow = categories
            .where((category) => category.type == (transactionType == TransactionType.expense ? 'expense' : 'income'))
            .toList();
        print('DEBUG: CategoryPickerWidget showing ${categoriesToShow.length} categories after filtering.'); // <--- И ЭТО


        int itemsPerPage = 16;
        int pageCount = (categoriesToShow.length / itemsPerPage).ceil();
        final PageController pageController = PageController();

        return Column(
          children: [
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: pageController,
                itemCount: pageCount,
                itemBuilder: (context, pageIndex) {
                  int start = pageIndex * itemsPerPage;
                  int end = (start + itemsPerPage).clamp(0, categoriesToShow.length);
                  List<TransactionCategoryModel> pageCategories = categoriesToShow.sublist(start, end);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: pageCategories.map((transactionCategoryModel) {
                        return TransactionCategoryTile(
                          // Передаем TransactionCategoryModel
                          transactionCategory: transactionCategoryModel,
                          onTap: () {
                            final controller = ref.read(transactionCreateControllerProvider.notifier);
                            // Важно: ID категории теперь String!
                            controller.updateTransactionCategory(transactionCategoryModel.id);
                            debugPrint('Category tapped: ${transactionCategoryModel.name} (ID: ${transactionCategoryModel.id})');
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            if (pageCount > 1) ...[
              const SizedBox(height: 6),
              SmoothPageIndicator(
                controller: pageController,
                count: pageCount,
                effect: const ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotColor: CustomColors.primary,
                  dotColor: CustomColors.mainLightGrey,
                ),
              ),
              const SizedBox(height: 6),
            ] else ... [
              const SizedBox(height: 20)
            ]
          ],
        );
      },
    );
  }
}

// 3. Модифицируем TransactionCategoryTile для работы с TransactionCategoryModel
class TransactionCategoryTile extends StatelessWidget {
  // Теперь принимает TransactionCategoryModel
  final TransactionCategoryModel transactionCategory;
  final VoidCallback onTap;

  const TransactionCategoryTile({
    super.key,
    required this.transactionCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ИСПОЛЬЗУЕМ iconFromString ДЛЯ ПОЛУЧЕНИЯ IconData
            Icon(iconFromString(transactionCategory.icon), size: 36, color: CustomColors.primary),
            const SizedBox(height: 6),
            Text(
              transactionCategory.name,
              textAlign: TextAlign.center,
              style: CustomTextStyles.normalSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}