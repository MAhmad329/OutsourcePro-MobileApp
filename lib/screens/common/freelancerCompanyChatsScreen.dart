import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/freelancerCompanyChat.dart';
import '../../providers/freelancerCompanyChatProvider.dart';
import '../common/freelancerCompanyChatScreen.dart';

class FreelancerCompanyChatsScreen extends StatefulWidget {
  final String userId;
  final String userType;

  const FreelancerCompanyChatsScreen({
    super.key,
    required this.userId,
    required this.userType,
  });

  @override
  _FreelancerCompanyChatsScreenState createState() =>
      _FreelancerCompanyChatsScreenState();
}

class _FreelancerCompanyChatsScreenState
    extends State<FreelancerCompanyChatsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    await Provider.of<FreelancerCompanyChatProvider>(context, listen: false)
        .getFreelancerCompanyChats(widget.userId, widget.userType);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<FreelancerCompanyChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0.r),
                child: chatProvider.chats.isEmpty
                    ? const Center(
                        child: Text('You currently don\'t have chats!'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: chatProvider.chats.length,
                        itemBuilder: (context, index) {
                          List<FreelancerCompanyChat> chats =
                              chatProvider.chats;
                          // Sort chats by the timestamp of the last message
                          chats.sort((a, b) {
                            DateTime? lastMessageTimeA =
                                a.messages?.last.timestamp;
                            DateTime? lastMessageTimeB =
                                b.messages?.last.timestamp;
                            if (lastMessageTimeA == null &&
                                lastMessageTimeB == null) {
                              return 0;
                            } else if (lastMessageTimeA == null) {
                              return 1;
                            } else if (lastMessageTimeB == null) {
                              return -1;
                            } else {
                              return lastMessageTimeB
                                  .compareTo(lastMessageTimeA);
                            }
                          });

                          FreelancerCompanyChat chat = chats[index];
                          Participant otherParticipant = chat.participants!
                              .firstWhere(
                                  (participant) =>
                                      participant.id != widget.userId,
                                  orElse: () => chat.participants![0]);

                          FreelancerCompanyMessage? lastMessage =
                              chat.messages!.isNotEmpty
                                  ? chat.messages?.last
                                  : null;

                          bool isUnread = lastMessage?.isRead == false &&
                              lastMessage?.senderId != widget.userId;

                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FreelancerCompanyChatScreen(
                                        userId: widget.userId,
                                        userType: widget.userType,
                                        receiverId: otherParticipant.id ?? '',
                                        username:
                                            otherParticipant.name ?? 'Chat',
                                        chatId: chat.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20.r,
                                          backgroundImage: NetworkImage(
                                              otherParticipant.profilePicture ??
                                                  ''),
                                        ),
                                        SizedBox(width: 15.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              otherParticipant.name ?? 'Chat',
                                              style: TextStyle(fontSize: 16.sp),
                                            ),
                                            SizedBox(height: 1.h),
                                            SizedBox(
                                              width: 180.w,
                                              child: Text(
                                                lastMessage?.content ??
                                                    'No messages',
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 12.sp,
                                                  fontWeight: isUnread
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                ),
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
                      ),
              ),
            ),
    );
  }
}
