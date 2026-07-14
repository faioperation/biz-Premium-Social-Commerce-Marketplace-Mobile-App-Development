import 'ticket_message_entity.dart';
import 'refund_evidence_entity.dart';

class SupportTicketEntity {
  final String id;
  final String subject;
  final String category; // 'General', 'Refund', 'Shipping', 'Technical'
  final String status; // 'open', 'closed', 'escalated', 'resolved'
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final String userId;
  final String userName;
  final String userEmail;
  final String? assignedAdminId;
  final String? assignedAdminName;
  final List<TicketMessageEntity> messages;

  // Refund Support (only present when category == 'Refund')
  final String? orderId;
  final double? refundAmount;
  final String? refundStatus; // 'pending_review', 'approved', 'rejected'
  final List<RefundEvidenceEntity> refundEvidence;

  final DateTime createdAt;
  final DateTime updatedAt;

  const SupportTicketEntity({
    required this.id,
    required this.subject,
    required this.category,
    required this.status,
    required this.priority,
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.assignedAdminId,
    this.assignedAdminName,
    required this.messages,
    this.orderId,
    this.refundAmount,
    this.refundStatus,
    required this.refundEvidence,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get hasRefund => category == 'Refund' && orderId != null;
  int get messageCount => messages.length;
}
