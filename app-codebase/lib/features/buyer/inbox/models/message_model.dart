class MessageModel {
  final String id;
  final String chatId;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final String type; // 'text' | 'image' | 'video'
  final String? mediaPath;
  final bool isEdited;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.type = 'text',
    this.mediaPath,
    this.isEdited = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['id'],
    chatId: json['chatId'],
    text: json['text'],
    timestamp: DateTime.parse(json['timestamp']),
    isMe: json['isMe'],
    type: json['type'] ?? 'text',
    mediaPath: json['mediaPath'],
    isEdited: json['isEdited'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'chatId': chatId,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
    'isMe': isMe,
    'type': type,
    'mediaPath': mediaPath,
    'isEdited': isEdited,
  };

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? text,
    DateTime? timestamp,
    bool? isMe,
    String? type,
    String? mediaPath,
    bool? isEdited,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
      type: type ?? this.type,
      mediaPath: mediaPath ?? this.mediaPath,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}

