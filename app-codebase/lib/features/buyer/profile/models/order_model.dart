class OrderModel {
  final String orderId;
  final DateTime date;
  final String status;
  final double totalAmount;
  final int itemCount;
  final List<String> productImageUrls;

  OrderModel({
    required this.orderId,
    required this.date,
    required this.status,
    required this.totalAmount,
    required this.itemCount,
    required this.productImageUrls,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'Processing',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      itemCount: json['itemCount'] ?? 0,
      productImageUrls: List<String>.from(json['productImageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'date': date.toIso8601String(),
    'status': status,
    'totalAmount': totalAmount,
    'itemCount': itemCount,
    'productImageUrls': productImageUrls,
  };
}
