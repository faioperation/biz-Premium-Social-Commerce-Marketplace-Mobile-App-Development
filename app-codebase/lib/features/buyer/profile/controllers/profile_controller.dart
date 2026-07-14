import 'package:get/get.dart';
import '../models/profile_user_model.dart';

class ProfileController extends GetxController {
  final user = Rxn<ProfileUserModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));

    user.value = ProfileUserModel(
      id: 'usr_001',
      name: 'John Smith',
      email: 'john.smith@email.com',
      avatarUrl: 'https://i.pravatar.cc/300',
      bannerUrl: 'https://images.unsplash.com/photo-1557682250-33bd709cbe85',
      bio: '🛍️ Shopping enthusiast | Tech lover\n✨ Discovering the best deals',
      followersCount: 12500,
      followingCount: 342,
      profileViews: 8900,
      ordersCount: 45,
      wishlistCount: 12,
      loyaltyPoints: 2400,
    );

    isLoading.value = false;
  }
}
