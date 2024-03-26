import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/screens/manage_skills.dart';
import 'package:provider/provider.dart';

import 'button.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({
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
                  'Skills',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageSkills(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: primaryColor,
                    size: 20.r,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showAddSkillEntryDialog(
                      'Skill',
                      provider.profile.skills,
                      context,
                      provider,
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
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Divider(
          thickness: 0.75.w,
        ),
        SizedBox(
          height: 5.h,
        ),
        Wrap(
          spacing: 6.0.r,
          runSpacing: 8.0.r,
          children: List.generate(
            provider.profile.skills.length,
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
                    provider.profile.skills[index],
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                  // SizedBox(
                  //   width: 10.w,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     _showDeleteSkillDialog(
                  //       index,
                  //       context,
                  //       provider,
                  //     );
                  //   },
                  //   child: Icon(
                  //     Icons.cancel_outlined,
                  //     size: 16.r,
                  //     color: Colors.red,
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16.0.h,
        ),
      ],
    );
  }
}

void _showAddSkillEntryDialog(
  String title,
  List<String> entries,
  BuildContext context,
  FreelancerProfileProvider provider,
) {
  TextEditingController entryController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          'Add $title',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        )),
        content: TextField(
          style: TextStyle(
            fontSize: 14.sp,
          ),
          controller: entryController,
          decoration: kTextFieldDecoration.copyWith(
            hintText: 'Enter a skill',
            hintStyle: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              MyButton(
                buttonText: 'Cancel',
                buttonColor: Colors.black26,
                buttonWidth: 110.w,
                buttonHeight: 40.h,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(width: 10.w),
              MyButton(
                buttonText: 'Confirm',
                buttonColor: primaryColor,
                buttonWidth: 110.w,
                buttonHeight: 40.h,
                onTap: () {
                  String entryText = entryController.text.trim();

                  if (entryText.isNotEmpty) {
                    provider.addSkill(
                      entryText,
                    );

                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
