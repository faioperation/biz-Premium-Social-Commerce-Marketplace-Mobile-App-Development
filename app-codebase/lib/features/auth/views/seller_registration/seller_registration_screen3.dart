import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_routes.dart';
import '../../controllers/seller_registration_controller.dart';

class SellerRegistrationScreen3 extends StatelessWidget {
  const SellerRegistrationScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellerRegistrationController>();

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.sellerBackground
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.sellerBackground
            : Theme.of(context).appBarTheme.backgroundColor,
        title: const Text('Identity Verification'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsAllLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verify Identity',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkBodyTitle
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We need to verify your identity to ensure security on the platform.',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkDescription
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 32),

            Obx(
              () => _buildUploadCard(
                context,
                title: 'ID Card / Passport',
                subtitle: controller.idCardPath.value.isEmpty
                    ? 'Upload a clear photo of your ID'
                    : controller.idCardPath.value.split('/').last,
                icon: Icons.badge_outlined,
                onTap: () => controller.showImageSourceDialog(
                  context,
                  (path) => controller.idCardPath.value = path,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Obx(
              () => _buildUploadCard(
                context,
                title: 'Selfie with ID',
                subtitle: controller.selfiePath.value.isEmpty
                    ? 'Hold your ID next to your face'
                    : controller.selfiePath.value.split('/').last,
                icon: Icons.camera_front_outlined,
                onTap: () => controller.showImageSourceDialog(
                  context,
                  (path) => controller.selfiePath.value = path,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Obx(
              () => _buildUploadCard(
                context,
                title: 'Business Document',
                subtitle: controller.businessDocPath.value.isEmpty
                    ? 'Trade license or registration proof'
                    : controller.businessDocPath.value.split('/').last,
                icon: Icons.description_outlined,
                onTap: () => controller.showImageSourceDialog(
                  context,
                  (path) => controller.businessDocPath.value = path,
                ),
              ),
            ),

            const SizedBox(height: 60),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.push(AppRoutes.sellerRegStep4),
                child: const Text(
                  'Next Step',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: AppSpacing.edgeInsetsAllMd,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.sellerIcon.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.sellerIcon),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkBodyTitle
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkDescription
                        : AppColors.lightTextSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(onPressed: onTap, child: const Text('Upload')),
        ],
      ),
    );
  }
}
