import 'package:flutter/material.dart';
import 'package:ecommerce_bizsolutio/core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/payment_method_model.dart';

class PaymentMethodTile extends StatelessWidget {
  final PaymentMethodModel method;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    switch (method.type) {
      case 'wallet':
        return Icons.account_balance_wallet_outlined;
      case 'cash':
        return Icons.payments_outlined;
      case 'card':
      default:
        return Icons.credit_card_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWallet = method.type == 'wallet';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isWallet
              ? const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isWallet
              ? null
              : isDark
              ? const Color(0xFF1A1625)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isWallet
              ? null
              : Border.all(
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
            if (!isWallet) ...[
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade400,
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
            ],
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isWallet
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _icon,
                color: isWallet ? Colors.white : AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        method.label,
                        style: TextStyle(
                          color: isWallet
                              ? Colors.white
                              : isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (method.isDefault && !isWallet) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Default',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isWallet
                        ? 'Available Balance'
                        : '${method.last4 != null ? '•••• •••• •••• ${method.last4}' : ''} ${method.expiry != null ? '| Exp: ${method.expiry}' : ''}',
                    style: TextStyle(
                      color: isWallet
                          ? Colors.white.withValues(alpha: 0.8)
                          : isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                  if (isWallet) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${AppConstants.currencySymbol}${method.walletBalance?.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isWallet)
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
