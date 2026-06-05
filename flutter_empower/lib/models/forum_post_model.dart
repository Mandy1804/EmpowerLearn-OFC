class ForumPostModel {
  final String authorName;
  final String authorInitials;
  final String authorRole;
  final String course;
  final String timeAgo;
  final String content;
  final int likes;
  final int comments;
  final bool isPinned;
  final int avatarColorIndex;

  const ForumPostModel({
    required this.authorName,
    required this.authorInitials,
    required this.authorRole,
    required this.course,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    this.isPinned = false,
    this.avatarColorIndex = 0,
  });
}