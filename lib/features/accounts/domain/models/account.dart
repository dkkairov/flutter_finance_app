// lib/features/accounts/domain/models/account.dart (или твой текущий путь)

/// Represents an account in the application.
class Account {
  /// The unique identifier of the account.
  final String id; // Изменено на String для UUID

  /// The name of the account.
  final String name;
  final double? balance;
  final String? currencyId; // Добавлено, если есть в API
  final bool? isActive; // Добавлено, если есть в API

  Account({
    required this.id,
    required this.name,
    this.balance,
    this.currencyId, // Включено
    this.isActive,   // Включено
  });

  // Factory конструктор для создания экземпляра Account из Map (JSON).
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String, // Парсим как String
      name: json['name'] as String,
      balance: (json['balance'] as num?)?.toDouble(), // Может быть null
      currencyId: json['currency_id'] as String?, // Предполагаем, что это UUID
      isActive: json['is_active'] as bool?, // Предполагаем, что это bool
    );
  }

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
    return 'Account{id: $id, name: $name, balance: $balance, currencyId: $currencyId, isActive: $isActive}';
  }
}