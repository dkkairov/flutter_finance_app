import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_manager.dart';

class ThemeToggleButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return IconButton(
      icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
      onPressed: () {
        final newTheme = isDarkMode ? ThemeMode.light : ThemeMode.dark;
        ref.read(themeModeProvider.notifier).state = newTheme;
      },
    );
  }
}
