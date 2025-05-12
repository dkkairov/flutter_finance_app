// lib/features/transactions/domain/entities/account.dart

/// Represents an account in the application.
class Account {
  /// The unique identifier of the account.
  final int id;

  /// The name of the account.
  final String name;
  final double? balance;

  // Вы можете добавить другие поля из вашей бэкенд-модели, если они необходимы для UI:
  // final int? currencyId;
  // final bool? isActive;


  Account({
    required this.id,
    required this.name,
    this.balance,
    // Добавьте сюда другие поля, если вы решили их включить
    // this.currencyId,
    // this.isActive,
  });

  // Для работы с данными из бэкенда вам, вероятно, потребуется factory конструктор
  // для создания экземпляра Account из Map (JSON).
  // factory Account.fromJson(Map<String, dynamic> json) {
  //   return Account(
  //     id: json['id'] as int,
  //     name: json['name'] as String,
  //     // Пример маппинга других полей (убедитесь в правильности типов)
  //     // balance: (json['balance'] as num?)?.toDouble(),
  //     // currencyId: json['currency_id'] as int?,
  //     // isActive: json['is_active'] as bool?,
  //   );
  // }

  // Также полезно переопределить equals и hashCode для сравнения объектов Account
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Account &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Account{id: $id, name: $name}';
  }
}