import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';

class ReportDetailsController extends GetxController {
  final ReportRepository _repository;

  ReportDetailsController(this._repository);

  final Rx<ReportEntity?> report = Rx<ReportEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> loadReport(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      report.value = await _repository.getReportDetails(id);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> dismissReport() async {
    if (report.value == null) return;
    try {
      await _repository.dismissReport(report.value!.id);
      report.value = report.value!.copyWith(status: 'dismissed');
      _showSuccess('Report dismissed');
    } catch (e) {
      _showError('Failed to dismiss report');
    }
  }

  Future<void> resolveReport() async {
    if (report.value == null) return;
    try {
      await _repository.resolveReport(report.value!.id);
      report.value = report.value!.copyWith(status: 'resolved');
      _showSuccess('Report marked as resolved');
    } catch (e) {
      _showError('Failed to resolve report');
    }
  }

  // Target Actions
  Future<void> suspendUser() async {
    if (report.value == null) return;
    try {
      await _repository.suspendUser(report.value!.targetId);
      await resolveReport();
      _showSuccess('User suspended successfully');
    } catch (e) {
      _showError('Failed to suspend user');
    }
  }

  Future<void> banUser() async {
    if (report.value == null) return;
    try {
      await _repository.banUser(report.value!.targetId);
      await resolveReport();
      _showSuccess('User banned successfully');
    } catch (e) {
      _showError('Failed to ban user');
    }
  }

  Future<void> removeContent() async {
    if (report.value == null) return;
    try {
      await _repository.removeContent(report.value!.targetId, report.value!.targetType);
      await resolveReport();
      _showSuccess('Content removed successfully');
    } catch (e) {
      _showError('Failed to remove content');
    }
  }

  Future<void> suspendStream() async {
    if (report.value == null) return;
    try {
      await _repository.suspendStream(report.value!.targetId);
      await resolveReport();
      _showSuccess('Livestream suspended successfully');
    } catch (e) {
      _showError('Failed to suspend stream');
    }
  }

  void _showSuccess(String message) {
    Get.snackbar('Success', message, backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _showError(String message) {
    Get.snackbar('Error', message, backgroundColor: Colors.red, colorText: Colors.white);
  }
}
