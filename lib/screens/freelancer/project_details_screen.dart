import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/providers/project_provider.dart';
import 'package:outsourcepro/providers/team_provider.dart';
import 'package:outsourcepro/screens/company/company_profile_screen.dart';
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

    TeamProvider teamProvider =
        Provider.of<TeamProvider>(context, listen: false);

    bool isTeamLeader =
        teamProvider.team?.owner.id == freelancerProvider.profile.id;
    bool hasTeam = teamProvider.team != null;
    bool canApply = !project.requiresTeam || (hasTeam && isTeamLeader);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SizedBox(
        child: Consumer<ProjectProvider>(
          builder: (_, provider, child) {
            bool isApplied = provider.hasApplied(project.id,
                freelancerProvider.profile.id, teamProvider.team?.id);
            return MyButton(
              onTap: canApply
                  ? () {
                      if (isApplied) {
                        provider.cancelApplication(project.id, context,
                            onSuccess: () {
                          freelancerProvider.fetchFreelancerDetails();
                        });
                      } else {
                        if (project.requiresTeam && isTeamLeader) {
                          provider.applyToProjectAsTeam(project.id, context,
                              onSuccess: () {
                            freelancerProvider.fetchFreelancerDetails();
                          });
                        } else {
                          provider.applyToProject(project.id, context,
                              onSuccess: () {
                            freelancerProvider.fetchFreelancerDetails();
                          });
                        }
                      }
                    }
                  : null,
              buttonText: isApplied ? 'Cancel' : 'Apply',
              buttonColor: canApply
                  ? (isApplied ? Colors.red : primaryColor)
                  : Colors.grey,
              buttonWidth: double.infinity.w,
              buttonHeight: 40.h,
              textColor: Colors.white,
              borderColor: canApply
                  ? (isApplied ? Colors.red : primaryColor)
                  : Colors.grey,
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
              // SizedBox(
              //   height: 5.h,
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
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
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
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
                  Padding(
                    padding: EdgeInsets.only(right: 15.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deadline',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          project.timeAgo(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                          Project updatedProject = provider.projects
                              .firstWhere((proj) => proj.id == project.id);
                          return Text(
                            updatedProject.requiresTeam
                                ? updatedProject.teamApplicants.length
                                    .toString()
                                : updatedProject.freelancerApplicants.length
                                    .toString(),
                            style: TextStyle(fontSize: 12.sp),
                          );
                        },
                      )
                    ],
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
                ],
              ),
              SizedBox(
                height: 25.h,
              ),
              Divider(
                thickness: 0.75.w,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundImage: NetworkImage(
                          project.owner.pfp,
                        ),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.owner.companyName,
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 2.5.h,
                            ),
                            Text(
                              project.owner.businessAddress,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanyProfile(
                                otherProfile: project.owner,
                              ),
                            ),
                          );
                        },
                        child: const Text('View Company Profile'),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
