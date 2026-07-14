class CommerceSettingsEntity {
  final double commissionPercentage;
  final double minAuctionBidIncrement;
  final int auctionExtensionMinutes; // extend by X mins when bid in last N mins
  final int auctionExtensionTriggerMinutes;
  final bool autoApproveProducts;
  final double minOrderAmount;
  final double freeShippingThreshold;
  final List<String> supportedShippingZones;
  final bool allowInternationalShipping;
  final double defaultShippingFee;

  const CommerceSettingsEntity({
    required this.commissionPercentage,
    required this.minAuctionBidIncrement,
    required this.auctionExtensionMinutes,
    required this.auctionExtensionTriggerMinutes,
    required this.autoApproveProducts,
    required this.minOrderAmount,
    required this.freeShippingThreshold,
    required this.supportedShippingZones,
    required this.allowInternationalShipping,
    required this.defaultShippingFee,
  });

  CommerceSettingsEntity copyWith({
    double? commissionPercentage,
    double? minAuctionBidIncrement,
    int? auctionExtensionMinutes,
    int? auctionExtensionTriggerMinutes,
    bool? autoApproveProducts,
    double? minOrderAmount,
    double? freeShippingThreshold,
    List<String>? supportedShippingZones,
    bool? allowInternationalShipping,
    double? defaultShippingFee,
  }) {
    return CommerceSettingsEntity(
      commissionPercentage: commissionPercentage ?? this.commissionPercentage,
      minAuctionBidIncrement: minAuctionBidIncrement ?? this.minAuctionBidIncrement,
      auctionExtensionMinutes: auctionExtensionMinutes ?? this.auctionExtensionMinutes,
      auctionExtensionTriggerMinutes: auctionExtensionTriggerMinutes ?? this.auctionExtensionTriggerMinutes,
      autoApproveProducts: autoApproveProducts ?? this.autoApproveProducts,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      freeShippingThreshold: freeShippingThreshold ?? this.freeShippingThreshold,
      supportedShippingZones: supportedShippingZones ?? this.supportedShippingZones,
      allowInternationalShipping: allowInternationalShipping ?? this.allowInternationalShipping,
      defaultShippingFee: defaultShippingFee ?? this.defaultShippingFee,
    );
  }
}
