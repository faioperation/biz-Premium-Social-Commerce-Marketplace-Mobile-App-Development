class SellerProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String image;
  final List<String>? images;
  final String description;
  final String? video;
  final String? size;

  SellerProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.image,
    this.images,
    required this.description,
    this.video,
    this.size,
  });

  bool get isOutOfStock => stock <= 0;

  factory SellerProductModel.fromJson(Map<String, dynamic> json) {
    return SellerProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      image: json['image'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      description: json['description'] ?? '',
      video: json['video'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'image': image,
      'images': images,
      'description': description,
      'video': video,
      'size': size,
    };
  }
}
