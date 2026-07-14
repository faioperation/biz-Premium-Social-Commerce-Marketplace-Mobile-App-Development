import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/seller_profile_model.dart';
import '../../../../core/theme/app_colors.dart';

/// Controller managing seller settings profiles, fields validation, and logout.
class SellerSettingsController extends GetxController {
  // Profile Info Form Fields
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController addressController;
  final RxString profileImageUrl = ''.obs;

  // Mock Active Profile State
  final Rx<SellerProfileModel> profile = const SellerProfileModel(
    name: 'John Doe Store',
    mobile: '+1-555-123-4567',
    address: '123 Melton Road, Leicester, UK',
    imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
  ).obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: profile.value.name);
    mobileController = TextEditingController(text: profile.value.mobile);
    addressController = TextEditingController(text: profile.value.address);
    profileImageUrl.value = profile.value.imageUrl;
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    super.onClose();
  }

  /// Update simulated profile image path or URL
  void updateProfileImage(String newPath) {
    profileImageUrl.value = newPath;
  }

  /// Validates and saves profile information changes
  bool saveProfileInfo(BuildContext context) {
    final name = nameController.text.trim();
    final mobile = mobileController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Error',
        'Store name cannot be empty.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (mobile.isEmpty) {
      Get.snackbar(
        'Error',
        'Mobile number cannot be empty.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isLoading.value = true;

    // Simulate network latency for API updates
    Future.delayed(const Duration(milliseconds: 600), () {
      profile.value = profile.value.copyWith(
        name: name,
        mobile: mobile,
        address: address,
        imageUrl: profileImageUrl.value,
      );
      isLoading.value = false;
      
      Get.snackbar(
        'Success',
        'Profile updated successfully.',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    });

    return true;
  }
}
