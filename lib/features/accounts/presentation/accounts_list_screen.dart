import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'account_screen.dart';

class AccountsListScreen extends StatelessWidget {
  const AccountsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text('Balance: 800 000 \$'),
        ),
        CupertinoPageScaffold(
          child: Column(
            children: [
              CupertinoListSection.insetGrouped(
                header: const Text('My Reminders'),
                children: <CupertinoListTile>[
                  CupertinoListTile.notched(
                    title: const Text('Open pull request'),
                    leading: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: CupertinoColors.activeGreen,
                    ),
                    trailing: const CupertinoListTileChevron(),
                    onTap:
                        () => Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (BuildContext context) {
                          return const AccountScreen();
                        },
                      ),
                    ),
                  ),
                  CupertinoListTile.notched(
                    title: const Text('Push to master'),
                    leading: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: CupertinoColors.systemRed,
                    ),
                    additionalInfo: const Text('Not available'),
                  ),
                  CupertinoListTile.notched(
                    title: const Text('View last commit'),
                    leading: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: CupertinoColors.activeOrange,
                    ),
                    additionalInfo: const Text('12 days ago'),
                    trailing: const CupertinoListTileChevron(),
                    onTap:
                        () => Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (BuildContext context) {
                          return AccountScreen();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              CupertinoButton.filled(onPressed: () {}, child: const Text('+ новый счёт')),
            ],
          ),
        ),
      ],
    );
  }
}
