import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/providers/auth_provider.dart';
import 'package:outsourcepro/providers/token_provider.dart';
import 'package:outsourcepro/widgets/button.dart';
import 'package:outsourcepro/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'login_screen.dart';

class ForgotPassword extends StatefulWidget {
  final LoginType loginType;
  const ForgotPassword({super.key, required this.loginType});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        iconTheme: IconThemeData(size: 30.0.r, color: primaryColor),
        elevation: 0,
        title: Text(
          'Forgot Password?',
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: authProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Forgot Password?',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.h),
                      const Text(
                        textAlign: TextAlign.center,
                        'To reset your password, enter your email that can be authenticated',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  TextField(
                    style: TextStyle(fontSize: 14.sp),
                    controller: emailController,
                    cursorColor: primaryColor,
                    decoration: kTextFieldDecoration.copyWith(
                      hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.sp,
                          fontFamily: 'Poppins'),
                      hintText: 'Enter a valid email address',
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  MyButton(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (emailController.text.trim() != '') {
                        Provider.of<AuthProvider>(context, listen: false)
                            .setEmail(emailController.text.trim());
                        Provider.of<AuthProvider>(context, listen: false)
                            .sendResetCode(
                                Provider.of<TokenProvider>(context,
                                        listen: false)
                                    .ipaddress,
                                Provider.of<TokenProvider>(context,
                                        listen: false)
                                    .cookie,
                                context,
                                widget.loginType == LoginType.freelancer
                                    ? 'freelancer'
                                    : 'company');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            customSnackBar(
                                'Kindly enter an email address', Colors.red));
                      }
                    },
                    buttonColor: primaryColor,
                    buttonWidth: double.infinity.w,
                    buttonHeight: 40.h,
                    buttonText: 'Send Code',
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
    );
  }
}
