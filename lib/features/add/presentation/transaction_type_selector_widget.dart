import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_screen.dart';

class TransactionTypeSelectorWidget extends StatelessWidget {
  final TransactionType selectedSegment;
  final ValueChanged<TransactionType> onValueChanged;

  const TransactionTypeSelectorWidget({
    super.key,
    required this.selectedSegment,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: CupertinoSlidingSegmentedControl<TransactionType>(
        backgroundColor: CupertinoColors.systemGrey2,
        thumbColor: skyColors[selectedSegment]!,
        groupValue: selectedSegment,
        onValueChanged: (TransactionType? value) {
          if (value != null) {
            onValueChanged(value);
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
    );
  }
}