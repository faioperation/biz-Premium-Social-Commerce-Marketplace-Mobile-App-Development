class SellerEntity {
  final String id;
  final String shopName;
  final String ownerName;
  final String email;
  final String phone;
  final String? logoUrl;
  final DateTime joinedAt;
  
  // Statuses
  final String status; // pending, active, suspended, rejected
  final String kycStatus; // unverified, pending, approved, rejected
  
  // Metrics
  final double rating;
  final int followers;
  final double totalRevenue;
  final int totalSales;
  final double conversionRate;
  
  // Flags
  final bool payoutsFrozen;
  final bool livestreamsDisabled;
  final bool auctionsDisabled;

  const SellerEntity({
    required this.id,
    required this.shopName,
    required this.ownerName,
    required this.email,
    required this.phone,
    this.logoUrl,
    required this.joinedAt,
    required this.status,
    required this.kycStatus,
    required this.rating,
    required this.followers,
    required this.totalRevenue,
    required this.totalSales,
    required this.conversionRate,
    this.payoutsFrozen = false,
    this.livestreamsDisabled = false,
    this.auctionsDisabled = false,
  });

  SellerEntity copyWith({
    String? status,
    String? kycStatus,
    bool? payoutsFrozen,
    bool? livestreamsDisabled,
    bool? auctionsDisabled,
  }) {
    return SellerEntity(
      id: id,
      shopName: shopName,
      ownerName: ownerName,
      email: email,
      phone: phone,
      logoUrl: logoUrl,
      joinedAt: joinedAt,
      status: status ?? this.status,
      kycStatus: kycStatus ?? this.kycStatus,
      rating: rating,
      followers: followers,
      totalRevenue: totalRevenue,
      totalSales: totalSales,
      conversionRate: conversionRate,
      payoutsFrozen: payoutsFrozen ?? this.payoutsFrozen,
      livestreamsDisabled: livestreamsDisabled ?? this.livestreamsDisabled,
      auctionsDisabled: auctionsDisabled ?? this.auctionsDisabled,
    );
  }
}
