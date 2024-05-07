import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/providers/community_provider.dart';
import 'package:outsourcepro/screens/common/post_card.dart';
import 'package:provider/provider.dart';

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
                      posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
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
