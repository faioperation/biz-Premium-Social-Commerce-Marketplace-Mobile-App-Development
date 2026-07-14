import 'package:get/get.dart';
import '../models/live_session_data.dart';

/// Controller for the Live Preview screen.
/// Manages the reactive live type selection (Sell or Bidding).
/// Kept minimal and focused — easy to extend for future API integration.
class LivePreviewController extends GetxController {
  /// The session data passed from the Setup screen (title, cover, products).
  late LiveSessionData sessionData;

  /// Reactive live type selection. Defaults to 'sell'.
  final Rx<LiveType> selectedLiveType = LiveType.sell.obs;

  /// Initialize with data passed from Setup screen.
  void init(LiveSessionData data) {
    sessionData = data;
  }

  /// Change the live broadcast type.
  void selectLiveType(LiveType type) {
    selectedLiveType.value = type;
  }

  /// Returns the selected products from the setup session.
  List<LiveStreamProduct> get featuredProducts => sessionData.selectedProducts;

  /// Returns the stream title from the setup session.
  String get streamTitle => sessionData.title;

  /// Returns the cover image path (nullable) from the setup session.
  String? get coverImagePath => sessionData.coverImagePath;
}
