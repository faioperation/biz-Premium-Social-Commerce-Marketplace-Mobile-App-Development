import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  final bool centered;
  const AppLoader({super.key, this.centered = true});

  @override
  Widget build(BuildContext context) {
    const loader = CircularProgressIndicator(color: AppColors.primary);
    return centered ? const Center(child: loader) : loader;
  }
}
