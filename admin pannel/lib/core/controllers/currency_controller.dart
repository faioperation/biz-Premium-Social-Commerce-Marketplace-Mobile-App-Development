import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/currency_config.dart';

class CurrencyController extends GetxController {
  static CurrencyController get to => Get.find<CurrencyController>();

  final _storage = GetStorage();
  final _storageKey = 'app_currency_config';

  final Rx<CurrencyConfig> currency = CurrencyConfig.defaultCurrency.obs;

  String get symbol => currency.value.symbol;

  @override
  void onInit() {
    super.onInit();
    _loadCurrency();
  }

  void _loadCurrency() {
    final savedData = _storage.read(_storageKey);
    if (savedData != null) {
      try {
        currency.value = CurrencyConfig.fromJson(Map<String, dynamic>.from(savedData));
      } catch (e) {
        currency.value = CurrencyConfig.defaultCurrency;
      }
    }
  }

  Future<void> updateCurrency(CurrencyConfig newConfig) async {
    currency.value = newConfig;
    await _storage.write(_storageKey, newConfig.toJson());
  }
}
