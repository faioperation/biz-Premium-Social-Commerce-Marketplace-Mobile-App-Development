import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/services/app_share_service.dart';
import '../models/store_model.dart';

/// GetX controller for managing the Store Profile data and user actions.
/// Designed for easy integration with future REST/GraphQL endpoints.
class StoreController extends GetxController {
  final Rxn<StoreModel> store = Rxn<StoreModel>();
  final RxBool isLoading = false.obs;
  
  // Reactive banner path representing active banner image
  final RxnString bannerImagePath = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadStoreData();
  }

  /// Simulation of fetching store data from a remote API
  void loadStoreData() async {
    isLoading.value = true;
    
    // Simulate short network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Seed mock data that matches the client's mockup screenshot exactly
    store.value = StoreModel(
      id: 'store_123',
      name: 'My Store',
      category: 'Electronics & Fashion',
      avatar: '🏪', // 24/7 Store Emoji matching mockup
      followers: 2458,
      rating: 4.8,
      productsCount: 127,
      bannerImagePath: null, // Start with no user uploaded banner
      description: 'Your premium boutique destination for curated high-quality watches, bags, and electronic accessories.',
      contactEmail: 'mystore@example.com',
      phoneNumber: '+1 (555) 123-4567',
      shippingPolicy: 'We ship orders within 24-48 hours. Delivery takes 2-3 business days within Dhaka, and 5-7 business days across other areas of Bangladesh. Enjoy free shipping on orders above ${AppConstants.currencySymbol}5,000.',
      returnPolicy: 'We accept returns within 7 days of delivery. Items must be in their original packaging, unused, and with all tags intact. Return shipping charges apply unless the item is defective.',
      termsOfService: 'By shopping on My Store, you agree to our terms of service. All product warranties are subject to original brand manufacturer policies. Prices are subject to change without prior notice.',
      featuredProducts: [
        StoreProductModel(
          id: 'p1',
          title: 'Premium Watch',
          price: 299.0,
          image: '⌚', // Watch emoji
        ),
        StoreProductModel(
          id: 'p2',
          title: 'Leather Bag',
          price: 159.0,
          image: '👜', // Handbag emoji
        ),
        StoreProductModel(
          id: 'p3',
          title: 'Wireless Headphones',
          price: 199.0,
          image: '🎧', // Headphone emoji
        ),
        StoreProductModel(
          id: 'p4',
          title: 'Smart Fitness Band',
          price: 89.0,
          image: '⌚', // Smart band emoji
        ),
      ],
    );

    // Initialize reactive banner path from model
    bannerImagePath.value = store.value?.bannerImagePath;

    isLoading.value = false;
  }

  /// Update active banner image path reactively
  void updateBanner(String? filePath) {
    bannerImagePath.value = filePath;
  }

  /// Saves the settings updates into our reactive StoreModel
  void saveStoreSettings({
    required String name,
    required String category,
    required String description,
    required String contactEmail,
    required String phoneNumber,
    required String shippingPolicy,
    required String returnPolicy,
    required String termsOfService,
  }) {
    if (store.value == null) return;
    
    // Update local model
    store.value = store.value!.copyWith(
      name: name,
      category: category,
      bannerImagePath: bannerImagePath.value,
      clearBanner: bannerImagePath.value == null,
      description: description,
      contactEmail: contactEmail,
      phoneNumber: phoneNumber,
      shippingPolicy: shippingPolicy,
      returnPolicy: returnPolicy,
      termsOfService: termsOfService,
    );
  }

  /// Dynamic action for sharing the store (simulates copying link)
  void shareStore(BuildContext context) {
    if (store.value == null) return;
    
    AppShareService.shareShop(
      shopId: store.value!.id,
      shopName: store.value!.name,
      context: context,
    );
  }

  /// Dynamic action for editing the store details - navigates to settings screen
  void editStore(BuildContext context) {
    if (store.value == null) return;
    context.push(AppRoutes.sellerStoreSettings);
  }

  /// Dynamic action for the settings button on AppBar - navigates to settings screen
  void openSettings(BuildContext context) {
    context.push(AppRoutes.sellerStoreSettings);
  }
}
