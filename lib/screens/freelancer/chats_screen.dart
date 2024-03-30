import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/screens/freelancer/chat_screen.dart';
import 'package:provider/provider.dart';

import '../../Providers/freelance_profile_provider.dart';
import '../../models/chat.dart';
import '../../models/freelancer.dart';
import '../../providers/chat_provider.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchChats();
    _startRefreshTimer();
  }

  void _fetchChats() {
    Provider.of<ChatProvider>(context, listen: false).getFreelancerChats(
        Provider.of<FreelancerProfileProvider>(context, listen: false)
            .profile
            .id);
  }

  void _startRefreshTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 2500), (timer) {
      _fetchChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.r),
          child: Consumer<ChatProvider>(
            builder: (_, provider, child) {
              // List<Chat> chats = provider.chats;
              // List<Chat> individualChats =
              //     chats.where((chat) => chat.type == 'individual').toList();
              List<Chat> chats = provider.chats;
              List<Chat> individualChats =
                  chats.where((chat) => chat.type == 'individual').toList();

              // Sort the individual chats based on the timestamp of the last message
              individualChats.sort((a, b) {
                DateTime? lastMessageTimeA = a.messages?.last.timestamp;
                DateTime? lastMessageTimeB = b.messages?.last.timestamp;
                if (lastMessageTimeA == null && lastMessageTimeB == null) {
                  return 0;
                } else if (lastMessageTimeA == null) {
                  return 1;
                } else if (lastMessageTimeB == null) {
                  return -1;
                } else {
                  return lastMessageTimeB.compareTo(lastMessageTimeA);
                }
              });
              return ListView.builder(
                shrinkWrap: true,
                itemCount: individualChats.length,
                itemBuilder: (context, index) {
                  Chat chat = individualChats[index];
                  print(chat);
                  FreelancerProfile? otherParticipant = chat.participants
                      ?.firstWhere((participant) =>
                          participant.id !=
                          Provider.of<FreelancerProfileProvider>(context,
                                  listen: false)
                              .profile
                              .id);
                  Message? lastMessage =
                      chat.messages!.isNotEmpty ? chat.messages?.last : null;
                  bool isLastMessageFromMe = lastMessage?.senderId ==
                      Provider.of<FreelancerProfileProvider>(context,
                              listen: false)
                          .profile
                          .id;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                receiverId: otherParticipant?.id ?? '',
                                username: otherParticipant?.username ?? 'User',
                                chatId: chat.id,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.r,
                                  backgroundImage:
                                      NetworkImage(otherParticipant?.pfp ?? ''),
                                ),
                                SizedBox(width: 15.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      otherParticipant?.username ?? 'User',
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                    SizedBox(height: 1.h),
                                    SizedBox(
                                      width: 180.w,
                                      child: Text(
                                        lastMessage?.content ?? 'No messages',
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 12.sp,
                                            fontWeight: !isLastMessageFromMe &&
                                                    !(lastMessage?.isRead ??
                                                        true)
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(lastMessage?.timeAgo() ?? ''),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
