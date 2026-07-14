import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import 'package:get/get.dart';
import '../controllers/revenue_analytics_controller.dart';
import '../widgets/time_period_selector.dart';
import '../widgets/revenue_bar_chart.dart';
import '../widgets/analytics_stat_card.dart';
import '../widgets/top_selling_products.dart';

class SellerRevenueAnalyticsScreen extends StatelessWidget {
  const SellerRevenueAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RevenueAnalyticsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text(
          'Revenue Analytics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: isDark ? Colors.white : Colors.black87,
            size: 28,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              ),
            );
          }

          final data = controller.analyticsData.value;
          if (data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No analytics data found.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        controller.loadAnalyticsData(controller.selectedPeriod.value),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period Selector
                TimePeriodSelector(
                  selectedPeriod: controller.selectedPeriod.value,
                  onChanged: (period) => controller.changePeriod(period),
                ),
                const SizedBox(height: 24),

                // Bar Chart Card
                RevenueBarChart(data: data.weeklyRevenue),
                const SizedBox(height: 24),

                // Row of side-by-side stats
                Row(
                  children: [
                    Expanded(
                      child: AnalyticsStatCard(
                        title: 'Avg. Order Value',
                        value: '${AppConstants.currencySymbol}${data.avgOrderValue.toStringAsFixed(0)}',
                        growthText: '+${data.avgOrderValueGrowth.toStringAsFixed(0)}% from last week',
                        icon: Icons.trending_up,
                        iconColor: const Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AnalyticsStatCard(
                        title: 'Total Orders',
                        value: '${data.totalOrders}',
                        growthText: '+${data.totalOrdersGrowth.toStringAsFixed(0)}% from last week',
                        icon: Icons.shopping_cart_outlined,
                        iconColor: const Color(0xFFEC4899),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Top Selling Products Card
                TopSellingProductsList(products: data.topProducts),
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }
}
