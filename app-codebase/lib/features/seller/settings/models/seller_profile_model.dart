class SellerProfileModel {
  final String name;
  final String mobile;
  final String address;
  final String imageUrl;

  const SellerProfileModel({
    required this.name,
    required this.mobile,
    required this.address,
    required this.imageUrl,
  });

  SellerProfileModel copyWith({
    String? name,
    String? mobile,
    String? address,
    String? imageUrl,
  }) {
    return SellerProfileModel(
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
