import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Banner & Avatar Stack
            SizedBox(
              height: 200,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Banner
                  GestureDetector(
                    onTap: () => controller.pickBanner(context),
                    child: Obx(() => Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2A2535) : AppColors.lightBorder,
                        image: controller.selectedBannerPath.value != null
                            ? DecorationImage(
                                image: controller.selectedBannerPath.value!.startsWith('http')
                                    ? NetworkImage(controller.selectedBannerPath.value!)
                                    : FileImage(File(controller.selectedBannerPath.value!)) as ImageProvider,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: controller.selectedBannerPath.value == null
                          ? const Center(child: Icon(Icons.add_photo_alternate, color: Colors.grey, size: 40))
                          : Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                    )),
                  ),
                  // Avatar
                  Positioned(
                    bottom: 0,
                    left: 24,
                    child: GestureDetector(
                      onTap: () => controller.pickImage(context),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Obx(() => Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? Colors.black : const Color(0xFFF8F9FC),
                                width: 4,
                              ),
                              image: controller.selectedAvatarPath.value != null
                                  ? DecorationImage(
                                      image: controller.selectedAvatarPath.value!.startsWith('http')
                                          ? NetworkImage(controller.selectedAvatarPath.value!)
                                          : FileImage(File(controller.selectedAvatarPath.value!)) as ImageProvider,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: controller.selectedAvatarPath.value == null
                                ? const Center(child: Icon(Icons.person, color: Colors.white, size: 40))
                                : null,
                          )),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: isDark ? Colors.black : Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Form Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildTextField(
                    controller: controller.nameController,
                    label: 'Full Name',
                    icon: Icons.person_outline,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: controller.bioController,
                    label: 'Bio',
                    icon: Icons.info_outline,
                    isDark: isDark,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: controller.phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    isDark: isDark,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 40),

                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.saveProfile(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            prefixIcon: maxLines > 1 
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 48), // align top
                    child: Icon(icon, color: AppColors.primary),
                  ) 
                : Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: isDark ? const Color(0xFF1A1625) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF2A2535) : AppColors.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF2A2535) : AppColors.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
