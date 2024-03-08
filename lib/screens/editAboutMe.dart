import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Providers/freelance_profile_provider.dart';
import '../constants.dart';
import '../main.dart';
import '../widgets/button.dart';

class EditAboutMe extends StatefulWidget {
  const EditAboutMe({Key? key}) : super(key: key);

  @override
  State<EditAboutMe> createState() => _EditAboutMeState();
}

class _EditAboutMeState extends State<EditAboutMe> {
  TextEditingController captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String ipaddress =
        Provider.of<IPAddressProvider>(context, listen: false).ipaddress;
    String cookie =
        Provider.of<AuthenticationProvider>(context, listen: false).cookie!;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('About Me '),
          centerTitle: true,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 25.h,
                  ),
                  TextField(
                    controller: captionController,
                    keyboardType: TextInputType.multiline,
                    minLines: 10,
                    maxLines: null,
                    decoration: kPostTextFieldDecoration,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                ],
              ),
              Flexible(
                child: Row(
                  children: [
                    MyButton(
                      buttonText: 'Cancel',
                      buttonColor: Colors.black26,
                      buttonWidth: 160.w,
                      buttonHeight: 50,
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
                      buttonHeight: 50,
                      onTap: () {
                        // Get the text from the text field
                        String editedText = captionController.text;
                        // Use the provider method to update the text
                        Provider.of<FreelancerProfileProvider>(context,
                                listen: false)
                            .updateAboutMe(editedText, ipaddress, cookie);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
