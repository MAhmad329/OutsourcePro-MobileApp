import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Providers/freelance_profile_provider.dart';
import '../../constants.dart';
import '../../models/chat.dart';
import '../../providers/chat_provider.dart';
import '../../providers/token_provider.dart';
import '../../services/socket_service.dart';

class TeamChatScreen extends StatefulWidget {
  final String teamId;
  const TeamChatScreen({super.key, required this.teamId});

  @override
  State<TeamChatScreen> createState() => _TeamChatScreenState();
}

class _TeamChatScreenState extends State<TeamChatScreen> {
  final SocketService socketService = SocketService();
  final TextEditingController _messageController = TextEditingController();
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _joinTeamChat();
    _setupSocketListeners();
    _fetchAndSetMessages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchAndSetMessages() async {
    String userId =
        Provider.of<FreelancerProfileProvider>(context, listen: false)
            .profile
            .id;
    await Provider.of<ChatProvider>(context, listen: false)
        .getChatMessages('team', '', '', widget.teamId, context);
    if (mounted) {
      setState(() {
        _messages.clear();
        _messages = Provider.of<ChatProvider>(context, listen: false).Messages;
        _messages = List.from(_messages.reversed);
      });
    }
  }

  void _joinTeamChat() {
    String userId =
        Provider.of<FreelancerProfileProvider>(context, listen: false)
            .profile
            .id;
    String ipAddress =
        Provider.of<TokenProvider>(context, listen: false).ipaddress;
    socketService.connect(userId, ipAddress);
    socketService.joinTeamChat(widget.teamId);
  }

  void _setupSocketListeners() {
    String userId =
        Provider.of<FreelancerProfileProvider>(context, listen: false)
            .profile
            .id;
    socketService.socket!.on('team chat message', (data) {
      Message message = Message.fromJson(data);
      print('content is: ${message.content}');
      if (message.senderId != userId) {
        print(message.senderId);
        print(userId);
        if (mounted) {
          setState(() {
            _messages.insert(0, message);
          });
        }
      }
    });
  }

  void _sendTeamMessage() {
    if (_messageController.text.isNotEmpty) {
      final sender =
          Provider.of<FreelancerProfileProvider>(context, listen: false)
              .profile;
      String content = _messageController.text;
      Provider.of<ChatProvider>(context, listen: false)
          .sendMessage('team', '', widget.teamId, content, sender.id);
      socketService.sendTeamMessage(
          widget.teamId, sender.id, content, sender.username);
      Message newMessage = Message(
          senderId: sender.id,
          content: content,
          timestamp: DateTime.now(),
          isRead: false);
      setState(() {
        _messages.insert(0, newMessage);
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    String myUserId =
        Provider.of<FreelancerProfileProvider>(context, listen: false)
            .profile
            .id;
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Chat'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isMe = _messages[index].senderId == myUserId;
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    isMe ? 64.0.w : 16.0.w,
                    11.h,
                    isMe ? 16.0.w : 64.0.w,
                    11.h,
                  ),
                  child: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: isMe ? primaryColor : Colors.grey[200],
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.h, horizontal: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isMe)
                                  Text(
                                    _messages[index].username ?? 'Unknown User',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isMe ? Colors.white : Colors.black,
                                    ),
                                  ),
                                Text(
                                  _messages[index].content ?? '',
                                  style: kText2.copyWith(
                                      color: isMe ? Colors.white : Colors.black,
                                      fontSize: 16.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: Text(
                            _messages[index].timeAgo(),
                            style: kText2.copyWith(fontSize: 10.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: 14.sp),
                    controller: _messageController,
                    decoration: kTextFieldDecoration.copyWith(
                        hintStyle: TextStyle(fontSize: 14.sp),
                        hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  onPressed: _sendTeamMessage,
                  icon: Icon(
                    Icons.send,
                    color: Colors.grey,
                    size: 24.r,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
