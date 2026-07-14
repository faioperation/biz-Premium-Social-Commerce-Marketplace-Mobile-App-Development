import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/currency_formatter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/table/app_table_source.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/router/route_names.dart';

class UsersTableSource extends AppTableSource<UserEntity> {
  final BuildContext context;
  
  UsersTableSource(this.context);

  @override
  DataGridRow buildDataGridRow(UserEntity item) {
    return DataGridRow(cells: [
      DataGridCell<String>(columnName: 'id', value: item.id),
      DataGridCell<UserEntity>(columnName: 'user', value: item),
      DataGridCell<String>(columnName: 'phone', value: item.phone ?? 'N/A'),
      DataGridCell<double>(columnName: 'wallet', value: item.walletBalance),
      DataGridCell<String>(columnName: 'status', value: item.status),
      DataGridCell<DateTime>(columnName: 'joinedAt', value: item.joinedAt),
      DataGridCell<UserEntity>(columnName: 'actions', value: item),
    ]);
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'user') {
          final user = cell.value as UserEntity;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                AppAvatar(imageUrl: user.avatarUrl, initials: user.name.substring(0, 1), radius: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                      Text(user.email, style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (cell.columnName == 'status') {
          final status = cell.value as String;
          AppStatusType type;
          if (status == 'active') {
            type = AppStatusType.success;
          } else if (status == 'suspended') {
            type = AppStatusType.warning;
          } else {
            type = AppStatusType.error;
          }
          
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppStatusChip(label: status.toUpperCase(), type: type),
          );
        } else if (cell.columnName == 'wallet') {
          final balance = cell.value as double;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              CurrencyFormatter.format(balance),
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
            ),
          );
        } else if (cell.columnName == 'joinedAt') {
          final date = cell.value as DateTime;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(DateFormat('MMM d, yyyy').format(date), style: AppTextStyles.body),
          );
        } else if (cell.columnName == 'actions') {
          final user = cell.value as UserEntity;
          return Container(
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(Icons.remove_red_eye, color: AppColors.primary),
              onPressed: () {
                context.goNamed(RouteNames.userDetails, pathParameters: {'id': user.id});
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
