import '../../../../core/network/network_service.dart';
import '../../domain/entities/general_settings_entity.dart';
import '../../domain/entities/commerce_settings_entity.dart';
import '../../domain/entities/security_settings_entity.dart';
import '../../domain/entities/livestream_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  // ignore: unused_field
  final NetworkService _networkService;
  SettingsRepositoryImpl(this._networkService);

  // In-memory mock store (simulates persisted settings)
  GeneralSettingsEntity _generalSettings = const GeneralSettingsEntity(
    appName: 'Vango Live',
    appTagline: 'Shop. Stream. Sell.',
    logoUrl: 'https://placehold.co/200x60/6366f1/white?text=VangoLive',
    faviconUrl: 'https://placehold.co/32x32/6366f1/white?text=V',
    primaryColor: '#6366F1',
    supportEmail: 'support@vangolive.com',
    supportPhone: '+1-800-826-4687',
    timezone: 'Asia/Dhaka',
    currency: 'USD',
  );

  CommerceSettingsEntity _commerceSettings = const CommerceSettingsEntity(
    commissionPercentage: 12.5,
    minAuctionBidIncrement: 1.0,
    auctionExtensionMinutes: 5,
    auctionExtensionTriggerMinutes: 2,
    autoApproveProducts: false,
    minOrderAmount: 5.0,
    freeShippingThreshold: 50.0,
    supportedShippingZones: ['Domestic', 'USA', 'Canada', 'UK', 'Australia'],
    allowInternationalShipping: true,
    defaultShippingFee: 4.99,
  );

  SecuritySettingsEntity _securitySettings = const SecuritySettingsEntity(
    minPasswordLength: 8,
    requireUppercase: true,
    requireNumbers: true,
    requireSpecialChars: false,
    passwordExpiryDays: 90,
    maxLoginAttempts: 5,
    lockoutDurationMinutes: 30,
    enableTwoFactor: true,
    otpExpirySeconds: 300,
    otpLength: 6,
    allowSmsOtp: true,
    allowEmailOtp: true,
    blockedIpRanges: [],
    enforceAdminIpWhitelist: false,
  );

  LivestreamSettingsEntity _livestreamSettings = const LivestreamSettingsEntity(
    maxConcurrentStreams: 100,
    maxStreamDurationMinutes: 180,
    maxViewersPerStream: 10000,
    enableChatModeration: true,
    autoFilterProfanity: true,
    requireSellerVerificationToStream: true,
    minFollowerCountToStream: 10,
    enableGifts: true,
    enableAuctionDuringStream: true,
    streamCooldownMinutes: 30,
    bannedKeywords: ['spam', 'scam', 'fake'],
  );

  @override
  Future<GeneralSettingsEntity> getGeneralSettings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _generalSettings;
  }

  @override
  Future<void> saveGeneralSettings(GeneralSettingsEntity settings) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _generalSettings = settings;
  }

  @override
  Future<CommerceSettingsEntity> getCommerceSettings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _commerceSettings;
  }

  @override
  Future<void> saveCommerceSettings(CommerceSettingsEntity settings) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _commerceSettings = settings;
  }

  @override
  Future<SecuritySettingsEntity> getSecuritySettings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _securitySettings;
  }

  @override
  Future<void> saveSecuritySettings(SecuritySettingsEntity settings) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _securitySettings = settings;
  }

  @override
  Future<LivestreamSettingsEntity> getLivestreamSettings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _livestreamSettings;
  }

  @override
  Future<void> saveLivestreamSettings(LivestreamSettingsEntity settings) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _livestreamSettings = settings;
  }
}
