import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    required super.status,
    required super.walletBalance,
    required super.isBiddingDisabled,
    required super.joinedAt,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      status: json['status'] ?? 'active',
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      isBiddingDisabled: json['isBiddingDisabled'] ?? false,
      joinedAt: DateTime.tryParse(json['joinedAt'] ?? '') ?? DateTime.now(),
      avatarUrl: json['avatarUrl'],
    );
  }
}
