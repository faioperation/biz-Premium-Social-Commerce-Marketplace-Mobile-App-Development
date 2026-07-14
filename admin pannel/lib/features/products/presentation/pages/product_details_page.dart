import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/currency_formatter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/router/route_names.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;
  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late final ProductDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProductDetailsController>();
    controller.loadProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.product.value == null) {
        return const Center(child: AppLoader());
      }

      final product = controller.product.value;
      if (product == null) {
        return const Center(child: Text('Product not found'));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Product Details', style: AppTextStyles.h2),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Images & Info
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Images Carousel placeholder
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: product.imageUrls.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: AppSpacing.md),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        product.imageUrls[index],
                                        width: 300,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 300,
                                          color: (Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight),
                                          child: Icon(Icons.image_not_supported, size: 50, color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(product.name, style: AppTextStyles.h2),
                                      const SizedBox(height: AppSpacing.sm),
                                      Text(product.category, style: AppTextStyles.body.copyWith(color: AppColors.primary)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      CurrencyFormatter.format(product.price),
                                      style: AppTextStyles.h2.copyWith(color: AppColors.success),
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    _buildStatusChip(product.status),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Text('Description', style: AppTextStyles.h4),
                            const SizedBox(height: AppSpacing.md),
                            Text(product.description, style: AppTextStyles.body.copyWith(height: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                
                // Right Column: Seller, Stats & Actions
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Inventory & Stats', style: AppTextStyles.h4),
                            const SizedBox(height: AppSpacing.lg),
                            _buildInfoRow('Stock Available', '\${product.stock} units'),
                            const Divider(),
                            _buildInfoRow('Rating', '\${product.rating} ★'),
                            const Divider(),
                            _buildInfoRow('Reviews', '\${product.reviewCount}'),
                            const Divider(),
                            _buildInfoRow('Listed On', DateFormat('MMM d, yyyy').format(product.createdAt)),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Seller Information', style: AppTextStyles.h4),
                            const SizedBox(height: AppSpacing.lg),
                            _buildInfoRow('Shop Name', product.sellerShopName),
                            const Divider(),
                            _buildInfoRow('Owner', product.sellerName),
                            const SizedBox(height: AppSpacing.md),
                            SizedBox(
                              width: double.infinity,
                              child: AppButton(
                                label: 'View Seller Profile',
                                type: AppButtonType.outline,
                                onPressed: () {
                                  context.pushNamed(RouteNames.sellerDetails, pathParameters: {'id': product.sellerId});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Administrative Actions', style: AppTextStyles.h4.copyWith(color: AppColors.error)),
                            const SizedBox(height: AppSpacing.lg),
                            
                            if (product.status == 'pending') ...[
                              _buildActionTile('Approve Product', 'Make product visible to users.', 'Approve', controller.approveProduct),
                              const Divider(),
                              _buildActionTile('Reject Product', 'Deny product listing.', 'Reject', controller.rejectProduct, isDestructive: true),
                              const Divider(),
                            ],

                            _buildActionTile(
                              'Feature Product', 
                              product.isFeatured ? 'Product is already featured.' : 'Promote this product to the front page.', 
                              'Feature', 
                              controller.featureProduct,
                            ),
                            const Divider(),
                            _buildActionTile(
                              'Disable Product', 
                              product.status == 'disabled' ? 'Product is already disabled.' : 'Remove product from user view.', 
                              'Disable', 
                              controller.disableProduct,
                              isDestructive: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatusChip(String status) {
    AppStatusType type;
    if (status == 'approved' || status == 'featured') {
      type = AppStatusType.success;
    } else if (status == 'rejected' || status == 'disabled') {
      type = AppStatusType.error;
    } else {
      type = AppStatusType.warning;
    }
    return AppStatusChip(label: status.toUpperCase(), type: type);
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, String description, String buttonLabel, VoidCallback onPressed, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h5.copyWith(color: isDestructive ? AppColors.error : (Theme.of(context).brightness == Brightness.dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))),
                const SizedBox(height: 4),
                Text(description, style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
              ],
            ),
          ),
          AppButton(
            label: buttonLabel,
            type: AppButtonType.outline,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AppConfirmationDialog(
                  title: title,
                  content: 'Are you sure you want to perform this action?',
                  confirmText: 'Confirm',
                  cancelText: 'Cancel',
                  onConfirm: onPressed,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
