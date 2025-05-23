// lib/features/accounts/domain/models/account.dart

class Account {
  final String id;
  final String teamId;
  final String name;
  final double? balance; // balance в Laravel 'decimal:2', поэтому double в Flutter, может быть null при определенных условиях?
  final String? currencyId; // currency_id может быть null, если не обязателен, или всегда есть?
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? updatedBy;
  final DateTime? syncedAt;

  Account({
    required this.id,
    required this.teamId,
    required this.name,
    this.balance, // Не required, если может быть null.
    this.currencyId, // Не required, если может быть null.
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.updatedBy,
    this.syncedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      name: json['name'] as String,
      // balance приходит как float/double из JSON, поэтому прямое приведение.
      // Используем as double? для null-safe парсинга.
      balance: (json['balance'] as num?)?.toDouble(),
      // currencyId может быть null или строкой
      currencyId: json['currencyId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
      updatedBy: json['updatedBy'] as String?,
      syncedAt: json['syncedAt'] != null ? DateTime.parse(json['syncedAt'] as String) : null,
    );
  }

  // Метод copyWith для удобного создания измененных копий объектов
  Account copyWith({
    String? id,
    String? teamId,
    String? name,
    double? balance,
    String? currencyId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? updatedBy,
    DateTime? syncedAt,
  }) {
    return Account(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      currencyId: currencyId ?? this.currencyId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }
}