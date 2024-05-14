import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/post.dart';

class CommunityProvider extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get posts => _posts;

  String _ipAddress = '';
  String _cookie = '';

  void updateDependencies(String ipAddress, String cookie) {
    _ipAddress = ipAddress;
    _cookie = cookie;
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

  Future<List<String>> uploadImages(List<XFile> images) async {
    List<String> uploadedUrls = [];
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return uploadedUrls;
    }

    for (var image in images) {
      var headers = {'Cookie': _cookie};
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://$_ipAddress:3000/api/v1/uploadFile'));
      request.files
          .add(await http.MultipartFile.fromPath('filename', image.path));
      request.headers.addAll(headers);

      try {
        var response = await request.send();

        if (response.statusCode == 200) {
          String responseBody = await response.stream.bytesToString();
          var jsonResponse = json.decode(responseBody);
          uploadedUrls.add(jsonResponse['url']);
          print("Image uploaded: ${jsonResponse['url']}");
        } else {
          String responseBody = await response.stream.bytesToString();
          print(
              "Failed to upload image: ${response.reasonPhrase}, Body: $responseBody");
        }
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    return uploadedUrls;
  }

  Future<void> createPost(String content, List<XFile> images) async {
    if (_ipAddress.isEmpty || _cookie.isEmpty) {
      return;
    }

    List<String> imageUrls = await uploadImages(images);
    var headers = {'Content-Type': 'application/json', 'Cookie': _cookie};
    var request = http.Request('POST',
        Uri.parse('http://$_ipAddress:3000/api/v1/community/createPost'));
    request.body = json
        .encode({"content": content != '' ? content : '', "media": imageUrls});
    request.headers.addAll(headers);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Post created successfully.");
      await getAllPosts(); // Refresh the list of posts
    } else {
      print("Failed to create post: ${response.reasonPhrase}");
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

  void reset() {
    _posts.clear();
    notifyListeners();
  }
}
