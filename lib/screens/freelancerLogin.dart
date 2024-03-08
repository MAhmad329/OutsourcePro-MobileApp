import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/widgets/button.dart';
import 'package:outsourcepro/constants.dart';
import '../main.dart';
import '../widgets/customrichtext.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FreelancerLogin extends StatefulWidget {
  const FreelancerLogin({Key? key}) : super(key: key);

  @override
  State<FreelancerLogin> createState() => _FreelancerLoginState();
}

class _FreelancerLoginState extends State<FreelancerLogin> {
  bool _isObscure = false;
  String ipaddress = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<void> _login() async {
    ipaddress =
        Provider.of<IPAddressProvider>(context, listen: false).ipaddress;
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST', Uri.parse('http://$ipaddress:3000/api/v1/freelancer/login'));
    print('Request Payload: ${json.encode({
          "email": emailController.text,
          "password": passwordController.text
        })}');
    request.body = json.encode({
      "email": emailController.text,
      "password": passwordController.text,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Save the cookie to the provider
      Provider.of<AuthenticationProvider>(context, listen: false)
          .setCookie(response.headers['set-cookie']!);

      Navigator.pushReplacementNamed(context, 'homepage_freelancer_screen');
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);

      String errorMessage = 'Login failed.';

      try {
        Map<String, dynamic> errorResponse =
            json.decode(await response.stream.bytesToString());

        // Check for specific error messages
        if (errorResponse.containsKey('error')) {
          errorMessage = errorResponse['error'];
        } else if (errorResponse.containsKey('message')) {
          // Example: {"message": "Wrong password."}
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0.w),
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
                          "Welcome Back Freelancer!",
                          style: TextStyle(
                              fontSize: 36,
                              color: primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          "Sign Into Your Account Below",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  style: kBasicText)),
                        ),
                        SizedBox(
                          height: 33.h,
                        ),
                        MyButton(
                          buttonText: 'Sign in',
                          buttonColor: primaryColor,
                          buttonWidth: 350,
                          buttonHeight: 50,
                          onTap: () {
                            _login();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 125.h,
                    ),
                    const CustomRichText(
                      text1: "Don't have an Account? ",
                      text2: 'Sign Up',
                      clickable: true,
                      currentScreen: 'loginfreelancer',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
