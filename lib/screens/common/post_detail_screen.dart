import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../Providers/freelance_profile_provider.dart';
import '../../constants.dart';
import '../../models/post.dart';
import '../../providers/community_provider.dart';

class PostDetailsScreen extends StatefulWidget {
  final Post post;

  const PostDetailsScreen({Key? key, required this.post}) : super(key: key);

  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late CommunityProvider _communityProvider;
  int _currentIndex = 0;

  late bool _isLiked;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _communityProvider = Provider.of<CommunityProvider>(context, listen: false);
    _currentUserId =
        Provider.of<FreelancerProfileProvider>(context, listen: false)
            .profile
            .id;
    _isLiked = widget.post.isLikedBy(_currentUserId);
  }

  Widget _buildMediaSection(List<String> media) {
    return Column(
      children: [
        SizedBox(
          height: 300.0.h,
          child: PageView.builder(
            itemCount: media.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(media[index]);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(media.length, (index) {
            return Container(
              width: 8.0.w,
              height: 8.0.h,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blueAccent : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  void _toggleLikeStatus() {
    setState(() {
      if (_isLiked) {
        _communityProvider.unlikePost(widget.post.id, _currentUserId);
      } else {
        _communityProvider.likePost(widget.post.id, _currentUserId);
      }
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CommunityProvider>(
              builder: (context, provider, child) {
                final updatedPost = provider.posts
                    .firstWhere((post) => post.id == widget.post.id);

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  child: updatedPost
                                          .author.profilePicture!.isNotEmpty
                                      ? ClipOval(
                                          child: Image.network(
                                            updatedPost.author.profilePicture!,
                                            fit: BoxFit.cover,
                                            width: 40.0.w,
                                            height: 40.0.h,
                                          ),
                                        )
                                      : Text(updatedPost.author.name[0]),
                                ),
                                SizedBox(width: 15.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      updatedPost.author.name,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      timeago.format(updatedPost.timestamp),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (widget.post.author.id == _currentUserId)
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  _showPostBottomSheet(widget.post.id);
                                },
                              ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(updatedPost.content),
                        SizedBox(height: 10.h),
                        if (widget.post.media.isNotEmpty)
                          _buildMediaSection(widget.post.media),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(_isLiked
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined),
                              onPressed: _toggleLikeStatus,
                            ),
                            Text('${updatedPost.likes.length}'),
                            SizedBox(width: 20.w),
                            const Icon(Icons.comment_outlined),
                            SizedBox(width: 10.w),
                            Text('${updatedPost.comments.length}'),
                          ],
                        ),
                        const Divider(),
                        Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        if (updatedPost.comments.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(50.0),
                            child: Center(
                              child: Text('No Comments'),
                            ),
                          ),
                        ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: updatedPost.comments.length,
                          itemBuilder: (context, index) {
                            final comment = updatedPost.comments[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blueAccent,
                                      child: comment.commenter.profilePicture !=
                                              null
                                          ? ClipOval(
                                              child: Image.network(
                                                comment
                                                    .commenter.profilePicture!,
                                                fit: BoxFit.cover,
                                                width: 40.0.w,
                                                height: 40.0.h,
                                              ),
                                            )
                                          : Text(comment.commenter.name[0]),
                                    ),
                                    SizedBox(width: 15.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      comment.commenter.name,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 2.5.h,
                                                    ),
                                                    Text(
                                                      timeago.format(
                                                          comment.timestamp),
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (comment.commenter.id ==
                                                  _currentUserId) ...[
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.more_vert),
                                                  onPressed: () async {
                                                    _showBottomSheet(
                                                        comment.id);
                                                  },
                                                ),
                                              ],
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(comment.content),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildCommentInput(context),
        ],
      ),
    );
  }

  void _showPostBottomSheet(String postId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _confirmDeletePost(postId);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDeletePost(String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pop(context);
                await _communityProvider.deletePost(postId);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(String commentId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _confirmDelete(commentId);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(String commentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Comment'),
          content: const Text('Are you sure you want to delete this comment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await _communityProvider.deleteComment(
                    widget.post.id, commentId);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Material(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: AutoSizeTextField(
                controller: _commentController,
                focusNode: _focusNode,
                minLines: 1,
                maxLines: 5,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Type comment here...',
                ),
              ),
            ),
            SizedBox(width: 10.w),
            ElevatedButton(
              onPressed: () async {
                await _communityProvider.commentOnPost(
                    widget.post.id, _commentController.text);
                _focusNode.unfocus();
                _commentController.clear();
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
