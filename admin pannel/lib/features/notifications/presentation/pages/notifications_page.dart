import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/widgets/table/app_table.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/router/route_names.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/notifications_table_source.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final NotificationsTableSource _source;

  @override
  void initState() {
    super.initState();
    _source = NotificationsTableSource(context);
    final controller = Get.find<NotificationsController>();
    controller.onPageActivated(); // Trigger lifecycle fetch
    ever(controller.notifications, (notifications) {
      _source.setTotalCount(controller.totalCount.value);
      _source.buildDataGridRows(notifications);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Notifications Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              AppButton(
                label: 'Create Notification',
                icon: Icons.add,
                onPressed: () {
                  context.goNamed(RouteNames.notificationForm);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: AppTable(
            title: 'All Notifications',
            source: _source,
            onSearch: (query) {},
            onFilter: () {},
            columns: [
              GridColumn(
                columnName: 'title',
                minimumWidth: 250,
                label: _buildColumnHeader('Title'),
              ),
              GridColumn(
                columnName: 'type',
                minimumWidth: 180,
                label: _buildColumnHeader('Type'),
              ),
              GridColumn(
                columnName: 'audience',
                minimumWidth: 150,
                label: _buildColumnHeader('Audience'),
              ),
              GridColumn(
                columnName: 'scheduled',
                minimumWidth: 200,
                label: _buildColumnHeader('Scheduled For'),
              ),
              GridColumn(
                columnName: 'status',
                minimumWidth: 120,
                label: _buildColumnHeader('Status'),
              ),
              GridColumn(
                columnName: 'actions',
                minimumWidth: 160,
                label: Container(
                  alignment: Alignment.center,
                  child: const Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColumnHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
