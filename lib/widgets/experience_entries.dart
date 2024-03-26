import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';
import 'package:provider/provider.dart';

import '../Providers/freelance_profile_provider.dart';
import '../models/experience_entry.dart';
import '../screens/add_experience.dart';

class ExperienceEntries extends StatelessWidget {
  const ExperienceEntries({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FreelancerProfileProvider provider =
        Provider.of<FreelancerProfileProvider>(context);
    List<ExperienceEntry> entries = provider.profile.experienceEntries;
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
          itemCount: entries.length,
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
                                  entries[index].jobtitle,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  entries[index].company,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Stack(
                                  children: [
                                    Text(
                                      '${entries[index].startDate}  -  ${entries[index].endDate}',
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.grey),
                                    ),
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
                                                experienceEntry: entries[index],
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
