import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'layout_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final LayoutController layoutController = Get.find<LayoutController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final bool isCollapsed = layoutController.isSidebarCollapsed.value;
      final double width = isCollapsed ? 72.0 : AppSpacing.sidebarWidth;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        width: width,
        decoration: BoxDecoration(
          color: isDark ? AppColors.sidebarDark : AppColors.sidebarLight,
          border: Border(
            right: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
        ),
        child: Column(
          children: [
            // ── Logo Area ──
            SizedBox(
              height: AppSpacing.headerHeight,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: isCollapsed
                    ? Center(
                        key: const ValueKey('icon'),
                        child: Image.asset(
                          'assets/images/client_logo.png',
                          width: 46,
                          height: 46,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Padding(
                        key: const ValueKey('full'),
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Center(
                          child: Image.asset(
                            'assets/images/client_logo.png',
                            width: 180,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
              ),
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),

            // ── Menu Items ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
                children: [
                  _SectionLabel(label: 'Overview', isCollapsed: isCollapsed, isDark: isDark),
                  _SidebarItem(icon: Icons.grid_view_rounded,      label: 'Dashboard',       route: '/',                  isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.bar_chart_rounded,      label: 'Analytics',       route: '/analytics',         isCollapsed: isCollapsed),

                  _SectionLabel(label: 'Commerce', isCollapsed: isCollapsed, isDark: isDark),
                  _SidebarItem(icon: Icons.people_alt_rounded,     label: 'Users',           route: '/users',             isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.storefront_rounded,     label: 'Sellers',         route: '/sellers',           isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.inventory_2_rounded,    label: 'Products',        route: '/products',          isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.shopping_bag_rounded,   label: 'Orders',          route: '/orders',            isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.account_balance_wallet_rounded, label: 'Wallets', route: '/wallets',           isCollapsed: isCollapsed),

                  _SectionLabel(label: 'Media', isCollapsed: isCollapsed, isDark: isDark),
                  _SidebarItem(icon: Icons.live_tv_rounded,        label: 'Livestreams',     route: '/livestreams',       isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.gavel_rounded,          label: 'Auctions',        route: '/auctions',          isCollapsed: isCollapsed),

                  _SectionLabel(label: 'Support', isCollapsed: isCollapsed, isDark: isDark),
                  _SidebarItem(icon: Icons.flag_rounded,           label: 'Reports',         route: '/reports',           isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.support_agent_rounded,  label: 'Support Tickets', route: '/support-tickets',   isCollapsed: isCollapsed),
                  _SidebarItem(icon: Icons.notifications_rounded,  label: 'Notifications',   route: '/notifications',     isCollapsed: isCollapsed),

                  Divider(
                    height: AppSpacing.lg,
                    thickness: 1,
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                  _SidebarItem(icon: Icons.settings_rounded,      label: 'Settings',        route: '/settings',          isCollapsed: isCollapsed),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
// Section Label
// ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isCollapsed;
  final bool isDark;

  const _SectionLabel({required this.label, required this.isCollapsed, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Center(
          child: Container(
            width: 24,
            height: 1,
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 4),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.overline.copyWith(
          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sidebar Item
// ─────────────────────────────────────────────
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isCollapsed;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();
    final bool isSelected = currentRoute == route ||
        (route != '/' && currentRoute.startsWith(route));

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color activeColor    = AppColors.primary;
    final Color inactiveColor  = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final Color activeBg       = isDark ? AppColors.selectedDark : AppColors.selectedLight;
    final Color hoverBg        = isDark ? AppColors.hoverDark     : AppColors.hoverLight;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            context.go(route);
            if (Scaffold.of(context).hasDrawer && Scaffold.of(context).isDrawerOpen) {
              Get.find<LayoutController>().closeDrawer();
            }
          },
          borderRadius: BorderRadius.circular(8),
          hoverColor: isSelected ? activeBg : hoverBg,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              vertical: 9,
              horizontal: isCollapsed ? 0 : 10,
            ),
            decoration: BoxDecoration(
              color: isSelected ? activeBg : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: isCollapsed
                ? Tooltip(
                    message: label,
                    preferBelow: false,
                    child: Center(
                      child: Icon(
                        icon,
                        color: isSelected ? activeColor : inactiveColor,
                        size: 20,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 3,
                        height: 18,
                        decoration: BoxDecoration(
                          color: isSelected ? activeColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        icon,
                        color: isSelected ? activeColor : inactiveColor,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        label,
                        style: AppTextStyles.body.copyWith(
                          color: isSelected ? activeColor : inactiveColor,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
