import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/core/theme/app_colors.dart';
import 'package:flutter_app_1/core/theme/app_text_styles.dart';
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
        backgroundColor: AppColors.mainLightGrey,
        thumbColor: AppColors.mainWhite,
        groupValue: selectedSegment,
        onValueChanged: (TransactionType? value) {
          if (value != null) {
            onValueChanged(value);
          }
        },
        children: <TransactionType, Widget>{
          TransactionType.expense: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Расход', style: AppTextStyles.normalMedium),
          ),
          TransactionType.income: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Доход', style: AppTextStyles.normalMedium),
          ),
          TransactionType.transfer: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Перевод', style: AppTextStyles.normalMedium),
          ),
        },
      ),
    );
  }
}