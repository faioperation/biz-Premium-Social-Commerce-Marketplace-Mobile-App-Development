import 'package:get/get.dart';
import '../models/revenue_analytics_model.dart';

class RevenueAnalyticsController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxString selectedPeriod = '7 Days'.obs;
  final Rxn<RevenueAnalyticsModel> analyticsData = Rxn<RevenueAnalyticsModel>();

  @override
  void onInit() {
    super.onInit();
    loadAnalyticsData(selectedPeriod.value);
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    loadAnalyticsData(period);
  }

  /// Fetch analytics data based on the selected period
  Future<void> loadAnalyticsData(String period) async {
    try {
      isLoading.value = true;

      // Simulate network request delay
      await Future.delayed(const Duration(milliseconds: 600));

      // Build mock data matching the period
      if (period == '7 Days') {
        analyticsData.value = RevenueAnalyticsModel(
          avgOrderValue: 356.0,
          avgOrderValueGrowth: 12.0,
          totalOrders: 127,
          totalOrdersGrowth: 8.0,
          weeklyRevenue: [
            4200.0, // Mon
            5300.0, // Tue
            3800.0, // Wed
            6600.0, // Thu
            8200.0, // Fri
            9600.0, // Sat
            7800.0, // Sun
          ],
          topProducts: [
            TopSellingProductModel(
              name: 'Premium Watch',
              soldCount: 32,
              revenue: 9568.0,
              image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=200',
            ),
            TopSellingProductModel(
              name: 'Leather Bag',
              soldCount: 32,
              revenue: 5088.0,
              image: 'https://images.unsplash.com/photo-1491637639811-60a2156d12a9?q=80&w=200',
            ),
            TopSellingProductModel(
              name: 'Wireless Headphones',
              soldCount: 32,
              revenue: 6368.0,
              image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200',
            ),
          ],
        );
      } else if (period == '30 Days') {
        analyticsData.value = RevenueAnalyticsModel(
          avgOrderValue: 382.0,
          avgOrderValueGrowth: 15.4,
          totalOrders: 542,
          totalOrdersGrowth: 12.5,
          weeklyRevenue: [
            3100.0,
            4900.0,
            4100.0,
            5500.0,
            7500.0,
            8200.0,
            6800.0,
          ],
          topProducts: [
            TopSellingProductModel(
              name: 'Premium Watch',
              soldCount: 145,
              revenue: 43355.0,
              image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=200',
            ),
            TopSellingProductModel(
              name: 'Wireless Headphones',
              soldCount: 110,
              revenue: 21890.0,
              image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200',
            ),
            TopSellingProductModel(
              name: 'Leather Bag',
              soldCount: 92,
              revenue: 14628.0,
              image: 'https://images.unsplash.com/photo-1491637639811-60a2156d12a9?q=80&w=200',
            ),
          ],
        );
      } else {
        // 90 Days
        analyticsData.value = RevenueAnalyticsModel(
          avgOrderValue: 410.0,
          avgOrderValueGrowth: 18.2,
          totalOrders: 1845,
          totalOrdersGrowth: 14.8,
          weeklyRevenue: [
            3500.0,
            4500.0,
            5200.0,
            6000.0,
            7000.0,
            8900.0,
            7200.0,
          ],
          topProducts: [
            TopSellingProductModel(
              name: 'Premium Watch',
              soldCount: 420,
              revenue: 125580.0,
              image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=200',
            ),
            TopSellingProductModel(
              name: 'Wireless Headphones',
              soldCount: 380,
              revenue: 75620.0,
              image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200',
            ),
            TopSellingProductModel(
              name: 'Leather Bag',
              soldCount: 310,
              revenue: 49290.0,
              image: 'https://images.unsplash.com/photo-1491637639811-60a2156d12a9?q=80&w=200',
            ),
          ],
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load analytics data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
