import 'package:get/get.dart';
import '../../../../core/mixins/page_lifecycle_mixin.dart';

class WalletsController extends GetxController with PageLifecycleMixin {
  final RxList<String> transactions = <String>[].obs;

  @override
  Future<void> fetchData({bool isRefresh = false}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (isRefresh) transactions.clear();
    transactions.addAll(List.generate(10, (index) => 'Transaction #' + (index + 1).toString()));
  }
}
