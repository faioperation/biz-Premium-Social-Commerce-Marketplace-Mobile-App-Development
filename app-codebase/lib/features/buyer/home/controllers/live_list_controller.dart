import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../models/live_model.dart';

class LiveListController extends GetxController {
  final RxList<LiveStreamModel> liveStreams = <LiveStreamModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load mock data safely after the initial build frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMockData();
    });
  }

  void loadMockData() {
    isLoading.value = true;
    liveStreams.assignAll([
      LiveStreamModel(
        id: '1',
        title: 'Summer Fashion Sale 🔥',
        sellerName: 'FashionHub',
        sellerProfileImage: 'https://i.pravatar.cc/150?u=fashion',
        previewImageUrl:
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&q=80',
        viewerCount: '8.2K',
        productCount: 15,
        isAuction: false,
      ),
      LiveStreamModel(
        id: '2',
        title: 'iPhone 15 Pro Max Auction 📱',
        sellerName: 'TechStore',
        sellerProfileImage: 'https://i.pravatar.cc/150?u=tech',
        previewImageUrl:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80',
        viewerCount: '5.6K',
        productCount: 1,
        isAuction: true,
      ),
      LiveStreamModel(
        id: '3',
        title: 'Minimalist Home Decor Live',
        sellerName: 'HomeDecor',
        sellerProfileImage: 'https://i.pravatar.cc/150?u=home',
        previewImageUrl:
            'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=800&q=80',
        viewerCount: '3.1K',
        productCount: 12,
        isAuction: false,
      ),
    ]);
    isLoading.value = false;
  }
}
