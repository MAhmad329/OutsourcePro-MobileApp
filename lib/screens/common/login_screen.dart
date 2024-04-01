import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/screens/common/forgot_password.dart';
import 'package:outsourcepro/widgets/button.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/password_visibility_provider.dart';
import '../../widgets/custom_richtext.dart';

enum LoginType { freelancer, company }

class LoginScreen extends StatefulWidget {
  final LoginType loginType;
  const LoginScreen({Key? key, required this.loginType}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String ipaddress = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        iconTheme: IconThemeData(size: 30.0.r, color: primaryColor),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.loginType == LoginType.freelancer
                                ? "Welcome Back Freelancer!"
                                : "Welcome Back Company!",
                            style: TextStyle(
                              fontSize: 32.sp,
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "Sign Into Your Account Below",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 75.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            style: TextStyle(fontSize: 14.sp),
                            controller: emailController,
                            cursorColor: primaryColor,
                            decoration: kTextFieldDecoration.copyWith(
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14.sp,
                              ),
                              hintText: 'Email',
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
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
                                  hintText: 'Password',
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
                            height: 6.h,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassword(
                                        loginType: widget.loginType ==
                                                LoginType.freelancer
                                            ? LoginType.freelancer
                                            : LoginType.company,
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Forgot Your Password?',
                                    style: kBasicText.copyWith(fontSize: 14))),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Consumer<AuthProvider>(builder: (
                            context,
                            provider,
                            child,
                          ) {
                            return MyButton(
                              buttonText: provider.isLoading ? '' : 'Sign in',
                              buttonColor: primaryColor,
                              buttonWidth: double.infinity,
                              buttonHeight: 40.h,
                              onTap: provider.isLoading
                                  ? null
                                  : () {
                                      FocusScope.of(context).unfocus();
                                      Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .setEmail(
                                              emailController.text.trim());
                                      provider.login(
                                          context,
                                          ipaddress,
                                          emailController.text,
                                          passwordController.text,
                                          widget.loginType ==
                                                  LoginType.freelancer
                                              ? 'freelancer'
                                              : 'company');
                                    },
                              child: provider.isLoading
                                  ? SizedBox(
                                      width: 22.w, // Adjust the size as needed
                                      height: 20.h, // Adjust the size as needed
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2
                                            .w, // Adjust the thickness of the indicator
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : null,
                            );
                          }),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomRichText(
                        text1: "Don't have an Account? ",
                        text2: 'Sign Up',
                        clickable: true,
                        currentScreen: widget.loginType == LoginType.freelancer
                            ? 'loginfreelancer'
                            : 'logincompany',
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
