import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/providers/theme_provider.dart';
import '../../../common/widgets/section_list_view.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final controller = ref.read(themeModeControllerProvider);

    final themeMode = themeModeAsync.value ?? ThemeMode.system;

    final settingsItems = [
      SectionListItemModel(
        icon: Icons.language,
        title: 'Язык',
        subtitle: 'Русский',
        onTap: () {},
      ),
      SectionListItemModel(
        icon: Icons.currency_exchange,
        title: 'Валюта по умолчанию',
        subtitle: '₸ Тенге (KZT)',
        onTap: () {},
      ),
      SectionListItemModel(
        icon: Icons.dark_mode,
        title: 'Тема',
        subtitle: _themeModeText(themeMode),
        onTap: () => _showThemeBottomSheet(context, controller, themeMode),
      ),
      SectionListItemModel(
        icon: Icons.star_rate,
        title: 'Оценить приложение',
        onTap: () {},
      ),
    ];

    return Scaffold(
      body: SectionListView(items: settingsItems),
    );
  }

  String _themeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Светлая';
      case ThemeMode.dark:
        return 'Тёмная';
      case ThemeMode.system:
      default:
        return 'Системная';
    }
  }

  void _showThemeBottomSheet(BuildContext context, ThemeModeController controller, ThemeMode currentMode) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Тема',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            _buildThemeOption(context, controller, 'Системная', ThemeMode.system, currentMode == ThemeMode.system),
            _buildThemeOption(context, controller, 'Светлая', ThemeMode.light, currentMode == ThemeMode.light),
            _buildThemeOption(context, controller, 'Тёмная', ThemeMode.dark, currentMode == ThemeMode.dark),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildThemeOption(
      BuildContext context,
      ThemeModeController controller,
      String label,
      ThemeMode mode,
      bool selected,
      ) {
    return ListTile(
      title: Text(label),
      trailing: selected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () async {
        await controller.setTheme(mode);
        Navigator.of(context).pop();
      },
    );
  }
}