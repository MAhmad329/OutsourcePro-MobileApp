import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';

import '../models/freelancer.dart';
import '../screens/freelancer/add_education.dart';

class EducationEntries extends StatelessWidget {
  final FreelancerProfile profile;
  final bool isEditable;

  const EducationEntries({
    super.key,
    required this.profile,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Education',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            if (isEditable)
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    'add_education_screen',
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: primaryColor,
                  size: 24.r,
                ),
              ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        // Use ListView to allow scrolling if there are many entries
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: profile.educationEntries.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Divider(
                  thickness: 0.75.w,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  profile.educationEntries[index].institution,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  profile.educationEntries[index].course,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Stack(
                                  children: [
                                    Text(
                                      '${profile.educationEntries[index].startDate}  -  ${profile.educationEntries[index].endDate}',
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.grey),
                                    ),
                                    if (isEditable)
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () {
                                            // Navigate to AddEducation screen with the selected entry for editing
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddEducation(
                                                        educationEntry: profile
                                                                .educationEntries[
                                                            index],
                                                        index: index),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: primaryColor,
                                            size: 15.r,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),

        SizedBox(
          height: 16.0.h,
        ),
      ],
    );
  }
}
