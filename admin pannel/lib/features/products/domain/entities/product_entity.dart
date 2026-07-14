class ProductEntity {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stock;
  final String status; // pending, approved, rejected, disabled, featured
  final String sellerId;
  final String sellerName;
  final String sellerShopName;
  final List<String> imageUrls;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final DateTime createdAt;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
    required this.status,
    required this.sellerId,
    required this.sellerName,
    required this.sellerShopName,
    required this.imageUrls,
    required this.rating,
    required this.reviewCount,
    required this.isFeatured,
    required this.createdAt,
  });

  ProductEntity copyWith({
    String? status,
    bool? isFeatured,
  }) {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      category: category,
      price: price,
      stock: stock,
      status: status ?? this.status,
      sellerId: sellerId,
      sellerName: sellerName,
      sellerShopName: sellerShopName,
      imageUrls: imageUrls,
      rating: rating,
      reviewCount: reviewCount,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt,
    );
  }
}
