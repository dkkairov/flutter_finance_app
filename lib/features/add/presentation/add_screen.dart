import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/data/auth_provider.dart';
import '../../../main.dart';

enum TransactionType { expense, income, transfer}

Map<TransactionType, Color> skyColors = <TransactionType, Color>{
  TransactionType.expense: const Color(0xff191970),
  TransactionType.income: const Color(0xff40826d),
  TransactionType.transfer: const Color(0xff007ba7),
};

class AddScreen extends ConsumerWidget {
  AddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TransactionType selectedSegment = ref.watch(transactionTypeProvider);
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              CupertinoSlidingSegmentedControl<TransactionType>(
                backgroundColor: CupertinoColors.systemGrey2,
                thumbColor: skyColors[selectedSegment]!,
                // This represents the currently selected segmented control.
                groupValue: selectedSegment,
                // Callback that sets the selected segmented control.
                onValueChanged: (TransactionType? value) {
                  if (value != null) {
                    ref.read(transactionTypeProvider.notifier).state = value;
                  }
                },
                children: const <TransactionType, Widget>{
                  TransactionType.expense: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Midnight', style: TextStyle(color: CupertinoColors.white)),
                  ),
                  TransactionType.income: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Viridian', style: TextStyle(color: CupertinoColors.white)),
                  ),
                  TransactionType.transfer: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Cerulean', style: TextStyle(color: CupertinoColors.white)),
                  ),
                },
              ),
            ],
          )
        ],
      )
    );
  }
}
