import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

class AppDocumentViewer extends StatelessWidget {
  final String title;
  final String documentUrl;
  final String documentType; // e.g. 'image', 'pdf'

  const AppDocumentViewer({
    super.key,
    required this.title,
    required this.documentUrl,
    this.documentType = 'image',
  });

  static void show(BuildContext context, {
    required String title,
    required String documentUrl,
    String documentType = 'image',
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AppDocumentViewer(
        title: title,
        documentUrl: documentUrl,
        documentType: documentType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 800),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(title, style: AppTextStyles.h3)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                  child: _buildDocumentContent(context),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  label: 'Close',
                  type: AppButtonType.outline,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: AppSpacing.md),
                AppButton(
                  label: 'Download',
                  icon: Icons.download_rounded,
                  onPressed: () {
                    // TODO: Implement document download logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Download started...')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentContent(BuildContext context) {
    // In the future, we can add logic here to differentiate between PDF and Image.
    // For now, if there is a URL we attempt to show it as an Image.
    // If it's a placeholder, we just show a mockup UI.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (documentUrl.isEmpty || documentUrl.startsWith('mock://')) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.insert_drive_file_outlined, 
                size: 64, 
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              const SizedBox(height: 16),
              Text(
                'Document Preview Not Available',
                style: AppTextStyles.h4.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This is a placeholder for the actual document. In a real scenario, the image or PDF will be rendered here.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySm.copyWith(
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Image.network(
      documentUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('Failed to load document image.', style: TextStyle(color: AppColors.error)),
          ),
        );
      },
    );
  }
}
