import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../../../core/widgets/glowing_floating_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      final authController = Get.find<AuthController>();
      if (!authController.isAuthenticated.value) {
        context.go(AppRoutes.roleSelection);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GlowingFloatingLogo(
              imagePath: AppImages.logo,
              size: 130.0,
            ),
            const SizedBox(height: 12),
            Text(
              'Vango Live',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: isDark
                    ? Theme.of(context).colorScheme.onSurface
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Watch  •  Shop  •  Go Live',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.9),
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
