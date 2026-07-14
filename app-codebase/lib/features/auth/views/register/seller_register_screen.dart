import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/register_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_images.dart';

class SellerRegisterScreen extends StatelessWidget {
  const SellerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return Scaffold(
      appBar: AppBar(title: const Text('Seller Registration')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.edgeInsetsAllLg,
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(AppImages.logo, height: 80),
                const SizedBox(height: 24),
                Text(
                  'Create Your Shop',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: controller.shopNameController,
                  decoration: const InputDecoration(
                    labelText: 'Shop Name',
                    prefixIcon: Icon(Icons.store),
                  ),
                  validator: (v) => v!.isEmpty ? 'Shop Name is required' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: controller.productTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Product Type (e.g., Electronics)',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? 'Product Type is required' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) => !GetUtils.isEmail(v ?? '')
                      ? 'Valid email required'
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: controller.addressController,
                  decoration: const InputDecoration(
                    labelText: 'Business Address',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (v) => v!.isEmpty ? 'Address is required' : null,
                ),
                const SizedBox(height: 16),

                Container(
                  padding: AppSpacing.edgeInsetsAllMd,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightBorder),
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.badge_outlined,
                        color: AppColors.lightTextSecondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => Text(
                            controller.idCardImagePath.value.isEmpty
                                ? 'Upload ID Card Image'
                                : controller.idCardImagePath.value,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showImageSourceDialog(context, controller);
                        },
                        child: const Text('Browse'),
                      ),
                    ],
                  ),
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
                    validator: (v) =>
                        v!.length < 6 ? 'Min 6 chars required' : null,
                  ),
                ),

                const SizedBox(height: 32),

                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.registerSeller(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.accentPink,
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Register Shop',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog(
    BuildContext context,
    RegisterController controller,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Image Source',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSourceOption(
                    context,
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      controller.pickIdCardImage(context, ImageSource.camera);
                    },
                  ),
                  _buildSourceOption(
                    context,
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      controller.pickIdCardImage(context, ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSourceOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppColors.accentPink),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
