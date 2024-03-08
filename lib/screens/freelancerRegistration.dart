import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../constants.dart';
import '../main.dart';
import '../widgets/button.dart';
import '../widgets/customrichtext.dart';

class FreelancerRegistration extends StatefulWidget {
  const FreelancerRegistration({Key? key}) : super(key: key);

  @override
  State<FreelancerRegistration> createState() => _FreelancerRegistrationState();
}

class _FreelancerRegistrationState extends State<FreelancerRegistration> {
  bool _isObscure = false;
  String ipaddress = '';
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
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
    ipaddress =
        Provider.of<IPAddressProvider>(context, listen: false).ipaddress;
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST', Uri.parse('http://$ipaddress:3000/api/v1/freelancer/register'));
    request.body = json.encode({
      "firstname": firstNameController.text,
      "lastname": lastNameController.text,
      "username": userNameController.text,
      "email": emailController.text,
      "password": passwordController.text
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${await response.stream.bytesToString()}');

    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, 'freelancer_login_screen');
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);

      String errorMessage = 'Signup failed.';

      try {
        Map<String, dynamic> errorResponse =
            json.decode(await response.stream.bytesToString());

        if (errorResponse.containsKey('error')) {
          errorMessage = errorResponse['error'];
        } else if (errorResponse.containsKey('message')) {
          errorMessage = errorResponse['message'];
        }
      } catch (e) {
        print('Error parsing response body: $e');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 3),
        ),
      );
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
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome to OutsourcePro!",
                            style: TextStyle(
                                fontSize: 36,
                                color: primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "Create Your Freelancer Account Below",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: firstNameController,
                            cursorColor: primaryColor,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'First Name',
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          TextField(
                            controller: lastNameController,
                            cursorColor: primaryColor,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Last Name',
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          TextField(
                            controller: userNameController,
                            cursorColor: primaryColor,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Username',
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          TextField(
                            controller: emailController,
                            cursorColor: primaryColor,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Email',
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          TextFormField(
                            controller: passwordController,
                            cursorColor: primaryColor,
                            obscureText: !_isObscure,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                splashColor: Colors.transparent,
                                color: Colors.grey.shade500,
                                icon: Icon(
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
                            controller: confirmPasswordController,
                            cursorColor: primaryColor,
                            obscureText: !_isObscure,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Confirm Password',
                              suffixIcon: IconButton(
                                splashColor: Colors.transparent,
                                color: Colors.grey.shade500,
                                icon: Icon(
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
                          SizedBox(
                            height: 15.h,
                          ),
                          MyButton(
                            buttonText: 'Sign Up',
                            buttonColor: primaryColor,
                            buttonWidth: 350,
                            buttonHeight: 50,
                            onTap: () {
                              if (_isNotValidEmail(emailController.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Email is not valid!'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else if (passwordController.text ==
                                      confirmPasswordController.text &&
                                  passwordController.text.isNotEmpty) {
                                _register();
                              } else if (passwordController.text !=
                                  confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Passwords do not match!'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please fill all the fields!'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35.h,
                      ),
                      const CustomRichText(
                        text1: "Already Have an Account? ",
                        text2: 'Sign In',
                        clickable: true,
                        currentScreen: 'signupfreelancer',
                      ),
                      SizedBox(
                        height: 35.h,
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
