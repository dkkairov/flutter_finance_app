// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_report_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectReportItemModel _$ProjectReportItemModelFromJson(
  Map<String, dynamic> json,
) => ProjectReportItemModel(
  projectId: json['projectId'] as String,
  projectName: json['projectName'] as String?,
  totalAmount: ProjectReportItemModel._doubleFromJson(json['totalAmount']),
  transactionCount: (json['transactionCount'] as num).toInt(),
);

Map<String, dynamic> _$ProjectReportItemModelToJson(
  ProjectReportItemModel instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'projectName': instance.projectName,
  'totalAmount': instance.totalAmount,
  'transactionCount': instance.transactionCount,
};
