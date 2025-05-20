import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../features/common/theme/custom_colors.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_item.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_view_separated.dart';
import 'category_report_screen.dart'; // Убедитесь, что путь правильный

// TODO: Создать и импортировать экран отчета по проектам (заглушку)
// import 'project_report_screen.dart';
import 'project_report_screen.dart';

// Экран Аналитики (соответствует левому экрану на скриншоте)
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List items = [
      [
        LocaleKeys.reportByCategories.tr(),
        Icons.chevron_right,
        const CategoryReportScreen(),
      ],
      [
        LocaleKeys.reportByProjects.tr(),
        Icons.chevron_right,
        const ProjectReportScreen(), // Заглушка, пока не реализован экран -> теперь импортирован
      ],
    ];
    return CustomListViewSeparated(
      items: items,
      itemBuilder: (context, item) { // item здесь имеет тип Account
        return CustomListItem(
          titleText: item[0], // Используем item[0] для заголовка (соответствует title в UI)
          trailing: Row( // Trailing остается виджетом Row, используем item.balance
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.chevron_right, color: CustomColors.mainGrey),
            ],
          ),
          onTap: item[2] != null
              ? () {
            // !!! НАВИГАЦИЯ НА ЭКРАН ОТЧЕТА ПО КАТЕГОРИЯМ
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => item[2]), // Передаем экран отчета по категориям
            );
          }
              : null, // Если item[2] == null, то не делаем ничего
        );
      },
    );
  }
}