import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/currency_formatter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../controllers/user_details_controller.dart';

class UserDetailsPage extends StatefulWidget {
  final String userId;
  const UserDetailsPage({super.key, required this.userId});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late final UserDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<UserDetailsController>();
    controller.loadUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.user.value == null) {
        return const Center(child: AppLoader());
      }

      final user = controller.user.value;
      if (user == null) {
        return const Center(child: Text('User not found'));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // Header with back button
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('User Details', style: AppTextStyles.h2),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Main Content Layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Profile Info
              Expanded(
                flex: 1,
                child: AppCard(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      AppAvatar(imageUrl: user.avatarUrl, initials: user.name.substring(0, 1), radius: 50),
                      const SizedBox(height: AppSpacing.md),
                      Text(user.name, style: AppTextStyles.h3),
                      const SizedBox(height: AppSpacing.xs),
                      Text(user.email, style: AppTextStyles.body.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                      const SizedBox(height: AppSpacing.lg),
                      
                      _buildInfoRow('ID', user.id),
                      const Divider(),
                      _buildInfoRow('Phone', user.phone ?? 'N/A'),
                      const Divider(),
                      _buildInfoRow('Joined', DateFormat('MMM d, yyyy').format(user.joinedAt)),
                      const Divider(),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status', style: AppTextStyles.body),
                            AppStatusChip(
                              label: user.status.toUpperCase(),
                              type: user.status == 'active' 
                                  ? AppStatusType.success 
                                  : (user.status == 'banned' ? AppStatusType.error : AppStatusType.warning),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: AppSpacing.xl),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: 'Edit Profile',
                          icon: Icons.edit,
                          type: AppButtonType.outline,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              
              // Right Column: Wallet & Actions
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // Wallet Card
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Wallet Overview', style: AppTextStyles.h4),
                          const SizedBox(height: AppSpacing.lg),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatItem('Balance', CurrencyFormatter.format(user.walletBalance)),
                              ),
                              Expanded(
                                child: _buildStatItem('Bidding Status', user.isBiddingDisabled ? 'Disabled' : 'Active'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    
                    // Danger Zone / Actions Card
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Administrative Actions', style: AppTextStyles.h4.copyWith(color: AppColors.error)),
                          const SizedBox(height: AppSpacing.lg),
                          
                          _buildActionTile(
                            title: 'Suspend User',
                            description: 'Temporarily prevent this user from accessing their account.',
                            buttonLabel: 'Suspend',
                            onPressed: () => _showConfirmation(
                              title: 'Suspend User',
                              message: 'Are you sure you want to suspend \${user.name}?',
                              onConfirm: controller.suspendUser,
                            ),
                          ),
                          const Divider(),
                          _buildActionTile(
                            title: 'Disable Bidding',
                            description: 'Prevent this user from participating in auctions.',
                            buttonLabel: 'Disable Bidding',
                            onPressed: () => _showConfirmation(
                              title: 'Disable Bidding',
                              message: 'Are you sure you want to disable bidding for \${user.name}?',
                              onConfirm: controller.disableBidding,
                            ),
                          ),
                          const Divider(),
                          _buildActionTile(
                            title: 'Freeze Wallet',
                            description: 'Lock funds so they cannot be withdrawn or used.',
                            buttonLabel: 'Freeze Wallet',
                            onPressed: () => _showConfirmation(
                              title: 'Freeze Wallet',
                              message: 'Are you sure you want to freeze the wallet of \${user.name}?',
                              onConfirm: controller.freezeWallet,
                            ),
                          ),
                          const Divider(),
                          _buildActionTile(
                            title: 'Ban User',
                            description: 'Permanently remove this user from the platform.',
                            buttonLabel: 'Ban User',
                            isDestructive: true,
                            onPressed: () => _showConfirmation(
                              title: 'Ban User',
                              message: 'Are you sure you want to PERMANENTLY BAN \${user.name}? This action cannot be undone.',
                              isDestructive: true,
                              onConfirm: controller.banUser,
                            ),
                          ),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
        const SizedBox(height: AppSpacing.sm),
        Text(value, style: AppTextStyles.h2),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required String description,
    required String buttonLabel,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }

  void _showConfirmation({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
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
