/// A model representing a chat message in the live stream.
class LiveCommentModel {
  final String id;
  final String userName;
  final String message;
  final DateTime timestamp;
  final List<LiveCommentModel> replies;
  final bool isLiked;
  final int likeCount;
  final String? parentId;

  const LiveCommentModel({
    required this.id,
    required this.userName,
    required this.message,
    required this.timestamp,
    this.replies = const [],
    this.isLiked = false,
    this.likeCount = 0,
    this.parentId,
  });

  LiveCommentModel copyWith({
    String? id,
    String? userName,
    String? message,
    DateTime? timestamp,
    List<LiveCommentModel>? replies,
    bool? isLiked,
    int? likeCount,
    String? parentId,
  }) {
    return LiveCommentModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      replies: replies ?? this.replies,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      parentId: parentId ?? this.parentId,
    );
  }
}
