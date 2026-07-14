import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login(BuildContext context, UserRole role) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      isLoading.value = false;

      if (!context.mounted) return;

      final email = emailController.text.trim().toLowerCase();
      final password = passwordController.text;

      UserRole selectedRole = role;

      if (email == 'buyer@vango.live' && password == 'password123') {
        selectedRole = UserRole.buyer;
      } else if (email == 'seller@vango.live' && password == 'password123') {
        selectedRole = UserRole.seller;
      } else {
        if (email.contains('seller')) {
          selectedRole = UserRole.seller;
        } else if (email.contains('buyer')) {
          selectedRole = UserRole.buyer;
        }
      }

      Get.find<AuthController>().login(selectedRole, context);
    }
  }

  void navigateToRegister(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.roleSelection);
    }
  }

  void navigateToForgotPassword(BuildContext context) {
    context.push(AppRoutes.forgotPassword);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
