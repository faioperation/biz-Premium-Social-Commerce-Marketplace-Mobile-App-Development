import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/app_share_service.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_section_header.dart';
import '../../../../routes/app_routes.dart';
import '../../../auth/controllers/auth_controller.dart';

class BuyerProfileScreen extends StatelessWidget {
  const BuyerProfileScreen({super.key});

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        final user = controller.user.value;
        if (user == null) return const SizedBox.shrink();

        return DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Banner and Avatar Stack
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2A2535) : const Color(0xFFE5E7EB),
                              image: user.bannerUrl != null
                                  ? DecorationImage(
                                      image: user.bannerUrl!.startsWith('http')
                                          ? NetworkImage(user.bannerUrl!)
                                          : FileImage(File(user.bannerUrl!)) as ImageProvider,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                          // Top Navigation Bar
                          Positioned(
                            top: MediaQuery.of(context).padding.top + 10,
                            left: 16,
                            right: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 48), // Replaces the add person icon
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => context.push(AppRoutes.profileSettings),
                                  icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                                ),
                              ],
                            ),
                          ),
                          // Avatar
                          Positioned(
                            bottom: -45,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark ? Colors.black : const Color(0xFFF8F9FC),
                                    width: 4,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: AppColors.primary,
                                  backgroundImage: user.avatarUrl != null 
                                      ? (user.avatarUrl!.startsWith('http')
                                          ? NetworkImage(user.avatarUrl!)
                                          : FileImage(File(user.avatarUrl!)) as ImageProvider)
                                      : null,
                                  child: user.avatarUrl == null
                                      ? Text(
                                          user.initials,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 55),
                      // User Info
                      Text(
                        '@${user.name.replaceAll(' ', '').toLowerCase()}',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => context.push(AppRoutes.following),
                            child: _buildStatColumn(_formatCount(user.followingCount), 'Following', isDark),
                          ),
                          const SizedBox(width: 32),
                          _buildStatColumn(_formatCount(user.profileViews), 'Profile Views', isDark),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => context.push(AppRoutes.profileEdit),
                            child: _buildActionButton('Edit profile', isDark),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => AppShareService.shareBuyerProfile(
                              profileId: user.id,
                              userName: user.name,
                              bio: user.bio,
                              context: context,
                            ),
                            child: _buildActionButton('Share profile', isDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Bio
                      if (user.bio.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            user.bio,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      indicatorColor: isDark ? Colors.white : Colors.black,
                      labelColor: isDark ? Colors.white : Colors.black,
                      unselectedLabelColor: isDark ? Colors.white54 : Colors.black54,
                      tabs: const [
                        Tab(icon: Icon(Icons.grid_view_rounded)), // Posts/Activity
                        Tab(icon: Icon(Icons.favorite_border_rounded)), // Wishlist
                        Tab(icon: Icon(Icons.lock_outline_rounded)), // Private/Settings
                      ],
                    ),
                    isDark,
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                // Tab 1: Activity / Shop Stats
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfileSectionHeader(title: 'My Store Activity'),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              'Orders',
                              '${user.ordersCount}',
                              Icons.receipt_long,
                              isDark,
                              () => context.push(AppRoutes.profileOrders),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoCard(
                              'Points',
                              '${(user.loyaltyPoints / 1000).toStringAsFixed(1)}K',
                              Icons.stars,
                              isDark,
                              () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _menuCard(
                        isDark,
                        children: [
                          ProfileMenuTile(
                            icon: Icons.shopping_cart_outlined,
                            iconColor: const Color(0xFFF59E0B),
                            title: 'Cart',
                            onTap: () => context.push(AppRoutes.profileCart),
                          ),
                          _separator(isDark),
                          ProfileMenuTile(
                            icon: Icons.logout_rounded,
                            iconColor: const Color(0xFFFF486A),
                            title: 'Log Out',
                            onTap: () => Get.find<AuthController>().logout(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Tab 2: Wishlist
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfileSectionHeader(title: 'Saved Items'),
                      _menuCard(
                        isDark,
                        children: [
                          ProfileMenuTile(
                            icon: Icons.favorite,
                            iconColor: AppColors.accentPink,
                            title: 'Wishlist (${user.wishlistCount} items)',
                            onTap: () => context.push(AppRoutes.profileWishlist),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Tab 3: Settings
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfileSectionHeader(title: 'Account Settings'),
                      _menuCard(
                        isDark,
                        children: [
                          ProfileMenuTile(
                            icon: Icons.location_on_outlined,
                            iconColor: AppColors.success,
                            title: 'Addresses',
                            onTap: () => context.push(AppRoutes.checkoutAddress),
                          ),
                          _separator(isDark),
                          ProfileMenuTile(
                            icon: Icons.credit_card_rounded,
                            iconColor: AppColors.primary,
                            title: 'Payment Methods',
                            onTap: () => context.push(AppRoutes.checkoutPayment),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatColumn(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, bool isDark, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.primary
            : (isDark ? const Color(0xFF2A2535) : const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isPrimary
              ? Colors.white
              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1625) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2A2535) : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
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

  Widget _menuCard(bool isDark, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1625) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2535) : AppColors.lightBorder,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final bool isDark;

  _SliverAppBarDelegate(this.tabBar, this.isDark);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? Colors.black : const Color(0xFFF8F9FC),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
