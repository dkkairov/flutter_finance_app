import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/reports/presentation/reports_screen.dart';
import 'package:flutter_app_1/features/settings/presentation/settings_screen.dart';
import 'package:flutter_app_1/features/teams/presentation/providers/team_provider.dart';
import 'package:flutter_app_1/features/teams/presentation/widgets/team_selector_bottom_sheet.dart';
import 'package:flutter_app_1/features/transactions/presentation/screens/transaction_create_screen.dart';
import 'package:flutter_app_1/generated/locale_keys.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'accounts/presentation/accounts_screen.dart';
import 'budget/presentation/budget_screen.dart';
import 'common/theme/custom_colors.dart';
import 'common/theme/custom_text_styles.dart';
import 'common/widgets/custom_divider.dart';
import '../main.dart';


class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScreenIndex = ref.watch(bottomNavProvider);
    // !!! Смотрим за выбранной командой для отображения в AppBar
    final selectedTeam = ref.watch(selectedTeamProvider);

    // Список экранов (остается без изменений, убедитесь, что все const, где возможно)
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

    final double bottomNavigationBarIconsSize = 30.0;

    return SafeArea( // SafeArea обычно оборачивает Scaffold, а не его body
      child: Scaffold(
        appBar: AppBar(
          // !!! ИЗМЕНЕНО: Условный заголовок AppBar
          title: appBarTitles.containsKey(currentScreenIndex)
              ? Text(
            appBarTitles[currentScreenIndex]!,
            style: CustomTextStyles.normalMedium.copyWith(
              color: CustomColors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          )
              : null, // Если нет заголовка по умолчанию, можно оставить null

          actions: [
            selectedTeam == null
                ? const SizedBox()
                : InkWell(
              onTap: () {
                // При нажатии показываем bottom sheet выбора команды
                showTeamSelectorBottomSheet(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: CustomColors.onPrimary,
                    ),
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
        body: screens[currentScreenIndex], // Отображаем выбранный экран
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
                // Обновляем выбранный индекс навигационной панели
                ref.read(bottomNavProvider.notifier).state = index;
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: LocaleKeys.accounts.tr()),
                BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: LocaleKeys.budget.tr()),
                BottomNavigationBarItem(icon: Icon(Icons.add_circle_outlined, size: 40,), label: LocaleKeys.add.tr()), // "Add" -> LocaleKeys.add
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