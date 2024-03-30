import 'package:outsourcepro/models/freelancer.dart';

class Chat {
  String? id;
  String? type;
  List<FreelancerProfile>? participants;
  String? team;
  List<Message>? messages;

  Chat({
    this.id,
    this.type,
    this.participants,
    this.team,
    this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'],
      type: json['type'],
      participants: json['participants'] != null
          ? (json['participants'] as List)
              .map((e) => FreelancerProfile.fromJson(e))
              .toList()
          : [],
      team: json['team'],
      messages: json['messages'] != null
          ? (json['messages'] as List).map((e) => Message.fromJson(e)).toList()
          : [],
    );
  }
}

class Message {
  String? senderId;
  String? content;
  DateTime? timestamp;

  bool? isRead;

  Message({
    this.senderId,
    this.content,
    this.timestamp,
    this.isRead,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId:
          json['sender'] as String?, // Cast to String? to allow null values
      content:
          json['content'] as String?, // Cast to String? to allow null values
      timestamp:
          json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      isRead: json['isRead'] ?? false,
    );
  }

  String timeAgo() {
    if (timestamp == null) {
      return 'Unknown';
    }
    final now = DateTime.now();
    final difference = now.difference(timestamp!);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }
}
