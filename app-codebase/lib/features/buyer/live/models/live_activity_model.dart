class LiveActivityModel {
  final String username;
  final String text;
  final bool isBid;

  LiveActivityModel({
    required this.username,
    required this.text,
    required this.isBid,
  });

  factory LiveActivityModel.fromJson(Map<String, dynamic> json) {
    return LiveActivityModel(
      username: json['username'] ?? '',
      text: json['text'] ?? '',
      isBid: json['isBid'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'text': text, 'isBid': isBid};
  }
}
