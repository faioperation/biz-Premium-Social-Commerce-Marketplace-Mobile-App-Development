import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../../Store/widgets/settings_text_field.dart';
import '../controllers/setup_livestream_controller.dart';
import '../widgets/live_product_selection_card.dart';
import '../widgets/live_type_selector.dart';
import '../widgets/tips_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/live_session_data.dart';

/// The central Setup Livestream screen allowing sellers to configure
/// their upcoming live stream broadcast details.
class SetupLivestreamScreen extends StatefulWidget {
  const SetupLivestreamScreen({super.key});

  @override
  State<SetupLivestreamScreen> createState() => _SetupLivestreamScreenState();
}

class _SetupLivestreamScreenState extends State<SetupLivestreamScreen> {
  final SetupLivestreamController _controller = Get.put(SetupLivestreamController());

  @override
  void dispose() {
    Get.delete<SetupLivestreamController>();
    super.dispose();
  }

  /// Handles submit execution
  void _handleSubmit() {
    final sessionData = _controller.validateAndSubmit(context);
    if (sessionData != null) {
      context.push(AppRoutes.sellerLiveBroadcast, extra: sessionData).then((_) {
        // Clear all selections when returning from a broadcast
        _controller.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-specific background parameters
    final Color backgroundColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color cardColor = isDark ? AppColors.darkCard : Colors.white;
    final Color labelColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            size: 20,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.sellerDashboard);
            }
          },
        ),
        title: Text(
          'Setup Livestream',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.history_rounded,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            tooltip: 'Past Lives',
            onPressed: () => context.push(AppRoutes.sellerPastLivesList),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 0. Past Lives Quick Access Banner
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF2E1A47), const Color(0xFF1E1E22)]
                            : [const Color(0xFFECE6F5), Colors.white],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => context.push(AppRoutes.sellerPastLivesList),
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.video_library_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recorded Live Streams',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Review comments, sales data, and replay previous streams.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // 1. Stream Title Form
                  SettingsTextField(
                    label: 'Stream Title',
                    controller: _controller.titleController,
                    placeholder: 'Enter stream title',
                  ),
                  const SizedBox(height: 24),
                  
                  // 2. Products List Header
                  Text(
                    'Select Products to Feature',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Search Bar Widget
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: TextField(
                      onChanged: (val) => _controller.searchQuery.value = val,
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: TextStyle(
                          color: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary).withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Interactive reactive list of products
                  Obx(() {
                    final products = _controller.filteredProducts;
                    // Force Obx to track the selection list by reading it synchronously
                    final selectedList = _controller.selectedProducts.toList();
                    
                    if (products.isEmpty) {
                      final hasSearch = _controller.searchQuery.value.trim().isNotEmpty;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          hasSearch
                              ? 'No products match your search.'
                              : 'No products found in your store. Add products to feature them.',
                          style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final isSelected = selectedList.any((p) => p.id == product.id);
                        
                        return LiveProductSelectionCard(
                          product: product,
                          isSelected: isSelected,
                          onChanged: (_) => _controller.toggleProductSelection(product),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 24),
                  
                  // 3. Live Type Selection (Sell vs Bidding)
                  Obx(() {
                    final isBidding = _controller.selectedLiveType.value == LiveType.bidding;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LiveTypeSelector(
                          selectedType: _controller.selectedLiveType.value,
                          onTypeSelected: _controller.selectLiveType,
                        ),
                        if (isBidding) ...[
                          const SizedBox(height: 24),
                          SettingsTextField(
                            label: 'Starting Bid Amount (\$)',
                            controller: _controller.startingBidController,
                            placeholder: 'Enter starting bid price (e.g. 50)',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 24),
                          SettingsTextField(
                            label: 'Bidding Duration (Minutes)',
                            controller: _controller.biddingDurationController,
                            placeholder: 'Enter duration in minutes (e.g. 10)',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ],
                    );
                  }),
                  const SizedBox(height: 24),
                  
                  // 4. Suggestions advice card
                  const TipsCard(),
                ],
              ),
            ),
          ),
          
          // Persistent Continue Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(
                top: BorderSide(color: borderColor, width: 1),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.sellerDashboard);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white70 : Colors.black87,
                        side: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 1,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Go Live',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
