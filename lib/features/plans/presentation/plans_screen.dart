import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/plans/data/plan_provider.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_field.dart';

class PlansScreen extends ConsumerWidget {
  final TextEditingController incomePlanController = TextEditingController();
  final TextEditingController expensePlanController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansNotifier = ref.read(plansProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: incomePlanController, hintText: 'Планируемый доход'),
            SizedBox(height: 16),
            CustomTextField(controller: expensePlanController, hintText: 'Планируемые расходы'),
            SizedBox(height: 24),
            CustomButton(
              text: 'Сохранить план',
              onPressed: () async {
                final income = double.tryParse(incomePlanController.text) ?? 0.0;
                final expense = double.tryParse(expensePlanController.text) ?? 0.0;
                await plansNotifier.savePlan(income, expense);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
