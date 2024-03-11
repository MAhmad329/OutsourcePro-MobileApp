import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';
import 'package:provider/provider.dart';
import '../Providers/freelance_profile_provider.dart';
import '../models/experience_entry.dart';


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
                Icon(
                  Icons.info,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8.0.w,
                ),
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
                size: 20.r,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // Use ListView to allow scrolling if there are many entries
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            return Container(
              width: double.infinity,
              // Make the container go full width
              padding: EdgeInsets.symmetric(
                horizontal: 16.0.w,
                vertical: 12.0.h,
              ),
              margin: EdgeInsets.only(
                bottom: 16.0.h,
              ),
              // Add bottom margin
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
                    children: [
                      Text(
                        'Job Title: ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        entries[index].jobtitle,
                        style: TextStyle(fontSize: 12.sp),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'Company: ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        entries[index].company,
                        style: TextStyle(fontSize: 12.sp),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'Duration: ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${entries[index].startDate}  ---  ${entries[index].endDate}',
                        style: TextStyle(fontSize: 12.sp),
                      )
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
