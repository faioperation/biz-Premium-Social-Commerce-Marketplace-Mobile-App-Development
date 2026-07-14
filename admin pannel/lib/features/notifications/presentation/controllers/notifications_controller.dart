import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

import '../../../../core/mixins/page_lifecycle_mixin.dart';

class NotificationsController extends GetxController with PageLifecycleMixin {
  final NotificationRepository _repository;

  NotificationsController(this._repository);

  final RxList<NotificationEntity> notifications = <NotificationEntity>[].obs;

  int _currentPage = 1;
  final int _limit = 15;
  final RxInt totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Replaced by onPageActivated in the UI
  }

  Future<void> _loadTotalCount() async {
    totalCount.value = await _repository.getTotalCount();
  }

  @override
  Future<void> fetchData({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      notifications.clear();
      await _loadTotalCount();
    }

    final newNotifications = await _repository.getNotifications(
      page: _currentPage,
      limit: _limit,
    );

    if (isRefresh) {
      notifications.value = newNotifications;
    } else {
      notifications.addAll(newNotifications);
    }

    _currentPage++;
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _repository.deleteNotification(id);
      notifications.removeWhere((n) => n.id == id);
      totalCount.value--;
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> sendNotificationNow(String id) async {
    try {
      await _repository.sendNotification(id);
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isSent: true);
      }
    } catch (e) {
      error.value = e.toString();
    }
  }
}
