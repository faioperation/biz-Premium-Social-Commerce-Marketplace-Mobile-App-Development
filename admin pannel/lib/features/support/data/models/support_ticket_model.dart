import '../../domain/entities/support_ticket_entity.dart';
import 'ticket_message_model.dart';
import 'refund_evidence_model.dart';

class SupportTicketModel extends SupportTicketEntity {
  const SupportTicketModel({
    required super.id,
    required super.subject,
    required super.category,
    required super.status,
    required super.priority,
    required super.userId,
    required super.userName,
    required super.userEmail,
    super.assignedAdminId,
    super.assignedAdminName,
    required super.messages,
    super.orderId,
    super.refundAmount,
    super.refundStatus,
    required super.refundEvidence,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      category: json['category'] ?? 'General',
      status: json['status'] ?? 'open',
      priority: json['priority'] ?? 'medium',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      assignedAdminId: json['assignedAdminId'],
      assignedAdminName: json['assignedAdminName'],
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map((m) => TicketMessageModel.fromJson(m as Map<String, dynamic>))
          .toList(),
      orderId: json['orderId'],
      refundAmount: (json['refundAmount'] as num?)?.toDouble(),
      refundStatus: json['refundStatus'],
      refundEvidence: (json['refundEvidence'] as List<dynamic>? ?? [])
          .map((e) => RefundEvidenceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
