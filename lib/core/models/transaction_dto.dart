import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_dto.freezed.dart';
part 'transaction_dto.g.dart';

@freezed
class TransactionDto with _$TransactionDto {
  const factory TransactionDto({
    required int id,
    @JsonKey(name: 'user_id', fromJson: _toInt) required int userId,
    @JsonKey(name: 'transaction_type', fromJson: _toTransactionType) required String transactionType,
    @JsonKey(name: 'transaction_category_id', fromJson: _toInt) required int transactionCategoryId,
    @JsonKey(fromJson: _toDouble) required double amount,
    @JsonKey(name: 'account_id', fromJson: _toIntNullable) int? accountId,
    @JsonKey(name: 'project_id', fromJson: _toIntNullable) int? projectId,
    String? description,
    required DateTime date,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  @override
  // TODO: implement accountId
  int? get accountId => throw UnimplementedError();

  @override
  // TODO: implement amount
  double get amount => throw UnimplementedError();

  @override
  // TODO: implement date
  DateTime get date => throw UnimplementedError();

  @override
  // TODO: implement description
  String? get description => throw UnimplementedError();

  @override
  // TODO: implement id
  int get id => throw UnimplementedError();

  @override
  // TODO: implement isActive
  bool get isActive => throw UnimplementedError();

  @override
  // TODO: implement projectId
  int? get projectId => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  // TODO: implement transactionCategoryId
  int get transactionCategoryId => throw UnimplementedError();

  @override
  // TODO: implement transactionType
  String get transactionType => throw UnimplementedError();

  @override
  // TODO: implement userId
  int get userId => throw UnimplementedError();
}
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

int? _toIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

String _toTransactionType(dynamic value) {
  const allowed = ['income', 'expense', 'transfer'];
  final str = value?.toString() ?? '';
  if (!allowed.contains(str)) {
    throw FormatException('Invalid transactionType: $str');
  }
  return str;
}
