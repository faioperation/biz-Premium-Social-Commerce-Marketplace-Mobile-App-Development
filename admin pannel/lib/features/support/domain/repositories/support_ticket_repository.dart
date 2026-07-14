import '../entities/support_ticket_entity.dart';

abstract class SupportTicketRepository {
  Future<List<SupportTicketEntity>> getTickets({
    int page = 1,
    int limit = 15,
    String? statusFilter,
    String? categoryFilter,
    String? searchQuery,
  });

  Future<int> getTotalCount({String? statusFilter});

  Future<SupportTicketEntity> getTicketDetails(String id);

  Future<void> replyToTicket(String ticketId, String message, List<String> attachments);

  Future<void> resolveTicket(String ticketId);

  Future<void> escalateTicket(String ticketId);

  Future<void> closeTicket(String ticketId);

  Future<void> assignTicket(String ticketId, String adminId, String adminName);

  Future<void> approveRefund(String ticketId);

  Future<void> rejectRefund(String ticketId, String reason);
}
