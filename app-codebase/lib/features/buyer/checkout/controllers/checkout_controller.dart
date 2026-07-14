import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../models/address_model.dart';
import '../models/payment_method_model.dart';
import '../models/delivery_option_model.dart';
import '../models/order_item_model.dart';
import '../../profile/controllers/cart_controller.dart';

class CheckoutController extends GetxController {
  final selectedAddressId = ''.obs;
  final selectedPaymentId = ''.obs;
  final selectedDeliveryId = ''.obs;
  final isPlacingOrder = false.obs;

  final orderNumber = ''.obs;
  final estimatedDelivery = ''.obs;

  final addresses = <AddressModel>[
    AddressModel(
      id: 'addr1',
      label: 'Home',
      name: 'John Smith',
      house: '123 Melton Road',
      street: 'Leicester',
      town: 'UK',
      phone: '+1 (555) 123-4567',
      isDefault: true,
    ),
    AddressModel(
      id: 'addr2',
      label: 'Work',
      name: 'John Smith',
      house: '123 Melton Road',
      street: 'Leicester',
      town: 'UK',
      phone: '+1 (555) 123-4567',
    ),
  ].obs;

  final paymentMethods = <PaymentMethodModel>[
    PaymentMethodModel(
      id: 'wallet',
      type: 'wallet',
      label: 'Vango Wallet',
      walletBalance: 150.50,
    ),
    PaymentMethodModel(
      id: 'card1',
      type: 'card',
      label: 'Visa',
      last4: '4242',
      expiry: '12/24',
      isDefault: true,
    ),
    PaymentMethodModel(
      id: 'card2',
      type: 'card',
      label: 'Mastercard',
      last4: '8888',
      expiry: '06/25',
    ),
    PaymentMethodModel(id: 'cash', type: 'cash', label: 'Cash on Delivery'),
  ].obs;

  final deliveryOptions = <DeliveryOptionModel>[
    DeliveryOptionModel(
      id: 'standard',
      name: 'Standard Delivery',
      duration: '3-5 days',
      price: 0.0,
    ),
    DeliveryOptionModel(
      id: 'express',
      name: 'Express Delivery',
      duration: '1-2 days',
      price: 15.0,
    ),
    DeliveryOptionModel(
      id: 'sameday',
      name: 'Same Day Delivery',
      duration: 'Today by 9pm',
      price: 25.0,
    ),
  ].obs;

  final orderItems = <OrderItemModel>[].obs;

  AddressModel? get selectedAddress {
    try {
      return addresses.firstWhere((a) => a.id == selectedAddressId.value);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  PaymentMethodModel? get selectedPayment {
    try {
      return paymentMethods.firstWhere((p) => p.id == selectedPaymentId.value);
    } catch (_) {
      return paymentMethods.firstWhere(
        (p) => p.isDefault,
        orElse: () => paymentMethods.first,
      );
    }
  }

  DeliveryOptionModel? get selectedDelivery {
    try {
      return deliveryOptions.firstWhere(
        (d) => d.id == selectedDeliveryId.value,
      );
    } catch (_) {
      return deliveryOptions.isNotEmpty ? deliveryOptions.first : null;
    }
  }

  double get itemsTotal =>
      orderItems.fold(0.0, (sum, item) => sum + item.subtotal);

  double get deliveryFee => selectedDelivery?.price ?? 0.0;

  double get grandTotal => itemsTotal + deliveryFee;

  @override
  void onInit() {
    super.onInit();
    // Set defaults
    selectedAddressId.value =
        addresses.firstWhereOrNull((a) => a.isDefault)?.id ??
        addresses.first.id;
    selectedPaymentId.value =
        paymentMethods.firstWhereOrNull((p) => p.isDefault)?.id ??
        paymentMethods.first.id;
    selectedDeliveryId.value = deliveryOptions.first.id;
  }

  void loadBuyNowItem(OrderItemModel item) {
    orderItems.clear();
    orderItems.add(item);
  }

  void loadFromCart() {
    if (Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      final items = cartController.items.map((c) => OrderItemModel(
        productId: c.productId,
        name: c.name,
        imageUrl: c.imageUrl,
        price: c.price,
        quantity: c.quantity,
      )).toList();
      orderItems.assignAll(items);
    }
  }

  void selectAddress(String id) => selectedAddressId.value = id;

  void addAddress(AddressModel address) {
    addresses.add(address);
    selectedAddressId.value = address.id;
  }

  void selectPayment(String id) => selectedPaymentId.value = id;

  void addCard({
    required String label,
    required String cardNumber,
    required String expiry,
    required String cvv,
  }) {
    final last4 = cardNumber.length >= 4
        ? cardNumber.substring(cardNumber.length - 4)
        : cardNumber;
    paymentMethods.add(
      PaymentMethodModel(
        id: 'card_${DateTime.now().millisecondsSinceEpoch}',
        type: 'card',
        label: label,
        last4: last4,
        expiry: expiry,
      ),
    );
  }

  void selectDelivery(String id) => selectedDeliveryId.value = id;

  Future<void> placeOrder(BuildContext context) async {
    if (orderItems.isEmpty) return;

    isPlacingOrder.value = true;

    final router = GoRouter.of(context);

    await Future.delayed(const Duration(milliseconds: 1200));

    orderNumber.value =
        '#ORD-${DateTime.now().year}-${(DateTime.now().millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}';

    final deliveryDays = selectedDelivery?.id == 'express'
        ? 2
        : selectedDelivery?.id == 'sameday'
        ? 0
        : 4;
    final deliveryDate = DateTime.now().add(Duration(days: deliveryDays));
    estimatedDelivery.value =
        '${_monthName(deliveryDate.month)} ${deliveryDate.day}-${deliveryDate.day + 2}, ${deliveryDate.year}';

    isPlacingOrder.value = false;

    router.push('/checkout/success');
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}
