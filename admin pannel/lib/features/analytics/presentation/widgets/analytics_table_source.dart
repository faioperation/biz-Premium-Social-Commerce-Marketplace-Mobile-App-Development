import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/widgets/table/app_table_source.dart';

class AnalyticsTableSource extends AppTableSource<Map<String, dynamic>> {
  final BuildContext context;
  
  AnalyticsTableSource(this.context);

  @override
  DataGridRow buildDataGridRow(Map<String, dynamic> item) {
    return DataGridRow(cells: [
      DataGridCell<String>(columnName: 'metric', value: item['metric']),
      DataGridCell<String>(columnName: 'value', value: item['value'].toString()),
      DataGridCell<String>(columnName: 'change', value: item['change']),
    ]);
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}
