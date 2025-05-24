// lib/features/reports/presentation/project_report_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../common/theme/custom_colors.dart';
import '../../common/theme/custom_text_styles.dart';
import '../domain/models/category_report_params.dart'; // Используем те же параметры запроса
import 'filtered_transaction_list_screen.dart'; // Экран для списка транзакций категории (позже можно адаптировать для проектов)
import '../domain/models/project_report_item_model.dart'; // <--- НОВАЯ МОДЕЛЬ
import '../presentation/providers/report_providers.dart'; // <--- НОВЫЙ ПРОВАЙДЕР

// !!! Enum для выбора типа отчета (Расходы/Доходы)
enum ReportType {
  expenses,
  income,
}

// Экран Отчета по Проектам
class ProjectReportScreen extends ConsumerStatefulWidget {
  const ProjectReportScreen({super.key});

  @override
  ConsumerState<ProjectReportScreen> createState() => _ProjectReportScreenState();
}

class _ProjectReportScreenState extends ConsumerState<ProjectReportScreen> {
  ReportType _selectedReportType = ReportType.expenses;

  late DateTime _startDate;
  late DateTime _endDate;

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
        ref.invalidate(projectReportProvider(CategoryReportParams( // <--- ИСПОЛЬЗУЕМ projectReportProvider
          type: _selectedReportType == ReportType.expenses ? 'expense' : 'income',
          startDate: _startDate,
          endDate: _endDate,
        )));
      });
    }
  }

  // TODO: Здесь нужно будет создать ProjectTransactionListScreen
  // Или адаптировать CategoryTransactionListScreen для работы с project_id
  void _navigateToProjectTransactions(BuildContext context, ProjectReportItemModel project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilteredTransactionListScreen( // <--- ИСПОЛЬЗУЕМ НОВОЕ НАЗВАНИЕ
          projectId: project.projectId, // Передаем projectId
          title: project.projectName ?? LocaleKeys.no_project.tr(), // Используем projectName как заголовок
          transactionType: _selectedReportType == ReportType.expenses ? 'expense' : 'income',
          startDate: _startDate,
          endDate: _endDate,
          // accountId: null, // Если accountId опционален
          // categoryId: null, // Убедитесь, что categoryId не передается, если это проект
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

    // Watch провайдер для получения данных отчета по проектам
    final projectReportAsyncValue = ref.watch(projectReportProvider(reportParams)); // <--- ИСПОЛЬЗУЕМ projectReportProvider

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
          LocaleKeys.reportByProjects.tr(), // TODO: Добавить в локализацию
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
                    ref.invalidate(projectReportProvider(CategoryReportParams( // <--- ИСПОЛЬЗУЕМ projectReportProvider
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
          projectReportAsyncValue.when( // <--- ИСПОЛЬЗУЕМ projectReportAsyncValue
            data: (projects) {
              // Создаем копию и сортируем для UI
              List<ProjectReportItemModel> currentProjects = projects.toList();
              currentProjects.sort((a, b) {
                if (_selectedReportType == ReportType.expenses) {
                  return b.totalAmount.abs().compareTo(a.totalAmount.abs());
                } else {
                  return b.totalAmount.compareTo(a.totalAmount);
                }
              });

              final num totalAmount = currentProjects.fold(0.0, (sum, proj) => sum + proj.totalAmount.abs());

              if (currentProjects.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Text(LocaleKeys.no_data_for_this_period.tr()),
                  ),
                );
              }

              List<PieChartSectionData> _generateChartData() {
                return currentProjects.asMap().entries.map((entry) {
                  final project = entry.value;
                  final double percentage = totalAmount > 0
                      ? (project.totalAmount.abs() / totalAmount) * 100
                      : 0.0;
                  const double radius = 50;

                  return PieChartSectionData(
                    value: percentage,
                    color: project.color ?? Colors.grey, // Используем сгенерированный цвет
                    title: percentage > 0.0 ? '${percentage.toStringAsFixed(1)}%' : '',
                    radius: radius,
                    titlePositionPercentageOffset: 0.5,
                    titleStyle: CustomTextStyles.normalSmall.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  );
                }).toList();
              }

              return Expanded(
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

                    // Секция со списком проектов
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                        itemCount: currentProjects.length,
                        itemBuilder: (context, index) {
                          final project = currentProjects[index];
                          final double percentage = totalAmount > 0
                              ? (project.totalAmount.abs() / totalAmount) * 100
                              : 0.0;
                          final double fillWidthFactor = percentage / 100.0;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            elevation: 0.5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            child: InkWell(
                              onTap: () {
                                _navigateToProjectTransactions(context, project);
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
                                            color: project.color?.withOpacity(0.3),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                    child: Row(
                                      children: [
                                        // TODO: Отображать иконку проекта, если есть:
                                        // Image.network(project.projectIcon, width: 24, height: 24)
                                        // Icon(IconData(int.parse(project.projectIcon), fontFamily: 'MaterialIcons'))
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                project.projectName ?? LocaleKeys.no_project.tr(), // <--- ИСПОЛЬЗУЕМ projectName
                                                style: CustomTextStyles.normalMedium,
                                              ),
                                              Text(
                                                '${project.transactionCount} ${LocaleKeys.transaction.plural(project.transactionCount)}',
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
                                              '${_selectedReportType == ReportType.expenses ? project.totalAmount.abs().toStringAsFixed(0) : project.totalAmount.toStringAsFixed(0)} ${LocaleKeys.tenge_short.tr()}',
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
            error: (err, stack) => Expanded(child: Center(child: Text('${LocaleKeys.error_loading_report.tr()}: $err'))),
          ),
        ],
      ),
    );
  }
}