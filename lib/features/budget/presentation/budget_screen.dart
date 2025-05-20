import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../features/common/theme/custom_colors.dart';
import '../../../features/common/widgets/custom_buttons/custom_primary_button.dart';
import '../../common/widgets/custom_draggable_scrollable_sheet.dart';
import '../../common/widgets/custom_text_form_field.dart'; // Импорт LocaleKeys

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final Map<String, double?> categoryBudgets = {
    'Groceries': 800,
    'Transport': 0,
    'Payments': 2500,
    'Cafes': null,
    'Clothes': 3000,
    'Entertainment': null,
    'Health': 400,
    'Gifts': 300,
    'Family': 500,
  };
  final Map<String, double?> categoryLimits = {
    'Groceries': 1000,
    'Transport': 2000,
    'Payments': 3300,
    'Cafes': null,
    'Clothes': 5000,
    'Entertainment': null,
    'Health': 5000,
    'Gifts': 20000,
    'Family': 1000,
  };

  @override
  Widget build(BuildContext context) {
    double totalSpent = categoryBudgets.values.fold<double>(
      0.0, // Начальное значение аккумулятора (0.0)
          (previousValue, currentValue) {
        if (currentValue != null) {
          return previousValue + currentValue;
        } else {
          return previousValue; // Пропускаем null значение
        }
      },
    );
    double totalBudget = categoryLimits.values.fold<double>(
      0.0, // Начальное значение аккумулятора (0.0)
          (previousValue, currentValue) {
        if (currentValue != null) {
          return previousValue + currentValue;
        } else {
          return previousValue; // Пропускаем null значение
        }
      },
    );
    double progress = totalSpent / totalBudget;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('MMMM yyyy').format(DateTime.now()), style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 8),
            Text('${totalSpent.toInt()} ₸', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: CustomColors.mainLightGrey,
              valueColor: AlwaysStoppedAnimation<Color>(CustomColors.mainBlue),
            ),
            Text('${LocaleKeys.totalBudgetForAMonth.tr()}: ${totalBudget.toInt()} ₸', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.8),
              itemCount: categoryBudgets.length,
              itemBuilder: (context, index) {
                String category = categoryBudgets.keys.elementAt(index);
                double? spent = categoryBudgets[category];
                double? limit = categoryLimits[category];
                double? progress;
                (spent != null && limit != null) ?  progress = spent / limit : 0;
                return CategoryWidget(
                  category: category.tr(), // Локализуем название категории
                  spent: spent,
                  limit: limit,
                  progress: progress,
                  onSetBudget: () => _setBudget(category),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _setBudget(String category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Позволяет листу занимать больше половины экрана
      backgroundColor: Colors.transparent, // Прозрачный фон, чтобы было видно скругление Container
      builder: (context) {
        double newLimit = categoryLimits[category] ?? 0;
        List<Widget> fields = [
          // Поле "Limit"
          CustomTextFormField(
            labelText: LocaleKeys.limit.tr(), // Лейбл поля -> LocaleKeys.limit
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            keyboardType: TextInputType.number,
            onChanged: (value) {
              newLimit = double.tryParse(value) ?? newLimit;
            },
          ),
          const SizedBox(height: 16), // Отступ между полями

          // Кнопка "Save"
          CustomPrimaryButton(
            onPressed: () {
              // TODO: Реализовать логику сохранения изменений счета
              setState(() {
                categoryLimits[category] = newLimit;
              });
              Navigator.pop(context);
            },
            text: LocaleKeys.save.tr(), // "Save" -> LocaleKeys.save
          ),
        ];
        return CustomDraggableScrollableSheet(fields: fields, title: '${LocaleKeys.setLimitFor.tr()} ${category.tr()}'); // Локализуем заголовок
      },
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String category;
  final double? spent;
  final double? limit;
  final double? progress;
  final VoidCallback onSetBudget;

  const CategoryWidget({super.key,
    required this.category,
    this.spent,
    this.limit,
    this.progress,
    required this.onSetBudget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: progress ?? 0,
                strokeWidth: 5,
                backgroundColor: progress != null ? CustomColors.mainGrey : CustomColors.background,
                valueColor: AlwaysStoppedAnimation<Color>(CustomColors.mainGreen),
              ),
            ),
            Icon(Icons.shopping_cart, size: 32),
          ],
        ),
        SizedBox(height: 4),
        Text(category, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        progress != null
            ? Text('${spent?.toInt()} / ${limit?.toInt()} ₸', style: TextStyle(fontSize: 12, color: Colors.black54))
            : ElevatedButton(
          onPressed: onSetBudget,
          style: ElevatedButton.styleFrom(
            foregroundColor: CustomColors.mainWhite,
            backgroundColor: CustomColors.mainBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            // Используем компактную визуальную плотность
            visualDensity: VisualDensity.compact,
          ),
          child: Icon(Icons.add),
        )
      ],
    );
  }
}