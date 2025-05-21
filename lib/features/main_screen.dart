import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/reports/presentation/reports_screen.dart';
import 'package:flutter_app_1/features/settings/presentation/settings_screen.dart';
import 'package:flutter_app_1/features/teams/presentation/providers/team_provider.dart';
import 'package:flutter_app_1/features/teams/presentation/widgets/team_selector_bottom_sheet.dart';
import 'package:flutter_app_1/features/transactions/presentation/screens/transaction_create_screen.dart';
import 'package:flutter_app_1/generated/locale_keys.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../main.dart'; // <--- ЭТОТ ИМПОРТ ТОЖЕ НЕ НУЖЕН ЗДЕСЬ

import '../main.dart';
import 'accounts/presentation/accounts_screen.dart';
import 'auth/presentation/providers/auth_providers.dart';
import 'budget/presentation/budget_screen.dart';
import 'common/theme/custom_colors.dart';
import 'common/theme/custom_text_styles.dart';
import 'common/widgets/custom_divider.dart';


class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScreenIndex = ref.watch(bottomNavProvider);
    final selectedTeam = ref.watch(selectedTeamProvider);
    final teamsAsyncValue = ref.watch(teamsProvider); // Watch для получения данных

    // НОВОЕ: Отслеживаем изменение teamsAsyncValue, чтобы установить selectedTeamIdProvider
    // Используем .when, чтобы обработать состояния загрузки/ошибки/данных
    teamsAsyncValue.when(
      data: (teams) {
        if (teams.isNotEmpty) {
          final currentSelectedTeamId = ref.read(selectedTeamIdProvider);
          // Если текущий выбранный ID null ИЛИ выбранной команды нет в списке
          // (например, была удалена или изменился пользователь)
          if (currentSelectedTeamId == null || !teams.any((t) => t.id == currentSelectedTeamId)) {
            // Устанавливаем ID первой команды как выбранный по умолчанию
            // В реальном приложении здесь может быть логика сохранения последней выбранной команды
            // или запрос у пользователя
            ref.read(selectedTeamIdProvider.notifier).state = teams.first.id;
            print('DEBUG: selectedTeamIdProvider updated to: ${teams.first.id}');
          }
        } else {
          // Если команд нет, убеждаемся, что teamId сброшен на null
          ref.read(selectedTeamIdProvider.notifier).state = null;
          print('DEBUG: No teams found, selectedTeamIdProvider set to null.');
        }
      },
      loading: () {
        // Пока загружаются команды, selectedTeamIdProvider остается в своем текущем состоянии (возможно, null)
        print('MainScreen: teamsProvider is still loading...');
      },
      error: (error, stack) {
        // При ошибке загрузки команд, также можно сбросить selectedTeamIdProvider
        ref.read(selectedTeamIdProvider.notifier).state = null;
        print('MainScreen: teamsProvider has error: $error. selectedTeamIdProvider set to null.');
      },
    );


    // Список экранов (остается без изменений)
    final List<Widget> screens = [
      const AccountsScreen(),
      BudgetScreen(),
      const TransactionCreateScreen(),
      const ReportsScreen(),
      SettingsScreen(),
    ];

    // !!! Карта для хранения заголовков AppBar для каждого экрана
    Map<int, String> appBarTitles = {
      0: LocaleKeys.accounts.tr(),
      1: LocaleKeys.budget.tr(),
      2: LocaleKeys.add.tr(),
      3: LocaleKeys.reports.tr(),
      4: LocaleKeys.settings.tr(),
    };

    // final double bottomNavigationBarIconsSize = 30.0; // Эта переменная не используется, можно удалить

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: appBarTitles.containsKey(currentScreenIndex)
              ? Text(
            appBarTitles[currentScreenIndex]!,
            style: CustomTextStyles.normalMedium.copyWith(
              color: CustomColors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          )
              : null,

          actions: [
            // Теперь selectedTeam может быть null, если команд нет или они еще не загрузились
            selectedTeam == null
                ? const SizedBox() // Пустой виджет, пока команда не выбрана/загружена
                : InkWell(
              onTap: () => showTeamSelectorBottomSheet(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(Icons.keyboard_arrow_down, size: 20, color: CustomColors.onPrimary),
                    const SizedBox(width: 4),
                    Text(
                      selectedTeam.name,
                      style: CustomTextStyles.normalMedium.copyWith(
                        color: CustomColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: screens[currentScreenIndex],
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomDivider(),
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: CustomColors.background,
              selectedItemColor: CustomColors.primary,
              selectedLabelStyle: CustomTextStyles.normalMedium.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: CustomColors.primary,
              ),
              unselectedItemColor: CustomColors.mainGrey,
              showSelectedLabels: true,
              elevation: 1.5,
              currentIndex: currentScreenIndex,
              onTap: (index) {
                ref.read(bottomNavProvider.notifier).state = index;
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: LocaleKeys.accounts.tr()),
                BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: LocaleKeys.budget.tr()),
                BottomNavigationBarItem(icon: Icon(Icons.add_circle_outlined, size: 40,), label: LocaleKeys.add.tr()),
                BottomNavigationBarItem(icon: Icon(Icons.analytics),label: LocaleKeys.reports.tr()),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: LocaleKeys.settings.tr()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}