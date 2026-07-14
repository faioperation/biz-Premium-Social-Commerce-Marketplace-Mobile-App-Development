import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/store_controller.dart';
import 'dashed_rect_painter.dart';
import 'settings_text_field.dart';

/// The Basic Information editing view tab for Store Settings.
/// Contains the banner picker, image preview, name, category, description, and contact email/phone.
class BasicInfoTab extends StatelessWidget {
  final StoreController storeController;
  final TextEditingController nameController;
  final TextEditingController categoryController;
  final TextEditingController descriptionController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final VoidCallback onPickImage;

  const BasicInfoTab({
    super.key,
    required this.storeController,
    required this.nameController,
    required this.categoryController,
    required this.descriptionController,
    required this.emailController,
    required this.phoneController,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color labelColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Banner Header Title
          Text(
            'Store Banner',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          // Reactive Banner Container
          Obx(() {
            final bannerPath = storeController.bannerImagePath.value;
            
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: bannerPath != null
                  ? Container(
                      key: const ValueKey('preview'),
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: FileImage(File(bannerPath)),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black.withValues(alpha: 0.35),
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: onPickImage,
                                  icon: const Icon(Icons.edit, size: 16),
                                  label: const Text('Change'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.lightTextPrimary,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () => storeController.updateBanner(null),
                                  icon: const Icon(Icons.delete_outline, size: 16),
                                  label: const Text('Remove'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      key: const ValueKey('upload'),
                      onTap: onPickImage,
                      borderRadius: BorderRadius.circular(16),
                      child: CustomPaint(
                        painter: DashedRectPainter(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          borderRadius: 16,
                          dash: 6,
                          gap: 4,
                          strokeWidth: 1.5,
                        ),
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 40,
                                color: labelColor.withValues(alpha: 0.7),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Upload banner',
                                style: TextStyle(
                                  color: labelColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            );
          }),
          
          const SizedBox(height: 24),
          
          // Form fields using SettingsTextField
          SettingsTextField(
            label: 'Store Name',
            controller: nameController,
            placeholder: 'My Store',
          ),
          const SizedBox(height: 20),
          
          SettingsTextField(
            label: 'Category',
            controller: categoryController,
            placeholder: 'Electronics & Fashion',
          ),
          const SizedBox(height: 20),
          
          SettingsTextField(
            label: 'Description',
            controller: descriptionController,
            placeholder: 'Briefly describe your store...',
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          
          SettingsTextField(
            label: 'Contact Email',
            controller: emailController,
            placeholder: 'mystore@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          
          SettingsTextField(
            label: 'Phone Number',
            controller: phoneController,
            placeholder: '+1 (555) 123-4567',
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}
