import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'layout_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'responsive_builder.dart';
import '../theme/theme_controller.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final LayoutController layoutController = Get.find<LayoutController>();
    final ThemeController themeController   = Get.find<ThemeController>();
    final bool isMobile = ResponsiveBuilder.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Glass header: blurred background with translucent tint
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: AppSpacing.headerHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.85)
                : AppColors.surfaceLight.withValues(alpha: 0.9),
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? AppColors.borderDark.withValues(alpha: 0.6)
                    : AppColors.borderLight.withValues(alpha: 0.8),
              ),
            ),
          ),
          child: Row(
            children: [
              // ── Sidebar Toggle ──
              if (isMobile)
                _HeaderIconButton(
                  icon: Icons.menu_rounded,
                  onPressed: layoutController.openDrawer,
                  isDark: isDark,
                )
              else
                Obx(() => _HeaderIconButton(
                  icon: layoutController.isSidebarCollapsed.value
                      ? Icons.menu_rounded
                      : Icons.menu_open_rounded,
                  onPressed: layoutController.toggleSidebar,
                  isDark: isDark,
                )),

              const Spacer(),

              // ── Search ──
              if (!isMobile) ...[
                _SearchBar(isDark: isDark),
                const SizedBox(width: AppSpacing.sm),
              ],

              // ── Theme Toggle ──
              Obx(() {
                final mode = themeController.themeMode.value;
                IconData icon;
                if (mode == ThemeMode.light) {
                  icon = Icons.light_mode_rounded;
                } else if (mode == ThemeMode.dark) {
                  icon = Icons.dark_mode_rounded;
                } else {
                  icon = Icons.settings_system_daydream_rounded;
                }
                return PopupMenuButton<ThemeMode>(
                  tooltip: 'Theme',
                  onSelected: themeController.setThemeMode,
                  offset: const Offset(0, 44),
                  child: _HeaderIconButton(
                    icon: icon,
                    onPressed: null,
                    isDark: isDark,
                    isButton: false,
                  ),
                  itemBuilder: (context) => [
                    _themeMenuItem(ThemeMode.light,  Icons.light_mode_rounded,             'Light',  mode, isDark),
                    _themeMenuItem(ThemeMode.dark,   Icons.dark_mode_rounded,              'Dark',   mode, isDark),
                    _themeMenuItem(ThemeMode.system, Icons.settings_system_daydream_rounded,'System', mode, isDark),
                  ],
                );
              }),

              const SizedBox(width: AppSpacing.xs),

              // ── Notifications ──
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _HeaderIconButton(
                    icon: Icons.notifications_none_rounded,
                    onPressed: () {},
                    isDark: isDark,
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: AppSpacing.sm),

              // ── Profile ──
              _ProfileMenu(isMobile: isMobile, isDark: isDark),

              const SizedBox(width: AppSpacing.xs),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<ThemeMode> _themeMenuItem(
    ThemeMode value, IconData icon, String label, ThemeMode current, bool isDark) {
    final isSelected = current == value;
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 16,
            color: isSelected ? AppColors.primary
                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          const SizedBox(width: 10),
          Text(label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : null,
            )),
          if (isSelected) ...[
            const Spacer(),
            Icon(Icons.check_rounded, size: 14, color: AppColors.primary),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Search Bar
// ─────────────────────────────────────────────
class _SearchBar extends StatefulWidget {
  final bool isDark;
  const _SearchBar({required this.isDark});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _focused ? 320 : 280,
      height: 36,
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.hoverDark : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _focused
              ? AppColors.primary.withValues(alpha: 0.5)
              : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
          width: _focused ? 1.5 : 1,
        ),
        boxShadow: _focused
            ? [BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )]
            : [],
      ),
      child: Focus(
        onFocusChange: (hasFocus) => setState(() => _focused = hasFocus),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          style: AppTextStyles.body.copyWith(
            color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          decoration: InputDecoration(
            hintText: 'Search anything...',
            hintStyle: AppTextStyles.body.copyWith(
              color: widget.isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 40, maxHeight: 36),
            prefixIcon: Icon(
              Icons.search_rounded, size: 18,
              color: _focused ? AppColors.primary
                  : (widget.isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
            ),
            suffixIconConstraints: const BoxConstraints(minWidth: 40, maxHeight: 36),
            suffixIcon: !_focused
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: widget.isDark ? AppColors.borderDark : AppColors.borderLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('⌘K',
                            style: AppTextStyles.caption.copyWith(
                              color: widget.isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                            )),
                        ],
                      ),
                    ),
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Profile Menu
// ─────────────────────────────────────────────
class _ProfileMenu extends StatelessWidget {
  final bool isMobile;
  final bool isDark;

  const _ProfileMenu({required this.isMobile, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
      elevation: 8,
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text('A', style: AppTextStyles.h6.copyWith(color: Colors.white)),
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin',
                  style: AppTextStyles.h6.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                Text('admin@vango.live',
                  style: AppTextStyles.caption.copyWith(
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
              ],
            ),
            const SizedBox(width: 4),
            Icon(Icons.unfold_more_rounded, size: 16,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
          ],
        ],
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Row(children: [
            Icon(Icons.person_outline_rounded, size: 16,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            const SizedBox(width: 10),
            const Text('Profile'),
          ]),
        ),
        PopupMenuItem(
          child: Row(children: [
            Icon(Icons.settings_outlined, size: 16,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            const SizedBox(width: 10),
            const Text('Settings'),
          ]),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: Row(children: [
            const Icon(Icons.logout_rounded, size: 16, color: AppColors.error),
            const SizedBox(width: 10),
            const Text('Logout', style: TextStyle(color: AppColors.error)),
          ]),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Header Icon Button with press animation
// ─────────────────────────────────────────────
class _HeaderIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isDark;
  final bool isButton;

  const _HeaderIconButton({
    required this.icon,
    required this.isDark,
    this.onPressed,
    this.isButton = true,
  });

  @override
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<_HeaderIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      widget.icon,
      size: 20,
      color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
    );

    if (!widget.isButton) {
      return SizedBox(width: 36, height: 36, child: Center(child: iconWidget));
    }

    return ScaleTransition(
      scale: _scale,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: widget.onPressed,
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          borderRadius: BorderRadius.circular(8),
          hoverColor: widget.isDark ? AppColors.hoverDark : AppColors.hoverLight,
          child: SizedBox(width: 36, height: 36, child: Center(child: iconWidget)),
        ),
      ),
    );
  }
}
