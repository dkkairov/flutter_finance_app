import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/add/presentation/add_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/reports/data/report_provider.dart';
import '../../../common/widgets/theme_toggle_button.dart';
import '../../../main.dart';
import '../../accounts/presentation/accounts_list_screen.dart';
import '../../budget/presentation/budget_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../transactions/presentation/screens/transactions_list_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final reportData = ref.watch(reportProvider);
    final currentScreenIndex = ref.watch(bottomNavProvider);
    final List<Widget> screens = [
      AddScreen(),
      AccountsListScreen(),
      BudgetScreen(),
      BudgetScreen(),
      TransactionListScreen(),
      // const SettingsScreen(),
    ];
    final bottomNavigationBarIconsSize = 30.0;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Личный'),
          actions: [ThemeToggleButton()],
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
            Navigator.of(context).pushReplacementNamed(screens[index] as String);
          },
          items: [
            BottomNavigationBarItem(
                label: '',
                icon: Icon(
                    Icons.add,
                    size: 40,
                    // color: (currentScreenIndex == 0)
                    //     ? Colors.amber
                    //     : Colors.white
                )
            ),
            BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.wallet,
                  size: bottomNavigationBarIconsSize,
                  // color: (currentScreenIndex == 1)
                  //   ? Colors.amber
                  //   : Colors.white
                )
            ),
            BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  CupertinoIcons.chart_pie_fill,
                  size: bottomNavigationBarIconsSize,
                ),
            ),
            BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  CupertinoIcons.chart_bar_fill,
                  size: bottomNavigationBarIconsSize,
                ),
            ),
            BottomNavigationBarItem(
                label: '',
                icon: Icon(
                    Icons.settings,
                  size: bottomNavigationBarIconsSize,
                    // color: (currentScreenIndex == 4)
                    //     ? Colors.amber
                    //     : Colors.white
                )
            ),
          ],
        ),
      ),
    );
  }
}
