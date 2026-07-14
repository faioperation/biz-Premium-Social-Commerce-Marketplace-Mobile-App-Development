class ChatModel {
  final String id;
  final String name;
  final String profileImage;
  String lastMessage;
  DateTime lastMessageTime;
  int unreadCount;

  ChatModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    id: json['id'],
    name: json['name'],
    profileImage: json['profileImage'],
    lastMessage: json['lastMessage'],
    lastMessageTime: DateTime.parse(json['lastMessageTime']),
    unreadCount: json['unreadCount'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'profileImage': profileImage,
    'lastMessage': lastMessage,
    'lastMessageTime': lastMessageTime.toIso8601String(),
    'unreadCount': unreadCount,
  };
}
