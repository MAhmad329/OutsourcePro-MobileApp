import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:outsourcepro/providers/team_provider.dart';
import 'package:provider/provider.dart';

import '../models/chat.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> _chats = [];
  List<Message> _Messages = [];

  List<Message> get Messages => _Messages;
  List<Chat> get chats => _chats;
  String _ipAddress = '';
  String _cookie = '';
  void updateDependencies(String ipAddress, String cookie) {
    _ipAddress = ipAddress;
    _cookie = cookie;
  }

  void updateLastMessage(String chatId, Message message) {
    int chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex].messages!.add(message);
      notifyListeners();
    }
  }

  Future<void> sendMessage(String type, String receiverId, String teamId,
      String content, String senderId,
      {String? fileUrl, String? fileType}) async {
    try {
      var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
      var request = http.Request(
          'POST', Uri.parse('http://$_ipAddress:3000/api/v1/Chat/sendMessage'));
      if (type == 'individual') {
        request.body = json.encode({
          "type": type,
          "receiverId": receiverId,
          "senderId": senderId,
          "content": content,
          "fileUrl": fileUrl, // Add fileUrl
          "fileType": fileType, // Add fileType
        });
      } else if (type == 'team') {
        request.body = json.encode({
          "type": type,
          "team": teamId,
          "content": content,
          "senderId": senderId,
          "fileUrl": fileUrl, // Add fileUrl
          "fileType": fileType, // Add fileType
        });
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Message sentMessage = Message(
          senderId: senderId,
          content: content,
          fileUrl: fileUrl, // Add fileUrl
          fileType: fileType, // Add fileType
        );
        _Messages.add(sentMessage);
        notifyListeners();
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> markMessageAsRead(String chatId) async {
    var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
    var request = http.Request('POST',
        Uri.parse('http://$_ipAddress:3000/api/v1/Chat/markMessagesAsRead'));
    request.body = json.encode({"chatId": chatId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Update local chat data if needed
      int chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
      if (chatIndex != -1) {
        for (var message in _chats[chatIndex].messages!) {
          message.isRead = true;
        }
        notifyListeners();
      }
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> getChatMessages(String type, String senderId, String receiverId,
      String teamId, BuildContext context) async {
    _Messages.clear();
    try {
      var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
      var request = http.Request('POST',
          Uri.parse('http://$_ipAddress:3000/api/v1/Chat/getChatMessages'));

      if (type == 'individual') {
        request.body = json.encode({
          "senderId": senderId,
          "receiverId": receiverId,
        });
      } else if (type == 'team') {
        request.body = json.encode({
          "teamId": teamId,
        });
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        List<dynamic> messagesData = jsonResponse['messages'];
        _Messages.clear();
        print(_Messages);

        Map<String, String> usernames =
            Provider.of<TeamProvider>(context, listen: false)
                .teamMemberUsernames;

        _Messages = messagesData.map((messageData) {
          Message message = Message.fromJson(messageData);
          message.username = usernames[message.senderId] ?? '';
          return message;
        }).toList();
        print(_Messages);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String?> uploadFile(File file) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://$_ipAddress:3000/api/v1/uploadFile'),
      );
      request.files.add(await http.MultipartFile.fromPath('filename', file.path));
      request.headers.addAll({'Cookie': _cookie});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var data = json.decode(responseData.body);
        return data['url'];
      } else {
        var responseData = await http.Response.fromStream(response);
        print('File upload failed: ${responseData.body}');
        return null;
      }
    } catch (e) {
      print('File upload error: $e');
      return null;
    }
  }

  Future<void> getFreelancerChats(String freelancerId) async {
    try {
      var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/Chat/$freelancerId/getFreelancerChats'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        List<dynamic> chatsData = jsonResponse['chats'];
        _chats = chatsData.map((chatData) => Chat.fromJson(chatData)).toList();
        notifyListeners();
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void reset() {
    _chats.clear();
    _Messages.clear();
    notifyListeners();
  }
}
