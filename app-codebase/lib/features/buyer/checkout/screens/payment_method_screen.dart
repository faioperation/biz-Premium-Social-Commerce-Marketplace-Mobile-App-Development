import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/checkout_controller.dart';
import '../models/payment_method_model.dart';
import '../widgets/payment_method_tile.dart';
import '../widgets/add_card_dialog.dart';

class PaymentMethodScreen extends StatelessWidget {
  final bool isSelectionMode;
  const PaymentMethodScreen({super.key, this.isSelectionMode = true});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          'Payment Method',
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
        final wallet = controller.paymentMethods.firstWhereOrNull(
          (p) => p.type == 'wallet',
        );
        final cards = controller.paymentMethods
            .where((p) => p.type == 'card')
            .toList();
        final cashOpt = controller.paymentMethods.firstWhereOrNull(
          (p) => p.type == 'cash',
        );

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const AddCardDialog(),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add New Card',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (wallet != null) ...[
                PaymentMethodTile(
                  method: wallet,
                  isSelected: isSelectionMode && controller.selectedPaymentId.value == wallet.id,
                  onTap: () {
                    if (isSelectionMode) {
                      controller.selectPayment(wallet.id);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                const SizedBox(height: 8),
              ],

              if (cards.isNotEmpty) ...[
                Text(
                  'Saved Cards',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                ...cards.map(
                  (card) => PaymentMethodTile(
                    method: card,
                    isSelected: isSelectionMode && controller.selectedPaymentId.value == card.id,
                    onTap: () {
                      if (isSelectionMode) {
                        controller.selectPayment(card.id);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],

              if (isSelectionMode && cashOpt != null) ...[
                const SizedBox(height: 8),
                _buildCashOnDelivery(context, controller, cashOpt, isDark),
              ],

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCashOnDelivery(
    BuildContext context,
    CheckoutController controller,
    PaymentMethodModel cashOpt,
    bool isDark,
  ) {
    final isSelected = controller.selectedPaymentId.value == cashOpt.id;

    return GestureDetector(
      onTap: () {
        controller.selectPayment(cashOpt.id);
        Navigator.of(context).pop();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1625) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isDark
                ? const Color(0xFF2A2535)
                : AppColors.lightBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.payments_outlined,
                color: AppColors.success,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Cash on Delivery',
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
