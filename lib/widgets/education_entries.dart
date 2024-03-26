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
          itemCount: entries.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Divider(
                  thickness: 0.75.w,
                ),
                Container(
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
                                  entries[index].institution,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  entries[index].course,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Stack(
                                  children: [
                                    Text(
                                      '${entries[index].startDate} - ${entries[index].endDate}',
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.grey),
                                    ),
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
                                                      educationEntry:
                                                          entries[index],
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
