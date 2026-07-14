import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Store/controllers/store_controller.dart';
import '../../Store/models/store_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/live_session_data.dart';

/// GetX Controller that manages the state of the Setup Livestream form.
/// Integrates dynamically with StoreController to retrieve and select
/// from the active seller's store products.
class SetupLivestreamController extends GetxController {
  // Lazy getter: safely resolves StoreController regardless of navigation order.
  // If the user navigates to Setup Livestream before visiting the Store tab,
  // StoreController won't be registered yet — so we create it on demand.
  StoreController get _storeController {
    if (!Get.isRegistered<StoreController>()) {
      Get.put(StoreController());
    }
    return Get.find<StoreController>();
  }

  // Reactive state fields
  final RxList<StoreProductModel> selectedProducts = <StoreProductModel>[].obs;
  late TextEditingController titleController;
  late TextEditingController startingBidController;
  late TextEditingController biddingDurationController;
  
  // Stream options
  final Rx<LiveType> selectedLiveType = LiveType.sell.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
    startingBidController = TextEditingController();
    biddingDurationController = TextEditingController();
  }

  @override
  void onClose() {
    titleController.dispose();
    startingBidController.dispose();
    biddingDurationController.dispose();
    super.onClose();
  }

  /// Get the active seller's store products from the StoreController
  List<StoreProductModel> get storeProducts {
    return _storeController.store.value?.featuredProducts ?? [];
  }

  /// Get active seller's store products filtered by the search query
  List<StoreProductModel> get filteredProducts {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return storeProducts;
    }
    return storeProducts.where((p) => p.title.toLowerCase().contains(query)).toList();
  }

  /// Set the live stream type selection
  void selectLiveType(LiveType type) {
    selectedLiveType.value = type;
  }

  /// Reset all form fields to their default unselected state
  void reset() {
    titleController.clear();
    startingBidController.clear();
    biddingDurationController.clear();
    selectedProducts.clear();
    selectedLiveType.value = LiveType.sell;
    searchQuery.value = '';
  }

  /// Toggle selection state of a product to feature in the stream
  void toggleProductSelection(StoreProductModel product) {
    final existingIndex = selectedProducts.indexWhere((p) => p.id == product.id);
    if (existingIndex != -1) {
      selectedProducts.removeAt(existingIndex);
    } else {
      selectedProducts.add(product);
    }
  }

  /// Launch the livestream mock session (validates inputs and returns data for preview)
  LiveSessionData? validateAndSubmit(BuildContext context) {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a stream title.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return null;
    }

    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one product to feature.'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return null;
    }

    double? startingBid;
    int? biddingDuration;

    if (selectedLiveType.value == LiveType.bidding) {
      final startingBidText = startingBidController.text.trim();
      final biddingDurationText = biddingDurationController.text.trim();

      if (startingBidText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter starting bid amount.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return null;
      }

      if (biddingDurationText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter bidding duration.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return null;
      }

      startingBid = double.tryParse(startingBidText);
      if (startingBid == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid starting bid amount.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return null;
      }

      biddingDuration = int.tryParse(biddingDurationText);
      if (biddingDuration == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid duration in minutes.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return null;
      }
    }

    // Map store products to lightweight LiveStreamProduct models
    final liveProducts = selectedProducts.map((p) => LiveStreamProduct(
      id: p.id,
      title: p.title,
      price: p.price,
      image: p.image,
    )).toList();

    return LiveSessionData(
      title: title,
      coverImagePath: null, // Cover image removed per requirements
      selectedProducts: liveProducts,
      liveType: selectedLiveType.value,
      startingBid: startingBid,
      biddingDuration: biddingDuration,
    );
  }
}
