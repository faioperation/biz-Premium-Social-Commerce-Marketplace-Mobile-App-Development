import 'dart:io';
import 'package:flutter/material.dart';

class MediaPreviewBar extends StatelessWidget {
  final String path;
  final String type; // 'image' | 'video'
  final VoidCallback onRemove;

  const MediaPreviewBar({
    super.key,
    required this.path,
    required this.type,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1625) : Colors.grey[50],
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[900]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.grey[850]! : Colors.grey[300]!,
                  ),
                  image: type == 'image'
                      ? DecorationImage(
                          image: FileImage(File(path)),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: type == 'video' ? Colors.black87 : null,
                ),
                child: type == 'video'
                    ? const Center(
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      )
                    : null,
              ),
              Positioned(
                top: -8,
                right: -8,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type == 'image' ? 'Image Selected' : 'Video Selected',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    fontFamily: 'Inter',
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap send to deliver this file.',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Inter',
                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
