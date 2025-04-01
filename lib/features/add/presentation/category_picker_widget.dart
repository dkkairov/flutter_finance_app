import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/app_colors.dart';
import 'package:flutter_app_1/core/theme/app_text_styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CategoryPickerWidget extends StatelessWidget {
  final List<CategoryItem> categories = [
    CategoryItem("Питание вне дома", Icons.wine_bar),
    CategoryItem("Продукты", Icons.shopping_bag),
    CategoryItem("Одежда", Icons.checkroom),
    CategoryItem("Ремонт", Icons.format_paint),
    CategoryItem("Развлечения", Icons.headset),
    CategoryItem("Спорт", Icons.fitness_center),
    CategoryItem("Авто", Icons.directions_car),
    CategoryItem("Коммуналка", Icons.water_drop),
    CategoryItem("Дети", Icons.baby_changing_station),
    CategoryItem("Семья", Icons.home),
    CategoryItem("Разное", Icons.movie),
    CategoryItem("Бизнес", Icons.business),
    CategoryItem("Благотворительность", Icons.volunteer_activism),
    CategoryItem("Жена", Icons.woman),
    CategoryItem("Подарки", Icons.card_giftcard),
    CategoryItem("Работа", Icons.laptop),
    CategoryItem("Путешествия", Icons.flight),
    CategoryItem("Здоровье", Icons.local_hospital),
    CategoryItem("Образование", Icons.school),
    CategoryItem("Культура", Icons.theater_comedy),
    CategoryItem("Питание вне дома", Icons.wine_bar),
    CategoryItem("Продукты", Icons.shopping_bag),
    CategoryItem("Одежда", Icons.checkroom),
    CategoryItem("Ремонт", Icons.format_paint),
    CategoryItem("Развлечения", Icons.headset),
    CategoryItem("Спорт", Icons.fitness_center),
    CategoryItem("Авто", Icons.directions_car),
    CategoryItem("Коммуналка", Icons.water_drop),
    CategoryItem("Дети", Icons.baby_changing_station),
    CategoryItem("Семья", Icons.home),
    CategoryItem("Разное", Icons.movie),
    CategoryItem("Бизнес", Icons.business),
    CategoryItem("Благотворительность", Icons.volunteer_activism),
    CategoryItem("Жена", Icons.woman),
    CategoryItem("Подарки", Icons.card_giftcard),
    CategoryItem("Работа", Icons.laptop),
    CategoryItem("Путешествия", Icons.flight),
    CategoryItem("Здоровье", Icons.local_hospital),
    CategoryItem("Образование", Icons.school),
    CategoryItem("Культура", Icons.theater_comedy),
  ];

  @override
  Widget build(BuildContext context) {
    int itemsPerPage = 12;
    int pageCount = (categories.length / itemsPerPage).ceil();
    final PageController _pageController = PageController();

    return Column(
      children: [
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pageCount,
            itemBuilder: (context, pageIndex) {
              int start = pageIndex * itemsPerPage;
              int end = (start + itemsPerPage).clamp(0, categories.length);
              List<CategoryItem> pageCategories = categories.sublist(start, end);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  children: pageCategories.map((category) => CategoryTile(category: category)).toList(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: pageCount,
          effect: const ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.red,
            dotColor: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class CategoryItem {
  final String name;
  final IconData icon;
  CategoryItem(this.name, this.icon);
}

class CategoryTile extends StatelessWidget {
  final CategoryItem category;
  const CategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(category.icon, size: 40, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(category.name, textAlign: TextAlign.center, style: AppTextStyles.normalSmall),
        ],
      ),
    );
  }
}