import 'package:flutter/material.dart';
import 'package:flutter_app_1/common/widgets/custom_divider.dart';
import '../../../core/theme/app_colors.dart';
import 'account_screen.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text('Balance: 800 000 \$'),
              ),
            ),
            CustomDivider(),
            AccountListWidget(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: ElevatedButton(onPressed: () {}, child: Text('новый счет')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountListWidget extends StatelessWidget {
  AccountListWidget({super.key});

  final List<_BenefitItem> items = [
    _BenefitItem(
      icon: Icons.child_friendly,
      title: 'Пособия на ребенка',
      subtitle: 'На рождение и по уходу',
      showNew: false,
    ),
    _BenefitItem(
      icon: Icons.groups,
      title: 'Пособие для многодетных семей',
      showNew: true,
    ),
    _BenefitItem(
      icon: Icons.work_off,
      title: 'Выплаты при потере работы',
      showNew: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(0),
        itemCount: items.length + 1, // +1 для финального разделителя,
        separatorBuilder: (_, __) => CustomDivider(),
        itemBuilder: (context, index) {
        if (index > items.length - 1) {
          return const SizedBox();
        }
        final item = items[index];
        return ListTile(
          leading: Icon(item.icon, color: Colors.grey[700]),
          title: Text(item.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.showNew)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(color: AppColors.mainWhite, fontSize: 12),
                  ),
                ),
              Icon(Icons.chevron_right, color: AppColors.mainGrey),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountScreen()),
            );
          },
        );
        },
      ),
    );
  }
}

class _BenefitItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool showNew;

  _BenefitItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.showNew = false,
  });
}
