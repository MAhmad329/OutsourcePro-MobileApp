import 'package:intl/intl.dart';

class FreelancerCompanyChat {
  String? id;
  String? type;
  List<Participant>? participants;
  List<FreelancerCompanyMessage>? messages;

  FreelancerCompanyChat({
    this.id,
    this.type,
    this.participants,
    this.messages,
  });

  factory FreelancerCompanyChat.fromJson(Map<String, dynamic> json) {
    return FreelancerCompanyChat(
      id: json['_id'],
      type: json['type'],
      participants: (json['participants'] as List)
          .map((participant) => Participant.fromJson(participant))
          .toList(),
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((e) => FreelancerCompanyMessage.fromJson(e))
              .toList()
          : [],
    );
  }
}

class Participant {
  String? id;
  String? name;
  String? companyname;
  String? firstname;
  String? lastname;
  String? email;
  String?
      profilePicture; // Assuming both Company and Freelancer have profile pictures

  Participant({
    this.id,
    this.name,
    this.companyname,
    this.firstname,
    this.lastname,
    this.email,
    this.profilePicture,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'],
      name: json['name'] ?? json['companyname'] ?? json['firstname'],
      companyname: json['companyname'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      profilePicture:
          json['pfp'], // Assuming profile picture URL is stored in 'pfp'
    );
  }
}

class FreelancerCompanyMessage {
  String? senderId;
  String? content;
  String? fileUrl;
  String? fileType;
  DateTime? timestamp;
  bool? isRead;
  String? username;

  FreelancerCompanyMessage({
    this.senderId,
    this.content,
    this.fileUrl,
    this.fileType,
    this.timestamp,
    this.isRead,
    this.username,
  });

  factory FreelancerCompanyMessage.fromJson(Map<String, dynamic> json) {
    return FreelancerCompanyMessage(
      senderId: json['sender'] as String?,
      content: json['content'] as String?,
      fileUrl: json['fileUrl'] as String?,
      fileType: json['fileType'] as String?,
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
    return DateFormat('kk:mm').format(timestamp!);
  }
}
