class ReportEntity {
  final String id;
  
  // Reporter Info
  final String reporterId;
  final String reporterName;
  
  // Target Info
  final String targetId;
  final String targetName;
  final String targetType; // 'user', 'product', 'livestream'
  
  // Report Details
  final String reason; 
  // 'Spam', 'Abuse', 'Scam', 'Fake Product', 'Copyright', 'Inappropriate Content', 'Fraudulent Selling'
  
  final String description;
  final String status; // 'pending', 'resolved', 'dismissed'
  final DateTime createdAt;

  const ReportEntity({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    required this.targetId,
    required this.targetName,
    required this.targetType,
    required this.reason,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  ReportEntity copyWith({
    String? status,
  }) {
    return ReportEntity(
      id: id,
      reporterId: reporterId,
      reporterName: reporterName,
      targetId: targetId,
      targetName: targetName,
      targetType: targetType,
      reason: reason,
      description: description,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
