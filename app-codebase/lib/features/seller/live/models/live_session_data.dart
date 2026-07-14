/// Data model passed from SetupLivestreamScreen → LivePreviewScreen.
/// Contains everything needed to preview and launch the live stream.
class LiveSessionData {
  final String title;
  final String? coverImagePath; // null if no cover was uploaded
  final List<LiveStreamProduct> selectedProducts;
  final LiveType liveType;
  final double? startingBid;
  final int? biddingDuration; // in minutes

  const LiveSessionData({
    required this.title,
    this.coverImagePath,
    required this.selectedProducts,
    required this.liveType,
    this.startingBid,
    this.biddingDuration,
  });
}

/// Lightweight product model used specifically in the live session flow.
/// Decoupled from StoreProductModel so future API mapping is clean.
class LiveStreamProduct {
  final String id;
  final String title;
  final double price;
  final String image; // Emoji or asset path

  const LiveStreamProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });
}

/// The type of live broadcast the seller wants to run.
enum LiveType {
  sell,
  bidding;

  String get label {
    switch (this) {
      case LiveType.sell:
        return 'Sell';
      case LiveType.bidding:
        return 'Bidding';
    }
  }

  String get description {
    switch (this) {
      case LiveType.sell:
        return 'Show products at a fixed price. Viewers can purchase instantly.';
      case LiveType.bidding:
        return 'Run a live auction. Viewers place bids on your featured products.';
    }
  }

  String get icon {
    switch (this) {
      case LiveType.sell:
        return '🛒';
      case LiveType.bidding:
        return '🔨';
    }
  }
}
