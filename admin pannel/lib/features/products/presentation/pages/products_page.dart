import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/widgets/table/app_table.dart';
import '../../../../core/widgets/table/table_action_models.dart';
import '../controllers/products_controller.dart';
import '../widgets/products_table_source.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ProductsTableSource _source;

  @override
  void initState() {
    super.initState();
    _source = ProductsTableSource(context);
    final controller = Get.find<ProductsController>();
    controller.onPageActivated(); // Trigger lifecycle fetch
    
    ever(controller.products, (products) {
      _source.setTotalCount(controller.totalCount.value);
      _source.buildDataGridRows(products);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppTable(
            title: 'Products Management',
            source: _source,
            onSearch: controller.onSearch,
            onFilter: () {
              // Implement advanced filters
            },
            bulkActions: [
              TableBulkAction(
                label: 'Approve Selected',
                icon: Icons.check_circle_outline,
                onAction: (items) {
                  // controller.bulkApprove(items.cast<ProductEntity>().toList());
                },
              ),
              TableBulkAction(
                label: 'Disable Selected',
                icon: Icons.block,
                onAction: (items) {
                  // controller.bulkDisable(items.cast<ProductEntity>().toList());
                },
                isDestructive: true,
              ),
            ],
            columns: [
              GridColumn(
                columnName: 'id',
                minimumWidth: 100,
                label: _buildColumnHeader('ID'),
              ),
              GridColumn(
                columnName: 'product',
                minimumWidth: 300,
                label: _buildColumnHeader('Product'),
              ),
              GridColumn(
                columnName: 'category',
                minimumWidth: 150,
                label: _buildColumnHeader('Category'),
              ),
              GridColumn(
                columnName: 'price',
                minimumWidth: 120,
                label: _buildColumnHeader('Price'),
              ),
              GridColumn(
                columnName: 'stock',
                minimumWidth: 100,
                label: _buildColumnHeader('Stock'),
              ),
              GridColumn(
                columnName: 'seller',
                minimumWidth: 180,
                label: _buildColumnHeader('Seller'),
              ),
              GridColumn(
                columnName: 'status',
                minimumWidth: 130,
                label: _buildColumnHeader('Status'),
              ),
              GridColumn(
                columnName: 'actions',
                minimumWidth: 80,
                label: Container(
                  alignment: Alignment.center,
                  child: const Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColumnHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
