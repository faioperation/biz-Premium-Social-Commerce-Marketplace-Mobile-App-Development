class RefundEvidenceEntity {
  final String id;
  final String submittedBy; // 'buyer' or 'seller'
  final String description;
  final List<String> attachmentUrls;
  final DateTime submittedAt;

  const RefundEvidenceEntity({
    required this.id,
    required this.submittedBy,
    required this.description,
    required this.attachmentUrls,
    required this.submittedAt,
  });
}
