import 'package:get/get.dart';
import '../models/home_models.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    isLoading.value = true;
    notifications.assignAll([
      NotificationModel(
        id: '1',
        title: 'Order Delivered',
        description: 'Your order #ORD-2024-1234 has been delivered',
        timeAgo: '2 hours ago',
        isRead: false,
        type: 'order',
      ),
      NotificationModel(
        id: '2',
        title: 'New Likes',
        description: 'John Smith and 12 others liked your review',
        timeAgo: '5 hours ago',
        isRead: false,
        type: 'like',
      ),
      NotificationModel(
        id: '3',
        title: 'New Message',
        description: 'TechStore replied to your question',
        timeAgo: '1 day ago',
        isRead: true,
        type: 'message',
      ),
      NotificationModel(
        id: '4',
        title: 'New Follower',
        description: 'FashionHub started following you',
        timeAgo: '2 days ago',
        isRead: true,
        type: 'follower',
      ),
      NotificationModel(
        id: '5',
        title: 'Flash Sale Alert',
        description: '50% off on Electronics - Ends in 2 hours!',
        timeAgo: '3 days ago',
        isRead: true,
        type: 'sale',
      ),
    ]);
    isLoading.value = false;
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
  }

  void toggleReadStatus(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(
        isRead: !notifications[index].isRead,
      );
    }
  }
}
