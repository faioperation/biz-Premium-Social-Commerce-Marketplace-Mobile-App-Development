class LivestreamSettingsEntity {
  final int maxConcurrentStreams;
  final int maxStreamDurationMinutes;
  final int maxViewersPerStream;
  final bool enableChatModeration;
  final bool autoFilterProfanity;
  final bool requireSellerVerificationToStream;
  final int minFollowerCountToStream;
  final bool enableGifts;
  final bool enableAuctionDuringStream;
  final int streamCooldownMinutes; // min time between streams for same seller
  final List<String> bannedKeywords;

  const LivestreamSettingsEntity({
    required this.maxConcurrentStreams,
    required this.maxStreamDurationMinutes,
    required this.maxViewersPerStream,
    required this.enableChatModeration,
    required this.autoFilterProfanity,
    required this.requireSellerVerificationToStream,
    required this.minFollowerCountToStream,
    required this.enableGifts,
    required this.enableAuctionDuringStream,
    required this.streamCooldownMinutes,
    required this.bannedKeywords,
  });

  LivestreamSettingsEntity copyWith({
    int? maxConcurrentStreams,
    int? maxStreamDurationMinutes,
    int? maxViewersPerStream,
    bool? enableChatModeration,
    bool? autoFilterProfanity,
    bool? requireSellerVerificationToStream,
    int? minFollowerCountToStream,
    bool? enableGifts,
    bool? enableAuctionDuringStream,
    int? streamCooldownMinutes,
    List<String>? bannedKeywords,
  }) {
    return LivestreamSettingsEntity(
      maxConcurrentStreams: maxConcurrentStreams ?? this.maxConcurrentStreams,
      maxStreamDurationMinutes: maxStreamDurationMinutes ?? this.maxStreamDurationMinutes,
      maxViewersPerStream: maxViewersPerStream ?? this.maxViewersPerStream,
      enableChatModeration: enableChatModeration ?? this.enableChatModeration,
      autoFilterProfanity: autoFilterProfanity ?? this.autoFilterProfanity,
      requireSellerVerificationToStream: requireSellerVerificationToStream ?? this.requireSellerVerificationToStream,
      minFollowerCountToStream: minFollowerCountToStream ?? this.minFollowerCountToStream,
      enableGifts: enableGifts ?? this.enableGifts,
      enableAuctionDuringStream: enableAuctionDuringStream ?? this.enableAuctionDuringStream,
      streamCooldownMinutes: streamCooldownMinutes ?? this.streamCooldownMinutes,
      bannedKeywords: bannedKeywords ?? this.bannedKeywords,
    );
  }
}
