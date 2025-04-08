import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/app_colors.dart';
import 'package:flutter_app_1/core/theme/app_text_styles.dart';
// Импортируем нужные провайдеры и контроллер
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../providers/transaction_controller.dart';

// 1. Добавляем ID в CategoryItem
class CategoryItem {
  final int id; // ID категории (должен совпадать с ID в базе данных)
  final String name;
  final IconData icon;
  CategoryItem({required this.id, required this.name, required this.icon});
}

// 2. Преобразуем в ConsumerWidget
class CategoryPickerWidget extends ConsumerWidget {
  // Добавляем примерные ID к категориям (ВАЖНО: замени на реальные ID из базы!)
  // Также убрал дубликаты для ясности
  final List<CategoryItem> categories = [
    CategoryItem(id: 1, name: "Питание вне дома", icon: Icons.wine_bar),
    CategoryItem(id: 2, name: "Продукты", icon: Icons.shopping_bag),
    CategoryItem(id: 3, name: "Одежда", icon: Icons.checkroom),
    CategoryItem(id: 4, name: "Ремонт", icon: Icons.format_paint),
    CategoryItem(id: 5, name: "Развлечения", icon: Icons.headset),
    CategoryItem(id: 6, name: "Спорт", icon: Icons.fitness_center),
    CategoryItem(id: 7, name: "Авто", icon: Icons.directions_car),
    CategoryItem(id: 8, name: "Коммуналка", icon: Icons.water_drop),
    CategoryItem(id: 9, name: "Дети", icon: Icons.baby_changing_station),
    CategoryItem(id: 10, name: "Семья", icon: Icons.home),
    CategoryItem(id: 11, name: "Разное", icon: Icons.movie),
    CategoryItem(id: 12, name: "Бизнес", icon: Icons.business),
    CategoryItem(id: 13, name: "Благотворительность", icon: Icons.volunteer_activism),
    CategoryItem(id: 14, name: "Жена", icon: Icons.woman), // :)
    CategoryItem(id: 15, name: "Подарки", icon: Icons.card_giftcard),
    CategoryItem(id: 16, name: "Работа", icon: Icons.laptop),
    CategoryItem(id: 17, name: "Путешествия", icon: Icons.flight),
    CategoryItem(id: 18, name: "Здоровье", icon: Icons.local_hospital),
    CategoryItem(id: 19, name: "Образование", icon: Icons.school),
    CategoryItem(id: 20, name: "Культура", icon: Icons.theater_comedy),
    // Добавь больше категорий по мере необходимости
  ];

  CategoryPickerWidget({super.key}); // Добавляем конструктор

  @override
  // Добавляем WidgetRef ref
  Widget build(BuildContext context, WidgetRef ref) {
    int itemsPerPage = 12; // 3 ряда по 4 иконки
    int pageCount = (categories.length / itemsPerPage).ceil();
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
              int end = (start + itemsPerPage).clamp(0, categories.length);
              List<CategoryItem> pageCategories = categories.sublist(start, end);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4, // 4 колонки
                  childAspectRatio: 1, // Соотношение сторон для плитки
                  mainAxisSpacing: 4, // Вертикальный отступ
                  crossAxisSpacing: 4, // Горизонтальный отступ
                  children: pageCategories.map((category) {
                    // 4. Создаем CategoryTile с обработчиком нажатия
                    return CategoryTile(
                      category: category,
                      onTap: () {
                        // Получаем notifier контроллера
                        final controller = ref.read(transactionCreateControllerProvider.notifier);
                        // Вызываем метод обновления категории (он сам проверит сумму и создаст транзакцию)
                        controller.updateCategory(category.id);
                        debugPrint('Category tapped: ${category.name} (ID: ${category.id})');
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
              activeDotColor: AppColors.primary, // Используй свой основной цвет
              dotColor: AppColors.mainLightGrey,
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


// 3. Делаем CategoryTile кликабельным и добавляем параметр onTap
class CategoryTile extends StatelessWidget {
  final CategoryItem category;
  final VoidCallback onTap; // Функция, которая будет вызвана при нажатии

  const CategoryTile({
    super.key,
    required this.category,
    required this.onTap, // Делаем onTap обязательным
  });

  @override
  Widget build(BuildContext context) {
    return InkWell( // Оборачиваем в InkWell для реакции на нажатия
      onTap: onTap, // Вызываем переданную функцию при нажатии
      borderRadius: BorderRadius.circular(8), // Скругляем область реакции для красоты
      child: Container(
        padding: const EdgeInsets.all(4.0), // Небольшой внутренний отступ
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 36, color: AppColors.primary), // Немного уменьшил иконку
            const SizedBox(height: 6),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: AppTextStyles.normalSmall,
              maxLines: 2, // Позволяем тексту переноситься на 2 строки
              overflow: TextOverflow.ellipsis, // Добавляем многоточие, если не влезает
            ),
          ],
        ),
      ),
    );
  }
}