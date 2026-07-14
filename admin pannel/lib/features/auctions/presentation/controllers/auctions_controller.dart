import 'package:get/get.dart';
import '../../../../core/mixins/page_lifecycle_mixin.dart';

class AuctionsController extends GetxController with PageLifecycleMixin {
  final RxList<Map<String, dynamic>> auctions = <Map<String, dynamic>>[].obs;

  @override
  Future<void> fetchData({bool isRefresh = false}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (isRefresh) auctions.clear();
    auctions.addAll([
      {'id': 'AUC-001', 'item': 'Vintage Watch', 'status': 'Active', 'highestBid': 450.0},
      {'id': 'AUC-002', 'item': 'Rare Coin', 'status': 'Ended', 'highestBid': 1200.0},
      {'id': 'AUC-003', 'item': 'Classic Car', 'status': 'Active', 'highestBid': 15000.0},
    ]);
  }
}
