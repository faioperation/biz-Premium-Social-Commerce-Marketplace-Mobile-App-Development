import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/cart_item_model.dart';

class CartController extends GetxController {
  final isLoading = false.obs;
  final items = <CartItemModel>[].obs;
  final couponController = TextEditingController();
  final appliedCoupon = Rxn<String>();
  final couponDiscount = 0.0.obs;
  final shippingFee = 10.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }

  Future<void> loadCart() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));

    items.value = [
      CartItemModel(
        productId: 'prod1',
        name: 'Smart Watch Ultra',
        sellerName: 'TechStore',
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200',
        price: 299.0,
        quantity: 1,
      ),
      CartItemModel(
        productId: 'prod5',
        name: 'Wireless Headphones Pro',
        sellerName: 'AudioHub',
        imageUrl:
            'https://images.unsplash.com/photo-1484704849700-f032a568e944?q=80&w=200',
        price: 99.0,
        quantity: 2,
      ),
    ];

    isLoading.value = false;
  }

  double get subtotal => items.fold(0.0, (sum, i) => sum + i.subtotal);
  double get grandTotal => subtotal + shippingFee.value - couponDiscount.value;
  int get totalItemCount => items.fold(0, (sum, i) => sum + i.quantity);

  void addItem(CartItemModel item) {
    final idx = items.indexWhere((i) => i.productId == item.productId);
    if (idx != -1) {
      items[idx].quantity += item.quantity;
      items.refresh();
    } else {
      items.add(item);
    }
  }

  /// TODO: Replace with real API call → PATCH /api/buyer/cart/{productId}
  void incrementQuantity(String productId) {
    final idx = items.indexWhere((i) => i.productId == productId);
    if (idx != -1) {
      items[idx].quantity++;
      items.refresh();
    }
  }

  void decrementQuantity(String productId) {
    final idx = items.indexWhere((i) => i.productId == productId);
    if (idx != -1) {
      if (items[idx].quantity > 1) {
        items[idx].quantity--;
        items.refresh();
      }
    }
  }

  void removeItem(String productId) {
    items.removeWhere((i) => i.productId == productId);
    Get.snackbar(
      'Removed',
      'Item removed from cart',
      duration: const Duration(seconds: 2),
    );
  }

  void applyCoupon() {
    final code = couponController.text.trim().toUpperCase();
    if (code == 'SAVE10') {
      appliedCoupon.value = code;
      couponDiscount.value = subtotal * 0.10;
      Get.snackbar(
        'Coupon Applied',
        '10% discount applied!',
        duration: const Duration(seconds: 2),
      );
    } else {
      appliedCoupon.value = null;
      couponDiscount.value = 0;
      Get.snackbar(
        'Invalid Coupon',
        'Coupon code not found.',
        duration: const Duration(seconds: 2),
      );
    }
  }
}
