import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widgets/button.dart';

class ManageSkills extends StatefulWidget {
  const ManageSkills({super.key});

  @override
  State<ManageSkills> createState() => _ManageSkillsState();
}

class _ManageSkillsState extends State<ManageSkills> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FreelancerProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skills',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.profile.skills.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Divider(
                            thickness: 0.75.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0.h),
                                child: Text(
                                  provider.profile.skills[index],
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDeleteSkillDialog(
                                      index, context, provider);
                                },
                                child: Icon(
                                  Icons.delete,
                                  size: 20.r,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showDeleteSkillDialog(
    int index, BuildContext context, FreelancerProfileProvider provider) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Delete Skill',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Text(
          textAlign: TextAlign.center,
          'Are you sure you want to delete this skill?',
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                buttonText: 'Cancel',
                buttonColor: Colors.black26,
                buttonWidth: 120.w,
                buttonHeight: 40.h,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                width: 10.w,
              ),
              MyButton(
                buttonText: 'Confirm',
                buttonColor: primaryColor,
                buttonWidth: 120.w,
                buttonHeight: 40.h,
                onTap: () {
                  provider.removeSkill(index);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),

          // SizedBox(
          //   width: 20.w,
          // ),
        ],
      );
    },
  );
}
