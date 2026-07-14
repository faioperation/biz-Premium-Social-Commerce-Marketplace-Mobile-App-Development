import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationFormController extends GetxController {
  final NotificationRepository _repository;

  NotificationFormController(this._repository);

  final titleController = TextEditingController();
  final messageController = TextEditingController();

  final RxString type = 'Push Notification'.obs;
  final RxString audience = 'All Users'.obs;
  final Rx<DateTime> scheduledFor = DateTime.now().obs;
  final RxBool isImmediate = true.obs;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  String? _editingId;

  void loadNotification(String id) async {
    try {
      isLoading.value = true;
      final notification = await _repository.getNotificationDetails(id);
      
      _editingId = notification.id;
      titleController.text = notification.title;
      messageController.text = notification.message;
      type.value = notification.type;
      audience.value = notification.audience;
      
      // If it's scheduled for future, it's not immediate
      if (notification.scheduledFor.isAfter(DateTime.now().add(const Duration(minutes: 5)))) {
        isImmediate.value = false;
        scheduledFor.value = notification.scheduledFor;
      } else {
        isImmediate.value = true;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveNotification() async {
    if (titleController.text.isEmpty || messageController.text.isEmpty) {
      error.value = 'Title and message are required.';
      return false;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final targetDate = isImmediate.value ? DateTime.now() : scheduledFor.value;

      final notification = NotificationEntity(
        id: _editingId ?? '',
        title: titleController.text,
        message: messageController.text,
        type: type.value,
        audience: audience.value,
        targetUserIds: [], // Empty for now, would handle specific users in a real app
        scheduledFor: targetDate,
        isSent: false, // Will be sent by backend cron if immediate
        sentCount: 0,
        createdAt: DateTime.now(),
      );

      if (_editingId == null) {
        await _repository.createNotification(notification);
      } else {
        await _repository.updateNotification(notification);
      }
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
