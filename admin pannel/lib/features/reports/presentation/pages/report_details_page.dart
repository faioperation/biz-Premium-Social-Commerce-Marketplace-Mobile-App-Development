import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../controllers/report_details_controller.dart';

class ReportDetailsPage extends StatefulWidget {
  final String reportId;
  const ReportDetailsPage({super.key, required this.reportId});

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  late final ReportDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ReportDetailsController>();
    controller.loadReport(widget.reportId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.report.value == null) {
        return const Center(child: AppLoader());
      }

      final report = controller.report.value;
      if (report == null) {
        return const Center(child: Text('Report not found'));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Report Details', style: AppTextStyles.h2),
                const Spacer(),
                _buildStatusChip(report.status),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Details
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Report Information', style: AppTextStyles.h3),
                            const SizedBox(height: AppSpacing.xl),
                            
                            Row(
                              children: [
                                Expanded(child: _buildInfoBlock('Reason', report.reason, Icons.warning_amber_rounded, AppColors.error)),
                                Expanded(child: _buildInfoBlock('Date Filed', DateFormat('MMM d, yyyy - h:mm a').format(report.createdAt), Icons.calendar_today, AppColors.primary)),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            
                            Text('Description', style: AppTextStyles.h4),
                            const SizedBox(height: AppSpacing.md),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight)),
                              ),
                              child: Text(
                                report.description,
                                style: AppTextStyles.body.copyWith(height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Target Information Card
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Target Details', style: AppTextStyles.h3),
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              children: [
                                _buildTargetIcon(report.targetType),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(report.targetName, style: AppTextStyles.h4),
                                      Text('Target Type: \${report.targetType.toUpperCase()}', style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                                    ],
                                  ),
                                ),
                                AppButton(
                                  label: 'View Target',
                                  type: AppButtonType.outline,
                                  onPressed: () {
                                    // Navigate to appropriate details page
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                
                // Right Column: Actions
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Resolution Actions
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Report Resolution', style: AppTextStyles.h4),
                            const SizedBox(height: AppSpacing.lg),
                            
                            if (report.status == 'pending') ...[
                              Text('Choose how to resolve this report.', style: AppTextStyles.body),
                              const SizedBox(height: AppSpacing.lg),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      label: 'Dismiss',
                                      type: AppButtonType.outline,
                                      onPressed: () => _showConfirmation(
                                        'Dismiss Report', 
                                        'Are you sure you want to dismiss this report? No action will be taken against the target.', 
                                        controller.dismissReport,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: AppButton(
                                      label: 'Mark Resolved',
                                      onPressed: () => _showConfirmation(
                                        'Resolve Report', 
                                        'Are you sure you want to mark this report as resolved?', 
                                        controller.resolveReport,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  color: report.status == 'resolved' ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      report.status == 'resolved' ? Icons.check_circle : Icons.cancel,
                                      color: report.status == 'resolved' ? AppColors.success : AppColors.error,
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Text(
                                      'This report has been \${report.status}.',
                                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Target Moderation Actions
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Moderation Actions', style: AppTextStyles.h4.copyWith(color: AppColors.error)),
                            const SizedBox(height: AppSpacing.lg),
                            
                            if (report.targetType == 'user') ...[
                              _buildActionTile('Suspend User', 'Temporarily disable user account.', 'Suspend', controller.suspendUser),
                              const Divider(),
                              _buildActionTile('Ban User', 'Permanently remove user.', 'Ban', controller.banUser, isDestructive: true),
                            ] else if (report.targetType == 'product') ...[
                              _buildActionTile('Remove Product', 'Take down the product listing.', 'Remove', controller.removeContent, isDestructive: true),
                              const Divider(),
                              _buildActionTile('Suspend Seller', 'Suspend the seller of this product.', 'Suspend Seller', controller.suspendUser),
                            ] else if (report.targetType == 'livestream') ...[
                              _buildActionTile('End Livestream', 'Forcefully end the active broadcast.', 'End Stream', controller.suspendStream, isDestructive: true),
                              const Divider(),
                              _buildActionTile('Suspend Streamer', 'Suspend the user broadcasting.', 'Suspend', controller.suspendUser),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTargetIcon(String targetType) {
    IconData icon;
    if (targetType == 'user') {
      icon = Icons.person;
    } else if (targetType == 'product') {
      icon = Icons.shopping_bag;
    } else {
      icon = Icons.live_tv;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: 30),
    );
  }

  Widget _buildInfoBlock(String title, String value, IconData icon, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 30),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
            Text(value, style: AppTextStyles.h5),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    AppStatusType type;
    if (status == 'resolved') {
      type = AppStatusType.success;
    } else if (status == 'dismissed') {
      type = AppStatusType.error;
    } else {
      type = AppStatusType.warning;
    }
    return AppStatusChip(label: status.toUpperCase(), type: type);
  }

  Widget _buildActionTile(String title, String description, String buttonLabel, VoidCallback onPressed, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h5.copyWith(color: isDestructive ? AppColors.error : (Theme.of(context).brightness == Brightness.dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))),
                const SizedBox(height: 4),
                Text(description, style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
              ],
            ),
          ),
          AppButton(
            label: buttonLabel,
            type: AppButtonType.outline,
            onPressed: () => _showConfirmation(title, 'Are you sure you want to perform this moderation action?', onPressed),
          ),
        ],
      ),
    );
  }

  void _showConfirmation(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: title,
        content: message,
        confirmText: 'Confirm',
        cancelText: 'Cancel',
        onConfirm: onConfirm,
      ),
    );
  }
}
