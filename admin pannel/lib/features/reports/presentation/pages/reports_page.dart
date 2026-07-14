import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/widgets/table/app_table.dart';
import '../controllers/reports_controller.dart';
import '../widgets/reports_table_source.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late final ReportsTableSource _source;

  @override
  void initState() {
    super.initState();
    _source = ReportsTableSource(context);
    final controller = Get.find<ReportsController>();
    controller.onPageActivated(); // Trigger lifecycle fetch
    ever(controller.reports, (reports) {
      _source.setTotalCount(controller.totalCount.value);
      _source.buildDataGridRows(reports);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final controller = Get.find<ReportsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppTable(
            title: 'Reports & Moderation',
            source: _source,
            onSearch: (query) {}, // Currently no backend search implemented for reports
            onFilter: () {
              // Implement advanced filters
            },
            columns: [
              GridColumn(
                columnName: 'id',
                minimumWidth: 100,
                label: _buildColumnHeader('ID'),
              ),
              GridColumn(
                columnName: 'reporter',
                minimumWidth: 180,
                label: _buildColumnHeader('Reporter'),
              ),
              GridColumn(
                columnName: 'target',
                minimumWidth: 250,
                label: _buildColumnHeader('Target'),
              ),
              GridColumn(
                columnName: 'reason',
                minimumWidth: 200,
                label: _buildColumnHeader('Reason'),
              ),
              GridColumn(
                columnName: 'date',
                minimumWidth: 150,
                label: _buildColumnHeader('Date'),
              ),
              GridColumn(
                columnName: 'status',
                minimumWidth: 130,
                label: _buildColumnHeader('Status'),
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

  Widget _buildColumnHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
