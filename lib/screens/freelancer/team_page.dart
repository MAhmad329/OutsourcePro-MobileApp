import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/providers/search_provider.dart';
import 'package:outsourcepro/screens/freelancer/profile_screen.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/freelancer.dart';
import '../../providers/team_provider.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  List<String> teamMembers = ['John Doe', 'Jane Smith', 'Alice Johnson'];

  @override
  Widget build(BuildContext context) {
    final freelanceProvider = Provider.of<FreelancerProfileProvider>(context);
    final teamProvider = Provider.of<TeamProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Team',
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: teamProvider.team == null
          ? const Center(
              child:
                  CircularProgressIndicator(), // or any other placeholder widget
            )
          : Padding(
              padding: EdgeInsets.all(16.0.r),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (teamProvider.team!.owner.id ==
                        freelanceProvider.profile.id)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Team Members',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextField(
                            onChanged: (value) {
                              if (value.isEmpty) {
                                Provider.of<FreelancerProfileProvider>(context,
                                        listen: false)
                                    .clearSearchResults();
                              } else {
                                Provider.of<SearchProvider>(context,
                                        listen: false)
                                    .updateFreelancerSearchQuery(
                                        value, freelanceProvider);
                              }
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0.h, horizontal: 16.0.w),
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
                                  color: const Color(0xffbdbdbd),
                                  fontWeight: FontWeight.w400),
                              hintText: 'Search for freelancers...',
                              prefixIcon: Icon(
                                size: 20.r,
                                Icons.search_sharp,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          Consumer<FreelancerProfileProvider>(
                            builder: (_, provider, child) {
                              List<FreelancerProfile> freelancers =
                                  provider.searchResults;
                              if (freelancers.isEmpty) {
                                return const Center(
                                  child: Text(''),
                                );
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: freelancers.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 2.0.w,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(15.0.r),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                freelancers[index].username,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Team Leader',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.h),
                      child: ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(teamProvider.team!.owner.pfp),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(teamProvider.team!.owner.firstname),
                          ],
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.person),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      otherProfile: teamProvider.team!.owner),
                                ),
                              );
                            }),
                      ),
                    ),
                    Text(
                      'Team Members',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    ListView.builder(
                      physics:
                          NeverScrollableScrollPhysics(), // to prevent inner scrolling
                      shrinkWrap:
                          true, // essential for ListView inside Column/ListView
                      itemCount: teamProvider.team!.members.length,
                      itemBuilder: (context, index) {
                        final member = teamProvider.team!.members[index];
                        if (member.id == teamProvider.team!.owner.id) {
                          // If the member is the owner, don't display them in the list
                          return Container(); // or SizedBox.shrink()
                        }
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(member.pfp),
                          ),
                          title: Text(member.firstname),
                          subtitle: Text(member.username),
                          onTap: () {
                            // Navigate to the profile screen with the selected team member's profile
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileScreen(otherProfile: member),
                              ),
                            );
                          },
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
