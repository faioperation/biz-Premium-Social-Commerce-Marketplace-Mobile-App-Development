import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/currency_formatter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/table/app_table_source.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../core/router/route_names.dart';

class ProductsTableSource extends AppTableSource<ProductEntity> {
  final BuildContext context;

  ProductsTableSource(this.context);

  @override
  DataGridRow buildDataGridRow(ProductEntity item) {
    return DataGridRow(cells: [
      DataGridCell<String>(columnName: 'id', value: item.id),
      DataGridCell<ProductEntity>(columnName: 'product', value: item),
      DataGridCell<String>(columnName: 'category', value: item.category),
      DataGridCell<double>(columnName: 'price', value: item.price),
      DataGridCell<int>(columnName: 'stock', value: item.stock),
      DataGridCell<String>(columnName: 'seller', value: item.sellerShopName),
      DataGridCell<String>(columnName: 'status', value: item.status),
      DataGridCell<ProductEntity>(columnName: 'actions', value: item),
    ]);
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'product') {
          final product = cell.value as ProductEntity;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrls.isNotEmpty ? product.imageUrls.first : 'https://via.placeholder.com/150',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 40,
                      height: 40,
                      color: (Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight),
                      child: Icon(Icons.image_not_supported, size: 20, color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (product.isFeatured)
                        Text('Featured', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (cell.columnName == 'price') {
          final price = cell.value as double;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              CurrencyFormatter.format(price),
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
            ),
          );
        } else if (cell.columnName == 'stock') {
          final stock = cell.value as int;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              stock.toString(),
              style: AppTextStyles.body.copyWith(
                color: stock == 0 ? AppColors.error : (Theme.of(context).brightness == Brightness.dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                fontWeight: stock == 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        } else if (cell.columnName == 'status') {
          final status = cell.value as String;
          AppStatusType type;
          if (status == 'approved' || status == 'featured') {
            type = AppStatusType.success;
          } else if (status == 'rejected' || status == 'disabled') {
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
          final product = cell.value as ProductEntity;
          return Container(
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(Icons.remove_red_eye, color: AppColors.primary),
              onPressed: () {
                context.goNamed(RouteNames.productDetails, pathParameters: {'id': product.id});
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
