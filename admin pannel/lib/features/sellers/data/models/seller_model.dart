import '../../domain/entities/seller_entity.dart';

class SellerModel extends SellerEntity {
  const SellerModel({
    required super.id,
    required super.shopName,
    required super.ownerName,
    required super.email,
    required super.phone,
    super.logoUrl,
    required super.joinedAt,
    required super.status,
    required super.kycStatus,
    required super.rating,
    required super.followers,
    required super.totalRevenue,
    required super.totalSales,
    required super.conversionRate,
    super.payoutsFrozen,
    super.livestreamsDisabled,
    super.auctionsDisabled,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json['id'] ?? '',
      shopName: json['shopName'] ?? '',
      ownerName: json['ownerName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      logoUrl: json['logoUrl'],
      joinedAt: DateTime.tryParse(json['joinedAt'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'pending',
      kycStatus: json['kycStatus'] ?? 'unverified',
      rating: (json['rating'] ?? 0).toDouble(),
      followers: json['followers'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      totalSales: json['totalSales'] ?? 0,
      conversionRate: (json['conversionRate'] ?? 0).toDouble(),
      payoutsFrozen: json['payoutsFrozen'] ?? false,
      livestreamsDisabled: json['livestreamsDisabled'] ?? false,
      auctionsDisabled: json['auctionsDisabled'] ?? false,
    );
  }
}
