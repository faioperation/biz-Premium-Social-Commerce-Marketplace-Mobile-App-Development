import '../../domain/entities/activity_feed_item.dart';

class ActivityFeedModel extends ActivityFeedItem {
  const ActivityFeedModel({
    required super.id,
    required super.title,
    required super.description,
    required super.timestamp,
    required super.type,
  });

  factory ActivityFeedModel.fromJson(Map<String, dynamic> json) {
    return ActivityFeedModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      type: json['type'] ?? 'info',
    );
  }
}
