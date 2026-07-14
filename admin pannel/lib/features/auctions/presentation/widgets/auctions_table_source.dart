import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/widgets/table/app_table_source.dart';

class AuctionsTableSource extends AppTableSource<Map<String, dynamic>> {
  final BuildContext context;
  
  AuctionsTableSource(this.context);

  @override
  DataGridRow buildDataGridRow(Map<String, dynamic> item) {
    return DataGridRow(cells: [
      DataGridCell<String>(columnName: 'id', value: item['id']),
      DataGridCell<String>(columnName: 'item', value: item['item']),
      DataGridCell<String>(columnName: 'status', value: item['status']),
      DataGridCell<double>(columnName: 'highestBid', value: item['highestBid']),
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
