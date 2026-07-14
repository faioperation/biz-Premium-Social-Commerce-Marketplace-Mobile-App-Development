import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/seller_settings_controller.dart';
import '../widgets/settings_item_tile.dart';
import 'profile_information_screen.dart';
import '../../../buyer/profile/screens/change_password_screen.dart';
import 'seller_payment_screen.dart';
import '../../../buyer/profile/screens/terms_of_service_screen.dart';
import '../../../buyer/profile/screens/privacy_policy_screen.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../../core/theme/app_colors.dart';

/// The central Settings menu screen for Sellers.
class SellerSettingsScreen extends StatefulWidget {
  const SellerSettingsScreen({super.key});

  @override
  State<SellerSettingsScreen> createState() => _SellerSettingsScreenState();
}

class _SellerSettingsScreenState extends State<SellerSettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Put controller so it persists during settings operations and child screens
    Get.put(SellerSettingsController());
  }

  @override
  void dispose() {
    Get.delete<SellerSettingsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : const Color(0xFFF8F9FC);
    final cardColor = isDark ? AppColors.darkCard : Colors.white;
    final headerTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Account Section Header
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 12),
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: headerTextColor,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            
            // Account Options Card
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SettingsItemTile(
                    icon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                    title: 'Profile Information',
                    subtitle: 'Update your personal details',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ProfileInformationScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 64),
                  SettingsItemTile(
                    icon: const Icon(Icons.lock_outline_rounded, color: AppColors.success),
                    title: 'Security & Password',
                    subtitle: 'Manage your account security',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 64),
                  SettingsItemTile(
                    icon: const Icon(Icons.credit_card_outlined, color: Colors.orange),
                    title: 'Payment Methods',
                    subtitle: 'Bank accounts & mobile banking',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SellerPaymentScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Support & Legal Header
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 12),
              child: Text(
                'Support & Legal',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: headerTextColor,
                  fontFamily: 'Inter',
                ),
              ),
            ),

            // Support & Legal Card
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SettingsItemTile(
                    icon: const Icon(Icons.help_outline_rounded, color: Colors.blue),
                    title: 'Help & Support',
                    subtitle: 'Get help from our team',
                    onTap: () {
                      Get.snackbar(
                        'Help & Support',
                        'Customer support service is coming soon!',
                        backgroundColor: AppColors.primary,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 64),
                  SettingsItemTile(
                    icon: const Icon(Icons.description_outlined, color: Colors.teal),
                    title: 'Terms & Conditions',
                    subtitle: 'Read our terms of service',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 64),
                  SettingsItemTile(
                    icon: const Icon(Icons.privacy_tip_outlined, color: Colors.purple),
                    title: 'Privacy Policy',
                    subtitle: 'How we protect your data',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // App Version & Log Out Button Group
            Center(
              child: Column(
                children: [
                  // Text(
                  //   'App Version',
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     color: subtitleColor,
                  //     fontFamily: 'Inter',
                  //   ),
                  // ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   '2.4.1',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.bold,
                  //     color: headerTextColor,
                  //     fontFamily: 'Inter',
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: TextButton(
                      onPressed: () {
                        Get.find<AuthController>().logout(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF3B1E22) : const Color(0xFFFFECEF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          color: Color(0xFFFF486A),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
