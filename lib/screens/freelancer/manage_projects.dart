import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/providers/project_provider.dart';
import 'package:outsourcepro/screens/freelancer/ongoing_project_screen.dart';
import 'package:outsourcepro/screens/freelancer/ongoing_project_solo.dart';
import 'package:outsourcepro/screens/freelancer/project_details_screen.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/project.dart';

class ManageProjects extends StatefulWidget {
  const ManageProjects({super.key});

  @override
  State<ManageProjects> createState() => _ManageProjectsState();
}

class _ManageProjectsState extends State<ManageProjects> {
  @override
  void initState() {
    Provider.of<ProjectProvider>(context, listen: false)
        .getSoloAssignedProjects();
    Provider.of<ProjectProvider>(context, listen: false)
        .getTeamAssignedProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        iconTheme: IconThemeData(size: 30.0.r, color: primaryColor),
        title: Text(
          'Manage Projects',
          style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Applied Projects',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Consumer<FreelancerProfileProvider>(
                builder: (context, provider, child) {
                  List<Project> projects = provider.profile.appliedProjects;
                  if (provider.profile.appliedProjects.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(left: 8.0.w),
                      child: const Text(
                        'No Projects Applied Currently',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true, // Add this line
                      physics:
                          const NeverScrollableScrollPhysics(), // Add this line
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0.h),
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
                              padding: EdgeInsets.all(10.0.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          projects[index].title,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
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
                                          icon: Icon(
                                            Icons.chevron_right,
                                            size: 24.r,
                                          ))
                                    ],
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
              SizedBox(
                height: 25.h,
              ),
              Text(
                'Ongoing Projects',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Solo Projects',
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(
                height: 5.h,
              ),
              Consumer<ProjectProvider>(
                builder: (context, provider, child) {
                  List<Project> projects = provider.soloAssignedProjects;
                  if (provider.soloAssignedProjects.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(left: 8.0.w),
                      child: const Text(
                        'No Ongoing Projects Currently',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true, // Add this line
                      physics:
                          const NeverScrollableScrollPhysics(), // Add this line
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0.h),
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
                              padding: EdgeInsets.all(10.0.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          projects[index].title,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SoloOngoingProject(
                                                  project: projects[index],
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.chevron_right,
                                            size: 24.r,
                                          ))
                                    ],
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
              SizedBox(
                height: 25.h,
              ),
              Text(
                'Team Projects',
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(
                height: 5.h,
              ),
              Consumer<ProjectProvider>(
                builder: (context, provider, child) {
                  List<Project> projects = provider.teamAssignedProjects;
                  if (provider.teamAssignedProjects.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(left: 8.0.w),
                      child: const Text(
                        'No Ongoing Projects Currently',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true, // Add this line
                      physics:
                          const NeverScrollableScrollPhysics(), // Add this line
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0.h),
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
                              padding: EdgeInsets.all(10.0.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          projects[index].title,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OngoingProjectScreen(
                                                  project: projects[index],
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.chevron_right,
                                            size: 24.r,
                                          ))
                                    ],
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
        ),
      ),
    );
  }
}
