import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  final obscureCurrent = true.obs;
  final obscureNew = true.obs;
  final obscureConfirm = true.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleCurrentObscure() => obscureCurrent.toggle();
  void toggleNewObscure() => obscureNew.toggle();
  void toggleConfirmObscure() => obscureConfirm.toggle();

  Future<void> submit() async {
    final current = currentPasswordController.text;
    final newPass = newPasswordController.text;
    final confirm = confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (newPass != confirm) {
      Get.snackbar(
        'Error',
        'New passwords do not match',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 1000));

    isLoading.value = false;

    Get.back();
    Get.snackbar(
      'Success',
      'Password changed successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
