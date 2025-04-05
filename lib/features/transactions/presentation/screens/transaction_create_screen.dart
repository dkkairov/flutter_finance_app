import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/transactions/presentation/widgets/sum_view_widget.dart';
import 'package:flutter_app_1/features/transactions/presentation/widgets/transaction_type_selector_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../widgets/additional_fields_widget.dart';
import '../widgets/category_picker_widget.dart';
import '../widgets/numeric_keypad_widget.dart';

enum TransactionType { expense, income, transfer}

class AddScreen extends ConsumerWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TransactionType selectedSegment = ref.watch(transactionTypeProvider);

    return Scaffold(
      body: Column(
        children: [
          TransactionTypeSelectorWidget(
            selectedSegment: selectedSegment,
            onValueChanged: (TransactionType value) {
              ref.read(transactionTypeProvider.notifier).state = value;
            },
          ),
          CategoryPickerWidget(),
          AdditionalFieldsWidget(),
          SumViewWidget(),
          NumericKeypadWidget(),
        ],
      ),
    );
  }
}