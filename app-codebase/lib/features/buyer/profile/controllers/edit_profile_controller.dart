import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/profile_user_model.dart';
import 'profile_controller.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  
  // Using Rxn<String> to hold either URL or local file path
  final selectedAvatarPath = Rxn<String>();
  final selectedBannerPath = Rxn<String>();
  
  final _picker = ImagePicker();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    try {
      final profileCtrl = Get.find<ProfileController>();
      final user = profileCtrl.user.value;
      if (user != null) {
        nameController.text = user.name;
        bioController.text = user.bio;
        phoneController.text = '+1 (555) 123-4567';
        selectedAvatarPath.value = user.avatarUrl;
        selectedBannerPath.value = user.bannerUrl;
      }
    } catch (_) {}
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.onClose();
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedAvatarPath.value = image.path;
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

  Future<void> pickBanner(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedBannerPath.value = image.path;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick banner: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> saveProfile(BuildContext context) async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name cannot be empty'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 1000)); // Simulate API call

    try {
      final profileCtrl = Get.find<ProfileController>();
      if (profileCtrl.user.value != null) {
        final currentUser = profileCtrl.user.value!;
        profileCtrl.user.value = ProfileUserModel(
          id: currentUser.id,
          name: nameController.text.trim(),
          email: currentUser.email,
          avatarUrl: selectedAvatarPath.value ?? currentUser.avatarUrl,
          bannerUrl: selectedBannerPath.value ?? currentUser.bannerUrl,
          bio: bioController.text.trim(),
          followersCount: currentUser.followersCount,
          followingCount: currentUser.followingCount,
          profileViews: currentUser.profileViews,
          ordersCount: currentUser.ordersCount,
          wishlistCount: currentUser.wishlistCount,
          loyaltyPoints: currentUser.loyaltyPoints,
        );
      }
    } catch (_) {}

    isLoading.value = false;
    
    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

