import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/shop_controller.dart';
import '../widgets/shop_sliver_app_bar_delegate.dart';
import '../widgets/shop_cover_header.dart';
import '../widgets/shop_profile_details.dart';
import '../widgets/shop_products_tab.dart';
import '../widgets/shop_live_tab.dart';
import '../widgets/shop_about_tab.dart';

class ShopProfileScreen extends StatefulWidget {
  final String sellerName;
  final String profileImageUrl;

  const ShopProfileScreen({
    super.key,
    required this.sellerName,
    required this.profileImageUrl,
  });

  @override
  State<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ShopController controller = Get.put(ShopController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    controller.loadShopDetails(widget.sellerName, widget.profileImageUrl);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final shop = controller.shop.value;
        if (shop == null) return const Center(child: Text('Shop not found'));

        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              ShopCoverHeader(
                coverImageUrl: shop.coverImageUrl,
                isDark: isDark,
                shopId: shop.id,
                shopName: shop.name,
              ),
              ShopProfileDetails(
                shop: shop,
                controller: controller,
                isDark: isDark,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: ShopSliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark
                        ? Colors.grey[500]
                        : Colors.grey[400],
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Inter',
                    ),
                    tabs: const [
                      Tab(text: 'Products'),
                      Tab(text: 'Live'),
                      Tab(text: 'About'),
                    ],
                  ),
                  isDark,
                ),
              ),
            ];
          },
          body: Container(
            color: isDark ? Colors.black : const Color(0xFFF8F9FC),
            child: TabBarView(
              controller: _tabController,
              children: [
                ShopProductsTab(controller: controller),
                ShopLiveTab(isLive: shop.isLive, isDark: isDark),
                ShopAboutTab(description: shop.description, isDark: isDark),
              ],
            ),
          ),
        );
      }),
    );
  }
}
