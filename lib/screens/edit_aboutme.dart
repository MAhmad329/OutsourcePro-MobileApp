import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Providers/freelance_profile_provider.dart';
import '../constants.dart';
import '../widgets/button.dart';

class EditAboutMe extends StatefulWidget {
  const EditAboutMe({super.key});

  @override
  State<EditAboutMe> createState() => _EditAboutMeState();
}

class _EditAboutMeState extends State<EditAboutMe> {
  TextEditingController captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default text
    captionController.text =
        Provider.of<FreelancerProfileProvider>(context, listen: false)
            .profile
            .aboutMe;
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 24.r,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'About Me ',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.0.w,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 25.h,
                  ),
                  TextField(
                    style: TextStyle(fontSize: 14.sp),
                    controller: captionController,
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: null,
                    decoration: kPostTextFieldDecoration,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                ],
              ),
              Row(
                children: [
                  MyButton(
                    buttonText: 'Cancel',
                    buttonColor: Colors.black26,
                    buttonWidth: 160.w,
                    buttonHeight: 40.h,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Flexible(
                    child: SizedBox(
                      width: 10.w,
                    ),
                  ),
                  MyButton(
                    buttonText: 'Confirm',
                    buttonColor: primaryColor,
                    buttonWidth: 160.w,
                    buttonHeight: 40.h,
                    onTap: () {
                      // Get the text from the text field
                      String editedText = captionController.text;
                      // Use the provider method to update the text
                      Provider.of<FreelancerProfileProvider>(context,
                              listen: false)
                          .updateAboutMe(editedText);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 25.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
