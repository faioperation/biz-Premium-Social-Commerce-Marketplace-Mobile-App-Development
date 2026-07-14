import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void sendOtp(BuildContext context) async {
    if (emailController.text.isNotEmpty) {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 1));
      isLoading.value = false;
      if (!context.mounted) return;
      context.push(AppRoutes.otpVerification);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void verifyOtp(BuildContext context) async {
    if (otpController.text.length == 6) {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 1));
      isLoading.value = false;
      if (!context.mounted) return;
      context.push(AppRoutes.resetPassword);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit OTP'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void resetPassword(BuildContext context) async {
    if (newPasswordController.text == confirmPasswordController.text &&
        newPasswordController.text.isNotEmpty) {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 1));
      isLoading.value = false;
      if (!context.mounted) return;
      context.pushReplacement(AppRoutes.passwordSuccess);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
