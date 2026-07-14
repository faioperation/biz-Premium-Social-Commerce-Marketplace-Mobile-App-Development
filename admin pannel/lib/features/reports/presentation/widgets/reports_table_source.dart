import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/table/app_table_source.dart';
import '../../domain/entities/report_entity.dart';
import '../../../../core/router/route_names.dart';

class ReportsTableSource extends AppTableSource<ReportEntity> {
  final BuildContext context;

  ReportsTableSource(this.context);

  @override
  DataGridRow buildDataGridRow(ReportEntity item) {
    return DataGridRow(cells: [
      DataGridCell<String>(columnName: 'id', value: item.id),
      DataGridCell<String>(columnName: 'reporter', value: item.reporterName),
      DataGridCell<ReportEntity>(columnName: 'target', value: item),
      DataGridCell<String>(columnName: 'reason', value: item.reason),
      DataGridCell<DateTime>(columnName: 'date', value: item.createdAt),
      DataGridCell<String>(columnName: 'status', value: item.status),
      DataGridCell<ReportEntity>(columnName: 'actions', value: item),
    ]);
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'target') {
          final report = cell.value as ReportEntity;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  report.targetName,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  report.targetType.toUpperCase(),
                  style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          );
        } else if (cell.columnName == 'date') {
          final date = cell.value as DateTime;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              DateFormat('MMM d, yyyy').format(date),
              style: AppTextStyles.body,
            ),
          );
        } else if (cell.columnName == 'status') {
          final status = cell.value as String;
          AppStatusType type;
          if (status == 'resolved') {
            type = AppStatusType.success;
          } else if (status == 'dismissed') {
            type = AppStatusType.error;
          } else {
            type = AppStatusType.warning; // pending
          }

          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppStatusChip(label: status.toUpperCase(), type: type),
          );
        } else if (cell.columnName == 'actions') {
          final report = cell.value as ReportEntity;
          return Container(
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(Icons.remove_red_eye, color: AppColors.primary),
              onPressed: () {
                context.goNamed(RouteNames.reportDetails, pathParameters: {'id': report.id});
              },
            ),
          );
        }

        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(cell.value.toString(), style: AppTextStyles.body),
        );
      }).toList(),
    );
  }
}
