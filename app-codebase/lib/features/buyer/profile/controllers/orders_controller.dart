import 'package:get/get.dart';
import '../models/order_model.dart';

class OrdersController extends GetxController {
  final isLoading = false.obs;

  final selectedFilter = 'All'.obs;

  final allOrders = <OrderModel>[].obs;

  final List<String> filterTabs = ['All', 'Pending', 'Delivered'];

  List<OrderModel> get filteredOrders {
    if (selectedFilter.value == 'All') return allOrders;
    return allOrders
        .where(
          (o) => o.status.toLowerCase() == selectedFilter.value.toLowerCase(),
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));

    allOrders.value = [
      OrderModel(
        orderId: '#ORD-2024-1234',
        date: DateTime(2026, 5, 15),
        status: 'Delivered',
        totalAmount: 497.0,
        itemCount: 2,
        productImageUrls: [
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200',
          'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?q=80&w=200',
        ],
      ),
      OrderModel(
        orderId: '#ORD-2024-1233',
        date: DateTime(2026, 5, 12),
        status: 'Processing',
        totalAmount: 79.0,
        itemCount: 1,
        productImageUrls: [
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=200',
        ],
      ),
      OrderModel(
        orderId: '#ORD-2024-1232',
        date: DateTime(2026, 5, 5),
        status: 'Pending',
        totalAmount: 1099.0,
        itemCount: 1,
        productImageUrls: [
          'https://images.unsplash.com/photo-1603302576837-37561b2e2302?q=80&w=200',
        ],
      ),
    ];

    isLoading.value = false;
  }

  void setFilter(String filter) => selectedFilter.value = filter;
}
