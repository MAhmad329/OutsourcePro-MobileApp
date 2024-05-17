import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/providers/community_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

import '../../constants.dart';
import '../../models/post.dart';
import 'post_detail_screen.dart';

class CommunityPostCard extends StatefulWidget {
  final Post post;

  const CommunityPostCard({Key? key, required this.post}) : super(key: key);

  @override
  _CommunityPostCardState createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard> {
  bool _isExpanded = false;
  int _currentIndex = 0;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.post.media.isNotEmpty) {
      _initializeVideoController(widget.post.media[0]);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _initializeVideoController(String url) {
    if (_isVideo(url)) {
      _videoController = VideoPlayerController.network(url)
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
        }).catchError((error) {
          print('Error initializing video player: $error');
        });
    }
  }

  bool _isVideo(String url) {
    return url.contains('.mp4') || url.contains('.mov') || url.contains('.avi');
  }

  @override
  Widget build(BuildContext context) {
    final communityProvider =
        Provider.of<CommunityProvider>(context, listen: false);
    final hasLongContent = _hasLongContent(widget.post.content, 3, context);
    final bool isLiked = widget.post.isLikedBy(
      Provider.of<FreelancerProfileProvider>(context, listen: false).profile.id,
    );

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
                    child: widget.post.author.profilePicture != null
                        ? ClipOval(
                            child: Image.network(
                              widget.post.author.profilePicture!,
                              fit: BoxFit.cover,
                              width: 40.0.w,
                              height: 40.0.h,
                            ),
                          )
                        : Text(
                            widget.post.author.name[0],
                            style: TextStyle(color: Colors.yellow),
                          ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: Text(
                            widget.post.author.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => CommunityProfileScreen(
                            //         author: widget.post.author,
                            //       ),
                            //     ));
                          },
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PostDetailsScreen(post: widget.post),
                      ));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    _buildContent(hasLongContent),
                    SizedBox(height: 10.h),
                    if (widget.post.media.isNotEmpty)
                      _buildMediaSection(widget.post.media),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined),
                    onPressed: () {
                      setState(() {
                        communityProvider.toggleLikeStatus(
                          widget.post,
                          Provider.of<FreelancerProfileProvider>(context,
                                  listen: false)
                              .profile
                              .id,
                        );
                      });
                    },
                  ),
                  Text('${widget.post.likes.length}'),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
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
        if (hasLongContent || _isExpanded)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Show Less' : 'Read More',
              style: TextStyle(
                color: primaryColor,
                fontSize: 12.sp,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
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
      maxWidth: MediaQuery.of(context).size.width - 30.w,
    );
    return tp.didExceedMaxLines;
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
              if (_isVideo(media[index])) {
                _videoController?.pause();
                _initializeVideoController(media[index]);
              } else {
                _videoController?.pause();
              }
            },
            itemBuilder: (context, index) {
              if (_isVideo(media[index])) {
                return _videoController != null &&
                        _videoController!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      )
                    : const Center(child: CircularProgressIndicator());
              } else {
                return Image.network(media[index]);
              }
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
}
