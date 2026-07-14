import 'package:syncfusion_flutter_datagrid/datagrid.dart';

abstract class AppTableSource<T> extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  List<T> rawData = [];

  int _dataCount = 0;
  int rowsPerPage = 15;

  @override
  List<DataGridRow> get rows => _dataGridRows;

  void buildDataGridRows(List<T> data) {
    rawData = data;
    _dataGridRows = data.map<DataGridRow>((item) => buildDataGridRow(item)).toList();
    notifyListeners();
  }

  /// Must be overridden by subclasses to map model T to DataGridRow
  DataGridRow buildDataGridRow(T item);

  /// Must be overridden to build individual cells
  @override
  DataGridRowAdapter? buildRow(DataGridRow row);

  /// Update total count for server-side pagination
  void setTotalCount(int count) {
    _dataCount = count;
  }

  int get totalCount => _dataCount;
}
