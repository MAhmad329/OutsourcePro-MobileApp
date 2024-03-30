import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/screens/freelancer/add_team_member.dart';
import 'package:outsourcepro/screens/freelancer/chat_screen.dart';
import 'package:outsourcepro/screens/freelancer/profile_screen.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/team_provider.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeamProvider>(context, listen: false).fetchTeam();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final freelanceProvider = Provider.of<FreelancerProfileProvider>(context);
    final teamProvider = Provider.of<TeamProvider>(context);
    final isMember = teamProvider.team?.members.any(
          (member) => member.id == freelanceProvider.profile.id,
        ) ??
        false;
    final bool isTeamLeader =
        teamProvider.team?.owner.id == freelanceProvider.profile.id;

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
          actions: [
            isMember &&
                    teamProvider.team?.owner.id != freelanceProvider.profile.id
                ? IconButton(
                    onPressed: () async {
                      final shouldRemove = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                              textAlign: TextAlign.center,
                              'Are you sure you want to leave the team?',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                      if (shouldRemove ?? false) {
                        teamProvider.exitTeam(freelanceProvider.profile.id,
                            freelanceProvider.profile.id);
                        teamProvider.fetchTeam();
                      }
                    },
                    icon: Icon(
                      Icons.exit_to_app,
                      size: 20.r,
                      color: Colors.red,
                    ))
                : const Text(''),
          ]),
      body: teamProvider.team == null || teamProvider.team!.members.isEmpty
          ? const Center(
              child: Text('You are not part of a team'),
            )
          : Padding(
              padding: EdgeInsets.all(16.0.r),
              child: SingleChildScrollView(
                child: Column(
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
                                  backgroundImage: NetworkImage(
                                      teamProvider.team!.owner.pfp),
                                  radius: 15.r,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  teamProvider.team!.owner.username,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                if (isTeamLeader)
                                  Text('(You)',
                                      style: TextStyle(fontSize: 14.sp)),
                              ],
                            ),
                          ),
                          if (!isTeamLeader)
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.person),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileScreen(
                                              otherProfile:
                                                  teamProvider.team!.owner),
                                        ),
                                      );
                                    }),
                                IconButton(
                                  icon: Icon(Icons.chat),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          receiverId:
                                              teamProvider.team!.owner.id,
                                          username:
                                              teamProvider.team!.owner.username,
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
                        if (isTeamLeader)
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddTeamMember()));
                              },
                              icon: Icon(
                                Icons.add,
                                size: 20.r,
                                color: primaryColor,
                              ))
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
                      itemCount: teamProvider.team!.members.length,
                      itemBuilder: (context, index) {
                        final member = teamProvider.team!.members[index];
                        if (member.id == teamProvider.team!.owner.id) {
                          // If the member is the owner, don't display them in the list
                          return Container(); // or SizedBox.shrink()
                        }
                        return Padding(
                          padding: EdgeInsets.only(left: 15.0.w),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(member.pfp),
                                        radius: 15.r,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        member.username,
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ],
                                  ),
                                  if (member.id != freelanceProvider.profile.id)
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                  otherProfile: member,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.person,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatScreen(
                                                            receiverId:
                                                                member.id,
                                                            username: member
                                                                .username)));
                                          },
                                          icon: Icon(
                                            Icons.message,
                                          ),
                                        ),
                                        if (teamProvider.team!.owner.id ==
                                            freelanceProvider.profile.id)
                                          IconButton(
                                            onPressed: () async {
                                              final shouldRemove =
                                                  await showDialog<bool>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      'Are you sure you want to remove ${member.username} from the team?',
                                                      style: TextStyle(
                                                          fontSize: 14.sp),
                                                    ),
                                                    actions: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(false),
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.sp),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 15.w,
                                                          ),
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true),
                                                            child: Text(
                                                              'Remove',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.sp),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                              // If the user confirmed, remove the member
                                              if (shouldRemove ?? false) {
                                                teamProvider.exitTeam(
                                                    member.id,
                                                    freelanceProvider
                                                        .profile.id);
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
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
                  ],
                ),
              ),
            ),
    );
  }
}
