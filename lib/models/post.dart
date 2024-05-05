class Comment {
  final String commenter;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.commenter,
    required this.content,
    required this.timestamp,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commenter: json['commenter'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class Post {
  final String id;
  final String author;
  final String content;
  final DateTime timestamp;
  int likes;
  List<Comment> comments;

  Post({
    required this.id,
    required this.author,
    required this.content,
    required this.timestamp,
    this.likes = 0,
    this.comments = const [],
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    var commentsJson = json['comments'] as List;
    List<Comment> commentsList =
        commentsJson.map((c) => Comment.fromJson(c)).toList();

    final author = json['author'] as Map<String, dynamic>;
    final authorName = "${author['firstname']} ${author['lastname']}";

    return Post(
      id: json['_id'],
      author: authorName,
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      likes: json['likes'].length,
      comments: commentsList,
    );
  }
}
