import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/providers/auth_provider.dart';
import 'package:outsourcepro/providers/token_provider.dart';
import 'package:outsourcepro/widgets/button.dart';
import 'package:outsourcepro/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/password_visibility_provider.dart';
import 'login_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  final LoginType loginType;
  const NewPasswordScreen({super.key, required this.loginType});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  'Enter New Password',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.h),
                const Text(
                  textAlign: TextAlign.center,
                  'Enter a new password for your account below',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
              ],
            ),
            SizedBox(
              height: 50.h,
            ),
            Consumer<PasswordVisibilityProvider>(
              builder: (context, provider, child) {
                return TextFormField(
                  style: TextStyle(fontSize: 14.sp),
                  controller: passwordController,
                  cursorColor: primaryColor,
                  obscureText: provider.isObscure,
                  decoration: kTextFieldDecoration.copyWith(
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14.sp,
                    ),
                    hintText: 'New Password',
                    suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        color: Colors.grey.shade500,
                        icon: Icon(
                          size: 20.r,
                          provider.isObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          provider.toggleVisibility();
                        }),
                  ),
                );
              },
            ),
            SizedBox(
              height: 15.h,
            ),
            Consumer<PasswordVisibilityProvider>(
              builder: (context, provider, child) {
                return TextFormField(
                  style: TextStyle(fontSize: 14.sp),
                  controller: confirmPasswordController,
                  cursorColor: primaryColor,
                  obscureText: provider.isObscure,
                  decoration: kTextFieldDecoration.copyWith(
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14.sp,
                    ),
                    hintText: 'Confirm New Password',
                    suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        color: Colors.grey.shade500,
                        icon: Icon(
                          size: 20.r,
                          provider.isObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          provider.toggleVisibility();
                        }),
                  ),
                );
              },
            ),
            SizedBox(
              height: 25.h,
            ),
            MyButton(
              onTap: () {
                FocusScope.of(context).unfocus();
                if (passwordController.text.trim() ==
                    confirmPasswordController.text.trim()) {
                  Provider.of<AuthProvider>(context, listen: false)
                      .setNewPassword(
                          Provider.of<TokenProvider>(context, listen: false)
                              .ipaddress,
                          Provider.of<TokenProvider>(context, listen: false)
                              .cookie,
                          passwordController.text.trim(),
                          context,
                          widget.loginType == LoginType.freelancer
                              ? 'freelancer'
                              : 'company');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      customSnackBar('Passwords do not match!', Colors.red));
                }
              },
              buttonColor: primaryColor,
              buttonWidth: double.infinity.w,
              buttonHeight: 40.h,
              buttonText: 'Set New Password',
            ),
            SizedBox(
              height: 15.h,
            ),
            MyButton(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              buttonColor: Colors.grey,
              buttonWidth: double.infinity.w,
              buttonHeight: 40.h,
              buttonText: 'Cancel',
            )
          ],
        ),
      ),
    );
  }
}
