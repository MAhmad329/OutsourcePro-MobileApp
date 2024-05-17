import 'package:intl/intl.dart';
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
  String? fileUrl; // Add fileUrl
  String? fileType; // Add fileType
  DateTime? timestamp;
  bool? isRead;
  String? username;

  Message({
    this.senderId,
    this.content,
    this.fileUrl, // Add fileUrl
    this.fileType, // Add fileType
    this.timestamp,
    this.isRead,
    this.username,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId:
          json['sender'] as String?, // Cast to String? to allow null values
      content:
          json['content'] as String?, // Cast to String? to allow null values
      fileUrl: json['fileUrl'] as String?, // Add fileUrl
      fileType: json['fileType'] as String?, // Add fileType
      timestamp:
          json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      isRead: json['isRead'] ?? false,
      username: json['senderUsername'] ?? '',
    );
  }

  String timeAgo() {
    if (timestamp == null) {
      return 'Unknown';
    }
    // Format the timestamp to only include the time
    return DateFormat('kk:mm').format(timestamp!);
  }
}
