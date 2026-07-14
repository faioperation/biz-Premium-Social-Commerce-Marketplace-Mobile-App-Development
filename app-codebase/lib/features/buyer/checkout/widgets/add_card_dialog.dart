import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/checkout_controller.dart';

class AddCardDialog extends StatefulWidget {
  const AddCardDialog({super.key});

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
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

    final controller = Get.find<CheckoutController>();
    final cardType = _detectCardType(_cardNumberCtrl.text.replaceAll(' ', ''));
    controller.addCard(
      label: cardType,
      cardNumber: _cardNumberCtrl.text.replaceAll(' ', ''),
      expiry: _expiryCtrl.text.trim(),
      cvv: _cvvCtrl.text.trim(),
    );
    controller.selectPayment(controller.paymentMethods.last.id);

    Navigator.of(context).pop();
    Get.snackbar(
      'Card Added',
      '$cardType card saved successfully!',
      backgroundColor: AppColors.success,
      colorText: Colors.white,
    );
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

                _buildField(
                  _nameCtrl,
                  'Cardholder Name',
                  Icons.person_outline,
                  isDark,
                ),
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
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
        ),
        validator: (val) =>
            (val == null || val.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }
}
