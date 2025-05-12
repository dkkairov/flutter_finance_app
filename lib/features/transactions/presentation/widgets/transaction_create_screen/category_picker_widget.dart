import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/custom_colors.dart';
import 'package:flutter_app_1/core/theme/custom_text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../providers/transaction_controller.dart';
import '../../screens/transaction_create_screen.dart';

// 1. Добавляем ID в CategoryItem
class TransactionCategoryItem {
  final int id; // ID категории (должен совпадать с ID в базе данных)
  final String name;
  final IconData icon;
  TransactionCategoryItem({required this.id, required this.name, required this.icon});
}

// 2. Преобразуем в ConsumerWidget
class CategoryPickerWidget extends ConsumerWidget {
  // Принимаем тип транзакции
  final TransactionType transactionType;

  // Добавляем примерные ID к категориям (ВАЖНО: замени на реальные ID из базы!)
  // Также убрал дубликаты для ясности
  final List<TransactionCategoryItem> expenseTransactionCategories = [
    TransactionCategoryItem(id: 1, name: "Питание вне дома", icon: Icons.wine_bar),
    TransactionCategoryItem(id: 2, name: "Продукты", icon: Icons.shopping_bag),
    TransactionCategoryItem(id: 3, name: "Одежда", icon: Icons.checkroom),
    TransactionCategoryItem(id: 4, name: "Ремонт", icon: Icons.format_paint),
    TransactionCategoryItem(id: 5, name: "Развлечения", icon: Icons.headset),
    TransactionCategoryItem(id: 6, name: "Спорт", icon: Icons.fitness_center),
    TransactionCategoryItem(id: 7, name: "Авто", icon: Icons.directions_car),
    TransactionCategoryItem(id: 8, name: "Коммуналка", icon: Icons.water_drop),
    TransactionCategoryItem(id: 9, name: "Дети", icon: Icons.baby_changing_station),
    TransactionCategoryItem(id: 10, name: "Семья", icon: Icons.home),
    TransactionCategoryItem(id: 11, name: "Разное", icon: Icons.movie),
    TransactionCategoryItem(id: 12, name: "Бизнес", icon: Icons.business),
    TransactionCategoryItem(id: 13, name: "Благотворительность", icon: Icons.volunteer_activism),
    TransactionCategoryItem(id: 14, name: "Жена", icon: Icons.woman), // :)
    TransactionCategoryItem(id: 15, name: "Подарки", icon: Icons.card_giftcard),
    TransactionCategoryItem(id: 16, name: "Работа", icon: Icons.laptop),
    TransactionCategoryItem(id: 17, name: "Путешествия", icon: Icons.flight),
    TransactionCategoryItem(id: 18, name: "Здоровье", icon: Icons.local_hospital),
    TransactionCategoryItem(id: 19, name: "Образование", icon: Icons.school),
    TransactionCategoryItem(id: 20, name: "Культура", icon: Icons.theater_comedy),
    // Добавь больше категорий по мере необходимости
  ];
  final List<TransactionCategoryItem> incomeTransactionCategories = [TransactionCategoryItem(id: 21, name: "Зарплата", icon: Icons.work),
    TransactionCategoryItem(id: 22, name: "Аренда", icon: Icons.home),
    TransactionCategoryItem(id: 23, name: "Дивиденды", icon: Icons.account_balance),
    TransactionCategoryItem(id: 24, name: "Прочее", icon: Icons.account_balance_wallet),
  ];

  CategoryPickerWidget({super.key, required this.transactionType}); // Добавляем конструктор с типом транзакции

  @override
  // Добавляем WidgetRef ref
  Widget build(BuildContext context, WidgetRef ref) {
    // Выбираем список категорий в зависимости от типа транзакции
    final List<TransactionCategoryItem> categoriesToShow =
    transactionType == TransactionType.expense
        ? expenseTransactionCategories
        : incomeTransactionCategories; // Если не расход, значит доход (для этого виджета)

    int itemsPerPage = 16; // 4 ряда по 4 иконки (оставляем 16, как мы настроили ранее)
    int pageCount = (categoriesToShow.length / itemsPerPage).ceil();
    final PageController pageController = PageController();

    return Column(
      children: [
        SizedBox(
          height: 300, // Уменьшил высоту, чтобы умещалось 3 ряда
          child: PageView.builder(
            controller: pageController,
            itemCount: pageCount,
            itemBuilder: (context, pageIndex) {
              int start = pageIndex * itemsPerPage;
              int end = (start + itemsPerPage).clamp(0, categoriesToShow.length);
              List<TransactionCategoryItem> pageCategories = categoriesToShow.sublist(start, end);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4, // 4 колонки
                  childAspectRatio: 1, // Соотношение сторон для плитки
                  mainAxisSpacing: 4, // Вертикальный отступ
                  crossAxisSpacing: 4, // Горизонтальный отступ
                  children: pageCategories.map((transactionCategory) {
                    // 4. Создаем CategoryTile с обработчиком нажатия
                    return TransactionCategoryTile(
                      transactionCategory: transactionCategory,
                      onTap: () {
                        // Получаем notifier контроллера
                        final controller = ref.read(transactionCreateControllerProvider.notifier);
                        // Вызываем метод обновления категории
                        controller.updateTransactionCategory(transactionCategory.id);
                        // При выборе категории, возможно, нужно закрыть клавиатуру или сделать что-то еще
                        // Navigator.of(context).pop(); // Или другое действие
                        debugPrint('Category tapped: ${transactionCategory.name} (ID: ${transactionCategory.id})');
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
        if (pageCount > 1) ...[ // Показываем индикатор, только если страниц больше одной
          const SizedBox(height: 6),
          SmoothPageIndicator(
            controller: pageController,
            count: pageCount,
            effect: const ExpandingDotsEffect(
              dotHeight: 6,
              dotWidth: 6,
              activeDotColor: CustomColors.primary, // Используй свой основной цвет
              dotColor: CustomColors.mainLightGrey,
            ),
          ),
          const SizedBox(height: 6),
        ] else ... [
          const SizedBox(height: 20) // Добавляем отступ снизу, если индикатора нет
        ]
      ],
    );
  }
}


// TransactionCategoryTile остается без изменений в этой задаче
class TransactionCategoryTile extends StatelessWidget {
  final TransactionCategoryItem transactionCategory;
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
            Icon(transactionCategory.icon, size: 36, color: CustomColors.primary),
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