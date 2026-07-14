import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double radius;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 20,
  });

  String get _initials {
    final raw = initials ?? '?';
    return raw.isNotEmpty ? raw[0].toUpperCase() : '?';
  }

  Widget _fallback() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary,
      child: Text(
        _initials,
        style: AppTextStyles.body.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primarySubtle,
        child: ClipOval(
          child: Image.network(
            imageUrl!,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _fallback(),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return _fallback();
            },
          ),
        ),
      );
    }

    return _fallback();
  }
}
