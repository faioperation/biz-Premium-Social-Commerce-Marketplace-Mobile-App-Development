import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A shimmer-animated loading skeleton for enterprise SaaS UIs.
///
/// Usage:
/// ```dart
/// AppSkeleton.card()         // A full card skeleton
/// AppSkeleton.table()        // A table rows skeleton
/// AppSkeleton.statRow()      // A row of 4 stat card skeletons
/// AppSkeleton(width: 200, height: 16) // Custom block
/// ```
class AppSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const AppSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 6,
  });

  // ── Prebuilt skeletons ──

  /// 4 stat cards in a row
  static Widget statRow() => const _SkeletonStatRow();

  /// A full card block (title + a few lines)
  static Widget card({double height = 180}) => _SkeletonCard(height: height);

  /// N rows of table content
  static Widget table({int rows = 6}) => _SkeletonTable(rows: rows);

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat();
    _shimmer = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor  = isDark ? const Color(0xFF1E1E24) : const Color(0xFFF0F0F2);
    final shineColor = isDark ? const Color(0xFF2A2A34) : const Color(0xFFFFFFFF);

    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, shineColor, baseColor],
              stops: [
                (_shimmer.value + 2) / 4 - 0.3,
                (_shimmer.value + 2) / 4,
                (_shimmer.value + 2) / 4 + 0.3,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Stat Row Skeleton
// ─────────────────────────────────────────────
class _SkeletonStatRow extends StatelessWidget {
  const _SkeletonStatRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: i < 3 ? AppSpacing.md : 0),
          child: const _SkeletonCard(height: 120),
        ),
      )),
    );
  }
}

// ─────────────────────────────────────────────
// Card Skeleton
// ─────────────────────────────────────────────
class _SkeletonCard extends StatelessWidget {
  final double height;
  const _SkeletonCard({this.height = 180});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            AppSkeleton(width: 120, height: 12, borderRadius: 4),
            const Spacer(),
            AppSkeleton(width: 36, height: 36, borderRadius: 8),
          ]),
          const SizedBox(height: AppSpacing.md),
          const AppSkeleton(width: 80, height: 28, borderRadius: 6),
          const Spacer(),
          const AppSkeleton(width: 140, height: 10, borderRadius: 4),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Table Skeleton
// ─────────────────────────────────────────────
class _SkeletonTable extends StatelessWidget {
  final int rows;
  const _SkeletonTable({this.rows = 6});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.tableHeaderDark : AppColors.tableHeaderLight,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: List.generate(4, (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 3 ? AppSpacing.lg : 0),
                  child: const AppSkeleton(height: 10, borderRadius: 4),
                ),
              )),
            ),
          ),
          // Data rows
          ...List.generate(rows, (i) => Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: i.isOdd
                  ? (isDark ? AppColors.tableRowAltDark : AppColors.tableRowAltLight)
                  : Colors.transparent,
              border: Border(bottom: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              )),
            ),
            child: Row(
              children: [
                const AppSkeleton(width: 20, height: 20, borderRadius: 4),
                const SizedBox(width: AppSpacing.md),
                Expanded(flex: 2, child: AppSkeleton(width: 80 + (i % 3) * 20, height: 12, borderRadius: 4)),
                const SizedBox(width: AppSpacing.lg),
                Expanded(child: AppSkeleton(width: 60 + (i % 2) * 30, height: 12, borderRadius: 4)),
                const SizedBox(width: AppSpacing.lg),
                Expanded(child: const AppSkeleton(width: 70, height: 24, borderRadius: 12)),
                const SizedBox(width: AppSpacing.lg),
                const AppSkeleton(width: 60, height: 12, borderRadius: 4),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
