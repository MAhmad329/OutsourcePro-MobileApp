import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/constants.dart';
import 'package:provider/provider.dart';

import '../models/education_entry.dart';
import '../screens/add_education.dart';

class EducationEntries extends StatelessWidget {
  const EducationEntries({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FreelancerProfileProvider provider =
        Provider.of<FreelancerProfileProvider>(context);
    List<EducationEntry> entries = provider.profile.educationEntries;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8.0.w,
                ),
                Text(
                  'Education',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
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
                size: 20.r,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        // Use ListView to allow scrolling if there are many entries
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 16.0.w,
                vertical: 12.0.h,
              ),
              margin: EdgeInsets.only(
                bottom: 16.0.h,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
              ),
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
                              height: 10.h,
                            ),
                            Text(
                              'Institution: ',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              entries[index].institution,
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Text(
                              'Course: ',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              entries[index].course,
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Text(
                              'Duration: ',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Stack(
                              children: [
                                Text(
                                  '${entries[index].startDate}  ---  ${entries[index].endDate}',
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () {
                                      // Navigate to AddEducation screen with the selected entry for editing
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddEducation(
                                              educationEntry: entries[index]),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: primaryColor,
                                      size: 20.r,
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
