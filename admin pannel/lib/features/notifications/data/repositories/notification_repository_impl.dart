import '../../../../core/network/network_service.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  // ignore: unused_field
  final NetworkService _networkService;

  NotificationRepositoryImpl(this._networkService);

  static const _types = ['Push Notification', 'In-App Notification', 'System Notification'];
  static const _audiences = ['All Users', 'All Sellers', 'Selected Users'];

  static final List<NotificationModel> _mockNotifications = List.generate(45, (index) {
    final isSent = index > 10;
    return NotificationModel(
      id: 'notif_${index + 1}',
      title: 'Notification Title ${index + 1}',
      message: 'This is the detailed message for notification ${index + 1}. It contains important updates for the target audience.',
      type: _types[index % 3],
      audience: _audiences[index % 3],
      targetUserIds: _audiences[index % 3] == 'Selected Users' ? ['user_1', 'user_2'] : [],
      scheduledFor: isSent 
          ? DateTime.now().subtract(Duration(days: index)) 
          : DateTime.now().add(Duration(days: 10 - index)),
      isSent: isSent,
      sentCount: isSent ? (index * 150) + 23 : 0,
      createdAt: DateTime.now().subtract(Duration(days: index + 2)),
    );
  });

  @override
  Future<List<NotificationEntity>> getNotifications({
    int page = 1,
    int limit = 15,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Sort by scheduled date descending
    final sorted = List<NotificationModel>.from(_mockNotifications)
      ..sort((a, b) => b.scheduledFor.compareTo(a.scheduledFor));

    final start = (page - 1) * limit;
    if (start >= sorted.length) return [];
    final end = (start + limit).clamp(0, sorted.length);
    return sorted.sublist(start, end);
  }

  @override
  Future<int> getTotalCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockNotifications.length;
  }

  @override
  Future<NotificationEntity> getNotificationDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockNotifications.firstWhere((n) => n.id == id, orElse: () => throw Exception('Notification not found'));
  }

  @override
  Future<void> createNotification(NotificationEntity notification) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final newNotification = NotificationModel(
      id: 'notif_\${DateTime.now().millisecondsSinceEpoch}',
      title: notification.title,
      message: notification.message,
      type: notification.type,
      audience: notification.audience,
      targetUserIds: notification.targetUserIds,
      scheduledFor: notification.scheduledFor,
      isSent: notification.isSent,
      sentCount: 0,
      createdAt: DateTime.now(),
    );
    _mockNotifications.insert(0, newNotification);
  }

  @override
  Future<void> updateNotification(NotificationEntity notification) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _mockNotifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      _mockNotifications[index] = NotificationModel(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        type: notification.type,
        audience: notification.audience,
        targetUserIds: notification.targetUserIds,
        scheduledFor: notification.scheduledFor,
        isSent: notification.isSent,
        sentCount: notification.sentCount,
        createdAt: notification.createdAt,
      );
    } else {
      throw Exception('Notification not found');
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _mockNotifications.removeWhere((n) => n.id == id);
  }

  @override
  Future<void> sendNotification(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _mockNotifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final current = _mockNotifications[index];
      _mockNotifications[index] = NotificationModel(
        id: current.id,
        title: current.title,
        message: current.message,
        type: current.type,
        audience: current.audience,
        targetUserIds: current.targetUserIds,
        scheduledFor: current.scheduledFor,
        isSent: true,
        sentCount: 1542, // Mock random sent count
        createdAt: current.createdAt,
      );
    }
  }
}
