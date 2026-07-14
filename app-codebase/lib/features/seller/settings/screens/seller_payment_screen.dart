import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/seller_payment_controller.dart';
import '../../../buyer/checkout/widgets/payment_method_tile.dart';
import '../../../../core/theme/app_colors.dart';

/// Seller-specific payment methods screen.
/// Independent from buyer checkout — has its own controller, card list,
/// and selected default card. Sellers can add new cards and select one
/// as their primary payment method.
class SellerPaymentScreen extends StatefulWidget {
  const SellerPaymentScreen({super.key});

  @override
  State<SellerPaymentScreen> createState() => _SellerPaymentScreenState();
}

class _SellerPaymentScreenState extends State<SellerPaymentScreen> {
  late final SellerPaymentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(SellerPaymentController());
  }

  @override
  void dispose() {
    Get.delete<SellerPaymentController>();
    super.dispose();
  }

  void _showAddCardDialog() {
    showDialog(
      context: context,
      builder: (_) => _SellerAddCardDialog(controller: _controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Payment Methods',
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
        final cards = _controller.savedCards;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add New Card button
              GestureDetector(
                onTap: _showAddCardDialog,
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
                      Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
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
              const SizedBox(height: 24),

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
                ...cards.map((card) {
                  final isSelected =
                      _controller.selectedCardId.value == card.id;
                  return Dismissible(
                    key: Key(card.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20, bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    onDismissed: (_) => _controller.removeCard(card.id),
                    child: PaymentMethodTile(
                      method: card,
                      isSelected: isSelected,
                      onTap: () => _controller.selectCard(card.id),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Text(
                  'Swipe left on a card to remove it',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
              ] else ...[
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.credit_card_off_outlined,
                        size: 56,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No saved cards yet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap "Add New Card" to save your first card.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal Add Card Dialog for the seller — uses SellerPaymentController
// ---------------------------------------------------------------------------

class _SellerAddCardDialog extends StatefulWidget {
  final SellerPaymentController controller;
  const _SellerAddCardDialog({required this.controller});

  @override
  State<_SellerAddCardDialog> createState() => _SellerAddCardDialogState();
}

class _SellerAddCardDialogState extends State<_SellerAddCardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  String _detectCardType(String number) {
    if (number.startsWith('4')) return 'Visa';
    if (number.startsWith('5') || number.startsWith('2')) return 'Mastercard';
    if (number.startsWith('3')) return 'Amex';
    return 'Card';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final rawNumber = _cardNumberCtrl.text.replaceAll(' ', '');
    widget.controller.addCard(
      label: _detectCardType(rawNumber),
      cardNumber: rawNumber,
      expiry: _expiryCtrl.text.trim(),
      cvv: _cvvCtrl.text.trim(),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1625) : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Add New Card',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildField(_nameCtrl, 'Cardholder Name',
                    Icons.person_outline, isDark),
                _buildField(
                  _cardNumberCtrl,
                  'Card Number',
                  Icons.credit_card_rounded,
                  isDark,
                  keyboardType: TextInputType.number,
                  maxLength: 19,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        _expiryCtrl,
                        'MM/YY',
                        Icons.calendar_month_outlined,
                        isDark,
                        keyboardType: TextInputType.datetime,
                        maxLength: 5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        _cvvCtrl,
                        'CVV',
                        Icons.lock_outline_rounded,
                        isDark,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Save Card',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String hint,
    IconData icon,
    bool isDark, {
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        maxLength: maxLength,
        obscureText: obscureText,
        style: TextStyle(
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          hintText: hint,
          counterText: '',
          hintStyle: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
          prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
          filled: true,
          fillColor: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : const Color(0xFFF8F9FC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
        validator: (val) =>
            (val == null || val.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }
}
