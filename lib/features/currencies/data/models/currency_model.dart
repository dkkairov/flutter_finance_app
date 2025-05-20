class CurrencyModel {
  final String id;
  final String code;
  final String name;
  final String symbol;

  CurrencyModel({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'symbol': symbol,
  };
}
