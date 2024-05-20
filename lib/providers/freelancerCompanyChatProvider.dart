import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/freelancerCompanyChat.dart';

class FreelancerCompanyChatProvider extends ChangeNotifier {
  List<FreelancerCompanyChat> _chats = [];
  List<FreelancerCompanyMessage> _messages = [];

  List<FreelancerCompanyMessage> get messages => _messages;
  List<FreelancerCompanyChat> get chats => _chats;
  String _ipAddress = '';
  String _cookie = '';

  void updateDependencies(String ipAddress, String cookie) {
    _ipAddress = ipAddress;
    _cookie = cookie;
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

  void updateLastMessage(String chatId, FreelancerCompanyMessage message) {
    int chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex].messages!.add(message);
      notifyListeners();
    }
  }

  Future<String?> uploadFile(File file) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://$_ipAddress:3000/api/v1/uploadFile'),
      );
      request.files
          .add(await http.MultipartFile.fromPath('filename', file.path));
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

  Future<void> sendMessage(String receiverId, String content, String senderId,
      String senderModel, String receiverModel,
      {String? fileUrl, String? fileType}) async {
    try {
      var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/chat/sendMessageFreelancerCompany'));
      request.body = json.encode({
        "receiverId": receiverId,
        "senderId": senderId,
        "content": content,
        "fileUrl": fileUrl,
        "fileType": fileType,
        "senderModel": senderModel,
        "receiverModel": receiverModel
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        FreelancerCompanyMessage sentMessage = FreelancerCompanyMessage(
          senderId: senderId,
          content: content,
          fileUrl: fileUrl,
          fileType: fileType,
        );
        _messages.add(sentMessage);
        notifyListeners();
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getChatMessages(String senderId, String receiverId,
      String senderModel, String receiverModel) async {
    _messages.clear();
    try {
      var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/chat/getChatMessagesFreelancerCompany'));
      request.body = json.encode({
        "senderId": senderId,
        "receiverId": receiverId,
        "senderModel": senderModel,
        "receiverModel": receiverModel
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        List<dynamic> messagesData = jsonResponse['messages'];
        _messages = messagesData
            .map(
                (messageData) => FreelancerCompanyMessage.fromJson(messageData))
            .toList();
        notifyListeners();
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getFreelancerCompanyChats(String userId, String userType) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': _cookie,
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/chat/$userId/getFreelancerCompanyChats'));
      request.body = json.encode({"userType": userType});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        List<dynamic> chatsData = jsonResponse['chats'];
        _chats = chatsData
            .map((chatData) => FreelancerCompanyChat.fromJson(chatData))
            .toList();
        notifyListeners();
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
