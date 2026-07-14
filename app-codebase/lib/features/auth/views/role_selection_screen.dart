import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/widgets/glowing_floating_logo.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../routes/app_routes.dart';
import '../widgets/interactive_role_card.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.edgeInsetsAllLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Center(
                child: GlowingFloatingLogo(
                  imagePath: AppImages.logo,
                  size: 100.0,
                ),
              ),
              const Spacer(),
              Text(
                'Welcome to Vango Live',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkBodyTitle
                      : AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Choose how you want to use the app',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkDescription
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              //const Spacer(),
              const SizedBox(height: 32),
              InteractiveRoleCard(
                title: 'Become a Buyer',
                description: 'Discover products, watch live streams, and shop!',
                icon: Icons.shopping_bag_outlined,
                color: AppColors.primary,
                onTap: () => context.push(AppRoutes.registerBuyer),
              ),
              const SizedBox(height: 24),
              InteractiveRoleCard(
                title: 'Become a Seller',
                description: 'Set up your shop, go live, and start selling!',
                icon: Icons.storefront_outlined,
                color: AppColors.accentPink,
                onTap: () => context.push(AppRoutes.sellerRegStep1),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Have an account? ',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.login),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

}
