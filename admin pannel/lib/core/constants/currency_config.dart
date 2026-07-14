enum CurrencyPosition { left, right }

class CurrencyConfig {
  final String code;
  final String symbol;
  final String name;
  final CurrencyPosition position;

  const CurrencyConfig({
    required this.code,
    required this.symbol,
    required this.name,
    this.position = CurrencyPosition.left,
  });

  factory CurrencyConfig.fromJson(Map<String, dynamic> json) {
    return CurrencyConfig(
      code: json['code'] as String? ?? 'GBP',
      symbol: json['symbol'] as String? ?? '£',
      name: json['name'] as String? ?? 'British Pound',
      position: json['position'] == 'right' ? CurrencyPosition.right : CurrencyPosition.left,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'symbol': symbol,
      'name': name,
      'position': position == CurrencyPosition.right ? 'right' : 'left',
    };
  }

  static const CurrencyConfig defaultCurrency = CurrencyConfig(
    code: 'GBP',
    symbol: '£',
    name: 'British Pound',
    position: CurrencyPosition.left,
  );
}
