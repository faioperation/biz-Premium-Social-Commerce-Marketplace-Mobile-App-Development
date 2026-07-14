import '../../domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  const ReportModel({
    required super.id,
    required super.reporterId,
    required super.reporterName,
    required super.targetId,
    required super.targetName,
    required super.targetType,
    required super.reason,
    required super.description,
    required super.status,
    required super.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? '',
      reporterId: json['reporterId'] ?? '',
      reporterName: json['reporterName'] ?? '',
      targetId: json['targetId'] ?? '',
      targetName: json['targetName'] ?? '',
      targetType: json['targetType'] ?? 'user',
      reason: json['reason'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
