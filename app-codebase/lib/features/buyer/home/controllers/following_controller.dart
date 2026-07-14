import 'package:get/get.dart';
import '../models/following_model.dart';

class FollowingController extends GetxController {
  final RxList<FollowingModel> followingContent = <FollowingModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    isLoading.value = true;
    followingContent.assignAll([
      FollowingModel(
        id: '1',
        title: 'New Smart Watch Collection',
        sellerName: 'TechStore',
        sellerProfileImage: 'https://i.pravatar.cc/150?u=tech',
        previewImageUrl:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80',
        timestamp: '2 hours ago',
        views: '12.5K',
        type: FollowingContentType.video,
      ),
      FollowingModel(
        id: '2',
        title: 'Summer Fashion Live Sale 🔥',
        sellerName: 'FashionHub',
        sellerProfileImage: 'https://i.pravatar.cc/150?u=fashion',
        previewImageUrl:
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&q=80',
        timestamp: 'Live now',
        views: '8.2K',
        type: FollowingContentType.live,
      ),
      FollowingModel(
        id: '3',
        title: 'Minimalist Home Decor Tour',
        sellerName: 'HomeDecor',
        sellerProfileImage: 'https://i.pravatar.cc/150?u=home',
        previewImageUrl:
            'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=800&q=80',
        timestamp: '5 hours ago',
        views: '4.1K',
        type: FollowingContentType.video,
      ),
    ]);
    isLoading.value = false;
  }
}
