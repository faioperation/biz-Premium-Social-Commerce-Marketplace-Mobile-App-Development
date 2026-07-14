class DiscoverProductModel {
  final String id;
  final String name;
  final double price;
  final double originalPrice;
  final int availableQuantity;
  final String imageUrl;
  final String categoryId;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final String sellerName;
  final String sellerProfileImage;
  final double sellerRating;
  final String description;
  final String subcategory;

  DiscoverProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.availableQuantity,
    required this.imageUrl,
    required this.categoryId,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
    required this.sellerName,
    required this.sellerProfileImage,
    required this.sellerRating,
    required this.description,
    required this.subcategory,
  });

  int get discountPercentage {
    if (originalPrice <= 0 || price >= originalPrice) return 0;
    return (((originalPrice - price) / originalPrice) * 100).round();
  }

  factory DiscoverProductModel.fromJson(Map<String, dynamic> json) {
    return DiscoverProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0.0).toDouble(),
      availableQuantity: json['availableQuantity'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      categoryId: json['categoryId'] ?? '',
      rating: (json['rating'] ?? 5.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      soldCount: json['soldCount'] ?? 0,
      sellerName: json['sellerName'] ?? '',
      sellerProfileImage: json['sellerProfileImage'] ?? '',
      sellerRating: (json['sellerRating'] ?? 5.0).toDouble(),
      description: json['description'] ?? '',
      subcategory: json['subcategory'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'originalPrice': originalPrice,
      'availableQuantity': availableQuantity,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'rating': rating,
      'reviewCount': reviewCount,
      'soldCount': soldCount,
      'sellerName': sellerName,
      'sellerProfileImage': sellerProfileImage,
      'sellerRating': sellerRating,
      'description': description,
      'subcategory': subcategory,
    };
  }
}
