import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/login_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/widgets/glowing_floating_logo.dart';

class LoginScreen extends StatelessWidget {
  final UserRole role;

  const LoginScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.edgeInsetsAllLg,
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: GlowingFloatingLogo(
                      imagePath: AppImages.logo,
                      size: 100.0,
                    ),
                  ),
                  const SizedBox(height: 32),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.displaySmall,
                      children: [
                        TextSpan(
                          text: 'Welcome ',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkHeading
                                : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Back!',
                          style: TextStyle(
                            color: role == UserRole.buyer
                                ? AppColors.primary
                                : AppColors.accentPink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  TextFormField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Obx(
                    () => TextFormField(
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          controller.navigateToForgotPassword(context),
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.login(context, role),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: role == UserRole.buyer
                            ? AppColors.primary
                            : AppColors.accentPink,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                  ),

                  //const SizedBox(height: 24),

                  // Demo Credentials Section
                  // Container(
                  //   padding: const EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).brightness == Brightness.dark
                  //         ? AppColors.darkBorder
                  //         : AppColors.lightBorder.withOpacity(0.3),
                  //     borderRadius: BorderRadius.circular(16),
                  //     border: Border.all(
                  //       color: Theme.of(context).brightness == Brightness.dark
                  //           ? AppColors.darkBorder.withOpacity(0.5)
                  //           : AppColors.lightBorder,
                  //     ),
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Icon(
                  //             Icons.info_outline,
                  //             size: 18,
                  //             color: role == UserRole.buyer
                  //                 ? AppColors.primary
                  //                 : AppColors.accentPink,
                  //           ),
                  //           const SizedBox(width: 8),
                  //           Text(
                  //             'Demo Credentials (Tap to Auto-fill)',
                  //             style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(height: 12),
                  //       InkWell(
                  //         onTap: () {
                  //           controller.emailController.text = 'buyer@vango.live';
                  //           controller.passwordController.text = 'password123';
                  //         },
                  //         borderRadius: BorderRadius.circular(8),
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  //           child: Row(
                  //             children: [
                  //               const Icon(Icons.shopping_bag_outlined, size: 16, color: AppColors.primary),
                  //               const SizedBox(width: 8),
                  //               Expanded(
                  //                 child: Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     Text(
                  //                       'Buyer: buyer@vango.live',
                  //                       style: TextStyle(
                  //                         fontSize: 13,
                  //                         fontWeight: FontWeight.w600,
                  //                         color: Theme.of(context).brightness == Brightness.dark
                  //                             ? AppColors.darkTextPrimary
                  //                             : AppColors.lightTextPrimary,
                  //                       ),
                  //                     ),
                  //                     const Text(
                  //                       'Password: password123',
                  //                       style: TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               const Icon(Icons.touch_app_outlined, size: 14, color: AppColors.lightTextSecondary),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       const Divider(height: 16),
                  //       InkWell(
                  //         onTap: () {
                  //           controller.emailController.text = 'seller@vango.live';
                  //           controller.passwordController.text = 'password123';
                  //         },
                  //         borderRadius: BorderRadius.circular(8),
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  //           child: Row(
                  //             children: [
                  //               const Icon(Icons.storefront_outlined, size: 16, color: AppColors.accentPink),
                  //               const SizedBox(width: 8),
                  //               Expanded(
                  //                 child: Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     Text(
                  //                       'Seller: seller@vango.live',
                  //                       style: TextStyle(
                  //                         fontSize: 13,
                  //                         fontWeight: FontWeight.w600,
                  //                         color: Theme.of(context).brightness == Brightness.dark
                  //                             ? AppColors.darkTextPrimary
                  //                             : AppColors.lightTextPrimary,
                  //                       ),
                  //                     ),
                  //                     const Text(
                  //                       'Password: password123',
                  //                       style: TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               const Icon(Icons.touch_app_outlined, size: 14, color: AppColors.lightTextSecondary),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () =>
                            controller.navigateToRegister(context),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: role == UserRole.buyer
                                ? AppColors.primary
                                : AppColors.accentPink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
