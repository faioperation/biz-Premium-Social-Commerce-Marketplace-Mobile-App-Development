import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_document_viewer.dart';

class KycReviewCard extends StatefulWidget {
  final String status;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const KycReviewCard({
    super.key,
    required this.status,
    required this.onApprove,
    required this.onReject,
  });

  @override
  State<KycReviewCard> createState() => _KycReviewCardState();
}

class _KycReviewCardState extends State<KycReviewCard> {
  // Local state for document statuses
  String _idStatus = 'Verified';
  String _licenseStatus = 'Pending Review';
  String _bankStatus = 'Verified';

  @override
  Widget build(BuildContext context) {
    final bool isPending = widget.status == 'pending' || widget.status == 'unverified';

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('KYC Verification', style: AppTextStyles.h4)),
              const SizedBox(width: 8),
              _buildStatusIndicator(),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Documents Submitted:',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDocumentRow(
            context,
            Icons.badge_outlined,
            'National ID / Passport',
            _idStatus,
            (newVal) => setState(() => _idStatus = newVal),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDocumentRow(
            context,
            Icons.business_outlined,
            'Business License',
            _licenseStatus,
            (newVal) => setState(() => _licenseStatus = newVal),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDocumentRow(
            context,
            Icons.account_balance_outlined,
            'Bank Statement',
            _bankStatus,
            (newVal) => setState(() => _bankStatus = newVal),
          ),
          
          if (isPending) ...[
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Reject KYC',
                    type: AppButtonType.outline,
                    onPressed: widget.onReject,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: 'Approve KYC',
                    onPressed: widget.onApprove,
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color color;
    IconData icon;
    if (widget.status == 'approved') {
      color = AppColors.success;
      icon = Icons.check_circle;
    } else if (widget.status == 'rejected') {
      color = AppColors.error;
      icon = Icons.cancel;
    } else {
      color = AppColors.warning;
      icon = Icons.pending;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          widget.status.toUpperCase(),
          style: AppTextStyles.body.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDocumentRow(
    BuildContext context,
    IconData icon,
    String name,
    String docStatus,
    ValueChanged<String> onStatusChanged,
    {String? documentUrl}
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(left: AppSpacing.md, right: 4, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(name, style: AppTextStyles.body),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: docStatus,
              icon: Icon(Icons.arrow_drop_down, size: 20, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              isDense: true,
              dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              style: AppTextStyles.bodySm.copyWith(
                color: docStatus == 'Verified' ? AppColors.success : (docStatus == 'Rejected' ? AppColors.error : AppColors.warning),
                fontWeight: FontWeight.w600,
              ),
              items: ['Pending Review', 'Verified', 'Rejected']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(
                          status,
                          style: AppTextStyles.bodySm.copyWith(
                            color: status == 'Verified' ? AppColors.success : (status == 'Rejected' ? AppColors.error : AppColors.warning),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  onStatusChanged(newValue);
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_red_eye, size: 20, color: AppColors.primary),
            tooltip: 'View Document',
            onPressed: () {
              AppDocumentViewer.show(
                context,
                title: name,
                documentUrl: documentUrl ?? 'mock://placeholder',
              );
            },
          ),
        ],
      ),
    );
  }
}
