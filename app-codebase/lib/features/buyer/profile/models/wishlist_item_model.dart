class WishlistItemModel {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final double originalPrice;
  final bool isInStock;

  WishlistItemModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    this.isInStock = true,
  });

  double get discountPercentage =>
      ((originalPrice - price) / originalPrice * 100).roundToDouble();

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      isInStock: json['isInStock'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'imageUrl': imageUrl,
    'price': price,
    'originalPrice': originalPrice,
    'isInStock': isInStock,
  };
}
