import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/providers/project_provider.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/project.dart';
import '../../widgets/button.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final VoidCallback? onActionCompleted;
  final Project project;
  const ProjectDetailsScreen(
      {super.key, required this.project, this.onActionCompleted});

  @override
  Widget build(BuildContext context) {
    FreelancerProfileProvider freelancerProvider =
        Provider.of<FreelancerProfileProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          child: Consumer<ProjectProvider>(
            builder: (_, provider, child) {
              bool isApplied = provider.hasApplied(
                  project.id, freelancerProvider.profile.id);
              return MyButton(
                onTap: () {
                  if (isApplied) {
                    provider.cancelApplication(
                        project.id, freelancerProvider.profile.id, context,
                        onSuccess: () {
                      Provider.of<FreelancerProfileProvider>(context,
                              listen: false)
                          .fetchFreelancerDetails();
                    });
                  } else {
                    provider.applyToProject(
                        project.id, freelancerProvider.profile.id, context,
                        onSuccess: () {
                      Provider.of<FreelancerProfileProvider>(context,
                              listen: false)
                          .fetchFreelancerDetails();
                    });
                  }
                },
                buttonText: isApplied ? 'Cancel' : 'Apply',
                buttonColor: isApplied ? Colors.red : primaryColor,
                buttonWidth: double.infinity.w,
                buttonHeight: 40.h,
                textColor: Colors.white,
                borderColor: isApplied ? Colors.red : primaryColor,
                borderRadius: 0,
              );
            },
          ),
        ),
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
                SizedBox(
                  height: 10.h,
                ),
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
                SizedBox(
                  height: 25.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Requirement',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      project.requiresTeam ? 'Team' : 'Freelancer',
                      style: TextStyle(fontSize: 12.sp),
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
                      project.requiresTeam
                          ? 'No. of Team Applicants'
                          : 'No. of Applicants',
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
                        Project updatedProject = provider.projects
                            .firstWhere((proj) => proj.id == project.id);
                        return Text(
                          updatedProject.requiresTeam
                              ? updatedProject.teamApplicants.length.toString()
                              : updatedProject.freelancerApplicants.length
                                  .toString(),
                          style: TextStyle(fontSize: 12.sp),
                        );
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
