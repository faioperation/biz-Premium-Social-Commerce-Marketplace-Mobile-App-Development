import 'package:get/get.dart';
import '../../../../core/mixins/page_lifecycle_mixin.dart';

class OrdersController extends GetxController with PageLifecycleMixin {
  final RxList<String> orders = <String>[].obs;

  @override
  Future<void> fetchData({bool isRefresh = false}) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (isRefresh) orders.clear();
    orders.addAll(List.generate(10, (index) => 'Order #' + (index + 1).toString()));
  }
}
