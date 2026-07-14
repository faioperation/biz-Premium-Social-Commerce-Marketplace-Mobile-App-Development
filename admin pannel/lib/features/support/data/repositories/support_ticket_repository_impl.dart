import '../../../../core/network/network_service.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/repositories/support_ticket_repository.dart';
import '../models/support_ticket_model.dart';
import '../models/ticket_message_model.dart';
import '../models/refund_evidence_model.dart';

class SupportTicketRepositoryImpl implements SupportTicketRepository {
  // ignore: unused_field
  final NetworkService _networkService;

  SupportTicketRepositoryImpl(this._networkService);

  static final List<String> _statuses = ['open', 'open', 'open', 'escalated', 'closed', 'resolved'];
  static final List<String> _categories = ['General', 'Refund', 'Technical', 'Shipping'];
  static final List<String> _priorities = ['low', 'medium', 'high', 'urgent'];

  static final List<String> _subjects = [
    'I haven\'t received my order yet',
    'Product is defective, requesting refund',
    'App keeps crashing when I open seller dashboard',
    'Payment was deducted but order not placed',
    'How do I become a verified seller?',
    'Incorrect item delivered',
    'Cannot withdraw funds from my wallet',
    'Livestream not starting properly',
    'Need to cancel subscription plan',
    'Auction bid not reflected',
  ];

  static List<SupportTicketModel> _mockTickets = List.generate(50, (i) {
    final status = _statuses[i % _statuses.length];
    final category = _categories[i % _categories.length];
    final isRefund = category == 'Refund';
    final createdAt = DateTime.now().subtract(Duration(days: i * 2 + 1));

    final messages = <TicketMessageModel>[
      TicketMessageModel(
        id: 'msg_${i}_1',
        senderId: 'user_$i',
        senderName: 'User ${i + 1}',
        isAdmin: false,
        message: 'Hi, I am having an issue with my order. ${_subjects[i % _subjects.length]}. Please assist me as soon as possible.',
        attachmentUrls: i.isEven ? ['https://placehold.co/400x300'] : [],
        createdAt: createdAt,
      ),
      if (i % 3 != 0)
        TicketMessageModel(
          id: 'msg_${i}_2',
          senderId: 'admin_1',
          senderName: 'Support Agent',
          isAdmin: true,
          message: 'Thank you for reaching out. We have received your request and are looking into it. Our team will respond within 24 hours.',
          attachmentUrls: [],
          createdAt: createdAt.add(const Duration(hours: 2)),
        ),
      if (i % 5 == 0)
        TicketMessageModel(
          id: 'msg_${i}_3',
          senderId: 'user_$i',
          senderName: 'User ${i + 1}',
          isAdmin: false,
          message: 'Thank you for the quick response. I have attached additional screenshots to better explain the issue.',
          attachmentUrls: ['https://placehold.co/400x300', 'https://placehold.co/400x300'],
          createdAt: createdAt.add(const Duration(hours: 4)),
        ),
    ];

    final refundEvidence = isRefund
        ? <RefundEvidenceModel>[
            RefundEvidenceModel(
              id: 'ev_${i}_1',
              submittedBy: 'buyer',
              description: 'The product was damaged on arrival. Photos attached.',
              attachmentUrls: ['https://placehold.co/400x300', 'https://placehold.co/400x300'],
              submittedAt: createdAt.add(const Duration(hours: 1)),
            ),
            RefundEvidenceModel(
              id: 'ev_${i}_2',
              submittedBy: 'seller',
              description: 'The item was properly packaged and handed to the courier. Damage occurred during delivery.',
              attachmentUrls: ['https://placehold.co/400x300'],
              submittedAt: createdAt.add(const Duration(hours: 6)),
            ),
          ]
        : <RefundEvidenceModel>[];

    return SupportTicketModel(
      id: 'ticket_${i + 1}',
      subject: _subjects[i % _subjects.length],
      category: category,
      status: status,
      priority: _priorities[i % _priorities.length],
      userId: 'user_$i',
      userName: 'User ${i + 1}',
      userEmail: 'user${i + 1}@example.com',
      assignedAdminId: i % 2 == 0 ? 'admin_1' : null,
      assignedAdminName: i % 2 == 0 ? 'John (Support)' : null,
      messages: messages,
      orderId: isRefund ? 'ORD-${10000 + i}' : null,
      refundAmount: isRefund ? (25.0 + i * 8.5) : null,
      refundStatus: isRefund
          ? (['pending_review', 'approved', 'rejected'][i % 3])
          : null,
      refundEvidence: refundEvidence,
      createdAt: createdAt,
      updatedAt: createdAt.add(Duration(hours: i % 12)),
    );
  });

