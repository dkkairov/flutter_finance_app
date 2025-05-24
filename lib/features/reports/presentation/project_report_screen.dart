import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../generated/locale_keys.g.dart';

import '../../common/theme/custom_colors.dart';
import '../../common/theme/custom_text_styles.dart';
import 'category_transaction_list_screen.dart'; // Убедитесь, что путь правильный


enum ReportType {
  expenses,
  income,
}


// ИЗМЕНЕНО: Добавлено поле 'id' для категории отчета
class _ReportCategory {
  final String id; // <--- ДОБАВЛЕНО: Уникальный ID категории
  final String name;
  final Color color;
  final int transactionCount;
  final num totalAmount;

  _ReportCategory({
    required this.id, // <--- ОБЯЗАТЕЛЬНОЕ ПОЛЕ
    required this.name,
    required this.color,
    required this.transactionCount,
    required this.totalAmount,
  });
}

// ИЗМЕНЕНО: Обновлены заглушечные данные с добавлением ID
final List<_ReportCategory> _dummyExpenseCategories = [
  _ReportCategory(id: 'cat-exp-001', name: 'Products', color: Colors.red.shade400, transactionCount: 15, totalAmount: -12000),
  _ReportCategory(id: 'cat-exp-002', name: 'Transport', color: Colors.blue.shade400, transactionCount: 8, totalAmount: -5000),
  _ReportCategory(id: 'cat-exp-003', name: 'Cafe & Restaurants', color: Colors.green.shade400, transactionCount: 10, totalAmount: -8000),
  _ReportCategory(id: 'cat-exp-004', name: 'Entertainments', color: Colors.purple.shade400, transactionCount: 5, totalAmount: -6000),
  _ReportCategory(id: 'cat-exp-005', name: 'Health', color: Colors.orange.shade400, transactionCount: 3, totalAmount: -3000),
  _ReportCategory(id: 'cat-exp-006', name: 'Other', color: Colors.grey.shade400, transactionCount: 7, totalAmount: -4000),
];

final List<_ReportCategory> _dummyIncomeCategories = [
  _ReportCategory(id: 'cat-inc-001', name: 'Salary', color: Colors.teal.shade400, transactionCount: 1, totalAmount: 150000),
  _ReportCategory(id: 'cat-inc-002', name: 'Gifts', color: Colors.pink.shade400, transactionCount: 2, totalAmount: 10000),
  _ReportCategory(id: 'cat-inc-003', name: 'Other Income', color: Colors.brown.shade400, transactionCount: 3, totalAmount: 5000),
];

final num _dummyTotalExpenses = _dummyExpenseCategories.fold(0.0, (sum, cat) => sum + cat.totalAmount.abs());
final num _dummyTotalIncome = _dummyIncomeCategories.fold(0.0, (sum, cat) => sum + cat.totalAmount);


class ProjectReportScreen extends StatefulWidget {
  const ProjectReportScreen({super.key});

  @override
  State<ProjectReportScreen> createState() => _ProjectReportScreenState();
}

