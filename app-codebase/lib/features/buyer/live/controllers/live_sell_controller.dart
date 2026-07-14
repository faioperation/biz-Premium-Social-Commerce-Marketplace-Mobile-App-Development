import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/live_activity_model.dart';
import '../models/live_product_model.dart';

class LiveSellController extends GetxController {
  final commentController = TextEditingController();
  final scrollController = ScrollController();

  final liveProducts = <LiveProductModel>[].obs;
  final pinnedProduct = Rxn<LiveProductModel>();

  @override
  void onInit() {
    super.onInit();
    fetchLiveProducts();
  }

  void fetchLiveProducts() {
    // API Swappable Endpoint: Fetch queued products for this livestream session.
    final list = [
      LiveProductModel(
        id: 'live_prod_3',
        number: 3,
        title: '"Melody" Jersey Set Baby Pink with "Los Angel...',
        price: 50.0,
        imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=500&auto=format&fit=crop&q=60',
        isCurrentlyFeatured: true,
        isUpcoming: false,
        rating: 4.8,
        salesCount: 142,
        flashSaleText: 'LIVE flash sale (£19.99 or less) will start in 00:21',
        description: 'Ultra-soft cotton jersey set in vibrant baby pink. Features the signature "Los Angeles" graphic detailing on front, cropped fit top, and matching high-waisted shorts with drawstring.',
      ),
      LiveProductModel(
        id: 'live_prod_14',
        number: 14,
        title: 'ELLA Striped Maxi Dress with Belt - Eleg...',
        price: 45.0,
        imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500&auto=format&fit=crop&q=60',
        isCurrentlyFeatured: false,
        isUpcoming: true,
        rating: 5.0,
        salesCount: 51,
        flashSaleText: 'LIVE flash sale starts in 00:00:44',
        description: 'Vibrant striped pattern maxi dress featuring matching cloth belt, deep V-neck style, and breathable linen blend material. Ideal for summer evenings.',
      ),
      LiveProductModel(
        id: 'live_prod_15',
        number: 15,
        title: 'QUEENIE Extreme Faux Fur Slippers Foot...',
        price: 11.99,
        imageUrl: 'https://images.unsplash.com/photo-1535043934128-cf0b28d52f95?w=500&auto=format&fit=crop&q=60',
        isCurrentlyFeatured: false,
        isUpcoming: true,
        rating: 4.9,
        salesCount: 28900,
        viewsText: '15.9K users viewed',
        description: 'Ultra-plush faux fur slippers with supportive memory foam sole. Designed for absolute comfort with stylish crossover strap design.',
      ),
      LiveProductModel(
        id: 'live_prod_16',
        number: 16,
        title: 'Dotty Dot Dress - Stylish Polka Dot Design in Multipl...',
        price: 45.99,
        imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=500&auto=format&fit=crop&q=60',
        isCurrentlyFeatured: false,
        isUpcoming: true,
        rating: 4.7,
        salesCount: 14,
        flashSaleText: 'LIVE flash sale starts in 00:00:44',
        description: 'A classic polka dot dress with contrast borders. Form-fitting bodycon design that adds flair and elegance. Made with stretchable premium cotton.',
      ),
      LiveProductModel(
        id: 'live_prod_17',
        number: 17,
        title: 'Paula Polka Dot maxi Dress in Multiple C...',
        price: 50.0,
        imageUrl: 'https://images.unsplash.com/photo-1612336307429-8a898d10e223?w=500&auto=format&fit=crop&q=60',
        isCurrentlyFeatured: false,
        isUpcoming: true,
        rating: 5.0,
        salesCount: 12,
        description: 'Flowy polka dot maxi dress with ruffled tiers. Fits beautifully on any body type. Comes with adjustable straps and smocked back.',
      ),
      LiveProductModel(
        id: 'live_prod_18',
        number: 18,
        title: '\'SKYE\' floral print dress Womenswear',
        price: 50.0,
        imageUrl: 'https://images.unsplash.com/photo-1596783074918-c84cb06531ca?w=500&auto=format&fit=crop&q=60',
        isCurrentlyFeatured: false,
        isUpcoming: true,
        rating: 4.6,
        salesCount: 8,
        description: 'Delicate floral pattern prints with flutter sleeves and dynamic side slit details. Crafted in lightweight chiffon for a breezy vibe.',
      ),
    ];
    liveProducts.assignAll(list);
    
    // Automatically pin the first product (#3 Jersey Set) to display on the live feed!
    pinnedProduct.value = list.first;
  }

  final comments = <LiveActivityModel>[
    LiveActivityModel(
      username: 'John Smith',
      text: 'This looks amazing! 😍',
      isBid: false,
    ),
    LiveActivityModel(
      username: 'Cazza',
      text: '5 😍',
      isBid: false,
    ),
    LiveActivityModel(
      username: 'x_chl0e_x2',
      text: 'joined',
      isBid: false,
    ),
  ].obs;

  final isLiked = false.obs;
  final isFollowing = false.obs;

  void toggleFollow() {
    isFollowing.toggle();
    Get.snackbar(
      isFollowing.value ? 'Following' : 'Unfollowed',
      isFollowing.value
          ? 'You are now following this seller!'
          : 'You unfollowed this seller.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isFollowing.value
          ? Colors.green.withValues(alpha: 0.9)
          : Colors.black87.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void onClose() {
    commentController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void addComment() {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    comments.add(LiveActivityModel(username: 'You', text: text, isBid: false));
    commentController.clear();
    _scrollToBottom();
  }

  void addSystemComment(String text) {
    comments.add(LiveActivityModel(username: 'You', text: text, isBid: false));
    _scrollToBottom();
  }

  void sendRose() {
    addSystemComment('Sent a Rose 🌹');
    Get.snackbar(
      'Gift Sent!',
      'You sent a Rose 🌹 to the host!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.pinkAccent.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
    );
  }

  void sendGift() {
    addSystemComment('Sent a Gift Box 🎁');
    Get.snackbar(
      'Gift Sent!',
      'You sent a Gift Box 🎁 to the host!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.purpleAccent.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
    );
  }

  void sendEmoji(String emoji) {
    addSystemComment(emoji);
  }

  void pinProduct(LiveProductModel? product) {
    pinnedProduct.value = product;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void toggleLike() {
    isLiked.toggle();
    Get.snackbar(
      isLiked.value ? 'Loved!' : 'Unloved',
      isLiked.value ? 'You liked the live stream!' : 'You removed your like.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isLiked.value
          ? Colors.pink.withValues(alpha: 0.8)
          : Colors.black87.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  void joinSellerGroup(BuildContext context, String sellerName) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.group_add_rounded,
                  color: Colors.orange,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "$sellerName's VIP Club",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Join this seller's private group to participate in group discussions, get exclusive coupons, and access flash sales!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.link_rounded, color: Colors.blueAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "https://fashiohub.com/groups/${sellerName.toLowerCase().replaceAll(' ', '_')}_vip",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.snackbar(
                          "Joined Group",
                          "You have successfully joined $sellerName's private group!",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Join Now"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
