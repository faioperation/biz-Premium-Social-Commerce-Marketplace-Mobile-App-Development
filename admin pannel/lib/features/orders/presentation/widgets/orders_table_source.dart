import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/widgets/table/app_table_source.dart';

class OrdersTableSource extends AppTableSource<String> {
  final BuildContext context;
  
  OrdersTableSource(this.context);

  @override
  DataGridRow buildDataGridRow(String item) {
    return DataGridRow(cells: [
      DataGridCell<String>(columnName: 'id', value: item),
      const DataGridCell<String>(columnName: 'status', value: 'Pending'),
      const DataGridCell<double>(columnName: 'total', value: 100.0),
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
