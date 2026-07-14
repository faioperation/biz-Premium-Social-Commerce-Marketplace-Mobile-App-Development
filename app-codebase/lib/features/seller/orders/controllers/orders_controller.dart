import 'package:get/get.dart';
import '../models/order_model.dart';

// ══════════════════════════════════════════════════════════
// Seller Orders Controller
// API integration: replace loadOrders() and updateOrderStatus()
// ══════════════════════════════════════════════════════════

class SellerOrdersController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<SellerOrderModel> ordersList = <SellerOrderModel>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<OrderStatus> selectedTab = OrderStatus.newOrder.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  // ── Mock data — TODO: replace with API call ───────────────
  void loadOrders() {
    final address1 = const DeliveryAddressModel(
      fullName: 'John Smith',
      phone: '+1 (555) 123-4567',
      addressLine1: '123 Melton Road',
      addressLine2: '',
      city: 'Leicester',
      country: 'UK',
    );
    final address2 = const DeliveryAddressModel(
      fullName: 'John Smith',
      phone: '+1 (555) 123-4567',
      addressLine1: '123 Melton Road',
      city: 'Leicester',
      country: 'UK',
    );
    final address3 = const DeliveryAddressModel(
      fullName: 'John Smith',
      phone: '+1 (555) 123-4567',
      addressLine1: '123 Melton Road',
      city: 'Leicester',
      country: 'UK',
    );
    final address4 = const DeliveryAddressModel(
      fullName: 'John Smith',
      phone: '+1 (555) 123-4567',
      addressLine1: '123 Melton Road',
      city: 'Leicester',
      country: 'UK',
    );

    ordersList.assignAll([
      SellerOrderModel(
        id: '1001',
        orderNumber: '#1001',
        customerName: 'John Smith',
        customerLocation: 'Leicester, UK',
        customerAvatar: '',
        items: const [
          OrderItemModel(id: 'p1', name: 'Premium Watch', price: 299.0, quantity: 1, imageUrl: ''),
          OrderItemModel(id: 'p2', name: 'Leather Bag', price: 159.0, quantity: 1, imageUrl: ''),
        ],
        totalAmount: 458.0,
        deliveryCharge: 60.0,
        status: OrderStatus.newOrder,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: 'bKash',
        deliveryAddress: address1,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        note: 'Please pack carefully.',
      ),
      SellerOrderModel(
        id: '1002',
        orderNumber: '#1002',
        customerName: 'John Smith',
        customerLocation: 'Leicester, UK',
        customerAvatar: '',
        items: const [
          OrderItemModel(id: 'p3', name: 'Wireless Headphones', price: 199.0, quantity: 2, imageUrl: ''),
        ],
        totalAmount: 398.0,
        deliveryCharge: 80.0,
        status: OrderStatus.processing,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: 'Nagad',
        deliveryAddress: address2,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      SellerOrderModel(
        id: '1003',
        orderNumber: '#1003',
        customerName: 'John Smith',
        customerLocation: 'Leicester, UK',
        customerAvatar: '',
        items: const [
          OrderItemModel(id: 'p4', name: 'Smart Fitness Band', price: 89.0, quantity: 3, imageUrl: ''),
        ],
        totalAmount: 267.0,
        deliveryCharge: 100.0,
        status: OrderStatus.shipped,
        paymentStatus: PaymentStatus.pending,
        paymentMethod: 'Cash on Delivery',
        deliveryAddress: address3,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      SellerOrderModel(
        id: '1004',
        orderNumber: '#1004',
        customerName: 'John Smith',
        customerLocation: 'Leicester, UK',
        customerAvatar: '',
        items: const [
          OrderItemModel(id: 'p5', name: 'Premium Watch', price: 299.0, quantity: 1, imageUrl: ''),
        ],
        totalAmount: 299.0,
        deliveryCharge: 60.0,
        status: OrderStatus.completed,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: 'Card',
        deliveryAddress: address4,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ]);
  }

  // ── Filtered list (tab + search) ─────────────────────────
  List<SellerOrderModel> get filteredOrders {
    var list = ordersList.where((o) => o.status == selectedTab.value).toList();
    if (searchQuery.value.trim().isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where((o) =>
              o.orderNumber.toLowerCase().contains(q) ||
              o.customerName.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  void selectTab(OrderStatus status) => selectedTab.value = status;

  // ── Status update — TODO: call API PATCH /orders/{id}/status ──
  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = ordersList.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final old = ordersList[index];
      ordersList[index] = SellerOrderModel(
        id: old.id,
        orderNumber: old.orderNumber,
        customerName: old.customerName,
        customerLocation: old.customerLocation,
        customerAvatar: old.customerAvatar,
        items: old.items,
        totalAmount: old.totalAmount,
        deliveryCharge: old.deliveryCharge,
        status: newStatus,
        paymentStatus: old.paymentStatus,
        paymentMethod: old.paymentMethod,
        deliveryAddress: old.deliveryAddress,
        createdAt: old.createdAt,
        note: old.note,
      );
      ordersList.refresh();
    }
  }

  // ── Helpers ───────────────────────────────────────────────
  String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String formatDate(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${_twoDigits(dt.hour)}:${_twoDigits(dt.minute)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  int get totalNewOrders =>
      ordersList.where((o) => o.status == OrderStatus.newOrder).length;
}
