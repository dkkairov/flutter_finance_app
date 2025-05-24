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
  categoryType: json['category_type'] as String,
);

Map<String, dynamic> _$TransactionCategoryModelToJson(
  TransactionCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon': instance.icon,
  'category_type': instance.categoryType,
};

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
  id: json['id'] as String,
  name: json['name'] as String,
  balance: (json['balance'] as num).toDouble(),
  currencyCode: json['currency_code'] as String,
  currencySymbol: json['currency_symbol'] as String,
);

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'balance': instance.balance,
      'currency_code': instance.currencyCode,
      'currency_symbol': instance.currencySymbol,
    };

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) =>
    ProjectModel(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$ProjectModelToJson(ProjectModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      transactionType: json['transaction_type'] as String,
      transactionCategoryId: json['transaction_category_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      accountId: json['account_id'] as String,
      projectId: json['project_id'] as String?,
      description: json['description'] as String?,
      date: TransactionModel._dateTimeFromJson(json['date']),
      createdAt: TransactionModel._dateTimeFromJson(json['created_at']),
      updatedAt: TransactionModel._nullableDateTimeFromJson(json['updated_at']),
      deletedAt: TransactionModel._nullableDateTimeFromJson(json['deleted_at']),
      category:
          json['transaction_category'] == null
              ? null
              : TransactionCategoryModel.fromJson(
                json['transaction_category'] as Map<String, dynamic>,
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

Map<String, dynamic> _$TransactionModelToJson(
  TransactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'transaction_type': instance.transactionType,
  'transaction_category_id': instance.transactionCategoryId,
  'amount': instance.amount,
  'account_id': instance.accountId,
  'project_id': instance.projectId,
  'description': instance.description,
  'date': TransactionModel._dateTimeToJson(instance.date),
  'created_at': TransactionModel._dateTimeToJson(instance.createdAt),
  'updated_at': TransactionModel._nullableDateTimeToJson(instance.updatedAt),
  'deleted_at': TransactionModel._nullableDateTimeToJson(instance.deletedAt),
  'transaction_category': instance.category,
  'account': instance.account,
  'project': instance.project,
};
