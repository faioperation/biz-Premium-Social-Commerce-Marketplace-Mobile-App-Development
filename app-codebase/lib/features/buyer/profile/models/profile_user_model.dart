class ProfileUserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? bannerUrl;
  final String bio;
  final int followersCount;
  final int followingCount;
  final int profileViews;
  final int ordersCount;
  final int wishlistCount;
  final int loyaltyPoints;

  ProfileUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.bannerUrl,
    this.bio = '',
    this.followersCount = 0,
    this.followingCount = 0,
    this.profileViews = 0,
    this.ordersCount = 0,
    this.wishlistCount = 0,
    this.loyaltyPoints = 0,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      bannerUrl: json['bannerUrl'],
      bio: json['bio'] ?? '',
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      profileViews: json['profileViews'] ?? 0,
      ordersCount: json['ordersCount'] ?? 0,
      wishlistCount: json['wishlistCount'] ?? 0,
      loyaltyPoints: json['loyaltyPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
    'bannerUrl': bannerUrl,
    'bio': bio,
    'followersCount': followersCount,
    'followingCount': followingCount,
    'profileViews': profileViews,
    'ordersCount': ordersCount,
    'wishlistCount': wishlistCount,
    'loyaltyPoints': loyaltyPoints,
  };
}
