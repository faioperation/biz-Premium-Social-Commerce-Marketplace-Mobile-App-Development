import 'package:get/get.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/activity_feed_item.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repository;

  DashboardController(this._repository);

  final Rx<DashboardStats?> stats = Rx<DashboardStats?>(null);
  final RxList<ActivityFeedItem> recentActivity = <ActivityFeedItem>[].obs;
  final RxList<Map<String, dynamic>> ordersOverviewData = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> userGrowthData = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;
      error.value = '';

      final results = await Future.wait([
        _repository.getStats(),
        _repository.getRecentActivity(),
        _repository.getOrdersOverviewData(),
        _repository.getUserGrowthData(),
      ]);

      stats.value = results[0] as DashboardStats;
      recentActivity.value = results[1] as List<ActivityFeedItem>;
      ordersOverviewData.value = results[2] as List<Map<String, dynamic>>;
      userGrowthData.value = results[3] as List<Map<String, dynamic>>;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() => loadDashboard();
}
