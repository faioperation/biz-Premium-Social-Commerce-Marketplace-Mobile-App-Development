import 'package:ecommerce_bizsolutio/core/constants/app_constants.dart';

class PaymentMethodModel {
  final String id;
  final String type;
  final String label;
  final String? last4;
  final String? expiry;
  final double? walletBalance;
  final bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.type,
    required this.label,
    this.last4,
    this.expiry,
    this.walletBalance,
    this.isDefault = false,
  });

  String get displayText {
    if (type == 'wallet')
      return 'Vango Wallet • ${AppConstants.currencySymbol}${walletBalance?.toStringAsFixed(2)}';
    if (type == 'cash') return 'Cash on Delivery';
    return '$label •••• $last4 | Exp: $expiry';
  }

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] ?? '',
      type: json['type'] ?? 'card',
      label: json['label'] ?? '',
      last4: json['last4'],
      expiry: json['expiry'],
      walletBalance: (json['walletBalance'] as num?)?.toDouble(),
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'label': label,
      'last4': last4,
      'expiry': expiry,
      'walletBalance': walletBalance,
      'isDefault': isDefault,
    };
  }
}
