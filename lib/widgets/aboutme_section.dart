import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';
import 'package:provider/provider.dart';

import '../Providers/freelance_profile_provider.dart';

class AboutMeSection extends StatelessWidget {
  const AboutMeSection({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    FreelancerProfileProvider provider =
        Provider.of<FreelancerProfileProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'About Me',
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
                  'edit_about_me_screen',
                );
              },
              icon: Icon(
                Icons.edit,
                color: primaryColor,
                size: 20.r,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h,),
        const Divider(
          thickness: 0.75,
        ),
        SizedBox(height: 5.h),
        if (provider.profile.aboutMe.isNotEmpty)
          Row(
            children: [
              Expanded(
                  child: Text(
                provider.profile.aboutMe,
                style: TextStyle(
                  fontSize: 13.sp,
                ),
              )),
            ],
          ),
        SizedBox(
          height: 16.0.h,
        ),
      ],
    );
  }
}
