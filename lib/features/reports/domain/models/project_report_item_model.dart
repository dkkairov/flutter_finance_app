import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_report_item_model.g.dart';

@JsonSerializable()
class ProjectReportItemModel {
  final String projectId;
  final String? projectName;

  @JsonKey(fromJson: _doubleFromJson)
  final double totalAmount; // <- Вот тут
  final int transactionCount;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final Color? color;

  ProjectReportItemModel({
    required this.projectId,
    this.projectName,
    required this.totalAmount,
    required this.transactionCount,
    this.color,
  });

  factory ProjectReportItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectReportItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectReportItemModelToJson(this);

  ProjectReportItemModel withGeneratedColor() {
    return ProjectReportItemModel(
      projectId: projectId,
      projectName: projectName,
      totalAmount: totalAmount,
      transactionCount: transactionCount,
      color: Colors.primaries[projectId.hashCode.abs() % Colors.primaries.length],
    );
  }

  /// --- Добавьте эту функцию ---
  static double _doubleFromJson(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
