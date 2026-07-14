import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/settings_controller.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_section_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileSectionHeader(title: 'Preferences'),
            _menuCard(
              isDark,
              children: [
                Obx(
                  () => _switchTile(
                    isDark: isDark,
                    icon: Icons.notifications_none_outlined,
                    iconColor: AppColors.primary,
                    title: 'Notifications',
                    value: controller.notificationsEnabled.value,
                    onChanged: controller.toggleNotifications,
                  ),
                ),
                _separator(isDark),
                Obx(
                  () => _switchTile(
                    isDark: isDark,
                    icon: Icons.dark_mode_outlined,
                    iconColor: isDark ? Colors.white : Colors.black87,
                    title: 'Dark Mode',
                    value: themeController.themeMode.value == ThemeMode.dark,
                    onChanged: controller.toggleDarkMode,
                  ),
                ),
              ],
            ),

            const ProfileSectionHeader(title: 'Account'),
            _menuCard(
              isDark,
              children: [
                ProfileMenuTile(
                  icon: Icons.person_outline,
                  iconColor: AppColors.accentPink,
                  title: 'Edit Profile',
                  onTap: () => context.push(AppRoutes.profileEdit),
                ),
                _separator(isDark),
                ProfileMenuTile(
                  icon: Icons.lock_outline_rounded,
                  iconColor: AppColors.warning,
                  title: 'Change Password',
                  onTap: () => context.push(AppRoutes.profileChangePassword),
                ),
                _separator(isDark),
                ProfileMenuTile(
                  icon: Icons.shield_outlined,
                  iconColor: AppColors.info,
                  title: 'Privacy & Security',
                  onTap: () => context.push(AppRoutes.privacySecurity),
                ),
              ],
            ),

            const ProfileSectionHeader(title: 'About'),
            _menuCard(
              isDark,
              children: [
                ProfileMenuTile(
                  icon: Icons.description_outlined,
                  iconColor: Colors.grey,
                  title: 'Terms of Service',
                  onTap: () => context.push(AppRoutes.termsOfService),
                ),
                _separator(isDark),
                ProfileMenuTile(
                  icon: Icons.privacy_tip_outlined,
                  iconColor: Colors.grey,
                  title: 'Privacy Policy',
                  onTap: () => context.push(AppRoutes.privacyPolicy),
                ),
                _separator(isDark),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: isDark ? Colors.white54 : Colors.grey[400],
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Version',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '1.0.0',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(bool isDark, {required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1625) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2A2535) : AppColors.lightBorder,
          ),
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _separator(bool isDark) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: isDark ? const Color(0xFF2A2535) : AppColors.lightBorder,
    );
  }

  Widget _switchTile({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
