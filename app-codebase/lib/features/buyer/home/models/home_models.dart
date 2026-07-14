import 'package:get/get.dart';

enum StoryMediaType { image, video }

class StoryMediaModel {
  final String id;
  final String mediaUrl;
  final StoryMediaType type;
  final int duration; // in seconds
  final String? caption;
  final DateTime? timestamp;
  final List<Map<String, String>> viewers; // Mock viewers

  StoryMediaModel({
    required this.id,
    required this.mediaUrl,
    required this.type,
    this.duration = 5,
    this.caption,
    this.timestamp,
    this.viewers = const [],
  });
}

class StoryModel {
  final String id;
  final String sellerName;
  final String profileImage;
  final bool isLive;
  final List<StoryMediaModel> slides;
  final RxBool? _isSeen;
  final int viewsCount;
  final List<Map<String, String>> viewsList;

  RxBool get isSeen => _isSeen ?? false.obs;

  StoryModel({
    required this.id,
    required this.sellerName,
    required this.profileImage,
    this.isLive = false,
    required this.slides,
    bool isSeen = false,
    this.viewsCount = 0,
    this.viewsList = const [],
  }) : _isSeen = RxBool(isSeen);
}

enum FeedType { post, live }

class FeedItemModel {
  final String id;
  final String sellerName;
  final String title;
  final double price;
  final String imageUrl;
  final FeedType type;
  final int likes;
  final int comments;
  final bool isLiked;

  FeedItemModel({
    required this.id,
    required this.sellerName,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.type,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });
}

class CommentModel {
  final String id;
  final String userName;
  final String userProfileUrl;
  final String commentText;
  final DateTime timestamp;

  CommentModel({
    required this.id,
    required this.userName,
    required this.userProfileUrl,
    required this.commentText,
    required this.timestamp,
  });
}

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String timeAgo;
  final bool isRead;
  final String type; // 'order', 'like', 'message', 'follower', 'sale'

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timeAgo,
    this.isRead = false,
    required this.type,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    String? timeAgo,
    bool? isRead,
    String? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timeAgo: timeAgo ?? this.timeAgo,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}
