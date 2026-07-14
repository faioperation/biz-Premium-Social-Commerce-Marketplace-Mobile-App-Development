import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/analytics_controller.dart';
import '../../../../core/widgets/app_loader.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/widgets/table/app_table.dart';
import '../widgets/analytics_table_source.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late final AnalyticsController controller;
  late final AnalyticsTableSource _source;

  @override
  void initState() {
    super.initState();
    _source = AnalyticsTableSource(context);
    if (!Get.isRegistered<AnalyticsController>()) {
      Get.put(AnalyticsController());
    }
    controller = Get.find<AnalyticsController>();
    controller.onPageActivated(forceRefresh: true);
    
    ever(controller.data, (data) {
      _source.setTotalCount(data.length);
      _source.buildDataGridRows(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppTable(
            title: 'Analytics Overview',
            source: _source,
            columns: [
              GridColumn(
                columnName: 'metric',
                minimumWidth: 200,
                label: _buildColumnHeader('Metric'),
              ),
              GridColumn(
                columnName: 'value',
                minimumWidth: 150,
                label: _buildColumnHeader('Value'),
              ),
              GridColumn(
                columnName: 'change',
                minimumWidth: 150,
                label: _buildColumnHeader('Change (30d)'),
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
