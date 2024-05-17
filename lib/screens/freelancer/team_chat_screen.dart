import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/providers/chat_provider.dart';
import 'package:outsourcepro/providers/token_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../../models/chat.dart';
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
    socketService.disconnect();
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
      if (message.senderId != userId) {
        if (mounted) {
          setState(() {
            _messages.insert(0, message);
          });
        }
      }
    });
  }

  void _sendTeamMessage({String? fileUrl, String? fileType}) {
    if (_messageController.text.isNotEmpty || fileUrl != null) {
      final sender =
          Provider.of<FreelancerProfileProvider>(context, listen: false)
              .profile;
      String content = _messageController.text;

      Provider.of<ChatProvider>(context, listen: false).sendMessage(
          'team', '', widget.teamId, content, sender.id,
          fileUrl: fileUrl, fileType: fileType);
      socketService.sendTeamMessage(
          widget.teamId, sender.id, content, sender.username,
          fileUrl: fileUrl, fileType: fileType);

      Message newMessage = Message(
        senderId: sender.id,
        content: content,
        fileUrl: fileUrl,
        fileType: fileType,
        timestamp: DateTime.now(),
        isRead: false,
      );

      setState(() {
        _messages.insert(0, newMessage);
      });
      _messageController.clear();
    }
  }

  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String? extension = result.files.single.extension;

      if (extension != null &&
          ['pdf', 'docx', 'jpg', 'jpeg', 'png']
              .contains(extension.toLowerCase())) {
        String? fileUrl =
            await Provider.of<ChatProvider>(context, listen: false)
                .uploadFile(file);

        if (fileUrl != null) {
          _sendTeamMessage(fileUrl: fileUrl, fileType: extension);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Unsupported file format. Please upload a PDF, DOCX, JPG, JPEG, or PNG file.')),
        );
      }
    }
  }

  Future<File?> downloadFile(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(bytes);
        return file;
      }
    } catch (e) {
      print("Error downloading file: $e");
    }
    return null;
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
                                if (_messages[index].fileUrl != null)
                                  _messages[index].fileType == 'pdf' ||
                                          _messages[index].fileType == 'docx'
                                      ? InkWell(
                                          onTap: () async {
                                            final url =
                                                _messages[index].fileUrl!;
                                            final fileName =
                                                'downloaded_file.${_messages[index].fileType}';
                                            final file = await downloadFile(
                                                url, fileName);
                                            if (file != null) {
                                              OpenFile.open(file.path);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Error opening file.')),
                                              );
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Icon(_messages[index].fileType ==
                                                      'pdf'
                                                  ? Icons.picture_as_pdf
                                                  : Icons.insert_drive_file),
                                              SizedBox(width: 8.w),
                                              Text(
                                                _messages[index]
                                                    .fileType!
                                                    .toUpperCase(),
                                                style: kText2.copyWith(
                                                    color: isMe
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 16.sp),
                                              ),
                                            ],
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    InteractiveViewer(
                                                  child: Image.network(
                                                    _messages[index].fileUrl!,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Image.network(
                                              _messages[index].fileUrl!),
                                        ),
                                if (_messages[index].content != null &&
                                    _messages[index].content!.isNotEmpty)
                                  Text(
                                    _messages[index].content!,
                                    style: kText2.copyWith(
                                        color:
                                            isMe ? Colors.white : Colors.black,
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
                IconButton(
                  onPressed: _pickAndUploadFile,
                  icon: Icon(
                    Icons.attach_file,
                    color: Colors.grey,
                    size: 24.r,
                  ),
                ),
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
                  onPressed: () => _sendTeamMessage(),
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

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  FullScreenImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Viewer'),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
        ),
      ),
    );
  }
}
