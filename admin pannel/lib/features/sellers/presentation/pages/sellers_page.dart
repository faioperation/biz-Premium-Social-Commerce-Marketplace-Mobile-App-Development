import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/widgets/table/app_table.dart';
import '../../../../core/widgets/table/table_action_models.dart';
import '../controllers/sellers_controller.dart';
import '../widgets/sellers_table_source.dart';

class SellersPage extends StatefulWidget {
  const SellersPage({super.key});

  @override
  State<SellersPage> createState() => _SellersPageState();
}

class _SellersPageState extends State<SellersPage> {
  late final SellersTableSource _source;
  
  @override
  void initState() {
    super.initState();
    _source = SellersTableSource(context);
    // Bind source updates to controller changes
    final controller = Get.find<SellersController>();
    controller.onPageActivated(); // Trigger lifecycle fetch
    
    ever(controller.sellers, (sellers) {
      _source.setTotalCount(controller.totalCount);
      _source.buildDataGridRows(sellers);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellersController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppTable(
            title: 'Sellers Management',
            source: _source,
            onSearch: controller.onSearch,
            onFilter: () {
              // Implement filter dialog
            },
            bulkActions: [
              TableBulkAction(
                label: 'Suspend Selected',
                icon: Icons.pause_circle_outline,
                onAction: (items) {},
                isDestructive: true,
              ),
              TableBulkAction(
                label: 'Approve KYC',
                icon: Icons.verified_user_outlined,
                onAction: (items) {},
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
                columnName: 'shop',
                minimumWidth: 250,
                label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text('Shop', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              GridColumn(
                columnName: 'owner',
                minimumWidth: 150,
                label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text('Owner', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              GridColumn(
                columnName: 'kyc',
                minimumWidth: 130,
                label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text('KYC Status', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              GridColumn(
                columnName: 'revenue',
                minimumWidth: 120,
                label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text('Revenue', style: TextStyle(fontWeight: FontWeight.bold)),
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
