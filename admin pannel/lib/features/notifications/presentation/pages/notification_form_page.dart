import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_loader.dart';
import '../controllers/notification_form_controller.dart';
import '../controllers/notifications_controller.dart';

class NotificationFormPage extends StatefulWidget {
  final String? notificationId;
  const NotificationFormPage({super.key, this.notificationId});

  @override
  State<NotificationFormPage> createState() => _NotificationFormPageState();
}

class _NotificationFormPageState extends State<NotificationFormPage> {
  late final NotificationFormController controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = Get.find<NotificationFormController>();
    if (widget.notificationId != null) {
      controller.loadNotification(widget.notificationId!);
    } else {
      // Reset for new creation
      controller.titleController.clear();
      controller.messageController.clear();
      controller.type.value = 'Push Notification';
      controller.audience.value = 'All Users';
      controller.isImmediate.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.notificationId != null;

    return Obx(() {
      if (controller.isLoading.value && isEditing && controller.titleController.text.isEmpty) {
        return const Center(child: AppLoader());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(isEditing ? 'Edit Notification' : 'Create Notification', style: AppTextStyles.h2),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: AppCard(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Notification Details', style: AppTextStyles.h3),
                        const SizedBox(height: AppSpacing.lg),

                        // Title
                        TextFormField(
                          controller: controller.titleController,
                          decoration: const InputDecoration(
                            labelText: 'Notification Title',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Message
                        TextFormField(
                          controller: controller.messageController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Notification Message',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Message is required' : null,
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        Row(
                          children: [
                            // Type
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Notification Type', style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                                  const SizedBox(height: AppSpacing.sm),
                                  DropdownButtonFormField<String>(
                                    value: controller.type.value,
                                    decoration: const InputDecoration(border: OutlineInputBorder()),
                                    items: const [
                                      DropdownMenuItem(value: 'Push Notification', child: Text('Push Notification')),
                                      DropdownMenuItem(value: 'In-App Notification', child: Text('In-App Notification')),
                                      DropdownMenuItem(value: 'System Notification', child: Text('System Notification')),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) controller.type.value = value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),

                            // Audience
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Target Audience', style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                                  const SizedBox(height: AppSpacing.sm),
                                  DropdownButtonFormField<String>(
                                    value: controller.audience.value,
                                    decoration: const InputDecoration(border: OutlineInputBorder()),
                                    items: const [
                                      DropdownMenuItem(value: 'All Users', child: Text('All Users')),
                                      DropdownMenuItem(value: 'All Sellers', child: Text('All Sellers')),
                                      DropdownMenuItem(value: 'Selected Users', child: Text('Selected Users (Requires CSV)')),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) controller.audience.value = value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        Text('Scheduling', style: AppTextStyles.h4),
                        const SizedBox(height: AppSpacing.sm),
                        
                        Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: controller.isImmediate.value,
                              onChanged: (value) => controller.isImmediate.value = value!,
                              activeColor: AppColors.primary,
                            ),
                            const Text('Send Immediately'),
                            const SizedBox(width: AppSpacing.xl),
                            Radio<bool>(
                              value: false,
                              groupValue: controller.isImmediate.value,
                              onChanged: (value) => controller.isImmediate.value = value!,
                              activeColor: AppColors.primary,
                            ),
                            const Text('Schedule for Later'),
                          ],
                        ),
                        
                        if (!controller.isImmediate.value) ...[
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: controller.scheduledFor.value,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                    );
                                    if (date != null) {
                                      if (!context.mounted) return;
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(controller.scheduledFor.value),
                                      );
                                      if (time != null) {
                                        controller.scheduledFor.value = DateTime(
                                          date.year, date.month, date.day, time.hour, time.minute,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(DateFormat('MMM d, yyyy - h:mm a').format(controller.scheduledFor.value)),
                                        Icon(Icons.calendar_today, size: 20, color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        
                        const SizedBox(height: AppSpacing.xxl),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppButton(
                              label: 'Cancel',
                              type: AppButtonType.outline,
                              onPressed: () => context.pop(),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            AppButton(
                              label: isEditing ? 'Update Notification' : 'Create Notification',
                              isLoading: controller.isLoading.value,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final success = await controller.saveNotification();
                                  if (success) {
                                    Get.find<NotificationsController>().onPageActivated(forceRefresh: true);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Notification saved successfully'), backgroundColor: Colors.green),
                                      );
                                      context.pop();
                                    }
                                  } else {
                                    if (context.mounted && controller.error.value.isNotEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(controller.error.value), backgroundColor: Colors.red),
                                      );
                                    }
                                  }
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
