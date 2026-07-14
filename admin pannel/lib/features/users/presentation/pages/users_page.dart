import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/widgets/table/app_table.dart';
import '../../../../core/widgets/table/table_action_models.dart';

import '../controllers/users_controller.dart';
import '../widgets/users_table_source.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late final UsersTableSource _source;
  
  @override
  void initState() {
    super.initState();
    _source = UsersTableSource(context);
    // Bind source updates to controller changes
    final controller = Get.find<UsersController>();
    controller.onPageActivated(); // Trigger lifecycle fetch
    
    ever(controller.users, (users) {
      _source.setTotalCount(controller.totalCount);
      _source.buildDataGridRows(users);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UsersController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppTable(
            title: 'Users Management',
            source: _source,
            onSearch: controller.onSearch,
            onFilter: () {
              // TODO: Implement advanced filters dialog
            },
            bulkActions: [
              TableBulkAction(
                label: 'Suspend Selected',
                icon: Icons.pause_circle_outline,
                onAction: (items) {
                  // TODO: Implement bulk suspend
                },
                isDestructive: true,
              ),
            ],
            columns: [
              GridColumn(
                columnName: 'id',
                minimumWidth: 100,
                label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              GridColumn(
                columnName: 'user',
                minimumWidth: 250,
                label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text('User', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              GridColumn(
                columnName: 'phone',
                minimumWidth: 150,
                label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text('Phone', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              GridColumn(
                columnName: 'wallet',
                minimumWidth: 120,
                label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text('Wallet', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              GridColumn(
                columnName: 'status',
                minimumWidth: 130,
                label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              GridColumn(
                columnName: 'joinedAt',
                minimumWidth: 130,
                label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text('Joined', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              GridColumn(
                columnName: 'actions',
                minimumWidth: 80,
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
}
