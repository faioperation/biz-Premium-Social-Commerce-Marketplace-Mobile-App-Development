import 'package:get/get.dart';
import '../models/past_live_stream_model.dart';

/// A controller managing the list of a seller's recorded past livestreams.
class SellerLiveListController extends GetxController {
  final RxList<PastLiveStreamModel> pastLives = <PastLiveStreamModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPastLives();
  }

  /// Simulates fetching past streams from a remote server with a loading delay.
  Future<void> fetchPastLives() async {
    isLoading.value = true;
    try {
      // Simulate network request delay
      await Future.delayed(const Duration(milliseconds: 800));
      pastLives.assignAll(PastLiveStreamModel.getMockPastLives());
    } finally {
      isLoading.value = false;
    }
  }

  /// Filters the past livestreams based on the search query.
  List<PastLiveStreamModel> get filteredLives {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return pastLives;
    return pastLives.where((stream) {
      return stream.title.toLowerCase().contains(query) ||
          stream.liveType.label.toLowerCase().contains(query);
    }).toList();
  }

  /// Metric aggregations
  int get totalStreams => pastLives.length;

  int get totalReach {
    return pastLives.fold(0, (sum, stream) => sum + stream.totalViewers);
  }

  int get totalLikes {
    return pastLives.fold(0, (sum, stream) => sum + stream.totalLikes);
  }

  double get totalRevenue {
    return pastLives.fold(0.0, (sum, stream) => sum + stream.estimatedRevenue);
  }

  /// Deletes a past livestream.
  void deletePastLive(String id) {
    pastLives.removeWhere((stream) => stream.id == id);
  }
}
