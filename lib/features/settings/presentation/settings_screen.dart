import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../features/common/theme/custom_colors.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_item.dart';
import '../../../features/common/widgets/custom_list_view/custom_list_view_separated.dart';
import '../../common/widgets/custom_picker_fields/picker_item.dart';
import '../../common/widgets/custom_show_modal_bottom_sheet.dart';
import '../../currencies/data/models/currency_model.dart';
import '../../currencies/presentation/providers/currency_providers.dart';
import '../../projects/presentation/projects_screen.dart';
import '../../teams/presentation/screens/teams_screen.dart';
import 'categories_screen.dart';
import 'delete_options_screen.dart';
import 'package:easy_localization/easy_localization.dart'; // Импорт easy_localization

// --- Riverpod Providers ---
final settingsProvider = Provider((ref) => SettingsNotifier());
final themeModeProvider = StateProvider((ref) => ThemeMode.system);
final themeModeControllerProvider = Provider((ref) => ThemeModeController(ref));
final selectedLocaleProvider = StateProvider<Locale>((ref) => const Locale('ru', 'RU'));
final selectedCurrencyProvider = StateProvider<CurrencyModel?>((ref) => null);


class ThemeModeController {
  final Ref ref;
  ThemeModeController(this.ref);

  Future<void> setTheme(ThemeMode mode) async {
    ref.read(themeModeProvider.notifier).state = mode;
    // TODO: Здесь в будущем будет логика сохранения темы
  }
}

class SettingsNotifier {
  Future<void> navigateToExpenseCategories(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen('expense')));
  }

  Future<void> navigateToIncomeCategories(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen('income')));
  }

  Future<void> showLanguageSelectionBottomSheet(BuildContext context, WidgetRef ref) async {
    final availableLanguages = [
      // PickerItem(id: const Locale('kk', 'KZ'), displayValue: 'Қазақ'),
      PickerItem(id: const Locale('ru', 'RU'), displayValue: LocaleKeys.russian.tr()),
      PickerItem(id: const Locale('en', 'US'), displayValue: LocaleKeys.english.tr()),
    ];

    final pickedLocaleItem = await customShowModalBottomSheet<Locale>(
      context: context,
      title: LocaleKeys.selectLanguage.tr(), // Используем функцию tr() для локализации
      type: 'line',
      items: availableLanguages,
    );

    if (pickedLocaleItem != null) {
      ref.read(selectedLocaleProvider.notifier).state = pickedLocaleItem.id;
      context.setLocale(pickedLocaleItem.id); // Меняем локаль приложения
      print('Выбранный язык: ${pickedLocaleItem.id.languageCode}');
      // Здесь будет логика сохранения языка в настройки (например, в SharedPreferences)
    }
  }

  Future<void> showCurrencySelectionBottomSheet(BuildContext context, WidgetRef ref) async {
    final currenciesAsync = await ref.read(currenciesProvider.future);

    final pickedCurrency = await customShowModalBottomSheet<CurrencyModel>(
      context: context,
      title: LocaleKeys.selectCurrency.tr(),
      type: 'line',
      items: currenciesAsync
          .map((c) => PickerItem<CurrencyModel>(
        id: c,
        displayValue: '${c.symbol} ${c.name} (${c.code})',
      ))
          .toList(),
    );

    if (pickedCurrency != null) {
      ref.read(selectedCurrencyProvider.notifier).state = pickedCurrency.id;
      // TODO: сохранить валюту в SharedPreferences, если нужно
    }
  }


  void navigateToProjectsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProjectsScreen()),
    );
    // Launch app store
  }

  void navigateToTeamsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TeamsScreen()),
    );
    // Launch app store
  }

  void navigateToDeleteProfileAndData(BuildContext context) {
    print('Удаление');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DeleteOptionsScreen()),
    );
    // Launch app store
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
    ];

    return CustomListViewSeparated(
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
    );
  }
}