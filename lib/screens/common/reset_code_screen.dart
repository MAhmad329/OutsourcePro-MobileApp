import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/providers/auth_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/token_provider.dart';
import '../../widgets/button.dart';
import 'login_screen.dart';

class ResetCodeScreen extends StatefulWidget {
  final LoginType loginType;
  const ResetCodeScreen({super.key, required this.loginType});

  @override
  State<ResetCodeScreen> createState() => _ResetCodeScreenState();
}

class _ResetCodeScreenState extends State<ResetCodeScreen> {
  TextEditingController codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        iconTheme: IconThemeData(size: 30.0.r, color: primaryColor),
        elevation: 0,
        title: Text(
          'Reset Password',
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  'Enter the Code Below',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.h),
                const Text(
                  textAlign: TextAlign.center,
                  'To reset your password, enter the code sent to your email',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
              ],
            ),
            SizedBox(
              height: 25.h,
            ),
            PinCodeTextField(
              textStyle: TextStyle(fontSize: 20.sp),
              pastedTextStyle: TextStyle(fontSize: 20.sp),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              appContext: context,
              length: 4,
              controller: codeController,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                activeColor: primaryColor,
                inactiveColor: Colors.grey,
                selectedColor: Colors.grey,
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            MyButton(
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).resetPassword(
                    Provider.of<TokenProvider>(context, listen: false)
                        .ipaddress,
                    Provider.of<TokenProvider>(context, listen: false).cookie,
                    codeController.text,
                    context,
                    widget.loginType == LoginType.freelancer
                        ? 'freelancer'
                        : 'company');
              },
              buttonColor: primaryColor,
              buttonWidth: double.infinity.w,
              buttonHeight: 40.h,
              buttonText: 'Reset Password',
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
