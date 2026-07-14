import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../models/home_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  Widget _buildNotificationIcon(String type, bool isDark) {
    IconData icon;
    Color bgColor;
    Color iconColor;

    switch (type) {
      case 'order':
        icon = Icons.inventory_2_outlined;
        bgColor = isDark ? const Color(0xFF2E2A4F) : const Color(0xFFEEECFF);
        iconColor = const Color(0xFF6C4DFF);
        break;
      case 'like':
        icon = Icons.favorite_outline_rounded;
        bgColor = isDark ? const Color(0xFF4C2735) : const Color(0xFFFFECEF);
        iconColor = const Color(0xFFFF4D67);
        break;
      case 'message':
        icon = Icons.chat_bubble_outline_rounded;
        bgColor = isDark ? const Color(0xFF4A2542) : const Color(0xFFFFECFA);
        iconColor = const Color(0xFFFF4FD8);
        break;
      case 'follower':
        icon = Icons.person_add_alt_1_outlined;
        bgColor = isDark ? const Color(0xFF1E3A2F) : const Color(0xFFE6F9F0);
        iconColor = const Color(0xFF10B981);
        break;
      case 'sale':
        icon = Icons.local_offer_outlined;
        bgColor = isDark ? const Color(0xFF3F321B) : const Color(0xFFFEF3C7);
        iconColor = const Color(0xFFF59E0B);
        break;
      default:
        icon = Icons.notifications_none_rounded;
        bgColor = isDark ? Colors.white12 : Colors.black12;
        iconColor = isDark ? Colors.white70 : Colors.black54;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
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
          'Notifications',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              controller.markAllAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              'Mark all as read',
              style: TextStyle(
                color: Color(0xFF6C4DFF),
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 64,
                  color: isDark ? Colors.white30 : Colors.black26,
                ),
                const SizedBox(height: 16),
                Text(
                  'No notifications yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];

            // Setup styling matching mockup:
            // Unread notifications: light purple background + light purple border + dot
            // Read notifications: white background + grey border
            final Color cardBgColor = notification.isRead
                ? (isDark ? const Color(0xFF1E1C24) : Colors.white)
                : (isDark
                    ? const Color(0xFF262238)
                    : const Color(0xFFF3F1FF));

            final Color cardBorderColor = notification.isRead
                ? (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04))
                : (isDark
                    ? const Color(0xFF6C4DFF).withValues(alpha: 0.3)
                    : const Color(0xFFE3DCFF));

            return GestureDetector(
              onTap: () => controller.toggleReadStatus(notification.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: cardBorderColor,
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notification Icon
                    _buildNotificationIcon(notification.type, isDark),
                    const SizedBox(width: 14),

                    // Notification Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),

                              // Unread Dot
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(top: 4, left: 8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF6C4DFF),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            notification.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white60 : Colors.black54,
                              fontFamily: 'Inter',
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            notification.timeAgo,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white38 : Colors.black38,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
