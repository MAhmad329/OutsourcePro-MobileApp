import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/Providers/freelance_profile_provider.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widgets/button.dart';

class EditPersonalInformation extends StatefulWidget {
  const EditPersonalInformation({super.key});

  @override
  State<EditPersonalInformation> createState() =>
      _EditPersonalInformationState();
}

class _EditPersonalInformationState extends State<EditPersonalInformation> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text =
        Provider.of<FreelancerProfileProvider>(context, listen: false)
            .profile
            .firstname;
    lastNameController.text =
        Provider.of<FreelancerProfileProvider>(context, listen: false)
            .profile
            .lastname;
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<FreelancerProfileProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Personal Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0.w,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 25.h,
              ),
              Center(
                child: CircleAvatar(
                  backgroundImage: const AssetImage(
                    'assets/defaultpic.jpg',
                  ),
                  radius: 75.r,
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<FreelancerProfileProvider>(context,
                              listen: false)
                          .uploadProfilePicture();
                    },
                    child: Consumer<FreelancerProfileProvider>(
                        builder: (_, provider, child) {
                      return provider.isUploading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : provider.profile.pfp != ''
                              ? CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(
                                    provider.profile.pfp,
                                  ),
                                  radius: 75.r,
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: const AssetImage(
                                    'assets/defaultpic.jpg',
                                  ),
                                  radius: 50.r,
                                );
                    }),
                  ),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            'First Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      TextField(
                        style: TextStyle(fontSize: 14.sp),
                        controller: firstNameController,
                        cursorColor: primaryColor,
                        decoration: kTextFieldDecoration.copyWith(
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14.sp,
                          ),
                          hintText: 'Enter your first name here',
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
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
                            'Last Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      TextField(
                        style: TextStyle(fontSize: 14.sp),
                        controller: lastNameController,
                        cursorColor: primaryColor,
                        decoration: kTextFieldDecoration.copyWith(
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14.sp,
                          ),
                          hintText: 'Enter your last name here',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          buttonText: 'Cancel',
                          buttonColor: Colors.black26,
                          buttonWidth: double.infinity,
                          buttonHeight: 40.h,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: MyButton(
                          buttonText: 'Confirm',
                          buttonColor: primaryColor,
                          buttonWidth: double.infinity,
                          buttonHeight: 40.h,
                          onTap: () {
                            profileProvider.updateName(firstNameController.text,
                                lastNameController.text);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
