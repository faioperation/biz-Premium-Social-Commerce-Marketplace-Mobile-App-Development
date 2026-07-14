import 'package:get/get.dart';
import '../../../buyer/checkout/models/payment_method_model.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Manages the seller's own saved payment methods independently
/// from the buyer checkout flow. Cards can be added and a default
/// can be selected without affecting checkout state.
class SellerPaymentController extends GetxController {
  final RxList<PaymentMethodModel> savedCards = <PaymentMethodModel>[].obs;
  final RxString selectedCardId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Pre-populate with a sample card so the screen doesn't look empty on first launch
    savedCards.addAll([
      PaymentMethodModel(
        id: 'seller_card_1',
        label: 'Visa',
        type: 'card',
        last4: '4242',
        expiry: '12/27',
        isDefault: true,
      ),
    ]);
    selectedCardId.value = 'seller_card_1';
  }

  /// Select a card as the default payment card
  void selectCard(String id) {
    selectedCardId.value = id;
  }

  /// Add a new card to the seller's saved list
  void addCard({
    required String label,
    required String cardNumber,
    required String expiry,
    required String cvv,
  }) {
    final last4 = cardNumber.length >= 4
        ? cardNumber.substring(cardNumber.length - 4)
        : cardNumber;
    final newCard = PaymentMethodModel(
      id: 'seller_card_${DateTime.now().millisecondsSinceEpoch}',
      label: label,
      type: 'card',
      last4: last4,
      expiry: expiry,
      isDefault: savedCards.isEmpty,
    );
    savedCards.add(newCard);
    // Auto-select the new card
    selectedCardId.value = newCard.id;

    Get.snackbar(
      'Card Added',
      '$label card saved successfully!',
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Remove a card from the seller's list
  void removeCard(String id) {
    savedCards.removeWhere((c) => c.id == id);
    if (selectedCardId.value == id) {
      selectedCardId.value = savedCards.isNotEmpty ? savedCards.first.id : '';
    }
  }
}
