// lib/features/settings/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../features/common/theme/custom_colors.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_item.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../../auth/presentation/providers/auth_providers.dart'; // Предполагаем, что performLogout там же
import '../../common/widgets/custom_picker_fields/picker_item.dart';
import '../../common/widgets/custom_show_modal_bottom_sheet.dart';
import '../../currencies/data/models/currency_model.dart';
import '../../currencies/presentation/providers/currency_providers.dart';
import '../../projects/presentation/projects_screen.dart';
import '../../teams/presentation/screens/teams_screen.dart';
import '../../transaction_categories/presentation/transaction_categories_screen.dart';
import 'delete_options_screen.dart';
import 'package:easy_localization/easy_localization.dart';

// --- Riverpod Providers ---
final settingsProvider = Provider((ref) => SettingsNotifier());
final selectedLocaleProvider = StateProvider<Locale>((ref) => const Locale('ru', 'RU'));
final selectedCurrencyProvider = StateProvider<CurrencyModel?>((ref) => null);


class SettingsNotifier {
  // Навигация на категории расходов
  Future<void> navigateToExpenseCategories(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen('expense')));
  }

  // Навигация на категории доходов
  Future<void> navigateToIncomeCategories(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen('income')));
  }

  // Показать bottom sheet для выбора языка
  Future<void> showLanguageSelectionBottomSheet(BuildContext context, WidgetRef ref) async {
    final availableLanguages = [
      // ИЗМЕНЕНО: id: на value:
      // PickerItem(value: const Locale('kk', 'KZ'), displayValue: 'Қазақ'), // Если у вас есть казахский
      PickerItem(value: const Locale('ru', 'RU'), displayValue: LocaleKeys.russian.tr()),
      PickerItem(value: const Locale('en', 'US'), displayValue: LocaleKeys.english.tr()),
    ];

    final pickedLocaleItem = await customShowModalBottomSheet<Locale>(
      context: context,
      title: LocaleKeys.selectLanguage.tr(),
      type: 'line',
      items: availableLanguages,
    );

    if (pickedLocaleItem != null) {
      ref.read(selectedLocaleProvider.notifier).state = pickedLocaleItem.value; // Использование .value
      context.setLocale(pickedLocaleItem.value); // Меняем локаль приложения
      print('Выбранный язык: ${pickedLocaleItem.value.languageCode}');
      // Здесь будет логика сохранения языка в настройки (например, в SharedPreferences)
    }
  }
  // --- Главный метод Logout ---
  // ВНИМАНИЕ: Дубликат метода `logout` здесь УДАЛЕН.
  // Оставлен только один, корректно расположенный метод logout.
  Future<void> logout(BuildContext context, WidgetRef ref) async {
    // Подтверждение выхода
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('logoutConfirmationTitle'),
        content: Text('logoutConfirmationContent'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(LocaleKeys.cancel.tr())),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(LocaleKeys.logout.tr())),
        ],
      ),
    );
    if (confirm == true) {
      await performLogout(ref); // <--- ИЗМЕНЕНО: Прямой вызов performLogout
      if (context.mounted) {
        // Очищаем стек и переходим на экран логина
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('loggedOutSuccessfully')),
        );
      }
    }
  }


  // Показать bottom sheet для выбора валюты
  Future<void> showCurrencySelectionBottomSheet(BuildContext context, WidgetRef ref) async {
    final currenciesAsync = await ref.read(currenciesProvider.future);

    final pickedCurrency = await customShowModalBottomSheet<CurrencyModel>(
      context: context,
      title: LocaleKeys.selectCurrency.tr(),
      type: 'line',
      items: currenciesAsync
          .map((c) => PickerItem<CurrencyModel>(
        value: c, // ИЗМЕНЕНО: id: на value:
        displayValue: '${c.symbol} ${c.name} (${c.code})',
      ))
          .toList(),
    );

    if (pickedCurrency != null) {
      ref.read(selectedCurrencyProvider.notifier).state = pickedCurrency.value; // Использование .value
      // TODO: сохранить валюту в SharedPreferences, если нужно
    }
  }

  // Навигация на экран проектов
  void navigateToProjectsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProjectsScreen()),
    );
  }

  // Навигация на экран команд
  void navigateToTeamsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TeamsScreen()),
    );
  }

  // Навигация на экран удаления профиля и данных
  void navigateToDeleteProfileAndData(BuildContext context) {
    print('Удаление');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DeleteOptionsScreen()),
    );
  }
}

