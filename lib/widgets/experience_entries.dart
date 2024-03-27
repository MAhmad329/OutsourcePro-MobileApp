import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';

import '../models/freelancer.dart';
import '../screens/freelancer/add_experience.dart';

class ExperienceEntries extends StatelessWidget {
  final FreelancerProfile profile;
  final bool isEditable;

  const ExperienceEntries({
    Key? key,
    required this.profile,
    this.isEditable = true,
  }) : super(key: key);

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
                  'Experience',
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
                    'add_experience_screen',
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
        SizedBox(height: 5.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: profile.experienceEntries.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Divider(
                  thickness: 0.75.w,
                ),
                SizedBox(
                  width: double.infinity,
                  // margin: EdgeInsets.only(
                  //   bottom: 16.0.h,
                  // ),
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
                                  profile.experienceEntries[index].jobtitle,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  profile.experienceEntries[index].company,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Stack(
                                  children: [
                                    Text(
                                      '${profile.experienceEntries[index].startDate}  -  ${profile.experienceEntries[index].endDate}',
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.grey),
                                    ),
                                    if (isEditable)
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () {
                                            // Navigate to AddExperience screen with the selected entry for editing
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddExperience(
                                                  experienceEntry: profile
                                                      .experienceEntries[index],
                                                  index: index,
                                                ),
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
