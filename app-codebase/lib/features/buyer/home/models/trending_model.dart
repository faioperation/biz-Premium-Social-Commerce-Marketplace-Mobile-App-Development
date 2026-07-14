class TrendingProductModel {
  final String id;
  final String name;
  final double currentPrice;
  final double originalPrice;
  final double rating;
  final String soldCount;
  final String imageUrl;
  final int discountPercentage;
  final bool isHot;

  TrendingProductModel({
    required this.id,
    required this.name,
    required this.currentPrice,
    required this.originalPrice,
    required this.rating,
    required this.soldCount,
    required this.imageUrl,
    required this.discountPercentage,
    this.isHot = false,
  });
}
