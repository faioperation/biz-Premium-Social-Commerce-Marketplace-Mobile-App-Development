import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/orders_controller.dart';
import '../../../../core/widgets/app_loader.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/widgets/table/app_table.dart';
import '../widgets/orders_table_source.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late final OrdersController controller;
  late final OrdersTableSource _source;

  @override
  void initState() {
    super.initState();
    _source = OrdersTableSource(context);
    if (!Get.isRegistered<OrdersController>()) {
      Get.put(OrdersController());
    }
    controller = Get.find<OrdersController>();
    controller.onPageActivated(forceRefresh: true);
    
    ever(controller.orders, (orders) {
      _source.setTotalCount(orders.length);
      _source.buildDataGridRows(orders);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppTable(
            title: 'Orders Management',
            source: _source,
            columns: [
              GridColumn(
                columnName: 'id',
                minimumWidth: 200,
                label: _buildColumnHeader('Order ID'),
              ),
              GridColumn(
                columnName: 'status',
                minimumWidth: 150,
                label: _buildColumnHeader('Status'),
              ),
              GridColumn(
                columnName: 'total',
                minimumWidth: 150,
                label: _buildColumnHeader('Total Amount'),
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
