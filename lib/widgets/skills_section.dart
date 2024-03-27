import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/screens/freelancer/manage_skills.dart';
import 'package:provider/provider.dart';

import '../models/freelancer.dart';
import 'button.dart';

class SkillsSection extends StatelessWidget {
  final FreelancerProfile profile;
  final bool isEditable;

  const SkillsSection({
    Key? key,
    required this.profile,
    this.isEditable = true,
  }) : super(key: key);

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
            if (isEditable)
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageSkills(),
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
        SizedBox(
          height: 5.h,
        ),
        Wrap(
          spacing: 6.0.r,
          runSpacing: 8.0.r,
          children: List.generate(
            profile.skills.length,
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
                    profile.skills[index],
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
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