class _ProjectReportScreenState extends State<ProjectReportScreen> {
  ReportType _selectedReportType = ReportType.expenses;

  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      // TODO: Настроить стили пикера даты
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        // TODO: Загрузить реальные данные отчета для выбранного диапазона дат
        // Здесь нужно будет вызвать логику загрузки данных, передавая _startDate, _endDate и _selectedReportType
      });
    }
  }

  // ИЗМЕНЕНО: Передаем все необходимые аргументы в CategoryTransactionListScreen
  void _navigateToCategoryTransactions(BuildContext context, _ReportCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryTransactionListScreen(
          categoryId: category.id, // <--- ПЕРЕДАНО
          categoryName: category.name, // <--- ПЕРЕДАНО
          transactionType: _selectedReportType == ReportType.expenses ? 'expense' : 'income', // <--- ПЕРЕДАНО
          startDate: _startDate, // <--- ПЕРЕДАНО
          endDate: _endDate, // <--- ПЕРЕДАНО
          // accountId: null, // Опционально, если нужно фильтровать по счету
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<_ReportCategory> currentCategories =
    _selectedReportType == ReportType.expenses
        ? _dummyExpenseCategories.toList()
        : _dummyIncomeCategories.toList();

    currentCategories.sort((a, b) {
      if (_selectedReportType == ReportType.expenses) {
        return b.totalAmount.abs().compareTo(a.totalAmount.abs());
      } else {
        return b.totalAmount.compareTo(a.totalAmount);
      }
    });

    final num totalAmount = _selectedReportType == ReportType.expenses
        ? _dummyTotalExpenses
        : _dummyTotalIncome;

    final DateFormat formatter = DateFormat('dd.MM.yy');
    final String formattedDateRange = '${formatter.format(_startDate)} - ${formatter.format(_endDate)}';

    final Map<ReportType, Widget> segmentChildren = {
      ReportType.expenses: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          LocaleKeys.expense.tr(),
        ),
      ),
      ReportType.income: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          LocaleKeys.income.tr(),
        ),
      ),
    };

    List<PieChartSectionData> _generateChartData() {
      return currentCategories.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        final double percentage = totalAmount > 0
            ? (category.totalAmount.abs() / totalAmount) * 100
            : 0.0;
        const double radius = 50;

        return PieChartSectionData(
          value: percentage,
          color: category.color,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: radius,
          titlePositionPercentageOffset: 0.5,
          titleStyle: CustomTextStyles.normalSmall.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.reportByCategories.tr(),
          style: CustomTextStyles.normalMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: CustomColors.onPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            child: CupertinoSlidingSegmentedControl<ReportType>(
              children: segmentChildren,
              backgroundColor: CustomColors.mainLightGrey,
              thumbColor: CustomColors.mainWhite,
              groupValue: _selectedReportType,
              onValueChanged: (ReportType? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedReportType = newValue;
                    // TODO: Загрузить реальные данные отчета для нового типа (Расходы/Доходы)
                    // Здесь нужно будет вызвать логику загрузки данных, передавая _selectedReportType и текущий диапазон дат
                  });
                }
              },
            ),
          ),

          InkWell(
            onTap: () => _selectDateRange(context),
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: CustomColors.mainLightGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Row(
                      children: [
                        Text(
                          formattedDateRange,
                          style: CustomTextStyles.normalMedium.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 8),
                        Icon(CupertinoIcons.chevron_down)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 60,
                      sections: _generateChartData(),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedReportType == ReportType.expenses ? '${LocaleKeys.totalExpenses.tr()}:' : '${LocaleKeys.totalIncome.tr()}:',
                        style: CustomTextStyles.normalSmall.copyWith(color: CustomColors.mainGrey),
                      ),
                      Text(
                        '${totalAmount.toStringAsFixed(0)} ${LocaleKeys.tenge_short.tr()}',
                        style: CustomTextStyles.normalMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
              itemCount: currentCategories.length,
              itemBuilder: (context, index) {
                final category = currentCategories[index];
                final double percentage = totalAmount > 0
                    ? (category.totalAmount.abs() / totalAmount) * 100
                    : 0.0;
                final double fillWidthFactor = percentage / 100.0;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  child: InkWell(
                    onTap: () {
                      print('Нажата категория: ${category.name}');
                      _navigateToCategoryTransactions(context, category);
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: fillWidthFactor,
                              heightFactor: 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: category.color.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category.name.tr(),
                                      style: CustomTextStyles.normalMedium,
                                    ),
                                    Text(
                                      '${category.transactionCount} ${LocaleKeys.transaction.plural(category.transactionCount)}',
                                      style: CustomTextStyles.normalSmall.copyWith(color: CustomColors.mainGrey),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${_selectedReportType == ReportType.expenses ? category.totalAmount.abs().toStringAsFixed(0) : category.totalAmount.toStringAsFixed(0)} ${LocaleKeys.tenge_short.tr()}',
                                    style: CustomTextStyles.normalMedium,
                                  ),
                                  Text(
                                    '${percentage.toStringAsFixed(1)} %',
                                    style: CustomTextStyles.normalSmall.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, color: CustomColors.mainGrey),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}