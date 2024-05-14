import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/screens/company/company_posted_projects.dart';
import 'package:provider/provider.dart';

import '../../models/project.dart';
import '../../providers/project_provider.dart';

class CompanyProject extends StatefulWidget {
  const CompanyProject({super.key});

  @override
  State<CompanyProject> createState() => _CompanyProjectState();
}

class _CompanyProjectState extends State<CompanyProject> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProjectProvider>(context, listen: false)
        .getCompanySoloProjects();
    Provider.of<ProjectProvider>(context, listen: false)
        .getCompanyTeamProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Projects'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25.h,
              ),
              Text(
                'Posted Projects',
                style: TextStyle(fontSize: 20.sp),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                'Solo Projects',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                child: Consumer<ProjectProvider>(
                  builder: (context, provider, child) {
                    List<Project> projects = provider.companySoloProjects;
                    if (provider.companySoloProjects.isEmpty) {
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
                                                      CompanyPostedProjects(
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
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                'Team Projects',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                child: Consumer<ProjectProvider>(
                  builder: (context, provider, child) {
                    List<Project> projects = provider.companyTeamProjects;
                    if (provider.companyTeamProjects.isEmpty) {
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
                                                      CompanyPostedProjects(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
