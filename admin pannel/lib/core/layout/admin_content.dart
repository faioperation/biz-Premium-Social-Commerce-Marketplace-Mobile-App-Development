import 'package:flutter/material.dart';
import 'breadcrumb_widget.dart';
import '../theme/app_spacing.dart';

class AdminContent extends StatelessWidget {
  final Widget child;

  const AdminContent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Breadcrumb Row
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: const BreadcrumbWidget(),
          ),
          // Actual Page Content — each page manages its own scroll
          Expanded(child: child),
        ],
      ),
    );
  }
}
