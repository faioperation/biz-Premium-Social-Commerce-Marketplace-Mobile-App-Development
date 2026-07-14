import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SellerRegistrationController extends GetxController {
  final shopName = ''.obs;
  final businessType = ''.obs;
  final country = ''.obs;
  final categories = <String>[].obs;

  final idCardPath = ''.obs;
  final selfiePath = ''.obs;
  final businessDocPath = ''.obs;

  final logoPath = ''.obs;
  final bannerPath = ''.obs;
  final description = ''.obs;

  final stripeConnected = false.obs;
  final bankInfo = ''.obs;
  final walletInfo = ''.obs;

  void updateShopName(String val) => shopName.value = val;
  void updateBusinessType(String val) => businessType.value = val;
  void updateCountry(String val) => country.value = val;
  void toggleCategory(String cat) {
    if (categories.contains(cat)) {
      categories.remove(cat);
    } else {
      categories.add(cat);
    }
  }

  Future<void> pickImage(
    BuildContext context,
    ImageSource source,
    Function(String) onPicked,
  ) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      onPicked(image.path);
    }
  }

  void showImageSourceDialog(BuildContext context, Function(String) onPicked) {
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
              const Text(
                'Select Image Source',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      pickImage(context, ImageSource.camera, onPicked);
                    },
                  ),
                  _buildSourceOption(
                    context,
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(context, ImageSource.gallery, onPicked);
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
            Icon(icon, size: 40, color: const Color(0xFF6C4DFF)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Future<void> submitRegistration() async {
    Get.snackbar(
      'Success',
      'Seller registration submitted successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
