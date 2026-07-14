class ShopModel {
  final String id;
  final String name;
  final String profileImageUrl;
  final String coverImageUrl;
  final String location;
  final int followersCount;
  final double rating;
  final int responseRate;
  final String description;
  final bool isLive;

  ShopModel({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.coverImageUrl,
    required this.location,
    required this.followersCount,
    required this.rating,
    required this.responseRate,
    required this.description,
    required this.isLive,
  });
}
