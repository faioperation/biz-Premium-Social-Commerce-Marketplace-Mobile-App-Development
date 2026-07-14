import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../buyer/inbox/controllers/inbox_controller.dart';
import '../models/shop_model.dart';
import '../controllers/shop_controller.dart';

class ShopProfileDetails extends StatelessWidget {
  final ShopModel shop;
  final ShopController controller;
  final bool isDark;

  const ShopProfileDetails({
    super.key,
    required this.shop,
    required this.controller,
    required this.isDark,
  });

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toString();
  }

  Widget _buildStatItem(
    String value,
    String label, {
    IconData? icon,
    Color? iconColor,
  }) {
    return Column(
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: isDark ? const Color(0xFF1A1625) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFF1A1625) : Colors.white,
                      width: 4,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(shop.profileImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Spacer(),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.toggleFollow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isFollowing.value
                          ? (isDark ? Colors.grey[800] : Colors.grey[300])
                          : AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 0,
                      ),
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(
                      controller.isFollowing.value ? 'Following' : 'Follow',
                      style: TextStyle(
                        color: controller.isFollowing.value
                            ? (isDark ? Colors.white70 : Colors.black87)
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: isDark ? Colors.white : Colors.black87,
                      size: 18,
                    ),
                    onPressed: () {
                      final inboxCtrl = Get.put(InboxController());
                      inboxCtrl.openOrCreateChat(
                        chatId: shop.id,
                        name: shop.name,
                        profileImage: shop.profileImageUrl,
                      );
                      context.push(
                        AppRoutes.chatScreen,
                        extra: {
                          'chatId': shop.id,
                          'shopName': shop.name,
                          'profileImage': shop.profileImageUrl,
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              shop.name,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),

            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.grey[500],
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  shop.location,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(_formatNumber(shop.followersCount), 'Followers'),
                _buildStatItem(
                  '${shop.rating}',
                  'Rating',
                  icon: Icons.star_rounded,
                  iconColor: Colors.orangeAccent,
                ),
                _buildStatItem('${shop.responseRate}%', 'Response Rate'),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
