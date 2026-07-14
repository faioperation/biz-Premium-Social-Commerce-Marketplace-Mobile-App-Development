import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_routes.dart';
import '../../controllers/seller_registration_controller.dart';

class SellerRegistrationScreen2 extends StatelessWidget {
  const SellerRegistrationScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellerRegistrationController>();

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.sellerBackground
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.sellerBackground
            : Theme.of(context).appBarTheme.backgroundColor,
        title: const Text('Business Info'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsAllLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us about your shop',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkBodyTitle
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Provide your business details to get started.',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkDescription
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 32),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Shop Name',
                hintText: 'Enter your shop name',
                prefixIcon: Icon(
                  Icons.store_outlined,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.sellerIcon
                      : null,
                ),
              ),
              onChanged: controller.updateShopName,
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Business Type',
                prefixIcon: Icon(
                  Icons.business_outlined,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.sellerIcon
                      : null,
                ),
              ),
              items: ['Individual', 'Company', 'Brand'].map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (val) => controller.updateBusinessType(val ?? ''),
            ),
            const SizedBox(height: 20),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Country',
                hintText: 'Your business country',
                prefixIcon: Icon(
                  Icons.public_outlined,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.sellerIcon
                      : null,
                ),
              ),
              onChanged: controller.updateCountry,
            ),
            const SizedBox(height: 32),

            Text(
              'Select Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkBodyTitle
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  [
                    'Fashion',
                    'Electronics',
                    'Beauty',
                    'Home',
                    'Food',
                    'Art',
                  ].map((cat) {
                    return Obx(() {
                      final isSelected = controller.categories.contains(cat);
                      return FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) => controller.toggleCategory(cat),
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        checkmarkColor: AppColors.primary,
                      );
                    });
                  }).toList(),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.push(AppRoutes.sellerRegStep3),
                child: const Text(
                  'Next Step',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
