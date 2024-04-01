import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/providers/token_provider.dart';
import 'package:outsourcepro/screens/freelancer/project_details_screen.dart';
import 'package:outsourcepro/widgets/button.dart';
import 'package:provider/provider.dart';

import '../../models/project.dart';
import '../../providers/project_provider.dart';
import '../../providers/search_provider.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String ipaddress = '';
  Future<void> _logout() async {
    ipaddress = Provider.of<TokenProvider>(context, listen: false).ipaddress;
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
    final projectProvider = Provider.of<ProjectProvider>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          elevation: 0.5,
          shadowColor: Colors.black,
          backgroundColor: const Color(0xFFFFFFFF),
          title: Text(
            'Projects',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Row(
            children: [
              SizedBox(
                width: 10.w,
              ),
              Consumer<FreelancerProfileProvider>(
                builder: (_, provider, child) {
                  return provider.profile.pfp != ''
                      ? CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                            provider.profile.pfp,
                          ),
                          radius: 13.r,
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: const AssetImage(
                            'assets/defaultpic.jpg',
                          ),
                          radius: 13.r,
                        );
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        Provider.of<SearchProvider>(context, listen: false)
                            .updateProjectSearchQuery(value, projectProvider);
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
                        hintText: 'Search for projects',
                        prefixIcon: Icon(
                          size: 20.r,
                          Icons.search_sharp,
                          color: primaryColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 10.w,
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     border: Border.fromBorderSide(
                  //         BorderSide(width: 2.w, color: primaryColor)),
                  //     borderRadius: BorderRadius.circular(5.0.r),
                  //   ),
                  //   height: 35.h,
                  //   width: 35.w,
                  //   child: const Icon(
                  //     Icons.tune,
                  //     color: Colors.grey,
                  //   ),
                  // )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: RefreshIndicator(
                  color: primaryColor,
                  onRefresh: () {
                    return Provider.of<ProjectProvider>(context, listen: false)
                        .fetchProjects();
                  },
                  child: Consumer<ProjectProvider>(
                    builder: (context, projectProvider, child) {
                      List<Project> projects = projectProvider.projects;
                      if (projectProvider.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        );
                      } else if (projectProvider.projects.isEmpty) {
                        return const Center(
                          child: Text('No results found'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                              ),
                              margin: EdgeInsets.symmetric(
                                vertical: 12.0.h,
                                horizontal: 4.0.w,
                              ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                projects[index].owner.pfp),
                                          ),
                                          SizedBox(
                                            width: 15.w,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  projects[index].title,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Text(
                                                  projects[index].timeElapsed(),
                                                  style: TextStyle(
                                                      fontSize: 11.sp,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        projects[index].description,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Container(
                                                height: 30
                                                    .h, // Adjust the height as needed
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: projects[index]
                                                      .requiredMembers
                                                      .length,
                                                  itemBuilder:
                                                      (context, memberIndex) {
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          right: 6.0
                                                              .w), // Spacing between items
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 10.0.w,
                                                        vertical: 8.0.h,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade100,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    8.0.r),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          projects[index]
                                                                  .requiredMembers[
                                                              memberIndex],
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Budget: ',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            projects[index].budget.toString(),
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15.h),
                                      MyButton(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProjectDetailsScreen(
                                                project: projects[index],
                                              ),
                                            ),
                                          );
                                        },
                                        buttonText: 'View Details',
                                        buttonColor: Colors.white,
                                        buttonWidth: double.infinity.w,
                                        buttonHeight: 35.h,
                                        textColor: Colors.black,
                                        borderColor: primaryColor,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
