import '../entities/dashboard_stats.dart';
import '../entities/activity_feed_item.dart';

abstract class DashboardRepository {
  Future<DashboardStats> getStats();
  Future<List<ActivityFeedItem>> getRecentActivity();
  Future<List<Map<String, dynamic>>> getOrdersOverviewData();
  Future<List<Map<String, dynamic>>> getUserGrowthData();
}
