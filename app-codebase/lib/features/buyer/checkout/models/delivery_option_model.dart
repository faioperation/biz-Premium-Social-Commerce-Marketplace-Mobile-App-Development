import 'package:ecommerce_bizsolutio/core/constants/app_constants.dart';

class DeliveryOptionModel {
  final String id;
  final String name;
  final String duration;
  final double price;

  DeliveryOptionModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
  });

  String get priceDisplay => price == 0.0
      ? 'FREE'
      : '${AppConstants.currencySymbol}${price.toStringAsFixed(2)}';

  factory DeliveryOptionModel.fromJson(Map<String, dynamic> json) {
    return DeliveryOptionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      duration: json['duration'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'duration': duration, 'price': price};
  }
}
