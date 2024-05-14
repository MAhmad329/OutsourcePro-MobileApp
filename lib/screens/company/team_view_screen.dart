import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/models/team.dart';
import 'package:outsourcepro/screens/freelancer/chat_screen.dart';
import 'package:outsourcepro/screens/freelancer/profile_screen.dart';

class TeamViewScreen extends StatefulWidget {
  final Team team;
  const TeamViewScreen({super.key, required this.team});

  @override
  State<TeamViewScreen> createState() => _TeamViewScreenState();
}

class _TeamViewScreenState extends State<TeamViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Team',
          style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Team Leader',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(widget.team!.owner.pfp),
                                radius: 15.r,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              SizedBox(
                                width: 150.w,
                                child: Text(
                                  widget.team!.owner.username,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.person),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          otherProfile: widget.team!.owner),
                                    ),
                                  );
                                }),
                            IconButton(
                              icon: const Icon(Icons.chat),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      receiverId: widget.team!.owner.id,
                                      username: widget.team!.owner.username,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Team Members',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // to prevent inner scrolling
                    shrinkWrap:
                        true, // essential for ListView inside Column/ListView
                    itemCount: widget.team!.members.length,
                    itemBuilder: (context, index) {
                      final member = widget.team!.members[index];
                      if (member.id == widget.team!.owner.id) {
                        // If the member is the owner, don't display them in the list
                        return Container(); // or SizedBox.shrink()
                      }
                      return Padding(
                        padding: EdgeInsets.only(left: 15.0.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(member.pfp),
                                      radius: 15.r,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    SizedBox(
                                      width: 125.w,
                                      child: Text(
                                        member.username,
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProfileScreen(
                                              otherProfile: member,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.person,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Team Skills',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Wrap(
                    spacing: 6.0.r,
                    runSpacing: 8.0.r,
                    children: List.generate(
                      widget.team.teamSkills.length,
                      (index) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0.w,
                          vertical: 8.0.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(
                            8.0.r,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.team.teamSkills[index],
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
