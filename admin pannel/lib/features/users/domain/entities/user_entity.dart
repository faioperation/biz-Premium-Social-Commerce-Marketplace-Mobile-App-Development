class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String status; // active, suspended, banned
  final double walletBalance;
  final bool isBiddingDisabled;
  final DateTime joinedAt;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.status,
    required this.walletBalance,
    required this.isBiddingDisabled,
    required this.joinedAt,
    this.avatarUrl,
  });

  // Helper method to create a copy with modifications
  UserEntity copyWith({
    String? status,
    bool? isBiddingDisabled,
    double? walletBalance,
  }) {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      status: status ?? this.status,
      walletBalance: walletBalance ?? this.walletBalance,
      isBiddingDisabled: isBiddingDisabled ?? this.isBiddingDisabled,
      joinedAt: joinedAt,
      avatarUrl: avatarUrl,
    );
  }
}
