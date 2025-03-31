// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../features/reports/data/report_provider.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class ReportsScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final reportData = ref.watch(reportProvider);
//
//     return Scaffold(
//       body: reportData.when(
//         data: (data) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Text('Отчёт о доходах и расходах', style: Theme.of(context).textTheme.titleLarge),
//                 SizedBox(height: 16),
//                 Expanded(
//                   child: LineChart(
//                     LineChartData(
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: [FlSpot(0, data['income'].toDouble()), FlSpot(1, data['expense'].toDouble())],
//                           isCurved: true,
//                           barWidth: 3,
//                           color: Colors.blue,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//         loading: () => Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(child: Text('Ошибка загрузки отчётов')),
//       ),
//     );
//   }
// }
