import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/currency_formatter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/table/app_table_source.dart';
import '../../domain/entities/seller_entity.dart';
import '../../../../core/router/route_names.dart';

class SellersTableSource extends AppTableSource<SellerEntity> {
  final BuildContext context;
  
  SellersTableSource(this.context);

  @override
  DataGridRow buildDataGridRow(SellerEntity item) {
    return DataGridRow(cells: [
      DataGridCell<String>(columnName: 'id', value: item.id),
      DataGridCell<SellerEntity>(columnName: 'shop', value: item),
      DataGridCell<String>(columnName: 'owner', value: item.ownerName),
      DataGridCell<String>(columnName: 'kyc', value: item.kycStatus),
      DataGridCell<double>(columnName: 'revenue', value: item.totalRevenue),
      DataGridCell<String>(columnName: 'status', value: item.status),
      DataGridCell<SellerEntity>(columnName: 'actions', value: item),
    ]);
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'shop') {
          final seller = cell.value as SellerEntity;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                AppAvatar(imageUrl: seller.logoUrl, initials: seller.shopName.substring(0, 1), radius: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(seller.shopName, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                      Text(seller.email, style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (cell.columnName == 'kyc') {
          final status = cell.value as String;
          AppStatusType type;
          if (status == 'approved') {
            type = AppStatusType.success;
          } else if (status == 'rejected') {
            type = AppStatusType.error;
          } else {
            type = AppStatusType.warning;
          }
          
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppStatusChip(label: status.toUpperCase(), type: type),
          );
        } else if (cell.columnName == 'status') {
          final status = cell.value as String;
          AppStatusType type;
          if (status == 'active') {
            type = AppStatusType.success;
          } else if (status == 'suspended' || status == 'pending') {
            type = AppStatusType.warning;
          } else {
            type = AppStatusType.error;
          }
          
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppStatusChip(label: status.toUpperCase(), type: type),
          );
        } else if (cell.columnName == 'revenue') {
          final revenue = cell.value as double;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              CurrencyFormatter.format(revenue),
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
            ),
          );
        } else if (cell.columnName == 'actions') {
          final seller = cell.value as SellerEntity;
          return Container(
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(Icons.remove_red_eye, color: AppColors.primary),
              onPressed: () {
                context.goNamed(RouteNames.sellerDetails, pathParameters: {'id': seller.id});
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
