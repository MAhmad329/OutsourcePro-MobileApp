import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/project.dart';
import '../widgets/button.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Project project;
  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          child: MyButton(
            onTap: () {},
            buttonText: 'Apply',
            buttonColor: primaryColor,
            buttonWidth: double.infinity.w,
            buttonHeight: 40.h,
            textColor: Colors.white,
            borderColor: primaryColor,
            borderRadius: 0,
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Project Details',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
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
                  height: 25.h,
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
                      'Technology Stack',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      project.technologyStack,
                      style: TextStyle(fontSize: 12.sp),
                    ),
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
