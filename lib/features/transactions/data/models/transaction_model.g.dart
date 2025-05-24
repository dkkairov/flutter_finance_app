// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCategoryModel _$TransactionCategoryModelFromJson(
  Map<String, dynamic> json,
) => TransactionCategoryModel(
  id: json['id'] as String,
  name: json['name'] as String,
  icon: json['icon'] as String?,
  categoryType: json['categoryType'] as String,
);

Map<String, dynamic> _$TransactionCategoryModelToJson(
  TransactionCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon': instance.icon,
  'categoryType': instance.categoryType,
};

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
  id: json['id'] as String,
  name: json['name'] as String,
  balance: (json['balance'] as num).toDouble(),
  currencyCode: json['currencyCode'] as String,
  currencySymbol: json['currencySymbol'] as String,
);

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'balance': instance.balance,
      'currencyCode': instance.currencyCode,
      'currencySymbol': instance.currencySymbol,
    };

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) =>
    ProjectModel(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$ProjectModelToJson(ProjectModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      transactionType: json['transactionType'] as String,
      transactionCategoryId: json['transactionCategoryId'] as String,
      amount: (json['amount'] as num).toDouble(),
      accountId: json['accountId'] as String,
      projectId: json['projectId'] as String?,
      description: json['description'] as String?,
      date: TransactionModel._dateTimeFromJson(json['date']),
      createdAt: TransactionModel._dateTimeFromJson(json['createdAt']),
      updatedAt: TransactionModel._nullableDateTimeFromJson(json['updatedAt']),
      deletedAt: TransactionModel._nullableDateTimeFromJson(json['deletedAt']),
      category:
          json['category'] == null
              ? null
              : TransactionCategoryModel.fromJson(
                json['category'] as Map<String, dynamic>,
              ),
      account:
          json['account'] == null
              ? null
              : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      project:
          json['project'] == null
              ? null
              : ProjectModel.fromJson(json['project'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'transactionType': instance.transactionType,
      'transactionCategoryId': instance.transactionCategoryId,
      'amount': instance.amount,
      'accountId': instance.accountId,
      'projectId': instance.projectId,
      'description': instance.description,
      'date': TransactionModel._dateTimeToJson(instance.date),
      'createdAt': TransactionModel._dateTimeToJson(instance.createdAt),
      'updatedAt': TransactionModel._nullableDateTimeToJson(instance.updatedAt),
      'deletedAt': TransactionModel._nullableDateTimeToJson(instance.deletedAt),
      'category': instance.category,
      'account': instance.account,
      'project': instance.project,
    };
