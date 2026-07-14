import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String _themeKey = 'isDarkMode';

  final Rx<ThemeMode> themeMode = ThemeMode.dark.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      setLightMode();
    } else {
      setDarkMode();
    }
  }

  void setDarkMode() {
    themeMode.value = ThemeMode.dark;
    _saveThemeToPrefs(true);
  }

  void setLightMode() {
    themeMode.value = ThemeMode.light;
    _saveThemeToPrefs(false);
  }

  void setSystemTheme() async {
    themeMode.value = ThemeMode.system;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeKey);
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_themeKey);

    if (isDarkMode == null) {
      themeMode.value = ThemeMode.system;
    } else {
      themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
  }

  Future<void> _saveThemeToPrefs(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }
}
