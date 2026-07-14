import '../../domain/entities/refund_evidence_entity.dart';

class RefundEvidenceModel extends RefundEvidenceEntity {
  const RefundEvidenceModel({
    required super.id,
    required super.submittedBy,
    required super.description,
    required super.attachmentUrls,
    required super.submittedAt,
  });

  factory RefundEvidenceModel.fromJson(Map<String, dynamic> json) {
    return RefundEvidenceModel(
      id: json['id'] ?? '',
      submittedBy: json['submittedBy'] ?? 'buyer',
      description: json['description'] ?? '',
      attachmentUrls: List<String>.from(json['attachmentUrls'] ?? []),
      submittedAt: DateTime.tryParse(json['submittedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'submittedBy': submittedBy,
    'description': description,
    'attachmentUrls': attachmentUrls,
    'submittedAt': submittedAt.toIso8601String(),
  };
}
