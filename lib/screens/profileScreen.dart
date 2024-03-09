import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:outsourcepro/constants.dart';
import 'package:provider/provider.dart';
import '../schemas/FreelanceProfile.dart';
import '../widgets/button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<FreelancerProfileProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile Section',
          style: TextStyle(fontSize: 24.sp),
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
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
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
                        image: AssetImage('assets/background.png'),
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.0.h,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              const AssetImage('assets/profilepic.png'),
                          radius: 50.r,
                        ),
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
              buildAboutMeSection(
                title: 'About Me',
                content: profileProvider.profile.aboutMe,
                editCallback: () {
                  Navigator.pushNamed(
                    context,
                    'edit_about_me_screen',
                  );
                },
              ),
              // Skills Section
              buildSkillsSection(profileProvider, context),
              // Education Section
              buildEducationEntriesSection(
                title: 'Education',
                entries: profileProvider.profile.educationEntries,
                editCallback: () {
                  Navigator.pushNamed(
                    context,
                    'add_education_screen',
                  );
                },
              ),

              // Experience Section
              buildExperienceEntriesSection(
                title: 'Experience',
                entries: profileProvider.profile.experienceEntries,
                editCallback: () {
                  Navigator.pushNamed(
                    context,
                    'add_experience_screen',
                  );
                },
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

  Widget buildAboutMeSection({
    required String title,
    required String content,
    required VoidCallback editCallback,
  }) {
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
                const SizedBox(width: 8.0),
                Text(
                  title,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                editCallback();
              },
              icon: Icon(
                Icons.edit,
                color: primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        if (content.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Expanded(child: Text(content)),
              ],
            ),
          ),
        SizedBox(height: 16.0.h),
      ],
    );
  }

  Widget buildSkillsSection(
      FreelancerProfileProvider provider, BuildContext context) {
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
                const SizedBox(width: 8.0),
                Text(
                  'Skills',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                _showAddSkillEntryDialog(
                    'Skill', provider.profile.skills, context, provider);
              },
              icon: Icon(
                Icons.add,
                color: primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.0,
          runSpacing: 12.0,
          children: List.generate(
            provider.profile.skills.length,
            (index) => Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(provider.profile.skills[index]),
                  SizedBox(
                    width: 10.w,
                  ),
                  InkWell(
                    onTap: () {
                      _showDeleteSkillDialog(index, context, provider);
                    },
                    child: Icon(
                      Icons.cancel_outlined,
                      size: 18.r,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16.0.h),
      ],
    );
  }

  void _showDeleteSkillDialog(
      int index, BuildContext context, FreelancerProfileProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Skill'),
          content: const Text('Are you sure you want to delete this skill?'),
          actions: [
            MyButton(
              buttonText: 'Cancel',
              buttonColor: Colors.black26,
              buttonWidth: 110.w,
              buttonHeight: 40.h,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            MyButton(
              buttonText: 'Confirm',
              buttonColor: primaryColor,
              buttonWidth: 110.w,
              buttonHeight: 40.h,
              onTap: () {
                provider.removeSkill(index);
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: 20.w,
            ),
          ],
        );
      },
    );
  }

  Widget buildEducationEntriesSection({
    required String title,
    required List<EducationEntry> entries,
    required VoidCallback editCallback,
  }) {
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
                const SizedBox(width: 8.0),
                Text(
                  title,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                editCallback();
              },
              icon: Icon(
                Icons.add,
                color: primaryColor,
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
              width: double.infinity, // Make the container go full width
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
              margin: EdgeInsets.only(bottom: 16.0.h), // Add bottom margin
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Institution: ',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(entries[index].institution)
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        'Course: ',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(entries[index].course)
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        'Duration: ',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          '${entries[index].startDate}  ---  ${entries[index].endDate}')
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 16.0.h),
      ],
    );
  }

  Widget buildExperienceEntriesSection({
    required String title,
    required List<ExperienceEntry> entries,
    required VoidCallback editCallback,
  }) {
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
                const SizedBox(width: 8.0),
                Text(
                  title,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                editCallback();
              },
              icon: Icon(
                Icons.add,
                color: primaryColor,
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
              width: double.infinity, // Make the container go full width
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
              margin: EdgeInsets.only(bottom: 16.0.h), // Add bottom margin
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Job Title: ',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(entries[index].jobtitle)
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        'Company: ',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(entries[index].company)
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        'Duration: ',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          '${entries[index].startDate}  ---  ${entries[index].endDate}')
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 16.0.h),
      ],
    );
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
          title: Center(child: Text('Add $title')),
          content: TextField(
            controller: entryController,
            decoration:
                kTextFieldDecoration.copyWith(hintText: 'Enter a skill'),
          ),
          actions: [
            MyButton(
              buttonText: 'Cancel',
              buttonColor: Colors.black26,
              buttonWidth: 110.w,
              buttonHeight: 40.h,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            MyButton(
              buttonText: 'Confirm',
              buttonColor: primaryColor,
              buttonWidth: 110.w,
              buttonHeight: 40.h,
              onTap: () {
                String entryText = entryController.text.trim();

                if (entryText.isNotEmpty) {
                  provider.addSkill(entryText);

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
