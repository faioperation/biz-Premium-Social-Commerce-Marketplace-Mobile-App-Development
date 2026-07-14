enum FollowingContentType { video, live }

class FollowingModel {
  final String id;
  final String title;
  final String sellerName;
  final String sellerProfileImage;
  final String previewImageUrl;
  final String timestamp;
  final String views;
  final FollowingContentType type;

  FollowingModel({
    required this.id,
    required this.title,
    required this.sellerName,
    required this.sellerProfileImage,
    required this.previewImageUrl,
    required this.timestamp,
    required this.views,
    required this.type,
  });
}
