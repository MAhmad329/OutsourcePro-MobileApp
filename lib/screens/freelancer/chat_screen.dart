import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/providers/chat_provider.dart';
import 'package:outsourcepro/providers/token_provider.dart';
import 'package:provider/provider.dart';

import '../../models/chat.dart';
import '../../services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String username;
  final String? chatId;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.username,
    this.chatId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SocketService socketService = SocketService();
  final TextEditingController _messageController = TextEditingController();
  List<Message> _messages = [];
  bool _isActive = false; // Track if the chat screen is active

  @override
  void initState() {
    super.initState();
    _fetchAndSetMessages();
    _setupSocketListeners();
    _isActive = true; // Set to true when the screen is active
  }

  @override
  void dispose() {
    socketService.disconnect();
    _isActive = false;
    super.dispose();
  }

  void _fetchAndSetMessages() async {
    String userId =
        Provider.of<FreelancerProfileProvider>(context, listen: false)
            .profile
            .id;
    await Provider.of<ChatProvider>(context, listen: false)
        .getChatMessages('individual', userId, widget.receiverId, '');
    if (mounted) {
      setState(() {
        _messages.clear();
        _messages = Provider.of<ChatProvider>(context, listen: false).Messages;
        _messages = List.from(_messages.reversed);
      });
    }
    if (widget.chatId != null) {
      Provider.of<ChatProvider>(context, listen: false)
          .markMessageAsRead(widget.chatId!);
    }
  }

  void _setupSocketListeners() {
    String userId =
        Provider.of<FreelancerProfileProvider>(context, listen: false)
            .profile
            .id;
    String ipAddress =
        Provider.of<TokenProvider>(context, listen: false).ipaddress;
    socketService.connect(userId, ipAddress);
    socketService.socket!.on('individual chat message', (data) {
      Message message = Message.fromJson(data);
      if (message.senderId != userId) {
        if (mounted) {
          setState(() {
            _messages.insert(0, message);
          });
          if (_isActive) {
            // Mark the message as read only if the chat screen is active
            Provider.of<ChatProvider>(context, listen: false)
                .markMessageAsRead(widget.chatId!);
          }
        }
      }
      Provider.of<ChatProvider>(context, listen: false)
          .updateLastMessage(widget.chatId!, message);
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      String senderId =
          Provider.of<FreelancerProfileProvider>(context, listen: false)
              .profile
              .id;
      String content = _messageController.text;
      Provider.of<ChatProvider>(context, listen: false)
          .sendMessage('individual', widget.receiverId, '', content, senderId);
      socketService.sendIndividualMessage(senderId, widget.receiverId, content);
      Message newMessage = Message(
          senderId: senderId,
          content: content,
          timestamp: DateTime.now(),
          isRead: false);
      setState(() {
        _messages.insert(0, newMessage);
      });
      _messageController.clear();
      Provider.of<ChatProvider>(context, listen: false)
          .updateLastMessage(widget.chatId!, newMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    String myUserId =
        Provider.of<FreelancerProfileProvider>(context, listen: false)
            .profile
            .id;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.username),
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
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(8.0.r),
                    margin: EdgeInsets.symmetric(
                        vertical: 4.0.h, horizontal: 8.0.w),
                    decoration: BoxDecoration(
                      color: isMe ? primaryColor : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _messages[index].content ?? '',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: isMe ? Colors.white : Colors.black),
                        ),
                        Text(
                          _messages[index].timeAgo(),
                          style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                              fontSize: 10.sp),
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
                  onPressed: _sendMessage,
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
