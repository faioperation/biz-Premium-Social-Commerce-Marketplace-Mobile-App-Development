import 'package:get/get.dart';
import '../../../../core/mixins/page_lifecycle_mixin.dart';

class AnalyticsController extends GetxController with PageLifecycleMixin {
  final RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;

  @override
  Future<void> fetchData({bool isRefresh = false}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (isRefresh) data.clear();
    data.addAll([
      {'metric': 'Total Users', 'value': 1500, 'change': '+5%'},
      {'metric': 'Total Revenue', 'value': 45000.0, 'change': '+12%'},
      {'metric': 'Total Orders', 'value': 320, 'change': '-2%'},
    ]);
  }
}
