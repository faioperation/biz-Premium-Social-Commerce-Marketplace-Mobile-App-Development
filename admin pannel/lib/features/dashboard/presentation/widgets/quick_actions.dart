import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: AppTextStyles.h4),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              _buildActionButton(context, 'Add User', Icons.person_add, AppColors.primary, () {}),
              _buildActionButton(context, 'New Report', Icons.bar_chart, AppColors.chartPalette[1], () {}),
              _buildActionButton(context, 'Create Livestream', Icons.live_tv, AppColors.error, () {}),
              _buildActionButton(context, 'Send Notification', Icons.notifications_active, AppColors.info, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppSpacing.sm),
            Text(label, style: AppTextStyles.bodySm, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
