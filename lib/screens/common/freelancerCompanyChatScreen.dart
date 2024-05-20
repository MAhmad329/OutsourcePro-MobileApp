import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/providers/freelancerCompanyChatProvider.dart';
import 'package:outsourcepro/providers/token_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../models/freelancerCompanyChat.dart';
import '../../services/socket_service.dart';
import '../common/calling/1on1_call.dart';

class FreelancerCompanyChatScreen extends StatefulWidget {
  final String userId;
  final String userType;
  final String receiverId;
  final String username;
  final String? chatId;

  const FreelancerCompanyChatScreen({
    super.key,
    required this.userId,
    required this.userType,
    required this.receiverId,
    required this.username,
    this.chatId,
  });

  @override
  State<FreelancerCompanyChatScreen> createState() =>
      _FreelancerCompanyChatScreenState();
}

class _FreelancerCompanyChatScreenState
    extends State<FreelancerCompanyChatScreen> {
  final SocketService socketService = SocketService();
  final TextEditingController _messageController = TextEditingController();
  List<FreelancerCompanyMessage> _messages = [];
  bool _isActive = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _fetchAndSetMessages();
    _setupSocketListeners();
    _isActive = true;
  }

  @override
  void dispose() {
    socketService.disconnect();
    _isActive = false;
    super.dispose();
  }

  Future<void> _fetchAndSetMessages() async {
    setState(() {
      _isLoading = true;
    });

    String senderModel =
        widget.userType == 'freelancer' ? 'Freelancer' : 'Company';
    String receiverModel =
        senderModel == 'Freelancer' ? 'Company' : 'Freelancer';

    await Provider.of<FreelancerCompanyChatProvider>(context, listen: false)
        .getChatMessages(
            widget.userId, widget.receiverId, senderModel, receiverModel);

    if (mounted) {
      setState(() {
        _messages.clear();
        _messages =
            Provider.of<FreelancerCompanyChatProvider>(context, listen: false)
                .messages;
        _messages = List.from(_messages.reversed);
        _isLoading = false;
      });
    }
    if (widget.chatId != null) {
      Provider.of<FreelancerCompanyChatProvider>(context, listen: false)
          .markMessageAsRead(widget.chatId!);
    }
  }

  Future<void> _setupSocketListeners() async {
    String ipAddress =
        Provider.of<TokenProvider>(context, listen: false).ipaddress;
    socketService.connect(widget.userId, ipAddress);
    socketService.socket!.on('individual chat message', (data) {
      FreelancerCompanyMessage message =
          FreelancerCompanyMessage.fromJson(data);
      print("Message senderId: ${message.senderId}");
      print("My userId: ${widget.userId}");
      if (message.senderId != widget.userId) {
        if (mounted) {
          setState(() {
            _messages.insert(0, message);
          });
          if (_isActive) {
            Provider.of<FreelancerCompanyChatProvider>(context, listen: false)
                .markMessageAsRead(widget.chatId!);
          }
        }
      }
      Provider.of<FreelancerCompanyChatProvider>(context, listen: false)
          .updateLastMessage(widget.chatId!, message);
    });
  }

  Future<void> _sendMessage({String? fileUrl, String? fileType}) async {
    if (_messageController.text.isNotEmpty || fileUrl != null) {
      String content = _messageController.text;

      String senderModel =
          widget.userType == 'freelancer' ? 'Freelancer' : 'Company';
      String receiverModel =
          senderModel == 'Freelancer' ? 'Company' : 'Freelancer';

      await Provider.of<FreelancerCompanyChatProvider>(context, listen: false)
          .sendMessage(widget.receiverId, content, widget.userId, senderModel,
              receiverModel,
              fileUrl: fileUrl, fileType: fileType);

      socketService.sendIndividualMessage(
          widget.userId, widget.receiverId, content,
          fileUrl: fileUrl, fileType: fileType);
      FreelancerCompanyMessage newMessage = FreelancerCompanyMessage(
          senderId: widget.userId,
          content: content,
          fileUrl: fileUrl,
          fileType: fileType,
          timestamp: DateTime.now(),
          isRead: false);
      setState(() {
        _messages.insert(0, newMessage);
      });
      _messageController.clear();
      Provider.of<FreelancerCompanyChatProvider>(context, listen: false)
          .updateLastMessage(widget.chatId ?? '', newMessage);
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
        String? fileUrl = await Provider.of<FreelancerCompanyChatProvider>(
                context,
                listen: false)
            .uploadFile(file);

        if (fileUrl != null) {
          _sendMessage(fileUrl: fileUrl, fileType: extension);
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.username),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OneOnOneCall(
                    receiverId: widget.receiverId,
                    userName: widget.username,
                  ),
                ),
              );
            },
            child: const Text(
              'Call',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      bool isMe = _messages[index].senderId == widget.userId;
                      print(
                          "Message senderId: ${_messages[index].senderId}, myUserId: ${widget.userId}, isMe: $isMe");
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                          isMe ? 64.0.w : 16.0.w,
                          11.h,
                          isMe ? 16.0.w : 64.0.w,
                          11.h,
                        ),
                        child: Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (_messages[index].fileUrl != null)
                                        _messages[index].fileType == 'pdf' ||
                                                _messages[index].fileType ==
                                                    'docx'
                                            ? InkWell(
                                                onTap: () async {
                                                  final url =
                                                      _messages[index].fileUrl!;
                                                  final fileName =
                                                      'downloaded_file.${_messages[index].fileType}';
                                                  final file =
                                                      await downloadFile(
                                                          url, fileName);
                                                  if (file != null) {
                                                    OpenFile.open(file.path);
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Error opening file.')),
                                                    );
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(_messages[index]
                                                                .fileType ==
                                                            'pdf'
                                                        ? Icons.picture_as_pdf
                                                        : Icons
                                                            .insert_drive_file),
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
                                                          _messages[index]
                                                              .fileUrl!,
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
                                              color: isMe
                                                  ? Colors.white
                                                  : Colors.black,
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
                                  style: kText2.copyWith(fontSize: 8.sp),
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
                        onPressed: () => _sendMessage(),
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
