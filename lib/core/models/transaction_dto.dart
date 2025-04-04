import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_dto.freezed.dart';
part 'transaction_dto.g.dart';

@freezed
class TransactionDto with _$TransactionDto {
  const factory TransactionDto({
    required int id,
    @JsonKey(name: 'userId') required int userId,
    @JsonKey(name: 'transactionType') required String transactionType,
    @JsonKey(name: 'transactionCategoryId') required int transactionCategoryId,
    required double amount,
    @JsonKey(name: 'accountId') int? accountId,
    @JsonKey(name: 'projectId') int? projectId,
    String? description,
    required DateTime date,
    @JsonKey(name: 'isActive') required bool isActive,
  }) = _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
