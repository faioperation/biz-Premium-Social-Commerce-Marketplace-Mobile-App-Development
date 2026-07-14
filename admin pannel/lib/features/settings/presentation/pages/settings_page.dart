import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loader.dart';
import '../controllers/settings_controller.dart';
import '../widgets/general_settings_panel.dart';
import '../widgets/commerce_settings_panel.dart';
import '../widgets/security_settings_panel.dart';
import '../widgets/livestream_settings_panel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const _tabs = [
    _TabItem(icon: Icons.tune, label: 'General'),
    _TabItem(icon: Icons.storefront_outlined, label: 'Commerce'),
    _TabItem(icon: Icons.security, label: 'Security'),
    _TabItem(icon: Icons.live_tv_outlined, label: 'Livestream'),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Page Header ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Platform Settings', style: AppTextStyles.h2),
              const SizedBox(height: 4),
              Text(
                'Configure global platform behaviour, security policies and feature limits.',
                style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Tab Bar ──────────────────────────────────────────
              Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_tabs.length, (i) {
                    final isActive = controller.activeTab.value == i;
                    return GestureDetector(
                      onTap: () => controller.setActiveTab(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isActive ? AppColors.primary : (Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _tabs[i].icon,
                              size: 16,
                              color: isActive ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _tabs[i].label,
                              style: AppTextStyles.bodySm.copyWith(
                                color: isActive ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              )),
              const SizedBox(height: AppSpacing.lg),
              const Divider(height: 1),
            ],
          ),
        ),

        // ── Content ──────────────────────────────────────────────────
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: AppLoader());
            }

            if (controller.error.value.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                    const SizedBox(height: AppSpacing.md),
                    Text('Failed to load settings', style: AppTextStyles.h4),
                    const SizedBox(height: AppSpacing.sm),
                    Text(controller.error.value,
                        style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                    const SizedBox(height: AppSpacing.lg),
                    TextButton.icon(
                      onPressed: controller.loadAllSettings,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.contentPadding),
              child: _buildActivePanel(controller),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildActivePanel(SettingsController controller) {
    switch (controller.activeTab.value) {
      case 0:
        if (controller.generalSettings.value == null) {
          return const Center(child: AppLoader());
        }
        return GeneralSettingsPanel(
          controller: controller,
          settings: controller.generalSettings.value!,
        );

      case 1:
        if (controller.commerceSettings.value == null) {
          return const Center(child: AppLoader());
        }
        return CommerceSettingsPanel(
          controller: controller,
          settings: controller.commerceSettings.value!,
        );

      case 2:
        if (controller.securitySettings.value == null) {
          return const Center(child: AppLoader());
        }
        return SecuritySettingsPanel(
          controller: controller,
          settings: controller.securitySettings.value!,
        );

      case 3:
        if (controller.livestreamSettings.value == null) {
          return const Center(child: AppLoader());
        }
        return LivestreamSettingsPanel(
          controller: controller,
          settings: controller.livestreamSettings.value!,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  const _TabItem({required this.icon, required this.label});
}
