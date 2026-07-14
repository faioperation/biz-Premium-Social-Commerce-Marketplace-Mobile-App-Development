import 'package:get/get.dart';
import '../../domain/entities/general_settings_entity.dart';
import '../../domain/entities/commerce_settings_entity.dart';
import '../../domain/entities/security_settings_entity.dart';
import '../../domain/entities/livestream_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsController extends GetxController {
  final SettingsRepository _repository;
  SettingsController(this._repository);

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString error = ''.obs;
  final RxString successMessage = ''.obs;

  // Settings data
  final Rx<GeneralSettingsEntity?> generalSettings = Rx(null);
  final Rx<CommerceSettingsEntity?> commerceSettings = Rx(null);
  final Rx<SecuritySettingsEntity?> securitySettings = Rx(null);
  final Rx<LivestreamSettingsEntity?> livestreamSettings = Rx(null);

  // Active tab index
  final RxInt activeTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllSettings();
  }

  Future<void> loadAllSettings() async {
    try {
      isLoading.value = true;
      error.value = '';
      final results = await Future.wait([
        _repository.getGeneralSettings(),
        _repository.getCommerceSettings(),
        _repository.getSecuritySettings(),
        _repository.getLivestreamSettings(),
      ]);
      generalSettings.value = results[0] as GeneralSettingsEntity;
      commerceSettings.value = results[1] as CommerceSettingsEntity;
      securitySettings.value = results[2] as SecuritySettingsEntity;
      livestreamSettings.value = results[3] as LivestreamSettingsEntity;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveGeneralSettings(GeneralSettingsEntity settings) async {
    return _save(() async {
      await _repository.saveGeneralSettings(settings);
      generalSettings.value = settings;
    });
  }

  Future<bool> saveCommerceSettings(CommerceSettingsEntity settings) async {
    return _save(() async {
      await _repository.saveCommerceSettings(settings);
      commerceSettings.value = settings;
    });
  }

  Future<bool> saveSecuritySettings(SecuritySettingsEntity settings) async {
    return _save(() async {
      await _repository.saveSecuritySettings(settings);
      securitySettings.value = settings;
    });
  }

  Future<bool> saveLivestreamSettings(LivestreamSettingsEntity settings) async {
    return _save(() async {
      await _repository.saveLivestreamSettings(settings);
      livestreamSettings.value = settings;
    });
  }

  Future<bool> _save(Future<void> Function() action) async {
    try {
      isSaving.value = true;
      error.value = '';
      successMessage.value = '';
      await action();
      successMessage.value = 'Settings saved successfully.';
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  void setActiveTab(int index) => activeTab.value = index;
}
