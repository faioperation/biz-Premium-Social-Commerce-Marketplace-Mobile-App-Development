import '../entities/general_settings_entity.dart';
import '../entities/commerce_settings_entity.dart';
import '../entities/security_settings_entity.dart';
import '../entities/livestream_settings_entity.dart';

abstract class SettingsRepository {
  Future<GeneralSettingsEntity> getGeneralSettings();
  Future<void> saveGeneralSettings(GeneralSettingsEntity settings);

  Future<CommerceSettingsEntity> getCommerceSettings();
  Future<void> saveCommerceSettings(CommerceSettingsEntity settings);

  Future<SecuritySettingsEntity> getSecuritySettings();
  Future<void> saveSecuritySettings(SecuritySettingsEntity settings);

  Future<LivestreamSettingsEntity> getLivestreamSettings();
  Future<void> saveLivestreamSettings(LivestreamSettingsEntity settings);
}
