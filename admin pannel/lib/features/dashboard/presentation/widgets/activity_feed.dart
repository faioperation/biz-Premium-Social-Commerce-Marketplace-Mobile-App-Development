import 'package:flutter/material.dart';
import '../../domain/entities/activity_feed_item.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import 'package:intl/intl.dart';

class ActivityFeedWidget extends StatelessWidget {
  final List<ActivityFeedItem> activities;

  const ActivityFeedWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Activity', style: AppTextStyles.h4),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: activities.isEmpty
                ? const Center(child: Text('No recent activity'))
                : ListView.separated(
                    itemCount: activities.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = activities[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: _buildIcon(item.type),
                        title: Text(item.title, style: AppTextStyles.body),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(item.description, style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM d, h:mm a').format(item.timestamp),
                              style: AppTextStyles.caption.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String type) {
    IconData iconData;
    Color color;

    switch (type) {
      case 'order':
        iconData = Icons.shopping_bag;
        color = AppColors.primary;
        break;
      case 'seller':
        iconData = Icons.store;
        color = AppColors.chartPalette[1];
        break;
      case 'user':
        iconData = Icons.person;
        color = AppColors.info;
        break;
      case 'product':
        iconData = Icons.inventory;
        color = AppColors.success;
        break;
      default:
        iconData = Icons.notifications;
        color = AppColors.info;
    }

    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.1),
      child: Icon(iconData, color: color, size: 20),
    );
  }
}
