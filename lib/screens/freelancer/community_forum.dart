import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/providers/community_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../constants.dart';
import '../../models/post.dart';

class CommunityForum extends StatefulWidget {
  CommunityForum({super.key});

  @override
  State<CommunityForum> createState() => _CommunityForumState();
}

class _CommunityForumState extends State<CommunityForum> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CommunityProvider>(context, listen: false).getAllPosts());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          elevation: 0.5,
          shadowColor: Colors.black,
          backgroundColor: const Color(0xFFFFFFFF),
          title: Text(
            'Community Forum',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        // Implement your search logic here
                      },
                      style: TextStyle(fontSize: 14.sp),
                      cursorColor: Colors.black,
                      decoration: kTextFieldDecoration.copyWith(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0.h, horizontal: 10.0.w),
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: primaryColor.withOpacity(0.5),
                              width: 2.0.w),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0.r)),
                        ),
                        hintStyle: kText3.copyWith(
                            fontSize: 15.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400),
                        hintText: 'Search for posts',
                        prefixIcon: Icon(
                          size: 20.r,
                          Icons.search_sharp,
                          color: primaryColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: RefreshIndicator(
                  color: primaryColor,
                  onRefresh: () {
                    return Provider.of<CommunityProvider>(context,
                            listen: false)
                        .getAllPosts();
                  },
                  child: Consumer<CommunityProvider>(
                    builder: (context, communityProvider, child) {
                      List<Post> posts = communityProvider.posts;
                      if (posts.isEmpty) {
                        return const Center(
                          child: Text('No posts found'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return CommunityPostCard(post: post);
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommunityPostCard extends StatefulWidget {
  final Post post;
  const CommunityPostCard({Key? key, required this.post}) : super(key: key);

  @override
  _CommunityPostCardState createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasLongContent = _hasLongContent(widget.post.content, 3, context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 4.0.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(widget.post.author[0]),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          timeago.format(widget.post.timestamp),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              _buildContent(hasLongContent),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up),
                    onPressed: () {
                      // Add your logic to handle likes
                    },
                  ),
                  Text('${widget.post.likes}'),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PostDetailsScreen(post: widget.post),
                        ),
                      );
                    },
                  ),
                  Text('${widget.post.comments.length}'),
                ],
              ),
              // Displaying a single comment
              // if (widget.post.comments.isNotEmpty)
              //   GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) =>
              //               PostDetailsScreen(post: widget.post),
              //         ),
              //       );
              //     },
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(vertical: 4.0.h),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Row(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               CircleAvatar(
              //                 backgroundColor: Colors.blueAccent,
              //                 child: Text(widget.post.author[0]),
              //               ),
              //               SizedBox(width: 15.w),
              //               Expanded(
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text(
              //                       widget.post.comments[0].commenter,
              //                       style:
              //                           TextStyle(fontWeight: FontWeight.bold),
              //                     ),
              //                     SizedBox(
              //                       height: 2.5.h,
              //                     ),
              //                     Text(
              //                       timeago.format(
              //                           widget.post.comments[0].timestamp),
              //                       style: const TextStyle(
              //                           fontSize: 12, color: Colors.grey),
              //                     ),
              //                     SizedBox(
              //                       height: 5.h,
              //                     ),
              //                     Row(
              //                       children: [
              //                         Expanded(
              //                           child: Text(
              //                               widget.post.comments[0].content),
              //                         ),
              //                       ],
              //                     ),
              //                     SizedBox(
              //                       height: 20.h,
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool hasLongContent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.post.content,
          maxLines: _isExpanded ? null : 3,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14.sp),
        ),
        if (hasLongContent)
          GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(_isExpanded ? 'Show Less' : 'Read More')),
      ],
    );
  }

  bool _hasLongContent(String content, int maxLines, BuildContext context) {
    final span = TextSpan(text: content, style: TextStyle(fontSize: 14.sp));
    final tp = TextPainter(
      maxLines: maxLines,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      text: span,
    );
    tp.layout(
        maxWidth: MediaQuery.of(context).size.width -
            30.w); // Adjust based on your padding
    return tp.didExceedMaxLines;
  }
}

class PostDetailsScreen extends StatefulWidget {
  final Post post;
  const PostDetailsScreen({Key? key, required this.post}) : super(key: key);

  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(widget.post.author[0]),
                        ),
                        SizedBox(width: 15.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post.author,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              timeago.format(widget.post.timestamp),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(widget.post.content),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.thumb_up_alt_outlined),
                          onPressed: () {
                            // Add your logic to handle likes
                          },
                        ),
                        Text('${widget.post.likes}'),
                        SizedBox(width: 20.w),
                        Icon(Icons.comment_outlined),
                        SizedBox(width: 10.w),
                        Text('${widget.post.comments.length}'),
                      ],
                    ),
                    Divider(),
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
                    ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.post.comments.length,
                      itemBuilder: (context, index) {
                        final comment = widget.post.comments[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  child: Text(widget.post.author[0]),
                                ),
                                SizedBox(width: 15.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.commenter,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 2.5.h,
                                      ),
                                      Text(
                                        timeago.format(comment.timestamp),
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(comment.content),
                                          ),
                                        ],
                                      ),
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
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
          _buildCommentInput(context),
        ],
      ),
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
                      hintText: 'Type comment here...')),
            ),
            SizedBox(width: 10.w),
            ElevatedButton(
              onPressed: () {
                // Implement your comment submission logic here
              },
              child: Text('Send'),
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
