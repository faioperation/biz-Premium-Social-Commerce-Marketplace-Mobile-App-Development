import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_routes.dart';
import '../../controllers/seller_registration_controller.dart';
import '../../controllers/auth_controller.dart';

class SellerRegistrationScreen5 extends StatelessWidget {
  const SellerRegistrationScreen5({super.key});

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
        title: const Text('Payment Setup'),
        leading: const BackButton(),
        actions: [
          TextButton(
            onPressed: () => _showSuccessDialog(context, controller),
            child: const Text('Skip'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsAllLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get Paid',
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
              'Connect your payment methods to receive earnings from your sales.',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkDescription
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 32),

            _buildPaymentOption(
              context,
              title: 'Connect Your Account',
              subtitle: 'Recommended for fast & secure payouts',
              icon: Icons.account_balance_outlined,
              color: AppColors.sellerIcon,
              onTap: () {},
            ),
            const SizedBox(height: 16),

            // _buildPaymentOption(
            //   title: 'Bank Account',
            //   subtitle: 'Direct transfer to your bank',
            //   icon: Icons.account_balance_wallet_outlined,
            //   color: AppColors.primary,
            //   onTap: () {},
            // ),
            // const SizedBox(height: 16),
            //
            // _buildPaymentOption(
            //   title: 'Digital Wallet',
            //   subtitle: 'PayPal, Payoneer or others',
            //   icon: Icons.account_balance_wallet_outlined,
            //   color: AppColors.accentPink,
            //   onTap: () {},
            // ),
            const SizedBox(height: 100),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _showSuccessDialog(context, controller),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                child: const Text(
                  'Complete Registration',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMd,
      child: Container(
        padding: AppSpacing.edgeInsetsAllMd,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
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
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(
    BuildContext context,
    SellerRegistrationController controller,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppColors.success,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'Registration Done!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkBodyTitle
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your seller account has been created. You can now start adding products and go live!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkDescription
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 32),
             SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Get.find<AuthController>().login(UserRole.seller, context);
                },
                child: const Text('Go to Dashboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
