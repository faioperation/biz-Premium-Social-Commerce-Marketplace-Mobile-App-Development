import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'theme_mode';

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
    // Listen for changes and apply them via Get outside of any build phase
    ever(themeMode, (ThemeMode mode) {
      Get.changeThemeMode(mode);
    });
  }

  void _loadThemeMode() {
    final String? themeText = _box.read(_key);
    if (themeText == null) {
      themeMode.value = ThemeMode.system;
    } else {
      switch (themeText) {
        case 'light':
          themeMode.value = ThemeMode.light;
          break;
        case 'dark':
          themeMode.value = ThemeMode.dark;
          break;
        default:
          themeMode.value = ThemeMode.system;
      }
    }
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _box.write(_key, mode.name);
  }

  bool get isDarkMode {
    if (themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return themeMode.value == ThemeMode.dark;
  }
}

