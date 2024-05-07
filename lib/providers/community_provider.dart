import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/post.dart';

class CommunityProvider extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get posts => _posts;

  String _ipAddress = '';
  String _cookie = '';

  void updateDependencies(String ipAddress, String cookie) {
    _ipAddress = ipAddress;
    _cookie = cookie;
    getAllPosts();
  }

  Future<void> getAllPosts() async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
    try {
      var headers = {'Cookie': _cookie};
      var request = http.Request('GET',
          Uri.parse('http://$_ipAddress:3000/api/v1/community/getPosts'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final responseData = json.decode(responseBody);
        List<dynamic> postJson = responseData['posts'];
        _posts = postJson.map((data) => Post.fromJson(data)).toList();
        notifyListeners();
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> commentOnPost(String postId, String comment) async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': _cookie,
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/community/$postId/addComment'));
      request.body = json.encode({
        "content": comment,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        await getAllPosts(); // Refresh the list of posts
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likePost(String postId, String userId) async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
    try {
      var headers = {'Cookie': _cookie};
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/community/$postId/likePost'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final post = _posts.firstWhere((p) => p.id == postId);
        post.likes.add(Like(
            user: Author(id: userId, name: "", email: "", type: ""),
            userType: ""));
        notifyListeners();
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> unlikePost(String postId, String userId) async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
    try {
      var headers = {'Cookie': _cookie};
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/community/$postId/unlikePost'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final post = _posts.firstWhere((p) => p.id == postId);
        post.likes.removeWhere((like) => like.user.id == userId);
        notifyListeners();
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
    try {
      var headers = {'Cookie': _cookie};
      var request = http.Request(
          'DELETE',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/community/$postId/comments/$commentId/delete'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        await getAllPosts(); // Refresh the list of posts
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }
    try {
      var headers = {'Cookie': _cookie};
      var request = http.Request(
          'DELETE',
          Uri.parse(
              'http://$_ipAddress:3000/api/v1/community/$postId/deletePost'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        await getAllPosts();
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void toggleLikeStatus(Post post, String userId) {
    if (post.isLikedBy(userId)) {
      unlikePost(post.id, userId);
    } else {
      likePost(post.id, userId);
    }
  }
}
