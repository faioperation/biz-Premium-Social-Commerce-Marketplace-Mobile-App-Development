import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.type,
    required super.audience,
    required super.targetUserIds,
    required super.scheduledFor,
    required super.isSent,
    required super.sentCount,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'Push Notification',
      audience: json['audience'] ?? 'All Users',
      targetUserIds: List<String>.from(json['targetUserIds'] ?? []),
      scheduledFor: DateTime.tryParse(json['scheduledFor'] ?? '') ?? DateTime.now(),
      isSent: json['isSent'] ?? false,
      sentCount: json['sentCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'audience': audience,
      'targetUserIds': targetUserIds,
      'scheduledFor': scheduledFor.toIso8601String(),
      'isSent': isSent,
      'sentCount': sentCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
