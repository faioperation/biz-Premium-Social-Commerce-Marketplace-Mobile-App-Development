import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  final col = GridColumn(
    columnName: 'test',
    minimumWidth: 100,
    width: 200,
    label: Container(),
  );
  print(col.columnName);
}
