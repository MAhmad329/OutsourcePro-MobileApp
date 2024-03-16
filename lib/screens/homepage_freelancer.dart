import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/constants.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';

class HomepageFreelancer extends StatefulWidget {
  const HomepageFreelancer({Key? key}) : super(key: key);

  @override
  State<HomepageFreelancer> createState() => _HomepageFreelancerState();
}

class _HomepageFreelancerState extends State<HomepageFreelancer> {
  String ipaddress = '';
  Future<void> _logout() async {
    ipaddress =
        Provider.of<IPAddressProvider>(context, listen: false).ipaddress;
    var request = http.Request(
        'GET', Uri.parse('http://$ipaddress:3000/api/v1/Freelancer/logout'));
    request.body = '''''';

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Navigator.pop(context);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          toolbarHeight: 20.h,
          elevation: 0,
          automaticallyImplyLeading: false,
          // actions: [
          //   InkWell(
          //     onTap: () {
          //       _logout();
          //     },
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 20.0.r),
          //       child: const Text('Logout'),
          //     ),
          //   )
          // ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'profile_screen');
                    },
                    child: CircleAvatar(
                      radius: 35.r,
                      backgroundColor: primaryColor.withOpacity(0.75),
                      child: CircleAvatar(
                        radius: 30.r,
                        backgroundImage: AssetImage('assets/profilepic.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: TextStyle(fontSize: 25.sp),
                      ),
                      Text(
                        '${Provider.of<FreelancerProfileProvider>(context).profile.firstname}.',
                        style: TextStyle(fontSize: 25.sp),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25.h,
              ),
              Text(
                'Find Project here.',
                style: TextStyle(fontSize: 24.sp),
              ),
              SizedBox(
                height: 15.h,
              ),
              TextField(
                style: TextStyle(fontSize: 14.sp),
                cursorColor: Colors.black,
                decoration: kTextFieldDecoration.copyWith(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: primaryColor.withOpacity(0.5), width: 2.0.w),
                    borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
                  ),
                  hintStyle: kText3.copyWith(
                      fontSize: 15.sp,
                      color: const Color(0xffbdbdbd),
                      fontWeight: FontWeight.w400),
                  hintText: 'Search',
                  prefixIcon: Icon(
                    size: 20.r,
                    Icons.search_sharp,
                    color: primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    return Provider.of<ProjectProvider>(context, listen: false)
                        .fetchProjects();
                  },
                  child: Consumer<ProjectProvider>(
                    builder: (context, projectProvider, child) {
                      List<Project> projects = projectProvider.projects;
                      if (projects.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        ); // Show loading indicator while fetching data
                      } else {
                        return ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                              ),
                              margin: EdgeInsets.symmetric(
                                vertical: 12.0.h,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0.r),
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryColor.withOpacity(0.9),
                                      primaryColor.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                padding: EdgeInsets.all(16.0.r),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      projects[index].title,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.attach_money,
                                          color: Colors.white,
                                          size: 20.r,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Budget: ${projects[index].budget}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.category,
                                          color: Colors.white,
                                          size: 20.r,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Type: ${projects[index].type}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.code,
                                          color: Colors.white,
                                          size: 20.r,
                                        ),
                                        SizedBox(width: 4.w),
                                        Expanded(
                                          child: Text(
                                            'Tech Stack: ${projects[index].technologyStack}',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: Colors.white,
                                          size: 20.r,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Posted: ${projects[index].timeElapsed()}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
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
