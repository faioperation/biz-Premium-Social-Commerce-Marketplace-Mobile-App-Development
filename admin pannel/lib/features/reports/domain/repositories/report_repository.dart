import '../entities/report_entity.dart';

abstract class ReportRepository {
  Future<List<ReportEntity>> getReports({
    int page = 1,
    int limit = 15,
    String? statusFilter,
    String? targetTypeFilter,
    String? dateRange,
  });
  
  Future<int> getTotalCount();
  Future<ReportEntity> getReportDetails(String id);

  // Report Resolution
  Future<void> dismissReport(String reportId);
  Future<void> resolveReport(String reportId);

  // Moderation Actions on Target
  Future<void> suspendUser(String userId);
  Future<void> banUser(String userId);
  Future<void> removeContent(String targetId, String type); // type: product or livestream
  Future<void> suspendStream(String streamId);
}
