import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'auth_controller.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final shopNameController = TextEditingController();
  final productTypeController = TextEditingController();
  final RxString idCardImagePath = ''.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void registerBuyer(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      isLoading.value = false;

      if (!context.mounted) return;
      Get.find<AuthController>().login(UserRole.buyer, context);
    }
  }

  void registerSeller(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      isLoading.value = false;

      if (!context.mounted) return;
      Get.find<AuthController>().login(UserRole.seller, context);
    }
  }

  Future<void> pickIdCardImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        idCardImagePath.value = image.name;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    shopNameController.dispose();
    productTypeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
