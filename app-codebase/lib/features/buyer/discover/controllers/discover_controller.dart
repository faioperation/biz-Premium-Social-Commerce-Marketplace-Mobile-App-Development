import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';
import '../models/discover_product_model.dart';

class DiscoverController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  final recentSearches = <String>[
    'wireless headphones',
    'smart watch',
    'summer dress',
  ].obs;

  final trendingSearches = <String>[
    'iPhone 15 Pro',
    'Nike Air Max',
    'Vintage watches',
    'Mechanical keyboard',
    'Yoga mat',
  ];

  final categories = <CategoryModel>[
    CategoryModel(
      id: 'electronics',
      name: 'Electronics',
      iconEmoji: '📱',
      backgroundColor: const Color(0xFFEFF6FF),
      textColor: const Color(0xFF2563EB),
    ),
    CategoryModel(
      id: 'fashion',
      name: 'Fashion',
      iconEmoji: '👕',
      backgroundColor: const Color(0xFFFDF2F8),
      textColor: const Color(0xFFDB2777),
    ),
    CategoryModel(
      id: 'home',
      name: 'Home',
      iconEmoji: '🏠',
      backgroundColor: const Color(0xFFECFDF5),
      textColor: const Color(0xFF059669),
    ),
    CategoryModel(
      id: 'beauty',
      name: 'Beauty',
      iconEmoji: '💄',
      backgroundColor: const Color(0xFFF5F3FF),
      textColor: const Color(0xFF7C3AED),
    ),
    CategoryModel(
      id: 'sports',
      name: 'Sports',
      iconEmoji: '⚽',
      backgroundColor: const Color(0xFFFFF7ED),
      textColor: const Color(0xFFEA580C),
    ),
    CategoryModel(
      id: 'books',
      name: 'Books',
      iconEmoji: '📚',
      backgroundColor: const Color(0xFFFEFCE8),
      textColor: const Color(0xFFCA8A04),
    ),
  ];

  final products = <DiscoverProductModel>[
    DiscoverProductModel(
      id: 'prod1',
      name: 'Smart Watch Ultra',
      price: 299.0,
      originalPrice: 399.0,
      availableQuantity: 14,
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=600',
      categoryId: 'electronics',
      rating: 4.8,
      reviewCount: 1234,
      soldCount: 2300,
      sellerName: 'TechStore',
      sellerProfileImage:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200',
      sellerRating: 4.9,
      description:
          'Experience pure acoustic bliss with our Smart Watch Ultra headphones. Features Hybrid Active Noise Cancellation, high-fidelity wireless audio playback, ultra-premium memory foam ear cups, and up to 40 hours of uninterrupted listening pleasure.',
      subcategory: 'Headphones',
    ),
    DiscoverProductModel(
      id: 'prod2',
      name: 'iPhone 15 Pro Max',
      price: 999.0,
      originalPrice: 1199.0,
      availableQuantity: 8,
      imageUrl:
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=600',
      categoryId: 'electronics',
      rating: 4.9,
      reviewCount: 923,
      soldCount: 1500,
      sellerName: 'TechStore',
      sellerProfileImage:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200',
      sellerRating: 4.9,
      description:
          'The ultimate iPhone featuring a titanium design, advanced camera system, and the powerful A17 Pro chip.',
      subcategory: 'Smartphones',
    ),
    DiscoverProductModel(
      id: 'prod3',
      name: 'Premium Office Laptop',
      price: 1099.0,
      originalPrice: 1299.0,
      availableQuantity: 5,
      imageUrl:
          'https://images.unsplash.com/photo-1603302576837-37561b2e2302?q=80&w=600',
      categoryId: 'electronics',
      rating: 4.7,
      reviewCount: 546,
      soldCount: 890,
      sellerName: 'TechStore',
      sellerProfileImage:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200',
      sellerRating: 4.9,
      description:
          'Unleash your creativity with this high-performance computing beast, built for multitasking and long battery life.',
      subcategory: 'Laptops',
    ),
    DiscoverProductModel(
      id: 'prod4',
      name: 'Polaroid OneStep 2 Camera',
      price: 129.0,
      originalPrice: 159.0,
      availableQuantity: 18,
      imageUrl:
          'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?q=80&w=600',
      categoryId: 'electronics',
      rating: 4.6,
      reviewCount: 345,
      soldCount: 620,
      sellerName: 'TechStore',
      sellerProfileImage:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200',
      sellerRating: 4.9,
      description:
          'Capture moments instantly with this vintage-inspired analog instant camera, perfect for daily photography.',
      subcategory: 'Cameras',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  List<DiscoverProductModel> getProductsByCategory(String categoryId) {
    return products.where((p) => p.categoryId == categoryId).toList();
  }

  int getProductCountBySubcategory(String subcategoryName) {
    return products.where((p) => p.subcategory == subcategoryName).length;
  }

  void performSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    if (!recentSearches.contains(trimmed)) {
      recentSearches.insert(0, trimmed);
      if (recentSearches.length > 5) {
        recentSearches.removeLast();
      }
    }
    searchQuery.value = trimmed;
  }

  void removeRecentSearch(String search) {
    recentSearches.remove(search);
  }

  void addToCart(DiscoverProductModel product) {
    Get.snackbar(
      'Added to Cart',
      '${product.name} successfully added to your shopping cart!',
      backgroundColor: Colors.green.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void buyNow(DiscoverProductModel product) {
    Get.snackbar(
      'Initiating Checkout',
      'Starting express checkout for ${product.name}...',
      backgroundColor: const Color(0xFF6C4DFF),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
