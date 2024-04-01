import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/project.dart';
import '../../providers/project_provider.dart';

class CompanyPostedProjects extends StatelessWidget {
  final Project project;
  const CompanyPostedProjects({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Project Details',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: 5.h,
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      project.timeElapsed(),
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Project Description',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      project.description,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budget',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          project.budget.toString(),
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Type',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            project.type,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Required Members',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Wrap(
                      spacing: 6.0.r,
                      runSpacing: 8.0.r,
                      children: List.generate(
                        project.requiredMembers.length,
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
                                project.requiredMembers[index],
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
                SizedBox(
                  height: 25.h,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.requiresTeam
                          ? 'Team Applicants'
                          : 'Freelancer Applicants',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Consumer<ProjectProvider>(
                      builder: (context, provider, child) {
                        if (project.requiresTeam) {
                          Project updatedProject = provider.companyTeamProjects
                              .firstWhere((proj) => proj.id == project.id);
                          return Row(
                            children: [
                              Text(
                                updatedProject.teamApplicants.length.toString(),
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              if (updatedProject.freelancerApplicants.length
                                      .toString() !=
                                  '0')
                                TextButton(
                                  onPressed: () {},
                                  child: Text('View Details'),
                                )
                            ],
                          );
                        } else if (!project.requiresTeam) {
                          Project updatedProject = provider.companySoloProjects
                              .firstWhere((proj) => proj.id == project.id);
                          return Row(
                            children: [
                              Text(
                                updatedProject.freelancerApplicants.length
                                    .toString(),
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              if (updatedProject.freelancerApplicants.length
                                      .toString() !=
                                  '0')
                                TextButton(
                                  onPressed: () {},
                                  child: Text('View Details'),
                                )
                            ],
                          );
                        }
                        return Text('Unknown');
                      },
                    )
                  ],
                ),

                SizedBox(
                  height: 25.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
