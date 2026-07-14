import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

class OrdersChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const OrdersChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final axisLabelStyle = TextStyle(
      color: isDark ? AppColors.textTertiaryDark : (Theme.of(context).brightness == Brightness.dark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
      fontSize: 11,
      fontFamily: 'Inter',
    );

    final gridLineColor = isDark
        ? AppColors.borderDark.withValues(alpha: 0.5)
        : (Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Orders Overview', style: AppTextStyles.h4.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : (Theme.of(context).brightness == Brightness.dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  )),
                  const SizedBox(height: 2),
                  Text('Monthly orders trend', style: AppTextStyles.caption.copyWith(
                    color: isDark ? AppColors.textTertiaryDark : (Theme.of(context).brightness == Brightness.dark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                  )),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up_rounded, size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text('+12.4%', style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                labelStyle: axisLabelStyle,
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                labelStyle: axisLabelStyle,
                majorGridLines: MajorGridLines(
                  width: 1,
                  color: gridLineColor,
                  dashArray: const <double>[4, 4],
                ),
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                color: isDark ? AppColors.cardDark : Colors.white,
                borderColor: isDark ? AppColors.borderDark : (Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight),
                borderWidth: 1,
                textStyle: AppTextStyles.caption.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : (Theme.of(context).brightness == Brightness.dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                ),
                shadowColor: Colors.black.withValues(alpha: 0.1),
                elevation: 8,
              ),
              series: <CartesianSeries>[
                ColumnSeries<Map<String, dynamic>, String>(
                  dataSource: data,
                  xValueMapper: (item, _) => item['month'] as String,
                  yValueMapper: (item, _) => item['orders'] as num,
                  name: 'Orders',
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  width: 0.6,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.info,
                      AppColors.info.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
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
