class StoreProductModel {
  final String id;
  final String title;
  final double price;
  final String image; // Emoji or asset path

  StoreProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  factory StoreProductModel.fromJson(Map<String, dynamic> json) {
    return StoreProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
    };
  }
}

class StoreModel {
  final String id;
  final String name;
  final String category;
  final String avatar; // Emoji or asset path
  final int followers;
  final double rating;
  final int productsCount;
  final List<StoreProductModel> featuredProducts;
  final String? bannerImagePath;
  final String description;
  final String contactEmail;
  final String phoneNumber;
  final String shippingPolicy;
  final String returnPolicy;
  final String termsOfService;

  StoreModel({
    required this.id,
    required this.name,
    required this.category,
    required this.avatar,
    required this.followers,
    required this.rating,
    required this.productsCount,
    required this.featuredProducts,
    this.bannerImagePath,
    this.description = '',
    this.contactEmail = '',
    this.phoneNumber = '',
    this.shippingPolicy = '',
    this.returnPolicy = '',
    this.termsOfService = '',
  });

  StoreModel copyWith({
    String? id,
    String? name,
    String? category,
    String? avatar,
    int? followers,
    double? rating,
    int? productsCount,
    List<StoreProductModel>? featuredProducts,
    String? bannerImagePath,
    bool clearBanner = false,
    String? description,
    String? contactEmail,
    String? phoneNumber,
    String? shippingPolicy,
    String? returnPolicy,
    String? termsOfService,
  }) {
    return StoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      avatar: avatar ?? this.avatar,
      followers: followers ?? this.followers,
      rating: rating ?? this.rating,
      productsCount: productsCount ?? this.productsCount,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      bannerImagePath: clearBanner ? null : (bannerImagePath ?? this.bannerImagePath),
      description: description ?? this.description,
      contactEmail: contactEmail ?? this.contactEmail,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      shippingPolicy: shippingPolicy ?? this.shippingPolicy,
      returnPolicy: returnPolicy ?? this.returnPolicy,
      termsOfService: termsOfService ?? this.termsOfService,
    );
  }

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      avatar: json['avatar'] as String,
      followers: json['followers'] as int,
      rating: (json['rating'] as num).toDouble(),
      productsCount: json['productsCount'] as int,
      featuredProducts: (json['featuredProducts'] as List<dynamic>?)
              ?.map((item) => StoreProductModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      bannerImagePath: json['bannerImagePath'] as String?,
      description: json['description'] as String? ?? '',
      contactEmail: json['contactEmail'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      shippingPolicy: json['shippingPolicy'] as String? ?? '',
      returnPolicy: json['returnPolicy'] as String? ?? '',
      termsOfService: json['termsOfService'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'avatar': avatar,
      'followers': followers,
      'rating': rating,
      'productsCount': productsCount,
      'featuredProducts': featuredProducts.map((p) => p.toJson()).toList(),
      'bannerImagePath': bannerImagePath,
      'description': description,
      'contactEmail': contactEmail,
      'phoneNumber': phoneNumber,
      'shippingPolicy': shippingPolicy,
      'returnPolicy': returnPolicy,
      'termsOfService': termsOfService,
    };
  }
}
