import '../../domain/entities/ticket_message_entity.dart';

class TicketMessageModel extends TicketMessageEntity {
  const TicketMessageModel({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.isAdmin,
    required super.message,
    required super.attachmentUrls,
    required super.createdAt,
  });

  factory TicketMessageModel.fromJson(Map<String, dynamic> json) {
    return TicketMessageModel(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      message: json['message'] ?? '',
      attachmentUrls: List<String>.from(json['attachmentUrls'] ?? []),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'senderName': senderName,
    'isAdmin': isAdmin,
    'message': message,
    'attachmentUrls': attachmentUrls,
    'createdAt': createdAt.toIso8601String(),
  };
}
