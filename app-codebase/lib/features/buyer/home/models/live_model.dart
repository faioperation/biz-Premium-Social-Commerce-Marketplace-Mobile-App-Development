class LiveStreamModel {
  final String id;
  final String title;
  final String sellerName;
  final String sellerProfileImage;
  final String previewImageUrl;
  final String viewerCount;
  final int productCount;
  final bool isAuction;

  LiveStreamModel({
    required this.id,
    required this.title,
    required this.sellerName,
    required this.sellerProfileImage,
    required this.previewImageUrl,
    required this.viewerCount,
    required this.productCount,
    this.isAuction = false,
  });
}
