import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/table/app_table_source.dart';
import '../../../../core/router/route_names.dart';
import '../../domain/entities/support_ticket_entity.dart';

class SupportTicketsTableSource extends AppTableSource<SupportTicketEntity> {
  final BuildContext context;
  SupportTicketsTableSource(this.context);

  @override
  DataGridRow buildDataGridRow(SupportTicketEntity item) {
    return DataGridRow(cells: [
      DataGridCell<String>(columnName: 'id', value: item.id),
      DataGridCell<String>(columnName: 'subject', value: item.subject),
      DataGridCell<String>(columnName: 'user', value: item.userName),
      DataGridCell<String>(columnName: 'category', value: item.category),
      DataGridCell<String>(columnName: 'priority', value: item.priority),
      DataGridCell<String>(columnName: 'status', value: item.status),
      DataGridCell<DateTime>(columnName: 'created', value: item.createdAt),
    ]);
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final rowIndex = rows.indexOf(row);
    final ticket = (rowIndex >= 0 && rowIndex < rawData.length) ? rawData[rowIndex] : null;

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'status') {
          final status = cell.value as String;
          AppStatusType type;
          switch (status) {
            case 'open': type = AppStatusType.info; break;
            case 'escalated': type = AppStatusType.error; break;
            case 'resolved': type = AppStatusType.success; break;
            case 'closed': type = AppStatusType.standard; break;
            default: type = AppStatusType.warning;
          }
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppStatusChip(label: status.toUpperCase(), type: type),
          );
        }

        if (cell.columnName == 'priority') {
          final priority = cell.value as String;
          Color color;
          switch (priority) {
            case 'urgent': color = AppColors.error; break;
            case 'high': color = AppColors.warning; break;
            case 'medium': color = AppColors.info; break;
            default: color = (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight);
          }
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                priority.toUpperCase(),
                style: AppTextStyles.bodySm.copyWith(color: color, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }

        if (cell.columnName == 'created') {
          final date = cell.value as DateTime;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(DateFormat('MMM d, y').format(date), style: AppTextStyles.body),
          );
        }

        if (cell.columnName == 'id') {
          return GestureDetector(
            onTap: () {
              if (ticket != null) {
                context.goNamed(RouteNames.supportTicketDetails, pathParameters: {'id': ticket.id});
              }
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '#${(cell.value as String).replaceAll('ticket_', '')}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          );
        }

        if (cell.columnName == 'subject') {
          return GestureDetector(
            onTap: () {
              if (ticket != null) {
                context.goNamed(RouteNames.supportTicketDetails, pathParameters: {'id': ticket.id});
              }
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                cell.value.toString(),
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }

        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(cell.value.toString(), style: AppTextStyles.body, maxLines: 1, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }
}
