class Author {
  final String id;
  final String name;
  final String email;
  final String type; // "Freelancer" or "Company"
  final String? profilePicture;

  Author({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    this.profilePicture,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    // Determine the author type based on the presence of specific keys
    final type = json.containsKey('companyname') ? 'Company' : 'Freelancer';
    if (type == 'Freelancer') {
      return Freelancer.fromJson(json);
    } else if (type == 'Company') {
      return Company.fromJson(json);
    } else {
      throw ArgumentError("Unknown author type: $type in $json");
    }
  }
}

class Comment {
  final String id;
  final Author commenter;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.commenter,
    required this.content,
    required this.timestamp,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      commenter: Author.fromJson(json['commenter'] as Map<String, dynamic>),
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class Like {
  final Author user;
  final String userType;

  Like({
    required this.user,
    required this.userType,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      user: Author.fromJson(json['user'] as Map<String, dynamic>),
      userType: json['userType'],
    );
  }
}

class Post {
  final String id;
  final Author author;
  final String content;
  final DateTime timestamp;
  final List<String> media;
  List<Like> likes;
  List<Comment> comments;

  Post({
    required this.id,
    required this.author,
    required this.content,
    required this.timestamp,
    this.media = const [],
    this.likes = const [],
    this.comments = const [],
  });

  int get likesCount => likes.length;

  bool isLikedBy(String userId) => likes.any((like) => like.user.id == userId);

  factory Post.fromJson(Map<String, dynamic> json) {
    var likesJson = json['likes'] as List;
    var commentsJson = json['comments'] as List;
    return Post(
      id: json['_id'],
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      media: List<String>.from(json['media'] ?? []),
      likes: likesJson.map((like) => Like.fromJson(like)).toList(),
      comments:
          commentsJson.map((comment) => Comment.fromJson(comment)).toList(),
    );
  }
}

class Freelancer extends Author {
  final List<String> skills;

  Freelancer({
    required String id,
    required String username,
    required String email,
    String? profilePicture,
    this.skills = const [],
  }) : super(
          id: id,
          name: username,
          email: email,
          type: 'Freelancer',
          profilePicture: profilePicture,
        );

  factory Freelancer.fromJson(Map<String, dynamic> json) {
    return Freelancer(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      profilePicture: json['pfp'],
      skills: List<String>.from(json['skills']),
    );
  }
}

class Company extends Author {
  final String? companyName;
  final String? businessAddress;

  Company({
    required String id,
    required String name,
    required String email,
    String? profilePicture,
    this.companyName,
    this.businessAddress,
  }) : super(
          id: id,
          name: name,
          email: email,
          type: 'Company',
          profilePicture: profilePicture,
        );

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'],
      name: json['companyName'] ?? json['name'],
      email: json['email'],
      profilePicture: json['pfp'],
      companyName: json['companyName'],
      businessAddress: json['businessAddress'],
    );
  }
}
