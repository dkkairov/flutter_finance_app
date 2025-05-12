// lib/features/teams/presentation/widgets/team_selector_bottom_sheet.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/custom_divider.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../teams/domain/models/team.dart'; // Импорт модели Team
import '../../../teams/presentation/providers/team_provider.dart'; // Импорт teamProvider и selectedTeamProvider
// Убедитесь, что пути к AppColors и AppTextStyles правильные


// Этот виджет будет содержимым DraggableScrollableSheet
class TeamSelectorBottomSheet extends ConsumerWidget {
  const TeamSelectorBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Смотрим за выбранной командой, чтобы отметить ее
    final selectedTeam = ref.watch(selectedTeamProvider);
    // Получаем список всех команд
    final teams = ref.watch(teamsProvider);
    // Получаем notifier для обновления выбранной команды
    final selectedTeamNotifier = ref.read(selectedTeamProvider.notifier);


    return DraggableScrollableSheet(
      expand: false, // Не занимает всю высоту изначально
      initialChildSize: 0.4, // Начальная высота (40% от доступной)
      minChildSize: 0.2, // Минимальная высота
      maxChildSize: 0.8, // Максимальная высота
      builder: (context, scrollController) {
        return Container(
          // Добавляем скругленные углы сверху и фон
          decoration: const BoxDecoration(
            color: Colors.white, // Или цвет фона вашего приложения
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Шапка листа: Заголовок и кнопка закрытия
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.selectTeam.tr(), // Заголовок листа
                      style: CustomTextStyles.normalMedium.copyWith(fontWeight: FontWeight.bold), // Пример стиля
                    ),
                    // Кнопка закрытия листа
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Разделитель под шапкой
              CustomDivider(),
              // Список команд
              Expanded( // Expanded нужен, чтобы ListView занял оставшееся место в Column
                child: ListView.builder(
                  controller: scrollController, // Привязываем контроллер скролла листа
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    // Проверяем, является ли текущая команда выбранной
                    final isSelected = team.id == selectedTeam?.id;

                    return InkWell( // Делаем элемент списка нажимаемым
                      onTap: () {
                        // Обновляем выбранную команду через Provider
                        selectedTeamNotifier.state = team;
                        // Закрываем bottom sheet после выбора
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Название команды
                            Text(
                              team.name,
                              style: CustomTextStyles.normalMedium.copyWith(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? CustomColors.primary : CustomColors.mainDarkGrey, // Подсвечиваем выбранную
                              ),
                            ),
                            // Иконка галочки для выбранной команды
                            if (isSelected)
                              const Icon(Icons.check_circle, color: CustomColors.primary, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Вспомогательная функция для удобного показа bottom sheet'а
void showTeamSelectorBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Позволяет листу занимать больше половины экрана
    backgroundColor: Colors.transparent, // Прозрачный фон, чтобы было видно скругление Container
    builder: (context) => const TeamSelectorBottomSheet(),
  );
}