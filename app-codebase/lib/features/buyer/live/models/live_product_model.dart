class LiveProductModel {
  final String id;
  final int number; // Live identification number (e.g. #1, #2)
  final String title;
  final double price;
  final String imageUrl;
  final bool isCurrentlyFeatured;
  final bool isUpcoming;
  final double rating;
  final int salesCount;
  final String? deliveryOption;
  final String? returnsOption;
  final String? flashSaleText;
  final String? description;
  final String? viewsText;

  LiveProductModel({
    required this.id,
    required this.number,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.isCurrentlyFeatured = false,
    this.isUpcoming = true,
    this.rating = 5.0,
    this.salesCount = 0,
    this.deliveryOption = 'Free 3-day delivery',
    this.returnsOption = 'Free returns',
    this.flashSaleText,
    this.description,
    this.viewsText,
  });

  factory LiveProductModel.fromJson(Map<String, dynamic> json) {
    return LiveProductModel(
      id: json['id'] as String,
      number: json['number'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      isCurrentlyFeatured: json['isCurrentlyFeatured'] as bool? ?? false,
      isUpcoming: json['isUpcoming'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      salesCount: json['salesCount'] as int? ?? 0,
      deliveryOption: json['deliveryOption'] as String? ?? 'Free 3-day delivery',
      returnsOption: json['returnsOption'] as String? ?? 'Free returns',
      flashSaleText: json['flashSaleText'] as String?,
      description: json['description'] as String?,
      viewsText: json['viewsText'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'isCurrentlyFeatured': isCurrentlyFeatured,
      'isUpcoming': isUpcoming,
      'rating': rating,
      'salesCount': salesCount,
      'deliveryOption': deliveryOption,
      'returnsOption': returnsOption,
      'flashSaleText': flashSaleText,
      'description': description,
      'viewsText': viewsText,
    };
  }
}
