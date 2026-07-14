import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SellerVideoPickerSection extends StatelessWidget {
  final String? videoPath;
  final Function(String?) onVideoChanged;

  const SellerVideoPickerSection({
    super.key,
    required this.videoPath,
    required this.onVideoChanged,
  });

  Future<void> _pickVideo() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 60),
      );

      if (pickedFile != null) {
        onVideoChanged(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick video: $e',
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
          'Product Video (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickVideo(),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF2A2A3C) : const Color(0xFFE5E7EB),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  videoPath != null ? Icons.check_circle_outline : Icons.movie_creation_outlined,
                  color: videoPath != null ? const Color(0xFF10B981) : (isDark ? Colors.grey[400] : Colors.grey[500]),
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  videoPath != null ? 'Video selected successfully' : 'Upload product video',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Inter',
                    color: videoPath != null ? const Color(0xFF10B981) : (isDark ? Colors.grey[400] : Colors.grey[600]),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
