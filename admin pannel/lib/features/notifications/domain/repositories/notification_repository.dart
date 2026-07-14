import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications({
    int page = 1,
    int limit = 15,
  });
  
  Future<int> getTotalCount();
  
  Future<NotificationEntity> getNotificationDetails(String id);

  Future<void> createNotification(NotificationEntity notification);
  
  Future<void> updateNotification(NotificationEntity notification);
  
  Future<void> deleteNotification(String id);
  
  // Triggers immediate send if scheduled for now, or just updates status
  Future<void> sendNotification(String id);
}
