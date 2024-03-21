import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:outsourcepro/providers/token_provider.dart';
import 'package:outsourcepro/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widgets/button.dart';
import '../widgets/custom_richtext.dart';

class CompanyRegistration extends StatefulWidget {
  const CompanyRegistration({Key? key}) : super(key: key);

  @override
  State<CompanyRegistration> createState() => _CompanyRegistrationState();
}

class _CompanyRegistrationState extends State<CompanyRegistration> {
  bool _isObscure = false;
  bool isLoading = false; // Add this line
  String ipaddress = '';
  TextEditingController companyNameController = TextEditingController();
  TextEditingController businessAddressController = TextEditingController();
  TextEditingController focalPersonNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _isNotValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$',
    );
    return !emailRegex.hasMatch(email);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<void> _register() async {
    setState(() {
      isLoading = true; // Set loading to true
    });
    ipaddress = Provider.of<TokenProvider>(context, listen: false).ipaddress;
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST', Uri.parse('http://$ipaddress:3000/api/v1/company/register'));
    request.body = json.encode({
      "companyname": companyNameController.text,
      "businessAddress": businessAddressController.text,
      "name": focalPersonNameController.text,
      "email": emailController.text,
      "password": passwordController.text
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    // Read the response stream into a variable
    String responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, 'company_login_screen');
      print(responseBody);
    } else {
      print(response.reasonPhrase);

      String errorMessage = 'Signup failed.';

      try {
        Map<String, dynamic> errorResponse = json.decode(responseBody);

        if (errorResponse.containsKey('error')) {
          errorMessage = errorResponse['error'];
        } else if (errorResponse.containsKey('message')) {
          errorMessage = errorResponse['message'];
        }
      } catch (e) {
        print(
          'Error parsing response body: $e',
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(errorMessage, Colors.red),
      );
    }
    setState(() {
      isLoading = false; // Set loading to false
    });
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome to OutsourcePro!",
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
                            "Create Your Company Account Below",
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            style: TextStyle(fontSize: 14.sp),
                            controller: companyNameController,
                            cursorColor: primaryColor,
                            decoration: kTextFieldDecoration.copyWith(
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins'),
                              hintText: 'Company Name',
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          TextField(
                            style: TextStyle(fontSize: 14.sp),
                            controller: businessAddressController,
                            cursorColor: primaryColor,
                            decoration: kTextFieldDecoration.copyWith(
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins'),
                              hintText: 'Business Address',
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          TextField(
                            style: TextStyle(fontSize: 14.sp),
                            controller: focalPersonNameController,
                            cursorColor: primaryColor,
                            decoration: kTextFieldDecoration.copyWith(
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins'),
                              hintText: 'Focal Person Name',
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
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
                              hintText: 'Focal Person Email',
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: 14.sp),
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
                            height: 12.h,
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: 14.sp),
                            controller: confirmPasswordController,
                            cursorColor: primaryColor,
                            obscureText: !_isObscure,
                            decoration: kTextFieldDecoration.copyWith(
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14.sp,
                              ),
                              hintText: 'Confirm Password',
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
                            height: 20.h,
                          ),
                          MyButton(
                            buttonText: isLoading ? '' : 'Sign Up',
                            buttonColor: primaryColor,
                            buttonWidth: double.infinity,
                            buttonHeight: 40.h,
                            onTap: isLoading
                                ? null
                                : () {
                                    if (_isNotValidEmail(
                                        emailController.text)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        customSnackBar(
                                            'Email is not valid!', Colors.red),
                                      );
                                    } else if (passwordController.text ==
                                            confirmPasswordController.text &&
                                        passwordController.text.isNotEmpty) {
                                      _register();
                                    } else if (passwordController.text !=
                                        confirmPasswordController.text) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        customSnackBar(
                                            'Passwords do not match!',
                                            Colors.red),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        customSnackBar(
                                            'Please fill all the fields!',
                                            Colors.red),
                                      );
                                    }
                                  },
                            child: isLoading
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.w,
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
                      const CustomRichText(
                        text1: "Already Have an Account? ",
                        text2: 'Sign In',
                        clickable: true,
                        currentScreen: 'signupcompany',
                      ),
                      SizedBox(
                        height: 20.h,
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
