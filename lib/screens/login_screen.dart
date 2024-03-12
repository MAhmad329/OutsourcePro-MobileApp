import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/widgets/button.dart';
import 'package:outsourcepro/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../widgets/custom_richtext.dart';

enum LoginType { freelancer, company }

class LoginScreen extends StatefulWidget {
  final LoginType loginType;
  const LoginScreen({Key? key, required this.loginType}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = false;
  bool isLoading = false;
  String ipaddress = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true; // Set loading to true
    });
    ipaddress =
        Provider.of<IPAddressProvider>(context, listen: false).ipaddress;
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST', Uri.parse('http://$ipaddress:3000/api/v1/freelancer/login'));
    request.body = json.encode({
      "email": emailController.text,
      "password": passwordController.text,
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Provider.of<AuthenticationProvider>(context, listen: false)
            .setCookie(response.headers['set-cookie']!);

        Navigator.pushReplacementNamed(context, 'homepage_freelancer_screen');
      } else {
        String errorMessage = 'Login failed.';
        Map<String, dynamic> errorResponse =
            json.decode(await response.stream.bytesToString());
        if (errorResponse.containsKey('error')) {
          errorMessage = errorResponse['error'];
        } else if (errorResponse.containsKey('message')) {
          errorMessage = errorResponse['message'];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            errorMessage,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          "Failed to sign in: ${e.toString()}",
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Set loading to false
      });
    }
  }

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
                                fontFamily: 'Poppins'),
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
                                fontFamily: 'Poppins'),
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
                            style: TextStyle(
                                fontFamily: 'Poppins', fontSize: 14.sp),
                            controller: emailController,
                            cursorColor: primaryColor,
                            decoration: kTextFieldDecoration.copyWith(
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins'),
                              hintText: 'Email',
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          TextFormField(
                            style: TextStyle(
                                fontFamily: 'Poppins', fontSize: 14.sp),
                            controller: passwordController,
                            cursorColor: primaryColor,
                            obscureText: !_isObscure,
                            decoration: kTextFieldDecoration.copyWith(
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins'),
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                splashColor: Colors.transparent,
                                color: Colors.grey.shade500,
                                icon: Icon(
                                  size: 20.r,
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, 'forget_password_screen');
                                },
                                child: Text('Forgot Your Password?',
                                    style:
                                        kBasicText.copyWith(fontSize: 14.sp))),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          MyButton(
                            buttonText: isLoading ? '' : 'Sign in',
                            buttonColor: primaryColor,
                            buttonWidth: double.infinity,
                            buttonHeight: 40.h,
                            onTap: isLoading ? null : _login,
                            child: isLoading
                                ? SizedBox(
                                    width: 22.w, // Adjust the size as needed
                                    height: 20.h, // Adjust the size as needed
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2
                                          .w, // Adjust the thickness of the indicator
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    ),
                                  )
                                : null,
                          ),
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