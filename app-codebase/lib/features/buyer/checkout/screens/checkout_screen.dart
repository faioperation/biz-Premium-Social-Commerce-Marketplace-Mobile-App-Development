import 'package:flutter/material.dart';
import 'package:ecommerce_bizsolutio/core/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/checkout_controller.dart';
import '../models/order_item_model.dart';
import '../widgets/checkout_section_card.dart';
import '../widgets/order_item_row.dart';

class CheckoutScreen extends StatelessWidget {
  final OrderItemModel? buyNowItem;

  const CheckoutScreen({super.key, this.buyNowItem});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (buyNowItem != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Only load if it's not already the only item, to prevent infinite loops or unnecessary updates
        if (controller.orderItems.isEmpty || controller.orderItems.first.productId != buyNowItem!.productId) {
          controller.loadBuyNowItem(buyNowItem!);
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadFromCart();
      });
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Checkout',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        final address = controller.selectedAddress;
        final payment = controller.selectedPayment;
        final delivery = controller.selectedDelivery;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckoutSectionCard(
                      title: 'Delivery Address',
                      titleIcon: Icons.location_on_outlined,
                      showArrow: true,
                      onTap: () => context.push('/checkout/address'),
                      child: address == null
                          ? const Text('No address selected')
                          : _addressPreview(address, isDark),
                    ),
                    const SizedBox(height: 12),

                    CheckoutSectionCard(
                      title: 'Payment Method',
                      titleIcon: Icons.credit_card_rounded,
                      showArrow: true,
                      onTap: () => context.push('/checkout/payment'),
                      child: payment == null
                          ? const Text('No payment selected')
                          : _paymentPreview(payment, isDark),
                    ),
                    const SizedBox(height: 12),

                    CheckoutSectionCard(
                      title: 'Delivery Options',
                      titleIcon: Icons.local_shipping_outlined,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedDeliveryId.value,
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.primary,
                          ),
                          dropdownColor: isDark
                              ? const Color(0xFF1A1625)
                              : Colors.white,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          items: controller.deliveryOptions.map((opt) {
                            return DropdownMenuItem<String>(
                              value: opt.id,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${opt.name} (${opt.duration})',
                                        style: TextStyle(
                                          color: isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.lightTextPrimary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    opt.priceDisplay,
                                    style: TextStyle(
                                      color: opt.price == 0
                                          ? AppColors.success
                                          : AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) controller.selectDelivery(val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    CheckoutSectionCard(
                      title: 'Order Items',
                      titleIcon: Icons.shopping_bag_outlined,
                      child: controller.orderItems.isEmpty
                          ? const Text('No items')
                          : Column(
                              children: [
                                ...controller.orderItems.map(
                                  (item) => OrderItemRow(item: item),
                                ),
                                const Divider(height: 24),
                                if (delivery != null && delivery.price > 0) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Delivery Fee',
                                        style: TextStyle(
                                          color: isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextSecondary,
                                          fontSize: 13,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      Text(
                                        '${AppConstants.currencySymbol}${delivery.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.lightTextPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.lightTextPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    Text(
                                      '${AppConstants.currencySymbol}${controller.grandTotal.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            _buildPlaceOrderButton(context, controller, isDark),
          ],
        );
      }),
    );
  }

  Widget _addressPreview(address, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.name,
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${address.house}\n${address.street}\n${address.phone}',
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontSize: 13,
            height: 1.5,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _paymentPreview(payment, bool isDark) {
    return Text(
      payment.displayText,
      style: TextStyle(
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        fontSize: 13,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildPlaceOrderButton(
    BuildContext context,
    CheckoutController controller,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(
          () => SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.isPlacingOrder.value
                  ? null
                  : () => controller.placeOrder(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withValues(
                  alpha: 0.6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: controller.isPlacingOrder.value
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Obx(
                      () => Text(
                        'Place Order • ${AppConstants.currencySymbol}${controller.grandTotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
