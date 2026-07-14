class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String type; // 'Push Notification', 'In-App Notification', 'System Notification'
  final String audience; // 'All Users', 'All Sellers', 'Selected Users'
  final List<String> targetUserIds; // If audience is 'Selected Users'
  final DateTime scheduledFor;
  final bool isSent;
  final int sentCount; // Number of users successfully notified
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.audience,
    required this.targetUserIds,
    required this.scheduledFor,
    required this.isSent,
    required this.sentCount,
    required this.createdAt,
  });

  NotificationEntity copyWith({
    String? title,
    String? message,
    String? type,
    String? audience,
    List<String>? targetUserIds,
    DateTime? scheduledFor,
    bool? isSent,
    int? sentCount,
  }) {
    return NotificationEntity(
      id: id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      audience: audience ?? this.audience,
      targetUserIds: targetUserIds ?? this.targetUserIds,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      isSent: isSent ?? this.isSent,
      sentCount: sentCount ?? this.sentCount,
      createdAt: createdAt,
    );
  }
}
