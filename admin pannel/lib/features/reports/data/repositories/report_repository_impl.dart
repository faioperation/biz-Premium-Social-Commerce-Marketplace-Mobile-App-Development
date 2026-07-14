import '../../../../core/network/network_service.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../models/report_model.dart';

class ReportRepositoryImpl implements ReportRepository {
  // ignore: unused_field
  final NetworkService _networkService;

  ReportRepositoryImpl(this._networkService);

  static const _reasonsUser = ['Spam', 'Abuse', 'Scam'];
  static const _reasonsProduct = ['Fake Product', 'Copyright', 'Prohibited Item'];
  static const _reasonsStream = ['Inappropriate Content', 'Fraudulent Selling', 'Harassment'];
  
  static const _targetTypes = ['user', 'product', 'livestream'];
  static const _statuses = ['pending', 'resolved', 'dismissed'];

  static final List<ReportModel> _mockReports = List.generate(60, (index) {
    final typeIndex = index % 3;
    final type = _targetTypes[typeIndex];
    
    String reason;
    if (type == 'user') {
      reason = _reasonsUser[(index % _reasonsUser.length)];
    } else if (type == 'product') {
      reason = _reasonsProduct[(index % _reasonsProduct.length)];
    } else {
      reason = _reasonsStream[(index % _reasonsStream.length)];
    }

    return ReportModel(
      id: 'rep_${index + 1}',
      reporterId: 'usr_${(index * 2) % 50 + 1}',
      reporterName: 'User ${(index * 2) % 50 + 1}',
      targetId: '${type.substring(0, 3)}_${index + 100}',
      targetName: '${type[0].toUpperCase()}${type.substring(1)} Target ${index + 100}',
      targetType: type,
      reason: reason,
      description: 'This is a detailed description of the report provided by the user. '
          'They claim that the target violates platform guidelines regarding $reason.',
      status: index % 5 == 0 ? _statuses[1] : (index % 7 == 0 ? _statuses[2] : _statuses[0]),
      createdAt: DateTime.now().subtract(Duration(hours: index * 5)),
    );
  });

  @override
  Future<List<ReportEntity>> getReports({
    int page = 1,
    int limit = 15,
    String? statusFilter,
    String? targetTypeFilter,
    String? dateRange,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    List<ReportModel> filtered = List.from(_mockReports);

    if (statusFilter != null && statusFilter != 'All') {
      filtered = filtered.where((r) => r.status == statusFilter.toLowerCase()).toList();
    }
    
    if (targetTypeFilter != null && targetTypeFilter != 'All') {
      filtered = filtered.where((r) => r.targetType == targetTypeFilter.toLowerCase()).toList();
    }

    // Sort by newest first
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final start = (page - 1) * limit;
    if (start >= filtered.length) return [];
    final end = (start + limit).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  @override
  Future<int> getTotalCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockReports.length;
  }

  @override
  Future<ReportEntity> getReportDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockReports.firstWhere((r) => r.id == id, orElse: () => throw Exception('Report not found'));
  }

  @override
  Future<void> dismissReport(String reportId) => _updateStatus(reportId, 'dismissed');

  @override
  Future<void> resolveReport(String reportId) => _updateStatus(reportId, 'resolved');

  @override
  Future<void> suspendUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Implementation would call user endpoint
  }

  @override
  Future<void> banUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> removeContent(String targetId, String type) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> suspendStream(String streamId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _updateStatus(String reportId, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockReports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      final cur = _mockReports[index];
      _mockReports[index] = ReportModel.fromJson({
        'id': cur.id,
        'reporterId': cur.reporterId,
        'reporterName': cur.reporterName,
        'targetId': cur.targetId,
        'targetName': cur.targetName,
        'targetType': cur.targetType,
        'reason': cur.reason,
        'description': cur.description,
        'status': status,
        'createdAt': cur.createdAt.toIso8601String(),
      });
    }
  }
}