// --- UI Screen ---
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(selectedLocaleProvider);
    final selectedCurrency = ref.watch(selectedCurrencyProvider);
    final settings = ref.watch(settingsProvider);

    final settingsItems = [
      {
        'icon': Icons.trending_down,
        'title': LocaleKeys.expenseCategories.tr(),
        'subtitle': null,
        'onTap': () => settings.navigateToExpenseCategories(context),
      },
      {
        'icon': Icons.trending_up,
        'title': LocaleKeys.incomeCategories.tr(),
        'subtitle': null,
        'onTap': () => settings.navigateToIncomeCategories(context),
      },
      {
        'icon': Icons.language,
        'title': LocaleKeys.language.tr(),
        'trailing': Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              switch (currentLocale.languageCode) {
                'kk' => 'Қазақ',
                'ru' => LocaleKeys.russian.tr(),
                'en' => LocaleKeys.english.tr(),
                _ => '',
              },
            ),
            const Icon(Icons.chevron_right, color: CustomColors.mainGrey),
          ],
        ),
        'onTap': () => settings.showLanguageSelectionBottomSheet(context, ref),
      },
      {
        'icon': Icons.currency_exchange,
        'title': LocaleKeys.defaultCurrency.tr(),
        'trailing': Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedCurrency != null
                  ? '${selectedCurrency.symbol} ${selectedCurrency.name} (${selectedCurrency.code})'
                  : '-',
            ),
            const Icon(Icons.chevron_right, color: CustomColors.mainGrey),
          ],
        ),
        'onTap': () => settings.showCurrencySelectionBottomSheet(context, ref),
      },
      {
        'icon': Icons.star,
        'title': LocaleKeys.projects.tr(),
        'trailing': const Icon(Icons.chevron_right, color: CustomColors.mainGrey),
        'onTap': () => settings.navigateToProjectsScreen(context),
      },
      {
        'icon': Icons.work,
        'title': LocaleKeys.teams.tr(),
        'trailing': const Icon(Icons.chevron_right, color: CustomColors.mainGrey),
        'onTap': () => settings.navigateToTeamsScreen(context),
      },
      {
        'icon': Icons.delete,
        'title': LocaleKeys.deleteProfileAndData.tr(),
        'trailing': const Icon(Icons.chevron_right, color: CustomColors.mainGrey),
        'onTap': () => settings.navigateToDeleteProfileAndData(context),
      },
      {
        'icon': Icons.logout,
        'title': LocaleKeys.logout.tr(), // Локализация
        'trailing': const Icon(Icons.chevron_right, color: CustomColors.mainGrey),
        'onTap': () async {
          // Вызываем метод logout из settingsNotifier
          await settings.logout(context, ref);
        },
      }
    ];

    return Scaffold( // Добавлен Scaffold, так как CustomListViewSeparated обычно не является корневым виджетом экрана
      body: CustomListViewSeparated(
        items: settingsItems,
        itemBuilder: (context, item) {
          return CustomListItem(
            leading: Icon(item['icon'] as IconData, color: CustomColors.mainGrey),
            titleText: item['title'] as String,
            subtitleText: item['subtitle'] as String?,
            trailing: item.containsKey('trailing') ? item['trailing'] as Widget : const Icon(Icons.chevron_right, color: CustomColors.mainGrey),
            onTap: item['onTap'] as VoidCallback?,
          );
        },
      ),
    );
  }
}