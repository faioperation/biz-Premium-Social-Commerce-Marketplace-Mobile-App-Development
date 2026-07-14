import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/table/app_table.dart';
import '../controllers/support_tickets_controller.dart';
import '../widgets/support_tickets_table_source.dart';

class SupportTicketsPage extends StatefulWidget {
  const SupportTicketsPage({super.key});

  @override
  State<SupportTicketsPage> createState() => _SupportTicketsPageState();
}

class _SupportTicketsPageState extends State<SupportTicketsPage> {
  late final SupportTicketsTableSource _source;
  late final SupportTicketsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SupportTicketsController>();
    _source = SupportTicketsTableSource(context);
    ever(controller.tickets, (list) {
      _source.setTotalCount(controller.totalCount.value);
      _source.buildDataGridRows(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Support Tickets', style: AppTextStyles.h2),
              const SizedBox(height: 4),
              Text('Manage customer support requests and refund disputes.', style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
              const SizedBox(height: AppSpacing.lg),
              _buildStatsRow(),
              const SizedBox(height: AppSpacing.lg),
              _buildFilterTabs(),
            ],
          ),
        ),
        Expanded(
          child: AppTable(
            title: 'All Tickets',
            source: _source,
            onSearch: controller.applySearch,
            onFilter: () {},
            columns: [
              GridColumn(columnName: 'id', minimumWidth: 80, label: _header('ID')),
              GridColumn(columnName: 'subject', minimumWidth: 280, label: _header('Subject')),
              GridColumn(columnName: 'user', minimumWidth: 150, label: _header('User')),
              GridColumn(columnName: 'category', minimumWidth: 130, label: _header('Category')),
              GridColumn(columnName: 'priority', minimumWidth: 120, label: _header('Priority')),
              GridColumn(columnName: 'status', minimumWidth: 130, label: _header('Status')),
              GridColumn(columnName: 'created', minimumWidth: 130, label: _header('Created')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header(String title) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    alignment: Alignment.centerLeft,
    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _buildStatsRow() {
    return Obx(() => Row(
      children: [
        _statCard('Open', controller.openCount.value, AppColors.info, Icons.inbox_rounded),
        const SizedBox(width: AppSpacing.md),
        _statCard('Escalated', controller.escalatedCount.value, AppColors.error, Icons.priority_high_rounded),
        const SizedBox(width: AppSpacing.md),
        _statCard('Closed', controller.closedCount.value, (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight), Icons.check_circle_outline),
        const SizedBox(width: AppSpacing.md),
        _statCard('Total', controller.totalCount.value, AppColors.primary, Icons.support_agent),
      ],
    ));
  }

  Widget _statCard(String label, int count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$count', style: AppTextStyles.h3.copyWith(color: color)),
                Text(label, style: AppTextStyles.bodySm.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Obx(() {
      final filters = ['all', 'open', 'escalated', 'closed', 'resolved'];
      final labels = ['All', 'Open', 'Escalated', 'Closed', 'Resolved'];
      return Row(
        children: List.generate(filters.length, (i) {
          final isSelected = controller.statusFilter.value == filters[i];
          return GestureDetector(
            onTap: () => controller.applyStatusFilter(filters[i]),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : (Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight),
                ),
              ),
              child: Text(
                labels[i],
                style: AppTextStyles.bodySm.copyWith(
                  color: isSelected ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}
