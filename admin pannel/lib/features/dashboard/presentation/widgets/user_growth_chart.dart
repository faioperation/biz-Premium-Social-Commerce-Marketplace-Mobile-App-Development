import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

class UserGrowthChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const UserGrowthChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User Growth', style: AppTextStyles.h4),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              primaryXAxis: const CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                axisLine: AxisLine(width: 0),
              ),
              primaryYAxis: const NumericAxis(
                axisLine: AxisLine(width: 0),
                majorTickLines: MajorTickLines(size: 0),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries>[
                SplineAreaSeries<Map<String, dynamic>, String>(
                  dataSource: data,
                  xValueMapper: (Map<String, dynamic> item, _) => item['month'] as String,
                  yValueMapper: (Map<String, dynamic> item, _) => item['users'] as num,
                  name: 'Users',
                  borderColor: AppColors.chartPalette[1],
                  borderWidth: 2.5,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.chartPalette[1].withValues(alpha: 0.25),
                      AppColors.chartPalette[1].withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    height: 6,
                    width: 6,
                    borderWidth: 2,
                    borderColor: AppColors.chartPalette[1],
                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : Colors.white,
                    shape: DataMarkerType.circle,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
