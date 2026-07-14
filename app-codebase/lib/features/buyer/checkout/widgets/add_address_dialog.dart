import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/checkout_controller.dart';
import '../models/address_model.dart';

class AddAddressDialog extends StatefulWidget {
  const AddAddressDialog({super.key});

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _houseCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _townCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _selectedLabel = 'Home';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _houseCtrl.dispose();
    _streetCtrl.dispose();
    _townCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<CheckoutController>();
    controller.addAddress(
      AddressModel(
        id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
        label: _selectedLabel,
        name: _nameCtrl.text.trim(),
        house: _houseCtrl.text.trim(),
        street: _streetCtrl.text.trim(),
        town: _townCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
      ),
    );

    Navigator.of(context).pop();
    Get.snackbar(
      'Address Added',
      'New address saved successfully!',
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
                        'Add New Address',
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

                Text(
                  'Address Type',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['Home', 'Work', 'Other'].map((label) {
                    final selected = _selectedLabel == label;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedLabel = label),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: selected ? Colors.white : AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                _buildField(
                  _nameCtrl,
                  'Full Name',
                  Icons.person_outline,
                  isDark,
                ),
                _buildField(
                  _houseCtrl,
                  'House / Flat No.',
                  Icons.home_outlined,
                  isDark,
                ),
                _buildField(
                  _streetCtrl,
                  'Street / Area',
                  Icons.location_on_outlined,
                  isDark,
                ),
                _buildField(
                  _townCtrl,
                  'Town / City & Postcode',
                  Icons.location_city_outlined,
                  isDark,
                ),
                _buildField(
                  _phoneCtrl,
                  'Phone Number',
                  Icons.phone_outlined,
                  isDark,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 24),

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
                      'Save Address',
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: TextStyle(
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          hintText: hint,
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