  @override
  Future<List<SupportTicketEntity>> getTickets({
    int page = 1,
    int limit = 15,
    String? statusFilter,
    String? categoryFilter,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    var filtered = List<SupportTicketModel>.from(_mockTickets);

    if (statusFilter != null && statusFilter.isNotEmpty && statusFilter != 'all') {
      filtered = filtered.where((t) => t.status == statusFilter).toList();
    }
    if (categoryFilter != null && categoryFilter.isNotEmpty && categoryFilter != 'all') {
      filtered = filtered.where((t) => t.category == categoryFilter).toList();
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      filtered = filtered.where((t) =>
        t.subject.toLowerCase().contains(q) ||
        t.userName.toLowerCase().contains(q) ||
        t.userEmail.toLowerCase().contains(q) ||
        t.id.toLowerCase().contains(q)
      ).toList();
    }

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final start = (page - 1) * limit;
    if (start >= filtered.length) return [];
    return filtered.sublist(start, (start + limit).clamp(0, filtered.length));
  }

  @override
  Future<int> getTotalCount({String? statusFilter}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (statusFilter != null && statusFilter != 'all') {
      return _mockTickets.where((t) => t.status == statusFilter).length;
    }
    return _mockTickets.length;
  }

  @override
  Future<SupportTicketEntity> getTicketDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockTickets.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Ticket not found'),
    );
  }

  @override
  Future<void> replyToTicket(String ticketId, String message, List<String> attachments) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final index = _mockTickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final ticket = _mockTickets[index];
      final newMsg = TicketMessageModel(
        id: 'msg_reply_${DateTime.now().millisecondsSinceEpoch}',
        senderId: 'admin_1',
        senderName: 'Support Agent',
        isAdmin: true,
        message: message,
        attachmentUrls: attachments,
        createdAt: DateTime.now(),
      );
      _mockTickets[index] = SupportTicketModel(
        id: ticket.id,
        subject: ticket.subject,
        category: ticket.category,
        status: ticket.status == 'closed' ? 'open' : ticket.status,
        priority: ticket.priority,
        userId: ticket.userId,
        userName: ticket.userName,
        userEmail: ticket.userEmail,
        assignedAdminId: ticket.assignedAdminId,
        assignedAdminName: ticket.assignedAdminName,
        messages: [...ticket.messages, newMsg],
        orderId: ticket.orderId,
        refundAmount: ticket.refundAmount,
        refundStatus: ticket.refundStatus,
        refundEvidence: ticket.refundEvidence.map((e) => RefundEvidenceModel(
          id: e.id,
          submittedBy: e.submittedBy,
          description: e.description,
          attachmentUrls: e.attachmentUrls,
          submittedAt: e.submittedAt,
        )).toList(),
        createdAt: ticket.createdAt,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> resolveTicket(String ticketId) async => _updateStatus(ticketId, 'resolved');

  @override
  Future<void> escalateTicket(String ticketId) async => _updateStatus(ticketId, 'escalated');

  @override
  Future<void> closeTicket(String ticketId) async => _updateStatus(ticketId, 'closed');

  @override
  Future<void> assignTicket(String ticketId, String adminId, String adminName) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockTickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final t = _mockTickets[index];
      _mockTickets[index] = SupportTicketModel(
        id: t.id, subject: t.subject, category: t.category, status: t.status,
        priority: t.priority, userId: t.userId, userName: t.userName, userEmail: t.userEmail,
        assignedAdminId: adminId, assignedAdminName: adminName,
        messages: t.messages,
        orderId: t.orderId, refundAmount: t.refundAmount, refundStatus: t.refundStatus,
        refundEvidence: t.refundEvidence.map((e) => RefundEvidenceModel(
          id: e.id, submittedBy: e.submittedBy, description: e.description,
          attachmentUrls: e.attachmentUrls, submittedAt: e.submittedAt,
        )).toList(),
        createdAt: t.createdAt, updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> approveRefund(String ticketId) async => _updateRefundStatus(ticketId, 'approved');

  @override
  Future<void> rejectRefund(String ticketId, String reason) async => _updateRefundStatus(ticketId, 'rejected');

  Future<void> _updateStatus(String ticketId, String status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockTickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final t = _mockTickets[index];
      _mockTickets[index] = SupportTicketModel(
        id: t.id, subject: t.subject, category: t.category, status: status,
        priority: t.priority, userId: t.userId, userName: t.userName, userEmail: t.userEmail,
        assignedAdminId: t.assignedAdminId, assignedAdminName: t.assignedAdminName,
        messages: t.messages,
        orderId: t.orderId, refundAmount: t.refundAmount, refundStatus: t.refundStatus,
        refundEvidence: t.refundEvidence.map((e) => RefundEvidenceModel(
          id: e.id, submittedBy: e.submittedBy, description: e.description,
          attachmentUrls: e.attachmentUrls, submittedAt: e.submittedAt,
        )).toList(),
        createdAt: t.createdAt, updatedAt: DateTime.now(),
      );
    }
  }

  Future<void> _updateRefundStatus(String ticketId, String refundStatus) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockTickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final t = _mockTickets[index];
      _mockTickets[index] = SupportTicketModel(
        id: t.id, subject: t.subject, category: t.category,
        status: refundStatus == 'approved' ? 'resolved' : t.status,
        priority: t.priority, userId: t.userId, userName: t.userName, userEmail: t.userEmail,
        assignedAdminId: t.assignedAdminId, assignedAdminName: t.assignedAdminName,
        messages: t.messages,
        orderId: t.orderId, refundAmount: t.refundAmount, refundStatus: refundStatus,
        refundEvidence: t.refundEvidence.map((e) => RefundEvidenceModel(
          id: e.id, submittedBy: e.submittedBy, description: e.description,
          attachmentUrls: e.attachmentUrls, submittedAt: e.submittedAt,
        )).toList(),
        createdAt: t.createdAt, updatedAt: DateTime.now(),
      );
    }
  }
}
