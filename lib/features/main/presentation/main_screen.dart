import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/add/presentation/add_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/reports/data/report_provider.dart';
import '../../../features/plans/data/plan_provider.dart';
import '../../../common/widgets/theme_toggle_button.dart';
import '../../../main.dart';
import '../../plans/presentation/plans_screen.dart';
import '../../reports/presentation/reports_screen.dart';
import '../../settings/presentation/settings_screen.dart';



class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportData = ref.watch(reportProvider);
    final planData = ref.watch(plansProvider);
    final currentScreenIndex = ref.watch(bottomNavProvider);
    final List<Widget> screens = [
      AddScreen(),
      PlansScreen(),
      const SettingsScreen(),
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Workspace 1'),
          actions: [ThemeToggleButton()],
        ),
        body: screens[currentScreenIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
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
                    (currentScreenIndex == 0) ? Icons.home : Icons.home_outlined),
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
              label: '',
              icon: Icon((currentScreenIndex == 1)
                  ? Icons.shopping_cart
                  : Icons.shopping_cart_outlined),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon((currentScreenIndex == 2)
                  ? Icons.account_circle
                  : Icons.account_circle_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
