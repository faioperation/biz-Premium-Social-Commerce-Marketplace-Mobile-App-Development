import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/currency_formatter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

class SellerAnalyticsWidget extends StatelessWidget {
  final double totalRevenue;
  final int totalSales;
  final double conversionRate;
  final double rating;

  const SellerAnalyticsWidget({
    super.key,
    required this.totalRevenue,
    required this.totalSales,
    required this.conversionRate,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Seller Analytics', style: AppTextStyles.h4),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _buildMetric(
                  context,
                  'Total Revenue',
                  CurrencyFormatter.format(totalRevenue),
                  Icons.payments_outlined,
                  AppColors.success,
                ),
              ),
              Expanded(
                child: _buildMetric(
                  context,
                  'Total Sales',
                  NumberFormat.compact().format(totalSales),
                  Icons.shopping_bag_outlined,
                  AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _buildMetric(
                  context,
                  'Conversion Rate',
                  '\${conversionRate.toStringAsFixed(1)}%',
                  Icons.show_chart,
                  AppColors.info,
                ),
              ),
              Expanded(
                child: _buildMetric(
                  context,
                  'Avg Rating',
                  rating.toStringAsFixed(1),
                  Icons.star_outline,
                  AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(BuildContext context, String label, String value, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.body.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: AppTextStyles.h2),
      ],
    );
  }
}
