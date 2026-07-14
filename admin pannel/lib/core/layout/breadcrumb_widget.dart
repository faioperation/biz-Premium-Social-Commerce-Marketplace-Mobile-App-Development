import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class BreadcrumbWidget extends StatelessWidget {
  const BreadcrumbWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == '/' || location.isEmpty) {
      return Text('Dashboard', style: AppTextStyles.h4);
    }

    final List<String> segments = location.split('/').where((e) => e.isNotEmpty).toList();
    
    return Row(
      children: [
        InkWell(
          onTap: () => context.go('/'),
          child: Text('Home', style: AppTextStyles.body.copyWith(color: AppColors.primary)),
        ),
        for (int i = 0; i < segments.length; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.chevron_right, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
          if (i == segments.length - 1)
            Text(
              _capitalize(segments[i]),
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
            )
          else
            InkWell(
              onTap: () {
                final path = '/${segments.sublist(0, i + 1).join('/')}';
                context.go(path);
              },
              child: Text(
                _capitalize(segments[i]),
                style: AppTextStyles.body.copyWith(color: AppColors.primary),
              ),
            ),
        ]
      ],
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s.split('-').map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '').join(' ');
  }
}
