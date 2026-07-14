import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/widgets/table/app_table.dart';
import '../controllers/auctions_controller.dart';
import '../widgets/auctions_table_source.dart';

class AuctionsPage extends StatefulWidget {
  const AuctionsPage({super.key});

  @override
  State<AuctionsPage> createState() => _AuctionsPageState();
}

class _AuctionsPageState extends State<AuctionsPage> {
  late final AuctionsController controller;
  late final AuctionsTableSource _source;

  @override
  void initState() {
    super.initState();
    _source = AuctionsTableSource(context);
    if (!Get.isRegistered<AuctionsController>()) {
      Get.put(AuctionsController());
    }
    controller = Get.find<AuctionsController>();
    controller.onPageActivated(forceRefresh: true);
    
    ever(controller.auctions, (auctions) {
      _source.setTotalCount(auctions.length);
      _source.buildDataGridRows(auctions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppTable(
            title: 'Auctions Management',
            source: _source,
            columns: [
              GridColumn(
                columnName: 'id',
                minimumWidth: 150,
                label: _buildColumnHeader('Auction ID'),
              ),
              GridColumn(
                columnName: 'item',
                minimumWidth: 200,
                label: _buildColumnHeader('Item Name'),
              ),
              GridColumn(
                columnName: 'status',
                minimumWidth: 120,
                label: _buildColumnHeader('Status'),
              ),
              GridColumn(
                columnName: 'highestBid',
                minimumWidth: 150,
                label: _buildColumnHeader('Highest Bid'),
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
