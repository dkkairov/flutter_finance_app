// lib/features/reports/presentation/category_report_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <--- ДОБАВЛЕНО
import '../../../../generated/locale_keys.g.dart';
import '../../common/theme/custom_colors.dart';
import '../../common/theme/custom_text_styles.dart';
import '../domain/models/category_report_params.dart';
import 'category_transaction_list_screen.dart';
import '../domain/models/category_report_item_model.dart'; // <--- ДОБАВЛЕНО
import '../presentation/providers/report_providers.dart'; // <--- ДОБАВЛЕНО

// !!! Enum для выбора типа отчета (Расходы/Доходы)
enum ReportType {
  expenses,
  income,
}

// Экран Отчета по Категориям
class CategoryReportScreen extends ConsumerStatefulWidget { // <--- ИЗМЕНЕНО НА ConsumerStatefulWidget
  const CategoryReportScreen({super.key});

  @override
  ConsumerState<CategoryReportScreen> createState() => _CategoryReportScreenState(); // <--- ИЗМЕНЕНО
}

class _CategoryReportScreenState extends ConsumerState<CategoryReportScreen> { // <--- ИЗМЕНЕНО
  ReportType _selectedReportType = ReportType.expenses;

  late DateTime _startDate;
  late DateTime _endDate;

  final List<Color> pieColors = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.cyan,
    Colors.deepPurple,
    Colors.indigo,
    Colors.brown,
    Colors.pink,
    Colors.lightBlue,
    Colors.lime,
    Colors.deepOrange,
    // ...добавь сколько нужно цветов
  ];


  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0); // Последний день текущего месяца
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: CustomColors.primary, // Цвет выбранных дат
              onPrimary: CustomColors.onPrimary, // Цвет текста на primary
              surface: CustomColors.mainWhite, // Цвет фона календаря
              onSurface: CustomColors.mainDarkGrey, // Цвет текста на поверхности
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.mainBlue, // Цвет кнопок "ОК", "ОТМЕНА"
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        // После изменения даты, инициируем перезагрузку данных через Riverpod
        ref.invalidate(categoryReportProvider(CategoryReportParams(
          type: _selectedReportType == ReportType.expenses ? 'expense' : 'income',
          startDate: _startDate,
          endDate: _endDate,
        )));
      });
    }
  }

  void _navigateToCategoryTransactions(BuildContext context, CategoryReportItemModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryTransactionListScreen(
          categoryId: category.categoryId,
          categoryName: category.categoryName ?? '',
          transactionType: _selectedReportType == ReportType.expenses ? 'expense' : 'income',
          startDate: _startDate,
          endDate: _endDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Параметры для провайдера отчета
    final reportParams = CategoryReportParams(
      type: _selectedReportType == ReportType.expenses ? 'expense' : 'income',
      startDate: _startDate,
      endDate: _endDate,
    );

    // Watch провайдер для получения данных отчета
    final categoryReportAsyncValue = ref.watch(categoryReportProvider(reportParams));

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
                    // Автоматическая перезагрузка данных через Riverpod при смене типа
                    ref.invalidate(categoryReportProvider(CategoryReportParams(
                      type: _selectedReportType == ReportType.expenses ? 'expense' : 'income',
                      startDate: _startDate,
                      endDate: _endDate,
                    )));
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

          // Обработка состояний AsyncValue
          categoryReportAsyncValue.when(
            data: (categories) {
              // Создаем копию и сортируем для UI
              List<CategoryReportItemModel> currentCategories = categories.toList();
              currentCategories.sort((a, b) {
                if (_selectedReportType == ReportType.expenses) {
                  return b.totalAmount.abs().compareTo(a.totalAmount.abs());
                } else {
                  return b.totalAmount.compareTo(a.totalAmount);
                }
              });

              final num totalAmount = currentCategories.fold(0.0, (sum, cat) => sum + cat.totalAmount.abs());

              if (currentCategories.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Text(LocaleKeys.no_data_for_this_period.tr()), // TODO: Локализация
                  ),
                );
              }

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
                    color: pieColors[index % pieColors.length],
                    title: percentage > 0.0 ? '${percentage.toStringAsFixed(1)}%' : '', // Не показывать % если 0
                    radius: radius,
                    titlePositionPercentageOffset: 0.5,
                    titleStyle: CustomTextStyles.normalSmall.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  );
                }).toList();
              }

              return Expanded( // Расширяем дочерний элемент, чтобы он занял оставшееся пространство
                child: Column(
                  children: [
                    // Секция с кольцевой диаграммой
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
                                sectionsSpace: 2,
                                centerSpaceRadius: 60,
                                sections: _generateChartData(),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedReportType == ReportType.expenses ? LocaleKeys.totalExpenses.tr() : LocaleKeys.totalIncome.tr(),
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

                    // Секция со списком категорий
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
                          final color = pieColors[index % pieColors.length];

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            elevation: 0.5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            child: InkWell(
                              onTap: () {
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
                                            color: color.withOpacity(0.15),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                    child: Row(
                                      children: [
                                        // TODO: Отображать иконку категории:
                                        // Image.network(category.categoryIcon, width: 24, height: 24)
                                        // Icon(IconData(int.parse(category.categoryIcon), fontFamily: 'MaterialIcons'))
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                category.categoryName ?? '', // Используем categoryName из модели
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
            },
            loading: () => const Expanded(child: Center(child: CircularProgressIndicator())),
            error: (err, stack) => Expanded(child: Center(child: Text('${LocaleKeys.error_loading_report.tr()}: $err'))), // TODO: Локализация
          ),
        ],
      ),
    );
  }
}