import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/table/app_table_source.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../domain/entities/notification_entity.dart';
import '../../../../core/router/route_names.dart';
import '../controllers/notifications_controller.dart';
import 'package:get/get.dart';

class NotificationsTableSource extends AppTableSource<NotificationEntity> {
  final BuildContext context;

  NotificationsTableSource(this.context);

  @override
  DataGridRow buildDataGridRow(NotificationEntity item) {
    return DataGridRow(cells: [
      DataGridCell<String>(columnName: 'title', value: item.title),
      DataGridCell<String>(columnName: 'type', value: item.type),
      DataGridCell<String>(columnName: 'audience', value: item.audience),
      DataGridCell<DateTime>(columnName: 'scheduled', value: item.scheduledFor),
      DataGridCell<String>(columnName: 'status', value: item.isSent ? 'Sent' : 'Pending'),
      DataGridCell<NotificationEntity>(columnName: 'actions', value: item),
    ]);
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'scheduled') {
          final date = cell.value as DateTime;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              DateFormat('MMM d, y - h:mm a').format(date),
              style: AppTextStyles.body,
            ),
          );
        } else if (cell.columnName == 'status') {
          final status = cell.value as String;
          final type = status == 'Sent' ? AppStatusType.success : AppStatusType.warning;

          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppStatusChip(label: status.toUpperCase(), type: type),
          );
        } else if (cell.columnName == 'actions') {
          final notification = cell.value as NotificationEntity;
          return Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!notification.isSent) ...[
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.success, size: 20),
                    tooltip: 'Send Now',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AppConfirmationDialog(
                          title: 'Send Notification',
                          content: 'Are you sure you want to send this notification now?',
                          confirmText: 'Send',
                          cancelText: 'Cancel',
                          onConfirm: () {
                            Get.find<NotificationsController>().sendNotificationNow(notification.id);
                          },
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primary, size: 20),
                    tooltip: 'Edit',
                    onPressed: () {
                      context.goNamed(RouteNames.notificationForm, queryParameters: {'id': notification.id});
                    },
                  ),
                ],
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.error, size: 20),
                  tooltip: 'Delete',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AppConfirmationDialog(
                        title: 'Delete Notification',
                        content: 'Are you sure you want to delete this notification?',
                        confirmText: 'Delete',
                        cancelText: 'Cancel',
                        onConfirm: () {
                          Get.find<NotificationsController>().deleteNotification(notification.id);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(cell.value.toString(), style: AppTextStyles.body, maxLines: 1, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }
}
