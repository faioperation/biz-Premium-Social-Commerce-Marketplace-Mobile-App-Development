import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';

import '../../../../core/mixins/page_lifecycle_mixin.dart';

class ReportsController extends GetxController with PageLifecycleMixin {
  final ReportRepository _repository;

  ReportsController(this._repository);

  final RxList<ReportEntity> reports = <ReportEntity>[].obs;

  int _currentPage = 1;
  final int _limit = 15;
  String _statusFilter = 'All';
  String _targetTypeFilter = 'All';

  final RxInt totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Replaced by onPageActivated in the UI
  }

  Future<void> _loadTotalCount() async {
    totalCount.value = await _repository.getTotalCount();
  }

  @override
  Future<void> fetchData({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      reports.clear();
      await _loadTotalCount();
    }

    final newReports = await _repository.getReports(
      page: _currentPage,
      limit: _limit,
      statusFilter: _statusFilter,
      targetTypeFilter: _targetTypeFilter,
    );

    if (isRefresh) {
      reports.value = newReports;
    } else {
      reports.addAll(newReports);
    }

    _currentPage++;
  }

  void onStatusChanged(String? status) {
    if (status == null) return;
    _statusFilter = status;
    onPageActivated(forceRefresh: true);
  }

  void onTargetTypeChanged(String? type) {
    if (type == null) return;
    _targetTypeFilter = type;
    onPageActivated(forceRefresh: true);
  }
}
