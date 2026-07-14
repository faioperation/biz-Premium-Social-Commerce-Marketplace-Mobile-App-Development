class TicketMessageEntity {
  final String id;
  final String senderId;
  final String senderName;
  final bool isAdmin; // true = admin, false = user/customer
  final String message;
  final List<String> attachmentUrls;
  final DateTime createdAt;

  const TicketMessageEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.isAdmin,
    required this.message,
    required this.attachmentUrls,
    required this.createdAt,
  });
}
