// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_report_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryReportItemModel _$CategoryReportItemModelFromJson(
  Map<String, dynamic> json,
) => CategoryReportItemModel(
  categoryId: json['categoryId'] as String,
  categoryName: json['categoryName'] as String?,
  categoryIcon: json['icon'] as String?,
  categoryType: json['categoryType'] as String,
  transactionCount: (json['transactionCount'] as num).toInt(),
  totalAmount: CategoryReportItemModel._doubleFromJson(json['totalAmount']),
);

Map<String, dynamic> _$CategoryReportItemModelToJson(
  CategoryReportItemModel instance,
) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'icon': instance.categoryIcon,
  'categoryType': instance.categoryType,
  'transactionCount': instance.transactionCount,
  'totalAmount': instance.totalAmount,
};
