import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/widgets/experience_entries.dart';
import 'package:provider/provider.dart';

import '../../models/freelancer.dart';
import '../../widgets/aboutme_section.dart';
import '../../widgets/education_entries.dart';
import '../../widgets/skills_section.dart';

class ProfileScreen extends StatefulWidget {
  final FreelancerProfile? otherProfile;

  const ProfileScreen({super.key, this.otherProfile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<FreelancerProfileProvider>(context);
    final FreelancerProfile profile =
        widget.otherProfile ?? profileProvider.profile;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile Section',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (widget.otherProfile == null)
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'edit_personal_info');
              },
              icon: Icon(
                Icons.edit,
                color: primaryColor,
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 52.r,
                    backgroundColor: primaryColor,
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: primaryColor,
                      backgroundImage: const AssetImage(
                        'assets/defaultpic.jpg',
                      ),
                      child: widget.otherProfile == null
                          ? Consumer<FreelancerProfileProvider>(
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
                              },
                            )
                          : profile.pfp != ''
                              ? CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(
                                    profile.pfp,
                                  ),
                                  radius: 50.r,
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: const AssetImage(
                                    'assets/defaultpic.jpg',
                                  ),
                                  radius: 50.r,
                                ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.firstname,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        profile.username,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Divider(
                thickness: 0.75.w,
              ),
              SizedBox(
                height: 10.h,
              ),
              AboutMeSection(
                profile: profile,
                isEditable: widget.otherProfile == null,
              ),
              SizedBox(
                height: 5.h,
              ),
              SkillsSection(
                profile: profile,
                isEditable: widget.otherProfile == null,
              ),
              SizedBox(
                height: 5.h,
              ),
              EducationEntries(
                profile: profile,
                isEditable: widget.otherProfile == null,
              ),
              SizedBox(
                height: 5.h,
              ),
              ExperienceEntries(
                profile: profile,
                isEditable: widget.otherProfile == null,
              ),
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
