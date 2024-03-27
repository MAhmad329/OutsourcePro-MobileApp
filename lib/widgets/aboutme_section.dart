import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';

import '../models/freelancer.dart';

class AboutMeSection extends StatelessWidget {
  final FreelancerProfile profile;
  final bool isEditable;

  const AboutMeSection({
    Key? key,
    required this.profile,
    this.isEditable = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(profile.aboutMe);
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
            if (isEditable)
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
        SizedBox(height: 5.h),
        if (profile.aboutMe.isNotEmpty)
          Row(
            children: [
              Expanded(
                  child: Text(
                profile.aboutMe,
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
