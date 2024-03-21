import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/widgets/experience_entries.dart';
import 'package:provider/provider.dart';

import '../widgets/aboutme_section.dart';
import '../widgets/education_entries.dart';
import '../widgets/skills_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<FreelancerProfileProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile Section',
          style: TextStyle(
            fontSize: 24.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          size: 30.0.r,
          color: primaryColor,
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'edit_personal_info');
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0.w,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    //fetchFreelancerDetails();
                  },
                  child: Container(
                    width: 325.w,
                    height: 175.h,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/background.png',
                        ),
                      ),
                      borderRadius: BorderRadius.circular(
                        10.0.r,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.0.h,
                        ),
                        Consumer<FreelancerProfileProvider>(
                            builder: (_, provider, child) {
                          return provider.profile.pfp != ''
                              ? CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(
                                    provider.profile.pfp,
                                  ),
                                  radius: 50.r,
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: const AssetImage(
                                    'assets/defaultpic.jpg',
                                  ),
                                  radius: 50.r,
                                );
                        }),
                        SizedBox(
                          height: 10.h,
                        ),
                        Column(
                          children: [
                            Text(
                              profileProvider.profile.firstname,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              profileProvider.profile.username,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              // About Me Section
              const AboutMeSection(),
              const SkillsSection(),
              const EducationEntries(),
              const ExperienceEntries(),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
