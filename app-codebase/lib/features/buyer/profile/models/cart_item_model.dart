class CartItemModel {
  final String productId;
  final String name;
  final String sellerName;
  final String imageUrl;
  final double price;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.sellerName,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  double get subtotal => price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      sellerName: json['sellerName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'sellerName': sellerName,
    'imageUrl': imageUrl,
    'price': price,
    'quantity': quantity,
  };
}
