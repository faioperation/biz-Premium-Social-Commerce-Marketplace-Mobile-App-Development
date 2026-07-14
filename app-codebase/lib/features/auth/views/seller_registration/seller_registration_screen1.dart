import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/widgets/glowing_floating_logo.dart';

class SellerRegistrationScreen1 extends StatelessWidget {
  const SellerRegistrationScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.sellerBackground
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.sellerBackground
            : Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.edgeInsetsAllLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: GlowingFloatingLogo(
                  imagePath: AppImages.logo,
                  size: 100.0,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Sell on Vango Live',
                style: TextStyle(
                  color: isDark ? AppColors.darkBodyTitle : AppColors.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Join thousands of successful sellers and grow your business with live commerce.',
                style: TextStyle(
                  color: isDark ? AppColors.darkDescription : AppColors.lightTextSecondary,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              _buildBenefitItem(
                context,
                icon: Icons.videocam_outlined,
                title: 'Go Live',
                description:
                    'Sell your products in real-time through engaging live streams.',
              ),
              _buildBenefitItem(
                context,
                icon: Icons.groups_outlined,
                title: 'Build Audience',
                description:
                    'Connect directly with your customers and build a loyal community.',
              ),
              _buildBenefitItem(
                context,
                icon: Icons.payments_outlined,
                title: 'Earn Money',
                description:
                    'Get paid instantly and track your business growth with ease.',
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => context.push(AppRoutes.sellerRegStep2),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentPink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                  ),
                  child: const Text(
                    'Become Seller',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.sellerIcon : AppColors.primary)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDark ? AppColors.sellerIcon : AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? AppColors.darkBodyTitle : AppColors.lightTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: isDark ? AppColors.darkDescription : AppColors.lightTextSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
