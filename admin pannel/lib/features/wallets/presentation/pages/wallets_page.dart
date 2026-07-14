import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallets_controller.dart';
import '../../../../core/widgets/app_loader.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/widgets/table/app_table.dart';
import '../widgets/wallets_table_source.dart';

class WalletsPage extends StatefulWidget {
  const WalletsPage({super.key});

  @override
  State<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  late final WalletsController controller;
  late final WalletsTableSource _source;

  @override
  void initState() {
    super.initState();
    _source = WalletsTableSource(context);
    if (!Get.isRegistered<WalletsController>()) {
      Get.put(WalletsController());
    }
    controller = Get.find<WalletsController>();
    controller.onPageActivated(forceRefresh: true);
    
    ever(controller.transactions, (transactions) {
      _source.setTotalCount(transactions.length);
      _source.buildDataGridRows(transactions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppTable(
            title: 'Wallets & Transactions',
            source: _source,
            columns: [
              GridColumn(
                columnName: 'id',
                minimumWidth: 200,
                label: _buildColumnHeader('Transaction ID'),
              ),
              GridColumn(
                columnName: 'type',
                minimumWidth: 150,
                label: _buildColumnHeader('Type'),
              ),
              GridColumn(
                columnName: 'amount',
                minimumWidth: 150,
                label: _buildColumnHeader('Amount'),
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
