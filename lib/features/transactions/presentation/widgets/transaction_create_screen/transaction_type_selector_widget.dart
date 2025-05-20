import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/generated/locale_keys.g.dart';
import '../../../../../features/common/theme/custom_colors.dart';
import '../../../../../features/common/theme/custom_text_styles.dart';
import '../../screens/transaction_create_screen.dart';

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
        backgroundColor: CustomColors.mainLightGrey,
        thumbColor: CustomColors.mainWhite,
        groupValue: selectedSegment,
        onValueChanged: (TransactionType? value) {
          if (value != null) {
            onValueChanged(value);
          }
        },
        children: <TransactionType, Widget>{
          TransactionType.expense: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(LocaleKeys.expense.tr(), style: CustomTextStyles.normalMedium),
          ),
          TransactionType.income: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(LocaleKeys.income.tr(), style: CustomTextStyles.normalMedium),
          ),
          TransactionType.transfer: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(LocaleKeys.transfer.tr(), style: CustomTextStyles.normalMedium),
          ),
        },
      ),
    );
  }
}