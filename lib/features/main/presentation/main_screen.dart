import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../common/widgets/theme_toggle_button.dart';
import '../../accounts/presentation/accounts_screen.dart';
import '../../budget/presentation/budget_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../transactions/presentation/widgets/transactions_list_widget.dart';
import '../../transactions/presentation/screens/transaction_create_screen.dart';
import '../../../main.dart';
import '../../transactions/presentation/screens/transactions_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScreenIndex = ref.watch(bottomNavProvider);

    final List<Widget> screens = [
      const AddScreen(),
      const AccountsScreen(),
      BudgetScreen(),
      const TransactionsScreen(),
      SettingsScreen(),
    ];

    final double bottomNavigationBarIconsSize = 30.0;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Личный'),
        ),
        body: screens[currentScreenIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.mainGrey,
          showSelectedLabels: false,
          elevation: 1.5,
          currentIndex: currentScreenIndex,
          onTap: (index) {
            ref.read(bottomNavProvider.notifier).state = index;
          },
          items: [
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.add, size: 40),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.wallet, size: bottomNavigationBarIconsSize),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(CupertinoIcons.chart_pie_fill, size: bottomNavigationBarIconsSize),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(CupertinoIcons.chart_bar_fill, size: bottomNavigationBarIconsSize),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.settings, size: bottomNavigationBarIconsSize),
            ),
          ],
        ),
      ),
    );
  }
}
