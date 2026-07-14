import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SellerImagePickerSection extends StatelessWidget {
  final List<String> selectedImages;
  final Function(List<String>) onImagesChanged;

  const SellerImagePickerSection({
    super.key,
    required this.selectedImages,
    required this.onImagesChanged,
  });

  Future<void> _pickImage(int index) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final newImages = List<String>.from(selectedImages);
        if (index < newImages.length) {
          newImages[index] = pickedFile.path;
        } else {
          newImages.add(pickedFile.path);
        }
        onImagesChanged(newImages);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Images',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(3, (index) {
            final hasImage = index < selectedImages.length;
            final imagePath = hasImage ? selectedImages[index] : null;

            return Expanded(
              child: GestureDetector(
                onTap: () => _pickImage(index),
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < 2 ? 12.0 : 0.0,
                  ),
                  height: 100,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E2A) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? const Color(0xFF2A2A3C) : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: hasImage && imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: imagePath.startsWith('http')
                              ? Image.network(
                                  imagePath,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                ),
                        )
                      : Icon(
                          Icons.add,
                          color: isDark ? Colors.grey[500] : Colors.grey[400],
                          size: 28,
                        ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
