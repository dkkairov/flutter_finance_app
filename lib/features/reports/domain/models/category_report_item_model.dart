// lib/features/reports/domain/models/category_report_item_model.dart

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_report_item_model.g.dart';

@JsonSerializable()
class CategoryReportItemModel {
  final String categoryId;
  final String? categoryName; // Оставьте nullable, если может быть null
  @JsonKey(name: 'icon') // <--- ДОБАВЬТЕ ЭТУ АННОТАЦИЮ!
  final String? categoryIcon; // <--- Это поле будет соответствовать 'icon' в JSON
  final String categoryType;
  final int transactionCount;
  @JsonKey(fromJson: _doubleFromJson)
  final double totalAmount;

  static double _doubleFromJson(dynamic value) {
    if (value == null) return 0.0;
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is num) return value.toDouble();
    return 0.0;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)

  CategoryReportItemModel({
    required this.categoryId,
    this.categoryName, // Оставьте nullable, если может быть null
    this.categoryIcon, // Если оно всегда есть, оставьте required
    required this.categoryType,
    required this.transactionCount,
    required this.totalAmount,
  });

  factory CategoryReportItemModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryReportItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryReportItemModelToJson(this);

  CategoryReportItemModel withGeneratedColor() {
    return CategoryReportItemModel(
      categoryId: categoryId,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      categoryType: categoryType,
      transactionCount: transactionCount,
      totalAmount: totalAmount,
    );
  }
}